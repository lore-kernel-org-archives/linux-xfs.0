Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9I09lLO032945 for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 19:09:48 -0500
Received: from e31.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66CB3F763F7
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 17:17:38 -0700 (PDT)
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149]) by
	cuda.sgi.com with ESMTP id 3KwG46cXDaSBHkvz for
	<xfs@oss.sgi.com>; Mon, 17 Oct 2011 17:17:38 -0700 (PDT)
Received: from /spool/local by us.ibm.com with XMail ESMTP
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 17 Oct 2011 18:09:46 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p9I09idM193976 for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 18:09:44 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p9I09ijM011637
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 18:09:44 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Mon, 17 Oct 2011 19:09:43 -0500
Message-Id: <20111018000943.14942.24899.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20111018000932.14942.11597.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20111018000932.14942.11597.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [RFC PATCH 2/3] Add pquota fields where gquota is used
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
is used. by use of macros.

No externally visible changed and no superblock changes, yet.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_dquot.c       |   20 +++-
 fs/xfs/xfs_dquot.h       |   14 ++-
 fs/xfs/xfs_iget.c        |    2 +-
 fs/xfs/xfs_inode.h       |    1 +
 fs/xfs/xfs_ioctl.c       |   12 +-
 fs/xfs/xfs_iops.c        |    4 +-
 fs/xfs/xfs_mount.c       |    2 +
 fs/xfs/xfs_qm.c          |  273 +++++++++++++++++++++++++++++++---------------
 fs/xfs/xfs_qm.h          |    4 +-
 fs/xfs/xfs_qm_bhv.c      |    2 +-
 fs/xfs/xfs_qm_syscalls.c |   16 ++-
 fs/xfs/xfs_quota.h       |   38 ++++---
 fs/xfs/xfs_sb.h          |    1 +
 fs/xfs/xfs_trans_dquot.c |   69 +++++++++---
 fs/xfs/xfs_vnodeops.c    |   23 +++--
 15 files changed, 329 insertions(+), 152 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 25d7280..e262936 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -841,8 +841,10 @@ xfs_qm_dqget(
 		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 		if (type == XFS_DQ_USER)
 			ASSERT(ip->i_udquot == NULL);
-		else
+		else if (type == XFS_DQ_GROUP)
 			ASSERT(ip->i_gdquot == NULL);
+		else
+			ASSERT(ip->i_pdquot == NULL);
 	}
 #endif
 	mutex_lock(&h->qh_lock);
@@ -933,8 +935,8 @@ xfs_qm_dqget(
 				xfs_dqlock(dqp);
 				goto dqret;
 			}
-		} else {
-			if (!XFS_IS_OQUOTA_ON(mp)) {
+		} else if (type == XFS_DQ_GROUP) {
+			if (!XFS_IS_GQUOTA_ON(mp)) {
 				/* inode stays locked on return */
 				xfs_qm_dqdestroy(dqp);
 				return XFS_ERROR(ESRCH);
@@ -945,6 +947,18 @@ xfs_qm_dqget(
 				xfs_dqlock(dqp);
 				goto dqret;
 			}
+		} else {
+			if (!XFS_IS_PQUOTA_ON(mp)) {
+				/* inode stays locked on return */
+				xfs_qm_dqdestroy(dqp);
+				return XFS_ERROR(ESRCH);
+			}
+			if (ip->i_pdquot) {
+				xfs_qm_dqdestroy(dqp);
+				dqp = ip->i_pdquot;
+				xfs_dqlock(dqp);
+				goto dqret;
+			}
 		}
 	}
 
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 34b7e94..ed2c6bd 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -59,6 +59,7 @@ typedef struct xfs_dquot {
 	xfs_fileoff_t	 q_fileoffset;	/* offset in quotas file */
 
 	struct xfs_dquot*q_gdquot;	/* group dquot, hint only */
+	struct xfs_dquot*q_pdquot;	/* project dquot, hint only */
 	xfs_disk_dquot_t q_core;	/* actual usage & quotas */
 	xfs_dq_logitem_t q_logitem;	/* dquot log item */
 	xfs_qcnt_t	 q_res_bcount;	/* total regular nblks used+reserved */
@@ -110,11 +111,16 @@ static inline void xfs_dqfunlock(xfs_dquot_t *dqp)
 #define XFS_DQ_TO_QINF(dqp)	((dqp)->q_mount->m_quotainfo)
 #define XFS_DQ_TO_QIP(dqp)	(XFS_QM_ISUDQ(dqp) ? \
 				 XFS_DQ_TO_QINF(dqp)->qi_uquotaip : \
-				 XFS_DQ_TO_QINF(dqp)->qi_gquotaip)
+				 ((XFS_QM_ISGDQ(dqp) ? \
+				 XFS_DQ_TO_QINF(dqp)->qi_gquotaip :\
+				 XFS_DQ_TO_QINF(dqp)->qi_pquotaip)))
 
