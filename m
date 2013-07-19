Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ABD6A7F51
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 17:36:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8C0C18F8054
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 15:36:11 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id hYDMrFU4hH6tFuir (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jul 2013 15:36:10 -0700 (PDT)
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 19 Jul 2013 16:36:06 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 807413E40030
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 16:35:41 -0600 (MDT)
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r6JMa3ch386328 for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 16:36:03 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r6JMce3J012964
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 16:38:40 -0600
Received: from [9.41.106.170] (chandra-dt.austin.ibm.com [9.41.106.170])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	r6JMcexx012950 for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 16:38:40 -0600
Subject: [PATCH] xfs: Start using pquotaino from the superblock.
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 19 Jul 2013 17:36:02 -0500
Message-ID: <1374273362.8941.2086.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: XFS mailing list <xfs@oss.sgi.com>

Change from the previous version:
Addressed Ben's comments
 - removed unnecessary sb_gquotino == NULLFSINO check in
   xfs_sb_quota_to_disk()
 - Changed the fs_quota_stat logic to not fail with EINVAL if
   both gquota and pquota are available. Instead, fill fs_quota_stat
   only with gquota information.
----

Start using pquotino and define a macro to check if the
superblock has pquotino.

Keep backward compatibilty by alowing mount of older superblock
with no separate pquota inode.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_mount.c       |   62 ++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_qm.c          |   72 ++++++++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_qm_syscalls.c |   35 +++++++++++++++++++---
 fs/xfs/xfs_sb.h          |   13 ++++++--
 fs/xfs/xfs_super.c       |   19 ++++++------
 6 files changed, 159 insertions(+), 44 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 7263e1b..a0fa802 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -336,14 +336,6 @@ xfs_mount_validate_sb(
 		return XFS_ERROR(EWRONGFS);
 	}
 
-	if ((sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) &&
-			(sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
-				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))) {
-		xfs_notice(mp,
-"Super block has XFS_OQUOTA bits along with XFS_PQUOTA and/or XFS_GQUOTA bits.\n");
-		return XFS_ERROR(EFSCORRUPTED);
-	}
-
 	/*
 	 * Version 5 superblock feature mask validation. Reject combinations the
 	 * kernel cannot support up front before checking anything else. For
@@ -387,6 +379,19 @@ xfs_mount_validate_sb(
 		}
 	}
 
+	if (xfs_sb_version_has_pquotino(sbp)) {
+		if (sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
+			xfs_notice(mp,
+			   "Version 5 of Super block has XFS_OQUOTA bits.\n");
+			return XFS_ERROR(EFSCORRUPTED);
+		}
+	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
+				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
+			xfs_notice(mp,
+"Superblock earlier than Version 5 has XFS_[PQ]UOTA_{ENFD|CHKD} bits.\n");
+			return XFS_ERROR(EFSCORRUPTED);
+	}
+
 	if (unlikely(
 	    sbp->sb_logstart == 0 && mp->m_logdev_targp == mp->m_ddev_targp)) {
 		xfs_warn(mp,
@@ -590,6 +595,13 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
 	if (sbp->sb_pquotino == 0)
 		sbp->sb_pquotino = NULLFSINO;
 
+	/*
+	 * We need to do these manipilations only if we are working
+	 * with an older version of on-disk superblock.
+	 */
+	if (xfs_sb_version_has_pquotino(sbp))
+		return;
+
 	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
 		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
 					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
@@ -597,6 +609,18 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
 		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
 					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
 	sbp->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
+
+	if (sbp->sb_qflags & XFS_PQUOTA_ACCT)  {
+		/*
+		 * In older version of superblock, on-disk superblock only
+		 * has sb_gquotino, and in-core superblock has both sb_gquotino
+		 * and sb_pquotino. But, only one of them is supported at any
+		 * point of time. So, if PQUOTA is set in disk superblock,
+		 * copy over sb_gquotino to sb_pquotino.
+		 */
+		sbp->sb_pquotino = sbp->sb_gquotino;
+		sbp->sb_gquotino = NULLFSINO;
+	}
 }
 
 void
