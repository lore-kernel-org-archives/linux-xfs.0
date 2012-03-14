Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2EKREGJ248235 for <xfs@oss.sgi.com>; Wed, 14 Mar 2012 15:27:14 -0500
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154]) by
	cuda.sgi.com with ESMTP id vx5mGenmQ0iyBRjS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 14 Mar 2012 13:27:13 -0700 (PDT)
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 14 Mar 2012 14:27:12 -0600
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com
	[9.17.195.107])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 0D27919D8051
	for <xfs@oss.sgi.com>; Wed, 14 Mar 2012 14:27:05 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q2EKQiqD248370 for <xfs@oss.sgi.com>; Wed, 14 Mar 2012 14:26:52 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id q2EKQhT4024768
	for <xfs@oss.sgi.com>; Wed, 14 Mar 2012 14:26:43 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Wed, 14 Mar 2012 15:26:42 -0500
Message-Id: <20120314202641.17044.32835.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20120314202623.17044.90045.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20120314202623.17044.90045.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [RFC v5 PATCH 3/4] xfs: Add pquotaino to on-disk super block
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

>From 9d32afb9cc284b2511951c45b47f6a73dfd0a7e1 Mon Sep 17 00:00:00 2001
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Wed, 14 Mar 2012 14:26:20 -0500
Subject: [PATCH 3/4] Add a new field to the superblock to add support for seperate pquota
 with a specific version.

No change made yet to gather both project and group quota with quotactl.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_itable.c       |    3 +-
 fs/xfs/xfs_mount.c        |   58 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_qm.c           |   18 +++++++++----
 fs/xfs/xfs_qm_syscalls.c  |   30 +++++++++++++++++-----
 fs/xfs/xfs_quota.h        |    8 ------
 fs/xfs/xfs_sb.h           |   20 ++++++++++++---
 fs/xfs/xfs_super.c        |   15 +++++++----
 fs/xfs/xfs_trans_dquot.c  |    4 ++-
 include/linux/dqblk_xfs.h |    1 +
 9 files changed, 123 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 9720c54..0f0b439 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -43,7 +43,8 @@ xfs_internal_inum(
 {
 	return (ino == mp->m_sb.sb_rbmino || ino == mp->m_sb.sb_rsumino ||
 		(xfs_sb_version_hasquota(&mp->m_sb) &&
-		 (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino)));
+		 (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino ||
+		  ino == mp->m_sb.sb_pquotino)));
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 5d5d157..706209a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -108,6 +108,7 @@ static const struct {
     { offsetof(xfs_sb_t, sb_logsunit),	 0 },
     { offsetof(xfs_sb_t, sb_features2),	 0 },
     { offsetof(xfs_sb_t, sb_bad_features2), 0 },
+    { offsetof(xfs_sb_t, sb_pquotino), 0 },
     { sizeof(xfs_sb_t),			 0 }
 };
 
