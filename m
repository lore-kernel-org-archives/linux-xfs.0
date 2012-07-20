Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6KN2ub5165273 for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 18:02:57 -0500
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149]) by
	cuda.sgi.com with ESMTP id K4J1tYOHaS9zwnWj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Jul 2012 16:02:55 -0700 (PDT)
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 20 Jul 2012 17:02:54 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 267813E40026
	for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 23:02:52 +0000 (WET)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q6KN2qfi123428 for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 17:02:52 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id q6KN2aC4022357
	for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 17:02:36 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 20 Jul 2012 18:02:25 -0500
Message-Id: <20120720230225.20477.87398.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20120720230202.20477.69766.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20120720230202.20477.69766.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [RFC v6 PATCH 2/5] xfs: Add pquota fields where gquota is used.
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

Add project quota changes to all the places where group quota field
is used:
   * add separate project quota members into various structures
   * split project quota and group quotas so that instead of overriding
     the group quota members incore, the new project quota members are
     used instead
   * get rid of usage of the OQUOTA flag incore, in favor of separate group
     and project quota flags.
   * add a project dquot argument to various functions.

No externally visible interfaces changed and no superblock changes yet.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_dquot.c       |   16 ++-
 fs/xfs/xfs_dquot.h       |   11 ++-
 fs/xfs/xfs_iget.c        |    2 +-
 fs/xfs/xfs_inode.h       |    1 +
 fs/xfs/xfs_ioctl.c       |   14 ++--
 fs/xfs/xfs_iops.c        |    4 +-
 fs/xfs/xfs_qm.c          |  255 ++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_qm.h          |   15 ++--
 fs/xfs/xfs_qm_bhv.c      |    2 +-
 fs/xfs/xfs_qm_syscalls.c |   19 +++-
 fs/xfs/xfs_quota.h       |   38 ++++---
 fs/xfs/xfs_sb.h          |    1 +
 fs/xfs/xfs_super.c       |    5 +-
 fs/xfs/xfs_trans_dquot.c |   71 ++++++++++---
 fs/xfs/xfs_vnodeops.c    |   23 +++--
 15 files changed, 326 insertions(+), 151 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index bf27fcc..42b8b79 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -751,7 +751,7 @@ xfs_qm_dqput_final(
 	struct xfs_dquot	*dqp)
 {
 	struct xfs_quotainfo	*qi = dqp->q_mount->m_quotainfo;
-	struct xfs_dquot	*gdqp;
+	struct xfs_dquot	*gdqp, *pdqp;
 
 	trace_xfs_dqput_free(dqp);
 
@@ -765,21 +765,29 @@ xfs_qm_dqput_final(
 
 	/*
 	 * If we just added a udquot to the freelist, then we want to release
-	 * the gdquot reference that it (probably) has. Otherwise it'll keep
-	 * the gdquot from getting reclaimed.
+	 * the gdquot/pdquot reference that it (probably) has. Otherwise it'll
+	 * keep the gdquot/pdquot from getting reclaimed.
 	 */
 	gdqp = dqp->q_gdquot;
 	if (gdqp) {
 		xfs_dqlock(gdqp);
 		dqp->q_gdquot = NULL;
 	}
+
+	pdqp = dqp->q_pdquot;
+	if (pdqp) {
+		xfs_dqlock(pdqp);
+		dqp->q_pdquot = NULL;
+	}
 	xfs_dqunlock(dqp);
 
 	/*
-	 * If we had a group quota hint, release it now.
+	 * If we had a group/project quota hint, release it now.
 	 */
 	if (gdqp)
 		xfs_qm_dqput(gdqp);
+	if (pdqp)
+		xfs_qm_dqput(pdqp);
 }
 
 /*
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 7d20af2..893cd5e 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -46,6 +46,7 @@ typedef struct xfs_dquot {
 	xfs_fileoff_t	 q_fileoffset;	/* offset in quotas file */
 
 	struct xfs_dquot*q_gdquot;	/* group dquot, hint only */
+	struct xfs_dquot *q_pdquot;	/* project dquot, hint only */
 	xfs_disk_dquot_t q_core;	/* actual usage & quotas */
 	xfs_dq_logitem_t q_logitem;	/* dquot log item */
 	xfs_qcnt_t	 q_res_bcount;	/* total regular nblks used+reserved */
@@ -108,8 +109,9 @@ static inline int xfs_this_quota_on(struct xfs_mount *mp, int type)
 	case XFS_DQ_USER:
 		return XFS_IS_UQUOTA_ON(mp);
 	case XFS_DQ_GROUP:
+		return XFS_IS_GQUOTA_ON(mp);
 	case XFS_DQ_PROJ:
-		return XFS_IS_OQUOTA_ON(mp);
+		return XFS_IS_PQUOTA_ON(mp);
 	default:
 		return 0;
 	}
@@ -121,8 +123,9 @@ static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
 	case XFS_DQ_USER:
 		return ip->i_udquot;
 	case XFS_DQ_GROUP:
-	case XFS_DQ_PROJ:
 		return ip->i_gdquot;
+	case XFS_DQ_PROJ:
+		return ip->i_pdquot;
 	default:
 		return NULL;
 	}
@@ -136,7 +139,9 @@ static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
 #define XFS_DQ_TO_QINF(dqp)	((dqp)->q_mount->m_quotainfo)
 #define XFS_DQ_TO_QIP(dqp)	(XFS_QM_ISUDQ(dqp) ? \
 				 XFS_DQ_TO_QINF(dqp)->qi_uquotaip : \