@@ -668,6 +692,13 @@ xfs_sb_quota_to_disk(
 {
 	__uint16_t	qflags = from->sb_qflags;
 
+	/*
+	 * We need to do these manipilations only if we are working
+	 * with an older version of on-disk superblock.
+	 */
+	if (xfs_sb_version_has_pquotino(from))
+		return;
+
 	if (*fields & XFS_SB_QFLAGS) {
 		/*
 		 * The in-core version of sb_qflags do not have
@@ -687,6 +718,21 @@ xfs_sb_quota_to_disk(
 		to->sb_qflags = cpu_to_be16(qflags);
 		*fields &= ~XFS_SB_QFLAGS;
 	}
+
+	/*
+	 * GQUOTINO and PQUOTINO cannot be used together in versions
+	 * of superblock that do not have pquotino. from->sb_flags
+	 * tells us which quota is active and should be copied to
+	 * disk.
+	 */
+	if ((*fields & XFS_SB_GQUOTINO) &&
+				(from->sb_qflags & XFS_GQUOTA_ACCT))
+		to->sb_gquotino = cpu_to_be64(from->sb_gquotino);
+	else if ((*fields & XFS_SB_PQUOTINO) &&
+				(from->sb_qflags & XFS_PQUOTA_ACCT))
+		to->sb_gquotino = cpu_to_be64(from->sb_pquotino);
+
+	*fields &= ~(XFS_SB_PQUOTINO | XFS_SB_GQUOTINO);
 }
 
 /*
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index d320794..1e2361d 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -834,6 +834,36 @@ xfs_qm_qino_alloc(
 	int		error;
 	int		committed;
 
+	*ip = NULL;
+	/*
+	 * With superblock that doesn't have separate pquotino, we
+	 * share an inode between gquota and pquota. If the on-disk
+	 * superblock has GQUOTA and the filesystem is now mounted
+	 * with PQUOTA, just use sb_gquotino for sb_pquotino and
+	 * vice-versa.
+	 */
+	if (!xfs_sb_version_has_pquotino(&mp->m_sb) &&
+			(flags & (XFS_QMOPT_PQUOTA|XFS_QMOPT_GQUOTA))) {
+		xfs_ino_t ino = NULLFSINO;
+
+		if ((flags & XFS_QMOPT_PQUOTA) &&
+			     (mp->m_sb.sb_gquotino != NULLFSINO)) {
+			ino = mp->m_sb.sb_gquotino;
+			ASSERT(mp->m_sb.sb_pquotino == NULLFSINO);
+		} else if ((flags & XFS_QMOPT_GQUOTA) &&
+			     (mp->m_sb.sb_pquotino != NULLFSINO)) {
+			ino = mp->m_sb.sb_pquotino;
+			ASSERT(mp->m_sb.sb_gquotino == NULLFSINO);
+		}
+		if (ino != NULLFSINO) {
+			error = xfs_iget(mp, NULL, ino, 0, 0, ip);
+			if (error)
+				return error;
+			mp->m_sb.sb_gquotino = NULLFSINO;
+			mp->m_sb.sb_pquotino = NULLFSINO;
+		}
+	}
+
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_QINOCREATE);
 	if ((error = xfs_trans_reserve(tp,
 				      XFS_QM_QINOCREATE_SPACE_RES(mp),
@@ -844,11 +874,14 @@ xfs_qm_qino_alloc(
 		return error;
 	}
 
-	error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, 1, ip, &committed);
-	if (error) {
-		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
-				 XFS_TRANS_ABORT);
-		return error;
+	if (!*ip) {
+		error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, 1, ip,
+								&committed);
+		if (error) {
+			xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
+					 XFS_TRANS_ABORT);
+			return error;
+		}
 	}
 
 	/*
@@ -860,21 +893,25 @@ xfs_qm_qino_alloc(
 	if (flags & XFS_QMOPT_SBVERSION) {
 		ASSERT(!xfs_sb_version_hasquota(&mp->m_sb));
 		ASSERT((sbfields & (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
-				   XFS_SB_GQUOTINO | XFS_SB_QFLAGS)) ==
-		       (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
-			XFS_SB_GQUOTINO | XFS_SB_QFLAGS));
+			XFS_SB_GQUOTINO | XFS_SB_PQUOTINO | XFS_SB_QFLAGS)) ==
+				(XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
+				 XFS_SB_GQUOTINO | XFS_SB_PQUOTINO |
+				 XFS_SB_QFLAGS));
 
 		xfs_sb_version_addquota(&mp->m_sb);
 		mp->m_sb.sb_uquotino = NULLFSINO;
 		mp->m_sb.sb_gquotino = NULLFSINO;
+		mp->m_sb.sb_pquotino = NULLFSINO;
 
-		/* qflags will get updated _after_ quotacheck */
-		mp->m_sb.sb_qflags = 0;
+		/* qflags will get updated fully _after_ quotacheck */
+		mp->m_sb.sb_qflags = mp->m_qflags & XFS_ALL_QUOTA_ACCT;
 	}
 	if (flags & XFS_QMOPT_UQUOTA)
 		mp->m_sb.sb_uquotino = (*ip)->i_ino;
