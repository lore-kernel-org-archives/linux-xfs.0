Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0VLfbn3101375 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 15:41:38 -0600
Received: from caliban.corp.sgi.com ([10.202.8.38])
	by cthulhu.engr.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id
	q0VLfbPo020761 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 13:41:37 -0800
Date: Tue, 31 Jan 2012 13:41:43 -0800
From: Phil White <pwhite@sgi.com>
Subject: [NOTES] [RFC v3 PATCH 2/4] xfs: Add pquota fields where gquota is
	used.
Message-ID: <20120131214143.GD2569@caliban.corp.sgi.com>
References: <20120123173158.31640.30333.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120123173210.31640.96565.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120123173210.31640.96565.sendpatchset@chandra-lucid.austin.ibm.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

#pwhite: Most of the changes fall into two categories.
#  1) Changing the check for OQUOTA to mean either GQUOTA or PQUOTA to an
#     inclusive or.
#  2) Substituting OQUOTA for PQUOTA and GQUOTA in function arguments,
#     initializations, etc.

Add project quota changes to all the places where group quota field
is used.

No externally visible changed and no superblock changes, yet.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Reviewed-by: Phil White <pwhite@sgi.com>
---
 fs/xfs/xfs_dquot.c       |   17 +++-
 fs/xfs/xfs_dquot.h       |    9 ++-
 fs/xfs/xfs_iget.c        |    2 +-
 fs/xfs/xfs_inode.h       |    1 +
 fs/xfs/xfs_ioctl.c       |   12 +-
 fs/xfs/xfs_iops.c        |    4 +-
 fs/xfs/xfs_qm.c          |  259 ++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_qm.h          |    7 +-
 fs/xfs/xfs_qm_bhv.c      |    2 +-
 fs/xfs/xfs_qm_syscalls.c |   19 +++-
 fs/xfs/xfs_quota.h       |   38 ++++---
 fs/xfs/xfs_quota_priv.h  |    6 +-
 fs/xfs/xfs_sb.h          |    1 +
 fs/xfs/xfs_super.c       |    5 +-
 fs/xfs/xfs_trans_dquot.c |   71 ++++++++++---
 fs/xfs/xfs_vnodeops.c    |   23 +++--
 16 files changed, 330 insertions(+), 146 deletions(-)

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
#pwhite: These have to get moved up because of the definitions for
#XFS_[GP]QUOTA_*
 
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
#pwhite: This -- and the series of redefinitions following are to change out
#passing one oquota structure for two structures -- one for pquota, one for
#gquota.
 
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
diff --git a/fs/xfs/xfs_quota_priv.h b/fs/xfs/xfs_quota_priv.h
index 94a3d92..0e5ef5a 100644
--- a/fs/xfs/xfs_quota_priv.h
+++ b/fs/xfs/xfs_quota_priv.h
@@ -30,11 +30,7 @@
 #define XFS_DQ_HASHVAL(mp, id) (((__psunsigned_t)(mp) + \
 				 (__psunsigned_t)(id)) & \
 				(xfs_Gqm->qm_dqhashmask - 1))
