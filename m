Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.221
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793703424;
	b=0clqSkS6qfvlS9UsJ8rhVpv7aRze2ony4gSWQkqGPSHMnKMMKqTuc023vkJUt8FXPlBX
	 /eMoF2RbaFB2CNsHXB9S2ZIbbzjdKNnYbgDbUKkbEVN2j71v4eT8wqKrVIzPf90f9CYsQ
	 g2hY0LoeKlG3RW9fyetHU8dF8G2hbYPQBqrQB3TYhj8rPV3DZWSvXWI1LtZQscZEHuB50
	 QoBr8pEutZ7OXpWum6tWiDtdYvDN6rXiO0qHb4UuV8u6Gw5xoJJlCHrnpHCZ4V/yoVE28
	 n5kZEz7udZ98CQ+uq6jwyI41gTLzDdDlG0mIWuB1WFwKOmsD84izMAUaP5tLiFYq/VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793703424;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=yALifMD/tP/5ZyBxCKPn8/yZq7ZSj/nIISQQ0UN9vRk=;
	b=ONrKuobYeT24gATE3V3y7MEYf4ga0ZC1M7px29Qk8jkFia+wHchJvyb3Zos0CVcEKaY2
	 7s+WORXRpD8LXi0P11joJef2KkIbVszSyG8qHVxtAx/1IxqSJGMur6uGcB9cTEwUH7mg3
	 5MMlKL34GS3DeIo9SVVNPV0EfqMiIeAEKfaWmEdGLlxv2EWvlrkpsqd37nY15A2F4+fCY
	 +mPl91BkhRp1kuLeVfTgiPUR4XnR/wW+8bwyIjSkr6C7RSSsYryC0KNw/OT5zR/e7YquN
	 DfTOK5BadbuQhWtqZI8VbhvP0XVkcmuXPE3/80DI6wBn8CMMY95EqURhkoXAzlNbmPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=OB+xVk6A;
	arc=none smtp.remote-ip=113.46.200.221
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9F0606C58B
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 10:57:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC9F0606C58B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=OB+xVk6A
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=yALifMD/tP/5ZyBxCKPn8/yZq7ZSj/nIISQQ0UN9vRk=;
	b=OB+xVk6Av8Y4dFQZIYPW17epec/11evcoThnUGLvFCedtSutgCEhVFB/6Z9ZTf3KCL5haInLk
	KMrw6ofx+voJLYAXEHZCcu19ClsZN58l+FaPqC9enOsJ+N/mQvHZbNg3VfO6+N3PylEtw8C9cCZ
	PLW2ZO3gbmntlgdxVvSazGs=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4jJlrP0rtSzRhQn;
	Tue,  3 Nov 2026 18:56:53 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id C78DB4057D;
	Tue,  3 Nov 2026 18:56:58 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 18:56:58 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Carlos Maiolino <cem@kernel.org>, <linux-xfs@vger.kernel.org>
CC: Kefeng Wang <wangkefeng.wang@huawei.com>, Brian Foster
	<bfoster@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v2] xfs: kill xfs_trans_set/clear_context() helpers
Date: Tue, 3 Nov 2026 18:56:54 +0800
Message-ID: <20261103105654.3129688-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk300003.china.huawei.com (7.202.195.93)

Open code the helpers so that tp->t_pflags access is explicit, reducing
the risk of misusing them outside the transaction owner thread as seen
in xfs_btree_split_worker().

Suggested-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
v2:
- Since the previous patches have already been merged[1],
  rebased on v7.4-rc1 and collect RB

[1] https://lore.kernel.org/linux-xfs/aqOp035i41XIrDXg@infradead.org/

 fs/xfs/libxfs/xfs_btree.c |  4 ----
 fs/xfs/libxfs/xfs_trans.h | 14 --------------
 fs/xfs/xfs_trans.c        | 10 +++++++---
 3 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2434c54a3570..4faab8cd3a52 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3009,10 +3009,6 @@ xfs_btree_split_worker(
 						struct xfs_btree_split_args, work);
 	unsigned int		nofs_flags;
 
-	/*
-	 * Don't use xfs_trans_set_context() here: it would overwrite the
-	 * caller's saved NOFS state in tp->t_pflags. Use a local scope.
-	 */
 	nofs_flags = memalloc_nofs_save();
 
 	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
diff --git a/fs/xfs/libxfs/xfs_trans.h b/fs/xfs/libxfs/xfs_trans.h
index 05b3cc19a311..b0c7724d0619 100644
--- a/fs/xfs/libxfs/xfs_trans.h
+++ b/fs/xfs/libxfs/xfs_trans.h
@@ -264,20 +264,6 @@ int xfs_trans_alloc_dir(struct xfs_inode *dp, struct xfs_trans_res *resv,
 		struct xfs_inode *ip, unsigned int *dblocks,
 		struct xfs_trans **tpp, int *nospace_error);
 
-static inline void
-xfs_trans_set_context(
-	struct xfs_trans	*tp)
-{
-	tp->t_pflags = memalloc_nofs_save();
-}
-
-static inline void
-xfs_trans_clear_context(
-	struct xfs_trans	*tp)
-{
-	memalloc_nofs_restore(tp->t_pflags);
-}
-
 static inline void
 xfs_trans_cancel(
 	struct xfs_trans	*tp)
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 8f0c308f312f..973e82e1e323 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -72,7 +72,7 @@ xfs_trans_free(
 	xfs_extent_busy_clear(&tp->t_busy, false);
 
 	trace_xfs_trans_free(tp, _RET_IP_);
-	xfs_trans_clear_context(tp);
+	memalloc_nofs_restore(tp->t_pflags);
 	if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
 		sb_end_intwrite(tp->t_mountp->m_super);
 	xfs_trans_free_dqinfo(tp);
@@ -220,7 +220,11 @@ __xfs_trans_alloc(
 	tp = kmem_cache_zalloc(xfs_trans_cache, GFP_KERNEL | __GFP_NOFAIL);
 	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
 		sb_start_intwrite(mp->m_super);
-	xfs_trans_set_context(tp);
+	/*
+	 * Save NOFS state for xfs_trans_free() to restore. Only the
+	 * transaction owner thread may touch tp->t_pflags.
+	 */
+	tp->t_pflags = memalloc_nofs_save();
 	tp->t_flags = flags;
 	tp->t_mountp = mp;
 	INIT_LIST_HEAD(&tp->t_items);
@@ -1038,7 +1042,7 @@ xfs_trans_roll(
 	 * xfs_trans_free.  Set it again here before doing memory
 	 * allocations.
 	 */
-	xfs_trans_set_context(tp);
+	tp->t_pflags = memalloc_nofs_save();
 
 	if (error)
 		return error;
-- 
2.55.0

