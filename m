Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 04 Nov 2007 17:45:49 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA51jb0s013123
	for <xfs@oss.sgi.com>; Sun, 4 Nov 2007 17:45:41 -0800
Date: Mon, 5 Nov 2007 12:45:10 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: writeout stalls in current -git
Message-ID: <20071105014510.GU66820511@sgi.com>
References: <393060478.03650@ustc.edu.cn> <64bb37e0710310822r5ca6b793p8fd97db2f72a8655@mail.gmail.com> <393903856.06449@ustc.edu.cn> <64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com> <64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com> <E1InmAI-0003ME-2i@localhost> <1193998532.27652.343.camel@twins> <64bb37e0711021222q7d12c825mc62d433c4fe19e8@mail.gmail.com> <20071102204258.GR995458@sgi.com> <64bb37e0711040319l5de285c3xea64474540a51b6e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="7ZAtKRhVyVSsbBD2"
Content-Disposition: inline
In-Reply-To: <64bb37e0711040319l5de285c3xea64474540a51b6e@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: David Chinner <dgc@sgi.com>, Peter Zijlstra <peterz@infradead.org>, Fengguang Wu <wfg@mail.ustc.edu.cn>, Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 04, 2007 at 12:19:19PM +0100, Torsten Kaiser wrote:
> On 11/2/07, David Chinner <dgc@sgi.com> wrote:
> > That's stalled waiting on the inode cluster buffer lock. That implies
> > that the inode lcuser is already being written out and the inode has
> > been redirtied during writeout.
> >
> > Does the kernel you are testing have the "flush inodes in ascending
> > inode number order" patches applied? If so, can you remove that
> > patch and see if the problem goes away?
> 
> I can now confirm, that I see this also with the current mainline-git-version
> I used 2.6.24-rc1-git-b4f555081fdd27d13e6ff39d455d5aefae9d2c0c
> plus the fix for the sg changes in ieee1394.

Ok, so it's probably a side effect of the writeback changes.

Attached are two patches (two because one was in a separate patchset as
a standalone change) that should prevent async writeback from blocking
on locked inode cluster buffers. Apply the xfs-factor-inotobp patch first.
Can you see if this fixes the problem?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group



--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=xfs-factor-inotobp

---
 fs/xfs/xfs_inode.c |  283 ++++++++++++++++++++++++-----------------------------
 1 file changed, 129 insertions(+), 154 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2007-09-12 15:41:22.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2007-09-13 08:57:06.395641940 +1000
