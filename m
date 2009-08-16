Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7G0kixV213677 for <xfs@oss.sgi.com>; Sat, 15 Aug 2009 19:47:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E7B714C03B3
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2009 17:47:10 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id sheySQVqleOK62fL for
	<xfs@oss.sgi.com>; Sat, 15 Aug 2009 17:47:10 -0700 (PDT)
Date: Sat, 15 Aug 2009 20:47:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH, RFC] xfs: batched discard support
Message-ID: <20090816004705.GA7347@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, liml@rtr.ca, jens.axboe@oracle.com


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Given that everyone is so big in the discard discussion I'd like to
present what I had started to prepare for XFS.  I didn't plan to send it
out until I get my hands onto a TRIM capable device (or at least get
time to add support to qemu), and so far it's only been tested in
dry-run mode.

The basic idea is to add an ioctl which walks the free space btrees in
each allocation group and simply discard everythin that is free.  Given
that XFS doesn't gragment freespace very much that's a very efficient
way to do it.  In addition we also already support setting a threshold
under which we don't bother to discard an extent, it's currently
hardcoded in the helper tool.  In the future we could also add things
like a sequence number in the AG headers if anything has changed at all,
but let's leave those optimizations until we need them.

XFS locks the allocation btree using the btree buffers, so we do not
block allocations from any extent which we're not currenly discarding.

Now the caveat for that is that we really do want to do the discard
synchronously, that is wait for the request to finish.  That's what
I've implemented in this patch, but it's the part I haven't been
able to test so far.  (and yes, this should be separate patch, but it's
really just an RFC for now)

Mark, any chance to try it?  Just create an XFS filesystem, age it a
bit and then call the attached little trim.c program on the mountmoint
(or any file inside the filesystem for that matter)


Index: linux-2.6/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2009-08-15 20:15:14.379163976 -0300
+++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl.c	2009-08-15 21:19:19.342664224 -0300
@@ -1275,6 +1275,31 @@ xfs_ioc_getbmapx(
 	return 0;
 }
 
+STATIC int
+xfs_ioc_trim(
+	struct xfs_mount	*mp,
+	__uint32_t		*argp)
+{
+	xfs_agnumber_t		agno;
+	int			error = 0;
+	__uint32_t		minlen;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (get_user(minlen, argp))
+		return -EFAULT;
+
+	down_read(&mp->m_peraglock);
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		error = -xfs_trim_extents(mp, agno, minlen);
+		if (error)
+			break;
+	}
+	up_read(&mp->m_peraglock);
+
+	return error;
+}
+
 /*
  * Note: some of the ioctl's return positive numbers as a
  * byte count indicating success, such as readlink_by_handle.
@@ -1524,6 +1549,9 @@ xfs_file_ioctl(
 		error = xfs_errortag_clearall(mp, 1);
 		return -error;
 
+	case XFS_IOC_TRIM:
+		return xfs_ioc_trim(mp, arg);
+
 	default:
 		return -ENOTTY;
 	}
Index: linux-2.6/fs/xfs/xfs_alloc.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_alloc.c	2009-08-15 20:11:00.791163409 -0300
+++ linux-2.6/fs/xfs/xfs_alloc.c	2009-08-15 21:40:16.226666638 -0300
@@ -2470,6 +2470,96 @@ error0:
 	return error;
 }
 
+STATIC int
+xfs_trim_extent(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		fbno,
+	xfs_extlen_t		flen)
+{
+	xfs_daddr_t		blkno = XFS_AGB_TO_DADDR(mp, agno, fbno);
+	sector_t		nblks = XFS_FSB_TO_BB(mp, flen);
+	int			error;
+
+	xfs_fs_cmn_err(CE_NOTE, mp, "discarding sectors [0x%llx-0x%llx]",
+			blkno, nblks);
+
+	error = -__blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
+				        blkno, nblks, GFP_NOFS, 1);
+	if (error && error != EOPNOTSUPP)
+		xfs_fs_cmn_err(CE_NOTE, mp, "discard failed, error %d", error);
+	return error;
+}
+
+/*
+ * Notify the underlying block device about our free extent map.
+ *
+ * This walks all free extents above a minimum threshold and notifies the
+ * underlying device that these blocks are unused.  That information is
+ * useful for SSDs or thinly provisioned storage in high end arrays or
+ * virtualization scenarios.
+ */
+int
+xfs_trim_extents(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_extlen_t		minlen)	/* minimum extent size to bother */
+{
+	struct xfs_btree_cur	*cur;	/* cursor for the by-block btree */
+	struct xfs_buf		*agbp;	/* AGF buffer pointer */
+	xfs_agblock_t		bno;	/* block the for next search */
+	xfs_agblock_t		fbno;	/* start block of found extent */
+	xfs_extlen_t		flen;	/* length of found extent */
+	int			error;
+	int			i;
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error)
+		return error;
+
+	bno = 0;
+	for (;;) {
+		cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno,
+					      XFS_BTNUM_BNO);
+
+		error = xfs_alloc_lookup_ge(cur, bno, minlen, &i);
+		if (error)
+			goto error0;
+		if (!i) {
+			/*
+			 * No more free extents found: done.
+			 */
+			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+			break;
+		}
+
+		error = xfs_alloc_get_rec(cur, &fbno, &flen, &i);
+		if (error)
+			goto error0;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+		/*
+		 * Pass if the freespace extent isn't long enough to bother.
+		 */
+		if (flen >= minlen) {
+			error = xfs_trim_extent(mp, agno, fbno, flen);
+			if (error) {
+				xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+				break;
+			}
+		}
+
+		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		bno = fbno + flen;
+	}
+
+out:
+	xfs_buf_relse(agbp);
+	return error;
+error0:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	goto out;
+}
 
 /*
  * AG Busy list management
Index: linux-2.6/fs/xfs/xfs_alloc.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_alloc.h	2009-08-15 20:12:51.762661386 -0300
+++ linux-2.6/fs/xfs/xfs_alloc.h	2009-08-15 20:15:07.334667592 -0300
@@ -217,4 +217,7 @@ xfs_free_extent(
 	xfs_fsblock_t	bno,	/* starting block number of extent */
 	xfs_extlen_t	len);	/* length of extent */
 
