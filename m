Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0231DF269
	for <linux-xfs@vger.kernel.org>; Sat, 21 Dec 2024 06:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734762888; cv=none; b=f6suZ9tKjrERIdbiDqweC3bmjlbsznCM+Fp8pi25nf/VNE6RLMnMk13jvDjJSpdHH1pZ2qq9/slKptqiFw+RIya2VJtCrh+nxEEzuDf6orjrfjOuUoqvfqXh5q08/Y3j5sk50N8olJS40MIEwGhpEOSLI5FlrNRwOOoSQKyBDDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734762888; c=relaxed/simple;
	bh=IL1qbMW6Bk1yZJdGFNl7kmmBVO7kxL0lFWtow9W4rvQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PeqRI7s4OkCeiqOr3PjZRo91k8WTZIiE0uOkK8nRoMIsvH4WCGdRDiXSoC/tmG1UNdiXQcDdztAwzRt6E7yaQPXABQvlABeCr/9oBaUd+/fvYFY7Ahiv2YO95MWeodYH/fY6I+RuQ1VEt3wvdpSsGhynyGaU4LVOdAzE8+V++nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4YFZJB1G4Jz1JB8S;
	Sat, 21 Dec 2024 14:34:18 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id E2394140133;
	Sat, 21 Dec 2024 14:34:43 +0800 (CST)
Received: from huawei.com (10.175.104.67) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 21 Dec
 2024 14:34:43 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH 2/2] xfs: remove bp->b_error check in xfs_attr3_root_inactive
Date: Sat, 21 Dec 2024 14:30:43 +0800
Message-ID: <20241221063043.106037-3-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241221063043.106037-1-leo.lilong@huawei.com>
References: <20241221063043.106037-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemf500017.china.huawei.com (7.185.36.126)

The xfs_da3_node_read earlier in the function will catch most cases of
incoming on-disk corruption, which makes this check mostly redundant,
unless someone corrupts the buffer and the AIL pushes it out to disk
while the buffer's unlocked.

In the first case we'll never reach this check, and in the second case
the AIL will shut down the log, at which point checking b_error becomes
meaningless. Remove the check to make the code consistent with most other
xfs_trans_get_buf() callers in XFS.

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

