Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E56A1E0DC3
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192288; cv=none; b=MBQG5lZ3L039yNanIsQEIjigxYeog1adk0HkGg0f0Z1KnDC2KNPEBRHhNakR68EC+8tvkxVsK/ZzqE+Qx+Y5Ua3XPnBIa0HJvdNj9JWU6jw8CTlSfNl8JKz8TiKo4q98kUCixjeU/Mr3OxR7PsOdRlv7QCswo3Qewt9kCkfdm68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192288; c=relaxed/simple;
	bh=0xtQPuYsFx6+EaDmrN6skq2nN6sSjNCg3Y9AEFd1TbE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wy+Xoy/CwjYAq7Z8YNVZW9rb4W0hkHFlqERMl20xfP8yXcFe2aUizbx5BFK9lXbVa9JZhQsvtS68EEaHjtjXSTKMuQZ+dWrSuPFHMaIMQ/NRo3Wht9uSqhFExLAjFCUHlsHeb1AfSfu086G3IsJO+/aXlUQvFwF1Y3ORhQ0SXBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IzQKtRky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IzQKtRky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EA3C4CECD;
	Thu, 17 Oct 2024 19:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729192288;
	bh=0xtQPuYsFx6+EaDmrN6skq2nN6sSjNCg3Y9AEFd1TbE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IzQKtRkyhb59kxYgg8/l1bti/M43OFRUwXnpPn2bsVQ0dFsCzjsdTb880/WytDO32
	 70XMLz5bNSKoUAywQ4a24mm+Y27BBolJHpQn4DUgNRYU7hKDk0VwhPUZQZDR6Ys2I1
	 +R9IyIOsLyQ9CD0FaN6VLD5JO6dfIKLDfvM8O69lJveJeE+7mAGoC8a/0dznRHjEak
	 BptzZNkRw6RAS2Z7DWofLqY21TeeoTj9yFGyLFZxEiKX70rO0YmXSxxumpZXC3ysT1
	 9S6BN1Bnyuy2PCyBYf7aoZ/KFvPeL6HakjlBmqjyR1147GGWv0vzXadtKKj1IzJQo2
	 Pwobqj4CDavBA==
Date: Thu, 17 Oct 2024 12:11:27 -0700
Subject: [PATCH 5/6] xfs: reserve quota for realtime files correctly
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919073164.3456016.15663661470844952824.stgit@frogsfrogsfrogs>
In-Reply-To: <172919073062.3456016.13160926749424883839.stgit@frogsfrogsfrogs>
References: <172919073062.3456016.13160926749424883839.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

