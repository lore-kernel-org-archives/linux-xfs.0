Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90AC38F83
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 13:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719928239; cv=none; b=dYTxkw9/WiJbTqwiOgfv3ZY4pakfzcPiwrUvBriDhosOir0BNPPi5YHZLggoBSJEMuB8FWVNZM5wwgvHMsRRaKj9sHPKpKT9svQSk8Q399Ky0hq9IBkWV6GwZcSeoL79pZxOMYxH+gvB7jqZXTpmr3fH72kOzmaJ4m9c4bM/pZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719928239; c=relaxed/simple;
	bh=r1XH6WaXJ2tVDrvGyc16H0EoAUJqoMtLXhduEQbg7tc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QEtlsZmORpyCtMY5sdBCSaYuftEtShRpcSv9A3CTsw7+4yY10cpDF9c//Cy/YcGlh2jN5XSUEQyMnnZ1LjiLL3ruiVE6vAS7djtaNBOlKc1fcYjBtSXuLPmqp4SKmAK0Tp57WddeB+MfBAoavoEeFiyOnas1ShZR10lOat9J4/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WD46f1MNLznYqw;
	Tue,  2 Jul 2024 21:50:18 +0800 (CST)
Received: from kwepemi500009.china.huawei.com (unknown [7.221.188.199])
	by mail.maildlp.com (Postfix) with ESMTPS id B4AE318007E;
	Tue,  2 Jul 2024 21:50:33 +0800 (CST)
Received: from localhost.localdomain (10.175.104.67) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 2 Jul 2024 21:50:32 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <chandanbabu@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH] xfs: get rid of xfs_ag_resv_rmapbt_alloc
Date: Tue, 2 Jul 2024 21:48:51 +0800
Message-ID: <20240702134851.2654558-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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
 fs/xfs/libxfs/xfs_rmap_btree.c |  8 +++++++-
 2 files changed, 7 insertions(+), 20 deletions(-)

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
index 9e759efa81cc..aa1d29814b74 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -88,6 +88,7 @@ xfs_rmapbt_alloc_block(
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_perag	*pag = cur->bc_ag.pag;
+	struct xfs_alloc_arg    args = { NULL };
 	int			error;
 	xfs_agblock_t		bno;
 
@@ -107,7 +108,12 @@ xfs_rmapbt_alloc_block(
 	be32_add_cpu(&agf->agf_rmap_blocks, 1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
 
-	xfs_ag_resv_rmapbt_alloc(cur->bc_mp, pag->pag_agno);
+	/*
+	 * Since rmapbt blocks are sourced from the AGFL, they are allocated one
+	 * at a time and the reservation updates don't require a transaction.
+	 */
+	args.len = 1;
+	xfs_ag_resv_alloc_extent(pag, XFS_AG_RESV_RMAPBT, &args);
 
 	*stat = 1;
 	return 0;
-- 
2.39.2

