Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14DA192D73
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 11:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734954572; cv=none; b=VHeYQ6kWTifpjsMX511n8CeLRASiJqSBcgRMcSlSvwZx8iPzGolgRxF1dcesZCoYNRhKCLZrdAcV3fWidDAJAhGriSZ2bfnJkFhmohtNQvIuNGoOVuG6mBinOGFKSO3P9jcys4sOyTAIAanIJceErXn2b3W89AMHfBB+ZNa/7aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734954572; c=relaxed/simple;
	bh=6MFAj+KSi8lOfe2hyHj7n5NHP38OWmNUpbhN7B170+o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oVGtWZKzMEYSc57c/TyDO8k2rZrrmtIS3xcTSlNw7QVl+Otm9gESbyzfcDjvleiZDIYo76rIoCd1aCfJpq7vdiSIkB/HOjuGsuol/7h3sihTR8714ZIWudGAEi7kqXdiQVEvjBFVTofGgcHzHMRBOlD+mMOZdXXIsM8Op4UpaUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4YGx7n5Lw7zhZYX;
	Mon, 23 Dec 2024 19:46:45 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 5F378140391;
	Mon, 23 Dec 2024 19:49:23 +0800 (CST)
Received: from huawei.com (10.175.104.67) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 23 Dec
 2024 19:49:22 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH v2 2/2] xfs: remove bp->b_error check in xfs_attr3_root_inactive
Date: Mon, 23 Dec 2024 19:45:11 +0800
Message-ID: <20241223114511.3484406-3-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241223114511.3484406-1-leo.lilong@huawei.com>
References: <20241223114511.3484406-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemf500017.china.huawei.com (7.185.36.126)

The b_error check right after xfs_trans_get_buf() is redundant:

1) If the buffer is found in transaction via xfs_trans_buf_item_match(),
   any corrupted metadata error would have already been exposed during
   previous reads like xfs_da3_node_read().

2) If the buffer is obtained via xfs_buf_get_map():
   - It's called without XBF_READ flag, so won't return buffer with
     b_error set, since xfs_buf_get_map() will clear it anyway.
   - Buffer found in cache normally won't have error since previous reads
     had checked it, unless someone corrupts the buffer and the AIL
     pushes it out to disk while the buffer's unlocked. But in this case,
     AIL will shut down the log.

Remove this redundant check to simplify the code, make the code consistent
with most other xfs_trans_get_buf() callers in XFS.

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_attr_inactive.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 24fb12986a56..319004bf089f 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -305,11 +305,6 @@ xfs_attr3_root_inactive(
 			XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0, &bp);
 	if (error)
 		return error;
-	error = bp->b_error;
-	if (error) {
-		xfs_trans_brelse(*trans, bp);
-		return error;
-	}
 	xfs_trans_binval(*trans, bp);	/* remove from cache */
 	/*
 	 * Commit the invalidate and start the next transaction.
-- 
2.39.2

