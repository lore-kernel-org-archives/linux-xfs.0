Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FD6FC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79B0922CB1
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387899AbhARWNZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 17:13:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:34198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbhARWNX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 17:13:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8AE822DFB;
        Mon, 18 Jan 2021 22:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611007962;
        bh=F3vmksUxWhQCJ1czwm3FdsYNA7Mq1zc0uQp8Z3lKxbw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MCxr0SqTsoxc8GuBIVJoygDdM+EWvVttGB/85nLE2BYo3DQEDamM8Fdugc7ImpKpX
         DKIP65KQjmuqotF/4BtzS/UXMGfGssaaK0+GyKxTE/zqq2d/ssY14Oi8RhJIlF6ZPR
         ddLnI+hTg7ei1sRv8W9L/l8zY9ZaTHtH0o7grLt8iMEI2Qugm64z3HGhwFkfWABnJf
         FymWSgnar5T73v33qu4IvM5gm118NHQiGFw9fIxLtfidmnKkcLXqf3UNnOQxFfPGz/
         19dgvpqevve8v8c6hdORseYwEPWvScmkxcSW+IrrT+PftC+PbweaeOjPGxHohA0bFj
         GeIWvOCPY6jmA==
Subject: [PATCH 08/11] xfs: flush eof/cowblocks if we can't reserve quota for
 chown
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 18 Jan 2021 14:12:42 -0800
Message-ID: <161100796237.88816.11226881762830433992.stgit@magnolia>
In-Reply-To: <161100791789.88816.10902093186807310995.stgit@magnolia>
References: <161100791789.88816.10902093186807310995.stgit@magnolia>
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
 fs/xfs/xfs_ioctl.c |   16 ++++++++++++----
 fs/xfs/xfs_iops.c  |   20 ++++++++++++--------
 fs/xfs/xfs_qm.c    |   36 +++++++++++++++++++++++++++---------
 fs/xfs/xfs_quota.h |    8 ++++----
 4 files changed, 55 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3fbd98f61ea5..70d9637b7806 100644
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
-		if (code)	/* out of quota */
-			goto error_trans_cancel;
+		unsigned int	flags = 0;
+
+		if (capable(CAP_FOWNER))
+			flags |= XFS_QMOPT_FORCE_RES;
+		code = xfs_qm_vop_chown_reserve(&tp, ip, NULL, NULL, pdqp,
+				flags, &quota_retry);
+		if (code)
+			goto error_free_dquots;
+		if (quota_retry)
+			goto retry;
 	}
 
 	xfs_fill_fsxattr(ip, false, &old_fa);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 67c8dc9de8aa..3cc6c4aa01c3 100644
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
-			if (error)	/* out of quota */
-				goto out_cancel;
+			error = xfs_qm_vop_chown_reserve(&tp, ip, udqp, gdqp,
+					NULL, flags, &quota_retry);
+			if (error)
+				goto out_dqrele;
+			if (quota_retry)
+				goto retry;
 		}
 
 		/*
@@ -814,9 +821,6 @@ xfs_setattr_nonsize(
 
 	return 0;
 
-out_cancel:
-	xfs_trans_cancel(tp);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 out_dqrele:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index c134eb4aeaa8..4c095526aaed 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1795,27 +1795,29 @@ xfs_qm_vop_chown(
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
-	int			error;
+	int			error, err2;
 
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
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
@@ -1878,13 +1880,29 @@ xfs_qm_vop_chown_reserve(
 			    udq_delblks, gdq_delblks, pdq_delblks,
 			    (xfs_qcnt_t)delblks, 0, flags | blkflags);
 		if (error)
-			return error;
+			goto err;
 		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
 				udq_unres, gdq_unres, pdq_unres,
 				-((xfs_qcnt_t)delblks), 0, blkflags);
 	}
 
 	return 0;
+err:
+	xfs_trans_cancel(*tpp);
+	*tpp = NULL;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	/* We only allow one retry for EDQUOT/ENOSPC. */
+	if (*retry || (error != -EDQUOT && error != -ENOSPC)) {
+		*retry = false;
+		return error;
+	}
+
+	/* Try to free some quota in the new dquots. */
+	err2 = xfs_blockgc_free_dquots(udq_delblks, gdq_delblks, pdq_delblks,
+			0, retry);
+	if (err2)
+		return err2;
+	return *retry ? 0 : error;
 }
 
 int
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index ec09b38a9687..2ec57a65b1db 100644
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
@@ -157,7 +157,7 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans **tpp, struct xfs_inode *dp,
 #define xfs_qm_vop_create_dqattach(tp, ip, u, g, p)
 #define xfs_qm_vop_rename_dqattach(it)					(0)
 #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
-#define xfs_qm_vop_chown_reserve(tp, ip, u, g, p, fl)			(0)
+#define xfs_qm_vop_chown_reserve(tpp, ip, u, g, p, fl, retry)		(0)
 #define xfs_qm_dqattach(ip)						(0)
 #define xfs_qm_dqattach_locked(ip, fl)					(0)
 #define xfs_qm_dqdetach(ip)