-	else
+	else if (flags & XFS_QMOPT_GQUOTA)
 		mp->m_sb.sb_gquotino = (*ip)->i_ino;
+	else
+		mp->m_sb.sb_pquotino = (*ip)->i_ino;
 	spin_unlock(&mp->m_sb_lock);
 	xfs_mod_sb(tp, sbfields);
 
@@ -1484,11 +1521,10 @@ xfs_qm_init_quotainos(
 			if (error)
 				goto error_rele;
 		}
-		/* XXX: Use gquotino for now */
 		if (XFS_IS_PQUOTA_ON(mp) &&
-		    mp->m_sb.sb_gquotino != NULLFSINO) {
-			ASSERT(mp->m_sb.sb_gquotino > 0);
-			error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
+		    mp->m_sb.sb_pquotino != NULLFSINO) {
+			ASSERT(mp->m_sb.sb_pquotino > 0);
+			error = xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
 					     0, 0, &pip);
 			if (error)
 				goto error_rele;
@@ -1496,7 +1532,8 @@ xfs_qm_init_quotainos(
 	} else {
 		flags |= XFS_QMOPT_SBVERSION;
 		sbflags |= (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
-			    XFS_SB_GQUOTINO | XFS_SB_QFLAGS);
+			    XFS_SB_GQUOTINO | XFS_SB_PQUOTINO |
+			    XFS_SB_QFLAGS);
 	}
 
 	/*
@@ -1524,9 +1561,8 @@ xfs_qm_init_quotainos(
 		flags &= ~XFS_QMOPT_SBVERSION;
 	}
 	if (XFS_IS_PQUOTA_ON(mp) && pip == NULL) {
-		/* XXX: Use XFS_SB_GQUOTINO for now */
 		error = xfs_qm_qino_alloc(mp, &pip,
-					  sbflags | XFS_SB_GQUOTINO,
+					  sbflags | XFS_SB_PQUOTINO,
 					  flags | XFS_QMOPT_PQUOTA);
 		if (error)
 			goto error_rele;
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index e4f8b2d..8d9e4c7 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -296,8 +296,10 @@ xfs_qm_scall_trunc_qfiles(
 
 	if (flags & XFS_DQ_USER)
 		error = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_uquotino);
-	if (flags & (XFS_DQ_GROUP|XFS_DQ_PROJ))
+	if (flags & XFS_DQ_GROUP)
 		error2 = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_gquotino);
+	if (flags & XFS_DQ_PROJ)
+		error2 = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_pquotino);
 
 	return error ? error : error2;
 }
@@ -413,8 +415,10 @@ xfs_qm_scall_getqstat(
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
 	struct xfs_inode	*uip = NULL;
 	struct xfs_inode	*gip = NULL;
+	struct xfs_inode	*pip = NULL;
 	bool                    tempuqip = false;
 	bool                    tempgqip = false;
+	bool                    temppqip = false;
 
 	memset(out, 0, sizeof(fs_quota_stat_t));
 
@@ -424,16 +428,14 @@ xfs_qm_scall_getqstat(
 		out->qs_gquota.qfs_ino = NULLFSINO;
 		return (0);
 	}
+
 	out->qs_flags = (__uint16_t) xfs_qm_export_flags(mp->m_qflags &
 							(XFS_ALL_QUOTA_ACCT|
 							 XFS_ALL_QUOTA_ENFD));
-	out->qs_pad = 0;
-	out->qs_uquota.qfs_ino = mp->m_sb.sb_uquotino;
-	out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
-
 	if (q) {
 		uip = q->qi_uquotaip;
 		gip = q->qi_gquotaip;
+		pip = q->qi_pquotaip;
 	}
 	if (!uip && mp->m_sb.sb_uquotino != NULLFSINO) {
 		if (xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
@@ -445,18 +447,41 @@ xfs_qm_scall_getqstat(
 					0, 0, &gip) == 0)
 			tempgqip = true;
 	}
+	/*
+	 * Q_XGETQSTAT doesn't have room for both group and project quotas.
+	 * So, allow the project quota values to be copied out only if
+	 * there is no group quota information available.
+	 */
+	if (!gip) {
+		if (!pip && mp->m_sb.sb_pquotino != NULLFSINO) {
+			if (xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
+						0, 0, &pip) == 0)
+				temppqip = true;
+		}
+	} else
+		pip = NULL;
 	if (uip) {
+		out->qs_uquota.qfs_ino = mp->m_sb.sb_uquotino;
 		out->qs_uquota.qfs_nblks = uip->i_d.di_nblocks;
 		out->qs_uquota.qfs_nextents = uip->i_d.di_nextents;
 		if (tempuqip)
 			IRELE(uip);
 	}
