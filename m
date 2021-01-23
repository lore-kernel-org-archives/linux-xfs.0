Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 240ABC433E6
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:53:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1DD022D57
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbhAWSxp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:53:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:35496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbhAWSx2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:53:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC91622D50;
        Sat, 23 Jan 2021 18:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611427956;
        bh=r6bXUGmLicXUaNpeuRMboTO+HJyN2ZgQ6qaAcoX50Wo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DeXwPyyEXmNHpxsCaOmeAnIZcJiuvwhDKi+P59dlfmyZDswpme2Jc/ElSPzjgdDoM
         6FOBeYSaVlrIOBjXXEsj5rVBrxAivGwB1qqoSyDuhvMYcvCJnwKkczfWTEOlKo2N+G
         8xx4/XirV+WxNAyMqGWCnA5QCRiPLE2wk4ukDWA15Eb+IEfSI8JbNmWtf24USDKSKh
         zh0O05lJtYzkIp8axuXQtWttD6Hps6BA8m6Fnr7zoEYXopaxxaZXnsbWY8yb+YheDE
         98xCBCSiNEuzNQmBmVI/BAG5bJx5RPKNWDQuJBJ0oCPZ2HsEGnBF4FJ1yX7+pglk8B
         Fy3yqJGUiD++g==
Subject: [PATCH 07/11] xfs: flush eof/cowblocks if we can't reserve quota for
 inode creation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:52:38 -0800
Message-ID: <161142795846.2171939.1839413303968531400.stgit@magnolia>
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

If an inode creation is unable to reserve enough quota to handle the
modification, try clearing whatever space the filesystem might have been
hanging onto in the hopes of speeding up the filesystem.  The flushing
behavior will become particularly important when we add deferred inode
inactivation because that will increase the amount of space that isn't
actively tied to user data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c      |   78 ++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_icache.h      |    2 +
 fs/xfs/xfs_inode.c       |   17 ++++++++--
 fs/xfs/xfs_quota.h       |   13 ++++----
 fs/xfs/xfs_symlink.c     |    8 ++++-
 fs/xfs/xfs_trans_dquot.c |   52 ++++++++++++++++++++++++++++---
 6 files changed, 124 insertions(+), 46 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 68b6f72593dc..7f999f9dd80a 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1646,60 +1646,78 @@ xfs_start_block_reaping(
 }
 
 /*
- * Run cow/eofblocks scans on the quotas applicable to the inode. For inodes
- * with multiple quotas, we don't know exactly which quota caused an allocation
- * failure. We make a best effort by including each quota under low free space
- * conditions (less than 1% free space) in the scan.
+ * Run cow/eofblocks scans on the supplied dquots.  We don't know exactly which
+ * quota caused an allocation failure, so we make a best effort by including
+ * each quota under low free space conditions (less than 1% free space) in the
+ * scan.
  */
 int