-				 XFS_DQ_TO_QINF(dqp)->qi_gquotaip)
+				 (XFS_QM_ISGDQ(dqp) ? \
+				 XFS_DQ_TO_QINF(dqp)->qi_gquotaip : \
+				 XFS_DQ_TO_QINF(dqp)->qi_pquotaip))
 
 extern int		xfs_qm_dqread(struct xfs_mount *, xfs_dqid_t, uint,
 					uint, struct xfs_dquot	**);
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 1bb4365..e97fb18 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -346,7 +346,7 @@ xfs_iget_cache_miss(
 	iflags = XFS_INEW;
 	if (flags & XFS_IGET_DONTCACHE)
 		iflags |= XFS_IDONTCACHE;
-	ip->i_udquot = ip->i_gdquot = NULL;
+	ip->i_udquot = ip->i_gdquot = ip->i_pdquot = NULL;
 	xfs_iflags_set(ip, iflags);
 
 	/* insert the new inode */
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 1efff36..1124620 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -224,6 +224,7 @@ typedef struct xfs_inode {
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
 	struct xfs_dquot	*i_udquot;	/* user dquot */
 	struct xfs_dquot	*i_gdquot;	/* group dquot */
+	struct xfs_dquot	*i_pdquot;	/* project dquot */
 
 	/* Inode location stuff */
 	xfs_ino_t		i_ino;		/* inode number (agno/agino)*/
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3a05a41..49da24b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -907,7 +907,7 @@ xfs_ioctl_setattr(
 	struct xfs_trans	*tp;
 	unsigned int		lock_flags = 0;
 	struct xfs_dquot	*udqp = NULL;
-	struct xfs_dquot	*gdqp = NULL;
+	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_dquot	*olddquot = NULL;
 	int			code;
 
@@ -936,7 +936,7 @@ xfs_ioctl_setattr(
 	if (XFS_IS_QUOTA_ON(mp) && (mask & FSX_PROJID)) {
 		code = xfs_qm_vop_dqalloc(ip, ip->i_d.di_uid,
 					 ip->i_d.di_gid, fa->fsx_projid,
-					 XFS_QMOPT_PQUOTA, &udqp, &gdqp);
+					 XFS_QMOPT_PQUOTA, &udqp, NULL, &pdqp);
 		if (code)
 			return code;
 	}
@@ -973,8 +973,8 @@ xfs_ioctl_setattr(
 		    XFS_IS_PQUOTA_ON(mp) &&
 		    xfs_get_projid(ip) != fa->fsx_projid) {
 			ASSERT(tp);
-			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
-						capable(CAP_FOWNER) ?
+			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, NULL,
+						pdqp, capable(CAP_FOWNER) ?
 						XFS_QMOPT_FORCE_RES : 0);
 			if (code)	/* out of quota */
 				goto error_return;
@@ -1092,7 +1092,7 @@ xfs_ioctl_setattr(
 		if (xfs_get_projid(ip) != fa->fsx_projid) {
 			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
 				olddquot = xfs_qm_vop_chown(tp, ip,
-							&ip->i_gdquot, gdqp);
+							&ip->i_pdquot, pdqp);
 			}
 			xfs_set_projid(ip, fa->fsx_projid);
 
@@ -1139,13 +1139,13 @@ xfs_ioctl_setattr(
 	 */
 	xfs_qm_dqrele(olddquot);
 	xfs_qm_dqrele(udqp);
-	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
 
 	return code;
 
  error_return:
 	xfs_qm_dqrele(udqp);
-	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
 	xfs_trans_cancel(tp, 0);
 	if (lock_flags)
 		xfs_iunlock(ip, lock_flags);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 1a25fd8..e8db154 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -516,7 +516,7 @@ xfs_setattr_nonsize(
 		ASSERT(udqp == NULL);
 		ASSERT(gdqp == NULL);
 		error = xfs_qm_vop_dqalloc(ip, uid, gid, xfs_get_projid(ip),
-					 qflags, &udqp, &gdqp);
+					 qflags, &udqp, &gdqp, NULL);
 		if (error)
 			return error;
 	}
@@ -552,7 +552,7 @@ xfs_setattr_nonsize(
 		     (XFS_IS_GQUOTA_ON(mp) && igid != gid))) {
 			ASSERT(tp);
 			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
-						capable(CAP_FOWNER) ?
+						NULL, capable(CAP_FOWNER) ?
 						XFS_QMOPT_FORCE_RES : 0);
 			if (error)	/* out of quota */
 				goto out_trans_cancel;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 3fb3730..46c7e4c 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -134,7 +134,7 @@ xfs_qm_dqpurge(
 {
 	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
-	struct xfs_dquot	*gdqp = NULL;
+	struct xfs_dquot	*gdqp = NULL, *pdqp = NULL;
 
 	xfs_dqlock(dqp);
 	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0) {
@@ -143,8 +143,8 @@ xfs_qm_dqpurge(
 	}
 
 	/*
-	 * If this quota has a group hint attached, prepare for releasing it
-	 * now.
+	 * If this quota has a group/project hint attached, prepare for
+	 * releasing it now.
 	 */
 	gdqp = dqp->q_gdquot;
 	if (gdqp) {
@@ -152,6 +152,12 @@ xfs_qm_dqpurge(
 		dqp->q_gdquot = NULL;
 	}
 
+	pdqp = dqp->q_pdquot;
+	if (pdqp) {
+		xfs_dqlock(pdqp);
+		dqp->q_pdquot = NULL;
+	}
+
 	dqp->dq_flags |= XFS_DQ_FREEING;
 
 	xfs_dqflock(dqp);
@@ -206,6 +212,8 @@ xfs_qm_dqpurge(
 
 	if (gdqp)
 		xfs_qm_dqput(gdqp);
+	if (pdqp)
+		xfs_qm_dqput(pdqp);
 	return 0;
 }
 
@@ -362,6 +370,10 @@ xfs_qm_unmount_quotas(
 			IRELE(mp->m_quotainfo->qi_gquotaip);
 			mp->m_quotainfo->qi_gquotaip = NULL;
 		}
+		if (mp->m_quotainfo->qi_pquotaip) {
+			IRELE(mp->m_quotainfo->qi_pquotaip);
+			mp->m_quotainfo->qi_pquotaip = NULL;
+		}
 	}
 }
 
@@ -408,7 +420,10 @@ xfs_qm_dqattach_one(
 		 * be reclaimed as long as we have a ref from inode and we
 		 * hold the ilock.
 		 */
-		dqp = udqhint->q_gdquot;
+		if (type == XFS_DQ_GROUP)
+			dqp = udqhint->q_gdquot;
+		else
+			dqp = udqhint->q_pdquot;
 		if (dqp && be32_to_cpu(dqp->q_core.d_id) == id) {
 			ASSERT(*IO_idqpp == NULL);
 
@@ -451,28 +466,29 @@ xfs_qm_dqattach_one(
 
 
 /*
- * Given a udquot and gdquot, attach a ptr to the group dquot in the
+ * Given a udquot and gdquot, attach a ptr to the group/project dquot in the
  * udquot as a hint for future lookups.
  */
 STATIC void
-xfs_qm_dqattach_grouphint(
-	xfs_dquot_t	*udq,
-	xfs_dquot_t	*gdq)
+xfs_qm_dqattach_grouphint(xfs_inode_t *ip, int type)
 {
-	xfs_dquot_t	*tmp;
+	xfs_dquot_t	**tmp, *gpdq, *tmp1, *udq = ip->i_udquot;
 
+	gpdq = (type == XFS_DQ_GROUP) ? ip->i_gdquot : ip->i_pdquot;
 	xfs_dqlock(udq);
 
-	tmp = udq->q_gdquot;
-	if (tmp) {
-		if (tmp == gdq)
+	tmp = (type == XFS_DQ_GROUP) ? &udq->q_gdquot : &udq->q_pdquot;
+
+	if (*tmp) {
+		if (*tmp == gpdq)
 			goto done;
 
-		udq->q_gdquot = NULL;
-		xfs_qm_dqrele(tmp);
+		tmp1 = *tmp;
+		*tmp = NULL;
+		xfs_qm_dqrele(tmp1);
 	}
 
-	udq->q_gdquot = xfs_qm_dqhold(gdq);
+	*tmp = xfs_qm_dqhold(gpdq);
 done:
 	xfs_dqunlock(udq);
 }
@@ -526,12 +542,8 @@ xfs_qm_dqattach_locked(
 	}
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	if (XFS_IS_OQUOTA_ON(mp)) {
-		error = XFS_IS_GQUOTA_ON(mp) ?
-			xfs_qm_dqattach_one(ip, ip->i_d.di_gid, XFS_DQ_GROUP,
-						flags & XFS_QMOPT_DQALLOC,
-						ip->i_udquot, &ip->i_gdquot) :
-			xfs_qm_dqattach_one(ip, xfs_get_projid(ip), XFS_DQ_PROJ,
+	if (XFS_IS_GQUOTA_ON(mp)) {
+		error = xfs_qm_dqattach_one(ip, ip->i_d.di_gid, XFS_DQ_GROUP,
 						flags & XFS_QMOPT_DQALLOC,
 						ip->i_udquot, &ip->i_gdquot);
 		/*
@@ -543,14 +555,28 @@ xfs_qm_dqattach_locked(
 		nquotas++;
 	}
 
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	if (XFS_IS_PQUOTA_ON(mp)) {
+		error = xfs_qm_dqattach_one(ip, xfs_get_projid(ip), XFS_DQ_PROJ,
+						flags & XFS_QMOPT_DQALLOC,
+						ip->i_udquot, &ip->i_pdquot);
+		/*
+		 * Don't worry about the udquot that we may have
+		 * attached above. It'll get detached, if not already.
+		 */
+		if (error)
+			goto done;
+		nquotas++;
+	}
+
 	/*
-	 * Attach this group quota to the user quota as a hint.
+	 * Attach this group/project quota to the user quota as a hint.
 	 * This WON'T, in general, result in a thrash.
 	 */
-	if (nquotas == 2) {
+	if (nquotas > 1 && ip->i_udquot) {
 		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-		ASSERT(ip->i_udquot);
-		ASSERT(ip->i_gdquot);
+		ASSERT(ip->i_gdquot || !XFS_IS_GQUOTA_ON(mp));
+		ASSERT(ip->i_pdquot || !XFS_IS_PQUOTA_ON(mp));
 
 		/*
 		 * We do not have i_udquot locked at this point, but this check
@@ -558,8 +584,13 @@ xfs_qm_dqattach_locked(
 		 * 100% all the time. It is just a hint, and this will
 		 * succeed in general.
 		 */
-		if (ip->i_udquot->q_gdquot != ip->i_gdquot)
-			xfs_qm_dqattach_grouphint(ip->i_udquot, ip->i_gdquot);
+		if (XFS_IS_GQUOTA_ON(mp) &&
+				ip->i_udquot->q_gdquot != ip->i_gdquot)
+			xfs_qm_dqattach_grouphint(ip, XFS_DQ_GROUP);
+
+		if (XFS_IS_PQUOTA_ON(mp) &&
+				ip->i_udquot->q_pdquot != ip->i_pdquot)
+			xfs_qm_dqattach_grouphint(ip, XFS_DQ_PROJ);
 	}
 
  done:
@@ -567,8 +598,10 @@ xfs_qm_dqattach_locked(
 	if (!error) {
 		if (XFS_IS_UQUOTA_ON(mp))
 			ASSERT(ip->i_udquot);
-		if (XFS_IS_OQUOTA_ON(mp))
+		if (XFS_IS_GQUOTA_ON(mp))
 			ASSERT(ip->i_gdquot);
+		if (XFS_IS_PQUOTA_ON(mp))
+			ASSERT(ip->i_pdquot);
 	}
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 #endif
@@ -601,7 +634,7 @@ void
 xfs_qm_dqdetach(
 	xfs_inode_t	*ip)
 {
-	if (!(ip->i_udquot || ip->i_gdquot))
+	if (!(ip->i_udquot || ip->i_gdquot || ip->i_pdquot))
 		return;
 
 	trace_xfs_dquot_dqdetach(ip);
@@ -616,6 +649,10 @@ xfs_qm_dqdetach(
 		xfs_qm_dqrele(ip->i_gdquot);
 		ip->i_gdquot = NULL;
 	}
+	if (ip->i_pdquot) {
+		xfs_qm_dqrele(ip->i_pdquot);
+		ip->i_pdquot = NULL;
+	}
 }
 
 /*
@@ -646,6 +683,7 @@ xfs_qm_init_quotainfo(
 
 	INIT_RADIX_TREE(&qinf->qi_uquota_tree, GFP_NOFS);
 	INIT_RADIX_TREE(&qinf->qi_gquota_tree, GFP_NOFS);
+	INIT_RADIX_TREE(&qinf->qi_pquota_tree, GFP_NOFS);
 	mutex_init(&qinf->qi_tree_lock);
 
 	INIT_LIST_HEAD(&qinf->qi_lru_list);
@@ -748,6 +786,10 @@ xfs_qm_destroy_quotainfo(
 		IRELE(qi->qi_gquotaip);
 		qi->qi_gquotaip = NULL;
 	}
+	if (qi->qi_pquotaip) {
+		IRELE(qi->qi_pquotaip);
+		qi->qi_pquotaip = NULL;
+	}
 	mutex_destroy(&qi->qi_quotaofflock);
 	kmem_free(qi);
 	mp->m_quotainfo = NULL;
@@ -1227,7 +1269,7 @@ xfs_qm_quotacheck(
 	int		done, count, error, error2;
 	xfs_ino_t	lastino;
 	size_t		structsz;
-	xfs_inode_t	*uip, *gip;
+	xfs_inode_t	*uip, *gip, *pip;
 	uint		flags;
 	LIST_HEAD	(buffer_list);
 
@@ -1236,7 +1278,8 @@ xfs_qm_quotacheck(
 	lastino = 0;
 	flags = 0;
 
-	ASSERT(mp->m_quotainfo->qi_uquotaip || mp->m_quotainfo->qi_gquotaip);
+	ASSERT(mp->m_quotainfo->qi_uquotaip || mp->m_quotainfo->qi_gquotaip
+			|| mp->m_quotainfo->qi_pquotaip);
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
 	xfs_notice(mp, "Quotacheck needed: Please wait.");
@@ -1257,13 +1300,20 @@ xfs_qm_quotacheck(
 
 	gip = mp->m_quotainfo->qi_gquotaip;
 	if (gip) {
-		error = xfs_qm_dqiterate(mp, gip, XFS_IS_GQUOTA_ON(mp) ?
-					 XFS_QMOPT_GQUOTA : XFS_QMOPT_PQUOTA,
+		error = xfs_qm_dqiterate(mp, gip, XFS_QMOPT_GQUOTA,
 					 &buffer_list);
 		if (error)
 			goto error_return;
-		flags |= XFS_IS_GQUOTA_ON(mp) ?
-					XFS_GQUOTA_CHKD : XFS_PQUOTA_CHKD;
+		flags |= XFS_GQUOTA_CHKD;
+	}
+
+	pip = mp->m_quotainfo->qi_pquotaip;
+	if (pip) {
+		error = xfs_qm_dqiterate(mp, pip, XFS_QMOPT_PQUOTA,
+					 &buffer_list);
+		if (error)
+			goto error_return;
+		flags |= XFS_PQUOTA_CHKD;
 	}
 
 	do {
@@ -1358,13 +1408,13 @@ STATIC int
 xfs_qm_init_quotainos(
 	xfs_mount_t	*mp)
 {
-	xfs_inode_t	*uip, *gip;
+	xfs_inode_t	*uip, *gip, *pip;
 	int		error;
 	__int64_t	sbflags;
 	uint		flags;
 
 	ASSERT(mp->m_quotainfo);
-	uip = gip = NULL;
+	uip = gip = pip = NULL;
 	sbflags = 0;
 	flags = 0;
 
@@ -1379,7 +1429,7 @@ xfs_qm_init_quotainos(
 					     0, 0, &uip)))
 				return XFS_ERROR(error);
 		}
-		if (XFS_IS_OQUOTA_ON(mp) &&
+		if (XFS_IS_GQUOTA_ON(mp) &&
 		    mp->m_sb.sb_gquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_gquotino > 0);
 			if ((error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
@@ -1389,6 +1439,19 @@ xfs_qm_init_quotainos(
 				return XFS_ERROR(error);
 			}
 		}
+		if (XFS_IS_PQUOTA_ON(mp) &&
+		    mp->m_sb.sb_pquotino != NULLFSINO) {
+			ASSERT(mp->m_sb.sb_pquotino > 0);
+			error = xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
+					     0, 0, &pip);
+			if (error) {
+				if (uip)
+					IRELE(uip);
+				if (gip)
+					IRELE(gip);
+				return XFS_ERROR(error);
+			}
+		}
 	} else {
 		flags |= XFS_QMOPT_SBVERSION;
 		sbflags |= (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
@@ -1396,7 +1459,7 @@ xfs_qm_init_quotainos(
 	}
 
 	/*
-	 * Create the two inodes, if they don't exist already. The changes
+	 * Create the three inodes, if they don't exist already. The changes
 	 * made above will get added to a transaction and logged in one of
 	 * the qino_alloc calls below.  If the device is readonly,
 	 * temporarily switch to read-write to do this.
@@ -1409,14 +1472,26 @@ xfs_qm_init_quotainos(
 
 		flags &= ~XFS_QMOPT_SBVERSION;
 	}
-	if (XFS_IS_OQUOTA_ON(mp) && gip == NULL) {
-		flags |= (XFS_IS_GQUOTA_ON(mp) ?
-				XFS_QMOPT_GQUOTA : XFS_QMOPT_PQUOTA);
+	if (XFS_IS_GQUOTA_ON(mp) && gip == NULL) {
 		error = xfs_qm_qino_alloc(mp, &gip,
-					  sbflags | XFS_SB_GQUOTINO, flags);
+					     sbflags | XFS_SB_GQUOTINO,
+					     flags | XFS_QMOPT_GQUOTA);
+		if (error) {
+			if (uip)
+				IRELE(uip);
+
+			return XFS_ERROR(error);
+		}
+	}
+	if (XFS_IS_PQUOTA_ON(mp) && pip == NULL) {
+		error = xfs_qm_qino_alloc(mp, &pip,
+					     sbflags | XFS_SB_GQUOTINO,
+					     flags | XFS_QMOPT_PQUOTA);
 		if (error) {
 			if (uip)
 				IRELE(uip);
+			if (gip)
+				IRELE(gip);
 
 			return XFS_ERROR(error);
 		}
@@ -1424,6 +1499,7 @@ xfs_qm_init_quotainos(
 
 	mp->m_quotainfo->qi_uquotaip = uip;
 	mp->m_quotainfo->qi_gquotaip = gip;
+	mp->m_quotainfo->qi_pquotaip = pip;
 
 	return 0;
 }
@@ -1621,10 +1697,11 @@ xfs_qm_vop_dqalloc(
 	prid_t			prid,
 	uint			flags,
 	struct xfs_dquot	**O_udqpp,
-	struct xfs_dquot	**O_gdqpp)
+	struct xfs_dquot	**O_gdqpp,
+	struct xfs_dquot	**O_pdqpp)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_dquot	*uq, *gq;
+	struct xfs_dquot	*uq, *gq, *pq;
 	int			error;
 	uint			lockflags;
 
@@ -1649,7 +1726,7 @@ xfs_qm_vop_dqalloc(
 		}
 	}
 
-	uq = gq = NULL;
+	uq = gq = pq = NULL;
 	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
 		if (ip->i_d.di_uid != uid) {
 			/*
@@ -1705,25 +1782,28 @@ xfs_qm_vop_dqalloc(
 			ASSERT(ip->i_gdquot);
 			gq = xfs_qm_dqhold(ip->i_gdquot);
 		}
-	} else if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
+	}
+	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
 		if (xfs_get_projid(ip) != prid) {
 			xfs_iunlock(ip, lockflags);
 			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)prid,
 						 XFS_DQ_PROJ,
 						 XFS_QMOPT_DQALLOC |
 						 XFS_QMOPT_DOWARN,
-						 &gq))) {
+						 &pq))) {
 				if (uq)
 					xfs_qm_dqrele(uq);
+				if (gq)
+					xfs_qm_dqrele(gq);
 				ASSERT(error != ENOENT);
 				return (error);
 			}
-			xfs_dqunlock(gq);
+			xfs_dqunlock(pq);
 			lockflags = XFS_ILOCK_SHARED;
 			xfs_ilock(ip, lockflags);
 		} else {
-			ASSERT(ip->i_gdquot);
-			gq = xfs_qm_dqhold(ip->i_gdquot);
+			ASSERT(ip->i_pdquot);
+			pq = xfs_qm_dqhold(ip->i_pdquot);
 		}
 	}
 	if (uq)
@@ -1738,6 +1818,10 @@ xfs_qm_vop_dqalloc(
 		*O_gdqpp = gq;
 	else if (gq)
 		xfs_qm_dqrele(gq);
+	if (O_pdqpp)
+		*O_pdqpp = pq;
+	else if (pq)
+		xfs_qm_dqrele(pq);
 	return 0;
 }
 
@@ -1790,11 +1874,13 @@ xfs_qm_vop_chown_reserve(
 	xfs_inode_t	*ip,
 	xfs_dquot_t	*udqp,
 	xfs_dquot_t	*gdqp,
+	xfs_dquot_t	*pdqp,
 	uint		flags)
 {
 	xfs_mount_t	*mp = ip->i_mount;
 	uint		delblks, blkflags, prjflags = 0;
-	xfs_dquot_t	*unresudq, *unresgdq, *delblksudq, *delblksgdq;
+	xfs_dquot_t	*unresudq, *unresgdq, *unrespdq;
+	xfs_dquot_t	*delblksudq, *delblksgdq, *delblkspdq;
 	int		error;
 
 
@@ -1802,7 +1888,8 @@ xfs_qm_vop_chown_reserve(
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
 	delblks = ip->i_delayed_blks;
-	delblksudq = delblksgdq = unresudq = unresgdq = NULL;
+	delblksudq = delblksgdq = delblkspdq = NULL;
+	unresudq = unresgdq = unrespdq = NULL;
 	blkflags = XFS_IS_REALTIME_INODE(ip) ?
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
@@ -1819,25 +1906,28 @@ xfs_qm_vop_chown_reserve(
 			unresudq = ip->i_udquot;
 		}
 	}
-	if (XFS_IS_OQUOTA_ON(ip->i_mount) && gdqp) {
-		if (XFS_IS_PQUOTA_ON(ip->i_mount) &&
-		     xfs_get_projid(ip) != be32_to_cpu(gdqp->q_core.d_id))
-			prjflags = XFS_QMOPT_ENOSPC;
-
-		if (prjflags ||
-		    (XFS_IS_GQUOTA_ON(ip->i_mount) &&
-		     ip->i_d.di_gid != be32_to_cpu(gdqp->q_core.d_id))) {
-			delblksgdq = gdqp;
-			if (delblks) {
-				ASSERT(ip->i_gdquot);
-				unresgdq = ip->i_gdquot;
-			}
+	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
+	    ip->i_d.di_gid != be32_to_cpu(gdqp->q_core.d_id)) {
+		delblksgdq = gdqp;
+		if (delblks) {
+			ASSERT(ip->i_gdquot);
+			unresgdq = ip->i_gdquot;
+		}
+	}
+
+	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
+	    xfs_get_projid(ip) != be32_to_cpu(pdqp->q_core.d_id)) {
+		prjflags = XFS_QMOPT_ENOSPC;
+		delblkspdq = pdqp;
+		if (delblks) {
+			ASSERT(ip->i_pdquot);
+			unrespdq = ip->i_pdquot;
 		}
 	}
 
 	if ((error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
-				delblksudq, delblksgdq, ip->i_d.di_nblocks, 1,
-				flags | blkflags | prjflags)))
+			delblksudq, delblksgdq, delblkspdq, ip->i_d.di_nblocks,
+			1, flags | blkflags | prjflags)))
 		return (error);
 
 	/*
@@ -1850,15 +1940,16 @@ xfs_qm_vop_chown_reserve(
 		/*
 		 * Do the reservations first. Unreservation can't fail.
 		 */
-		ASSERT(delblksudq || delblksgdq);
-		ASSERT(unresudq || unresgdq);
+		ASSERT(delblksudq || delblksgdq || delblkspdq);
+		ASSERT(unresudq || unresgdq || unrespdq);
 		if ((error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
-				delblksudq, delblksgdq, (xfs_qcnt_t)delblks, 0,
+				delblksudq, delblksgdq, delblkspdq,
+				(xfs_qcnt_t)delblks, 0,
 				flags | blkflags | prjflags)))
 			return (error);
 		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
-				unresudq, unresgdq, -((xfs_qcnt_t)delblks), 0,
-				blkflags);
+				unresudq, unresgdq, unrespdq,
+				-((xfs_qcnt_t)delblks), 0, blkflags);
 	}
 
 	return (0);
@@ -1897,7 +1988,8 @@ xfs_qm_vop_create_dqattach(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	struct xfs_dquot	*udqp,
-	struct xfs_dquot	*gdqp)
+	struct xfs_dquot	*gdqp,
+	struct xfs_dquot	*pdqp)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 
@@ -1917,13 +2009,18 @@ xfs_qm_vop_create_dqattach(
 	}
 	if (gdqp) {
 		ASSERT(ip->i_gdquot == NULL);
-		ASSERT(XFS_IS_OQUOTA_ON(mp));
-		ASSERT((XFS_IS_GQUOTA_ON(mp) ?
-			ip->i_d.di_gid : xfs_get_projid(ip)) ==
-				be32_to_cpu(gdqp->q_core.d_id));
-
+		ASSERT(XFS_ISGOQUOTA_ON(mp));
+		ASSERT(ip->i_d.di_gid == be32_to_cpu(gdqp->q_core.d_id));
 		ip->i_gdquot = xfs_qm_dqhold(gdqp);
 		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
+	if (pdqp) {
+		ASSERT(ip->i_pdquot == NULL);
+		ASSERT(XFS_IS_PQUOTA_ON(mp));
+		ASSERT(xfs_get_projid(ip) == be32_to_cpu(pdqp->q_core.d_id));
+
+		ip->i_pdquot = xfs_qm_dqhold(pdqp);
+		xfs_trans_mod_dquot(tp, pdqp, XFS_TRANS_DQ_ICOUNT, 1);
+	}
 }
 
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 44b858b..256ff71 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -44,9 +44,11 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
 typedef struct xfs_quotainfo {
 	struct radix_tree_root qi_uquota_tree;
 	struct radix_tree_root qi_gquota_tree;
+	struct radix_tree_root qi_pquota_tree;
 	struct mutex qi_tree_lock;
 	xfs_inode_t	*qi_uquotaip;	 /* user quota inode */
 	xfs_inode_t	*qi_gquotaip;	 /* group quota inode */
+	xfs_inode_t	*qi_pquotaip;	 /* project quota inode */
 	struct list_head qi_lru_list;
 	struct mutex	 qi_lru_lock;
 	int		 qi_lru_count;
@@ -70,26 +72,25 @@ typedef struct xfs_quotainfo {
 } xfs_quotainfo_t;
 
 #define XFS_DQUOT_TREE(qi, type) \
-	((type & XFS_DQ_USER) ? \
-	 &((qi)->qi_uquota_tree) : \
-	 &((qi)->qi_gquota_tree))
+	((type & XFS_DQ_USER) ? &((qi)->qi_uquota_tree) : \
+	((type & XFS_DQ_GROUP) ? &((qi)->qi_gquota_tree) : \
+	 &((qi)->qi_pquota_tree)))
 
 
 extern void	xfs_trans_mod_dquot(xfs_trans_t *, xfs_dquot_t *, uint, long);
-extern int	xfs_trans_reserve_quota_bydquots(xfs_trans_t *, xfs_mount_t *,
-			xfs_dquot_t *, xfs_dquot_t *, long, long, uint);
 extern void	xfs_trans_dqjoin(xfs_trans_t *, xfs_dquot_t *);
 extern void	xfs_trans_log_dquot(xfs_trans_t *, xfs_dquot_t *);
 
 /*
- * We keep the usr and grp dquots separately so that locking will be easier
- * to do at commit time. All transactions that we know of at this point
+ * We keep the usr, grp, and prj dquots separately so that locking will be
+ * easier to do at commit time. All transactions that we know of at this point
  * affect no more than two dquots of one type. Hence, the TRANS_MAXDQS value.
  */
 #define XFS_QM_TRANS_MAXDQS		2
 typedef struct xfs_dquot_acct {
 	xfs_dqtrx_t	dqa_usrdquots[XFS_QM_TRANS_MAXDQS];
 	xfs_dqtrx_t	dqa_grpdquots[XFS_QM_TRANS_MAXDQS];
+	xfs_dqtrx_t	dqa_prjdquots[XFS_QM_TRANS_MAXDQS];
 } xfs_dquot_acct_t;
 
 /*
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 6b39115..eb45424 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -115,7 +115,7 @@ xfs_qm_newmount(
 	     (pquotaondisk && !XFS_IS_PQUOTA_ON(mp)) ||
 	    (!pquotaondisk &&  XFS_IS_PQUOTA_ON(mp)) ||
 	     (gquotaondisk && !XFS_IS_GQUOTA_ON(mp)) ||
-	    (!gquotaondisk &&  XFS_IS_OQUOTA_ON(mp)))  &&
+	    (!gquotaondisk &&  XFS_IS_GQUOTA_ON(mp)))  &&
 	    xfs_dev_is_read_only(mp, "changing quota state")) {
 		xfs_warn(mp, "please mount with%s%s%s%s.",
 			(!quotaondisk ? "out quota" : ""),
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 76cf0ca..509bbf7 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -118,7 +118,8 @@ xfs_qm_scall_quotaoff(
 		dqtype |= XFS_QMOPT_GQUOTA;
 		flags |= (XFS_GQUOTA_CHKD | XFS_GQUOTA_ENFD);
 		inactivate_flags |= XFS_GQUOTA_ACTIVE;
-	} else if (flags & XFS_PQUOTA_ACCT) {
+	}
+	if (flags & XFS_PQUOTA_ACCT) {
 		dqtype |= XFS_QMOPT_PQUOTA;
 		flags |= (XFS_PQUOTA_CHKD | XFS_PQUOTA_ENFD);
 		inactivate_flags |= XFS_PQUOTA_ACTIVE;
@@ -213,10 +214,14 @@ xfs_qm_scall_quotaoff(
 		IRELE(q->qi_uquotaip);
 		q->qi_uquotaip = NULL;
 	}
-	if ((dqtype & (XFS_QMOPT_GQUOTA|XFS_QMOPT_PQUOTA)) && q->qi_gquotaip) {
+	if ((dqtype & XFS_QMOPT_GQUOTA) && q->qi_gquotaip) {
 		IRELE(q->qi_gquotaip);
 		q->qi_gquotaip = NULL;
 	}
+	if ((dqtype & XFS_QMOPT_PQUOTA) && q->qi_pquotaip) {
+		IRELE(q->qi_pquotaip);
+		q->qi_pquotaip = NULL;
+	}
 
 out_unlock:
 	mutex_unlock(&q->qi_quotaofflock);
@@ -853,9 +858,11 @@ xfs_dqrele_inode(
 {
 	/* skip quota inodes */
 	if (ip == ip->i_mount->m_quotainfo->qi_uquotaip ||
-	    ip == ip->i_mount->m_quotainfo->qi_gquotaip) {
+	    ip == ip->i_mount->m_quotainfo->qi_gquotaip ||
+	    ip == ip->i_mount->m_quotainfo->qi_pquotaip) {
 		ASSERT(ip->i_udquot == NULL);
 		ASSERT(ip->i_gdquot == NULL);
+		ASSERT(ip->i_pdquot == NULL);
 		return 0;
 	}
 
@@ -864,10 +871,14 @@ xfs_dqrele_inode(
 		xfs_qm_dqrele(ip->i_udquot);
 		ip->i_udquot = NULL;
 	}
-	if (flags & (XFS_PQUOTA_ACCT|XFS_GQUOTA_ACCT) && ip->i_gdquot) {
+	if ((flags & XFS_GQUOTA_ACCT) && ip->i_gdquot) {
 		xfs_qm_dqrele(ip->i_gdquot);
 		ip->i_gdquot = NULL;
 	}
+	if ((flags & XFS_PQUOTA_ACCT) && ip->i_pdquot) {
+		xfs_qm_dqrele(ip->i_pdquot);
+		ip->i_pdquot = NULL;
+	}
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return 0;
 }
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index d7205b0..1c61c9b 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -186,9 +186,9 @@ typedef struct xfs_qoff_logformat {
  * are in the process of getting turned off. These flags are in m_qflags but
  * never in sb_qflags.
  */
-#define XFS_UQUOTA_ACTIVE	0x0100  /* uquotas are being turned off */
-#define XFS_PQUOTA_ACTIVE	0x0200  /* pquotas are being turned off */
-#define XFS_GQUOTA_ACTIVE	0x0400  /* gquotas are being turned off */
+#define XFS_UQUOTA_ACTIVE	0x1000  /* uquotas are being turned off */
+#define XFS_PQUOTA_ACTIVE	0x2000  /* pquotas are being turned off */
+#define XFS_GQUOTA_ACTIVE	0x4000  /* gquotas are being turned off */
 #define XFS_ALL_QUOTA_ACTIVE	\
 	(XFS_UQUOTA_ACTIVE | XFS_PQUOTA_ACTIVE | XFS_GQUOTA_ACTIVE)
 
@@ -199,8 +199,6 @@ typedef struct xfs_qoff_logformat {
 #define XFS_IS_QUOTA_ON(mp)	((mp)->m_qflags & (XFS_UQUOTA_ACTIVE | \
 						   XFS_GQUOTA_ACTIVE | \
 						   XFS_PQUOTA_ACTIVE))
-#define XFS_IS_OQUOTA_ON(mp)	((mp)->m_qflags & (XFS_GQUOTA_ACTIVE | \
-						   XFS_PQUOTA_ACTIVE))
 #define XFS_IS_UQUOTA_ON(mp)	((mp)->m_qflags & XFS_UQUOTA_ACTIVE)
 #define XFS_IS_GQUOTA_ON(mp)	((mp)->m_qflags & XFS_GQUOTA_ACTIVE)
 #define XFS_IS_PQUOTA_ON(mp)	((mp)->m_qflags & XFS_PQUOTA_ACTIVE)
@@ -267,8 +265,10 @@ typedef struct xfs_qoff_logformat {
  */
 #define XFS_NOT_DQATTACHED(mp, ip) ((XFS_IS_UQUOTA_ON(mp) &&\
 				     (ip)->i_udquot == NULL) || \
-				    (XFS_IS_OQUOTA_ON(mp) && \
-				     (ip)->i_gdquot == NULL))
+				    (XFS_IS_GQUOTA_ON(mp) && \
+				     (ip)->i_gdquot == NULL) || \
+				    (XFS_IS_PQUOTA_ON(mp) && \
+				     (ip)->i_pdquot == NULL))
 
 #define XFS_QM_NEED_QUOTACHECK(mp) \
 	((XFS_IS_UQUOTA_ON(mp) && \
@@ -323,17 +323,18 @@ extern int xfs_trans_reserve_quota_nblks(struct xfs_trans *,
 		struct xfs_inode *, long, long, uint);
 extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
 		struct xfs_mount *, struct xfs_dquot *,
-		struct xfs_dquot *, long, long, uint);
+		struct xfs_dquot *, struct xfs_dquot *, long, long, uint);
 
 extern int xfs_qm_vop_dqalloc(struct xfs_inode *, uid_t, gid_t, prid_t, uint,
-		struct xfs_dquot **, struct xfs_dquot **);
+		struct xfs_dquot **, struct xfs_dquot **, struct xfs_dquot **);
 extern void xfs_qm_vop_create_dqattach(struct xfs_trans *, struct xfs_inode *,
-		struct xfs_dquot *, struct xfs_dquot *);
+		struct xfs_dquot *, struct xfs_dquot *, struct xfs_dquot *);
 extern int xfs_qm_vop_rename_dqattach(struct xfs_inode **);
 extern struct xfs_dquot *xfs_qm_vop_chown(struct xfs_trans *,
 		struct xfs_inode *, struct xfs_dquot **, struct xfs_dquot *);
 extern int xfs_qm_vop_chown_reserve(struct xfs_trans *, struct xfs_inode *,
-		struct xfs_dquot *, struct xfs_dquot *, uint);
+		struct xfs_dquot *, struct xfs_dquot *,
+		struct xfs_dquot *, uint);
 extern int xfs_qm_dqattach(struct xfs_inode *, uint);
 extern int xfs_qm_dqattach_locked(struct xfs_inode *, uint);
 extern void xfs_qm_dqdetach(struct xfs_inode *);
@@ -347,10 +348,12 @@ extern void xfs_qm_unmount_quotas(struct xfs_mount *);
 #else
 static inline int
 xfs_qm_vop_dqalloc(struct xfs_inode *ip, uid_t uid, gid_t gid, prid_t prid,
-		uint flags, struct xfs_dquot **udqp, struct xfs_dquot **gdqp)
+		uint flags, struct xfs_dquot **udqp, struct xfs_dquot **gdqp,
+		xfs_dquot **pdqp)
 {
 	*udqp = NULL;
 	*gdqp = NULL;
+	*pdqp = NULL;
 	return 0;
 }
 #define xfs_trans_dup_dqinfo(tp, tp2)
@@ -365,14 +368,15 @@ static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp,
 }
 static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
 		struct xfs_mount *mp, struct xfs_dquot *udqp,
-		struct xfs_dquot *gdqp, long nblks, long nions, uint flags)
+		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp,
+		long nblks, long nions, uint flags)
 {
 	return 0;
 }
-#define xfs_qm_vop_create_dqattach(tp, ip, u, g)
+#define xfs_qm_vop_create_dqattach(tp, ip, u, g, p)
 #define xfs_qm_vop_rename_dqattach(it)					(0)
 #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
-#define xfs_qm_vop_chown_reserve(tp, ip, u, g, fl)			(0)
+#define xfs_qm_vop_chown_reserve(tp, ip, u, g, p, fl)			(0)
 #define xfs_qm_dqattach(ip, fl)						(0)
 #define xfs_qm_dqattach_locked(ip, fl)					(0)
 #define xfs_qm_dqdetach(ip)
@@ -386,8 +390,8 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
 
 #define xfs_trans_unreserve_quota_nblks(tp, ip, nblks, ninos, flags) \
 	xfs_trans_reserve_quota_nblks(tp, ip, -(nblks), -(ninos), flags)
-#define xfs_trans_reserve_quota(tp, mp, ud, gd, nb, ni, f) \
-	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, nb, ni, \
+#define xfs_trans_reserve_quota(tp, mp, ud, gd, pd, nb, ni, f) \
+	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, pd, nb, ni, \
 				f | XFS_QMOPT_RES_REGBLKS)
 
 extern int xfs_qm_dqcheck(struct xfs_mount *, xfs_disk_dquot_t *,
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index f429d9d..8fd7894 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -140,6 +140,7 @@ typedef struct xfs_sb {
 	 */
 	xfs_ino_t	sb_uquotino;	/* user quota inode */
 	xfs_ino_t	sb_gquotino;	/* group quota inode */
+#define sb_pquotino	sb_gquotino
 	__uint16_t	sb_qflags;	/* quota flags */
 	__uint8_t	sb_flags;	/* misc. flags */
 	__uint8_t	sb_shared_vn;	/* shared version number */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 61ac734..595f5ac 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -538,14 +538,13 @@ xfs_showargs(
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
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 40460e8..fa4045f 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -113,7 +113,7 @@ xfs_trans_dup_dqinfo(
 	if(otp->t_flags & XFS_TRANS_DQ_DIRTY)
 		ntp->t_flags |= XFS_TRANS_DQ_DIRTY;
 
-	for (j = 0; j < 2; j++) {
+	for (j = 0; j < 3; j++) { /* 0 - usr, 1 - grp, 2 - prj */
 		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
 			if (oqa[i].qt_dquot == NULL)
 				break;
@@ -138,8 +138,13 @@ xfs_trans_dup_dqinfo(
 			oq->qt_ino_res = oq->qt_ino_res_used;
 
 		}
-		oqa = otp->t_dqinfo->dqa_grpdquots;
-		nqa = ntp->t_dqinfo->dqa_grpdquots;
+		if (oqa == otp->t_dqinfo->dqa_usrdquots) {
+			oqa = otp->t_dqinfo->dqa_grpdquots;
+			nqa = ntp->t_dqinfo->dqa_grpdquots;
+		} else {
+			oqa = otp->t_dqinfo->dqa_prjdquots;
+			nqa = ntp->t_dqinfo->dqa_prjdquots;
+		}
 	}
 }
 
@@ -166,8 +171,10 @@ xfs_trans_mod_dquot_byino(
 
 	if (XFS_IS_UQUOTA_ON(mp) && ip->i_udquot)
 		(void) xfs_trans_mod_dquot(tp, ip->i_udquot, field, delta);
-	if (XFS_IS_OQUOTA_ON(mp) && ip->i_gdquot)
+	if (XFS_IS_GQUOTA_ON(mp) && ip->i_gdquot)
 		(void) xfs_trans_mod_dquot(tp, ip->i_gdquot, field, delta);
+	if (XFS_IS_PQUOTA_ON(mp) && ip->i_pdquot)
+		(void) xfs_trans_mod_dquot(tp, ip->i_pdquot, field, delta);
 }
 
 STATIC xfs_dqtrx_t *
@@ -178,15 +185,20 @@ xfs_trans_get_dqtrx(
 	int		i;
 	xfs_dqtrx_t	*qa;
 
-	qa = XFS_QM_ISUDQ(dqp) ?
-		tp->t_dqinfo->dqa_usrdquots : tp->t_dqinfo->dqa_grpdquots;
+	if (XFS_QM_ISUDQ(dqp))
+		qa = tp->t_dqinfo->dqa_usrdquots;
+	else if (XFS_QM_ISGDQ(dqp))
+		qa = tp->t_dqinfo->dqa_grpdquots;
+	else if (XFS_QM_ISPDQ(dqp))
+		qa = tp->t_dqinfo->dqa_prjdquots;
+	else
+		return NULL;
 
 	for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
 		if (qa[i].qt_dquot == NULL ||
 		    qa[i].qt_dquot == dqp)
 			return &qa[i];
 	}
-
 	return NULL;
 }
 
@@ -340,9 +352,12 @@ xfs_trans_apply_dquot_deltas(
 
 	ASSERT(tp->t_dqinfo);
 	qa = tp->t_dqinfo->dqa_usrdquots;
-	for (j = 0; j < 2; j++) {
+	for (j = 0; j < 3; j++) { /* 0 - usr, 1 - grp, 2 - prj */
 		if (qa[0].qt_dquot == NULL) {
-			qa = tp->t_dqinfo->dqa_grpdquots;
+			if (qa == tp->t_dqinfo->dqa_usrdquots)
+				qa = tp->t_dqinfo->dqa_grpdquots;
+			else
+				qa = tp->t_dqinfo->dqa_prjdquots;
 			continue;
 		}
 
@@ -496,9 +511,12 @@ xfs_trans_apply_dquot_deltas(
 				be64_to_cpu(dqp->q_core.d_rtbcount));
 		}
 		/*
-		 * Do the group quotas next
+		 * Do the group quotas or project quotas next
 		 */
-		qa = tp->t_dqinfo->dqa_grpdquots;
+		if (qa == tp->t_dqinfo->dqa_usrdquots)
+			qa = tp->t_dqinfo->dqa_grpdquots;
+		else
+			qa = tp->t_dqinfo->dqa_prjdquots;
 	}
 }
 
@@ -523,7 +541,7 @@ xfs_trans_unreserve_and_mod_dquots(
 
 	qa = tp->t_dqinfo->dqa_usrdquots;
 
-	for (j = 0; j < 2; j++) {
+	for (j = 0; j < 3; j++) { /* 0 - usr, 1 - grp, 2 - prj */
 		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
 			qtrx = &qa[i];
 			/*
@@ -565,7 +583,10 @@ xfs_trans_unreserve_and_mod_dquots(
 				xfs_dqunlock(dqp);
 
 		}
-		qa = tp->t_dqinfo->dqa_grpdquots;
+		if (qa == tp->t_dqinfo->dqa_usrdquots)
+			qa = tp->t_dqinfo->dqa_grpdquots;
+		else
+			qa = tp->t_dqinfo->dqa_prjdquots;
 	}
 }
 
@@ -734,8 +755,8 @@ error_return:
 
 /*
  * Given dquot(s), make disk block and/or inode reservations against them.
- * The fact that this does the reservation against both the usr and
- * grp/prj quotas is important, because this follows a both-or-nothing
+ * The fact that this does the reservation against user, group and
+ * project quotas is important, because this follows a all-or-nothing
  * approach.
  *
  * flags = XFS_QMOPT_FORCE_RES evades limit enforcement. Used by chown.
@@ -750,6 +771,7 @@ xfs_trans_reserve_quota_bydquots(
 	xfs_mount_t	*mp,
 	xfs_dquot_t	*udqp,
 	xfs_dquot_t	*gdqp,
+	xfs_dquot_t	*pdqp,
 	long		nblks,
 	long		ninos,
 	uint		flags)
@@ -787,6 +809,24 @@ xfs_trans_reserve_quota_bydquots(
 		}
 	}
 
+	if (pdqp) {
+		error = xfs_trans_dqresv(tp, mp, pdqp, nblks, ninos, flags);
+		if (error) {
+			/*
+			 * can't do it, so backout previous reservation
+			 */
+			if (resvd) {
+				flags |= XFS_QMOPT_FORCE_RES;
+				xfs_trans_dqresv(tp, mp, udqp,
+						 -nblks, -ninos, flags);
+				if (gdqp)
+					xfs_trans_dqresv(tp, mp, gdqp,
+						 -nblks, -ninos, flags);
+			}
+			return error;
+		}
+	}
+
 	/*
 	 * Didn't change anything critical, so, no need to log
 	 */
@@ -828,6 +868,7 @@ xfs_trans_reserve_quota_nblks(
 	 */
 	return xfs_trans_reserve_quota_bydquots(tp, mp,
 						ip->i_udquot, ip->i_gdquot,
+						ip->i_pdquot,
 						nblks, ninos, flags);
 }
 
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index c22f4e0..e97f1f7 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -849,6 +849,7 @@ xfs_create(
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
+	struct xfs_dquot	*pdqp = NULL;
 	uint			resblks;
 	uint			log_res;
 	uint			log_count;
@@ -867,7 +868,7 @@ xfs_create(
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
 	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
-			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
+		XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp, &pdqp);
 	if (error)
 		return error;
 
@@ -919,7 +920,8 @@ xfs_create(
 	/*
 	 * Reserve disk quota and the inode.
 	 */
-	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp, resblks, 1, 0);
+	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
+						pdqp, resblks, 1, 0);
 	if (error)
 		goto out_trans_cancel;
 
@@ -983,7 +985,7 @@ xfs_create(
 	 * These ids of the inode couldn't have changed since the new
 	 * inode has been locked ever since it was created.
 	 */
-	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp);
+	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
 
 	error = xfs_bmap_finish(&tp, &free_list, &committed);
 	if (error)
@@ -995,6 +997,7 @@ xfs_create(
 
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
 	return 0;
@@ -1016,6 +1019,7 @@ xfs_create(
 
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
 
 	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
@@ -1498,7 +1502,7 @@ xfs_symlink(
 	int			n;
 	xfs_buf_t		*bp;
 	prid_t			prid;
-	struct xfs_dquot	*udqp, *gdqp;
+	struct xfs_dquot	*udqp = NULL, *gdqp = NULL, *pdqp = NULL;
 	uint			resblks;
 
 	*ipp = NULL;
@@ -1528,7 +1532,7 @@ xfs_symlink(
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
 	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
-			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
+		XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp, &pdqp);
 	if (error)
 		goto std_return;
 
@@ -1569,7 +1573,8 @@ xfs_symlink(
 	/*
 	 * Reserve disk quota : blocks and inode.
 	 */
-	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp, resblks, 1, 0);
+	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
+						pdqp, resblks, 1, 0);
 	if (error)
 		goto error_return;
 
@@ -1607,7 +1612,7 @@ xfs_symlink(
 	/*
 	 * Also attach the dquot(s) to it, if applicable.
 	 */
-	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp);
+	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
 
 	if (resblks)
 		resblks -= XFS_IALLOC_SPACE_RES(mp);
@@ -1691,6 +1696,7 @@ xfs_symlink(
 	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
 	return 0;
@@ -1704,6 +1710,7 @@ xfs_symlink(
 	xfs_trans_cancel(tp, cancel_flags);
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
 
 	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
@@ -2170,7 +2177,7 @@ xfs_free_file_space(
 		}
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		error = xfs_trans_reserve_quota(tp, mp,
-				ip->i_udquot, ip->i_gdquot,
+				ip->i_udquot, ip->i_gdquot, ip->i_pdquot,
 				resblks, 0, XFS_QMOPT_RES_REGBLKS);
 		if (error)
 			goto error1;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
