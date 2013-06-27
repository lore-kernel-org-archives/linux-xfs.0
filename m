Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8342C7F54
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 17:25:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 34E078F804C
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 15:25:32 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id q5C5YRJHa9j93xet (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Jun 2013 15:25:30 -0700 (PDT)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 27 Jun 2013 18:25:29 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id CC6BFC9003E
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 18:25:26 -0400 (EDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5RMPRYH275412 for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 18:25:27 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r5RMPQvD018642
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:25:26 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v10 04/11] xfs: Code cleanup and removal of some typedef usage
Date: Thu, 27 Jun 2013 17:25:07 -0500
Message-Id: <1372371914-11370-5-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
References: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
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

In preparation for combined pquota/gquota support, for the sake
of readability, do some code cleanup surrounding the affected
code.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_dquot.c       |   12 ++--
 fs/xfs/xfs_icache.c      |    3 +-
 fs/xfs/xfs_qm.c          |  152 ++++++++++++++++++++++++----------------------
 fs/xfs/xfs_qm.h          |   37 ++++++-----
 fs/xfs/xfs_qm_syscalls.c |    8 +-
 fs/xfs/xfs_symlink.c     |    3 +-
 fs/xfs/xfs_trans_dquot.c |   46 ++++++--------
 7 files changed, 135 insertions(+), 126 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 7d184de..f01012d 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -570,13 +570,13 @@ xfs_qm_dqtobp(
 	xfs_buf_t		**O_bpp,
 	uint			flags)
 {
-	xfs_bmbt_irec_t map;
-	int		nmaps = 1, error;
-	xfs_buf_t	*bp;
+	struct xfs_bmbt_irec	map;
+	int			nmaps = 1, error;
+	struct xfs_buf		*bp;
 	struct xfs_inode	*quotip = xfs_dq_to_quota_inode(dqp);
-	xfs_mount_t	*mp = dqp->q_mount;
-	xfs_dqid_t	id = be32_to_cpu(dqp->q_core.d_id);
-	xfs_trans_t	*tp = (tpp ? *tpp : NULL);
+	struct xfs_mount	*mp = dqp->q_mount;
+	xfs_dqid_t		id = be32_to_cpu(dqp->q_core.d_id);
+	struct xfs_trans	*tp = (tpp ? *tpp : NULL);
 
 	dqp->q_fileoffset = (xfs_fileoff_t)id / mp->m_quotainfo->qi_dqperchunk;
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 96e344e..9560dc1 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -335,7 +335,8 @@ xfs_iget_cache_miss(
 	iflags = XFS_INEW;
 	if (flags & XFS_IGET_DONTCACHE)
 		iflags |= XFS_IDONTCACHE;
-	ip->i_udquot = ip->i_gdquot = NULL;
+	ip->i_udquot = NULL;
+	ip->i_gdquot = NULL;
 	xfs_iflags_set(ip, iflags);
 
 	/* insert the new inode */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 8e707d3..cf09aa8 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1260,19 +1260,20 @@ int
 xfs_qm_quotacheck(
 	xfs_mount_t	*mp)
 {
-	int		done, count, error, error2;
-	xfs_ino_t	lastino;
-	size_t		structsz;
-	xfs_inode_t	*uip, *gip;
-	uint		flags;
-	LIST_HEAD	(buffer_list);
+	int			done, count, error, error2;
+	xfs_ino_t		lastino;
+	size_t			structsz;
+	uint			flags;
+	LIST_HEAD		(buffer_list);
+	struct xfs_inode	*uip = mp->m_quotainfo->qi_uquotaip;
+	struct xfs_inode	*gip = mp->m_quotainfo->qi_gquotaip;
 
 	count = INT_MAX;
 	structsz = 1;
 	lastino = 0;
 	flags = 0;
 
-	ASSERT(mp->m_quotainfo->qi_uquotaip || mp->m_quotainfo->qi_gquotaip);
+	ASSERT(uip || gip);
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
 	xfs_notice(mp, "Quotacheck needed: Please wait.");
@@ -1282,7 +1283,6 @@ xfs_qm_quotacheck(
 	 * their counters to zero. We need a clean slate.
 	 * We don't log our changes till later.
 	 */
-	uip = mp->m_quotainfo->qi_uquotaip;
 	if (uip) {
 		error = xfs_qm_dqiterate(mp, uip, XFS_QMOPT_UQUOTA,
 					 &buffer_list);
@@ -1291,7 +1291,6 @@ xfs_qm_quotacheck(
 		flags |= XFS_UQUOTA_CHKD;
 	}
 
-	gip = mp->m_quotainfo->qi_gquotaip;
 	if (gip) {
 		error = xfs_qm_dqiterate(mp, gip, XFS_IS_GQUOTA_ON(mp) ?
 					 XFS_QMOPT_GQUOTA : XFS_QMOPT_PQUOTA,
@@ -1393,15 +1392,13 @@ STATIC int
 xfs_qm_init_quotainos(
 	xfs_mount_t	*mp)
 {
-	xfs_inode_t	*uip, *gip;
-	int		error;
-	__int64_t	sbflags;
-	uint		flags;
+	struct xfs_inode	*uip = NULL;
+	struct xfs_inode	*gip = NULL;
+	int			error;
+	__int64_t		sbflags = 0;
+	uint			flags = 0;
 
 	ASSERT(mp->m_quotainfo);
-	uip = gip = NULL;
-	sbflags = 0;
-	flags = 0;
 
 	/*
 	 * Get the uquota and gquota inodes
@@ -1410,19 +1407,18 @@ xfs_qm_init_quotainos(
 		if (XFS_IS_UQUOTA_ON(mp) &&
 		    mp->m_sb.sb_uquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_uquotino > 0);
-			if ((error = xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
-					     0, 0, &uip)))
+			error = xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
+					     0, 0, &uip);
+			if (error)
 				return XFS_ERROR(error);
 		}
 		if (XFS_IS_OQUOTA_ON(mp) &&
 		    mp->m_sb.sb_gquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_gquotino > 0);
-			if ((error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
-					     0, 0, &gip))) {
-				if (uip)
-					IRELE(uip);
-				return XFS_ERROR(error);
-			}
+			error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
+					     0, 0, &gip);
+			if (error)
+				goto error_rele;
 		}
 	} else {
 		flags |= XFS_QMOPT_SBVERSION;
@@ -1437,10 +1433,11 @@ xfs_qm_init_quotainos(
 	 * temporarily switch to read-write to do this.
 	 */
 	if (XFS_IS_UQUOTA_ON(mp) && uip == NULL) {
-		if ((error = xfs_qm_qino_alloc(mp, &uip,
+		error = xfs_qm_qino_alloc(mp, &uip,
 					      sbflags | XFS_SB_UQUOTINO,
-					      flags | XFS_QMOPT_UQUOTA)))
-			return XFS_ERROR(error);
+					      flags | XFS_QMOPT_UQUOTA);
+		if (error)
+			goto error_rele;
 
 		flags &= ~XFS_QMOPT_SBVERSION;
 	}
@@ -1449,18 +1446,21 @@ xfs_qm_init_quotainos(
 				XFS_QMOPT_GQUOTA : XFS_QMOPT_PQUOTA);
 		error = xfs_qm_qino_alloc(mp, &gip,
 					  sbflags | XFS_SB_GQUOTINO, flags);
-		if (error) {
-			if (uip)
-				IRELE(uip);
-
-			return XFS_ERROR(error);
-		}
+		if (error)
+			goto error_rele;
 	}
 
 	mp->m_quotainfo->qi_uquotaip = uip;
 	mp->m_quotainfo->qi_gquotaip = gip;
 
 	return 0;
+
+error_rele:
+	if (uip)
+		IRELE(uip);
+	if (gip)
+		IRELE(gip);
+	return XFS_ERROR(error);
 }
 
 STATIC void
@@ -1657,7 +1657,8 @@ xfs_qm_vop_dqalloc(
 	struct xfs_dquot	**O_gdqpp)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_dquot	*uq, *gq;
+	struct xfs_dquot	*uq = NULL;
+	struct xfs_dquot	*gq = NULL;
 	int			error;
 	uint			lockflags;
 
@@ -1682,7 +1683,6 @@ xfs_qm_vop_dqalloc(
 		}
 	}
 
-	uq = gq = NULL;
 	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
 		if (ip->i_d.di_uid != uid) {
 			/*
@@ -1695,11 +1695,12 @@ xfs_qm_vop_dqalloc(
 			 * holding ilock.
 			 */
 			xfs_iunlock(ip, lockflags);
-			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t) uid,
+			error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t) uid,
 						 XFS_DQ_USER,
 						 XFS_QMOPT_DQALLOC |
 						 XFS_QMOPT_DOWARN,
-						 &uq))) {
+						 &uq);
+			if (error) {
 				ASSERT(error != ENOENT);
 				return error;
 			}
@@ -1721,15 +1722,14 @@ xfs_qm_vop_dqalloc(
 	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
 		if (ip->i_d.di_gid != gid) {
 			xfs_iunlock(ip, lockflags);
-			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)gid,
+			error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)gid,
 						 XFS_DQ_GROUP,
 						 XFS_QMOPT_DQALLOC |
 						 XFS_QMOPT_DOWARN,
-						 &gq))) {
-				if (uq)
-					xfs_qm_dqrele(uq);
+						 &gq);
+			if (error) {
 				ASSERT(error != ENOENT);
-				return error;
+				goto error_rele;
 			}
 			xfs_dqunlock(gq);
 			lockflags = XFS_ILOCK_SHARED;