+int xfs_trim_extents(struct xfs_mount *mp, xfs_agnumber_t agno,
+	xfs_extlen_t minlen);
+
 #endif	/* __XFS_ALLOC_H__ */
Index: linux-2.6/fs/xfs/xfs_fs.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_fs.h	2009-08-15 20:22:03.735200427 -0300
+++ linux-2.6/fs/xfs/xfs_fs.h	2009-08-15 20:24:18.677996430 -0300
@@ -475,6 +475,7 @@ typedef struct xfs_handle {
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
+#define XFS_IOC_TRIM		     _IOR ('X', 126, __uint32_t)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
Index: linux-2.6/block/blk-barrier.c
===================================================================
--- linux-2.6.orig/block/blk-barrier.c	2009-08-15 21:36:30.426696824 -0300
+++ linux-2.6/block/blk-barrier.c	2009-08-15 21:41:11.490664659 -0300
@@ -348,22 +348,27 @@ static void blkdev_discard_end_io(struct
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	}
 
+	if (bio->bi_private)
+		complete(bio->bi_private);
 	bio_put(bio);
 }
 
 /**
- * blkdev_issue_discard - queue a discard
+ * __blkdev_issue_discard - queue a discard
  * @bdev:	blockdev to issue discard for
  * @sector:	start sector
  * @nr_sects:	number of sectors to discard
  * @gfp_mask:	memory allocation flags (for bio_alloc)
+ * @wait:	if %1 wait for the discard to finish
  *
  * Description:
- *    Issue a discard request for the sectors in question. Does not wait.
+ *    Issue a discard request for the sectors in question.
  */
-int blkdev_issue_discard(struct block_device *bdev,
-			 sector_t sector, sector_t nr_sects, gfp_t gfp_mask)
+int __blkdev_issue_discard(struct block_device *bdev,
+			 sector_t sector, sector_t nr_sects, gfp_t gfp_mask,
+			 int wait)
 {
+	DECLARE_COMPLETION_ONSTACK(done);
 	struct request_queue *q;
 	struct bio *bio;
 	int ret = 0;
@@ -385,6 +390,7 @@ int blkdev_issue_discard(struct block_de
 
 		bio->bi_end_io = blkdev_discard_end_io;
 		bio->bi_bdev = bdev;
+		bio->bi_private = wait ? &done : NULL;
 
 		bio->bi_sector = sector;
 
@@ -399,6 +405,9 @@ int blkdev_issue_discard(struct block_de
 		bio_get(bio);
 		submit_bio(DISCARD_BARRIER, bio);
 
+		if (wait)
+			wait_for_completion(&done);
+
 		/* Check if it failed immediately */
 		if (bio_flagged(bio, BIO_EOPNOTSUPP))
 			ret = -EOPNOTSUPP;
@@ -408,4 +417,4 @@ int blkdev_issue_discard(struct block_de
 	}
 	return ret;
 }
-EXPORT_SYMBOL(blkdev_issue_discard);
+EXPORT_SYMBOL(__blkdev_issue_discard);
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2009-08-15 21:40:20.507164178 -0300
+++ linux-2.6/include/linux/blkdev.h	2009-08-15 21:42:15.734715355 -0300
@@ -977,8 +977,14 @@ static inline struct request *blk_map_qu
 }
 
 extern int blkdev_issue_flush(struct block_device *, sector_t *);
-extern int blkdev_issue_discard(struct block_device *,
-				sector_t sector, sector_t nr_sects, gfp_t);
+extern int __blkdev_issue_discard(struct block_device *, sector_t sector,
+		sector_t nr_sects, gfp_t, int wait);
+
+static inline int blkdev_issue_discard(struct block_device *bdev,
+		sector_t sector, sector_t nr_sects, gfp_t gfp_mask)
+{
+	return __blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, 0);
+}
 
 static inline int sb_issue_discard(struct super_block *sb,
 				   sector_t block, sector_t nr_blocks)

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="trim.c"


#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdint.h>
#include <sys/ioctl.h>

#define XFS_IOC_TRIM                 _IOR ('X', 126, uint32_t)


int main(int argc, char **argv)
{
	int minsize = 4096;
	int fd;

	if (argc != 2) {
		fprintf(stderr, "usage: %s mountpoint\n", argv[0]);
		return 1;
	}

	fd = open(argv[1], O_RDONLY);
	if (fd < 0) {
		perror("open");
		return 1;
	}

	if (ioctl(fd, XFS_IOC_TRIM, &minsize)) {
		if (errno == EOPNOTSUPP)
			fprintf(stderr, "TRIM not supported\n");
		else
			perror("XFS_IOC_TRIM");
		return 1;
	}

	return 0;
}

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--0OAP2g/MAC+5xKAE--
