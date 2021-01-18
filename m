Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 269ABC43332
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0281B23102
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387550AbhARWNV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 17:13:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:34174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387827AbhARWNS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 17:13:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2618522DD3;
        Mon, 18 Jan 2021 22:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611007957;
        bh=WBbQ96+9f8Y0bmzwG289ne5I7of4B/hi5gzMdzxPxCM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fhS6Q0G7Vd457sCz1I0ADg9G6cCkDKxH7XXo3z0J78xObCWepeJoEUMnkomuvVx51
         RtvAzGkWIfpkAdkyWZLIezEpvbGojaTpGdD/0TOD5bkcTcz0KVoduVaZZzXOO+jcrf
         X3lucr1rhwaj9iqvgJ6+IgxR+eAJ/x0ckMjgh8kSavBEGH+xqdR88oUpJx1bwuSMSC
         TityE3GUZ3PJDgD+UhSdU9rFlN255gm4MHRpMgjqfU0LKqmIVejkg4xvrVrKwSZCi0
         ymw5dHYG6dsgu87pl423QOmoiVM/AdSARExtPoXlg9y3gqu/BgCDTB61375wB8YKP7
         RM0OR4hbrv02A==
Subject: [PATCH 07/11] xfs: flush eof/cowblocks if we can't reserve quota for
 inode creation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 18 Jan 2021 14:12:36 -0800
Message-ID: <161100795681.88816.5998499443198628059.stgit@magnolia>
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

If an inode creation is unable to reserve enough quota to handle the
modification, try clearing whatever space the filesystem might have been
hanging onto in the hopes of speeding up the filesystem.  The flushing
behavior will become particularly important when we add deferred inode
inactivation because that will increase the amount of space that isn't
actively tied to user data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c      |   79 +++++++++++++++++++++++++++++-----------------
 fs/xfs/xfs_icache.h      |    3 ++
 fs/xfs/xfs_inode.c       |   22 +++++++++----
 fs/xfs/xfs_quota.h       |   13 ++++----
 fs/xfs/xfs_symlink.c     |   12 +++++--
 fs/xfs/xfs_trans_dquot.c |   44 +++++++++++++++++++++++---
 6 files changed, 123 insertions(+), 50 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 1e0ffc0fb73c..9ba1ad69abb7 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1646,65 +1646,84 @@ xfs_start_block_reaping(
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
 	unsigned int		eof_flags,
 	bool			*found_work)
 {
 	struct xfs_eofblocks	eofb = {0};
-	struct xfs_dquot	*dq;
+	struct xfs_mount	*mp = NULL;
 	int			error;
 
 	*found_work = false;
 
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
-			*found_work = true;
-		}
+	if (XFS_IS_UQUOTA_ENFORCED(mp) && udqp && xfs_dquot_lowsp(udqp)) {
+		eofb.eof_uid = make_kuid(mp->m_super->s_user_ns, udqp->q_id);
+		eofb.eof_flags |= XFS_EOF_FLAGS_UID;
+		*found_work = true;
 	}
 