@@ -1741,15 +1741,14 @@ xfs_qm_vop_dqalloc(
 	} else if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
 		if (xfs_get_projid(ip) != prid) {
 			xfs_iunlock(ip, lockflags);
-			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)prid,
+			error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)prid,
 						 XFS_DQ_PROJ,
 						 XFS_QMOPT_DQALLOC |
 						 XFS_QMOPT_DOWARN,
-						 &gq))) {
-				if (uq)
-					xfs_qm_dqrele(uq);
+						 &gq);
+			if (error) {
 				ASSERT(error != ENOENT);
-				return (error);
+				goto error_rele;
 			}
 			xfs_dqunlock(gq);
 			lockflags = XFS_ILOCK_SHARED;
@@ -1772,6 +1771,11 @@ xfs_qm_vop_dqalloc(
 	else if (gq)
 		xfs_qm_dqrele(gq);
 	return 0;
+
+error_rele:
+	if (uq)
+		xfs_qm_dqrele(uq);
+	return error;
 }
 
 /*
@@ -1819,29 +1823,31 @@ xfs_qm_vop_chown(
  */
 int
 xfs_qm_vop_chown_reserve(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*ip,
-	xfs_dquot_t	*udqp,
-	xfs_dquot_t	*gdqp,
-	uint		flags)
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_dquot	*udqp,
+	struct xfs_dquot	*gdqp,
+	uint			flags)
 {
-	xfs_mount_t	*mp = ip->i_mount;
-	uint		delblks, blkflags, prjflags = 0;
-	xfs_dquot_t	*unresudq, *unresgdq, *delblksudq, *delblksgdq;
-	int		error;
+	struct xfs_mount	*mp = ip->i_mount;
+	uint			delblks, blkflags, prjflags = 0;
+	struct xfs_dquot	*udq_unres = NULL;
+	struct xfs_dquot	*gdq_unres = NULL;
+	struct xfs_dquot	*udq_delblks = NULL;
+	struct xfs_dquot	*gdq_delblks = NULL;
+	int			error;
 
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
 	delblks = ip->i_delayed_blks;
-	delblksudq = delblksgdq = unresudq = unresgdq = NULL;
 	blkflags = XFS_IS_REALTIME_INODE(ip) ?
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
 	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
 	    ip->i_d.di_uid != (uid_t)be32_to_cpu(udqp->q_core.d_id)) {
-		delblksudq = udqp;
+		udq_delblks = udqp;
 		/*
 		 * If there are delayed allocation blocks, then we have to
 		 * unreserve those from the old dquot, and add them to the
@@ -1849,7 +1855,7 @@ xfs_qm_vop_chown_reserve(
 		 */
 		if (delblks) {
 			ASSERT(ip->i_udquot);
-			unresudq = ip->i_udquot;
+			udq_unres = ip->i_udquot;
 		}
 	}
 	if (XFS_IS_OQUOTA_ON(ip->i_mount) && gdqp) {
@@ -1860,18 +1866,19 @@ xfs_qm_vop_chown_reserve(
 		if (prjflags ||
 		    (XFS_IS_GQUOTA_ON(ip->i_mount) &&
 		     ip->i_d.di_gid != be32_to_cpu(gdqp->q_core.d_id))) {
-			delblksgdq = gdqp;
+			gdq_delblks = gdqp;
 			if (delblks) {
 				ASSERT(ip->i_gdquot);
-				unresgdq = ip->i_gdquot;
+				gdq_unres = ip->i_gdquot;
 			}
 		}
 	}
 
-	if ((error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
-				delblksudq, delblksgdq, ip->i_d.di_nblocks, 1,
-				flags | blkflags | prjflags)))
-		return (error);
+	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
+				udq_delblks, gdq_delblks, ip->i_d.di_nblocks, 1,
+				flags | blkflags | prjflags);
+	if (error)
+		return error;
 
 	/*
 	 * Do the delayed blks reservations/unreservations now. Since, these
@@ -1883,14 +1890,15 @@ xfs_qm_vop_chown_reserve(
 		/*
 		 * Do the reservations first. Unreservation can't fail.
 		 */
