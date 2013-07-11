Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3C1087F62
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 00:01:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D8E61AC002
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 22:01:00 -0700 (PDT)
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158]) by
	cuda.sgi.com with ESMTP id VUDZzhIPNX3NgFCA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Jul 2013 22:00:59 -0700 (PDT)
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 10 Jul 2013 23:00:58 -0600
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id F319119D804E
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 23:00:45 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r6B50uU1125862 for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 23:00:56 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r6B50tB2005470
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 23:00:55 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v11 2/4] xfs: Start using pquotaino from the superblock.
Date: Thu, 11 Jul 2013 00:00:41 -0500
Message-Id: <1373518843-1492-3-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1373518843-1492-1-git-send-email-sekharan@us.ibm.com>
References: <1373518843-1492-1-git-send-email-sekharan@us.ibm.com>
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
 fs/xfs/xfs_mount.c             |   62 ++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_qm.c                |   28 +++++++++--------
 fs/xfs/xfs_qm_syscalls.c       |   21 +++++++++++++-
 fs/xfs/xfs_sb.h                |    9 +++++-
 fs/xfs/xfs_super.c             |   19 ++++++------
 include/uapi/linux/dqblk_xfs.h |    1 +
 6 files changed, 108 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 2b0ba35..b8a633b 100644
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
@@ -570,8 +575,13 @@ out_unwind:
 }
 
 static void
-xfs_sb_quota_from_disk(struct xfs_sb *sbp)
+xfs_sb_quota_from_disk(struct xfs_mount *mp)
 {
+	struct xfs_sb *sbp = &mp->m_sb;
+
+	if (xfs_sb_version_has_pquota(sbp))
+		return;
+
 	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
 		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
 					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
@@ -579,6 +589,18 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
 		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
 					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
 	sbp->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
+
+	if (!xfs_sb_version_has_pquota(sbp) && (XFS_IS_PQUOTA_ON(mp))) {
+		/*
+		 * On disk superblock only has sb_gquotino, and incore
+		 * superblock has both sb_gquotino and sb_pquotino.
+		 * But, only one them is supported at any point of time.
+		 * So, if PQUOTA is set in disk superblock, copy over
+		 * sb_gquotino to sb_pquotino.
+		 */
+		mp->m_sb.sb_pquotino = mp->m_sb.sb_gquotino;
+		mp->m_sb.sb_gquotino = NULLFSINO;
+	}
 }
 
 void
@@ -650,6 +672,13 @@ xfs_sb_quota_to_disk(
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
@@ -669,6 +698,23 @@ xfs_sb_quota_to_disk(
 		to->sb_qflags = cpu_to_be16(qflags);
 		*fields &= ~XFS_SB_QFLAGS;
 	}
+
+	if (*fields & XFS_SB_PQUOTINO && *fields & XFS_SB_GQUOTINO) {
+		/*
+		 * PQUOTINO and GQUOTINO cannot be used together in versions
+		 * of superblock that do not have pquotino. If used, use
+		 * sb_flags to resolve which one should be set.
+		*/
+		if (from->sb_qflags & XFS_PQUOTA_ACCT)
+			*fields &= ~XFS_SB_GQUOTINO;
+		else
+			*fields &= ~XFS_SB_PQUOTINO;
+	}
+
+	if (*fields & XFS_SB_PQUOTINO) {
+		to->sb_gquotino = cpu_to_be64(from->sb_pquotino);
+		*fields &= ~XFS_SB_PQUOTINO;
+	}
 }
 
 /*
@@ -885,7 +931,7 @@ reread:
 	 */
 	xfs_sb_from_disk(&mp->m_sb, XFS_BUF_TO_SBP(bp));
 
-	xfs_sb_quota_from_disk(&mp->m_sb);
+	xfs_sb_quota_from_disk(mp);
 	/*
 	 * We must be able to do sector-sized and sector-aligned IO.
 	 */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index d320794..ba12dc4 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -860,21 +860,24 @@ xfs_qm_qino_alloc(
 	if (flags & XFS_QMOPT_SBVERSION) {
 		ASSERT(!xfs_sb_version_hasquota(&mp->m_sb));
 		ASSERT((sbfields & (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
-				   XFS_SB_GQUOTINO | XFS_SB_QFLAGS)) ==
-		       (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
-			XFS_SB_GQUOTINO | XFS_SB_QFLAGS));
+			XFS_SB_GQUOTINO | XFS_SB_PQUOTINO | XFS_SB_QFLAGS)) ==
+				(XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
+                        XFS_SB_GQUOTINO | XFS_SB_PQUOTINO | XFS_SB_QFLAGS));
 
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
 
@@ -1484,11 +1487,10 @@ xfs_qm_init_quotainos(
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
@@ -1496,7 +1498,8 @@ xfs_qm_init_quotainos(
 	} else {
 		flags |= XFS_QMOPT_SBVERSION;
 		sbflags |= (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
-			    XFS_SB_GQUOTINO | XFS_SB_QFLAGS);
+			    XFS_SB_GQUOTINO | XFS_SB_PQUOTINO |
+			    XFS_SB_QFLAGS);
 	}
 
 	/*
@@ -1524,9 +1527,8 @@ xfs_qm_init_quotainos(
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
index e4f8b2d..132e811 100644
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
 
@@ -422,6 +426,7 @@ xfs_qm_scall_getqstat(
 	if (!xfs_sb_version_hasquota(&mp->m_sb)) {
 		out->qs_uquota.qfs_ino = NULLFSINO;
 		out->qs_gquota.qfs_ino = NULLFSINO;
+		out->qs_pquota.qfs_ino = NULLFSINO;
 		return (0);
 	}
 	out->qs_flags = (__uint16_t) xfs_qm_export_flags(mp->m_qflags &
@@ -430,10 +435,13 @@ xfs_qm_scall_getqstat(
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
@@ -445,6 +453,11 @@ xfs_qm_scall_getqstat(
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
@@ -457,6 +470,12 @@ xfs_qm_scall_getqstat(
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
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index 78f9e70..d372fdf 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -621,7 +621,14 @@ xfs_sb_has_incompat_log_feature(
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
 }
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 1d68ffc..5ade637 100644
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
