Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:58758 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388457AbeGYCYD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jul 2018 22:24:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6P19Jhc178930
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jul 2018 01:14:52 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2kbvsnucps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jul 2018 01:14:52 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6P1Ep43008720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jul 2018 01:14:51 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w6P1Epw3007851
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jul 2018 01:14:51 GMT
Subject: [PATCH 2/2] xfs: clean up IRELE/iput callsites
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 24 Jul 2018 18:14:58 -0700
Message-ID: <153248129832.28208.4218463670080722161.stgit@magnolia>
In-Reply-To: <153248128617.28208.11803349732053454018.stgit@magnolia>
References: <153248128617.28208.11803349732053454018.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the IRELE macro with a proper function so that we can do proper
typechecking and so that we can stop open-coding iput in scrub, which
means that we'll be able to ftrace inode lifetimes going through scrub
correctly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/common.c    |    2 +-
 fs/xfs/scrub/dir.c       |    2 +-
 fs/xfs/scrub/parent.c    |    6 +++---
 fs/xfs/scrub/scrub.c     |    2 +-
 fs/xfs/xfs_bmap_item.c   |    4 ++--
 fs/xfs/xfs_export.c      |    2 +-
 fs/xfs/xfs_filestream.c  |    4 ++--
 fs/xfs/xfs_icache.c      |    4 ++--
 fs/xfs/xfs_inode.c       |   17 +++++++++++++----
 fs/xfs/xfs_inode.h       |    7 ++-----
 fs/xfs/xfs_iops.c        |    4 ++--
 fs/xfs/xfs_itable.c      |    2 +-
 fs/xfs/xfs_log_recover.c |    4 ++--
 fs/xfs/xfs_mount.c       |    4 ++--
 fs/xfs/xfs_qm.c          |   22 +++++++++++-----------
 fs/xfs/xfs_qm_syscalls.c |    8 ++++----
 fs/xfs/xfs_quotaops.c    |    2 +-
 fs/xfs/xfs_rtalloc.c     |    6 +++---
 fs/xfs/xfs_symlink.c     |    2 +-
 19 files changed, 55 insertions(+), 49 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 248efa74c390..6512d8fb67e1 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -711,7 +711,7 @@ xchk_get_inode(
 		return error;
 	}
 	if (VFS_I(ip)->i_generation != sc->sm->sm_gen) {
-		iput(VFS_I(ip));
+		xfs_irele(ip);
 		return -ENOENT;
 	}
 
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index f58709052b03..cd3e4d768a18 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -87,7 +87,7 @@ xchk_dir_check_ftype(
 			xfs_mode_to_ftype(VFS_I(ip)->i_mode));
 	if (ino_dtype != dtype)
 		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