-		ASSERT(delblksudq || delblksgdq);
-		ASSERT(unresudq || unresgdq);
-		if ((error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
-				delblksudq, delblksgdq, (xfs_qcnt_t)delblks, 0,
-				flags | blkflags | prjflags)))
-			return (error);
+		ASSERT(udq_delblks || gdq_delblks);
+		ASSERT(udq_unres || gdq_unres);
+		error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
+			    udq_delblks, gdq_delblks, (xfs_qcnt_t)delblks, 0,
+			    flags | blkflags | prjflags);
+		if (error)
+			return error;
 		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
-				unresudq, unresgdq, -((xfs_qcnt_t)delblks), 0,
+				udq_unres, gdq_unres, -((xfs_qcnt_t)delblks), 0,
 				blkflags);
 	}
 
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 051e43a..978bbb1 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -103,11 +103,13 @@ xfs_dq_to_quota_inode(struct xfs_dquot *dqp)
 
 extern int	xfs_qm_calc_dquots_per_chunk(struct xfs_mount *mp,
 					     unsigned int nbblks);
-extern void	xfs_trans_mod_dquot(xfs_trans_t *, xfs_dquot_t *, uint, long);
-extern int	xfs_trans_reserve_quota_bydquots(xfs_trans_t *, xfs_mount_t *,
-			xfs_dquot_t *, xfs_dquot_t *, long, long, uint);
-extern void	xfs_trans_dqjoin(xfs_trans_t *, xfs_dquot_t *);
-extern void	xfs_trans_log_dquot(xfs_trans_t *, xfs_dquot_t *);
+extern void	xfs_trans_mod_dquot(struct xfs_trans *,
+					struct xfs_dquot *, uint, long);
+extern int	xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
+			struct xfs_mount *, struct xfs_dquot *,
+			struct xfs_dquot *, long, long, uint);
+extern void	xfs_trans_dqjoin(struct xfs_trans *, struct xfs_dquot *);
+extern void	xfs_trans_log_dquot(struct xfs_trans *, struct xfs_dquot *);
 
 /*
  * We keep the usr and grp dquots separately so that locking will be easier
@@ -132,22 +134,23 @@ typedef struct xfs_dquot_acct {
 #define XFS_QM_IWARNLIMIT	5
 #define XFS_QM_RTBWARNLIMIT	5
 
-extern void		xfs_qm_destroy_quotainfo(xfs_mount_t *);
-extern int		xfs_qm_quotacheck(xfs_mount_t *);
-extern int		xfs_qm_write_sb_changes(xfs_mount_t *, __int64_t);
+extern void		xfs_qm_destroy_quotainfo(struct xfs_mount *);
+extern int		xfs_qm_quotacheck(struct xfs_mount *);
+extern int		xfs_qm_write_sb_changes(struct xfs_mount *, __int64_t);
 
 /* dquot stuff */