-#define XFS_IS_THIS_QUOTA_OFF(d) (! (XFS_QM_ISUDQ(d) ? \
-				     (XFS_IS_UQUOTA_ON((d)->q_mount)) : \
-				     (XFS_IS_OQUOTA_ON((d)->q_mount))))
+#define XFS_IS_THIS_QUOTA_OFF(d) (! ((XFS_QM_ISUDQ(d) && \
+				     XFS_IS_UQUOTA_ON((d)->q_mount)) || \
+				     (XFS_QM_ISGDQ(d) && \
+				     XFS_IS_GQUOTA_ON((d)->q_mount)) || \
+				     (XFS_QM_ISPDQ(d) && \
+				     XFS_IS_PQUOTA_ON((d)->q_mount))))
 
 extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
 extern int		xfs_qm_dqflush(xfs_dquot_t *, uint);
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 0fa98b1..bee588b 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -365,7 +365,7 @@ xfs_iget_cache_miss(
 	}
 
 	/* These values _must_ be set before releasing the radix tree lock! */
-	ip->i_udquot = ip->i_gdquot = NULL;
+	ip->i_udquot = ip->i_gdquot = ip->i_pdquot = NULL;
 	xfs_iflags_set(ip, XFS_INEW);
 
 	spin_unlock(&pag->pag_ici_lock);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 760140d..26f95a6 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -231,6 +231,7 @@ typedef struct xfs_inode {
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
 	struct xfs_dquot	*i_udquot;	/* user dquot */
 	struct xfs_dquot	*i_gdquot;	/* group dquot */
+	struct xfs_dquot	*i_pdquot;	/* project dquot */
 
 	/* Inode location stuff */
 	xfs_ino_t		i_ino;		/* inode number (agno/agino)*/
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d99a905..48f2e57 100644
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
@@ -973,7 +973,7 @@ xfs_ioctl_setattr(
 		    XFS_IS_PQUOTA_ON(mp) &&
 		    xfs_get_projid(ip) != fa->fsx_projid) {
 			ASSERT(tp);
-			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
+			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, NULL, pdqp,
 						capable(CAP_FOWNER) ?
 						XFS_QMOPT_FORCE_RES : 0);
 			if (code)	/* out of quota */
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
index 556bbe7..abda70f 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -568,7 +568,7 @@ xfs_setattr_nonsize(
 		ASSERT(udqp == NULL);
 		ASSERT(gdqp == NULL);
 		error = xfs_qm_vop_dqalloc(ip, uid, gid, xfs_get_projid(ip),
-					 qflags, &udqp, &gdqp);
+					 qflags, &udqp, &gdqp, NULL);
 		if (error)
 			return error;
 	}
@@ -603,7 +603,7 @@ xfs_setattr_nonsize(
 		    ((XFS_IS_UQUOTA_ON(mp) && iuid != uid) ||
 		     (XFS_IS_GQUOTA_ON(mp) && igid != gid))) {
 			ASSERT(tp);
-			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
+			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp, NULL,
 						capable(CAP_FOWNER) ?
 						XFS_QMOPT_FORCE_RES : 0);
 			if (error)	/* out of quota */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 366bbb7..a60d555 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -628,6 +628,7 @@ xfs_sb_to_disk(
 	xfs_sb_field_t	f;
 	int		first;
 	int		size;
+	__be16		saved_qflags = from->sb_qflags;
 
 	ASSERT(fields);
 	if (!fields)
@@ -669,6 +670,7 @@ xfs_sb_to_disk(
 
 		fields &= ~(1LL << f);
 	}
+	from->sb_qflags = saved_qflags;
 }
 
 /*
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index cb2ed78..931adc5 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -408,6 +408,10 @@ xfs_qm_unmount_quotas(
 			IRELE(mp->m_quotainfo->qi_gquotaip);
 			mp->m_quotainfo->qi_gquotaip = NULL;
 		}
+		if (mp->m_quotainfo->qi_pquotaip) {
+			IRELE(mp->m_quotainfo->qi_pquotaip);
+			mp->m_quotainfo->qi_pquotaip = NULL;
+		}
 	}
 }
 
@@ -693,29 +697,30 @@ xfs_qm_dqattach_one(
 
 
 /*
- * Given a udquot and gdquot, attach a ptr to the group dquot in the
- * udquot as a hint for future lookups. The idea sounds simple, but the
- * execution isn't, because the udquot might have a group dquot attached
+ * Given an ip, attach a ptr to the group/project dquot in ip->i_udquot
+ * as a hint for future lookups. The idea sounds simple, but the execution
+ * isn't, because the udquot might have a group/project dquot attached
  * already and getting rid of that gets us into lock ordering constraints.
  * The process is complicated more by the fact that the dquots may or may not
  * be locked on entry.
  */
 STATIC void
