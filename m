Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DE1E37F51
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 21:49:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 842CF304043
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 19:49:15 -0700 (PDT)
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152]) by
	cuda.sgi.com with ESMTP id 8lbyVrxSM0pkJXHR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 23 Jun 2013 19:49:13 -0700 (PDT)
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Sun, 23 Jun 2013 20:48:34 -0600
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 28C501FF001B
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 20:43:17 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5O2mWLD134654 for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 20:48:32 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r5O2mVrV008447
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 20:48:31 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v9 1/6] xfs: Move code around and remove typedefs
Date: Sun, 23 Jun 2013 21:48:22 -0500
Message-Id: <1372042107-27332-2-git-send-email-sekharan@us.ibm.com>
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

Removed some typedefs, defined new functions, made some code clean up all in
preparation of the series.

No functional changes.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_dquot.c       |   16 ++--
 fs/xfs/xfs_dquot.h       |    4 -
 fs/xfs/xfs_icache.c      |    3 +-
 fs/xfs/xfs_itable.c      |    2 +-
 fs/xfs/xfs_qm.c          |  175 +++++++++++++++++++++++----------------------
 fs/xfs/xfs_qm.h          |  133 ++++++++++++++++++++++-------------
 fs/xfs/xfs_qm_syscalls.c |    8 +-
 fs/xfs/xfs_sb.h          |    6 ++
 fs/xfs/xfs_symlink.c     |    3 +-
 fs/xfs/xfs_trans_dquot.c |   83 +++++++++-------------
 10 files changed, 230 insertions(+), 203 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 044e97a..f01012d 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -570,13 +570,13 @@ xfs_qm_dqtobp(
 	xfs_buf_t		**O_bpp,
 	uint			flags)
 {
-	xfs_bmbt_irec_t map;
-	int		nmaps = 1, error;
-	xfs_buf_t	*bp;
-	xfs_inode_t	*quotip = XFS_DQ_TO_QIP(dqp);
-	xfs_mount_t	*mp = dqp->q_mount;
-	xfs_dqid_t	id = be32_to_cpu(dqp->q_core.d_id);
-	xfs_trans_t	*tp = (tpp ? *tpp : NULL);
+	struct xfs_bmbt_irec	map;
+	int			nmaps = 1, error;
+	struct xfs_buf		*bp;
+	struct xfs_inode	*quotip = xfs_dq_to_quota_inode(dqp);
+	struct xfs_mount	*mp = dqp->q_mount;
+	xfs_dqid_t		id = be32_to_cpu(dqp->q_core.d_id);
+	struct xfs_trans	*tp = (tpp ? *tpp : NULL);
 
 	dqp->q_fileoffset = (xfs_fileoff_t)id / mp->m_quotainfo->qi_dqperchunk;
 
@@ -804,7 +804,7 @@ xfs_qm_dqget(
 	xfs_dquot_t	**O_dqpp) /* OUT : locked incore dquot */
 {
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
-	struct radix_tree_root *tree = XFS_DQUOT_TREE(qi, type);
+	struct radix_tree_root *tree = xfs_dquot_tree(qi, type);
 	struct xfs_dquot	*dqp;
 	int			error;
 
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 4f0ebfc..b596626 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -143,10 +143,6 @@ static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
 #define XFS_QM_ISUDQ(dqp)	((dqp)->dq_flags & XFS_DQ_USER)
 #define XFS_QM_ISPDQ(dqp)	((dqp)->dq_flags & XFS_DQ_PROJ)
 #define XFS_QM_ISGDQ(dqp)	((dqp)->dq_flags & XFS_DQ_GROUP)
-#define XFS_DQ_TO_QINF(dqp)	((dqp)->q_mount->m_quotainfo)
-#define XFS_DQ_TO_QIP(dqp)	(XFS_QM_ISUDQ(dqp) ? \
-				 XFS_DQ_TO_QINF(dqp)->qi_uquotaip : \
-				 XFS_DQ_TO_QINF(dqp)->qi_gquotaip)
 
 extern int		xfs_qm_dqread(struct xfs_mount *, xfs_dqid_t, uint,
 					uint, struct xfs_dquot	**);
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
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 2ea7d40..9cbf9e0 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -43,7 +43,7 @@ xfs_internal_inum(
 {
 	return (ino == mp->m_sb.sb_rbmino || ino == mp->m_sb.sb_rsumino ||
 		(xfs_sb_version_hasquota(&mp->m_sb) &&
-		 (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino)));
+		 xfs_is_quota_inode(&mp->m_sb, ino)));
 }
 
 /*
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b75c9bb..f5f9925 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -70,7 +70,7 @@ xfs_qm_dquot_walk(
 	void			*data)
 {
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
-	struct radix_tree_root	*tree = XFS_DQUOT_TREE(qi, type);
+	struct radix_tree_root	*tree = xfs_dquot_tree(qi, type);
 	uint32_t		next_index;
 	int			last_error = 0;
 	int			skipped;
@@ -189,7 +189,7 @@ xfs_qm_dqpurge(
 	xfs_dqfunlock(dqp);
 	xfs_dqunlock(dqp);
 
-	radix_tree_delete(XFS_DQUOT_TREE(qi, dqp->q_core.d_flags),
+	radix_tree_delete(xfs_dquot_tree(qi, dqp->q_core.d_flags),
 			  be32_to_cpu(dqp->q_core.d_id));
 	qi->qi_dquots--;
 
@@ -489,8 +489,7 @@ xfs_qm_need_dqattach(
 		return false;
 	if (!XFS_NOT_DQATTACHED(mp, ip))
 		return false;
-	if (ip->i_ino == mp->m_sb.sb_uquotino ||
-	    ip->i_ino == mp->m_sb.sb_gquotino)
+	if (xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
 		return false;
 	return true;
 }
@@ -606,8 +605,7 @@ xfs_qm_dqdetach(
 
 	trace_xfs_dquot_dqdetach(ip);
 
-	ASSERT(ip->i_ino != ip->i_mount->m_sb.sb_uquotino);
-	ASSERT(ip->i_ino != ip->i_mount->m_sb.sb_gquotino);
+	ASSERT(!xfs_is_quota_inode(&ip->i_mount->m_sb, ip->i_ino));
 	if (ip->i_udquot) {
 		xfs_qm_dqrele(ip->i_udquot);
 		ip->i_udquot = NULL;
@@ -1152,7 +1150,7 @@ xfs_qm_dqusage_adjust(
 	 * rootino must have its resources accounted for, not so with the quota
 	 * inodes.
 	 */
