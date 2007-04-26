Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Apr 2007 16:43:12 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3QNh7fB030577
	for <xfs@oss.sgi.com>; Thu, 26 Apr 2007 16:43:09 -0700
Subject: Re: [PATCH] make growfs check device size limits too
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20070426071055.GA24411@infradead.org>
References: <1177569014.6273.367.camel@edge>
	 <20070426071055.GA24411@infradead.org>
Content-Type: multipart/mixed; boundary="=-KqqObupthjG8eQxoXnzv"
Date: Fri, 27 Apr 2007 09:45:20 +1000
Message-Id: <1177631120.6273.380.camel@edge>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

--=-KqqObupthjG8eQxoXnzv
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2007-04-26 at 08:10 +0100, Christoph Hellwig wrote:
> On Thu, Apr 26, 2007 at 04:30:14PM +1000, Nathan Scott wrote:
> > On the mount path we check for a superblock that describes a filesystem
> > to large for the running kernel to handle.  This catches the case of an
> > attempt to mount a >16TB filesystem on i386 (where we are limited by the
> > page->index size, for XFS metadata buffers in xfs_buf.c).
> > 
> > This patch makes similar checks on the growfs code paths for regular and
> > realtime growth, else we can end up with filesystem corruption, it would
> > seem (from #xfs chatter).  Untested patch follows; probably better to do
> > this as a macro, in a header, and call that in each place...?
> 
> Yeah, the check should probably we in one place only.  Given that's it's
> only used in slow pathes a function would probably do it.

Here's a revised version...

cheers.

-- 
Nathan

--=-KqqObupthjG8eQxoXnzv
Content-Disposition: attachment; filename=fix-sb-size-checks
Content-Type: text/x-patch; name=fix-sb-size-checks; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: linux/fs/xfs/xfs_fsops.c
===================================================================
--- linux.orig/fs/xfs/xfs_fsops.c	2007-04-27 09:00:57.306146750 +1000
+++ linux/fs/xfs/xfs_fsops.c	2007-04-27 09:41:22.897736750 +1000
@@ -140,6 +140,8 @@ xfs_growfs_data_private(
 	pct = in->imaxpct;
 	if (nb < mp->m_sb.sb_dblocks || pct < 0 || pct > 100)
 		return XFS_ERROR(EINVAL);
+	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
+		return error;
 	dpct = pct - mp->m_sb.sb_imax_pct;
 	error = xfs_read_buf(mp, mp->m_ddev_targp,
 			XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
Index: linux/fs/xfs/xfs_rtalloc.c
===================================================================
--- linux.orig/fs/xfs/xfs_rtalloc.c	2007-04-27 09:16:57.558158750 +1000
+++ linux/fs/xfs/xfs_rtalloc.c	2007-04-27 09:38:03.705288000 +1000
@@ -1882,11 +1882,13 @@ xfs_growfs_rt(
 	    (nrblocks = in->newblocks) <= sbp->sb_rblocks ||
 	    (sbp->sb_rblocks && (in->extsize != sbp->sb_rextsize)))
 		return XFS_ERROR(EINVAL);
+	if ((error = xfs_sb_validate_fsb_count(sbp, nrblocks)))
+		return error;
 	/*
 	 * Read in the last block of the device, make sure it exists.
 	 */
 	error = xfs_read_buf(mp, mp->m_rtdev_targp,
-			XFS_FSB_TO_BB(mp, in->newblocks - 1),
+			XFS_FSB_TO_BB(mp, nrblocks - 1),
 			XFS_FSB_TO_BB(mp, 1), 0, &bp);
 	if (error)
 		return error;
Index: linux/fs/xfs/xfs_mount.c
===================================================================
--- linux.orig/fs/xfs/xfs_mount.c	2007-04-27 09:00:57.354149750 +1000
+++ linux/fs/xfs/xfs_mount.c	2007-04-27 09:42:07.700536750 +1000
@@ -202,6 +202,27 @@ xfs_mount_free(
 	kmem_free(mp, sizeof(xfs_mount_t));
 }
 
+/*
+ * Check size of device based on the (data/realtime) block count.
+ * Note: this check is used by the growfs code as well as mount.
+ */
+int
+xfs_sb_validate_fsb_count(
+	xfs_sb_t	*sbp,
+	__uint64_t	nblocks)
+{
+	ASSERT(PAGE_SHIFT >= sbp->sb_blocklog);
+	ASSERT(sbp->sb_blocklog >= BBSHIFT);
+
+#if XFS_BIG_BLKNOS     /* Limited by ULONG_MAX of page cache index */
+	if (nblocks >> (PAGE_CACHE_SHIFT - sbp->sb_blocklog) > ULONG_MAX)
+		return E2BIG;
+#else                  /* Limited by UINT_MAX of sectors */
+	if (nblocks << (sbp->sb_blocklog - BBSHIFT) > UINT_MAX)
+		return E2BIG;
+#endif
+	return 0;
+}
 
 /*
  * Check the validity of the SB found.
@@ -284,18 +305,8 @@ xfs_mount_validate_sb(
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 
-	ASSERT(PAGE_SHIFT >= sbp->sb_blocklog);
-	ASSERT(sbp->sb_blocklog >= BBSHIFT);
-
-#if XFS_BIG_BLKNOS     /* Limited by ULONG_MAX of page cache index */
-	if (unlikely(
-	    (sbp->sb_dblocks >> (PAGE_SHIFT - sbp->sb_blocklog)) > ULONG_MAX ||
-	    (sbp->sb_rblocks >> (PAGE_SHIFT - sbp->sb_blocklog)) > ULONG_MAX)) {
-#else                  /* Limited by UINT_MAX of sectors */
-	if (unlikely(
-	    (sbp->sb_dblocks << (sbp->sb_blocklog - BBSHIFT)) > UINT_MAX ||
-	    (sbp->sb_rblocks << (sbp->sb_blocklog - BBSHIFT)) > UINT_MAX)) {
-#endif
+	if (xfs_sb_validate_fsb_count(sbp, sbp->sb_dblocks) ||
+	    xfs_sb_validate_fsb_count(sbp, sbp->sb_rblocks)) {
 		xfs_fs_mount_cmn_err(flags,
 			"file system too large to be mounted on this system.");
 		return XFS_ERROR(E2BIG);
Index: linux/fs/xfs/xfs_mount.h
===================================================================
--- linux.orig/fs/xfs/xfs_mount.h	2007-04-27 09:25:44.667101000 +1000
+++ linux/fs/xfs/xfs_mount.h	2007-04-27 09:37:43.448022000 +1000
@@ -624,6 +624,7 @@ extern int	xfs_sync_inodes(xfs_mount_t *
 extern xfs_agnumber_t	xfs_initialize_perag(struct bhv_vfs *, xfs_mount_t *,
 						xfs_agnumber_t);
 extern void	xfs_xlatesb(void *, struct xfs_sb *, int, __int64_t);
+extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, __uint64_t);
 
 extern struct xfs_dmops xfs_dmcore_stub;
 extern struct xfs_qmops xfs_qmcore_stub;

--=-KqqObupthjG8eQxoXnzv--