@@ -124,6 +124,126 @@ xfs_inobp_check(
 #endif
 
 /*
+ * Simple wrapper for calling xfs_imap() that includes error
+ * and bounds checking
+ */
+STATIC int
+xfs_ino_to_imap(
+	xfs_mount_t	*mp,
+	xfs_trans_t	*tp,
+	xfs_ino_t	ino,
+	xfs_imap_t	*imap,
+	uint		imap_flags)
+{
+	int		error;
+
+	error = xfs_imap(mp, tp, ino, imap, imap_flags);
+	if (error) {
+		cmn_err(CE_WARN, "xfs_ino_to_imap: xfs_imap()  returned an "
+				"error %d on %s.  Returning error.",
+				error, mp->m_fsname);
+		return error;
+	}
+
+	/*
+	 * If the inode number maps to a block outside the bounds
+	 * of the file system then return NULL rather than calling
+	 * read_buf and panicing when we get an error from the
+	 * driver.
+	 */
+	if ((imap->im_blkno + imap->im_len) >
+	    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
+		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_ino_to_imap: "
+			"(imap->im_blkno (0x%llx) + imap->im_len (0x%llx)) > "
+			" XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) (0x%llx)",
+			(unsigned long long) imap->im_blkno,
+			(unsigned long long) imap->im_len,
+			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
+		return XFS_ERROR(EINVAL);
+	}
+	return 0;
+}
+
+/*
+ * Find the buffer associated with the given inode map
+ * We do basic validation checks on the buffer once it has been
+ * retrieved from disk.
+ */
+STATIC int
+xfs_imap_to_bp(
+	xfs_mount_t	*mp,
+	xfs_trans_t	*tp,
+	xfs_imap_t	*imap,
+	xfs_buf_t	**bpp,
+	uint		buf_flags,
+	uint		imap_flags)
+{
+	int		error;
+	int		i;
+	int		ni;
+	xfs_buf_t	*bp;
+
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
+				   (int)imap->im_len, XFS_BUF_LOCK, &bp);
+	if (error) {
+		cmn_err(CE_WARN, "xfs_imap_to_bp: xfs_trans_read_buf()returned "
+				"an error %d on %s.  Returning error.",
+				error, mp->m_fsname);
+		return error;
+	}
+
+	/*
+	 * Validate the magic number and version of every inode in the buffer
+	 * (if DEBUG kernel) or the first inode in the buffer, otherwise.
+	 */
+#ifdef DEBUG
+	ni = BBTOB(imap->im_len) >> mp->m_sb.sb_inodelog;
+#else	/* usual case */
+	ni = 1;
+#endif
+
+	for (i = 0; i < ni; i++) {
+		int		di_ok;
+		xfs_dinode_t	*dip;
+
+		dip = (xfs_dinode_t *)xfs_buf_offset(bp,
+					(i << mp->m_sb.sb_inodelog));
+		di_ok = be16_to_cpu(dip->di_core.di_magic) == XFS_DINODE_MAGIC &&
+			    XFS_DINODE_GOOD_VERSION(dip->di_core.di_version);
+		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
+						XFS_ERRTAG_ITOBP_INOTOBP,
+						XFS_RANDOM_ITOBP_INOTOBP))) {
+			if (imap_flags & XFS_IMAP_BULKSTAT) {
+				xfs_trans_brelse(tp, bp);
+				return XFS_ERROR(EINVAL);
+			}
+			XFS_CORRUPTION_ERROR("xfs_imap_to_bp",
+						XFS_ERRLEVEL_HIGH, mp, dip);
+#ifdef DEBUG
+			cmn_err(CE_PANIC,
+					"Device %s - bad inode magic/vsn "
+					"daddr %lld #%d (magic=%x)",
+				XFS_BUFTARG_NAME(mp->m_ddev_targp),
+				(unsigned long long)imap->im_blkno, i,
+				be16_to_cpu(dip->di_core.di_magic));
+#endif
+			xfs_trans_brelse(tp, bp);
+			return XFS_ERROR(EFSCORRUPTED);
+		}
+	}
+
+	xfs_inobp_check(mp, bp);
+
+	/*
+	 * Mark the buffer as an inode buffer now that it looks good
+	 */
+	XFS_BUF_SET_VTYPE(bp, B_FS_INO);
+
+	*bpp = bp;
+	return 0;
+}
+
+/*
  * This routine is called to map an inode number within a file
  * system to the buffer containing the on-disk version of the
  * inode.  It returns a pointer to the buffer containing the
@@ -145,72 +265,19 @@ xfs_inotobp(
 	xfs_buf_t	**bpp,
 	int		*offset)
 {
-	int		di_ok;
 	xfs_imap_t	imap;
 	xfs_buf_t	*bp;
 	int		error;
-	xfs_dinode_t	*dip;
 
-	/*
-	 * Call the space management code to find the location of the
-	 * inode on disk.
-	 */
 	imap.im_blkno = 0;