@@ -618,6 +619,35 @@ xfs_sb_from_disk(
 	to->sb_logsunit = be32_to_cpu(from->sb_logsunit);
 	to->sb_features2 = be32_to_cpu(from->sb_features2);
 	to->sb_bad_features2 = be32_to_cpu(from->sb_bad_features2);
+
+	if (xfs_sb_version_has_no_oquota(to)) {
+		if (to->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
+			xfs_notice(mp, "Super block has XFS_OQUOTA bits with "
+			"version NO_OQUOTA. Fixing it.\n");
+			to->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
+		}
+		to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
+	} else {
+		if (to->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
+					XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
+			xfs_notice(mp, "Super block has XFS_[G|P]UOTA bits in "
+				"older version. Fixing it.\n");
+			to->sb_qflags &= ~(XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
+					XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD);
+		}
+		if (to->sb_qflags & XFS_OQUOTA_ENFD)
+			to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
+					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
+		if (to->sb_qflags & XFS_OQUOTA_CHKD)
+			to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
+					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
+		to->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
+
+		if (to->sb_qflags & XFS_PQUOTA_ACCT) {
+			to->sb_pquotino = to->sb_gquotino;
+			to->sb_gquotino = NULLFSINO;
+		}
+	}
 }
 
 /*
@@ -637,11 +667,22 @@ xfs_sb_to_disk(
 	int		first;
 	int		size;
 	 __uint16_t	tmp16;
+	xfs_ino_t	gquotino;
 
 	ASSERT(fields);
 	if (!fields)
 		return;
 
+	/*
+	 * On-disk version earlier than NO_OQUOTA doesn't have sb_pquotino.
+	 * so, we need to copy the value to gquotino field.
+	 */
+	if (!xfs_sb_version_has_no_oquota(from) &&
+			(from->sb_qflags & (XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD)))
+		gquotino = from->sb_pquotino;
+	else
+		gquotino = from->sb_gquotino;
+
 	while (fields) {
 		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
 		first = xfs_sb_info[f].offset;
@@ -651,7 +692,8 @@ xfs_sb_to_disk(
 
 		if (size == 1 || xfs_sb_info[f].type == 1) {
 			memcpy(to_ptr + first, from_ptr + first, size);
-		} else if (f == XFS_SBS_QFLAGS) {
+		} else if ((f == XFS_SBS_QFLAGS) &&
+				 !xfs_sb_version_has_no_oquota(from)) {
 			/*
 			 * The in-core version of sb_qflags do not have
 			 * XFS_OQUOTA_* flags, whereas the on-disk version
@@ -671,6 +713,8 @@ xfs_sb_to_disk(
 				tmp16 |= XFS_OQUOTA_CHKD;
 
 			*(__be16 *)(to_ptr + first) = cpu_to_be16(tmp16);
+		} else if (f == XFS_SBS_GQUOTINO) {
+			*(__be64 *)(to_ptr + first) = cpu_to_be64(gquotino);
 		} else {
 			switch (size) {
 			case 2:
@@ -759,6 +803,12 @@ reread:
 		goto reread;
 	}
 
+	if (!xfs_sb_version_has_no_oquota(&mp->m_sb) &&
+			XFS_IS_PQUOTA_ON(mp)) {
+		mp->m_sb.sb_pquotino = mp->m_sb.sb_gquotino;
+		mp->m_sb.sb_gquotino = NULLFSINO;
+	}
+
 	/* Initialize per-cpu counters */
 	xfs_icsb_reinit_counters(mp);
 
@@ -1677,6 +1727,12 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fields)
 	first = sizeof(xfs_sb_t);
 	last = 0;
 
+	if (!xfs_sb_version_has_no_oquota(&mp->m_sb) &&
+			XFS_IS_PQUOTA_ON(mp)) {
+		fields &= (__int64_t)~XFS_SB_PQUOTINO;
+		fields |= (__int64_t)XFS_SB_GQUOTINO;
+	}
+
 	/* translate/copy */
 
 	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, fields);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 68c04c9..c3a2a9c 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -705,7 +705,8 @@ xfs_qm_dqattach_locked(
 	    !XFS_IS_QUOTA_ON(mp) ||
 	    !XFS_NOT_DQATTACHED(mp, ip) ||
 	    ip->i_ino == mp->m_sb.sb_uquotino ||
-	    ip->i_ino == mp->m_sb.sb_gquotino)
+	    ip->i_ino == mp->m_sb.sb_gquotino ||
+	    ip->i_ino == mp->m_sb.sb_pquotino)
 		return 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
