Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8A3149C46
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 11:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724411377; cv=none; b=q4u2lS1zrB2+fzu6kZvR5s+A+z2+W3zxDhen5I4zrD25EePeFzAIALIrUbe1gYW68jTh5tPKtb+fQEZbWtN85vaMx90jTDcXeBE6clqFhcebr5C88Wjw3oVoHm1dphJj6uGhqd8NeQziBNIahpSy+RIeq5WYyy36JYF+gZP+Pc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724411377; c=relaxed/simple;
	bh=SumY8s8vVWlvWgWsSZyYCJFPDfkXACMGJosfzreKhzo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L/fH4evrJXZppgYVPTwfaWlGUleKP4wpigqMp3wqB43kqmVtju5zFge5bDVr6wTdUBvG8NgnjncIR/3QK4XeY2W0/Y04yovO/XeSQDIbW4qOqkrL7v7MFj1otzynjclFjAaiSfbq9zaYd7U27z/4GwMDeRLpmndXW9aaWbOc9XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Wqy4g4ZKbzyR80;
	Fri, 23 Aug 2024 19:09:07 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 7B7141800CD;
	Fri, 23 Aug 2024 19:09:32 +0800 (CST)
Received: from localhost.localdomain (10.175.104.67) by
 dggpemf500017.china.huawei.com (7.185.36.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 23 Aug 2024 19:09:31 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <chandanbabu@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH 1/5] xfs: remove redundant set null for ip->i_itemp
Date: Fri, 23 Aug 2024 19:04:35 +0800
Message-ID: <20240823110439.1585041-2-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240823110439.1585041-1-leo.lilong@huawei.com>
References: <20240823110439.1585041-1-leo.lilong@huawei.com>
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

ip->i_itemp has been set null in xfs_inode_item_destroy(), so there is
no need set it null again in xfs_inode_free_callback().

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_icache.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index cf629302d48e..a5e5e5520a3b 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -143,7 +143,6 @@ xfs_inode_free_callback(
 		ASSERT(!test_bit(XFS_LI_IN_AIL,
 				 &ip->i_itemp->ili_item.li_flags));
 		xfs_inode_item_destroy(ip);
-		ip->i_itemp = NULL;
 	}
 
 	kmem_cache_free(xfs_inode_cache, ip);
-- 
2.39.2

