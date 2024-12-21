Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3211DC99B
	for <linux-xfs@vger.kernel.org>; Sat, 21 Dec 2024 06:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734762889; cv=none; b=j2tTjueHlluON9seuHPkit3UEjTp5Q+KP9iq/19XQ7qAgwM1q+KBFFbR8+/gcitnC8mo6Ya8fIxtTm//QzabhpTnx6hmMkmLfOMBovlgahUHLDXV9y7j/o6PJOxGALA67fimaWeYZo5dAWoRopdy60s0+st2UUQ+qhE8GSZhI8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734762889; c=relaxed/simple;
	bh=5j/AjEKt2SORX1omk3AXCry+tl4OpqkocsvIPvs9ewA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=am07iTZJhzR2xN/0UDeNmrYu75cFpkvirERy9kld5a0cmSjf5EZK5QACO2BDS4xR6rEAZcG/NgPNIpYXRK8d45Jo2myAZ6WDy+eWzahXjmLj3SkcfM8oepTZJqFXGxSo0+/52IGiM0Xq4bzsrSwUfPrs2sEmlX7bmMa+PNhENrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4YFZGR6ZwVz21nrH;
	Sat, 21 Dec 2024 14:32:47 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 63DB11A0188;
	Sat, 21 Dec 2024 14:34:43 +0800 (CST)
Received: from huawei.com (10.175.104.67) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 21 Dec
 2024 14:34:42 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH 1/2] xfs: remove redundant update for t_curr_res in xfs_log_ticket_regrant
Date: Sat, 21 Dec 2024 14:30:42 +0800
Message-ID: <20241221063043.106037-2-leo.lilong@huawei.com>
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

The current reservation of the log ticket has already been updated in
xfs_log_ticket_regrant(), so there is no need to update it again. This
is just a code cleanup with no functional changes.

Signed-off-by: Long Li <leo.lilong@huawei.com>
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

