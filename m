Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DF8C87F37
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 21:49:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CC2E88F8035
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 19:49:05 -0700 (PDT)
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154]) by
	cuda.sgi.com with ESMTP id 2bYKfptnlTrLlyR2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 23 Jun 2013 19:49:04 -0700 (PDT)
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Sun, 23 Jun 2013 20:48:55 -0600
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 3B35F3E40044
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 20:48:17 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5O2magA137422 for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 20:48:36 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r5O2ma8n008686
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 20:48:36 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v9 4/6] xfs: Start using pquotaino from the superblock.
Date: Sun, 23 Jun 2013 21:48:25 -0500
Message-Id: <1372042107-27332-5-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1372042107-27332-1-git-send-email-sekharan@us.ibm.com>
References: <1372042107-27332-1-git-send-email-sekharan@us.ibm.com>
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Start using pquotino and define a macro to check if the
superblock has pquotino.

Keep backward compatibilty by alowing mount of older superblock
with no separate pquota inode.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_fsops.c             |    3 +-
 fs/xfs/xfs_mount.c             |   51 +++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_qm.c                |   22 +++++++++--------
 fs/xfs/xfs_qm_syscalls.c       |   24 ++++++++++++++++--
 fs/xfs/xfs_quota.h             |    8 ------
 fs/xfs/xfs_sb.h                |   16 +++++++++++-
 fs/xfs/xfs_super.c             |   14 ++++++----
 include/uapi/linux/dqblk_xfs.h |    1 +
 8 files changed, 99 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 614eb0c..3bf05f4 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -501,7 +501,8 @@ xfs_growfs_data_private(
 				error, agno);
 			break;
 		}