-#define XFS_DQ_HASH(mp, id, type)   (type == XFS_DQ_USER ? \
-				     (xfs_Gqm->qm_usr_dqhtable + \
-				      XFS_DQ_HASHVAL(mp, id)) : \
-				     (xfs_Gqm->qm_grp_dqhtable + \
-				      XFS_DQ_HASHVAL(mp, id)))
+
#pwhite: Ok -- this is a little worrying.  I'm not sure why we're removing
#XFS_DQ_HASH.
 #define XFS_IS_DQUOT_UNINITIALIZED(dqp) ( \
 	!dqp->q_core.d_blk_hardlimit && \
 	!dqp->q_core.d_blk_softlimit && \
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
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 9b4f3ad..d46ff1c 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -68,6 +68,7 @@ typedef xfs_dqhash_t	xfs_dqlist_t;
 typedef struct xfs_qm {
 	xfs_dqlist_t	*qm_usr_dqhtable;/* udquot hash table */
 	xfs_dqlist_t	*qm_grp_dqhtable;/* gdquot hash table */
+	xfs_dqlist_t	*qm_prj_dqhtable;/* project hash table */
 	uint		 qm_dqhashmask;	 /* # buckets in dq hashtab - 1 */
 	struct list_head qm_dqfrlist;	 /* freelist of dquots */
 	struct mutex	 qm_dqfrlist_lock;
@@ -86,6 +87,7 @@ typedef struct xfs_qm {
 typedef struct xfs_quotainfo {
 	xfs_inode_t	*qi_uquotaip;	 /* user quota inode */
 	xfs_inode_t	*qi_gquotaip;	 /* group quota inode */
+	xfs_inode_t	*qi_pquotaip;	 /* project quota inode */
 	struct list_head qi_dqlist;	 /* all dquots in filesys */
 	struct mutex	 qi_dqlist_lock;
 	int		 qi_dquots;
#pwhite: Why are the group & project quota inodes different here, but not in
#xfs_sb?  This anticipates a change in the 3rd patch.
@@ -110,13 +112,11 @@ typedef struct xfs_quotainfo {
 
 
 extern void	xfs_trans_mod_dquot(xfs_trans_t *, xfs_dquot_t *, uint, long);
-extern int	xfs_trans_reserve_quota_bydquots(xfs_trans_t *, xfs_mount_t *,
-			xfs_dquot_t *, xfs_dquot_t *, long, long, uint);
 extern void	xfs_trans_dqjoin(xfs_trans_t *, xfs_dquot_t *);
 extern void	xfs_trans_log_dquot(xfs_trans_t *, xfs_dquot_t *);
 
 /*
- * We keep the usr and grp dquots separately so that locking will be easier
+ * We keep the usr, grp, and prj dquots separately so that locking will be easier
  * to do at commit time. All transactions that we know of at this point
  * affect no more than two dquots of one type. Hence, the TRANS_MAXDQS value.
  */
@@ -124,6 +124,7 @@ extern void	xfs_trans_log_dquot(xfs_trans_t *, xfs_dquot_t *);
 typedef struct xfs_dquot_acct {
 	xfs_dqtrx_t	dqa_usrdquots[XFS_QM_TRANS_MAXDQS];
 	xfs_dqtrx_t	dqa_grpdquots[XFS_QM_TRANS_MAXDQS];
+	xfs_dqtrx_t	dqa_prjdquots[XFS_QM_TRANS_MAXDQS];
 } xfs_dquot_acct_t;
 
 /*
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 2f27b74..cafc3c2 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -224,6 +224,7 @@ typedef struct xfs_inode {
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
 	struct xfs_dquot	*i_udquot;	/* user dquot */
 	struct xfs_dquot	*i_gdquot;	/* group dquot */
+	struct xfs_dquot	*i_pdquot;	/* project dquot */
 
 	/* Inode location stuff */
 	xfs_ino_t		i_ino;		/* inode number (agno/agino)*/
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 41cb5f4..0cdb79e 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -59,6 +59,7 @@ typedef struct xfs_dquot {
 	xfs_fileoff_t	 q_fileoffset;	/* offset in quotas file */
 
 	struct xfs_dquot*q_gdquot;	/* group dquot, hint only */
+	struct xfs_dquot*q_pdquot;	/* project dquot, hint only */
 	xfs_disk_dquot_t q_core;	/* actual usage & quotas */
 	xfs_dq_logitem_t q_logitem;	/* dquot log item */
 	xfs_qcnt_t	 q_res_bcount;	/* total regular nblks used+reserved */
@@ -122,8 +123,9 @@ static inline int xfs_this_quota_on(struct xfs_mount *mp, int type)
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
@@ -136,6 +138,7 @@ static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
 	case XFS_DQ_USER:
 		return ip->i_udquot;
 	case XFS_DQ_PROJ:
+		return ip->i_pdquot;
 	case XFS_DQ_GROUP:
 		return ip->i_gdquot;
 	default:
@@ -151,7 +154,9 @@ static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
 #define XFS_DQ_TO_QINF(dqp)	((dqp)->q_mount->m_quotainfo)
 #define XFS_DQ_TO_QIP(dqp)	(XFS_QM_ISUDQ(dqp) ? \
 				 XFS_DQ_TO_QINF(dqp)->qi_uquotaip : \
-				 XFS_DQ_TO_QINF(dqp)->qi_gquotaip)
+				 (XFS_QM_ISGDQ(dqp) ? \
+				 XFS_DQ_TO_QINF(dqp)->qi_gquotaip : \
+				 XFS_DQ_TO_QINF(dqp)->qi_pquotaip))
 
 extern int		xfs_qm_dqread(struct xfs_mount *, xfs_dqid_t, uint,
 					uint, struct xfs_dquot	**);
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index bf4fe86..e6e9a1a 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -706,6 +706,21 @@ xfs_qm_dqlookup(
 	return 1;
 }
 
+static struct xfs_dqhash *xfs_dq_hash(struct xfs_mount *mp,
+		xfs_dqid_t id, uint type)
+{
+	switch (type) {
+	case XFS_DQ_USER:
+		return (xfs_Gqm->qm_usr_dqhtable + XFS_DQ_HASHVAL(mp, id));
+	case XFS_DQ_GROUP:
+		return (xfs_Gqm->qm_grp_dqhtable + XFS_DQ_HASHVAL(mp, id));
+	case XFS_DQ_PROJ:
+		return (xfs_Gqm->qm_prj_dqhtable + XFS_DQ_HASHVAL(mp, id));
+	default:
+		return NULL;
+	}
+}
+
#pwhite: OK.  This replaces XFS_DQ_HASH().  Fair enough.
 /*
  * Given the file system, inode OR id, and type (UDQUOT/GDQUOT), return a
  * a locked dquot, doing an allocation (if requested) as needed.
@@ -734,7 +749,7 @@ xfs_qm_dqget(
 	    (! XFS_IS_GQUOTA_ON(mp) && type == XFS_DQ_GROUP)) {
 		return (ESRCH);
 	}
-	h = XFS_DQ_HASH(mp, id, type);
+	h = xfs_dq_hash(mp, id, type);
 
 #ifdef DEBUG
 	if (xfs_do_dqerror) {
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 8c3e463..823f5d8 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -362,7 +362,7 @@ xfs_iget_cache_miss(
 	}
 
 	/* These values _must_ be set before releasing the radix tree lock! */
-	ip->i_udquot = ip->i_gdquot = NULL;
+	ip->i_udquot = ip->i_gdquot = ip->i_pdquot = NULL;
 	xfs_iflags_set(ip, XFS_INEW);
 
 	spin_unlock(&pag->pag_ici_lock);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 76f3ca5..abe9269 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -907,7 +907,7 @@ xfs_ioctl_setattr(
 	struct xfs_trans	*tp;
 	unsigned int		lock_flags = 0;
 	struct xfs_dquot	*udqp = NULL;
-	struct xfs_dquot	*gdqp = NULL;
+	struct xfs_dquot	*pdqp = NULL;
#pwhite: Why does this remove *gdqp?  Are we never going to use group quotas
#through this ioctl() ?
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
index ab30253..6959a48 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -569,7 +569,7 @@ xfs_setattr_nonsize(
 		ASSERT(udqp == NULL);
 		ASSERT(gdqp == NULL);
 		error = xfs_qm_vop_dqalloc(ip, uid, gid, xfs_get_projid(ip),
-					 qflags, &udqp, &gdqp);
+					 qflags, &udqp, &gdqp, NULL);
 		if (error)
 			return error;
 	}
@@ -604,7 +604,7 @@ xfs_setattr_nonsize(
 		    ((XFS_IS_UQUOTA_ON(mp) && iuid != uid) ||
 		     (XFS_IS_GQUOTA_ON(mp) && igid != gid))) {
 			ASSERT(tp);
-			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
+			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp, NULL,
 						capable(CAP_FOWNER) ?
 						XFS_QMOPT_FORCE_RES : 0);
 			if (error)	/* out of quota */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index bb8c2ac..47c33a5 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -74,7 +74,7 @@ static struct shrinker xfs_qm_shaker = {
 STATIC struct xfs_qm *
 xfs_Gqm_init(void)
 {
-	xfs_dqhash_t	*udqhash, *gdqhash;
+	xfs_dqhash_t	*udqhash, *gdqhash, *pdqhash;
 	xfs_qm_t	*xqm;
 	size_t		hsize;
 	uint		i;
@@ -92,6 +92,10 @@ xfs_Gqm_init(void)
 	if (!gdqhash)
 		goto out_free_udqhash;
 
+	pdqhash = kmem_zalloc_large(hsize);
+	if (!pdqhash)
+		goto out_free_gdqhash;
+
 	hsize /= sizeof(xfs_dqhash_t);
 	ndquot = hsize << 8;
 
@@ -99,12 +103,15 @@ xfs_Gqm_init(void)
 	xqm->qm_dqhashmask = hsize - 1;
 	xqm->qm_usr_dqhtable = udqhash;
 	xqm->qm_grp_dqhtable = gdqhash;
+	xqm->qm_prj_dqhtable = pdqhash;
 	ASSERT(xqm->qm_usr_dqhtable != NULL);
 	ASSERT(xqm->qm_grp_dqhtable != NULL);
+	ASSERT(xqm->qm_prj_dqhtable != NULL);
 
 	for (i = 0; i < hsize; i++) {
 		xfs_qm_list_init(&(xqm->qm_usr_dqhtable[i]), "uxdqh", i);
 		xfs_qm_list_init(&(xqm->qm_grp_dqhtable[i]), "gxdqh", i);
+		xfs_qm_list_init(&(xqm->qm_prj_dqhtable[i]), "pxdqh", i);
 	}
 
 	/*
@@ -141,6 +148,8 @@ xfs_Gqm_init(void)
 	xqm->qm_nrefs = 0;
 	return xqm;
 
+ out_free_gdqhash:
+	kmem_free_large(gdqhash);
  out_free_udqhash:
 	kmem_free_large(udqhash);
  out:
@@ -169,11 +178,14 @@ xfs_qm_destroy(
 	for (i = 0; i < hsize; i++) {
 		xfs_qm_list_destroy(&(xqm->qm_usr_dqhtable[i]));
 		xfs_qm_list_destroy(&(xqm->qm_grp_dqhtable[i]));
+		xfs_qm_list_destroy(&(xqm->qm_prj_dqhtable[i]));
 	}
 	kmem_free_large(xqm->qm_usr_dqhtable);
 	kmem_free_large(xqm->qm_grp_dqhtable);
+	kmem_free_large(xqm->qm_prj_dqhtable);
 	xqm->qm_usr_dqhtable = NULL;
 	xqm->qm_grp_dqhtable = NULL;
+	xqm->qm_prj_dqhtable = NULL;
 	xqm->qm_dqhashmask = 0;
 
 	kmem_free(xqm);
@@ -378,6 +390,10 @@ xfs_qm_unmount_quotas(
 			IRELE(mp->m_quotainfo->qi_gquotaip);
 			mp->m_quotainfo->qi_gquotaip = NULL;
 		}
+		if (mp->m_quotainfo->qi_pquotaip) {
+			IRELE(mp->m_quotainfo->qi_pquotaip);
+			mp->m_quotainfo->qi_pquotaip = NULL;
+		}
 	}
 }
 
@@ -450,7 +466,7 @@ xfs_qm_detach_gdquots(
 	struct xfs_mount	*mp)
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	struct xfs_dquot	*dqp, *gdqp;
+	struct xfs_dquot	*dqp, *gdqp, *pdqp;
 
  again:
 	ASSERT(mutex_is_locked(&q->qi_dqlist_lock));
@@ -467,10 +483,15 @@ xfs_qm_detach_gdquots(
 		gdqp = dqp->q_gdquot;
 		if (gdqp)
 			dqp->q_gdquot = NULL;
+		pdqp = dqp->q_pdquot;
+		if (pdqp)
+			dqp->q_pdquot = NULL;
 		xfs_dqunlock(dqp);
 
 		if (gdqp)
 			xfs_qm_dqrele(gdqp);
+		if (pdqp)
+			xfs_qm_dqrele(pdqp);
 	}
 }
 
@@ -593,7 +614,10 @@ xfs_qm_dqattach_one(
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
 
@@ -636,28 +660,29 @@ xfs_qm_dqattach_one(
 
 
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
@@ -698,12 +723,8 @@ xfs_qm_dqattach_locked(
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
#pwhite: Shouldn't this code check for PQUOTA_ON and do the appropriate attach?
 		/*
@@ -715,14 +736,28 @@ xfs_qm_dqattach_locked(
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
#pwhite: Oh, there it is.  That'll teach me to hold my horses.
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
@@ -730,8 +765,13 @@ xfs_qm_dqattach_locked(
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
@@ -739,8 +779,10 @@ xfs_qm_dqattach_locked(
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
@@ -770,7 +812,7 @@ void
 xfs_qm_dqdetach(
 	xfs_inode_t	*ip)
 {
-	if (!(ip->i_udquot || ip->i_gdquot))
+	if (!(ip->i_udquot || ip->i_gdquot || ip->i_pdquot))
 		return;
 
 	trace_xfs_dquot_dqdetach(ip);
@@ -785,6 +827,10 @@ xfs_qm_dqdetach(
 		xfs_qm_dqrele(ip->i_gdquot);
 		ip->i_gdquot = NULL;
 	}
+	if (ip->i_pdquot) {
+		xfs_qm_dqrele(ip->i_pdquot);
+		ip->i_pdquot = NULL;
+	}
 }
 
 /*
@@ -936,6 +982,10 @@ xfs_qm_destroy_quotainfo(
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
@@ -1413,7 +1463,7 @@ xfs_qm_quotacheck(
 	int		done, count, error;
 	xfs_ino_t	lastino;
 	size_t		structsz;
-	xfs_inode_t	*uip, *gip;
+	xfs_inode_t	*uip, *gip, *pip;
 	uint		flags;
 
 	count = INT_MAX;
@@ -1421,7 +1471,8 @@ xfs_qm_quotacheck(
 	lastino = 0;
 	flags = 0;
 
-	ASSERT(mp->m_quotainfo->qi_uquotaip || mp->m_quotainfo->qi_gquotaip);
+	ASSERT(mp->m_quotainfo->qi_uquotaip || mp->m_quotainfo->qi_gquotaip 
+			|| mp->m_quotainfo->qi_pquotaip);
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
 	/*
@@ -1447,12 +1498,18 @@ xfs_qm_quotacheck(
 
 	gip = mp->m_quotainfo->qi_gquotaip;
 	if (gip) {
-		error = xfs_qm_dqiterate(mp, gip, XFS_IS_GQUOTA_ON(mp) ?
-					XFS_QMOPT_GQUOTA : XFS_QMOPT_PQUOTA);
+		error = xfs_qm_dqiterate(mp, gip, XFS_QMOPT_GQUOTA);
 		if (error)
 			goto error_return;
-		flags |= XFS_IS_GQUOTA_ON(mp) ?
-					XFS_GQUOTA_CHKD : XFS_PQUOTA_CHKD;
+		flags |= XFS_GQUOTA_CHKD;
+	}
+
+	pip = mp->m_quotainfo->qi_pquotaip;
+	if (pip) {
+		error = xfs_qm_dqiterate(mp, pip, XFS_QMOPT_PQUOTA);
+		if (error)
+			goto error_return;
+		flags |= XFS_PQUOTA_CHKD;
 	}
 
 	do {
@@ -1533,13 +1590,13 @@ STATIC int
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
 
@@ -1554,7 +1611,7 @@ xfs_qm_init_quotainos(
 					     0, 0, &uip)))
 				return XFS_ERROR(error);
 		}
-		if (XFS_IS_OQUOTA_ON(mp) &&
+		if (XFS_IS_GQUOTA_ON(mp) &&
 		    mp->m_sb.sb_gquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_gquotino > 0);
 			if ((error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
@@ -1564,6 +1621,18 @@ xfs_qm_init_quotainos(
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
@@ -1571,7 +1640,7 @@ xfs_qm_init_quotainos(
 	}
 
 	/*
-	 * Create the two inodes, if they don't exist already. The changes
+	 * Create the three inodes, if they don't exist already. The changes
 	 * made above will get added to a transaction and logged in one of
 	 * the qino_alloc calls below.  If the device is readonly,
 	 * temporarily switch to read-write to do this.
@@ -1584,11 +1653,10 @@ xfs_qm_init_quotainos(
 
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
@@ -1596,9 +1664,23 @@ xfs_qm_init_quotainos(
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
@@ -1862,10 +1944,11 @@ xfs_qm_vop_dqalloc(
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
 
@@ -1890,7 +1973,7 @@ xfs_qm_vop_dqalloc(
 		}
 	}
 
-	uq = gq = NULL;
+	uq = gq = pq = NULL;
 	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
 		if (ip->i_d.di_uid != uid) {
 			/*
@@ -1946,25 +2029,28 @@ xfs_qm_vop_dqalloc(
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
@@ -1979,6 +2065,10 @@ xfs_qm_vop_dqalloc(
 		*O_gdqpp = gq;
 	else if (gq)
 		xfs_qm_dqrele(gq);
+	if (O_pdqpp)
+		*O_pdqpp = pq;
+	else if (pq)
+		xfs_qm_dqrele(pq);
 	return 0;
 }
 
@@ -2031,11 +2121,13 @@ xfs_qm_vop_chown_reserve(
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
 
 
@@ -2043,7 +2135,8 @@ xfs_qm_vop_chown_reserve(
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
 	delblks = ip->i_delayed_blks;
-	delblksudq = delblksgdq = unresudq = unresgdq = NULL;
+	delblksudq = delblksgdq = delblkspdq = NULL;
+	unresudq = unresgdq = unrespdq = NULL;
 	blkflags = XFS_IS_REALTIME_INODE(ip) ?
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
@@ -2060,25 +2153,28 @@ xfs_qm_vop_chown_reserve(
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
@@ -2091,15 +2187,16 @@ xfs_qm_vop_chown_reserve(
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
@@ -2138,7 +2235,8 @@ xfs_qm_vop_create_dqattach(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	struct xfs_dquot	*udqp,
-	struct xfs_dquot	*gdqp)
+	struct xfs_dquot	*gdqp,
+	struct xfs_dquot	*pdqp)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 
@@ -2158,13 +2256,18 @@ xfs_qm_vop_create_dqattach(
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
index d43c68c..9849828 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -123,7 +123,8 @@ xfs_qm_scall_quotaoff(
 		dqtype |= XFS_QMOPT_GQUOTA;
 		flags |= (XFS_GQUOTA_CHKD | XFS_GQUOTA_ENFD);
 		inactivate_flags |= XFS_GQUOTA_ACTIVE;
-	} else if (flags & XFS_PQUOTA_ACCT) {
+	}
+	if (flags & XFS_PQUOTA_ACCT) {
 		dqtype |= XFS_QMOPT_PQUOTA;
 		flags |= (XFS_PQUOTA_CHKD | XFS_PQUOTA_ENFD);
 		inactivate_flags |= XFS_PQUOTA_ACTIVE;
@@ -223,10 +224,14 @@ xfs_qm_scall_quotaoff(
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
@@ -878,9 +883,11 @@ xfs_dqrele_inode(
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
 
@@ -889,10 +896,14 @@ xfs_dqrele_inode(
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
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 01de9f9..b0a1266 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -539,14 +539,13 @@ xfs_showargs(
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
index bea957d..48003d3 100644
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
@@ -180,15 +187,20 @@ xfs_trans_get_dqtrx(
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
 
@@ -342,9 +354,12 @@ xfs_trans_apply_dquot_deltas(
 
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
 
@@ -498,9 +513,12 @@ xfs_trans_apply_dquot_deltas(
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
 
@@ -525,7 +543,7 @@ xfs_trans_unreserve_and_mod_dquots(
 
 	qa = tp->t_dqinfo->dqa_usrdquots;
 
-	for (j = 0; j < 2; j++) {
+	for (j = 0; j < 3; j++) { /* 0 - usr, 1 - grp, 2 - prj */
 		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
 			qtrx = &qa[i];
 			/*
@@ -567,7 +585,10 @@ xfs_trans_unreserve_and_mod_dquots(
 				xfs_dqunlock(dqp);
 
 		}
-		qa = tp->t_dqinfo->dqa_grpdquots;
+		if (qa == tp->t_dqinfo->dqa_usrdquots)
+			qa = tp->t_dqinfo->dqa_grpdquots;
+		else
+			qa = tp->t_dqinfo->dqa_prjdquots;
 	}
 }
 
@@ -737,8 +758,8 @@ error_return:
 
 /*
  * Given dquot(s), make disk block and/or inode reservations against them.
- * The fact that this does the reservation against both the usr and
- * grp/prj quotas is important, because this follows a both-or-nothing
+ * The fact that this does the reservation against user, group and
+ * project quotas is important, because this follows a all-or-nothing
  * approach.
  *
  * flags = XFS_QMOPT_FORCE_RES evades limit enforcement. Used by chown.
@@ -753,6 +774,7 @@ xfs_trans_reserve_quota_bydquots(
 	xfs_mount_t	*mp,
 	xfs_dquot_t	*udqp,
 	xfs_dquot_t	*gdqp,
+	xfs_dquot_t	*pdqp,
 	long		nblks,
 	long		ninos,
 	uint		flags)
@@ -790,6 +812,24 @@ xfs_trans_reserve_quota_bydquots(
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
@@ -831,6 +871,7 @@ xfs_trans_reserve_quota_nblks(
 	 */
 	return xfs_trans_reserve_quota_bydquots(tp, mp,
 						ip->i_udquot, ip->i_gdquot,
+						ip->i_pdquot,
 						nblks, ninos, flags);
 }
 
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 0cf52da..62d8689 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -851,6 +851,7 @@ xfs_create(
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
+	struct xfs_dquot	*pdqp = NULL;
 	uint			resblks;
 	uint			log_res;
 	uint			log_count;
@@ -869,7 +870,7 @@ xfs_create(
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
 	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
-			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
+		XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp, &pdqp);
 	if (error)
 		return error;
 
@@ -929,7 +930,8 @@ xfs_create(
 	/*
 	 * Reserve disk quota and the inode.
 	 */
-	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp, resblks, 1, 0);
+	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
+						pdqp, resblks, 1, 0);
 	if (error)
 		goto out_trans_cancel;
 
@@ -993,7 +995,7 @@ xfs_create(
 	 * These ids of the inode couldn't have changed since the new
 	 * inode has been locked ever since it was created.
 	 */
-	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp);
+	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
 
 	error = xfs_bmap_finish(&tp, &free_list, &committed);
 	if (error)
@@ -1005,6 +1007,7 @@ xfs_create(
 
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
 	return 0;
@@ -1026,6 +1029,7 @@ xfs_create(
 
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
 
 	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
@@ -1516,7 +1520,7 @@ xfs_symlink(
 	int			n;
 	xfs_buf_t		*bp;
 	prid_t			prid;
-	struct xfs_dquot	*udqp, *gdqp;
+	struct xfs_dquot	*udqp, *gdqp, *pdqp;
 	uint			resblks;
 
 	*ipp = NULL;
@@ -1546,7 +1550,7 @@ xfs_symlink(
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
 	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
-			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
+		XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp, &pdqp);
 	if (error)
 		goto std_return;
 
@@ -1587,7 +1591,8 @@ xfs_symlink(
 	/*
 	 * Reserve disk quota : blocks and inode.
 	 */
-	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp, resblks, 1, 0);
+	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
+						pdqp, resblks, 1, 0);
 	if (error)
 		goto error_return;
 
@@ -1625,7 +1630,7 @@ xfs_symlink(
 	/*
 	 * Also attach the dquot(s) to it, if applicable.
 	 */
-	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp);
+	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
 
 	if (resblks)
 		resblks -= XFS_IALLOC_SPACE_RES(mp);
@@ -1709,6 +1714,7 @@ xfs_symlink(
 	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
 
 	*ipp = ip;
 	return 0;
@@ -1722,6 +1728,7 @@ xfs_symlink(
 	xfs_trans_cancel(tp, cancel_flags);
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
 
 	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
@@ -2188,7 +2195,7 @@ xfs_free_file_space(
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