-	error = xfs_imap(mp, tp, ino, &imap, XFS_IMAP_LOOKUP);
-	if (error != 0) {
-		cmn_err(CE_WARN,
-	"xfs_inotobp: xfs_imap()  returned an "
-	"error %d on %s.  Returning error.", error, mp->m_fsname);
+	error = xfs_ino_to_imap(mp, tp, ino, &imap, XFS_IMAP_LOOKUP);
+	if (error)
 		return error;
-	}
-
-	/*
-	 * If the inode number maps to a block outside the bounds of the
-	 * file system then return NULL rather than calling read_buf
-	 * and panicing when we get an error from the driver.
-	 */
-	if ((imap.im_blkno + imap.im_len) >
-	    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
-		cmn_err(CE_WARN,
-	"xfs_inotobp: inode number (%llu + %d) maps to a block outside the bounds "
-	"of the file system %s.  Returning EINVAL.",
-			(unsigned long long)imap.im_blkno,
-			imap.im_len, mp->m_fsname);
-		return XFS_ERROR(EINVAL);
-	}
-
-	/*
-	 * Read in the buffer.  If tp is NULL, xfs_trans_read_buf() will
-	 * default to just a read_buf() call.
-	 */
-	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap.im_blkno,
-				   (int)imap.im_len, XFS_BUF_LOCK, &bp);
 
-	if (error) {
-		cmn_err(CE_WARN,
-	"xfs_inotobp: xfs_trans_read_buf()  returned an "
-	"error %d on %s.  Returning error.", error, mp->m_fsname);
+	error = xfs_imap_to_bp(mp, tp, &imap, &bp, XFS_BUF_LOCK, 0);
+	if (error)
 		return error;
-	}
-	dip = (xfs_dinode_t *)xfs_buf_offset(bp, 0);
-	di_ok =
-		be16_to_cpu(dip->di_core.di_magic) == XFS_DINODE_MAGIC &&
-		XFS_DINODE_GOOD_VERSION(dip->di_core.di_version);
-	if (unlikely(XFS_TEST_ERROR(!di_ok, mp, XFS_ERRTAG_ITOBP_INOTOBP,
-			XFS_RANDOM_ITOBP_INOTOBP))) {
-		XFS_CORRUPTION_ERROR("xfs_inotobp", XFS_ERRLEVEL_LOW, mp, dip);
-		xfs_trans_brelse(tp, bp);
-		cmn_err(CE_WARN,
-	"xfs_inotobp: XFS_TEST_ERROR()  returned an "
-	"error on %s.  Returning EFSCORRUPTED.",  mp->m_fsname);
-		return XFS_ERROR(EFSCORRUPTED);
-	}
-
-	xfs_inobp_check(mp, bp);
 
-	/*
-	 * Set *dipp to point to the on-disk inode in the buffer.
-	 */
 	*dipp = (xfs_dinode_t *)xfs_buf_offset(bp, imap.im_boffset);
 	*bpp = bp;
 	*offset = imap.im_boffset;
