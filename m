Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 929247F5F
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 21:42:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7159F8F8033
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 19:42:40 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	HGe8CGChCfG8fEae for <xfs@oss.sgi.com>;
	Sun, 01 Nov 2015 19:42:38 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Zt60k-00014n-9D
	for xfs@oss.sgi.com; Mon, 02 Nov 2015 14:42:22 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1Zt60k-0000SQ-8P
	for xfs@oss.sgi.com; Mon, 02 Nov 2015 14:42:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/7] xfs: DAX does not use IO completion callbacks
Date: Mon,  2 Nov 2015 14:42:12 +1100
Message-Id: <1446435735-1526-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1446435735-1526-1-git-send-email-david@fromorbit.com>
References: <1446435735-1526-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

For DAX, we are now doing block zeroing during allocation. This
means we no longer need a special DAX fault IO completion callback
to do unwritten extent conversion. Because mmap never extends the
file size (it SEGVs the process) we don't need a callback to update
the file size, either. Hence we can remove the completion callbacks
from the __dax_fault and __dax_mkwrite calls.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_aops.c | 39 ---------------------------------------
 fs/xfs/xfs_aops.h |  1 -
 fs/xfs/xfs_file.c |  5 ++---
 3 files changed, 2 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 7b4f849..29e7e5d 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1666,45 +1666,6 @@ xfs_end_io_direct_write(
 	__xfs_end_io_direct_write(inode, ioend, offset, size);
 }
 
-/*
- * For DAX we need a mapping buffer callback for unwritten extent conversion
- * when page faults allocate blocks and then zero them. Note that in this
- * case the mapping indicated by the ioend may extend beyond EOF. We most
- * definitely do not want to extend EOF here, so we trim back the ioend size to
- * EOF.
- */
-#ifdef CONFIG_FS_DAX
-void
-xfs_end_io_dax_write(
-	struct buffer_head	*bh,
-	int			uptodate)
-{
-	struct xfs_ioend	*ioend = bh->b_private;
-	struct inode		*inode = ioend->io_inode;
-	ssize_t			size = ioend->io_size;
-
-	ASSERT(IS_DAX(ioend->io_inode));
-
-	/* if there was an error zeroing, then don't convert it */
-	if (!uptodate)
-		ioend->io_error = -EIO;
-
-	/*
-	 * Trim update to EOF, so we don't extend EOF during unwritten extent
-	 * conversion of partial EOF blocks.
-	 */
-	spin_lock(&XFS_I(inode)->i_flags_lock);
-	if (ioend->io_offset + size > i_size_read(inode))
-		size = i_size_read(inode) - ioend->io_offset;
-	spin_unlock(&XFS_I(inode)->i_flags_lock);
-
-	__xfs_end_io_direct_write(inode, ioend, ioend->io_offset, size);
-
-}
-#else
-void xfs_end_io_dax_write(struct buffer_head *bh, int uptodate) { }
-#endif
-
 static inline ssize_t
 xfs_vm_do_dio(
 	struct inode		*inode,
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index d39ba25..f6ffc9a 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -60,7 +60,6 @@ int	xfs_get_blocks_direct(struct inode *inode, sector_t offset,
 			      struct buffer_head *map_bh, int create);
 int	xfs_get_blocks_dax_fault(struct inode *inode, sector_t offset,
 			         struct buffer_head *map_bh, int create);
-void	xfs_end_io_dax_write(struct buffer_head *bh, int uptodate);
 
 extern void xfs_count_page_state(struct page *, int *, int *);
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7f873bc..403151a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1508,8 +1508,7 @@ xfs_filemap_page_mkwrite(
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 
 	if (IS_DAX(inode)) {
-		ret = __dax_mkwrite(vma, vmf, xfs_get_blocks_dax_fault,
-				    xfs_end_io_dax_write);
+		ret = __dax_mkwrite(vma, vmf, xfs_get_blocks_dax_fault, NULL);
 	} else {
 		ret = __block_page_mkwrite(vma, vmf, xfs_get_blocks);
 		ret = block_page_mkwrite_return(ret);
@@ -1571,7 +1570,7 @@ xfs_filemap_pmd_fault(
 	file_update_time(vma->vm_file);
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 	ret = __dax_pmd_fault(vma, addr, pmd, flags, xfs_get_blocks_dax_fault,
-				    xfs_end_io_dax_write);
+			      NULL);
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 	sb_end_pagefault(inode->i_sb);
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
