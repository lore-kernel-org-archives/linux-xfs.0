Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Sep 2006 04:24:19 -0700 (PDT)
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k84BNvDW004644
	for <xfs@oss.sgi.com>; Mon, 4 Sep 2006 04:24:08 -0700
Received: from [134.15.160.13] (vpn-emea-sw-emea-160-13.emea.sgi.com [134.15.160.13])
	by imr2.americas.sgi.com (8.12.9/8.12.10/SGI_generic_relay-1.2) with ESMTP id k84BNqDu51075438
	for <xfs@oss.sgi.com>; Mon, 4 Sep 2006 04:23:53 -0700 (PDT)
Message-ID: <44FC0D0F.60403@sgi.com>
Date: Mon, 04 Sep 2006 12:25:03 +0100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: review: propogate return codes from flush routines
Content-Type: multipart/mixed;
 boundary="------------070105020404090905000704"
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------070105020404090905000704
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Here's a patch to handle error return values in fs_flush_pages and
fs_flushinval_pages.  It changes the prototype of fs_flushinval_pages
so we can propogate the errors and handle them at higher layers.  I also 
modified xfs_itruncate_start so that it could propogate the error further.

I've changed the necessary prototypes on 2.4 to keep the build happy but
haven't bothered to fix the error handling in fs_flush_pages or 
fs_flushinval_pages for 2.4.

The motivation behind this change was the recent BUG reported due to a
direct I/O read trying to write to delayed alloc extents.  While the exact
cause of this problem is not known it is possible that fs_flushinval_pages
ignored an error while flushing, truncated the pages on the file anyway,
and failed to convert all delayed alloc extents.

Lachlan

--------------070105020404090905000704
Content-Type: text/plain;
 name="flush.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="flush.patch"

--- fs/xfs/linux-2.4/xfs_fs_subr.c_1.48	2006-09-04 11:55:28.000000000 +0100
+++ fs/xfs/linux-2.4/xfs_fs_subr.c	2006-09-04 11:54:38.000000000 +0100
@@ -35,7 +35,7 @@
 		truncate_inode_pages(ip->i_mapping, first);
 }
 
-void
+int
 fs_flushinval_pages(
 	bhv_desc_t	*bdp,
 	xfs_off_t	first,
@@ -53,6 +53,7 @@
 		filemap_fdatawait(ip->i_mapping);
 		truncate_inode_pages(ip->i_mapping, first);
 	}
+	return 0;
 }
 
 int
--- fs/xfs/linux-2.4/xfs_fs_subr.h_1.17	2006-09-04 11:55:52.000000000 +0100
+++ fs/xfs/linux-2.4/xfs_fs_subr.h	2006-09-04 11:55:24.000000000 +0100
@@ -23,7 +23,7 @@
 extern int  fs_nosys(void);
 extern void fs_noval(void);
 extern void fs_tosspages(bhv_desc_t *, xfs_off_t, xfs_off_t, int);
-extern void fs_flushinval_pages(bhv_desc_t *, xfs_off_t, xfs_off_t, int);
+extern int  fs_flushinval_pages(bhv_desc_t *, xfs_off_t, xfs_off_t, int);
 extern int  fs_flush_pages(bhv_desc_t *, xfs_off_t, xfs_off_t, uint64_t, int);
 
 #endif	/* __XFS_FS_SUBR_H__ */
--- fs/xfs/linux-2.4/xfs_vnode.h_1.113	2006-09-04 11:56:17.000000000 +0100
+++ fs/xfs/linux-2.4/xfs_vnode.h	2006-09-04 11:56:51.000000000 +0100
@@ -183,7 +183,7 @@
 typedef void	(*vop_link_removed_t)(bhv_desc_t *, bhv_vnode_t *, int);
 typedef void	(*vop_vnode_change_t)(bhv_desc_t *, bhv_vchange_t, __psint_t);
 typedef void	(*vop_ptossvp_t)(bhv_desc_t *, xfs_off_t, xfs_off_t, int);