-		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, XFS_SB_ALL_BITS);
+		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb,
+				xfs_sb_all_bits(&mp->m_sb));
 
 		/*
 		 * If we get an error writing out the alternate superblocks,
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index e2e14cb..bb7b23e 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -336,12 +336,17 @@ xfs_mount_validate_sb(
 		return XFS_ERROR(EWRONGFS);
 	}
 
-	if ((sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) &&
-			(sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
-				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))) {
-		xfs_notice(mp,
-"Super block has XFS_OQUOTA bits along with XFS_PQUOTA and/or XFS_GQUOTA bits.\n");
-		return XFS_ERROR(EFSCORRUPTED);
+	if (xfs_sb_version_has_pquota(sbp)) {
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
 	}
 
 	/*
@@ -638,6 +643,13 @@ xfs_handle_quota_to_disk(
 {
 	__uint16_t	qflags = from->sb_qflags;
 
+	/*
+	 * We need to do these manipilations only if we are working
+	 * with an older version of on-disk superblock.
+	 */
+	if (xfs_sb_version_has_pquota(from))
+		return;
+
 	if (*fields & XFS_SB_QFLAGS) {
 		/*
 		 * The in-core version of sb_qflags do not have
@@ -657,6 +669,10 @@ xfs_handle_quota_to_disk(
 		to->sb_qflags = cpu_to_be16(qflags);
 		*fields &= ~XFS_SB_QFLAGS;
 	}
+	if (*fields & XFS_SB_PQUOTINO) {
+		to->sb_gquotino = cpu_to_be64(from->sb_pquotino);
+		*fields &= ~XFS_SB_PQUOTINO;
+	}
 }
 
 /*
@@ -873,13 +889,26 @@ reread:
 	 */
 	xfs_sb_from_disk(&mp->m_sb, XFS_BUF_TO_SBP(bp));
 
-	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
-		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
+	if (!xfs_sb_version_has_pquota(&mp->m_sb)) {
+		if (XFS_IS_PQUOTA_ON(mp)) {
+			/*
+			 * On disk superblock only has sb_gquotino, and incore
+			 * superblock has both sb_gquotino and sb_pquotino.
+			 * But, only one them is supported at any point of time.
+			 * So, if PQUOTA is set in disk superblock, copy over
+			 * sb_gquotino to sb_pquotino.
+			 */
+			mp->m_sb.sb_pquotino = mp->m_sb.sb_gquotino;
+			mp->m_sb.sb_gquotino = NULLFSINO;
+		}
+		if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
+			sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
 					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
-	if (sbp->sb_qflags & XFS_OQUOTA_CHKD)
-		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
+		if (sbp->sb_qflags & XFS_OQUOTA_CHKD)
+			sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
 					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
-	sbp->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
+		sbp->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
+	}
 
 	/*
 	 * We must be able to do sector-sized and sector-aligned IO.
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b3e05ef..12abcf0 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -859,22 +859,21 @@ xfs_qm_qino_alloc(
 	spin_lock(&mp->m_sb_lock);
 	if (flags & XFS_QMOPT_SBVERSION) {
 		ASSERT(!xfs_sb_version_hasquota(&mp->m_sb));
-		ASSERT((sbfields & (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
-				   XFS_SB_GQUOTINO | XFS_SB_QFLAGS)) ==
-		       (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
-			XFS_SB_GQUOTINO | XFS_SB_QFLAGS));
 
 		xfs_sb_version_addquota(&mp->m_sb);
 		mp->m_sb.sb_uquotino = NULLFSINO;
 		mp->m_sb.sb_gquotino = NULLFSINO;
+		mp->m_sb.sb_pquotino = NULLFSINO;
 
 		/* qflags will get updated _after_ quotacheck */
 		mp->m_sb.sb_qflags = 0;
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
 
@@ -1484,11 +1483,10 @@ xfs_qm_init_quotainos(
 			if (error)
 				goto error_rele;
 		}
-		/* Use gquotino for now */
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
@@ -1497,6 +1495,8 @@ xfs_qm_init_quotainos(
 		flags |= XFS_QMOPT_SBVERSION;
 		sbflags |= (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
 			    XFS_SB_GQUOTINO | XFS_SB_QFLAGS);
+		if (xfs_sb_version_has_pquota(&mp->m_sb))
+			sbflags |= XFS_SB_PQUOTINO;
 	}
 
 	/*
@@ -1524,8 +1524,10 @@ xfs_qm_init_quotainos(
 		flags &= ~XFS_QMOPT_SBVERSION;
 	}
 	if (XFS_IS_PQUOTA_ON(mp) && pip == NULL) {
+		if (!xfs_sb_version_has_pquota(&mp->m_sb))
+			sbflags &= ~XFS_SB_GQUOTINO;
 		error = xfs_qm_qino_alloc(mp, &pip,
-					  sbflags | XFS_SB_GQUOTINO,
+					  sbflags | XFS_SB_PQUOTINO,
 					  flags | XFS_QMOPT_PQUOTA);
 		if (error)
 			goto error_rele;
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index ed7cd55..d664a2d 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -201,8 +201,7 @@ xfs_qm_scall_quotaoff(
 	/*
 	 * If quotas is completely disabled, close shop.
 	 */
-	if (((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_SET1) ||
-	    ((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_SET2)) {
+	if ((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_ALL) {
 		mutex_unlock(&q->qi_quotaofflock);
 		xfs_qm_destroy_quotainfo(mp);
 		return (0);
@@ -297,8 +296,10 @@ xfs_qm_scall_trunc_qfiles(
 
 	if (flags & XFS_DQ_USER)
 		error = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_uquotino);
-	if (flags & (XFS_DQ_GROUP|XFS_DQ_PROJ))
+	if (flags & XFS_DQ_GROUP)
 		error2 = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_gquotino);
+	if (flags & XFS_DQ_PROJ)
+		error2 = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_pquotino);
 
 	return error ? error : error2;
 }
@@ -414,8 +415,10 @@ xfs_qm_scall_getqstat(
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
 	struct xfs_inode	*uip = NULL;
 	struct xfs_inode	*gip = NULL;
+	struct xfs_inode	*pip = NULL;
 	bool                    tempuqip = false;
 	bool                    tempgqip = false;
+	bool                    temppqip = false;
 
 	memset(out, 0, sizeof(fs_quota_stat_t));
 
@@ -423,6 +426,7 @@ xfs_qm_scall_getqstat(
 	if (!xfs_sb_version_hasquota(&mp->m_sb)) {
 		out->qs_uquota.qfs_ino = NULLFSINO;
 		out->qs_gquota.qfs_ino = NULLFSINO;
+		out->qs_pquota.qfs_ino = NULLFSINO;
 		return (0);
 	}
 	out->qs_flags = (__uint16_t) xfs_qm_export_flags(mp->m_qflags &
@@ -431,10 +435,13 @@ xfs_qm_scall_getqstat(
 	out->qs_pad = 0;
 	out->qs_uquota.qfs_ino = mp->m_sb.sb_uquotino;
 	out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
+	if (&out->qs_gquota != &out->qs_pquota)
+		out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
 
 	if (q) {
 		uip = q->qi_uquotaip;
 		gip = q->qi_gquotaip;
+		pip = q->qi_pquotaip;
 	}
 	if (!uip && mp->m_sb.sb_uquotino != NULLFSINO) {
 		if (xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
@@ -446,6 +453,11 @@ xfs_qm_scall_getqstat(
 					0, 0, &gip) == 0)
 			tempgqip = true;
 	}
+	if (!pip && mp->m_sb.sb_pquotino != NULLFSINO) {
+		if (xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
+					0, 0, &pip) == 0)
+			temppqip = true;
+	}
 	if (uip) {
 		out->qs_uquota.qfs_nblks = uip->i_d.di_nblocks;
 		out->qs_uquota.qfs_nextents = uip->i_d.di_nextents;
@@ -458,6 +470,12 @@ xfs_qm_scall_getqstat(
 		if (tempgqip)
 			IRELE(gip);
 	}
+	if (pip) {
+		out->qs_pquota.qfs_nblks = pip->i_d.di_nblocks;
+		out->qs_pquota.qfs_nextents = pip->i_d.di_nextents;
+		if (temppqip)
+			IRELE(pip);
+	}
 	if (q) {
 		out->qs_incoredqs = q->qi_dquots;
 		out->qs_btimelimit = q->qi_btimelimit;
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index d7668f9..e59725c 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -287,14 +287,6 @@ typedef struct xfs_qoff_logformat {
 	 (XFS_IS_PQUOTA_ON(mp) && \
 		(mp->m_sb.sb_qflags & XFS_PQUOTA_CHKD) == 0))
 
-#define XFS_MOUNT_QUOTA_SET1	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
-				 XFS_UQUOTA_CHKD|XFS_PQUOTA_ACCT|\
-				 XFS_PQUOTA_ENFD|XFS_PQUOTA_CHKD)
-
-#define XFS_MOUNT_QUOTA_SET2	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
-				 XFS_UQUOTA_CHKD|XFS_GQUOTA_ACCT|\
-				 XFS_GQUOTA_ENFD|XFS_GQUOTA_CHKD)
-
 #define XFS_MOUNT_QUOTA_ALL	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
 				 XFS_UQUOTA_CHKD|XFS_PQUOTA_ACCT|\
 				 XFS_PQUOTA_ENFD|XFS_PQUOTA_CHKD|\
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index 78f9e70..d1d2407 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -621,7 +621,21 @@ xfs_sb_has_incompat_log_feature(
 static inline bool
 xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
 {
-	return (ino == sbp->sb_uquotino || ino == sbp->sb_gquotino);
+	return (ino == sbp->sb_uquotino ||
+		ino == sbp->sb_gquotino ||
+		ino == sbp->sb_pquotino);
+}
+
+static inline int xfs_sb_version_has_pquota(xfs_sb_t *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
+}
+
+static inline __int64_t xfs_sb_all_bits(xfs_sb_t *sbp)
+{
+	if (xfs_sb_version_has_pquota(sbp))
+		return XFS_SB_ALL_BITS;
+	return XFS_SB_ALL_BITS & ~XFS_SB_PQUOTINO;
 }
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2a76ba2..1bcc017 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -420,12 +420,6 @@ xfs_parseargs(
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
@@ -1400,6 +1394,14 @@ xfs_finish_flags(
 		return XFS_ERROR(EROFS);
 	}
 
+	if ((mp->m_qflags & (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE)) &&
+	    (mp->m_qflags & (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE)) &&
+	    !xfs_sb_version_has_pquota(&mp->m_sb)) {
+		xfs_warn(mp,
+		  "Super block does not support project and group quota together");
+		return XFS_ERROR(EINVAL);
+	}
+
 	return 0;
 }
 
diff --git a/include/uapi/linux/dqblk_xfs.h b/include/uapi/linux/dqblk_xfs.h
index 8655280..f17e3bb 100644
--- a/include/uapi/linux/dqblk_xfs.h
+++ b/include/uapi/linux/dqblk_xfs.h
@@ -155,6 +155,7 @@ typedef struct fs_quota_stat {
 	__s8		qs_pad;		/* unused */
 	fs_qfilestat_t	qs_uquota;	/* user quota storage information */
 	fs_qfilestat_t	qs_gquota;	/* group quota storage information */
+#define qs_pquota	qs_gquota
 	__u32		qs_incoredqs;	/* number of dquots incore */
 	__s32		qs_btimelimit;  /* limit for blks timer */	
 	__s32		qs_itimelimit;  /* limit for inodes timer */	
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
