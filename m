Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C84C433E9
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E11422EBE
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbhAWSxr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:53:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:35498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726324AbhAWSx2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:53:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61C6023159;
        Sat, 23 Jan 2021 18:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611427962;
        bh=wb/gijJacXZUBU83NHvEtkoWx4yWCoaWNsn84sDOmGA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ttoi15NUY8Ak2Nq11O9O+rX5fQ48u44q3J8Na8FbN1PTSEOrgFPR3hegYU/VQ0Uh5
         SzLw+5AroFUdGTE7+9C7jr5W36NE3wWhRBfP7tSdJs8sNu1qyPDlrwAIbDEj80SK0M
         3N6Slej+S7b5PeNJxaSvwH2qd3eSLJyi97GmAf9/Cx0AVhC9C7YljsTSnAH3eH+UW4
         UV2oKZETIqU1z78mqWisehsIY8N9X2zbZLjq7FbFgJ0Cirw6qXzifBeFlQzzsaTA8Z
         skVI6TEXdIdRmkPy8LueNVxX7LaXUyh/MobM4a1Ri23rApJe+9qkZDrOMfHXe657Bo
         3Cl48phtR4ZWA==
Subject: [PATCH 08/11] xfs: flush eof/cowblocks if we can't reserve quota for
 chown
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:52:44 -0800
Message-ID: <161142796398.2171939.8342732885181707528.stgit@magnolia>
In-Reply-To: <161142791950.2171939.3320927557987463636.stgit@magnolia>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If a file user, group, or project change is unable to reserve enough
quota to handle the modification, try clearing whatever space the
filesystem might have been hanging onto in the hopes of speeding up the
filesystem.  The flushing behavior will become particularly important
when we add deferred inode inactivation because that will increase the
amount of space that isn't actively tied to user data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c |   12 ++++++++++--
 fs/xfs/xfs_iops.c  |   13 ++++++++++---
 fs/xfs/xfs_qm.c    |   34 ++++++++++++++++++++++++++--------
 fs/xfs/xfs_quota.h |    8 ++++----
 4 files changed, 50 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3fbd98f61ea5..952eca338807 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1436,6 +1436,7 @@ xfs_ioctl_setattr(
 	struct xfs_trans	*tp;
 	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_dquot	*olddquot = NULL;
+	bool			quota_retry = false;
 	int			code;
 
 	trace_xfs_ioctl_setattr(ip);
@@ -1462,6 +1463,7 @@ xfs_ioctl_setattr(
 
 	xfs_ioctl_setattr_prepare_dax(ip, fa);
 
+retry:
 	tp = xfs_ioctl_setattr_get_trans(ip);
 	if (IS_ERR(tp)) {
 		code = PTR_ERR(tp);
@@ -1470,10 +1472,16 @@ xfs_ioctl_setattr(
 
 	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
 	    ip->i_d.di_projid != fa->fsx_projid) {
-		code = xfs_qm_vop_chown_reserve(tp, ip, NULL, NULL, pdqp,
-				capable(CAP_FOWNER) ?  XFS_QMOPT_FORCE_RES : 0);
+		unsigned int	flags = 0;
+
+		if (capable(CAP_FOWNER))
+			flags |= XFS_QMOPT_FORCE_RES;
+		code = xfs_qm_vop_chown_reserve(&tp, ip, NULL, NULL, pdqp,
+				flags, &quota_retry);
 		if (code)	/* out of quota */
 			goto error_trans_cancel;
+		if (quota_retry)
+			goto retry;
 	}
 
 	xfs_fill_fsxattr(ip, false, &old_fa);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f1e21b6cfa48..d43c2b008be8 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -660,6 +660,7 @@ xfs_setattr_nonsize(
 	kgid_t			gid = GLOBAL_ROOT_GID, igid = GLOBAL_ROOT_GID;
 	struct xfs_dquot	*udqp = NULL, *gdqp = NULL;
 	struct xfs_dquot	*olddquot1 = NULL, *olddquot2 = NULL;
+	bool			quota_retry = false;
 
 	ASSERT((mask & ATTR_SIZE) == 0);
 
@@ -700,6 +701,7 @@ xfs_setattr_nonsize(
 			return error;
 	}
 
+retry:
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
 	if (error)
 		goto out_dqrele;
@@ -729,12 +731,17 @@ xfs_setattr_nonsize(
 		if (XFS_IS_QUOTA_RUNNING(mp) &&
 		    ((XFS_IS_UQUOTA_ON(mp) && !uid_eq(iuid, uid)) ||
 		     (XFS_IS_GQUOTA_ON(mp) && !gid_eq(igid, gid)))) {
+			unsigned int	flags = 0;
+
+			if (capable(CAP_FOWNER))
+				flags |= XFS_QMOPT_FORCE_RES;
 			ASSERT(tp);
-			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
-						NULL, capable(CAP_FOWNER) ?
-						XFS_QMOPT_FORCE_RES : 0);
+			error = xfs_qm_vop_chown_reserve(&tp, ip, udqp, gdqp,
+					NULL, flags, &quota_retry);
 			if (error)	/* out of quota */
 				goto out_cancel;
+			if (quota_retry)
+				goto retry;
 		}
 
 		/*
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index c134eb4aeaa8..3b481f69a913 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1795,24 +1795,26 @@ xfs_qm_vop_chown(
 }
 
 /*
- * Quota reservations for setattr(AT_UID|AT_GID|AT_PROJID).
+ * Quota reservations for setattr(AT_UID|AT_GID|AT_PROJID).  This function has
+ * the same return behavior as xfs_trans_reserve_quota_nblks.
  */
 int
 xfs_qm_vop_chown_reserve(
-	struct xfs_trans	*tp,
+	struct xfs_trans	**tpp,
 	struct xfs_inode	*ip,
 	struct xfs_dquot	*udqp,
 	struct xfs_dquot	*gdqp,
 	struct xfs_dquot	*pdqp,
-	uint			flags)
+	unsigned int		flags,
+	bool			*retry)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	uint64_t		delblks;
 	unsigned int		blkflags;
-	struct xfs_dquot	*udq_unres = NULL;
+	struct xfs_dquot	*udq_unres = NULL; /* old dquots */
 	struct xfs_dquot	*gdq_unres = NULL;
 	struct xfs_dquot	*pdq_unres = NULL;
-	struct xfs_dquot	*udq_delblks = NULL;
+	struct xfs_dquot	*udq_delblks = NULL; /* new dquots */
 	struct xfs_dquot	*gdq_delblks = NULL;
 	struct xfs_dquot	*pdq_delblks = NULL;
 	int			error;
@@ -1856,11 +1858,11 @@ xfs_qm_vop_chown_reserve(
 		}
 	}
 
-	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
+	error = xfs_trans_reserve_quota_bydquots(*tpp, ip->i_mount,
 				udq_delblks, gdq_delblks, pdq_delblks,
 				ip->i_d.di_nblocks, 1, flags | blkflags);
 	if (error)
-		return error;
+		goto err;
 
 	/*
 	 * Do the delayed blks reservations/unreservations now. Since, these
@@ -1878,12 +1880,28 @@ xfs_qm_vop_chown_reserve(
 			    udq_delblks, gdq_delblks, pdq_delblks,
 			    (xfs_qcnt_t)delblks, 0, flags | blkflags);
 		if (error)
-			return error;
+			goto err;
 		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
 				udq_unres, gdq_unres, pdq_unres,
 				-((xfs_qcnt_t)delblks), 0, blkflags);
 	}
 
+	return 0;
+err:
+	/* We only allow one retry for EDQUOT/ENOSPC. */
+	if (*retry || (error != -EDQUOT && error != -ENOSPC)) {
+		*retry = false;
+		return error;
+	}
+
+	/* Release resources, prepare for scan. */
+	xfs_trans_cancel(*tpp);
+	*tpp = NULL;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	/* Try to free some quota in the new dquots. */
+	*retry = true;
+	xfs_blockgc_free_dquots(udq_delblks, gdq_delblks, pdq_delblks, 0);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index c4d02252e36f..ce65f6ac57a9 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -100,9 +100,9 @@ extern void xfs_qm_vop_create_dqattach(struct xfs_trans *, struct xfs_inode *,
 extern int xfs_qm_vop_rename_dqattach(struct xfs_inode **);
 extern struct xfs_dquot *xfs_qm_vop_chown(struct xfs_trans *,
 		struct xfs_inode *, struct xfs_dquot **, struct xfs_dquot *);
-extern int xfs_qm_vop_chown_reserve(struct xfs_trans *, struct xfs_inode *,
-		struct xfs_dquot *, struct xfs_dquot *,
-		struct xfs_dquot *, uint);
+int xfs_qm_vop_chown_reserve(struct xfs_trans **tpp, struct xfs_inode *ip,
+		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
+		struct xfs_dquot *pdqp, unsigned int flags, bool *retry);
 extern int xfs_qm_dqattach(struct xfs_inode *);
 extern int xfs_qm_dqattach_locked(struct xfs_inode *ip, bool doalloc);
 extern void xfs_qm_dqdetach(struct xfs_inode *);
@@ -169,7 +169,7 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans **tpp, struct xfs_inode *dp,
 #define xfs_qm_vop_create_dqattach(tp, ip, u, g, p)
 #define xfs_qm_vop_rename_dqattach(it)					(0)
 #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
-#define xfs_qm_vop_chown_reserve(tp, ip, u, g, p, fl)			(0)
+#define xfs_qm_vop_chown_reserve(tpp, ip, u, g, p, fl, retry)		(0)
 #define xfs_qm_dqattach(ip)						(0)
 #define xfs_qm_dqattach_locked(ip, fl)					(0)
 #define xfs_qm_dqdetach(ip)

