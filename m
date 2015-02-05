Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3E1EE7FC0
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 07:58:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B02F5AC001
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 05:58:00 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id 0SVEXQRu7mlpacL5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 05:57:58 -0800 (PST)
Date: Thu, 5 Feb 2015 14:57:56 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 19/20] xfs: implement pNFS export operations
Message-ID: <20150205135756.GA6386@lst.de>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
	<1421925006-24231-20-git-send-email-hch@lst.de>
	<20150205004758.GO4251@dastard> <20150205070858.GA593@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150205070858.GA593@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@primarydata.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

I've updated the patch and pushed out a new pnfsd-for-3.20-4 branch.

The changes relative to the old one are below:

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 99465ba..48561a0 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -602,8 +602,12 @@ xfs_growfs_data(
 	if (!mutex_trylock(&mp->m_growlock))
 		return -EWOULDBLOCK;
 	error = xfs_growfs_data_private(mp, in);
-	if (!error)
-		mp->m_generation++;
+	/*
+	 * Increment the generation unconditionally, the error could be from
+	 * updating the secondary superblocks, in which case the new size
+	 * is live already.
+	 */
+	mp->m_generation++;
 	mutex_unlock(&mp->m_growlock);
 	return error;
 }
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index ab5ee78..7440b40 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -15,6 +15,7 @@
 #include "xfs_error.h"
 #include "xfs_iomap.h"
 #include "xfs_shared.h"
+#include "xfs_bit.h"
 #include "xfs_pnfs.h"
 
 /*
@@ -48,6 +49,10 @@ xfs_break_layouts(
 	return error;
 }
 
+/*
+ * Get a uniqueue ID including its location so that the client can identify
+ * the exported device.
+ */
 int
 xfs_fs_get_uuid(
 	struct super_block	*sb,
@@ -57,6 +62,10 @@ xfs_fs_get_uuid(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
+	printk_once(KERN_NOTICE
+"XFS (%s): using experimental pNFS feature, use at your own risk!\n",
+		mp->m_fsname);
+
 	if (*len < sizeof(uuid_t))
 		return -EINVAL;
 
@@ -75,13 +84,14 @@ xfs_bmbt_to_iomap(
 	struct xfs_mount	*mp = ip->i_mount;
 
 	if (imap->br_startblock == HOLESTARTBLOCK) {
-		iomap->blkno = -1;
+		iomap->blkno = IOMAP_NULL_BLOCK;
 		iomap->type = IOMAP_HOLE;
 	} else if (imap->br_startblock == DELAYSTARTBLOCK) {
-		iomap->blkno = -1;
+		iomap->blkno = IOMAP_NULL_BLOCK;
 		iomap->type = IOMAP_DELALLOC;
 	} else {
-		iomap->blkno = xfs_fsb_to_db(ip, imap->br_startblock);
+		iomap->blkno =
+			XFS_FSB_TO_DADDR(ip->i_mount, imap->br_startblock);
 		if (imap->br_state == XFS_EXT_UNWRITTEN)
 			iomap->type = IOMAP_UNWRITTEN;
 		else
@@ -115,6 +125,12 @@ xfs_fs_map_blocks(
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
+
+	/*
+	 * We can't export inodes residing on the realtime device.  The realtime
+	 * device doesn't have a UUID to identify it, so the client has no way
+	 * to find it.
+	 */
 	if (XFS_IS_REALTIME_INODE(ip))
 		return -ENXIO;
 
@@ -190,6 +206,32 @@ out_unlock:
 }
 
 /*
+ * Ensure the size update falls into a valid allocated block.
+ */
+static int
+xfs_pnfs_validate_isize(
+	struct xfs_inode	*ip,
+	xfs_off_t		isize)
+{
+	struct xfs_bmbt_irec	imap;
+	int			nimaps = 1;
+	int			error = 0;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	error = xfs_bmapi_read(ip, XFS_B_TO_FSBT(ip->i_mount, isize - 1), 1,
+				&imap, &nimaps, 0);
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	if (error)
+		return error;
+
+	if (imap.br_startblock == HOLESTARTBLOCK ||
+	    imap.br_startblock == DELAYSTARTBLOCK ||
+	    imap.br_state == XFS_EXT_UNWRITTEN)
+		return -EIO;
+	return 0;
+}
+
+/*
  * Make sure the blocks described by maps are stable on disk.  This includes
  * converting any unwritten extents, flushing the disk cache and updating the
  * time stamps.
@@ -209,6 +251,7 @@ xfs_fs_commit_blocks(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
+	bool			update_isize = false;
 	int			error, i;
 	loff_t			size;
 
@@ -217,8 +260,10 @@ xfs_fs_commit_blocks(
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 
 	size = i_size_read(inode);
-	if ((iattr->ia_valid & ATTR_SIZE) && iattr->ia_size > size)
+	if ((iattr->ia_valid & ATTR_SIZE) && iattr->ia_size > size) {
+		update_isize = true;
 		size = iattr->ia_size;
+	}
 
 	for (i = 0; i < nr_maps; i++) {
 		u64 start, length, end;
@@ -248,6 +293,12 @@ xfs_fs_commit_blocks(
 			goto out_drop_iolock;
 	}
 
+	if (update_isize) {
+		error = xfs_pnfs_validate_isize(ip, size);
+		if (error)
+			goto out_drop_iolock;
+	}
+
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
 	if (error)
@@ -258,11 +309,9 @@ xfs_fs_commit_blocks(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	xfs_setattr_time(ip, iattr);
-	if (iattr->ia_valid & ATTR_SIZE) {
-		if (iattr->ia_size > i_size_read(inode)) {
-			i_size_write(inode, iattr->ia_size);
-			ip->i_d.di_size = iattr->ia_size;
-		}
+	if (update_isize) {
+		i_size_write(inode, iattr->ia_size);
+		ip->i_d.di_size = iattr->ia_size;
 	}
 
 	xfs_trans_set_sync(tp);
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index ff46bf7..fa05e04 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -187,6 +187,8 @@ struct fid {
 #define IOMAP_MAPPED	0x03	/* blocks allocated @blkno */
 #define IOMAP_UNWRITTEN	0x04	/* blocks allocated @blkno in unwritten state */
 
+#define IOMAP_NULL_BLOCK -1LL	/* blkno is not valid */
+
 struct iomap {
 	sector_t	blkno;	/* first sector of mapping */
 	loff_t		offset;	/* file offset of mapping, bytes */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