-xfs_blockgc_free_quota(
-	struct xfs_inode	*ip,
+xfs_blockgc_free_dquots(
+	struct xfs_dquot	*udqp,
+	struct xfs_dquot	*gdqp,
+	struct xfs_dquot	*pdqp,
 	unsigned int		eof_flags)
 {
 	struct xfs_eofblocks	eofb = {0};
-	struct xfs_dquot	*dq;
+	struct xfs_mount	*mp = NULL;
 	bool			do_work = false;
 	int			error;
 
+	if (!udqp && !gdqp && !pdqp)
+		return 0;
+	if (udqp)
+		mp = udqp->q_mount;
+	if (!mp && gdqp)
+		mp = gdqp->q_mount;
+	if (!mp && pdqp)
+		mp = pdqp->q_mount;
+
 	/*
 	 * Run a scan to increase effectiveness and use the union filter to
 	 * cover all applicable quotas in a single scan.
 	 */
 	eofb.eof_flags = XFS_EOF_FLAGS_UNION | eof_flags;
 
-	if (XFS_IS_UQUOTA_ENFORCED(ip->i_mount)) {
-		dq = xfs_inode_dquot(ip, XFS_DQTYPE_USER);
-		if (dq && xfs_dquot_lowsp(dq)) {
-			eofb.eof_uid = VFS_I(ip)->i_uid;
-			eofb.eof_flags |= XFS_EOF_FLAGS_UID;
-			do_work = true;
-		}
+	if (XFS_IS_UQUOTA_ENFORCED(mp) && udqp && xfs_dquot_lowsp(udqp)) {
+		eofb.eof_uid = make_kuid(mp->m_super->s_user_ns, udqp->q_id);
+		eofb.eof_flags |= XFS_EOF_FLAGS_UID;
+		do_work = true;
 	}
 
-	if (XFS_IS_GQUOTA_ENFORCED(ip->i_mount)) {
-		dq = xfs_inode_dquot(ip, XFS_DQTYPE_GROUP);
-		if (dq && xfs_dquot_lowsp(dq)) {
-			eofb.eof_gid = VFS_I(ip)->i_gid;
-			eofb.eof_flags |= XFS_EOF_FLAGS_GID;
-			do_work = true;
-		}
+	if (XFS_IS_UQUOTA_ENFORCED(mp) && gdqp && xfs_dquot_lowsp(gdqp)) {
+		eofb.eof_gid = make_kgid(mp->m_super->s_user_ns, gdqp->q_id);
+		eofb.eof_flags |= XFS_EOF_FLAGS_GID;
+		do_work = true;
 	}
 
-	if (XFS_IS_PQUOTA_ENFORCED(ip->i_mount)) {
-		dq = xfs_inode_dquot(ip, XFS_DQTYPE_PROJ);
-		if (dq && xfs_dquot_lowsp(dq)) {
-			eofb.eof_prid = ip->i_d.di_projid;
-			eofb.eof_flags |= XFS_EOF_FLAGS_PRID;
-			do_work = true;
-		}
+	if (XFS_IS_PQUOTA_ENFORCED(mp) && pdqp && xfs_dquot_lowsp(pdqp)) {
+		eofb.eof_prid = pdqp->q_id;
+		eofb.eof_flags |= XFS_EOF_FLAGS_PRID;
+		do_work = true;
 	}
 
 	if (!do_work)
 		return 0;
 
-	error = xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+	error = xfs_icache_free_eofblocks(mp, &eofb);
 	if (error)
 		return error;
 
-	return xfs_icache_free_cowblocks(ip->i_mount, &eofb);
+	return xfs_icache_free_cowblocks(mp, &eofb);
+}
+
+/*
+ * Run cow/eofblocks scans on the quotas applicable to the inode. For inodes
+ * with multiple quotas, we don't know exactly which quota caused an allocation
+ * failure. We make a best effort by including each quota under low free space
+ * conditions (less than 1% free space) in the scan.
+ */
+int
+xfs_blockgc_free_quota(
+	struct xfs_inode	*ip,
+	unsigned int		eof_flags)
+{
+	return xfs_blockgc_free_dquots(xfs_inode_dquot(ip, XFS_DQTYPE_USER),
+			xfs_inode_dquot(ip, XFS_DQTYPE_GROUP),
+			xfs_inode_dquot(ip, XFS_DQTYPE_PROJ), eof_flags);
 }
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index d64ea8f5c589..5f520de637f6 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -54,6 +54,8 @@ long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 
+int xfs_blockgc_free_dquots(struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
+		struct xfs_dquot *pdqp, unsigned int eof_flags);
 int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int eof_flags);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e909da05cd28..a3072c3f5028 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -990,6 +990,7 @@ xfs_create(
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_trans_res	*tres;
+	bool			quota_retry = false;
 	uint			resblks;
 
 	trace_xfs_create(dp, name);
@@ -1022,6 +1023,7 @@ xfs_create(
 	 * the case we'll drop the one we have and get a more
 	 * appropriate transaction later.
 	 */
+retry:
 	error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
 	if (error == -ENOSPC) {
 		/* flush outstanding delalloc blocks and retry */
@@ -1037,10 +1039,12 @@ xfs_create(
 	/*
 	 * Reserve disk quota and the inode.
 	 */
-	error = xfs_trans_reserve_quota_icreate(tp, dp, udqp, gdqp, pdqp,
-			resblks);
+	error = xfs_trans_reserve_quota_icreate(&tp, dp, &unlock_dp_on_error,
+			udqp, gdqp, pdqp, resblks, &quota_retry);
 	if (error)
 		goto out_trans_cancel;
+	if (quota_retry)
+		goto retry;
 
 	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
 			XFS_IEXT_DIR_MANIP_CNT(mp));
@@ -1146,6 +1150,8 @@ xfs_create_tmpfile(
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_trans_res	*tres;
+	bool			locked = false;
+	bool			quota_retry = false;
 	uint			resblks;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
@@ -1165,14 +1171,17 @@ xfs_create_tmpfile(
 	resblks = XFS_IALLOC_SPACE_RES(mp);
 	tres = &M_RES(mp)->tr_create_tmpfile;
 
+retry:
 	error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
 	if (error)
 		goto out_release_inode;
 
-	error = xfs_trans_reserve_quota_icreate(tp, dp, udqp, gdqp, pdqp,
-			resblks);
+	error = xfs_trans_reserve_quota_icreate(&tp, dp, &locked, udqp, gdqp,
+			pdqp, resblks, &quota_retry);
 	if (error)
 		goto out_trans_cancel;
+	if (quota_retry)
+		goto retry;
 
 	error = xfs_dir_ialloc(&tp, dp, mode, 0, 0, prid, &ip);
 	if (error)
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 1c083b5267d9..c4d02252e36f 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -87,9 +87,10 @@ int xfs_trans_reserve_quota_nblks(struct xfs_trans **tpp, struct xfs_inode *ip,
 extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
 		struct xfs_mount *, struct xfs_dquot *,
 		struct xfs_dquot *, struct xfs_dquot *, int64_t, long, uint);
-int xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_inode *dp,
-		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
-		struct xfs_dquot *pdqp, int64_t nblks);
+int xfs_trans_reserve_quota_icreate(struct xfs_trans **tpp,
+		struct xfs_inode *dp, bool *dp_locked, struct xfs_dquot *udqp,
+		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp, int64_t nblks,
+		bool *retry);
 
 extern int xfs_qm_vop_dqalloc(struct xfs_inode *, kuid_t, kgid_t,
 		prid_t, uint, struct xfs_dquot **, struct xfs_dquot **,
@@ -158,9 +159,9 @@ xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t nblks, bool isrt)
 }
 
 static inline int
-xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_inode *dp,
-		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
-		struct xfs_dquot *pdqp, int64_t nblks)
+xfs_trans_reserve_quota_icreate(struct xfs_trans **tpp, struct xfs_inode *dp,
+		bool *dp_locked, struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
+		struct xfs_dquot *pdqp, int64_t nblks, bool *retry)
 {
 	return 0;
 }
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index f8bfa51bdeef..20c150ad699f 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -159,6 +159,7 @@ xfs_symlink(
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
+	bool			quota_retry = false;
 	uint			resblks;
 
 	*ipp = NULL;
@@ -197,6 +198,7 @@ xfs_symlink(
 		fs_blocks = xfs_symlink_blocks(mp, pathlen);
 	resblks = XFS_SYMLINK_SPACE_RES(mp, link_name->len, fs_blocks);
 
+retry:
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_symlink, resblks, 0, 0, &tp);
 	if (error)
 		goto out_release_inode;
@@ -215,10 +217,12 @@ xfs_symlink(
 	/*
 	 * Reserve disk quota : blocks and inode.
 	 */
-	error = xfs_trans_reserve_quota_icreate(tp, dp, udqp, gdqp, pdqp,
-			resblks);
+	error = xfs_trans_reserve_quota_icreate(&tp, dp, &unlock_dp_on_error,
+			udqp, gdqp, pdqp, resblks, &quota_retry);
 	if (error)
 		goto out_trans_cancel;
+	if (quota_retry)
+		goto retry;
 
 	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
 			XFS_IEXT_DIR_MANIP_CNT(mp));
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index adc7331ff182..340c066f8ef1 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -835,25 +835,69 @@ xfs_trans_reserve_quota_nblks(
 	return 0;
 }
 
-/* Change the quota reservations for an inode creation activity. */
+/*
+ * Change the quota reservations for an inode creation activity.  This doesn't
+ * change the actual usage, just the reservation.  The caller may hold
+ * ILOCK_EXCL on the inode.  If @retry is not a NULL pointer, the caller must
+ * ensure that *retry is set to false before the first time this function is
+ * called.
+ *
+ * If the quota reservation fails because we hit a quota limit (and retry is
+ * not a NULL pointer, and *retry is false), this function will try to invoke
+ * the speculative preallocation gc scanner to reduce quota usage.  In order to
+ * do that, we cancel the transaction, NULL out tpp, drop the ILOCK and update
+ * *dp_locked if dp_locked is not NULL, and set *retry to true.
+ *
+ * This function ends one of two ways:
+ *
+ *  1) To signal the caller to try again, *retry is set to true; *tpp is
+ *     cancelled and set to NULL; if *dp_locked is true, the inode is unlocked
+ *     and *dp_locked is set to false; and the return value is zero.
+ *
+ *  2) Otherwise, *tpp is still set; the inode is still locked; and the return
+ *     value is zero or the usual negative error code.
+ */
 int
 xfs_trans_reserve_quota_icreate(
-	struct xfs_trans	*tp,
+	struct xfs_trans	**tpp,
 	struct xfs_inode	*dp,
+	bool			*dp_locked,
 	struct xfs_dquot	*udqp,
 	struct xfs_dquot	*gdqp,
 	struct xfs_dquot	*pdqp,
-	int64_t			nblks)
+	int64_t			nblks,
+	bool			*retry)
 {
 	struct xfs_mount	*mp = dp->i_mount;
+	int			error;
 
 	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
 		return 0;
 
 	ASSERT(!xfs_is_quota_inode(&mp->m_sb, dp->i_ino));
 
-	return xfs_trans_reserve_quota_bydquots(tp, dp->i_mount, udqp, gdqp,
+	error = xfs_trans_reserve_quota_bydquots(*tpp, dp->i_mount, udqp, gdqp,
 			pdqp, nblks, 1, XFS_QMOPT_RES_REGBLKS);
+	if (retry == NULL)
+		return error;
+	/* We only allow one retry for EDQUOT/ENOSPC. */
+	if (*retry || (error != -EDQUOT && error != -ENOSPC)) {
+		*retry = false;
+		return error;
+	}
+
+	/* Release resources, prepare for scan. */
+	xfs_trans_cancel(*tpp);
+	*tpp = NULL;
+	if (*dp_locked) {
+		xfs_iunlock(dp, XFS_ILOCK_EXCL);
+		*dp_locked = false;
+	}
+
+	/* Try to free some quota for the supplied dquots. */
+	*retry = true;
+	xfs_blockgc_free_dquots(udqp, gdqp, pdqp, 0);
+	return 0;
 }
 
 /*