-	if (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino) {
+	if (xfs_is_quota_inode(&mp->m_sb, ino)) {
 		*res = BULKSTAT_RV_NOTHING;
 		return XFS_ERROR(EINVAL);
 	}
@@ -1262,19 +1260,20 @@ int
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
@@ -1284,7 +1283,6 @@ xfs_qm_quotacheck(
 	 * their counters to zero. We need a clean slate.
 	 * We don't log our changes till later.
 	 */
-	uip = mp->m_quotainfo->qi_uquotaip;
 	if (uip) {
 		error = xfs_qm_dqiterate(mp, uip, XFS_QMOPT_UQUOTA,
 					 &buffer_list);
@@ -1293,7 +1291,6 @@ xfs_qm_quotacheck(
 		flags |= XFS_UQUOTA_CHKD;
 	}
 
-	gip = mp->m_quotainfo->qi_gquotaip;
 	if (gip) {
 		error = xfs_qm_dqiterate(mp, gip, XFS_IS_GQUOTA_ON(mp) ?
 					 XFS_QMOPT_GQUOTA : XFS_QMOPT_PQUOTA,
@@ -1395,15 +1392,13 @@ STATIC int
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
@@ -1412,19 +1407,18 @@ xfs_qm_init_quotainos(
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
@@ -1439,10 +1433,11 @@ xfs_qm_init_quotainos(
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
@@ -1451,18 +1446,21 @@ xfs_qm_init_quotainos(
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
@@ -1473,7 +1471,7 @@ xfs_qm_dqfree_one(
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 
 	mutex_lock(&qi->qi_tree_lock);
-	radix_tree_delete(XFS_DQUOT_TREE(qi, dqp->q_core.d_flags),
+	radix_tree_delete(xfs_dquot_tree(qi, dqp->q_core.d_flags),
 			  be32_to_cpu(dqp->q_core.d_id));
 
 	qi->qi_dquots--;
@@ -1659,7 +1657,8 @@ xfs_qm_vop_dqalloc(
 	struct xfs_dquot	**O_gdqpp)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_dquot	*uq, *gq;
+	struct xfs_dquot	*uq = NULL;
+	struct xfs_dquot	*gq = NULL;
 	int			error;
 	uint			lockflags;
 
@@ -1684,7 +1683,6 @@ xfs_qm_vop_dqalloc(
 		}
 	}
 
-	uq = gq = NULL;
 	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
 		if (ip->i_d.di_uid != uid) {
 			/*
@@ -1697,14 +1695,14 @@ xfs_qm_vop_dqalloc(
 			 * holding ilock.
 			 */
 			xfs_iunlock(ip, lockflags);
-			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t) uid,
+			error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t) uid,
 						 XFS_DQ_USER,
 						 XFS_QMOPT_DQALLOC |
 						 XFS_QMOPT_DOWARN,
-						 &uq))) {
-				ASSERT(error != ENOENT);
+						 &uq);
+			ASSERT(error != ENOENT);
+			if (error)
 				return error;
-			}
 			/*
 			 * Get the ilock in the right order.
 			 */
@@ -1723,16 +1721,14 @@ xfs_qm_vop_dqalloc(
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
-				ASSERT(error != ENOENT);
-				return error;
-			}
+						 &gq);
+			ASSERT(error != ENOENT);
+			if (error)
+				goto error_rele;
 			xfs_dqunlock(gq);
 			lockflags = XFS_ILOCK_SHARED;
 			xfs_ilock(ip, lockflags);
@@ -1743,16 +1739,14 @@ xfs_qm_vop_dqalloc(
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
-				ASSERT(error != ENOENT);
-				return (error);
-			}
+						 &gq);
+			ASSERT(error != ENOENT);
+			if (error)
+				goto error_rele;
 			xfs_dqunlock(gq);
 			lockflags = XFS_ILOCK_SHARED;
 			xfs_ilock(ip, lockflags);
@@ -1774,6 +1768,11 @@ xfs_qm_vop_dqalloc(
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
@@ -1821,29 +1820,31 @@ xfs_qm_vop_chown(
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
@@ -1851,7 +1852,7 @@ xfs_qm_vop_chown_reserve(
 		 */
 		if (delblks) {
 			ASSERT(ip->i_udquot);
-			unresudq = ip->i_udquot;
+			udq_unres = ip->i_udquot;
 		}
 	}
 	if (XFS_IS_OQUOTA_ON(ip->i_mount) && gdqp) {
@@ -1862,18 +1863,19 @@ xfs_qm_vop_chown_reserve(
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
@@ -1885,14 +1887,15 @@ xfs_qm_vop_chown_reserve(
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
index 5d16a6e..4b330f2 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -42,57 +42,89 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
  * The mount structure keeps a pointer to this.
  */
 typedef struct xfs_quotainfo {
-	struct radix_tree_root qi_uquota_tree;
-	struct radix_tree_root qi_gquota_tree;
-	struct mutex qi_tree_lock;
-	xfs_inode_t	*qi_uquotaip;	 /* user quota inode */
-	xfs_inode_t	*qi_gquotaip;	 /* group quota inode */
-	struct list_head qi_lru_list;
-	struct mutex	 qi_lru_lock;
-	int		 qi_lru_count;
-	int		 qi_dquots;
-	time_t		 qi_btimelimit;	 /* limit for blks timer */
-	time_t		 qi_itimelimit;	 /* limit for inodes timer */
-	time_t		 qi_rtbtimelimit;/* limit for rt blks timer */
-	xfs_qwarncnt_t	 qi_bwarnlimit;	 /* limit for blks warnings */
-	xfs_qwarncnt_t	 qi_iwarnlimit;	 /* limit for inodes warnings */
-	xfs_qwarncnt_t	 qi_rtbwarnlimit;/* limit for rt blks warnings */
-	struct mutex	 qi_quotaofflock;/* to serialize quotaoff */
-	xfs_filblks_t	 qi_dqchunklen;	 /* # BBs in a chunk of dqs */
-	uint		 qi_dqperchunk;	 /* # ondisk dqs in above chunk */
-	xfs_qcnt_t	 qi_bhardlimit;	 /* default data blk hard limit */
-	xfs_qcnt_t	 qi_bsoftlimit;	 /* default data blk soft limit */
-	xfs_qcnt_t	 qi_ihardlimit;	 /* default inode count hard limit */
-	xfs_qcnt_t	 qi_isoftlimit;	 /* default inode count soft limit */
-	xfs_qcnt_t	 qi_rtbhardlimit;/* default realtime blk hard limit */
-	xfs_qcnt_t	 qi_rtbsoftlimit;/* default realtime blk soft limit */
-	struct shrinker  qi_shrinker;
+	struct radix_tree_root	qi_uquota_tree;
+	struct radix_tree_root	qi_gquota_tree;
+	struct mutex		qi_tree_lock;
+	struct xfs_inode	*qi_uquotaip;	 /* user quota inode */
+	struct xfs_inode	*qi_gquotaip;	 /* group quota inode */
+	struct list_head	qi_lru_list;
+	struct mutex		qi_lru_lock;
+	int		qi_lru_count;
+	int		qi_dquots;
+	time_t		qi_btimelimit;	 /* limit for blks timer */
+	time_t		qi_itimelimit;	 /* limit for inodes timer */
+	time_t		qi_rtbtimelimit;/* limit for rt blks timer */
+	xfs_qwarncnt_t	qi_bwarnlimit;	 /* limit for blks warnings */
+	xfs_qwarncnt_t	qi_iwarnlimit;	 /* limit for inodes warnings */
+	xfs_qwarncnt_t	qi_rtbwarnlimit;/* limit for rt blks warnings */
+	struct mutex	qi_quotaofflock;/* to serialize quotaoff */
+	xfs_filblks_t	qi_dqchunklen;	 /* # BBs in a chunk of dqs */
+	uint		qi_dqperchunk;	 /* # ondisk dqs in above chunk */
+	xfs_qcnt_t	qi_bhardlimit;	 /* default data blk hard limit */
+	xfs_qcnt_t	qi_bsoftlimit;	 /* default data blk soft limit */
+	xfs_qcnt_t	qi_ihardlimit;	 /* default inode count hard limit */
+	xfs_qcnt_t	qi_isoftlimit;	 /* default inode count soft limit */
+	xfs_qcnt_t	qi_rtbhardlimit;/* default realtime blk hard limit */
+	xfs_qcnt_t	qi_rtbsoftlimit;/* default realtime blk soft limit */
+	struct shrinker	qi_shrinker;
 } xfs_quotainfo_t;
 
-#define XFS_DQUOT_TREE(qi, type) \
-	((type & XFS_DQ_USER) ? \
-	 &((qi)->qi_uquota_tree) : \
-	 &((qi)->qi_gquota_tree))
+static inline struct radix_tree_root *
+xfs_dquot_tree(
+	struct xfs_quotainfo	*qi,
+	int			type)
+{
+	switch (type) {
+	case XFS_DQ_USER:
+		return &qi->qi_uquota_tree;
+	case XFS_DQ_GROUP:
+	case XFS_DQ_PROJ:
+		return &qi->qi_gquota_tree;
+	default:
+		ASSERT(0);
+	}
+	return NULL;
+}
 
+static inline struct xfs_inode *
+xfs_dq_to_quota_inode(struct xfs_dquot *dqp)
+{
+	switch (dqp->dq_flags & XFS_DQ_ALLTYPES) {
+	case XFS_DQ_USER:
+		return dqp->q_mount->m_quotainfo->qi_uquotaip;
+	case XFS_DQ_GROUP:
+	case XFS_DQ_PROJ:
+		return dqp->q_mount->m_quotainfo->qi_gquotaip;
+	default:
+		ASSERT(0);
+	}
+	return NULL;
+}
 
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
  * to do at commit time. All transactions that we know of at this point
  * affect no more than two dquots of one type. Hence, the TRANS_MAXDQS value.
  */
+enum {
+	XFS_QM_TRANS_USR = 0,
+	XFS_QM_TRANS_GRP,
+	XFS_QM_TRANS_DQTYPES
+};
 #define XFS_QM_TRANS_MAXDQS		2
-typedef struct xfs_dquot_acct {
-	xfs_dqtrx_t	dqa_usrdquots[XFS_QM_TRANS_MAXDQS];
-	xfs_dqtrx_t	dqa_grpdquots[XFS_QM_TRANS_MAXDQS];
-} xfs_dquot_acct_t;
+struct xfs_dquot_acct {
+	struct xfs_dqtrx	dqs[XFS_QM_TRANS_DQTYPES][XFS_QM_TRANS_MAXDQS];
+};
 
 /*
  * Users are allowed to have a usage exceeding their softlimit for
@@ -106,22 +138,23 @@ typedef struct xfs_dquot_acct {
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
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index 2de58a8..78f9e70 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -618,6 +618,12 @@ xfs_sb_has_incompat_log_feature(
 	return (sbp->sb_features_log_incompat & feature) != 0;
 }
 
+static inline bool
+xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
+{
+	return (ino == sbp->sb_uquotino || ino == sbp->sb_gquotino);
+}
+
 /*
  * end of superblock version macros
  */
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
index fec75d0..7ea7485 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -103,8 +103,6 @@ xfs_trans_dup_dqinfo(
 		return;
 
 	xfs_trans_alloc_dqinfo(ntp);
-	oqa = otp->t_dqinfo->dqa_usrdquots;
-	nqa = ntp->t_dqinfo->dqa_usrdquots;
 
 	/*
 	 * Because the quota blk reservation is carried forward,
@@ -113,7 +111,9 @@ xfs_trans_dup_dqinfo(
 	if(otp->t_flags & XFS_TRANS_DQ_DIRTY)
 		ntp->t_flags |= XFS_TRANS_DQ_DIRTY;
 
-	for (j = 0; j < 2; j++) {
+	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
+		oqa = otp->t_dqinfo->dqs[j];
+		nqa = ntp->t_dqinfo->dqs[j];
 		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
 			if (oqa[i].qt_dquot == NULL)
 				break;
@@ -138,8 +138,6 @@ xfs_trans_dup_dqinfo(
 			oq->qt_ino_res = oq->qt_ino_res_used;
 
 		}
-		oqa = otp->t_dqinfo->dqa_grpdquots;
-		nqa = ntp->t_dqinfo->dqa_grpdquots;
 	}
 }
 
@@ -157,8 +155,7 @@ xfs_trans_mod_dquot_byino(
 
 	if (!XFS_IS_QUOTA_RUNNING(mp) ||
 	    !XFS_IS_QUOTA_ON(mp) ||
-	    ip->i_ino == mp->m_sb.sb_uquotino ||
-	    ip->i_ino == mp->m_sb.sb_gquotino)
+	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
 		return;
 
 	if (tp->t_dqinfo == NULL)
@@ -170,16 +167,18 @@ xfs_trans_mod_dquot_byino(
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
 
-	qa = XFS_QM_ISUDQ(dqp) ?
-		tp->t_dqinfo->dqa_usrdquots : tp->t_dqinfo->dqa_grpdquots;
+	if (XFS_QM_ISUDQ(dqp))
+		qa = tp->t_dqinfo->dqs[XFS_QM_TRANS_USR];
+	else
+		qa = tp->t_dqinfo->dqs[XFS_QM_TRANS_GRP];
 
 	for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
 		if (qa[i].qt_dquot == NULL ||
@@ -339,12 +338,10 @@ xfs_trans_apply_dquot_deltas(
 		return;
 
 	ASSERT(tp->t_dqinfo);
-	qa = tp->t_dqinfo->dqa_usrdquots;
-	for (j = 0; j < 2; j++) {
-		if (qa[0].qt_dquot == NULL) {
-			qa = tp->t_dqinfo->dqa_grpdquots;
+	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
+		qa = tp->t_dqinfo->dqs[j];
+		if (qa[0].qt_dquot == NULL)
 			continue;
-		}
 
 		/*
 		 * Lock all of the dquots and join them to the transaction.
@@ -495,10 +492,6 @@ xfs_trans_apply_dquot_deltas(
 			ASSERT(dqp->q_res_rtbcount >=
 				be64_to_cpu(dqp->q_core.d_rtbcount));
 		}
-		/*
-		 * Do the group quotas next
-		 */
-		qa = tp->t_dqinfo->dqa_grpdquots;
 	}
 }
 
@@ -521,9 +514,9 @@ xfs_trans_unreserve_and_mod_dquots(
 	if (!tp->t_dqinfo || !(tp->t_flags & XFS_TRANS_DQ_DIRTY))
 		return;
 
-	qa = tp->t_dqinfo->dqa_usrdquots;
+	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
+		qa = tp->t_dqinfo->dqs[j];
 
-	for (j = 0; j < 2; j++) {
 		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
 			qtrx = &qa[i];
 			/*
@@ -565,7 +558,6 @@ xfs_trans_unreserve_and_mod_dquots(
 				xfs_dqunlock(dqp);
 
 		}
-		qa = tp->t_dqinfo->dqa_grpdquots;
 	}
 }
 
@@ -748,15 +740,15 @@ error_return:
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
@@ -771,28 +763,24 @@ xfs_trans_reserve_quota_bydquots(
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
 
 
@@ -816,8 +804,7 @@ xfs_trans_reserve_quota_nblks(
 	if (XFS_IS_PQUOTA_ON(mp))
 		flags |= XFS_QMOPT_ENOSPC;
 
-	ASSERT(ip->i_ino != mp->m_sb.sb_uquotino);
-	ASSERT(ip->i_ino != mp->m_sb.sb_gquotino);
+	ASSERT(!xfs_is_quota_inode(&mp->m_sb, ip->i_ino));
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES | XFS_QMOPT_ENOSPC)) ==
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
