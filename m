Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o94ADE1s057243 for <xfs@oss.sgi.com>; Mon, 4 Oct 2010 05:13:14 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B572E18A4C51
	for <xfs@oss.sgi.com>; Mon,  4 Oct 2010 03:14:15 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	o9rhiYNqPVS8PGoI for <xfs@oss.sgi.com>;
	Mon, 04 Oct 2010 03:14:15 -0700 (PDT)
Received: from dastard (unverified [121.44.66.70])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	41540387-1927428
	for <xfs@oss.sgi.com>; Mon, 04 Oct 2010 20:44:14 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1P2i3g-0005OJ-JZ
	for xfs@oss.sgi.com; Mon, 04 Oct 2010 21:14:12 +1100
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1P2i3T-0004M6-8x
	for xfs@oss.sgi.com; Mon, 04 Oct 2010 21:13:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: dynamic speculative EOF preallocation
Date: Mon,  4 Oct 2010 21:13:55 +1100
Message-Id: <1286187236-16682-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1286187236-16682-1-git-send-email-david@fromorbit.com>
References: <1286187236-16682-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Currently the size of the speculative preallocation during delayed
allocation is fixed by either the allocsize mount option of a
default size. We are seeing a lot of cases where we need to
recommend using the allocsize mount option to prevent fragmentation
when buffered writes land in the same AG.

Rather than using a fixed preallocation size by default (up to 64k),
make it dynamic by exponentially increasing it on each subsequent
preallocation. This will result in the preallocation size increasing
as the file increases, so for streaming writes we are much more
likely to get large preallocations exactly when we need it to reduce
fragementation. It should also prevent the need for using the
allocsize mount option for most workloads involving concurrent
streaming writes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.h |    1 +
 fs/xfs/xfs_iomap.c |   39 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 39f8c78..1594190 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -248,6 +248,7 @@ typedef struct xfs_inode {
 	mrlock_t		i_iolock;	/* inode IO lock */
 	struct completion	i_flush;	/* inode flush completion q */
 	atomic_t		i_pincount;	/* inode pin count */
+	unsigned int		i_last_prealloc; /* last EOF prealloc size */
 	wait_queue_head_t	i_ipin_wait;	/* inode pinning wait queue */
 	spinlock_t		i_flags_lock;	/* inode i_flags lock */
 	/* Miscellaneous state. */
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 2057614..b2e4782 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -389,6 +389,9 @@ error_out:
  * If the caller is doing a write at the end of the file, then extend the
  * allocation out to the file system's write iosize.  We clean up any extra
  * space left over when the file is closed in xfs_inactive().
+ *
+ * If we find we already have delalloc preallocation out to alloc_blocks
+ * beyond EOF, don't do more preallocation as it it not needed.
  */
 STATIC int
 xfs_iomap_eof_want_preallocate(
@@ -405,6 +408,7 @@ xfs_iomap_eof_want_preallocate(
 	xfs_filblks_t   count_fsb;
 	xfs_fsblock_t	firstblock;
 	int		n, error, imaps;
+	int		found_delalloc = 0;
 
 	*prealloc = 0;
 	if ((offset + count) <= ip->i_size)
@@ -427,11 +431,25 @@ xfs_iomap_eof_want_preallocate(
 			if ((imap[n].br_startblock != HOLESTARTBLOCK) &&
 			    (imap[n].br_startblock != DELAYSTARTBLOCK))
 				return 0;
+
 			start_fsb += imap[n].br_blockcount;
 			count_fsb -= imap[n].br_blockcount;
+
+			/* count delalloc blocks beyond EOF */
+			if (imap[n].br_startblock == DELAYSTARTBLOCK)
+				found_delalloc += imap[n].br_blockcount;
 		}
 	}
-	*prealloc = 1;
+	if (!found_delalloc) {
+		/* haven't got any prealloc, so need some */
+		*prealloc = 1;
+	} else if (found_delalloc <= count_fsb) {
+		/* almost run out of prealloc */
+		*prealloc = 1;
+	} else {
+		/* still lots of prealloc left */
+		*prealloc = 0;
+	}
 	return 0;
 }
 
@@ -469,6 +487,7 @@ xfs_iomap_write_delay(
 	extsz = xfs_get_extsz_hint(ip);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 
+
 	error = xfs_iomap_eof_want_preallocate(mp, ip, offset, count,
 				ioflag, imap, XFS_WRITE_IMAPS, &prealloc);
 	if (error)
@@ -476,9 +495,25 @@ xfs_iomap_write_delay(
 
 retry:
 	if (prealloc) {
+		xfs_fileoff_t	alloc_blocks = 0;
+		/*
+		 * If we don't have a user specified preallocation size, dynamically
+		 * increase the preallocation size as we do more preallocation.
+		 * Cap the maximum size at a single extent.
+		 */
+		if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)) {
+			alloc_blocks = XFS_FILEOFF_MIN(MAXEXTLEN,
+						(ip->i_last_prealloc * 4));
+		}
+		if (alloc_blocks == 0)
+			alloc_blocks = mp->m_writeio_blocks;
+		ip->i_last_prealloc = alloc_blocks;
+
 		aligned_offset = XFS_WRITEIO_ALIGN(mp, (offset + count - 1));
 		ioalign = XFS_B_TO_FSBT(mp, aligned_offset);
-		last_fsb = ioalign + mp->m_writeio_blocks;
+		last_fsb = ioalign + alloc_blocks;
+		printk("ino %lld, ioalign 0x%llx, alloc_blocks 0x%llx\n",
+				ip->i_ino, ioalign, alloc_blocks);
 	} else {
 		last_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)(offset + count)));
 	}
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