-	iput(VFS_I(ip));
+	xfs_irele(ip);
 out:
 	return error;
 }
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index aacb0284c48a..1c9d7c7f64f5 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -230,11 +230,11 @@ xchk_parent_validate(
 
 	/* Drat, parent changed.  Try again! */
 	if (dnum != dp->i_ino) {
-		iput(VFS_I(dp));
+		xfs_irele(dp);
 		*try_again = true;
 		return 0;
 	}
-	iput(VFS_I(dp));
+	xfs_irele(dp);
 
 	/*
 	 * '..' didn't change, so check that there was only one entry
@@ -247,7 +247,7 @@ xchk_parent_validate(
 out_unlock:
 	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
 out_rele:
-	iput(VFS_I(dp));
+	xfs_irele(dp);
 out:
 	return error;
 }
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 5956b8073e2f..6efb926f3cf8 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -183,7 +183,7 @@ xchk_teardown(
 			xfs_iunlock(sc->ip, sc->ilock_flags);
 		if (sc->ip != ip_in &&
 		    !xfs_internal_inum(sc->mp, sc->ip->i_ino))
-			iput(VFS_I(sc->ip));
+			xfs_irele(sc->ip);
 		sc->ip = NULL;
 	}
 	if (sc->has_quotaofflock)
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 956ebd583e27..c2b4a5befa78 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -489,7 +489,7 @@ xfs_bui_recover(
 	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
 	error = xfs_trans_commit(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	IRELE(ip);
+	xfs_irele(ip);
 
 	return error;
 
@@ -497,7 +497,7 @@ xfs_bui_recover(
 	xfs_trans_cancel(tp);
 	if (ip) {
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		IRELE(ip);
+		xfs_irele(ip);
 	}
 	return error;
 }
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 3cf4682e2510..f2284ceb129f 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -150,7 +150,7 @@ xfs_nfs_get_inode(
 	}
 
 	if (VFS_I(ip)->i_generation != generation) {
-		IRELE(ip);
+		xfs_irele(ip);
 		return ERR_PTR(-ESTALE);
 	}
 
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 2d2c5ab9143c..150f5899f225 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -339,7 +339,7 @@ xfs_filestream_lookup_ag(
 	if (xfs_filestream_pick_ag(pip, startag, &ag, 0, 0))
 		ag = NULLAGNUMBER;
 out:
-	IRELE(pip);
+	xfs_irele(pip);
 	return ag;
 }
 
@@ -388,7 +388,7 @@ xfs_filestream_new_ag(
 	if (mru)
 		xfs_fstrm_free_func(mp, mru);
 
-	IRELE(pip);
+	xfs_irele(pip);
 exit:
 	if (*agp == NULLAGNUMBER)
 		*agp = 0;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 47f417d20a30..8de94ecd73ae 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -716,7 +716,7 @@ xfs_icache_inode_is_allocated(
 		return error;
 
 	*inuse = !!(VFS_I(ip)->i_mode);
-	IRELE(ip);
+	xfs_irele(ip);
 	return 0;
 }
 
@@ -856,7 +856,7 @@ xfs_inode_ag_walk(
 			    xfs_iflags_test(batch[i], XFS_INEW))
 				xfs_inew_wait(batch[i]);
 			error = execute(batch[i], flags, args);
-			IRELE(batch[i]);
+			xfs_irele(batch[i]);
 			if (error == -EAGAIN) {
 				skipped++;
 				continue;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5df4de666cc1..d01b6a0db16c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1287,7 +1287,7 @@ xfs_create(
 	 */
 	if (ip) {
 		xfs_finish_inode_setup(ip);
-		IRELE(ip);
+		xfs_irele(ip);
 	}
 
 	xfs_qm_dqrele(udqp);
@@ -1382,7 +1382,7 @@ xfs_create_tmpfile(
 	 */
 	if (ip) {
 		xfs_finish_inode_setup(ip);
-		IRELE(ip);
+		xfs_irele(ip);
 	}
 
 	xfs_qm_dqrele(udqp);
@@ -3209,7 +3209,7 @@ xfs_rename(
 
 	error = xfs_finish_rename(tp, &dfops);
 	if (wip)
-		IRELE(wip);
+		xfs_irele(wip);
 	return error;
 
 out_bmap_cancel:
@@ -3218,7 +3218,7 @@ xfs_rename(
 	xfs_trans_cancel(tp);
 out_release_wip:
 	if (wip)
-		IRELE(wip);
+		xfs_irele(wip);
 	return error;
 }
 
@@ -3674,3 +3674,12 @@ xfs_iflush_int(
 corrupt_out:
 	return -EFSCORRUPTED;
 }
+
+/* Release an inode. */
+void
+xfs_irele(
+	struct xfs_inode	*ip)
+{
+	trace_xfs_irele(ip, _RET_IP_);
+	iput(VFS_I(ip));
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 8e18bc0fedd0..fa05f8126b00 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -484,11 +484,7 @@ static inline void xfs_setup_existing_inode(struct xfs_inode *ip)
 	xfs_finish_inode_setup(ip);
 }
 
-#define IRELE(ip) \
-do { \
-	trace_xfs_irele(ip, _THIS_IP_); \
-	iput(VFS_I(ip)); \
-} while (0)
+void xfs_irele(struct xfs_inode *ip);
 
 extern struct kmem_zone	*xfs_inode_zone;
 
@@ -497,4 +493,5 @@ extern struct kmem_zone	*xfs_inode_zone;
 
 bool xfs_inode_verify_forks(struct xfs_inode *ip);
 
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 0fa29f39d658..4101410021ca 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -208,7 +208,7 @@ xfs_generic_create(
 	xfs_finish_inode_setup(ip);
 	if (!tmpfile)
 		xfs_cleanup_inode(dir, inode, dentry);
-	iput(inode);
+	xfs_irele(ip);
 	goto out_free_acl;
 }
 
@@ -390,7 +390,7 @@ xfs_vn_symlink(
  out_cleanup_inode:
 	xfs_finish_inode_setup(cip);
 	xfs_cleanup_inode(dir, inode, dentry);
-	iput(inode);
+	xfs_irele(cip);
  out:
 	return error;
 }
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 65810827a8d0..e9508ba01ed1 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -114,7 +114,7 @@ xfs_bulkstat_one_int(
 		break;
 	}
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-	IRELE(ip);
+	xfs_irele(ip);
 
 	error = formatter(buffer, ubsize, ubused, buf);
 	if (!error)
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b181b5f57a19..8fa6730653ae 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -5094,11 +5094,11 @@ xlog_recover_process_one_iunlink(
 	 */
 	ip->i_d.di_dmevmask = 0;
 
-	IRELE(ip);
+	xfs_irele(ip);
 	return agino;
 
  fail_iput:
-	IRELE(ip);
+	xfs_irele(ip);
  fail:
 	/*
 	 * We can't read in the inode this bucket points to, or this inode
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 4fb361cde32a..8f739e4d0d1c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1039,7 +1039,7 @@ xfs_mountfs(
  out_rtunmount:
 	xfs_rtunmount_inodes(mp);
  out_rele_rip:
-	IRELE(rip);
+	xfs_irele(rip);
 	/* Clean out dquots that might be in memory after quotacheck. */
 	xfs_qm_unmount(mp);
 	/*
@@ -1095,7 +1095,7 @@ xfs_unmountfs(
 	xfs_fs_unreserve_ag_blocks(mp);
 	xfs_qm_unmount_quotas(mp);
 	xfs_rtunmount_inodes(mp);
-	IRELE(mp->m_rootip);
+	xfs_irele(mp->m_rootip);
 
 	/*
 	 * We can potentially deadlock here if we have an inode cluster
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 9ceb85cce33a..52ed7904df10 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -231,15 +231,15 @@ xfs_qm_unmount_quotas(
 	 */
 	if (mp->m_quotainfo) {
 		if (mp->m_quotainfo->qi_uquotaip) {
-			IRELE(mp->m_quotainfo->qi_uquotaip);
+			xfs_irele(mp->m_quotainfo->qi_uquotaip);
 			mp->m_quotainfo->qi_uquotaip = NULL;
 		}
 		if (mp->m_quotainfo->qi_gquotaip) {
-			IRELE(mp->m_quotainfo->qi_gquotaip);
+			xfs_irele(mp->m_quotainfo->qi_gquotaip);
 			mp->m_quotainfo->qi_gquotaip = NULL;
 		}
 		if (mp->m_quotainfo->qi_pquotaip) {
-			IRELE(mp->m_quotainfo->qi_pquotaip);
+			xfs_irele(mp->m_quotainfo->qi_pquotaip);
 			mp->m_quotainfo->qi_pquotaip = NULL;
 		}
 	}
@@ -1200,12 +1200,12 @@ xfs_qm_dqusage_adjust(
 			goto error0;
 	}
 
-	IRELE(ip);
+	xfs_irele(ip);
 	*res = BULKSTAT_RV_DIDONE;
 	return 0;
 
 error0:
-	IRELE(ip);
+	xfs_irele(ip);
 	*res = BULKSTAT_RV_GIVEUP;
 	return error;
 }
@@ -1575,11 +1575,11 @@ xfs_qm_init_quotainos(
 
 error_rele:
 	if (uip)
-		IRELE(uip);
+		xfs_irele(uip);
 	if (gip)
-		IRELE(gip);
+		xfs_irele(gip);
 	if (pip)
-		IRELE(pip);
+		xfs_irele(pip);
 	return error;
 }
 
@@ -1588,15 +1588,15 @@ xfs_qm_destroy_quotainos(
 	xfs_quotainfo_t	*qi)
 {
 	if (qi->qi_uquotaip) {
-		IRELE(qi->qi_uquotaip);
+		xfs_irele(qi->qi_uquotaip);
 		qi->qi_uquotaip = NULL; /* paranoia */
 	}
 	if (qi->qi_gquotaip) {
-		IRELE(qi->qi_gquotaip);
+		xfs_irele(qi->qi_gquotaip);
 		qi->qi_gquotaip = NULL;
 	}
 	if (qi->qi_pquotaip) {
-		IRELE(qi->qi_pquotaip);
+		xfs_irele(qi->qi_pquotaip);
 		qi->qi_pquotaip = NULL;
 	}
 }
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index abc8a21e3a82..2c51f2992d3d 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -189,15 +189,15 @@ xfs_qm_scall_quotaoff(
 	 * Release our quotainode references if we don't need them anymore.
 	 */
 	if ((dqtype & XFS_QMOPT_UQUOTA) && q->qi_uquotaip) {
-		IRELE(q->qi_uquotaip);
+		xfs_irele(q->qi_uquotaip);
 		q->qi_uquotaip = NULL;
 	}
 	if ((dqtype & XFS_QMOPT_GQUOTA) && q->qi_gquotaip) {
-		IRELE(q->qi_gquotaip);
+		xfs_irele(q->qi_gquotaip);
 		q->qi_gquotaip = NULL;
 	}
 	if ((dqtype & XFS_QMOPT_PQUOTA) && q->qi_pquotaip) {
-		IRELE(q->qi_pquotaip);
+		xfs_irele(q->qi_pquotaip);
 		q->qi_pquotaip = NULL;
 	}
 
@@ -250,7 +250,7 @@ xfs_qm_scall_trunc_qfile(
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 out_put:
-	IRELE(ip);
+	xfs_irele(ip);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 205fbb2a77e4..a7c0c657dfaf 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -45,7 +45,7 @@ xfs_qm_fill_state(
 	tstate->ino_warnlimit = q->qi_iwarnlimit;
 	tstate->rt_spc_warnlimit = q->qi_rtbwarnlimit;
 	if (tempqip)
-		IRELE(ip);
+		xfs_irele(ip);
 }
 
 /*
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 329d4d26c13e..ae592a2d5ce2 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1215,7 +1215,7 @@ xfs_rtmount_inodes(
 	ASSERT(sbp->sb_rsumino != NULLFSINO);
 	error = xfs_iget(mp, NULL, sbp->sb_rsumino, 0, 0, &mp->m_rsumip);
 	if (error) {
-		IRELE(mp->m_rbmip);
+		xfs_irele(mp->m_rbmip);
 		return error;
 	}
 	ASSERT(mp->m_rsumip != NULL);
@@ -1227,9 +1227,9 @@ xfs_rtunmount_inodes(
 	struct xfs_mount	*mp)
 {
 	if (mp->m_rbmip)
-		IRELE(mp->m_rbmip);
+		xfs_irele(mp->m_rbmip);
 	if (mp->m_rsumip)
-		IRELE(mp->m_rsumip);
+		xfs_irele(mp->m_rsumip);
 }
 
 /*
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 3783afcb68d2..7f85342a09e6 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -381,7 +381,7 @@ xfs_symlink(
 	 */
 	if (ip) {
 		xfs_finish_inode_setup(ip);
-		IRELE(ip);
+		xfs_irele(ip);
 	}
 
 	xfs_qm_dqrele(udqp);

