Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90274192D91
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 11:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734954572; cv=none; b=Y1XYn4GKdypCCOgZesPz8yPQdPQ1X4feOJLVuYIsRb9dTOTzq1zPxW5wIkZGdp8jVXAeLNam39/xOclt3Ke3ViN79tQcCamK8TlAw0sJ1AElpYJ/ocu4cKp4T0oMIJcY2PXNXJnlrSZZCINhvvw9Xs1sHmluX4mJU1zZ+Ui0T78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734954572; c=relaxed/simple;
	bh=PucH9xW2gn/9Si6GlPuv0qHCDAY0t9RiGIMnAbhln1E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UaPRXtrE69KjsRgy13/tTUU7oMGqZJXcdcR+FyUQPSvjrnycwbGmkZ0vcbLJgsoag52qHmGHTNQ6QY5E1QtrwiVjO8yVnjKBe0avzxvtM0dSe4BCPrx2B3zjRLNRwCguvRvM812t4rbZk00Jrx4bRDWPKUxrf73RPO3vFq7sAYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4YGx8Y01Npz21p3q;
	Mon, 23 Dec 2024 19:47:24 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id D6026140202;
	Mon, 23 Dec 2024 19:49:22 +0800 (CST)
Received: from huawei.com (10.175.104.67) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 23 Dec
 2024 19:49:22 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH v2 1/2] xfs: remove redundant update for ticket->t_curr_res in xfs_log_ticket_regrant
Date: Mon, 23 Dec 2024 19:45:10 +0800
Message-ID: <20241223114511.3484406-2-leo.lilong@huawei.com>
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

The current reservation of the log ticket has already been updated a few
lines above in xfs_log_ticket_regrant(), so there is no need to update it
again. This is just a code cleanup with no functional changes.

Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 05daad8a8d34..f8851ff835de 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2744,8 +2744,6 @@ xfs_log_ticket_regrant(
 	if (!ticket->t_cnt) {
 		xlog_grant_add_space(&log->l_reserve_head, ticket->t_unit_res);
 		trace_xfs_log_ticket_regrant_exit(log, ticket);
-
-		ticket->t_curr_res = ticket->t_unit_res;
 	}
 
 	xfs_log_ticket_put(ticket);
-- 
2.39.2