-extern void		xfs_qm_dqpurge_all(xfs_mount_t *, uint);
-extern void		xfs_qm_dqrele_all_inodes(xfs_mount_t *, uint);
+extern void		xfs_qm_dqpurge_all(struct xfs_mount *, uint);
+extern void		xfs_qm_dqrele_all_inodes(struct xfs_mount *, uint);
 
 /* quota ops */
-extern int		xfs_qm_scall_trunc_qfiles(xfs_mount_t *, uint);
-extern int		xfs_qm_scall_getquota(xfs_mount_t *, xfs_dqid_t, uint,
-					fs_disk_quota_t *);
+extern int		xfs_qm_scall_trunc_qfiles(struct xfs_mount *, uint);
+extern int		xfs_qm_scall_getquota(struct xfs_mount *, xfs_dqid_t,
+					uint, struct fs_disk_quota *);
 extern int		xfs_qm_scall_setqlim(struct xfs_mount *, xfs_dqid_t, uint,
-					fs_disk_quota_t *);
-extern int		xfs_qm_scall_getqstat(xfs_mount_t *, fs_quota_stat_t *);
-extern int		xfs_qm_scall_quotaon(xfs_mount_t *, uint);
-extern int		xfs_qm_scall_quotaoff(xfs_mount_t *, uint);
+					struct fs_disk_quota *);
+extern int		xfs_qm_scall_getqstat(struct xfs_mount *,
+					struct fs_quota_stat *);
+extern int		xfs_qm_scall_quotaon(struct xfs_mount *, uint);
+extern int		xfs_qm_scall_quotaoff(struct xfs_mount *, uint);
 
 #endif /* __XFS_QM_H__ */
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 6cdf6ff..b03b2ab 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -407,11 +407,11 @@ xfs_qm_scall_getqstat(
 	struct fs_quota_stat	*out)
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	struct xfs_inode	*uip, *gip;
-	bool                    tempuqip, tempgqip;
+	struct xfs_inode	*uip = NULL;
+	struct xfs_inode	*gip = NULL;
+	bool                    tempuqip = false;
+	bool                    tempgqip = false;
 