@@ -816,6 +817,7 @@ xfs_qm_dqdetach(
 
 	ASSERT(ip->i_ino != ip->i_mount->m_sb.sb_uquotino);
 	ASSERT(ip->i_ino != ip->i_mount->m_sb.sb_gquotino);
+	ASSERT(ip->i_ino != ip->i_mount->m_sb.sb_pquotino);
 	if (ip->i_udquot) {
 		xfs_qm_dqrele(ip->i_udquot);
 		ip->i_udquot = NULL;
@@ -1055,19 +1057,22 @@ xfs_qm_qino_alloc(
 		ASSERT((sbfields & (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
 				   XFS_SB_GQUOTINO | XFS_SB_QFLAGS)) ==
 		       (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
-			XFS_SB_GQUOTINO | XFS_SB_QFLAGS));
+			XFS_SB_GQUOTINO | XFS_SB_PQUOTINO | XFS_SB_QFLAGS));
 
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
 
@@ -1374,7 +1379,8 @@ xfs_qm_dqusage_adjust(
 	 * rootino must have its resources accounted for, not so with the quota
 	 * inodes.
 	 */
-	if (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino) {
+	if (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino ||
+				ino == mp->m_sb.sb_pquotino) {
 		*res = BULKSTAT_RV_NOTHING;
 		return XFS_ERROR(EINVAL);
 	}
@@ -1634,7 +1640,7 @@ xfs_qm_init_quotainos(
 	} else {
 		flags |= XFS_QMOPT_SBVERSION;
 		sbflags |= (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
-			    XFS_SB_GQUOTINO | XFS_SB_QFLAGS);
+			    XFS_SB_GQUOTINO | XFS_SB_PQUOTINO | XFS_SB_QFLAGS);
 	}
 
 	/*
@@ -1664,7 +1670,7 @@ xfs_qm_init_quotainos(
 	}
 	if (XFS_IS_PQUOTA_ON(mp) && pip == NULL) {
 		error = xfs_qm_qino_alloc(mp, &pip,
-					     sbflags | XFS_SB_GQUOTINO,
+					     sbflags | XFS_SB_PQUOTINO,
 					     flags | XFS_QMOPT_PQUOTA);
 		if (error) {
 			if (uip)
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index c343973..832ec26 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -207,8 +207,7 @@ xfs_qm_scall_quotaoff(
 	/*
 	 * If quotas is completely disabled, close shop.
 	 */
-	if (((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_SET1) ||
-	    ((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_SET2)) {
+	if ((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_ALL) {
 		mutex_unlock(&q->qi_quotaofflock);
 		xfs_qm_destroy_quotainfo(mp);
 		return (0);
@@ -303,8 +302,10 @@ xfs_qm_scall_trunc_qfiles(
 
 	if (flags & XFS_DQ_USER)
 		error = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_uquotino);
-	if (flags & (XFS_DQ_GROUP|XFS_DQ_PROJ))
+	if (flags & XFS_DQ_GROUP)
 		error2 = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_gquotino);
+	if (flags & XFS_DQ_PROJ)
+		error2 = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_pquotino);
 
 	return error ? error : error2;
 }
@@ -420,17 +421,18 @@ xfs_qm_scall_getqstat(
 	struct fs_quota_stat	*out)
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	struct xfs_inode	*uip, *gip;
-	boolean_t		tempuqip, tempgqip;
+	struct xfs_inode	*uip, *gip, *pip;
+	boolean_t		tempuqip, tempgqip, temppqip;
 
-	uip = gip = NULL;
-	tempuqip = tempgqip = B_FALSE;
+	uip = gip = pip = NULL;
+	tempuqip = tempgqip = temppqip = B_FALSE;
 	memset(out, 0, sizeof(fs_quota_stat_t));
 
 	out->qs_version = FS_QSTAT_VERSION;
 	if (!xfs_sb_version_hasquota(&mp->m_sb)) {
 		out->qs_uquota.qfs_ino = NULLFSINO;
 		out->qs_gquota.qfs_ino = NULLFSINO;
+		out->qs_pquota.qfs_ino = NULLFSINO;
 		return (0);
 	}
 	out->qs_flags = (__uint16_t) xfs_qm_export_flags(mp->m_qflags &
@@ -439,10 +441,13 @@ xfs_qm_scall_getqstat(
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
@@ -454,6 +459,11 @@ xfs_qm_scall_getqstat(
 					0, 0, &gip) == 0)
 			tempgqip = B_TRUE;
 	}
+	if (!pip && mp->m_sb.sb_pquotino != NULLFSINO) {
+		if (xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
+					0, 0, &pip) == 0)
+			temppqip = B_TRUE;
+	}
 	if (uip) {
 		out->qs_uquota.qfs_nblks = uip->i_d.di_nblocks;
 		out->qs_uquota.qfs_nextents = uip->i_d.di_nextents;
@@ -466,6 +476,12 @@ xfs_qm_scall_getqstat(
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
index 1c61c9b..6e218ba 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -278,14 +278,6 @@ typedef struct xfs_qoff_logformat {
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
index 8fd7894..7373108 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -81,11 +81,15 @@ struct xfs_mount;
 #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
 #define XFS_SB_VERSION2_PARENTBIT	0x00000010	/* parent pointers */
 #define XFS_SB_VERSION2_PROJID32BIT	0x00000080	/* 32 bit project id */
+#define XFS_SB_VERSION2_NO_OQUOTA	0x00000100	/* No OQUOTA and     *
+							 * separate project  *
+							 * quota field       */
 
 #define	XFS_SB_VERSION2_OKREALFBITS	\
 	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
 	 XFS_SB_VERSION2_ATTR2BIT	| \
-	 XFS_SB_VERSION2_PROJID32BIT)
+	 XFS_SB_VERSION2_PROJID32BIT	| \
+	 XFS_SB_VERSION2_NO_OQUOTA)
 #define	XFS_SB_VERSION2_OKSASHFBITS	\
 	(0)
 #define XFS_SB_VERSION2_OKREALBITS	\
@@ -140,7 +144,6 @@ typedef struct xfs_sb {
 	 */
 	xfs_ino_t	sb_uquotino;	/* user quota inode */
 	xfs_ino_t	sb_gquotino;	/* group quota inode */
-#define sb_pquotino	sb_gquotino
 	__uint16_t	sb_qflags;	/* quota flags */
 	__uint8_t	sb_flags;	/* misc. flags */
 	__uint8_t	sb_shared_vn;	/* shared version number */
@@ -160,6 +163,7 @@ typedef struct xfs_sb {
 	 * it for anything else.
 	 */
 	__uint32_t	sb_bad_features2;
+	xfs_ino_t	sb_pquotino;	/* project quota inode */
 
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
@@ -230,6 +234,7 @@ typedef struct xfs_dsb {
 	 * it for anything else.
 	 */
 	__be32	sb_bad_features2;
+	__be64		sb_pquotino;	/* project quota inode */
 
 	/* must be padded to 64 bit alignment */
 } xfs_dsb_t;
@@ -250,7 +255,7 @@ typedef enum {
 	XFS_SBS_GQUOTINO, XFS_SBS_QFLAGS, XFS_SBS_FLAGS, XFS_SBS_SHARED_VN,
 	XFS_SBS_INOALIGNMT, XFS_SBS_UNIT, XFS_SBS_WIDTH, XFS_SBS_DIRBLKLOG,
 	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
-	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2,
+	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2, XFS_SBS_PQUOTINO,
 	XFS_SBS_FIELDCOUNT
 } xfs_sb_field_t;
 
@@ -276,6 +281,7 @@ typedef enum {
 #define XFS_SB_FDBLOCKS		XFS_SB_MVAL(FDBLOCKS)
 #define XFS_SB_FEATURES2	XFS_SB_MVAL(FEATURES2)
 #define XFS_SB_BAD_FEATURES2	XFS_SB_MVAL(BAD_FEATURES2)
+#define XFS_SB_PQUOTINO		XFS_SB_MVAL(PQUOTINO)
 #define	XFS_SB_NUM_BITS		((int)XFS_SBS_FIELDCOUNT)
 #define	XFS_SB_ALL_BITS		((1LL << XFS_SB_NUM_BITS) - 1)
 #define	XFS_SB_MOD_BITS		\
@@ -283,7 +289,7 @@ typedef enum {
 	 XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO | XFS_SB_GQUOTINO | \
 	 XFS_SB_QFLAGS | XFS_SB_SHARED_VN | XFS_SB_UNIT | XFS_SB_WIDTH | \
 	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2 | \
-	 XFS_SB_BAD_FEATURES2)
+	 XFS_SB_BAD_FEATURES2 | XFS_SB_PQUOTINO)
 
 
 /*
@@ -504,6 +510,12 @@ static inline int xfs_sb_version_hasprojid32bit(xfs_sb_t *sbp)
 		(sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT);
 }
 
+static inline int xfs_sb_version_has_no_oquota(xfs_sb_t *sbp)
+{
+	return xfs_sb_version_hasmorebits(sbp) &&
+		(sbp->sb_features2 & XFS_SB_VERSION2_NO_OQUOTA);
+}
+
 /*
  * end of superblock version macros
  */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 678c138..b8624d5 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -400,12 +400,6 @@ xfs_parseargs(
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
@@ -1317,6 +1311,15 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_destroy_counters;
 
+	if ((mp->m_qflags & (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE)) &&
+	    (mp->m_qflags & (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE)) &&
+	    !xfs_sb_version_has_no_oquota(&mp->m_sb)) {
+		xfs_warn(mp, "Super block does not support "
+				 "project and group quota together");
+		error = EINVAL;
+		goto out_free_sb;
+	}
+
 	error = xfs_finish_flags(mp);
 	if (error)
 		goto out_free_sb;
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 61a545d..01b276c 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -165,7 +165,8 @@ xfs_trans_mod_dquot_byino(
 	if (!XFS_IS_QUOTA_RUNNING(mp) ||
 	    !XFS_IS_QUOTA_ON(mp) ||
 	    ip->i_ino == mp->m_sb.sb_uquotino ||
-	    ip->i_ino == mp->m_sb.sb_gquotino)
+	    ip->i_ino == mp->m_sb.sb_gquotino ||
+	    ip->i_ino == mp->m_sb.sb_pquotino)
 		return;
 
 	if (tp->t_dqinfo == NULL)
@@ -858,6 +859,7 @@ xfs_trans_reserve_quota_nblks(
 
 	ASSERT(ip->i_ino != mp->m_sb.sb_uquotino);
 	ASSERT(ip->i_ino != mp->m_sb.sb_gquotino);
+	ASSERT(ip->i_ino != mp->m_sb.sb_pquotino);
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES | XFS_QMOPT_ENOSPC)) ==
diff --git a/include/linux/dqblk_xfs.h b/include/linux/dqblk_xfs.h
index 8655280..f17e3bb 100644
--- a/include/linux/dqblk_xfs.h
+++ b/include/linux/dqblk_xfs.h
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