-	if (XFS_IS_GQUOTA_ENFORCED(ip->i_mount)) {
-		dq = xfs_inode_dquot(ip, XFS_DQTYPE_GROUP);
-		if (dq && xfs_dquot_lowsp(dq)) {
-			eofb.eof_gid = VFS_I(ip)->i_gid;
-			eofb.eof_flags |= XFS_EOF_FLAGS_GID;
-			*found_work = true;
-		}
+	if (XFS_IS_UQUOTA_ENFORCED(mp) && gdqp && xfs_dquot_lowsp(gdqp)) {
+		eofb.eof_gid = make_kgid(mp->m_super->s_user_ns, gdqp->q_id);
+		eofb.eof_flags |= XFS_EOF_FLAGS_GID;
+		*found_work = true;
 	}
 
-	if (XFS_IS_PQUOTA_ENFORCED(ip->i_mount)) {
-		dq = xfs_inode_dquot(ip, XFS_DQTYPE_PROJ);
-		if (dq && xfs_dquot_lowsp(dq)) {
-			eofb.eof_prid = ip->i_d.di_projid;
-			eofb.eof_flags |= XFS_EOF_FLAGS_PRID;
-			*found_work = true;
-		}
+	if (XFS_IS_PQUOTA_ENFORCED(mp) && pdqp && xfs_dquot_lowsp(pdqp)) {
+		eofb.eof_prid = pdqp->q_id;
+		eofb.eof_flags |= XFS_EOF_FLAGS_PRID;
+		*found_work = true;
 	}
 
 	if (*found_work) {
-		error = xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+		error = xfs_icache_free_eofblocks(mp, &eofb);
 		if (error)
 			return error;
 
-		error = xfs_icache_free_cowblocks(ip->i_mount, &eofb);
+		error = xfs_icache_free_cowblocks(mp, &eofb);
 		if (error)
 			return error;
 	}
 
 	return 0;
 }
+/*
+ * Run cow/eofblocks scans on the quotas applicable to the inode. For inodes
+ * with multiple quotas, we don't know exactly which quota caused an allocation
+ * failure. We make a best effort by including each quota under low free space
+ * conditions (less than 1% free space) in the scan.
+ */
+int
+xfs_blockgc_free_quota(
+	struct xfs_inode	*ip,
+	unsigned int		eof_flags,
+	bool			*found_work)
+{
+	return xfs_blockgc_free_dquots(xfs_inode_dquot(ip, XFS_DQTYPE_USER),
+			xfs_inode_dquot(ip, XFS_DQTYPE_GROUP),
+			xfs_inode_dquot(ip, XFS_DQTYPE_PROJ), eof_flags,
+			found_work);
+}
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index f7b6ead6fc08..8d8e7cabc27f 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -54,6 +54,9 @@ long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 
+int xfs_blockgc_free_dquots(struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
+		struct xfs_dquot *pdqp, unsigned int eof_flags,
+		bool *found_work);
 int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int eof_flags,
 		bool *found_work);
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 43cff78c20c4..596b6d10d2bc 100644
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
-		goto out_trans_cancel;
+		goto out_release_dquots;
+	if (quota_retry)
+		goto retry;
 
 	/*
 	 * A newly created regular or special file just has one directory
@@ -1117,6 +1121,7 @@ xfs_create(
 		xfs_irele(ip);
 	}
 
+out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
 	xfs_qm_dqrele(pdqp);
@@ -1141,6 +1146,7 @@ xfs_create_tmpfile(
 	struct xfs_dquot	*gdqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_trans_res	*tres;
+	bool			quota_retry = false;
 	uint			resblks;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
@@ -1160,14 +1166,17 @@ xfs_create_tmpfile(
 	resblks = XFS_IALLOC_SPACE_RES(mp);
 	tres = &M_RES(mp)->tr_create_tmpfile;
 
+retry:
 	error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
 	if (error)
 		goto out_release_inode;
 
-	error = xfs_trans_reserve_quota_icreate(tp, dp, udqp, gdqp, pdqp,
-			resblks);
+	error = xfs_trans_reserve_quota_icreate(&tp, dp, NULL, udqp, gdqp, pdqp,
+			resblks, &quota_retry);
 	if (error)
-		goto out_trans_cancel;
+		goto out_release_dquots;
+	if (quota_retry)
+		goto retry;
 
 	error = xfs_dir_ialloc(&tp, dp, mode, 0, 0, prid, &ip);
 	if (error)
@@ -1211,6 +1220,7 @@ xfs_create_tmpfile(
 		xfs_irele(ip);
 	}
 
+out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
 	xfs_qm_dqrele(pdqp);
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 996046eb1492..ec09b38a9687 100644
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
@@ -147,9 +148,9 @@ static inline int xfs_quota_reserve_blkres(struct xfs_inode *ip,
 	return 0;
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
index e53f7bc2b820..535585a821d0 100644
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
-		goto out_trans_cancel;
+		goto out_release_dquots;
+	if (quota_retry)
+		goto retry;
 
 	/*
 	 * Allocate an inode for the symlink.
@@ -342,7 +346,7 @@ xfs_symlink(
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
-
+out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
 	xfs_qm_dqrele(pdqp);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index c6abe1f1106c..7fc5aa69c1c5 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -846,25 +846,61 @@ xfs_trans_reserve_quota_nblks(
 	return *retry ? 0 : error;
 }
 
-/* Change the quota reservations for an inode creation activity. */
+/*
+ * Change the quota reservations for an inode creation activity.  This function
+ * has the same return behavior as xfs_trans_reserve_quota_nblks but with the
+ * added twist that we update *dp_locked so that the caller can track the ILOCK
+ * state of the parent directory.
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
+	int			error, err2;
 
 	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
 		return 0;
 
 	ASSERT(!xfs_is_quota_inode(&mp->m_sb, dp->i_ino));
 
-	return xfs_trans_reserve_quota_bydquots(tp, dp->i_mount, udqp, gdqp,
+	error = xfs_trans_reserve_quota_bydquots(*tpp, dp->i_mount, udqp, gdqp,
 			pdqp, nblks, 1, XFS_QMOPT_RES_REGBLKS);
+
+	/* Exit immediately if the caller did not want retries. */
+	if (retry == NULL)
+		return error;
+
+	/*
+	 * If the caller /can/ handle retries, we always cancel the transaction
+	 * on error, even if we aren't going to attempt a gc scan.
+	 */
+	if (error) {
+		xfs_trans_cancel(*tpp);
+		*tpp = NULL;
+		if (dp_locked && *dp_locked) {
+			xfs_iunlock(dp, XFS_ILOCK_EXCL);
+			*dp_locked = false;
+		}
+	}
+	/* We only allow one retry for EDQUOT/ENOSPC. */
+	if (*retry || (error != -EDQUOT && error != -ENOSPC)) {
+		*retry = false;
+		return error;
+	}
+
+	/* Try to free some quota for the new file's dquots. */
+	err2 = xfs_blockgc_free_dquots(udqp, gdqp, pdqp, 0, retry);
+	if (err2)
+		return err2;
+	return *retry ? 0 : error;
 }
 
 /*