-	uip = gip = NULL;
-	tempuqip = tempgqip = false;
 	memset(out, 0, sizeof(fs_quota_stat_t));
 
 	out->qs_version = FS_QSTAT_VERSION;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 738c04b..e830fb5 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -358,7 +358,8 @@ xfs_symlink(
 	int			n;
 	xfs_buf_t		*bp;
 	prid_t			prid;
-	struct xfs_dquot	*udqp, *gdqp;
+	struct xfs_dquot	*udqp = NULL;
+	struct xfs_dquot	*gdqp = NULL;
 	uint			resblks;
 
 	*ipp = NULL;
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 3fa369c..45b3e2d 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -169,13 +169,13 @@ xfs_trans_mod_dquot_byino(
 		(void) xfs_trans_mod_dquot(tp, ip->i_gdquot, field, delta);
 }
 
-STATIC xfs_dqtrx_t *
+STATIC struct xfs_dqtrx *
 xfs_trans_get_dqtrx(
-	xfs_trans_t	*tp,
-	xfs_dquot_t	*dqp)
+	struct xfs_trans	*tp,
+	struct xfs_dquot	*dqp)
 {
-	int		i;
-	xfs_dqtrx_t	*qa;
+	int			i;
+	struct xfs_dqtrx	*qa;
 
 	qa = XFS_QM_ISUDQ(dqp) ?
 		tp->t_dqinfo->dqa_usrdquots : tp->t_dqinfo->dqa_grpdquots;
@@ -747,15 +747,15 @@ error_return:
  */
 int
 xfs_trans_reserve_quota_bydquots(
-	xfs_trans_t	*tp,
-	xfs_mount_t	*mp,
-	xfs_dquot_t	*udqp,
-	xfs_dquot_t	*gdqp,
-	long		nblks,
-	long		ninos,
-	uint		flags)
+	struct xfs_trans	*tp,
+	struct xfs_mount	*mp,
+	struct xfs_dquot	*udqp,
+	struct xfs_dquot	*gdqp,
+	long			nblks,
+	long			ninos,
+	uint			flags)
 {
-	int		resvd = 0, error;
+	int		error;
 
 	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
 		return 0;
@@ -770,28 +770,24 @@ xfs_trans_reserve_quota_bydquots(
 					(flags & ~XFS_QMOPT_ENOSPC));
 		if (error)
 			return error;
-		resvd = 1;
 	}
 
 	if (gdqp) {
 		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos, flags);
-		if (error) {
-			/*
-			 * can't do it, so backout previous reservation
-			 */
-			if (resvd) {
-				flags |= XFS_QMOPT_FORCE_RES;
-				xfs_trans_dqresv(tp, mp, udqp,
-						 -nblks, -ninos, flags);
-			}
-			return error;
-		}
+		if (error)
+			goto unwind_usr;
 	}
 
 	/*
 	 * Didn't change anything critical, so, no need to log
 	 */
 	return 0;
+
+unwind_usr:
+	flags |= XFS_QMOPT_FORCE_RES;
+	if (udqp)
+		xfs_trans_dqresv(tp, mp, udqp, -nblks, -ninos, flags);
+	return error;
 }
 
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