-xfs_qm_dqattach_grouphint(
-	xfs_dquot_t	*udq,
-	xfs_dquot_t	*gdq)
+xfs_qm_dqattach_grouphint(xfs_inode_t *ip, int type)
 {
-	xfs_dquot_t	*tmp;
+	xfs_dquot_t	*udq=ip->i_udquot, *gpdq, **tmp, *tmp1;
 
+	gpdq = (type == XFS_DQ_GROUP) ? ip->i_gdquot : ip->i_pdquot;
 	xfs_dqlock(udq);
 
-	if ((tmp = udq->q_gdquot)) {
-		if (tmp == gdq) {
+	tmp = (type == XFS_DQ_GROUP) ? &udq->q_gdquot : &udq->q_pdquot;
+	if (*tmp) {
+		if (*tmp == gpdq) {
 			xfs_dqunlock(udq);
 			return;
 		}
 
-		udq->q_gdquot = NULL;
+		tmp1 = *tmp;
+		*tmp = NULL;
 		/*
 		 * We can't keep any dqlocks when calling dqrele,
 		 * because the freelist lock comes before dqlocks.
@@ -726,28 +731,28 @@ xfs_qm_dqattach_grouphint(
 		 * so give it back when the udquot no longer points at it
 		 * dqput() does the unlocking of the dquot.
 		 */
-		xfs_qm_dqrele(tmp);
+		xfs_qm_dqrele(tmp1);
 
 		xfs_dqlock(udq);
-		xfs_dqlock(gdq);
+		xfs_dqlock(gpdq);
 
 	} else {
 		ASSERT(XFS_DQ_IS_LOCKED(udq));
-		xfs_dqlock(gdq);
+		xfs_dqlock(gpdq);
 	}
 
 	ASSERT(XFS_DQ_IS_LOCKED(udq));
-	ASSERT(XFS_DQ_IS_LOCKED(gdq));
+	ASSERT(XFS_DQ_IS_LOCKED(gpdq));
 	/*
-	 * Somebody could have attached a gdquot here,
+	 * Somebody could have attached a gdquot/pdquot here,
 	 * when we dropped the uqlock. If so, just do nothing.
 	 */
-	if (udq->q_gdquot == NULL) {
-		XFS_DQHOLD(gdq);
-		udq->q_gdquot = gdq;
+	if (*tmp == NULL) {
+		XFS_DQHOLD(gpdq);
+		*tmp = gpdq;
 	}
 
-	xfs_dqunlock(gdq);
+	xfs_dqunlock(gpdq);
 	xfs_dqunlock(udq);
 }
 
@@ -787,12 +792,8 @@ xfs_qm_dqattach_locked(
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
@@ -804,14 +805,29 @@ xfs_qm_dqattach_locked(
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
+	if (nquotas > 1) {
 		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 		ASSERT(ip->i_udquot);
 		ASSERT(ip->i_gdquot);
+		ASSERT(ip->i_pdquot);
 
 		/*
 		 * We may or may not have the i_udquot locked at this point,
@@ -819,12 +835,22 @@ xfs_qm_dqattach_locked(
 		 * be accurate 100% all the time. It is just a hint, and this
 		 * will succeed in general.
 		 */
-		if (ip->i_udquot->q_gdquot == ip->i_gdquot)
-			goto done;
-		/*
-		 * Attach i_gdquot to the gdquot hint inside the i_udquot.
-		 */
-		xfs_qm_dqattach_grouphint(ip->i_udquot, ip->i_gdquot);
+		if (XFS_IS_GQUOTA_ON(mp) && 
+				ip->i_udquot->q_gdquot != ip->i_gdquot) {
+			/*
+			 * Attach i_gdquot to the gdquot hint inside
+			 * the i_udquot.
+			 */
+			xfs_qm_dqattach_grouphint(ip, XFS_DQ_GROUP);
+		}
+		if (XFS_IS_PQUOTA_ON(mp) && 
+				ip->i_udquot->q_pdquot != ip->i_pdquot) {
+			/*
+			 * Attach i_pdquot to the pdquot hint inside
+			 * the i_udquot.
+			 */
+			xfs_qm_dqattach_grouphint(ip, XFS_DQ_PROJ);
+		}
 	}
 
  done:
@@ -832,8 +858,10 @@ xfs_qm_dqattach_locked(
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
@@ -863,7 +891,7 @@ void
 xfs_qm_dqdetach(
 	xfs_inode_t	*ip)
 {
-	if (!(ip->i_udquot || ip->i_gdquot))
+	if (!(ip->i_udquot || ip->i_gdquot || ip->i_pdquot))
 		return;
 
 	trace_xfs_dquot_dqdetach(ip);
@@ -878,6 +906,10 @@ xfs_qm_dqdetach(
 		xfs_qm_dqrele(ip->i_gdquot);
 		ip->i_gdquot = NULL;
 	}
+	if (ip->i_pdquot) {
+		xfs_qm_dqrele(ip->i_pdquot);
+		ip->i_pdquot = NULL;
+	}
 }
 
 int
@@ -1125,6 +1157,10 @@ xfs_qm_destroy_quotainfo(
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
@@ -1602,7 +1638,7 @@ xfs_qm_quotacheck(
 	int		done, count, error;
 	xfs_ino_t	lastino;
 	size_t		structsz;
-	xfs_inode_t	*uip, *gip;
+	xfs_inode_t	*uip, *gip, *pip;
 	uint		flags;
 
 	count = INT_MAX;
@@ -1610,7 +1646,8 @@ xfs_qm_quotacheck(
 	lastino = 0;
 	flags = 0;
 
-	ASSERT(mp->m_quotainfo->qi_uquotaip || mp->m_quotainfo->qi_gquotaip);
+	ASSERT(mp->m_quotainfo->qi_uquotaip || mp->m_quotainfo->qi_gquotaip 
+			|| mp->m_quotainfo->qi_pquotaip);
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
 	/*
@@ -1636,12 +1673,18 @@ xfs_qm_quotacheck(
 
 	gip = mp->m_quotainfo->qi_gquotaip;
 	if (gip) {
-		error = xfs_qm_dqiterate(mp, gip, XFS_IS_GQUOTA_ON(mp) ?
-					XFS_QMOPT_GQUOTA : XFS_QMOPT_PQUOTA);
+		error = xfs_qm_dqiterate(mp, gip, XFS_QMOPT_GQUOTA);
+		if (error)
+			goto error_return;
+		flags |= XFS_GQUOTA_CHKD;
+	}
+
+	pip = mp->m_quotainfo->qi_pquotaip;
+	if (pip) {
+		error = xfs_qm_dqiterate(mp, pip, XFS_QMOPT_PQUOTA);
 		if (error)
 			goto error_return;
-		flags |= XFS_IS_GQUOTA_ON(mp) ?
-					XFS_GQUOTA_CHKD : XFS_PQUOTA_CHKD;
+		flags |= XFS_PQUOTA_CHKD;
 	}
 
 	do {
@@ -1722,13 +1765,13 @@ STATIC int
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
 
@@ -1743,7 +1786,7 @@ xfs_qm_init_quotainos(
 					     0, 0, &uip)))
 				return XFS_ERROR(error);
 		}
-		if (XFS_IS_OQUOTA_ON(mp) &&
+		if (XFS_IS_GQUOTA_ON(mp) &&
 		    mp->m_sb.sb_gquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_gquotino > 0);
 			if ((error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
@@ -1753,6 +1796,18 @@ xfs_qm_init_quotainos(
 				return XFS_ERROR(error);
 			}
 		}
+		if (XFS_IS_PQUOTA_ON(mp) &&
+		    mp->m_sb.sb_pquotino != NULLFSINO) {
+			ASSERT(mp->m_sb.sb_pquotino > 0);
+			if ((error = xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
+					     0, 0, &pip))) {
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
@@ -1760,7 +1815,7 @@ xfs_qm_init_quotainos(
 	}
 
 	/*
-	 * Create the two inodes, if they don't exist already. The changes
+	 * Create the three inodes, if they don't exist already. The changes
 	 * made above will get added to a transaction and logged in one of
 	 * the qino_alloc calls below.  If the device is readonly,
 	 * temporarily switch to read-write to do this.
@@ -1773,11 +1828,10 @@ xfs_qm_init_quotainos(
 
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
 		if (error) {
 			if (uip)
 				IRELE(uip);
@@ -1785,9 +1839,23 @@ xfs_qm_init_quotainos(
 			return XFS_ERROR(error);
 		}
 	}
+	if (XFS_IS_PQUOTA_ON(mp) && pip == NULL) {
+		error = xfs_qm_qino_alloc(mp, &pip,
+					     sbflags | XFS_SB_GQUOTINO,
+					     flags | XFS_QMOPT_PQUOTA);
+		if (error) {
+			if (uip)
+				IRELE(uip);
+			if (gip)
+				IRELE(gip);
+
+			return XFS_ERROR(error);
+		}
+	}
 
 	mp->m_quotainfo->qi_uquotaip = uip;
 	mp->m_quotainfo->qi_gquotaip = gip;
+	mp->m_quotainfo->qi_pquotaip = pip;
 
 	return 0;
 }
@@ -2092,10 +2160,11 @@ xfs_qm_vop_dqalloc(
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
 
@@ -2120,7 +2189,7 @@ xfs_qm_vop_dqalloc(
 		}
 	}
 
-	uq = gq = NULL;
+	uq = gq = pq = NULL;
 	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
 		if (ip->i_d.di_uid != uid) {
 			/*
@@ -2182,28 +2251,31 @@ xfs_qm_vop_dqalloc(
 			XFS_DQHOLD(gq);
 			xfs_dqunlock(gq);
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
-			gq = ip->i_gdquot;
-			xfs_dqlock(gq);
-			XFS_DQHOLD(gq);
-			xfs_dqunlock(gq);
+			ASSERT(ip->i_pdquot);
+			pq = ip->i_pdquot;
+			xfs_dqlock(pq);
+			XFS_DQHOLD(pq);
+			xfs_dqunlock(pq);
 		}
 	}
 	if (uq)
@@ -2218,6 +2290,10 @@ xfs_qm_vop_dqalloc(
 		*O_gdqpp = gq;
 	else if (gq)
 		xfs_qm_dqrele(gq);
+	if (O_pdqpp)
+		*O_pdqpp = pq;
+	else if (pq)
+		xfs_qm_dqrele(pq);
 	return 0;
 }
 
@@ -2274,11 +2350,13 @@ xfs_qm_vop_chown_reserve(
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
 
 
@@ -2286,7 +2364,8 @@ xfs_qm_vop_chown_reserve(
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
 	delblks = ip->i_delayed_blks;
-	delblksudq = delblksgdq = unresudq = unresgdq = NULL;
+	delblksudq = delblksgdq = delblkspdq = NULL;
+	unresudq = unresgdq = unrespdq = NULL;
 	blkflags = XFS_IS_REALTIME_INODE(ip) ?
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
@@ -2303,25 +2382,28 @@ xfs_qm_vop_chown_reserve(
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
@@ -2334,15 +2416,16 @@ xfs_qm_vop_chown_reserve(
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
@@ -2381,7 +2464,8 @@ xfs_qm_vop_create_dqattach(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	struct xfs_dquot	*udqp,
-	struct xfs_dquot	*gdqp)
+	struct xfs_dquot	*gdqp,
+	struct xfs_dquot	*pdqp)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 
@@ -2395,9 +2479,9 @@ xfs_qm_vop_create_dqattach(
 		xfs_dqlock(udqp);
 		XFS_DQHOLD(udqp);
 		xfs_dqunlock(udqp);
-		ASSERT(ip->i_udquot == NULL);
+		ASSERT_ALWAYS(ip->i_udquot == NULL);
 		ip->i_udquot = udqp;
-		ASSERT(XFS_IS_UQUOTA_ON(mp));
+		ASSERT_ALWAYS(XFS_IS_UQUOTA_ON(mp));
 		ASSERT(ip->i_d.di_uid == be32_to_cpu(udqp->q_core.d_id));
 		xfs_trans_mod_dquot(tp, udqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
@@ -2405,13 +2489,22 @@ xfs_qm_vop_create_dqattach(
 		xfs_dqlock(gdqp);
 		XFS_DQHOLD(gdqp);
 		xfs_dqunlock(gdqp);
-		ASSERT(ip->i_gdquot == NULL);
+		ASSERT_ALWAYS(ip->i_gdquot == NULL);
 		ip->i_gdquot = gdqp;
-		ASSERT(XFS_IS_OQUOTA_ON(mp));
-		ASSERT((XFS_IS_GQUOTA_ON(mp) ?
-			ip->i_d.di_gid : xfs_get_projid(ip)) ==
-				be32_to_cpu(gdqp->q_core.d_id));
+		ASSERT_ALWAYS(XFS_IS_GQUOTA_ON(mp));
+		ASSERT(ip->i_d.di_gid == be32_to_cpu(gdqp->q_core.d_id));
 		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
+	if (pdqp) {
+		xfs_dqlock(pdqp);
+		XFS_DQHOLD(pdqp);
+		xfs_dqunlock(pdqp);
+		ASSERT_ALWAYS(pdqp);
+		ASSERT_ALWAYS(ip->i_pdquot == NULL);
+		ip->i_pdquot = pdqp;
+		ASSERT_ALWAYS(XFS_IS_PQUOTA_ON(mp));
+		ASSERT(xfs_get_projid(ip) == be32_to_cpu(gdqp->q_core.d_id));
+		xfs_trans_mod_dquot(tp, pdqp, XFS_TRANS_DQ_ICOUNT, 1);
+	}
 }
 
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 43b9abe..289ae66 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -92,6 +92,7 @@ typedef struct xfs_qm {
 typedef struct xfs_quotainfo {
 	xfs_inode_t	*qi_uquotaip;	 /* user quota inode */
 	xfs_inode_t	*qi_gquotaip;	 /* group quota inode */
+	xfs_inode_t	*qi_pquotaip;	 /* project quota inode */
 	struct list_head qi_dqlist;	 /* all dquots in filesys */
 	struct mutex	 qi_dqlist_lock;
 	int		 qi_dquots;
@@ -116,8 +117,6 @@ typedef struct xfs_quotainfo {
 
 
 extern void	xfs_trans_mod_dquot(xfs_trans_t *, xfs_dquot_t *, uint, long);
-extern int	xfs_trans_reserve_quota_bydquots(xfs_trans_t *, xfs_mount_t *,
-			xfs_dquot_t *, xfs_dquot_t *, long, long, uint);
 extern void	xfs_trans_dqjoin(xfs_trans_t *, xfs_dquot_t *);
 extern void	xfs_trans_log_dquot(xfs_trans_t *, xfs_dquot_t *);
 
@@ -130,6 +129,7 @@ extern void	xfs_trans_log_dquot(xfs_trans_t *, xfs_dquot_t *);
 typedef struct xfs_dquot_acct {
 	xfs_dqtrx_t	dqa_usrdquots[XFS_QM_TRANS_MAXDQS];
 	xfs_dqtrx_t	dqa_grpdquots[XFS_QM_TRANS_MAXDQS];
+	xfs_dqtrx_t	dqa_prjdquots[XFS_QM_TRANS_MAXDQS];
 } xfs_dquot_acct_t;
 
 /*
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index a0a829a..c9b05f1 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -117,7 +117,7 @@ xfs_qm_newmount(
 	     (pquotaondisk && !XFS_IS_PQUOTA_ON(mp)) ||
 	    (!pquotaondisk &&  XFS_IS_PQUOTA_ON(mp)) ||
 	     (gquotaondisk && !XFS_IS_GQUOTA_ON(mp)) ||
-	    (!gquotaondisk &&  XFS_IS_OQUOTA_ON(mp)))  &&
+	    (!gquotaondisk &&  XFS_IS_GQUOTA_ON(mp)))  &&
 	    xfs_dev_is_read_only(mp, "changing quota state")) {
 		xfs_warn(mp, "please mount with%s%s%s%s.",
 			(!quotaondisk ? "out quota" : ""),
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 3a67805..5f3f2d3 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -222,10 +222,14 @@ xfs_qm_scall_quotaoff(
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
@@ -872,9 +876,11 @@ xfs_dqrele_inode(
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
 
@@ -883,10 +889,14 @@ xfs_dqrele_inode(
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
index 41483d8..c50dd76 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -189,9 +189,9 @@ typedef struct xfs_qoff_logformat {
  * are in the process of getting turned off. These flags are in m_qflags but
  * never in sb_qflags.
  */
-#define XFS_UQUOTA_ACTIVE	0x0100  /* uquotas are being turned off */
-#define XFS_PQUOTA_ACTIVE	0x0200  /* pquotas are being turned off */
-#define XFS_GQUOTA_ACTIVE	0x0400  /* gquotas are being turned off */
+#define XFS_UQUOTA_ACTIVE	0x1000  /* uquotas are being turned off */
+#define XFS_PQUOTA_ACTIVE	0x2000  /* pquotas are being turned off */
+#define XFS_GQUOTA_ACTIVE	0x4000  /* gquotas are being turned off */
 
 /*
  * Checking XFS_IS_*QUOTA_ON() while holding any inode lock guarantees
@@ -200,8 +200,6 @@ typedef struct xfs_qoff_logformat {
 #define XFS_IS_QUOTA_ON(mp)	((mp)->m_qflags & (XFS_UQUOTA_ACTIVE | \
 						   XFS_GQUOTA_ACTIVE | \
 						   XFS_PQUOTA_ACTIVE))
-#define XFS_IS_OQUOTA_ON(mp)	((mp)->m_qflags & (XFS_GQUOTA_ACTIVE | \
-						   XFS_PQUOTA_ACTIVE))
 #define XFS_IS_UQUOTA_ON(mp)	((mp)->m_qflags & XFS_UQUOTA_ACTIVE)
 #define XFS_IS_GQUOTA_ON(mp)	((mp)->m_qflags & XFS_GQUOTA_ACTIVE)
 #define XFS_IS_PQUOTA_ON(mp)	((mp)->m_qflags & XFS_PQUOTA_ACTIVE)
@@ -269,8 +267,10 @@ typedef struct xfs_qoff_logformat {
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
@@ -325,17 +325,18 @@ extern int xfs_trans_reserve_quota_nblks(struct xfs_trans *,
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
@@ -350,10 +351,12 @@ extern void xfs_qm_unmount_quotas(struct xfs_mount *);
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
@@ -368,14 +371,15 @@ static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp,
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
@@ -393,8 +397,8 @@ static inline int xfs_qm_sync(struct xfs_mount *mp, int flags)
 
 #define xfs_trans_unreserve_quota_nblks(tp, ip, nblks, ninos, flags) \
 	xfs_trans_reserve_quota_nblks(tp, ip, -(nblks), -(ninos), flags)
-#define xfs_trans_reserve_quota(tp, mp, ud, gd, nb, ni, f) \
-	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, nb, ni, \
+#define xfs_trans_reserve_quota(tp, mp, ud, gd, pd, nb, ni, f) \
+	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, pd, nb, ni, \
 				f | XFS_QMOPT_RES_REGBLKS)
 
 extern int xfs_qm_dqcheck(struct xfs_mount *, xfs_disk_dquot_t *,
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index cb6ae71..5242512 100644
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
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index bea957d..3f84601 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -115,7 +115,7 @@ xfs_trans_dup_dqinfo(
 	if(otp->t_flags & XFS_TRANS_DQ_DIRTY)
 		ntp->t_flags |= XFS_TRANS_DQ_DIRTY;
 
-	for (j = 0; j < 2; j++) {
+	for (j = 0; j < 3; j++) { /* 0 - usr, 1 - grp, 2 - prj */
 		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
 			if (oqa[i].qt_dquot == NULL)
 				break;
@@ -140,8 +140,13 @@ xfs_trans_dup_dqinfo(
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
 
@@ -168,8 +173,10 @@ xfs_trans_mod_dquot_byino(
 
 	if (XFS_IS_UQUOTA_ON(mp) && ip->i_udquot)
 		(void) xfs_trans_mod_dquot(tp, ip->i_udquot, field, delta);
-	if (XFS_IS_OQUOTA_ON(mp) && ip->i_gdquot)
+	if (XFS_IS_GQUOTA_ON(mp) && ip->i_gdquot)
 		(void) xfs_trans_mod_dquot(tp, ip->i_gdquot, field, delta);
+	if (XFS_IS_PQUOTA_ON(mp) && ip->i_pdquot)
+		(void) xfs_trans_mod_dquot(tp, ip->i_pdquot, field, delta);
 }
 
 STATIC xfs_dqtrx_t *
@@ -180,8 +187,12 @@ xfs_trans_get_dqtrx(
 	int		i;
 	xfs_dqtrx_t	*qa;
 
-	qa = XFS_QM_ISUDQ(dqp) ?
-		tp->t_dqinfo->dqa_usrdquots : tp->t_dqinfo->dqa_grpdquots;
+	if (XFS_QM_ISUDQ(dqp))
+		qa = tp->t_dqinfo->dqa_usrdquots;
+	else if (XFS_QM_ISGDQ(dqp))
+		qa = tp->t_dqinfo->dqa_grpdquots;
+	else
+		qa = tp->t_dqinfo->dqa_prjdquots;
 
 	for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
 		if (qa[i].qt_dquot == NULL ||
@@ -342,12 +353,14 @@ xfs_trans_apply_dquot_deltas(
 
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
-
 		/*
 		 * Lock all of the dquots and join them to the transaction.
 		 */
@@ -498,9 +511,12 @@ xfs_trans_apply_dquot_deltas(
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
 
@@ -525,7 +541,7 @@ xfs_trans_unreserve_and_mod_dquots(
 
 	qa = tp->t_dqinfo->dqa_usrdquots;
 
-	for (j = 0; j < 2; j++) {
+	for (j = 0; j < 3; j++) { /* 0 - usr, 1 - grp, 2 - prj */
 		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
 			qtrx = &qa[i];
 			/*
@@ -567,7 +583,10 @@ xfs_trans_unreserve_and_mod_dquots(
 				xfs_dqunlock(dqp);
 
 		}
-		qa = tp->t_dqinfo->dqa_grpdquots;
+		if (qa == tp->t_dqinfo->dqa_usrdquots)
+			qa = tp->t_dqinfo->dqa_grpdquots;
+		else
+			qa = tp->t_dqinfo->dqa_prjdquots;
 	}
 }
 
@@ -737,8 +756,8 @@ error_return:
 
 /*
  * Given dquot(s), make disk block and/or inode reservations against them.
- * The fact that this does the reservation against both the usr and
- * grp/prj quotas is important, because this follows a both-or-nothing
+ * The fact that this does the reservation against user, group and
+ * project quotas is important, because this follows a all-or-nothing
  * approach.
  *
  * flags = XFS_QMOPT_FORCE_RES evades limit enforcement. Used by chown.
@@ -753,6 +772,7 @@ xfs_trans_reserve_quota_bydquots(
 	xfs_mount_t	*mp,
 	xfs_dquot_t	*udqp,
 	xfs_dquot_t	*gdqp,
+	xfs_dquot_t	*pdqp,
 	long		nblks,
 	long		ninos,
 	uint		flags)
@@ -790,6 +810,24 @@ xfs_trans_reserve_quota_bydquots(
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
@@ -831,6 +869,7 @@ xfs_trans_reserve_quota_nblks(
 	 */
 	return xfs_trans_reserve_quota_bydquots(tp, mp,
 						ip->i_udquot, ip->i_gdquot,
+						ip->i_pdquot,
 						nblks, ninos, flags);
 }
 
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 4ecf2a5..404096a 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -833,6 +833,7 @@ xfs_create(
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
+	struct xfs_dquot	*pdqp = NULL;
 	uint			resblks;
 	uint			log_res;
 	uint			log_count;
@@ -851,7 +852,7 @@ xfs_create(
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
 	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
-			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
+		XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp, &pdqp);
 	if (error)
 		return error;
 
@@ -911,7 +912,8 @@ xfs_create(
 	/*
 	 * Reserve disk quota and the inode.
 	 */
-	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp, resblks, 1, 0);
+	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
+						pdqp, resblks, 1, 0);
 	if (error)
 		goto out_trans_cancel;
 
@@ -975,7 +977,7 @@ xfs_create(
 	 * These ids of the inode couldn't have changed since the new
 	 * inode has been locked ever since it was created.
 	 */
-	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp);
+	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
 
 	error = xfs_bmap_finish(&tp, &free_list, &committed);
 	if (error)
@@ -987,6 +989,7 @@ xfs_create(
 
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
 	return 0;
@@ -1008,6 +1011,7 @@ xfs_create(
 
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
+	struct xfs_dquot	*udqp, *gdqp, *pdqp;
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
