Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743A01D172A
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846466; cv=none; b=Qx+SSiVJSjprY/fBWAaUEdVnSx3cRMapMEz+IsoGiMx0PQVY8X6CLfdEpJKVYRfxcw7M6/l1XX3PJ8XD+tROCi+FrjSzqb6PLx9quJq7r2QXAfkAnpkgUwDMcJJZJTfs5bG0TBaRNTgzRC68Q84EANV2kLY3i6fodgLR3oYW33Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846466; c=relaxed/simple;
	bh=0xtQPuYsFx6+EaDmrN6skq2nN6sSjNCg3Y9AEFd1TbE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b9kUm2147mGNlPA19zxbPKQ1DbAbX8p92/6lwg/qfDX7THY0MCg7KO6+EtCz4OBiiZ6NB6a9xsX18/hzsTqsfBVwYQ8goo+TE5FxKoP59is8fn0UmDBqpZ1g27en8TZnfRUMXLko/c8wUe02I1QlSOi12I9xhUUF7VaD1DHp0EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IfxQrF8T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IfxQrF8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08650C4CECF;
	Tue,  5 Nov 2024 22:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846466;
	bh=0xtQPuYsFx6+EaDmrN6skq2nN6sSjNCg3Y9AEFd1TbE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IfxQrF8TEIALO9XI4R/oHRn20SDWC8xfroImLrh5/3f/TXPUh89cHwjyNwolWcnHe
	 8mdHHNK/zCiuqOwzDyj9jdb1HU6latn5Qg79u7kSrqGU4JOO/N2rypo/aBcxk3Zzwn
	 zSZR5qUNp+5xaa3jWcbuAlqwpLFei07ggXTXMb2VJ3yPyjdLCyYuozsD3VF5ZcQNxu
	 qeDUFIuzngy1/U5QEEDX8WlN0Zm3YFKTWB1jf2Hm5nxNQxNnY2KXoy7Pfs5nRCrosu
	 PYcEudYmWwEUHEfjQo7ywGWwC7sNScnRueT54EbG2VktInekLIu2o2eeoFvdfHCmLx
	 BgrPhHdeWKDxA==
Date: Tue, 05 Nov 2024 14:41:05 -0800
Subject: [PATCH 5/6] xfs: reserve quota for realtime files correctly
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084399647.1873230.17634497666081035380.stgit@frogsfrogsfrogs>
In-Reply-To: <173084399548.1873230.14221538780736772304.stgit@frogsfrogsfrogs>
References: <173084399548.1873230.14221538780736772304.stgit@frogsfrogsfrogs>
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

