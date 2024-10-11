Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB40CA6F
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609204; cv=none; b=aTdiZHo/qerJssO1367ad7YGqr0z8Az1gwbm0ECkfGt35BD+QMOzRaSye1GfasX7Jj/hXojo4LAqe3ksGnn/6B61/G1LamuIpy9zenAQMkUY9dlZkgIl5BzLJgW3Qo5UzQpD8HL26JHWqrPYjLz3PFl2ic+NRqteogpSUlhMWUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609204; c=relaxed/simple;
	bh=co0P9R4lkxwj+xoMlgDmQiLZODRBolImYhOodf7PDco=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NqkPv8J0o/ZHumuTqhX90/rSGZTz7l8JF/QPQE7Z5CjMVLvM0cEcbJfGK+oK+RCTpg2460Likuyk5bku9ktATn4JA+bIB/v9T1DU1zpgRm9HXvDxiXSD6J6zlf6WdvRqxNPGBz0EB3jmIJr9y+oDZeSyB9Ncv+n1u8Kh/SVwMyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pLCBNjQB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pLCBNjQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FA1C4CEC5;
	Fri, 11 Oct 2024 01:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609203;
	bh=co0P9R4lkxwj+xoMlgDmQiLZODRBolImYhOodf7PDco=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pLCBNjQBxqEteLO/Autbdvf21eSYtzPjCN7Rt/eeZU9F/yvOCkVx0UhFpESD3NGvk
	 zDGX1xjD71+NdCiSeZrkEnh0LQiaz0ACyOTLVepaeq3kpT6kTflhfVRczaIiVdQBO1
	 4+NuIAYQiyveb9pBiu9bv94ydBRoKhFshBTijuuNXbiO7ErkUmUk9VDvhykmuN/zw7
	 APDOcvx9nkbHAohLxAZIZIWN0noaxLFmLYUg7/sNG/S058ve/SL7oA57ClrtxrHUFP
	 vJDnVD5d01CQ+MhN4gnPJW+22q3nMgcshJLqd8L5ax3cBB/ZXJTCnIyOM4RstrVoP5
	 0RgIUdxTiZBpQ==
Date: Thu, 10 Oct 2024 18:13:23 -0700
Subject: [PATCH 5/6] xfs: reserve quota for realtime files correctly
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860645763.4180109.14022183245293865679.stgit@frogsfrogsfrogs>
In-Reply-To: <172860645659.4180109.14821543026500028245.stgit@frogsfrogsfrogs>
References: <172860645659.4180109.14821543026500028245.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fix xfs_quota_reserve_blkres to reserve rt block quota whenever we're
dealing with a realtime file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_quota.h       |   12 ++++++------
 fs/xfs/xfs_trans_dquot.c |   11 +++++++++++
 2 files changed, 17 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 2d36d967380e7c..fa1317cc396c96 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -130,6 +130,7 @@ extern void xfs_qm_mount_quotas(struct xfs_mount *);
 extern void xfs_qm_unmount(struct xfs_mount *);
 extern void xfs_qm_unmount_quotas(struct xfs_mount *);
 bool xfs_inode_near_dquot_enforcement(struct xfs_inode *ip, xfs_dqtype_t type);
+int xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks);
 
 # ifdef CONFIG_XFS_LIVE_HOOKS
 void xfs_trans_mod_ino_dquot(struct xfs_trans *tp, struct xfs_inode *ip,
@@ -209,6 +210,11 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
 #define xfs_qm_unmount_quotas(mp)
 #define xfs_inode_near_dquot_enforcement(ip, type)			(false)
 
+static inline int xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
+{
+	return 0;
+}
+
 # ifdef CONFIG_XFS_LIVE_HOOKS
 #  define xfs_dqtrx_hook_enable()		((void)0)
 #  define xfs_dqtrx_hook_disable()		((void)0)
@@ -216,12 +222,6 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
 
 #endif /* CONFIG_XFS_QUOTA */
 
-static inline int
-xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
-{
-	return xfs_trans_reserve_quota_nblks(NULL, ip, blocks, 0, false);
-}
-
 static inline void
 xfs_quota_unreserve_blkres(struct xfs_inode *ip, uint64_t blocks)
 {
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index ca7df018290e0e..481ba3dc9f190d 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -1031,3 +1031,14 @@ xfs_trans_free_dqinfo(
 	kmem_cache_free(xfs_dqtrx_cache, tp->t_dqinfo);
 	tp->t_dqinfo = NULL;
 }
+
+int
+xfs_quota_reserve_blkres(
+	struct xfs_inode	*ip,
+	int64_t			blocks)
+{
+	if (XFS_IS_REALTIME_INODE(ip))
+		return xfs_trans_reserve_quota_nblks(NULL, ip, 0, blocks,
+				false);
+	return xfs_trans_reserve_quota_nblks(NULL, ip, blocks, 0, false);
+}