@@ -251,41 +318,15 @@ xfs_itobp(
 	xfs_imap_t	imap;
 	xfs_buf_t	*bp;
 	int		error;
-	int		i;
-	int		ni;
 
 	if (ip->i_blkno == (xfs_daddr_t)0) {
-		/*
-		 * Call the space management code to find the location of the
-		 * inode on disk.
-		 */
 		imap.im_blkno = bno;
-		if ((error = xfs_imap(mp, tp, ip->i_ino, &imap,
-					XFS_IMAP_LOOKUP | imap_flags)))
+		error = xfs_ino_to_imap(mp, tp, ip->i_ino, &imap,
+					XFS_IMAP_LOOKUP | imap_flags);
+		if (error)
 			return error;
 
 		/*
-		 * If the inode number maps to a block outside the bounds
-		 * of the file system then return NULL rather than calling
-		 * read_buf and panicing when we get an error from the
-		 * driver.
-		 */
-		if ((imap.im_blkno + imap.im_len) >
-		    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
-#ifdef DEBUG
-			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_itobp: "
-					"(imap.im_blkno (0x%llx) "
-					"+ imap.im_len (0x%llx)) > "
-					" XFS_FSB_TO_BB(mp, "
-					"mp->m_sb.sb_dblocks) (0x%llx)",
-					(unsigned long long) imap.im_blkno,
-					(unsigned long long) imap.im_len,
-					XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
-#endif /* DEBUG */
-			return XFS_ERROR(EINVAL);
-		}
-
-		/*
 		 * Fill in the fields in the inode that will be used to
 		 * map the inode to its buffer from now on.
 		 */
@@ -303,76 +344,10 @@ xfs_itobp(
 	}
 	ASSERT(bno == 0 || bno == imap.im_blkno);
 
-	/*
-	 * Read in the buffer.  If tp is NULL, xfs_trans_read_buf() will
-	 * default to just a read_buf() call.
-	 */
-	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap.im_blkno,
-				   (int)imap.im_len, XFS_BUF_LOCK, &bp);
-	if (error) {
-#ifdef DEBUG
-		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_itobp: "
-				"xfs_trans_read_buf() returned error %d, "
-				"imap.im_blkno 0x%llx, imap.im_len 0x%llx",
-				error, (unsigned long long) imap.im_blkno,
-				(unsigned long long) imap.im_len);
-#endif /* DEBUG */
+	error = xfs_imap_to_bp(mp, tp, &imap, &bp, XFS_BUF_LOCK, imap_flags);
+	if (error)
 		return error;
-	}
-
-	/*
-	 * Validate the magic number and version of every inode in the buffer
-	 * (if DEBUG kernel) or the first inode in the buffer, otherwise.
-	 * No validation is done here in userspace (xfs_repair).
-	 */
-#if !defined(__KERNEL__)
-	ni = 0;
-#elif defined(DEBUG)
-	ni = BBTOB(imap.im_len) >> mp->m_sb.sb_inodelog;
-#else	/* usual case */
-	ni = 1;
-#endif
-
-	for (i = 0; i < ni; i++) {
-		int		di_ok;
-		xfs_dinode_t	*dip;
-
-		dip = (xfs_dinode_t *)xfs_buf_offset(bp,
-					(i << mp->m_sb.sb_inodelog));
-		di_ok = be16_to_cpu(dip->di_core.di_magic) == XFS_DINODE_MAGIC &&
-			    XFS_DINODE_GOOD_VERSION(dip->di_core.di_version);
-		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
-						XFS_ERRTAG_ITOBP_INOTOBP,
-						XFS_RANDOM_ITOBP_INOTOBP))) {
-			if (imap_flags & XFS_IMAP_BULKSTAT) {
-				xfs_trans_brelse(tp, bp);
-				return XFS_ERROR(EINVAL);
-			}
-#ifdef DEBUG
-			cmn_err(CE_ALERT,
-					"Device %s - bad inode magic/vsn "
-					"daddr %lld #%d (magic=%x)",
-				XFS_BUFTARG_NAME(mp->m_ddev_targp),
-				(unsigned long long)imap.im_blkno, i,
-				be16_to_cpu(dip->di_core.di_magic));
-#endif
-			XFS_CORRUPTION_ERROR("xfs_itobp", XFS_ERRLEVEL_HIGH,
-					     mp, dip);
-			xfs_trans_brelse(tp, bp);
-			return XFS_ERROR(EFSCORRUPTED);
-		}
-	}
-
-	xfs_inobp_check(mp, bp);
 
-	/*
-	 * Mark the buffer as an inode buffer now that it looks good
-	 */
-	XFS_BUF_SET_VTYPE(bp, B_FS_INO);
-
-	/*
-	 * Set *dipp to point to the on-disk inode in the buffer.
-	 */
 	*dipp = (xfs_dinode_t *)xfs_buf_offset(bp, imap.im_boffset);
 	*bpp = bp;
 	return 0;

--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=xfs-iflush-blocking-fix