+
 	if (gip) {
+		out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
 		out->qs_gquota.qfs_nblks = gip->i_d.di_nblocks;
 		out->qs_gquota.qfs_nextents = gip->i_d.di_nextents;
 		if (tempgqip)
 			IRELE(gip);
 	}
+	if (pip) {
+		out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
+		out->qs_gquota.qfs_nblks = pip->i_d.di_nblocks;
+		out->qs_gquota.qfs_nextents = pip->i_d.di_nextents;
+		if (temppqip)
+			IRELE(pip);
+	}
 	if (q) {
 		out->qs_incoredqs = q->qi_dquots;
 		out->qs_btimelimit = q->qi_btimelimit;
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index 78f9e70..a6ff9d6 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -618,16 +618,23 @@ xfs_sb_has_incompat_log_feature(
 	return (sbp->sb_features_log_incompat & feature) != 0;
 }
 
-static inline bool
-xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
+static inline int xfs_sb_version_has_pquotino(xfs_sb_t *sbp)
 {
-	return (ino == sbp->sb_uquotino || ino == sbp->sb_gquotino);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
 }
 
 /*
  * end of superblock version macros
  */
 
+static inline bool
+xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
+{
+	return (ino == sbp->sb_uquotino ||
+		ino == sbp->sb_gquotino ||
+		ino == sbp->sb_pquotino);
+}
+
 #define XFS_SB_DADDR		((xfs_daddr_t)0) /* daddr in filesystem/ag */
 #define	XFS_SB_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_SB_DADDR)
 #define XFS_BUF_TO_SBP(bp)	((xfs_dsb_t *)((bp)->b_addr))
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 1d68ffc..525524e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -421,12 +421,6 @@ xfs_parseargs(
 	}
 #endif
 
-	if ((mp->m_qflags & (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE)) &&
-	    (mp->m_qflags & (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE))) {
-		xfs_warn(mp, "cannot mount with both project and group quota");
-		return EINVAL;
-	}
-
 	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
 		xfs_warn(mp, "sunit and swidth must be specified together");
 		return EINVAL;
@@ -556,14 +550,13 @@ xfs_showargs(
 	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
 		seq_puts(m, "," MNTOPT_UQUOTANOENF);
 
-	/* Either project or group quotas can be active, not both */
-
 	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
 		if (mp->m_qflags & XFS_PQUOTA_ENFD)
 			seq_puts(m, "," MNTOPT_PRJQUOTA);
 		else
 			seq_puts(m, "," MNTOPT_PQUOTANOENF);
-	} else if (mp->m_qflags & XFS_GQUOTA_ACCT) {
+	}
+	if (mp->m_qflags & XFS_GQUOTA_ACCT) {
 		if (mp->m_qflags & XFS_GQUOTA_ENFD)
 			seq_puts(m, "," MNTOPT_GRPQUOTA);
 		else
@@ -1396,6 +1389,14 @@ xfs_finish_flags(
 		return XFS_ERROR(EROFS);
 	}
 
+	if ((mp->m_qflags & (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE)) &&
+	    (mp->m_qflags & (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE)) &&
+	    !xfs_sb_version_has_pquotino(&mp->m_sb)) {
+		xfs_warn(mp,
+		  "Super block does not support project and group quota together");
+		return XFS_ERROR(EINVAL);
+	}
+
 	return 0;
 }
 
-- 
1.7.1



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
