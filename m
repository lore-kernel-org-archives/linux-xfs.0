Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27EB13210B
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 06:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719989063; cv=none; b=Dd7dqcyBKPZrmHsPyKSLWot5LirnBAs9to/HwMI9qrQqtzwObdXFoZsBfqzUpt/cofFk8R7UHgBhr8oZ2IwXdnjFIKKyR7BqMLOBXEKbKdDJYGb2YcFGU6Jol4jS2U7JiNcoi/Zw7eWZSp0V6+yCXtgzOzBPaJQMLpKcw3CMgm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719989063; c=relaxed/simple;
	bh=e7W++zVSejYbhhGXxpu9A3kOpS/W9Ky44l6BkhuegDI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Qw/XOIwqmu+MV76clHHITOH768DuPLDy1ty/iWdBLTuMURRLZOtJQj+h5ZQ9beo2SFS5hSYfr2Wgs6PlviXtW6WcslmlZABPC9ncTJlyYuEQEg1I+yWBcRfjcJqH9GfSfl5bJ2RmAbl9xNRZiJ7zXkyvpR02IPIn1DVAfYRutQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WDVcC2r2ZznZ4s;
	Wed,  3 Jul 2024 14:43:55 +0800 (CST)
Received: from kwepemi500009.china.huawei.com (unknown [7.221.188.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 0223618006C;
	Wed,  3 Jul 2024 14:44:12 +0800 (CST)
Received: from localhost.localdomain (10.175.104.67) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 3 Jul 2024 14:44:11 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <chandanbabu@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH v2] xfs: get rid of xfs_ag_resv_rmapbt_alloc
Date: Wed, 3 Jul 2024 14:42:26 +0800
Message-ID: <20240703064226.229599-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500009.china.huawei.com (7.221.188.199)

The pag in xfs_ag_resv_rmapbt_alloc() is already held when the struct
xfs_btree_cur is initialized in xfs_rmapbt_init_cursor(), so there is no
need to get pag again.

On the other hand, in xfs_rmapbt_free_block(), the similar function
xfs_ag_resv_rmapbt_free() was removed in commit 92a005448f6f ("xfs: get
rid of unnecessary xfs_perag_{get,put} pairs"), xfs_ag_resv_rmapbt_alloc()
was left because scrub used it, but now scrub has removed it. Therefore,
we could get rid of xfs_ag_resv_rmapbt_alloc() just like the rmap free
block, make the code cleaner.

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/libxfs/xfs_ag_resv.h    | 19 -------------------
 fs/xfs/libxfs/xfs_rmap_btree.c |  7 ++++++-
 2 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
index ff20ed93de77..f247eeff7358 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.h
+++ b/fs/xfs/libxfs/xfs_ag_resv.h
@@ -33,23 +33,4 @@ xfs_perag_resv(
 	}
 }
 
-/*
- * RMAPBT reservation accounting wrappers. Since rmapbt blocks are sourced from
- * the AGFL, they are allocated one at a time and the reservation updates don't
- * require a transaction.
- */
-static inline void
-xfs_ag_resv_rmapbt_alloc(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno)
-{
-	struct xfs_alloc_arg	args = { NULL };
-	struct xfs_perag	*pag;
-
-	args.len = 1;
-	pag = xfs_perag_get(mp, agno);
-	xfs_ag_resv_alloc_extent(pag, XFS_AG_RESV_RMAPBT, &args);
-	xfs_perag_put(pag);
-}
-
 #endif	/* __XFS_AG_RESV_H__ */
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 9e759efa81cc..56fd6c4bd8b4 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -88,6 +88,7 @@ xfs_rmapbt_alloc_block(
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_perag	*pag = cur->bc_ag.pag;
+	struct xfs_alloc_arg    args = { .len = 1 };
 	int			error;
 	xfs_agblock_t		bno;
 
@@ -107,7 +108,11 @@ xfs_rmapbt_alloc_block(
 	be32_add_cpu(&agf->agf_rmap_blocks, 1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
 
-	xfs_ag_resv_rmapbt_alloc(cur->bc_mp, pag->pag_agno);
+	/*
+	 * Since rmapbt blocks are sourced from the AGFL, they are allocated one
+	 * at a time and the reservation updates don't require a transaction.
+	 */
+	xfs_ag_resv_alloc_extent(pag, XFS_AG_RESV_RMAPBT, &args);
 
 	*stat = 1;
 	return 0;
-- 
2.39.2