---
 fs/xfs/linux-2.6/xfs_super.c |    3 +-
 fs/xfs/linux-2.6/xfs_vnode.h |    5 ---
 fs/xfs/xfs_inode.c           |   33 ++++++++++++++++---------
 fs/xfs/xfs_inode.h           |    7 +++--
 fs/xfs/xfs_vnodeops.c        |   55 +++++++++----------------------------------
 5 files changed, 41 insertions(+), 62 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2007-11-05 10:17:36.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2007-11-05 10:33:49.590268027 +1100
@@ -306,14 +306,15 @@ xfs_inotobp(
  * 0 for the disk block address.
  */
 int
-xfs_itobp(
+xfs_itobp_flags(
 	xfs_mount_t	*mp,
 	xfs_trans_t	*tp,
 	xfs_inode_t	*ip,
 	xfs_dinode_t	**dipp,
 	xfs_buf_t	**bpp,
 	xfs_daddr_t	bno,
-	uint		imap_flags)
+	uint		imap_flags,
+	uint		buf_flags)
 {
 	xfs_imap_t	imap;
 	xfs_buf_t	*bp;
@@ -344,10 +345,17 @@ xfs_itobp(
 	}
 	ASSERT(bno == 0 || bno == imap.im_blkno);
 
-	error = xfs_imap_to_bp(mp, tp, &imap, &bp, XFS_BUF_LOCK, imap_flags);
+	error = xfs_imap_to_bp(mp, tp, &imap, &bp, buf_flags, imap_flags);
 	if (error)
 		return error;
 
+	if (!bp) {
+		ASSERT(buf_flags & XFS_BUF_TRYLOCK);
+		ASSERT(tp == NULL);
+		*bpp = NULL;
+		return EAGAIN;
+	}
+
 	*dipp = (xfs_dinode_t *)xfs_buf_offset(bp, imap.im_boffset);
 	*bpp = bp;
 	return 0;
@@ -3068,15 +3076,6 @@ xfs_iflush(
 	}
 
 	/*
-	 * Get the buffer containing the on-disk inode.
-	 */
-	error = xfs_itobp(mp, NULL, ip, &dip, &bp, 0, 0);
-	if (error) {
-		xfs_ifunlock(ip);
-		return error;
-	}
-
-	/*
 	 * Decide how buffer will be flushed out.  This is done before
 	 * the call to xfs_iflush_int because this field is zeroed by it.
 	 */
@@ -3125,6 +3124,16 @@ xfs_iflush(
 	}
 
 	/*
+	 * Get the buffer containing the on-disk inode.
+	 */
+	error = xfs_itobp_flags(mp, NULL, ip, &dip, &bp, 0, 0,
+			(flags == INT_ASYNC) ? XFS_BUF_TRYLOCK : XFS_BUF_LOCK);
+	if (error ||!bp) {
+		xfs_ifunlock(ip);
+		return error;
+	}
+
+	/*
 	 * First flush out the inode that xfs_iflush was called with.
 	 */
 	error = xfs_iflush_int(ip, bp);
Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.h	2007-11-02 13:44:46.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.h	2007-11-05 10:25:44.885153248 +1100
@@ -488,9 +488,12 @@ int		xfs_finish_reclaim_all(struct xfs_m
 /*
  * xfs_inode.c prototypes.
  */
-int		xfs_itobp(struct xfs_mount *, struct xfs_trans *,
+int		xfs_itobp_flags(struct xfs_mount *, struct xfs_trans *,
 			  xfs_inode_t *, struct xfs_dinode **, struct xfs_buf **,
-			  xfs_daddr_t, uint);
+			  xfs_daddr_t, uint, uint);
+#define xfs_itobp(mp, tp, ip, dipp, bpp, bno, iflags)	\
+	xfs_itobp_flags(mp, tp, ip, dipp, bpp, bno, iflags, XFS_BUF_LOCK)
+
 int		xfs_iread(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
 			  xfs_inode_t **, xfs_daddr_t, uint);
 int		xfs_iread_extents(struct xfs_trans *, xfs_inode_t *, int);
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_super.c	2007-11-02 13:44:50.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c	2007-11-05 10:39:05.969204451 +1100
@@ -840,7 +840,8 @@ xfs_fs_write_inode(
 	struct inode		*inode,
 	int			sync)
 {
-	int			error = 0, flags = FLUSH_INODE;
+	int			error = 0;
+	int			flags = 0;
 
 	xfs_itrace_entry(XFS_I(inode));
 	if (sync) {
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_vnode.h	2007-10-02 16:01:47.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vnode.h	2007-11-05 10:40:49.103817818 +1100
@@ -73,12 +73,9 @@ typedef enum bhv_vrwlock {
 #define IO_INVIS	0x00020		/* don't update inode timestamps */
 
 /*
- * Flags for vop_iflush call
+ * Flags for xfs_inode_flush
  */
 #define FLUSH_SYNC		1	/* wait for flush to complete	*/
-#define FLUSH_INODE		2	/* flush the inode itself	*/
-#define FLUSH_LOG		4	/* force the last log entry for
-					 * this inode out to disk	*/
 
 /*
  * Flush/Invalidate options for vop_toss/flush/flushinval_pages.
Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2007-11-05 10:02:05.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2007-11-05 10:37:53.398623943 +1100
@@ -3556,29 +3556,6 @@ xfs_inode_flush(
 	    ((iip == NULL) || !(iip->ili_format.ilf_fields & XFS_ILOG_ALL)))
 		return 0;
 
-	if (flags & FLUSH_LOG) {
-		if (iip && iip->ili_last_lsn) {
-			xlog_t		*log = mp->m_log;
-			xfs_lsn_t	sync_lsn;
-			int		s, log_flags = XFS_LOG_FORCE;
-
-			s = GRANT_LOCK(log);
-			sync_lsn = log->l_last_sync_lsn;
-			GRANT_UNLOCK(log, s);
-
-			if ((XFS_LSN_CMP(iip->ili_last_lsn, sync_lsn) > 0)) {
-				if (flags & FLUSH_SYNC)
-					log_flags |= XFS_LOG_SYNC;
-				error = xfs_log_force(mp, iip->ili_last_lsn, log_flags);
-				if (error)
-					return error;
-			}
-
-			if (ip->i_update_core == 0)
-				return 0;
-		}
-	}
-
 	/*
 	 * We make this non-blocking if the inode is contended,
 	 * return EAGAIN to indicate to the caller that they
@@ -3586,30 +3563,22 @@ xfs_inode_flush(
 	 * blocking on inodes inside another operation right
 	 * now, they get caught later by xfs_sync.
 	 */
-	if (flags & FLUSH_INODE) {
-		int	flush_flags;
-
-		if (flags & FLUSH_SYNC) {
-			xfs_ilock(ip, XFS_ILOCK_SHARED);
-			xfs_iflock(ip);
-		} else if (xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)) {
-			if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip)) {
-				xfs_iunlock(ip, XFS_ILOCK_SHARED);
-				return EAGAIN;
-			}
-		} else {
+	if (flags & FLUSH_SYNC) {
+		xfs_ilock(ip, XFS_ILOCK_SHARED);
+		xfs_iflock(ip);
+	} else if (xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)) {
+		if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip)) {
+			xfs_iunlock(ip, XFS_ILOCK_SHARED);
 			return EAGAIN;
 		}
-
-		if (flags & FLUSH_SYNC)
-			flush_flags = XFS_IFLUSH_SYNC;
-		else
-			flush_flags = XFS_IFLUSH_ASYNC;
-
-		error = xfs_iflush(ip, flush_flags);
-		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	} else {
+		return EAGAIN;
 	}
 
+	error = xfs_iflush(ip, (flags & FLUSH_SYNC) ? XFS_IFLUSH_SYNC
+						    : XFS_IFLUSH_ASYNC);
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
 	return error;
 }
 

--7ZAtKRhVyVSsbBD2--