-typedef void	(*vop_pflushinvalvp_t)(bhv_desc_t *, xfs_off_t, xfs_off_t, int);
+typedef int	(*vop_pflushinvalvp_t)(bhv_desc_t *, xfs_off_t, xfs_off_t, int);
 typedef int	(*vop_pflushvp_t)(bhv_desc_t *, xfs_off_t, xfs_off_t,
 				uint64_t, int);
 typedef int	(*vop_iflush_t)(bhv_desc_t *, int);
--- fs/xfs/linux-2.6/xfs_fs_subr.c_1.47	2006-09-01 16:34:01.000000000 +0100
+++ fs/xfs/linux-2.6/xfs_fs_subr.c	2006-09-01 16:36:00.000000000 +0100
@@ -35,7 +35,7 @@
 		truncate_inode_pages(ip->i_mapping, first);
 }
 
-void
+int
 fs_flushinval_pages(
 	bhv_desc_t	*bdp,
 	xfs_off_t	first,
@@ -44,13 +44,16 @@
 {
 	bhv_vnode_t	*vp = BHV_TO_VNODE(bdp);
 	struct inode	*ip = vn_to_inode(vp);
+	int		ret = 0;
 
 	if (VN_CACHED(vp)) {
 		if (VN_TRUNC(vp))
 			VUNTRUNCATE(vp);
-		filemap_write_and_wait(ip->i_mapping);
-		truncate_inode_pages(ip->i_mapping, first);
+		ret = filemap_write_and_wait(ip->i_mapping);
+		if (!ret)
+			truncate_inode_pages(ip->i_mapping, first);
 	}
+	return ret;
 }
 
 int
@@ -63,14 +66,14 @@
 {
 	bhv_vnode_t	*vp = BHV_TO_VNODE(bdp);
 	struct inode	*ip = vn_to_inode(vp);
+	int		ret = 0;
 
 	if (VN_DIRTY(vp)) {
 		if (VN_TRUNC(vp))
 			VUNTRUNCATE(vp);
-		filemap_fdatawrite(ip->i_mapping);
-		if (flags & XFS_B_ASYNC)
-			return 0;
-		filemap_fdatawait(ip->i_mapping);
+		ret = filemap_fdatawrite(ip->i_mapping);
+		if (!ret && !(flags & XFS_B_ASYNC))
+			ret = filemap_fdatawait(ip->i_mapping);
 	}
-	return 0;
+	return ret;
 }
--- fs/xfs/linux-2.6/xfs_fs_subr.h_1.13	2006-09-01 18:24:35.000000000 +0100
+++ fs/xfs/linux-2.6/xfs_fs_subr.h	2006-09-01 17:08:16.000000000 +0100
@@ -23,7 +23,7 @@
 extern int  fs_nosys(void);
 extern void fs_noval(void);
 extern void fs_tosspages(bhv_desc_t *, xfs_off_t, xfs_off_t, int);
-extern void fs_flushinval_pages(bhv_desc_t *, xfs_off_t, xfs_off_t, int);
+extern int  fs_flushinval_pages(bhv_desc_t *, xfs_off_t, xfs_off_t, int);
 extern int  fs_flush_pages(bhv_desc_t *, xfs_off_t, xfs_off_t, uint64_t, int);
 
 #endif	/* __XFS_FS_SUBR_H__ */
--- fs/xfs/linux-2.6/xfs_lrw.c_1.250	2006-09-04 11:03:51.000000000 +0100
+++ fs/xfs/linux-2.6/xfs_lrw.c	2006-09-04 11:05:20.000000000 +0100
@@ -200,7 +200,7 @@
 	struct file		*file = iocb->ki_filp;
 	struct inode		*inode = file->f_mapping->host;
 	size_t			size = 0;
-	ssize_t			ret;
+	ssize_t			ret = 0;
 	xfs_fsize_t		n;
 	xfs_inode_t		*ip;
 	xfs_mount_t		*mp;
@@ -272,9 +272,13 @@
 
 	if (unlikely(ioflags & IO_ISDIRECT)) {
 		if (VN_CACHED(vp))
-			bhv_vop_flushinval_pages(vp, ctooff(offtoct(*offset)),
+			ret = bhv_vop_flushinval_pages(vp, ctooff(offtoct(*offset)),
 						 -1, FI_REMAPF_LOCKED);
 		mutex_unlock(&inode->i_mutex);
+		if (ret) {
+			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+			return ret;
+		}
 	}
 
 	xfs_rw_enter_trace(XFS_READ_ENTER, &ip->i_iocore,
@@ -802,8 +806,10 @@
 		if (need_flush) {
 			xfs_inval_cached_trace(io, pos, -1,
 					ctooff(offtoct(pos)), -1);
-			bhv_vop_flushinval_pages(vp, ctooff(offtoct(pos)),
+			error = bhv_vop_flushinval_pages(vp, ctooff(offtoct(pos)),
 					-1, FI_REMAPF_LOCKED);
+			if (error)
+				goto out_unlock_internal;
 		}
 
 		if (need_i_mutex) {
--- fs/xfs/linux-2.6/xfs_vnode.h_1.125	2006-09-01 18:11:19.000000000 +0100
+++ fs/xfs/linux-2.6/xfs_vnode.h	2006-09-01 18:12:32.000000000 +0100
@@ -196,7 +196,7 @@
 typedef void	(*vop_link_removed_t)(bhv_desc_t *, bhv_vnode_t *, int);
 typedef void	(*vop_vnode_change_t)(bhv_desc_t *, bhv_vchange_t, __psint_t);
 typedef void	(*vop_ptossvp_t)(bhv_desc_t *, xfs_off_t, xfs_off_t, int);
-typedef void	(*vop_pflushinvalvp_t)(bhv_desc_t *, xfs_off_t, xfs_off_t, int);
+typedef int	(*vop_pflushinvalvp_t)(bhv_desc_t *, xfs_off_t, xfs_off_t, int);
 typedef int	(*vop_pflushvp_t)(bhv_desc_t *, xfs_off_t, xfs_off_t,
 				uint64_t, int);
 typedef int	(*vop_iflush_t)(bhv_desc_t *, int);
--- fs/xfs/xfs_dfrag.c_1.55	2006-09-01 18:25:24.000000000 +0100
+++ fs/xfs/xfs_dfrag.c	2006-09-01 16:46:00.000000000 +0100
@@ -200,7 +200,9 @@
 
 	if (VN_CACHED(tvp) != 0) {
 		xfs_inval_cached_trace(&tip->i_iocore, 0, -1, 0, -1);
-		bhv_vop_flushinval_pages(tvp, 0, -1, FI_REMAPF_LOCKED);
+		error = bhv_vop_flushinval_pages(tvp, 0, -1, FI_REMAPF_LOCKED);
+		if (error)
+			goto error0;
 	}
 
 	/* Verify O_DIRECT for ftmp */
--- fs/xfs/xfs_inode.c_1.451	2006-09-01 18:25:49.000000000 +0100
+++ fs/xfs/xfs_inode.c	2006-09-01 16:52:40.000000000 +0100
@@ -1421,7 +1421,7 @@
  * must be called again with all the same restrictions as the initial
  * call.
  */
-void
+int
 xfs_itruncate_start(
 	xfs_inode_t	*ip,
 	uint		flags,
@@ -1431,6 +1431,7 @@
 	xfs_off_t	toss_start;
 	xfs_mount_t	*mp;
 	bhv_vnode_t	*vp;
+	int		error = 0;
 
 	ASSERT(ismrlocked(&ip->i_iolock, MR_UPDATE) != 0);
 	ASSERT((new_size == 0) || (new_size <= ip->i_d.di_size));
@@ -1468,7 +1469,7 @@
 		 * file size, so there is no way that the data extended
 		 * out there.
 		 */
-		return;
+		return 0;
 	}
 	last_byte = xfs_file_last_byte(ip);
 	xfs_itrunc_trace(XFS_ITRUNC_START, ip, flags, new_size, toss_start,
@@ -1477,7 +1478,7 @@
 		if (flags & XFS_ITRUNC_DEFINITE) {
 			bhv_vop_toss_pages(vp, toss_start, -1, FI_REMAPF_LOCKED);
 		} else {
-			bhv_vop_flushinval_pages(vp, toss_start, -1, FI_REMAPF_LOCKED);
+			error = bhv_vop_flushinval_pages(vp, toss_start, -1, FI_REMAPF_LOCKED);
 		}
 	}
 
@@ -1486,6 +1487,7 @@
 		ASSERT(VN_CACHED(vp) == 0);
 	}
 #endif
+	return error;
 }
 
 /*
--- fs/xfs/xfs_inode.h_1.215	2006-09-01 18:26:15.000000000 +0100
+++ fs/xfs/xfs_inode.h	2006-09-01 16:53:11.000000000 +0100
@@ -439,7 +439,7 @@
 uint		xfs_dic2xflags(struct xfs_dinode_core *);
 int		xfs_ifree(struct xfs_trans *, xfs_inode_t *,
 			   struct xfs_bmap_free *);
-void		xfs_itruncate_start(xfs_inode_t *, uint, xfs_fsize_t);
+int		xfs_itruncate_start(xfs_inode_t *, uint, xfs_fsize_t);
 int		xfs_itruncate_finish(struct xfs_trans **, xfs_inode_t *,
 				     xfs_fsize_t, int, int);
 int		xfs_iunlink(struct xfs_trans *, xfs_inode_t *);
--- fs/xfs/xfs_utils.c_1.72	2006-09-01 18:26:39.000000000 +0100
+++ fs/xfs/xfs_utils.c	2006-09-01 16:55:21.000000000 +0100
@@ -420,7 +420,11 @@
 	 * in a transaction.
 	 */
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
-	xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, (xfs_fsize_t)0);
+	error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, (xfs_fsize_t)0);
+	if (error) {
+		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+		return error;
+	}
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_TRUNCATE_FILE);
 	if ((error = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0,
--- fs/xfs/xfs_vfsops.c_1.511	2006-09-04 11:06:00.000000000 +0100
+++ fs/xfs/xfs_vfsops.c	2006-09-04 11:00:50.000000000 +0100
@@ -1150,7 +1150,7 @@
 			if (XFS_FORCED_SHUTDOWN(mp)) {
 				bhv_vop_toss_pages(vp, 0, -1, FI_REMAPF);
 			} else {
-				bhv_vop_flushinval_pages(vp, 0, -1, FI_REMAPF);
+				error = bhv_vop_flushinval_pages(vp, 0, -1, FI_REMAPF);
 			}
 
 			xfs_ilock(ip, XFS_ILOCK_SHARED);
--- fs/xfs/xfs_vnodeops.c_1.682	2006-09-01 18:27:04.000000000 +0100
+++ fs/xfs/xfs_vnodeops.c	2006-09-04 01:11:37.000000000 +0100
@@ -1258,8 +1258,12 @@
 		 * do that within a transaction.
 		 */
 		xfs_ilock(ip, XFS_IOLOCK_EXCL);
-		xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE,
+		error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE,
 				    ip->i_d.di_size);
+		if (error) {
+			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+			return error;
+		}
 
 		error = xfs_trans_reserve(tp, 0,
 					  XFS_ITRUNCATE_LOG_RES(mp),
@@ -1676,7 +1680,11 @@
 		 */
 		xfs_ilock(ip, XFS_IOLOCK_EXCL);
 
-		xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, 0);
+		error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, 0);
+		if (error) {
+			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+			return VN_INACTIVE_CACHE;
+		}
 
 		error = xfs_trans_reserve(tp, 0,
 					  XFS_ITRUNCATE_LOG_RES(mp),
@@ -4332,8 +4340,10 @@
 	if (VN_CACHED(vp) != 0) {
 		xfs_inval_cached_trace(&ip->i_iocore, ioffset, -1,
 				ctooff(offtoct(ioffset)), -1);
-		bhv_vop_flushinval_pages(vp, ctooff(offtoct(ioffset)),
+		error = bhv_vop_flushinval_pages(vp, ctooff(offtoct(ioffset)),
 				-1, FI_REMAPF_LOCKED);
+		if (error)
+			goto out_unlock_iolock;
 	}
 
 	/*

--------------070105020404090905000704--
