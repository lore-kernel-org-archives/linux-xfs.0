Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9QLMLmr036992 for <xfs@oss.sgi.com>; Wed, 26 Oct 2011 16:22:21 -0500
Received: from e6.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B80D51CBFA87
	for <xfs@oss.sgi.com>; Wed, 26 Oct 2011 14:22:20 -0700 (PDT)
Received: from e6.ny.us.ibm.com (e6.ny.us.ibm.com [32.97.182.146]) by
	cuda.sgi.com with ESMTP id fe5cBYuVqUeA4Ilb for
	<xfs@oss.sgi.com>; Wed, 26 Oct 2011 14:22:20 -0700 (PDT)
Received: from /spool/local
	by e6.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 26 Oct 2011 17:22:03 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p9QLLxr72109518
	for <xfs@oss.sgi.com>; Wed, 26 Oct 2011 17:21:59 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p9QLLxvN014625 for <xfs@oss.sgi.com>; Wed, 26 Oct 2011 19:21:59 -0200
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Wed, 26 Oct 2011 16:21:58 -0500
Message-Id: <20111026212158.6513.17142.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20111026212150.6513.38058.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20111026212150.6513.38058.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [RFC v2 PATCH 1/5] xfs: Prep work for supporting both pquota and
	gquota.
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

Define few macros, inline functions, and change interface in
preparation for allowing pquota and gquota to be used together.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_dquot.c       |   37 +++++++++++--------------------------
 fs/xfs/xfs_dquot.h       |   15 ++++++++++++---
 fs/xfs/xfs_log_recover.c |    2 +-
 fs/xfs/xfs_mount.c       |    6 ++++--
 fs/xfs/xfs_mount.h       |    2 +-
 fs/xfs/xfs_qm.c          |    2 +-
 fs/xfs/xfs_quota.h       |    2 ++
 fs/xfs/xfs_super.c       |    7 +++----
 8 files changed, 35 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 25d7280..1952999 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -372,7 +372,7 @@ xfs_qm_dqalloc(
 	 * Return if this type of quotas is turned off while we didn't
 	 * have an inode lock
 	 */
-	if (XFS_IS_THIS_QUOTA_OFF(dqp)) {
+	if (!XFS_IS_TYPE_QUOTA_ON(dqp->q_mount, dqp->dq_flags)) {
 		xfs_iunlock(quotip, XFS_ILOCK_EXCL);
 		return (ESRCH);
 	}
@@ -474,7 +474,7 @@ xfs_qm_dqtobp(
 	dqp->q_fileoffset = (xfs_fileoff_t)id / mp->m_quotainfo->qi_dqperchunk;
 
 	xfs_ilock(quotip, XFS_ILOCK_SHARED);
-	if (XFS_IS_THIS_QUOTA_OFF(dqp)) {
+	if (!XFS_IS_TYPE_QUOTA_ON(dqp->q_mount, dqp->dq_flags)) {
 		/*
 		 * Return if this type of quotas is turned off while we
 		 * didn't have the quota inode lock.
@@ -808,7 +808,7 @@ xfs_qm_dqget(
 	uint		flags,	  /* DQALLOC, DQSUSER, DQREPAIR, DOWARN */
 	xfs_dquot_t	**O_dqpp) /* OUT : locked incore dquot */
 {
-	xfs_dquot_t	*dqp;
+	xfs_dquot_t	*dqp, *dqp1;
 	xfs_dqhash_t	*h;
 	uint		version;
 	int		error;
@@ -839,10 +839,7 @@ xfs_qm_dqget(
 	       type == XFS_DQ_GROUP);
 	if (ip) {
 		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-		if (type == XFS_DQ_USER)
-			ASSERT(ip->i_udquot == NULL);
-		else
-			ASSERT(ip->i_gdquot == NULL);
+		ASSERT(xfs_inode_dquot(ip, type) == NULL);
 	}
 #endif
 	mutex_lock(&h->qh_lock);
@@ -921,30 +918,18 @@ xfs_qm_dqget(
 		 * A dquot could be attached to this inode by now, since
 		 * we had dropped the ilock.
 		 */
-		if (type == XFS_DQ_USER) {
-			if (!XFS_IS_UQUOTA_ON(mp)) {
-				/* inode stays locked on return */
-				xfs_qm_dqdestroy(dqp);
-				return XFS_ERROR(ESRCH);
-			}
-			if (ip->i_udquot) {
+		if (XFS_IS_TYPE_QUOTA_ON(mp, type)) {
+			dqp1 = xfs_inode_dquot(ip, type);
+			if (dqp1) {
 				xfs_qm_dqdestroy(dqp);
-				dqp = ip->i_udquot;
+				dqp = dqp1;
 				xfs_dqlock(dqp);
 				goto dqret;
 			}
 		} else {
-			if (!XFS_IS_OQUOTA_ON(mp)) {
-				/* inode stays locked on return */
-				xfs_qm_dqdestroy(dqp);
-				return XFS_ERROR(ESRCH);
-			}
-			if (ip->i_gdquot) {
-				xfs_qm_dqdestroy(dqp);
-				dqp = ip->i_gdquot;
-				xfs_dqlock(dqp);
-				goto dqret;
-			}
+			/* inode stays locked on return */
+			xfs_qm_dqdestroy(dqp);
+			return XFS_ERROR(ESRCH);
 		}
 	}
 
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 34b7e94..4467fd1 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -102,6 +102,14 @@ static inline void xfs_dqfunlock(xfs_dquot_t *dqp)
 	complete(&dqp->q_flush);
 }
 
+static inline xfs_dquot_t *xfs_inode_dquot(xfs_inode_t *ip, int type)
+{
+	if (type == XFS_DQ_USER)
+		return ip->i_udquot;
+	else 
+		return ip->i_gdquot;
+}
+	
 #define XFS_DQ_IS_LOCKED(dqp)	(mutex_is_locked(&((dqp)->q_qlock)))
 #define XFS_DQ_IS_DIRTY(dqp)	((dqp)->dq_flags & XFS_DQ_DIRTY)
 #define XFS_QM_ISUDQ(dqp)	((dqp)->dq_flags & XFS_DQ_USER)
@@ -112,9 +120,10 @@ static inline void xfs_dqfunlock(xfs_dquot_t *dqp)
 				 XFS_DQ_TO_QINF(dqp)->qi_uquotaip : \
 				 XFS_DQ_TO_QINF(dqp)->qi_gquotaip)
 
-#define XFS_IS_THIS_QUOTA_OFF(d) (! (XFS_QM_ISUDQ(d) ? \
-				     (XFS_IS_UQUOTA_ON((d)->q_mount)) : \
-				     (XFS_IS_OQUOTA_ON((d)->q_mount))))
+#define XFS_IS_TYPE_QUOTA_ON(mp, type) \
+		((XFS_IS_UQUOTA_ON(mp) && (type) == XFS_DQ_USER) || \
+		(XFS_IS_OQUOTA_ON(mp) && (type) == XFS_DQ_PROJ) || \
+		(XFS_IS_OQUOTA_ON(mp) && (type) == XFS_DQ_GROUP))
 
 extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
 extern int		xfs_qm_dqflush(xfs_dquot_t *, uint);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 541a508..b38eb84 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3695,7 +3695,7 @@ xlog_do_recover(
 
 	/* Convert superblock from on-disk format */
 	sbp = &log->l_mp->m_sb;
-	xfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(bp));
+	xfs_sb_from_disk(log->l_mp, XFS_BUF_TO_SBP(bp));
 	ASSERT(sbp->sb_magicnum == XFS_SB_MAGIC);
 	ASSERT(xfs_sb_good_version(sbp));
 	xfs_buf_relse(bp);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d06afbc..19a6f40 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -553,9 +553,11 @@ out_unwind:
 
 void
 xfs_sb_from_disk(
-	xfs_sb_t	*to,
+	xfs_mount_t	*mp,
 	xfs_dsb_t	*from)
 {
+	xfs_sb_t	*to = &mp->m_sb;
+
 	to->sb_magicnum = be32_to_cpu(from->sb_magicnum);
 	to->sb_blocksize = be32_to_cpu(from->sb_blocksize);
 	to->sb_dblocks = be64_to_cpu(from->sb_dblocks);
@@ -693,7 +695,7 @@ reread:
 	 * Initialize the mount structure from the superblock.
 	 * But first do some basic consistency checking.
 	 */
-	xfs_sb_from_disk(&mp->m_sb, XFS_BUF_TO_SBP(bp));
+	xfs_sb_from_disk(mp, XFS_BUF_TO_SBP(bp));
 	error = xfs_mount_validate_sb(mp, &(mp->m_sb), flags);
 	if (error) {
 		if (loud)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index bb24dac..376a618 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -396,7 +396,7 @@ extern void	xfs_set_low_space_thresholds(struct xfs_mount *);
 extern void	xfs_mod_sb(struct xfs_trans *, __int64_t);
 extern int	xfs_initialize_perag(struct xfs_mount *, xfs_agnumber_t,
 					xfs_agnumber_t *);
-extern void	xfs_sb_from_disk(struct xfs_sb *, struct xfs_dsb *);
+extern void	xfs_sb_from_disk(struct xfs_mount *, struct xfs_dsb *);
 extern void	xfs_sb_to_disk(struct xfs_dsb *, struct xfs_sb *, __int64_t);
 
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 5cff443..508cee7 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1688,7 +1688,7 @@ xfs_qm_quotacheck(
 	 * quotachecked status, since we won't be doing accounting for
 	 * that type anymore.
 	 */
-	mp->m_qflags &= ~(XFS_OQUOTA_CHKD | XFS_UQUOTA_CHKD);
+	mp->m_qflags &= ~XFS_ALL_QUOTA_CHKD;
 	mp->m_qflags |= flags;
 
  error_return:
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index a595f29..16486c3 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -176,6 +176,8 @@ typedef struct xfs_qoff_logformat {
 #define XFS_UQUOTA_ACTIVE	0x0100  /* uquotas are being turned off */
 #define XFS_PQUOTA_ACTIVE	0x0200  /* pquotas are being turned off */
 #define XFS_GQUOTA_ACTIVE	0x0400  /* gquotas are being turned off */
+#define XFS_ALL_QUOTA_ACTIVE	\
+		(XFS_UQUOTA_ACTIVE | XFS_PQUOTA_ACTIVE | XFS_GQUOTA_ACTIVE)
 
 /*
  * Checking XFS_IS_*QUOTA_ON() while holding any inode lock guarantees
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 3eca58f..5e4364a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -325,10 +325,9 @@ xfs_parseargs(
 		} else if (!strcmp(this_char, MNTOPT_FILESTREAM)) {
 			mp->m_flags |= XFS_MOUNT_FILESTREAMS;
 		} else if (!strcmp(this_char, MNTOPT_NOQUOTA)) {
-			mp->m_qflags &= ~(XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
-					  XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
-					  XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
-					  XFS_UQUOTA_ENFD | XFS_OQUOTA_ENFD);
+			mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
+			mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
+			mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
 		} else if (!strcmp(this_char, MNTOPT_QUOTA) ||
 			   !strcmp(this_char, MNTOPT_UQUOTA) ||
 			   !strcmp(this_char, MNTOPT_USRQUOTA)) {
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
