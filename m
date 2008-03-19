Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 13:48:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2JKmmW1030704
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 13:48:49 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C9FE56C040E
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 13:49:19 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id Zaiv4eFgnECR5Ebf for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 13:49:19 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m2JKnEF3024639
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 21:49:14 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m2JKnEGv024637
	for xfs@oss.sgi.com; Wed, 19 Mar 2008 21:49:14 +0100
Date: Wed, 19 Mar 2008 21:49:14 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove most calls to VN_RELE
Message-ID: <20080319204914.GB24271@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Most VN_RELE calls either directly contain a XFS_ITOV or have the
corresponding xfs_inode already in scope.  Use the IRELE helper instead
of VN_RELE to clarify the code.  With a little more work we can kill
VN_RELE altogether and define IRELE in terms of iput directly.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm.c	2008-03-06 10:32:26.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm.c	2008-03-06 10:33:30.000000000 +0100
@@ -1810,7 +1810,7 @@ xfs_qm_dqusage_adjust(
 	 * Now release the inode. This will send it to 'inactive', and
 	 * possibly even free blocks.
 	 */
-	VN_RELE(XFS_ITOV(ip));
+	IRELE(ip);
 
 	/*
 	 * Goto next inode.
@@ -1968,7 +1968,7 @@ xfs_qm_init_quotainos(
 			if ((error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
 					     0, 0, &gip, 0))) {
 				if (uip)
-					VN_RELE(XFS_ITOV(uip));
+					IRELE(uip);
 				return XFS_ERROR(error);
 			}
 		}
@@ -1999,7 +1999,7 @@ xfs_qm_init_quotainos(
 					  sbflags | XFS_SB_GQUOTINO, flags);
 		if (error) {
 			if (uip)
-				VN_RELE(XFS_ITOV(uip));
+				IRELE(uip);
 
 			return XFS_ERROR(error);
 		}
Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2008-03-06 10:05:58.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm_syscalls.c	2008-03-06 10:33:30.000000000 +0100
@@ -386,7 +386,7 @@ xfs_qm_scall_trunc_qfiles(
 		error = xfs_iget(mp, NULL, mp->m_sb.sb_uquotino, 0, 0, &qip, 0);
 		if (! error) {
 			(void) xfs_truncate_file(mp, qip);
-			VN_RELE(XFS_ITOV(qip));
+			IRELE(qip);
 		}
 	}
 
@@ -395,7 +395,7 @@ xfs_qm_scall_trunc_qfiles(
 		error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino, 0, 0, &qip, 0);
 		if (! error) {
 			(void) xfs_truncate_file(mp, qip);
-			VN_RELE(XFS_ITOV(qip));
+			IRELE(qip);
 		}
 	}
 
@@ -552,13 +552,13 @@ xfs_qm_scall_getqstat(
 		out->qs_uquota.qfs_nblks = uip->i_d.di_nblocks;
 		out->qs_uquota.qfs_nextents = uip->i_d.di_nextents;
 		if (tempuqip)
-			VN_RELE(XFS_ITOV(uip));
+			IRELE(uip);
 	}
 	if (gip) {
 		out->qs_gquota.qfs_nblks = gip->i_d.di_nblocks;
 		out->qs_gquota.qfs_nextents = gip->i_d.di_nextents;
 		if (tempgqip)
-			VN_RELE(XFS_ITOV(gip));
+			IRELE(gip);
 	}
 	if (mp->m_quotainfo) {
 		out->qs_incoredqs = XFS_QI_MPLNDQUOTS(mp);
@@ -1095,7 +1095,7 @@ again:
 		 * inactive code in hell.
 		 */
 		if (vnode_refd)
-			VN_RELE(vp);
+			IRELE(ip);
 		XFS_MOUNT_ILOCK(mp);
 		/*
 		 * If an inode was inserted or removed, we gotta
Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2008-03-06 10:32:26.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2008-03-06 10:33:30.000000000 +0100
@@ -46,6 +46,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_quota.h"
 #include "xfs_rw.h"
+#include "xfs_utils.h"
 
 STATIC int	xlog_find_zeroed(xlog_t *, xfs_daddr_t *);
 STATIC int	xlog_clear_stale_blocks(xlog_t *, xfs_lsn_t);
@@ -3248,7 +3249,7 @@ xlog_recover_process_iunlinks(
 					if (ip->i_d.di_mode == 0)
 						xfs_iput_new(ip, 0);
 					else
-						VN_RELE(XFS_ITOV(ip));
+						IRELE(ip);
 				} else {
 					/*
 					 * We can't read in the inode
Index: linux-2.6-xfs/fs/xfs/xfs_rtalloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rtalloc.c	2008-03-06 10:05:58.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_rtalloc.c	2008-03-06 10:33:30.000000000 +0100
@@ -44,6 +44,7 @@
 #include "xfs_rw.h"
 #include "xfs_inode_item.h"
 #include "xfs_trans_space.h"
+#include "xfs_utils.h"
 
 
 /*
@@ -2278,7 +2279,7 @@ xfs_rtmount_inodes(
 	ASSERT(sbp->sb_rsumino != NULLFSINO);
 	error = xfs_iget(mp, NULL, sbp->sb_rsumino, 0, 0, &mp->m_rsumip, 0);
 	if (error) {
-		VN_RELE(XFS_ITOV(mp->m_rbmip));
+		IRELE(mp->m_rbmip);
 		return error;
 	}
 	ASSERT(mp->m_rsumip != NULL);
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2008-03-06 10:32:26.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2008-03-06 10:33:30.000000000 +0100
@@ -55,6 +55,7 @@
 #include "xfs_fsops.h"
 #include "xfs_vnodeops.h"
 #include "xfs_vfsops.h"
+#include "xfs_utils.h"
 
 
 int __init
@@ -595,7 +596,7 @@ xfs_unmount(
 	/*
 	 * Drop the reference count
 	 */
-	VN_RELE(rvp);
+	IRELE(rip);
 
 	/*
 	 * If we're forcing a shutdown, typically because of a media error,
@@ -777,8 +778,8 @@ xfs_unmount_flush(
 		goto fscorrupt_out2;
 
 	if (rbmip) {
-		VN_RELE(XFS_ITOV(rbmip));
-		VN_RELE(XFS_ITOV(rsumip));
+		IRELE(rbmip);
+		IRELE(rsumip);
 	}
 
 	xfs_iunlock(rip, XFS_ILOCK_EXCL);
@@ -1156,10 +1157,10 @@ xfs_sync_inodes(
 			 * above, then wait until after we've unlocked
 			 * the inode to release the reference.  This is
 			 * because we can be already holding the inode
-			 * lock when VN_RELE() calls xfs_inactive().
+			 * lock when IRELE() calls xfs_inactive().
 			 *
 			 * Make sure to drop the mount lock before calling
-			 * VN_RELE() so that we don't trip over ourselves if
+			 * IRELE() so that we don't trip over ourselves if
 			 * we have to go for the mount lock again in the
 			 * inactive code.
 			 */
@@ -1167,7 +1168,7 @@ xfs_sync_inodes(
 				IPOINTER_INSERT(ip, mp);
 			}
 
-			VN_RELE(vp);
+			IRELE(ip);
 
 			vnode_refed = B_FALSE;
 		}
Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-03-06 10:33:29.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-03-06 10:33:30.000000000 +0100
@@ -43,6 +43,7 @@
 #include "xfs_rw.h"
 #include "xfs_quota.h"
 #include "xfs_fsops.h"
+#include "xfs_utils.h"
 
 STATIC void	xfs_mount_log_sb(xfs_mount_t *, __int64_t);
 STATIC int	xfs_uuid_mount(xfs_mount_t *);
@@ -957,7 +958,6 @@ xfs_mountfs(
 {
 	xfs_sb_t	*sbp = &(mp->m_sb);
 	xfs_inode_t	*rip;
-	bhv_vnode_t	*rvp = NULL;
 	__uint64_t	resblks;
 	__int64_t	update_flags = 0LL;
 	uint		quotamount, quotaflags;
@@ -1147,7 +1147,6 @@ xfs_mountfs(
 	}
 
 	ASSERT(rip != NULL);
-	rvp = XFS_ITOV(rip);
 
 	if (unlikely((rip->i_d.di_mode & S_IFMT) != S_IFDIR)) {
 		cmn_err(CE_WARN, "XFS: corrupted root inode");
@@ -1230,7 +1229,7 @@ xfs_mountfs(
 	/*
 	 * Free up the root inode.
 	 */
-	VN_RELE(rvp);
+	IRELE(rip);
  error3:
 	xfs_log_unmount_dealloc(mp);
  error2:
