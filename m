Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 19D2F7F63
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 17:25:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7D342AC001
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 15:25:38 -0700 (PDT)
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152]) by
	cuda.sgi.com with ESMTP id bPGGzg4OIaJqZJ2u (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Jun 2013 15:25:36 -0700 (PDT)
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 27 Jun 2013 16:25:36 -0600
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id CD18B1FF001B
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:20:16 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5RMPWme156936 for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:25:32 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r5RMPWWC018960
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:25:32 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v10 08/11] xfs: Add pquota fields where gquota is used.
Date: Thu, 27 Jun 2013 17:25:11 -0500
Message-Id: <1372371914-11370-9-git-send-email-sekharan@us.ibm.com>
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

Add project quota changes to all the places where group quota field
is used:
   * add separate project quota members into various structures
   * split project quota and group quotas so that instead of overriding
     the group quota members incore, the new project quota members are
     used instead
   * get rid of usage of the OQUOTA flag incore, in favor of separate
   * group and project quota flags.
   * add a project dquot argument to various functions.

Not using the pquotino field from superblock yet.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_dquot.c       |   15 +++-
 fs/xfs/xfs_dquot.h       |    7 +-
 fs/xfs/xfs_icache.c      |    1 +
 fs/xfs/xfs_inode.h       |    1 +
 fs/xfs/xfs_ioctl.c       |   14 ++--
 fs/xfs/xfs_iops.c        |    4 +-
 fs/xfs/xfs_qm.c          |  241 +++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_qm.h          |   16 ++-
 fs/xfs/xfs_qm_bhv.c      |    2 +-
 fs/xfs/xfs_qm_syscalls.c |   19 +++-
 fs/xfs/xfs_quota.h       |   32 ++++---
 fs/xfs/xfs_symlink.c     |   10 ++-
 fs/xfs/xfs_trans_dquot.c |   26 ++++-
 fs/xfs/xfs_vnodeops.c    |   13 ++-
 14 files changed, 283 insertions(+), 118 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index f01012d..0adf27e 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -936,6 +936,7 @@ xfs_qm_dqput_final(
 {
 	struct xfs_quotainfo	*qi = dqp->q_mount->m_quotainfo;
 	struct xfs_dquot	*gdqp;
+	struct xfs_dquot	*pdqp;
 
 	trace_xfs_dqput_free(dqp);
 
@@ -949,21 +950,29 @@ xfs_qm_dqput_final(
 
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
index b596626..55abbca 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -53,6 +53,7 @@ typedef struct xfs_dquot {
 	xfs_fileoff_t	 q_fileoffset;	/* offset in quotas file */
 
 	struct xfs_dquot*q_gdquot;	/* group dquot, hint only */
+	struct xfs_dquot*q_pdquot;	/* project dquot, hint only */
 	xfs_disk_dquot_t q_core;	/* actual usage & quotas */
 	xfs_dq_logitem_t q_logitem;	/* dquot log item */
 	xfs_qcnt_t	 q_res_bcount;	/* total regular nblks used+reserved */
@@ -118,8 +119,9 @@ static inline int xfs_this_quota_on(struct xfs_mount *mp, int type)
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
@@ -131,8 +133,9 @@ static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
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
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 9560dc1..3f90e1c 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -337,6 +337,7 @@ xfs_iget_cache_miss(
 		iflags |= XFS_IDONTCACHE;
 	ip->i_udquot = NULL;
 	ip->i_gdquot = NULL;
+	ip->i_pdquot = NULL;
 	xfs_iflags_set(ip, iflags);
 
 	/* insert the new inode */
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 9112979..b55fd34 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -250,6 +250,7 @@ typedef struct xfs_inode {
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
 	struct xfs_dquot	*i_udquot;	/* user dquot */
 	struct xfs_dquot	*i_gdquot;	/* group dquot */
+	struct xfs_dquot	*i_pdquot;	/* project dquot */
 
 	/* Inode location stuff */
 	xfs_ino_t		i_ino;		/* inode number (agno/agino)*/
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5e99968..71a8bc5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -928,7 +928,7 @@ xfs_ioctl_setattr(
 	struct xfs_trans	*tp;
 	unsigned int		lock_flags = 0;
 	struct xfs_dquot	*udqp = NULL;
-	struct xfs_dquot	*gdqp = NULL;
+	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_dquot	*olddquot = NULL;
 	int			code;
 
@@ -957,7 +957,7 @@ xfs_ioctl_setattr(
 	if (XFS_IS_QUOTA_ON(mp) && (mask & FSX_PROJID)) {
 		code = xfs_qm_vop_dqalloc(ip, ip->i_d.di_uid,
 					 ip->i_d.di_gid, fa->fsx_projid,
-					 XFS_QMOPT_PQUOTA, &udqp, &gdqp);
+					 XFS_QMOPT_PQUOTA, &udqp, NULL, &pdqp);
 		if (code)
 			return code;
 	}
@@ -994,8 +994,8 @@ xfs_ioctl_setattr(
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
@@ -1113,7 +1113,7 @@ xfs_ioctl_setattr(
 		if (xfs_get_projid(ip) != fa->fsx_projid) {
 			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
 				olddquot = xfs_qm_vop_chown(tp, ip,
-							&ip->i_gdquot, gdqp);
+							&ip->i_pdquot, pdqp);
 			}
 			xfs_set_projid(ip, fa->fsx_projid);
 
@@ -1160,13 +1160,13 @@ xfs_ioctl_setattr(
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
index c69bbc4..2ae62d2 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -539,7 +539,7 @@ xfs_setattr_nonsize(
 		ASSERT(udqp == NULL);
 		ASSERT(gdqp == NULL);
 		error = xfs_qm_vop_dqalloc(ip, uid, gid, xfs_get_projid(ip),
-					 qflags, &udqp, &gdqp);
+					 qflags, &udqp, &gdqp, NULL);
 		if (error)
 			return error;
 	}
@@ -575,7 +575,7 @@ xfs_setattr_nonsize(
 		     (XFS_IS_GQUOTA_ON(mp) && igid != gid))) {
 			ASSERT(tp);
 			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
-						capable(CAP_FOWNER) ?
+						NULL, capable(CAP_FOWNER) ?
 						XFS_QMOPT_FORCE_RES : 0);
 			if (error)	/* out of quota */
 				goto out_trans_cancel;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 7a3e007..42055ca 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -137,6 +137,7 @@ xfs_qm_dqpurge(
 	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 	struct xfs_dquot	*gdqp = NULL;
+	struct xfs_dquot	*pdqp = NULL;
 
 	xfs_dqlock(dqp);
 	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0) {
@@ -145,8 +146,7 @@ xfs_qm_dqpurge(
 	}
 
 	/*
-	 * If this quota has a group hint attached, prepare for releasing it
-	 * now.
+	 * If this quota has a hint attached, prepare for releasing it now.
 	 */
 	gdqp = dqp->q_gdquot;
 	if (gdqp) {
@@ -154,6 +154,12 @@ xfs_qm_dqpurge(
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
@@ -208,6 +214,8 @@ xfs_qm_dqpurge(
 
 	if (gdqp)
 		xfs_qm_dqput(gdqp);
+	if (pdqp)
+		xfs_qm_dqput(pdqp);
 	return 0;
 }
 
@@ -364,6 +372,10 @@ xfs_qm_unmount_quotas(
 			IRELE(mp->m_quotainfo->qi_gquotaip);
 			mp->m_quotainfo->qi_gquotaip = NULL;
 		}
+		if (mp->m_quotainfo->qi_pquotaip) {
+			IRELE(mp->m_quotainfo->qi_pquotaip);
+			mp->m_quotainfo->qi_pquotaip = NULL;
+		}
 	}
 }
 
@@ -410,7 +422,10 @@ xfs_qm_dqattach_one(
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
 
@@ -453,28 +468,40 @@ xfs_qm_dqattach_one(
 
 
 /*
- * Given a udquot and gdquot, attach a ptr to the group dquot in the
- * udquot as a hint for future lookups.
+ * Given a udquot and group/project type, attach the group/project
+ * dquot pointer to the udquot as a hint for future lookups.
  */
 STATIC void
-xfs_qm_dqattach_grouphint(
-	xfs_dquot_t	*udq,
-	xfs_dquot_t	*gdq)
+xfs_qm_dqattach_hint(
+	struct xfs_inode	*ip,
+	int			type)
 {
-	xfs_dquot_t	*tmp;
+	struct xfs_dquot **dqhint;
+	struct xfs_dquot *dqp;
+	struct xfs_dquot *udq = ip->i_udquot;
 
 	xfs_dqlock(udq);
 
-	tmp = udq->q_gdquot;
-	if (tmp) {
-		if (tmp == gdq)
+	if (type == XFS_DQ_GROUP) {
+		dqp = ip->i_gdquot;
+		dqhint = &udq->q_gdquot;
+	} else {
+		dqp = ip->i_pdquot;
+		dqhint = &udq->q_pdquot;
+	}
+
+	if (*dqhint) {
+		struct xfs_dquot *tmp;
+
+		if (*dqhint == dqp)
 			goto done;
 
-		udq->q_gdquot = NULL;
+		tmp = *dqhint;
+		*dqhint = NULL;
 		xfs_qm_dqrele(tmp);
 	}
 
-	udq->q_gdquot = xfs_qm_dqhold(gdq);
+	*dqhint = xfs_qm_dqhold(dqp);
 done:
 	xfs_dqunlock(udq);
 }
@@ -527,12 +554,8 @@ xfs_qm_dqattach_locked(
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
@@ -544,14 +567,28 @@ xfs_qm_dqattach_locked(
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
@@ -560,7 +597,10 @@ xfs_qm_dqattach_locked(
 		 * succeed in general.
 		 */
 		if (ip->i_udquot->q_gdquot != ip->i_gdquot)
-			xfs_qm_dqattach_grouphint(ip->i_udquot, ip->i_gdquot);
+			xfs_qm_dqattach_hint(ip, XFS_DQ_GROUP);
+
+		if (ip->i_udquot->q_pdquot != ip->i_pdquot)
+			xfs_qm_dqattach_hint(ip, XFS_DQ_PROJ);
 	}
 
  done:
@@ -568,8 +608,10 @@ xfs_qm_dqattach_locked(
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
@@ -602,7 +644,7 @@ void
 xfs_qm_dqdetach(
 	xfs_inode_t	*ip)
 {
-	if (!(ip->i_udquot || ip->i_gdquot))
+	if (!(ip->i_udquot || ip->i_gdquot || ip->i_pdquot))
 		return;
 
 	trace_xfs_dquot_dqdetach(ip);
@@ -616,6 +658,10 @@ xfs_qm_dqdetach(
 		xfs_qm_dqrele(ip->i_gdquot);
 		ip->i_gdquot = NULL;
 	}
+	if (ip->i_pdquot) {
+		xfs_qm_dqrele(ip->i_pdquot);
+		ip->i_pdquot = NULL;
+	}
 }
 
 int
@@ -660,6 +706,7 @@ xfs_qm_init_quotainfo(
 
 	INIT_RADIX_TREE(&qinf->qi_uquota_tree, GFP_NOFS);
 	INIT_RADIX_TREE(&qinf->qi_gquota_tree, GFP_NOFS);
+	INIT_RADIX_TREE(&qinf->qi_pquota_tree, GFP_NOFS);
 	mutex_init(&qinf->qi_tree_lock);
 
 	INIT_LIST_HEAD(&qinf->qi_lru_list);
@@ -761,6 +808,10 @@ xfs_qm_destroy_quotainfo(
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
@@ -1269,13 +1320,14 @@ xfs_qm_quotacheck(
 	LIST_HEAD		(buffer_list);
 	struct xfs_inode	*uip = mp->m_quotainfo->qi_uquotaip;
 	struct xfs_inode	*gip = mp->m_quotainfo->qi_gquotaip;
+	struct xfs_inode	*pip = mp->m_quotainfo->qi_pquotaip;
 
 	count = INT_MAX;
 	structsz = 1;
 	lastino = 0;
 	flags = 0;
 
-	ASSERT(uip || gip);
+	ASSERT(uip || gip || pip);
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
 	xfs_notice(mp, "Quotacheck needed: Please wait.");
@@ -1294,13 +1346,19 @@ xfs_qm_quotacheck(
 	}
 
 	if (gip) {
-		error = xfs_qm_dqiterate(mp, gip, XFS_IS_GQUOTA_ON(mp) ?
-					 XFS_QMOPT_GQUOTA : XFS_QMOPT_PQUOTA,
+		error = xfs_qm_dqiterate(mp, gip, XFS_QMOPT_GQUOTA,
+					 &buffer_list);
+		if (error)
+			goto error_return;
+		flags |= XFS_GQUOTA_CHKD;
+	}
+
+	if (pip) {
+		error = xfs_qm_dqiterate(mp, pip, XFS_QMOPT_PQUOTA,
 					 &buffer_list);
 		if (error)
 			goto error_return;
-		flags |= XFS_IS_GQUOTA_ON(mp) ?
-					XFS_GQUOTA_CHKD : XFS_PQUOTA_CHKD;
+		flags |= XFS_PQUOTA_CHKD;
 	}
 
 	do {
@@ -1397,6 +1455,7 @@ xfs_qm_init_quotainos(
 {
 	struct xfs_inode	*uip = NULL;
 	struct xfs_inode	*gip = NULL;
+	struct xfs_inode	*pip = NULL;
 	int			error;
 	__int64_t		sbflags = 0;
 	uint			flags = 0;
@@ -1415,7 +1474,7 @@ xfs_qm_init_quotainos(
 			if (error)
 				return XFS_ERROR(error);
 		}
-		if (XFS_IS_OQUOTA_ON(mp) &&
+		if (XFS_IS_GQUOTA_ON(mp) &&
 		    mp->m_sb.sb_gquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_gquotino > 0);
 			error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
@@ -1423,6 +1482,15 @@ xfs_qm_init_quotainos(
 			if (error)
 				goto error_rele;
 		}
+		/* XXX: Use gquotino for now */
+		if (XFS_IS_PQUOTA_ON(mp) &&
+		    mp->m_sb.sb_gquotino != NULLFSINO) {
+			ASSERT(mp->m_sb.sb_gquotino > 0);
+			error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
+					     0, 0, &pip);
+			if (error)
+				goto error_rele;
+		}
 	} else {
 		flags |= XFS_QMOPT_SBVERSION;
 		sbflags |= (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
@@ -1430,7 +1498,7 @@ xfs_qm_init_quotainos(
 	}
 
 	/*
-	 * Create the two inodes, if they don't exist already. The changes
+	 * Create the three inodes, if they don't exist already. The changes
 	 * made above will get added to a transaction and logged in one of
 	 * the qino_alloc calls below.  If the device is readonly,
 	 * temporarily switch to read-write to do this.
@@ -1444,17 +1512,27 @@ xfs_qm_init_quotainos(
 
 		flags &= ~XFS_QMOPT_SBVERSION;
 	}
-	if (XFS_IS_OQUOTA_ON(mp) && gip == NULL) {
-		flags |= (XFS_IS_GQUOTA_ON(mp) ?
-				XFS_QMOPT_GQUOTA : XFS_QMOPT_PQUOTA);
+	if (XFS_IS_GQUOTA_ON(mp) && gip == NULL) {
 		error = xfs_qm_qino_alloc(mp, &gip,
-					  sbflags | XFS_SB_GQUOTINO, flags);
+					  sbflags | XFS_SB_GQUOTINO,
+					  flags | XFS_QMOPT_GQUOTA);
+		if (error)
+			goto error_rele;
+
+		flags &= ~XFS_QMOPT_SBVERSION;
+	}
+	if (XFS_IS_PQUOTA_ON(mp) && pip == NULL) {
+		/* XXX: Use XFS_SB_GQUOTINO for now */
+		error = xfs_qm_qino_alloc(mp, &pip,
+					  sbflags | XFS_SB_GQUOTINO,
+					  flags | XFS_QMOPT_PQUOTA);
 		if (error)
 			goto error_rele;
 	}
 
 	mp->m_quotainfo->qi_uquotaip = uip;
 	mp->m_quotainfo->qi_gquotaip = gip;
+	mp->m_quotainfo->qi_pquotaip = pip;
 
 	return 0;
 
@@ -1463,6 +1541,8 @@ error_rele:
 		IRELE(uip);
 	if (gip)
 		IRELE(gip);
+	if (pip)
+		IRELE(pip);
 	return XFS_ERROR(error);
 }
 
@@ -1657,11 +1737,13 @@ xfs_qm_vop_dqalloc(
 	prid_t			prid,
 	uint			flags,
 	struct xfs_dquot	**O_udqpp,
-	struct xfs_dquot	**O_gdqpp)
+	struct xfs_dquot	**O_gdqpp,
+	struct xfs_dquot	**O_pdqpp)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_dquot	*uq = NULL;
 	struct xfs_dquot	*gq = NULL;
+	struct xfs_dquot	*pq = NULL;
 	int			error;
 	uint			lockflags;
 
@@ -1741,24 +1823,25 @@ xfs_qm_vop_dqalloc(
 			ASSERT(ip->i_gdquot);
 			gq = xfs_qm_dqhold(ip->i_gdquot);
 		}
-	} else if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
+	}
+	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
 		if (xfs_get_projid(ip) != prid) {
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)prid,
 						 XFS_DQ_PROJ,
 						 XFS_QMOPT_DQALLOC |
 						 XFS_QMOPT_DOWARN,
-						 &gq);
+						 &pq);
 			if (error) {
 				ASSERT(error != ENOENT);
 				goto error_rele;
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
@@ -1773,9 +1856,15 @@ xfs_qm_vop_dqalloc(
 		*O_gdqpp = gq;
 	else if (gq)
 		xfs_qm_dqrele(gq);
+	if (O_pdqpp)
+		*O_pdqpp = pq;
+	else if (pq)
+		xfs_qm_dqrele(pq);
 	return 0;
 
 error_rele:
+	if (gq)
+		xfs_qm_dqrele(gq);
 	if (uq)
 		xfs_qm_dqrele(uq);
 	return error;
@@ -1830,14 +1919,17 @@ xfs_qm_vop_chown_reserve(
 	struct xfs_inode	*ip,
 	struct xfs_dquot	*udqp,
 	struct xfs_dquot	*gdqp,
+	struct xfs_dquot	*pdqp,
 	uint			flags)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	uint			delblks, blkflags, prjflags = 0;
 	struct xfs_dquot	*udq_unres = NULL;
 	struct xfs_dquot	*gdq_unres = NULL;
+	struct xfs_dquot	*pdq_unres = NULL;
 	struct xfs_dquot	*udq_delblks = NULL;
 	struct xfs_dquot	*gdq_delblks = NULL;
+	struct xfs_dquot	*pdq_delblks = NULL;
 	int			error;
 
 
@@ -1861,24 +1953,28 @@ xfs_qm_vop_chown_reserve(
 			udq_unres = ip->i_udquot;
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
-			gdq_delblks = gdqp;
-			if (delblks) {
-				ASSERT(ip->i_gdquot);
-				gdq_unres = ip->i_gdquot;
-			}
+	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
+	    ip->i_d.di_gid != be32_to_cpu(gdqp->q_core.d_id)) {
+		gdq_delblks = gdqp;
+		if (delblks) {
+			ASSERT(ip->i_gdquot);
+			gdq_unres = ip->i_gdquot;
+		}
+	}
+
+	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
+	    xfs_get_projid(ip) != be32_to_cpu(pdqp->q_core.d_id)) {
+		prjflags = XFS_QMOPT_ENOSPC;
+		pdq_delblks = pdqp;
+		if (delblks) {
+			ASSERT(ip->i_pdquot);
+			pdq_unres = ip->i_pdquot;
 		}
 	}
 
 	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
-				udq_delblks, gdq_delblks, ip->i_d.di_nblocks, 1,
+				udq_delblks, gdq_delblks, pdq_delblks,
+				ip->i_d.di_nblocks, 1,
 				flags | blkflags | prjflags);
 	if (error)
 		return error;
@@ -1893,16 +1989,17 @@ xfs_qm_vop_chown_reserve(
 		/*
 		 * Do the reservations first. Unreservation can't fail.
 		 */
-		ASSERT(udq_delblks || gdq_delblks);
-		ASSERT(udq_unres || gdq_unres);
+		ASSERT(udq_delblks || gdq_delblks || pdq_delblks);
+		ASSERT(udq_unres || gdq_unres || pdq_unres);
 		error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
-			    udq_delblks, gdq_delblks, (xfs_qcnt_t)delblks, 0,
+			    udq_delblks, gdq_delblks, pdq_delblks,
+			    (xfs_qcnt_t)delblks, 0,
 			    flags | blkflags | prjflags);
 		if (error)
 			return error;
 		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
-				udq_unres, gdq_unres, -((xfs_qcnt_t)delblks), 0,
-				blkflags);
+				udq_unres, gdq_unres, pdq_unres,
+				-((xfs_qcnt_t)delblks), 0, blkflags);
 	}
 
 	return (0);
@@ -1941,7 +2038,8 @@ xfs_qm_vop_create_dqattach(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	struct xfs_dquot	*udqp,
-	struct xfs_dquot	*gdqp)
+	struct xfs_dquot	*gdqp,
+	struct xfs_dquot	*pdqp)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 
@@ -1961,13 +2059,18 @@ xfs_qm_vop_create_dqattach(
 	}
 	if (gdqp) {
 		ASSERT(ip->i_gdquot == NULL);
-		ASSERT(XFS_IS_OQUOTA_ON(mp));
-		ASSERT((XFS_IS_GQUOTA_ON(mp) ?
-			ip->i_d.di_gid : xfs_get_projid(ip)) ==
-				be32_to_cpu(gdqp->q_core.d_id));
-
+		ASSERT(XFS_IS_GQUOTA_ON(mp));
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
index 9efec02..dcf8063 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -44,9 +44,11 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
 typedef struct xfs_quotainfo {
 	struct radix_tree_root	qi_uquota_tree;
 	struct radix_tree_root	qi_gquota_tree;
+	struct radix_tree_root	qi_pquota_tree;
 	struct mutex		qi_tree_lock;
 	struct xfs_inode	*qi_uquotaip;
 	struct xfs_inode	*qi_gquotaip;
+	struct xfs_inode	*qi_pquotaip;
 	struct list_head	qi_lru_list;
 	struct mutex		qi_lru_lock;
 	int			qi_lru_count;
@@ -78,8 +80,9 @@ xfs_dquot_tree(
 	case XFS_DQ_USER:
 		return &qi->qi_uquota_tree;
 	case XFS_DQ_GROUP:
-	case XFS_DQ_PROJ:
 		return &qi->qi_gquota_tree;
+	case XFS_DQ_PROJ:
+		return &qi->qi_pquota_tree;
 	default:
 		ASSERT(0);
 	}
@@ -93,8 +96,9 @@ xfs_dq_to_quota_inode(struct xfs_dquot *dqp)
 	case XFS_DQ_USER:
 		return dqp->q_mount->m_quotainfo->qi_uquotaip;
 	case XFS_DQ_GROUP:
-	case XFS_DQ_PROJ:
 		return dqp->q_mount->m_quotainfo->qi_gquotaip;
+	case XFS_DQ_PROJ:
+		return dqp->q_mount->m_quotainfo->qi_pquotaip;
 	default:
 		ASSERT(0);
 	}
@@ -107,18 +111,20 @@ extern void	xfs_trans_mod_dquot(struct xfs_trans *,
 					struct xfs_dquot *, uint, long);
 extern int	xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
 			struct xfs_mount *, struct xfs_dquot *,
-			struct xfs_dquot *, long, long, uint);
+			struct xfs_dquot *, struct xfs_dquot *,
+			long, long, uint);
 extern void	xfs_trans_dqjoin(struct xfs_trans *, struct xfs_dquot *);
 extern void	xfs_trans_log_dquot(struct xfs_trans *, struct xfs_dquot *);
 
 /*
- * We keep the usr and grp dquots separately so that locking will be easier
- * to do at commit time. All transactions that we know of at this point
+ * We keep the usr, grp, and prj dquots separately so that locking will be
+ * easier to do at commit time. All transactions that we know of at this point
  * affect no more than two dquots of one type. Hence, the TRANS_MAXDQS value.
  */
 enum {
 	XFS_QM_TRANS_USR = 0,
 	XFS_QM_TRANS_GRP,
+	XFS_QM_TRANS_PRJ,
 	XFS_QM_TRANS_DQTYPES
 };
 #define XFS_QM_TRANS_MAXDQS		2
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 2d02eac..72a4fdd 100644
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
index a08801a..b936383 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -119,7 +119,8 @@ xfs_qm_scall_quotaoff(
 		dqtype |= XFS_QMOPT_GQUOTA;
 		flags |= (XFS_GQUOTA_CHKD | XFS_GQUOTA_ENFD);
 		inactivate_flags |= XFS_GQUOTA_ACTIVE;
-	} else if (flags & XFS_PQUOTA_ACCT) {
+	}
+	if (flags & XFS_PQUOTA_ACCT) {
 		dqtype |= XFS_QMOPT_PQUOTA;
 		flags |= (XFS_PQUOTA_CHKD | XFS_PQUOTA_ENFD);
 		inactivate_flags |= XFS_PQUOTA_ACTIVE;
@@ -214,10 +215,14 @@ xfs_qm_scall_quotaoff(
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
@@ -859,9 +864,11 @@ xfs_dqrele_inode(
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
 
@@ -870,10 +877,14 @@ xfs_dqrele_inode(
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
index c3483ba..5faf654 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -271,10 +271,10 @@ typedef struct xfs_qoff_logformat {
  * we didn't have the inode locked, the appropriate dquot(s) will be
  * attached atomically.
  */
-#define XFS_NOT_DQATTACHED(mp, ip) ((XFS_IS_UQUOTA_ON(mp) &&\
-				     (ip)->i_udquot == NULL) || \
-				    (XFS_IS_OQUOTA_ON(mp) && \
-				     (ip)->i_gdquot == NULL))
+#define XFS_NOT_DQATTACHED(mp, ip) \
+	((XFS_IS_UQUOTA_ON(mp) && (ip)->i_udquot == NULL) || \
+	 (XFS_IS_GQUOTA_ON(mp) && (ip)->i_gdquot == NULL) || \
+	 (XFS_IS_PQUOTA_ON(mp) && (ip)->i_pdquot == NULL))
 
 #define XFS_QM_NEED_QUOTACHECK(mp) \
 	((XFS_IS_UQUOTA_ON(mp) && \
@@ -329,17 +329,18 @@ extern int xfs_trans_reserve_quota_nblks(struct xfs_trans *,
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
@@ -353,10 +354,12 @@ extern void xfs_qm_unmount_quotas(struct xfs_mount *);
 #else
 static inline int
 xfs_qm_vop_dqalloc(struct xfs_inode *ip, uid_t uid, gid_t gid, prid_t prid,
-		uint flags, struct xfs_dquot **udqp, struct xfs_dquot **gdqp)
+		uint flags, struct xfs_dquot **udqp, struct xfs_dquot **gdqp,
+		struct xfs_dquot **pdqp)
 {
 	*udqp = NULL;
 	*gdqp = NULL;
+	*pdqp = NULL;
 	return 0;
 }
 #define xfs_trans_dup_dqinfo(tp, tp2)
@@ -371,14 +374,15 @@ static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp,
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
@@ -392,8 +396,8 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
 
 #define xfs_trans_unreserve_quota_nblks(tp, ip, nblks, ninos, flags) \
 	xfs_trans_reserve_quota_nblks(tp, ip, -(nblks), -(ninos), flags)
-#define xfs_trans_reserve_quota(tp, mp, ud, gd, nb, ni, f) \
-	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, nb, ni, \
+#define xfs_trans_reserve_quota(tp, mp, ud, gd, pd, nb, ni, f) \
+	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, pd, nb, ni, \
 				f | XFS_QMOPT_RES_REGBLKS)
 
 extern int xfs_qm_dqcheck(struct xfs_mount *, xfs_disk_dquot_t *,
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index e830fb5..f4895b6 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -360,6 +360,7 @@ xfs_symlink(
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
+	struct xfs_dquot	*pdqp = NULL;
 	uint			resblks;
 
 	*ipp = NULL;
@@ -386,7 +387,7 @@ xfs_symlink(
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
 	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
-			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
+		XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp, &pdqp);
 	if (error)
 		goto std_return;
 
@@ -427,7 +428,8 @@ xfs_symlink(
 	/*
 	 * Reserve disk quota : blocks and inode.
 	 */
-	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp, resblks, 1, 0);
+	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
+						pdqp, resblks, 1, 0);
 	if (error)
 		goto error_return;
 
@@ -465,7 +467,7 @@ xfs_symlink(
 	/*
 	 * Also attach the dquot(s) to it, if applicable.
 	 */
-	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp);
+	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
 
 	if (resblks)
 		resblks -= XFS_IALLOC_SPACE_RES(mp);
@@ -563,6 +565,7 @@ xfs_symlink(
 	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
 	return 0;
@@ -576,6 +579,7 @@ xfs_symlink(
 	xfs_trans_cancel(tp, cancel_flags);
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
 
 	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 3ba64d5..e3a8b25 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -163,8 +163,10 @@ xfs_trans_mod_dquot_byino(
 
 	if (XFS_IS_UQUOTA_ON(mp) && ip->i_udquot)
 		(void) xfs_trans_mod_dquot(tp, ip->i_udquot, field, delta);
-	if (XFS_IS_OQUOTA_ON(mp) && ip->i_gdquot)
+	if (XFS_IS_GQUOTA_ON(mp) && ip->i_gdquot)
 		(void) xfs_trans_mod_dquot(tp, ip->i_gdquot, field, delta);
+	if (XFS_IS_PQUOTA_ON(mp) && ip->i_pdquot)
+		(void) xfs_trans_mod_dquot(tp, ip->i_pdquot, field, delta);
 }
 
 STATIC struct xfs_dqtrx *
@@ -177,8 +179,12 @@ xfs_trans_get_dqtrx(
 
 	if (XFS_QM_ISUDQ(dqp))
 		qa = tp->t_dqinfo->dqs[XFS_QM_TRANS_USR];
-	else
+	else if (XFS_QM_ISGDQ(dqp))
 		qa = tp->t_dqinfo->dqs[XFS_QM_TRANS_GRP];
+	else if (XFS_QM_ISPDQ(dqp))
+		qa = tp->t_dqinfo->dqs[XFS_QM_TRANS_PRJ];
+	else
+		return NULL;
 
 	for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
 		if (qa[i].qt_dquot == NULL ||
@@ -728,8 +734,8 @@ error_return:
 
 /*
  * Given dquot(s), make disk block and/or inode reservations against them.
- * The fact that this does the reservation against both the usr and
- * grp/prj quotas is important, because this follows a both-or-nothing
+ * The fact that this does the reservation against user, group and
+ * project quotas is important, because this follows a all-or-nothing
  * approach.
  *
  * flags = XFS_QMOPT_FORCE_RES evades limit enforcement. Used by chown.
@@ -744,6 +750,7 @@ xfs_trans_reserve_quota_bydquots(
 	struct xfs_mount	*mp,
 	struct xfs_dquot	*udqp,
 	struct xfs_dquot	*gdqp,
+	struct xfs_dquot	*pdqp,
 	long			nblks,
 	long			ninos,
 	uint			flags)
@@ -771,11 +778,21 @@ xfs_trans_reserve_quota_bydquots(
 			goto unwind_usr;
 	}
 
+	if (pdqp) {
+		error = xfs_trans_dqresv(tp, mp, pdqp, nblks, ninos, flags);
+		if (error)
+			goto unwind_grp;
+	}
+
 	/*
 	 * Didn't change anything critical, so, no need to log
 	 */
 	return 0;
 
+unwind_grp:
+	flags |= XFS_QMOPT_FORCE_RES;
+	if (gdqp)
+		xfs_trans_dqresv(tp, mp, gdqp, -nblks, -ninos, flags);
 unwind_usr:
 	flags |= XFS_QMOPT_FORCE_RES;
 	if (udqp)
@@ -817,6 +834,7 @@ xfs_trans_reserve_quota_nblks(
 	 */
 	return xfs_trans_reserve_quota_bydquots(tp, mp,
 						ip->i_udquot, ip->i_gdquot,
+						ip->i_pdquot,
 						nblks, ninos, flags);
 }
 
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 42c0ef2..dc730ac 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -489,6 +489,7 @@ xfs_create(
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
+	struct xfs_dquot	*pdqp = NULL;
 	uint			resblks;
 	uint			log_res;
 	uint			log_count;
@@ -507,7 +508,8 @@ xfs_create(
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
 	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
-			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
+					XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
+					&udqp, &gdqp, &pdqp);
 	if (error)
 		return error;
 
@@ -559,7 +561,8 @@ xfs_create(
 	/*
 	 * Reserve disk quota and the inode.
 	 */
-	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp, resblks, 1, 0);
+	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
+						pdqp, resblks, 1, 0);
 	if (error)
 		goto out_trans_cancel;
 
@@ -623,7 +626,7 @@ xfs_create(
 	 * These ids of the inode couldn't have changed since the new
 	 * inode has been locked ever since it was created.
 	 */
-	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp);
+	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
 
 	error = xfs_bmap_finish(&tp, &free_list, &committed);
 	if (error)
@@ -635,6 +638,7 @@ xfs_create(
 
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
 	return 0;
@@ -656,6 +660,7 @@ xfs_create(
 
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
 
 	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
@@ -1568,7 +1573,7 @@ xfs_free_file_space(
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
