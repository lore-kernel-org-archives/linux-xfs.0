Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD70192D73
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 11:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734954568; cv=none; b=dWcJ4MS3ojc3e70yK8FYyHSdgCAunQM2mwUy8h3CabLb6V1OY+QX8ba1LSmHfvGKBhNP9azgjptfgn47eIqkECQ2GdBbXqa7Ehh8N+THIw6funAJrTQId8XYHcCiqNhwWbjpZPlJb50a8w6Tq+zMQNnTKFYX5KwjfmLJ3elGHlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734954568; c=relaxed/simple;
	bh=KqJ1naOIADwpBZ+m6ZFgAIX6lfuwV0ETtTSP2ueq6S4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LN9i076M273FIUEdTrM2pqcuyVSQslx94h3oWcqwuc1cxldCpuQOWpxdjhocUn7dZ1ONJdzaXqIVobKvG1I3YDyTkD4ggGAIy/TJYiNK2UG633A7EY+WwCWHsWIAa6C4c7KeiQGoVPo6+mKRCPWNhb+vS/Y7gLWfId/I5/TpA7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4YGx7M6VRXzgZY6;
	Mon, 23 Dec 2024 19:46:23 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 4FEA018007C;
	Mon, 23 Dec 2024 19:49:22 +0800 (CST)
Received: from huawei.com (10.175.104.67) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 23 Dec
 2024 19:49:21 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH v2 0/2] xfs: two small cleanup
Date: Mon, 23 Dec 2024 19:45:09 +0800
Message-ID: <20241223114511.3484406-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
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

This series contains two small cleanup patches. No functional changes.

v2-v3:
  Rewrite commit message, make the explaine clearly.

Long Li (2):
  xfs: remove redundant update for ticket->t_curr_res in
    xfs_log_ticket_regrant
  xfs: remove bp->b_error check in xfs_attr3_root_inactive

 fs/xfs/xfs_attr_inactive.c | 5 -----
 fs/xfs/xfs_log.c           | 2 --
 2 files changed, 7 deletions(-)

-- 
2.39.2

