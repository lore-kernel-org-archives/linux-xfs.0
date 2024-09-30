Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300F83A8CB
	for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 10:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727693135; cv=none; b=SYmIDUWyDtGc5XFs0zLde2Nfzd/YKWv3lNE8V0o+1fXppT2S1OpyuPcquipX4vVdzgcgNqWo+7xeTAz8xo6mpnJRantO00LOaQLSOiBlMWQXBQ0ljfFhaABVTmKJIBJphfOJ6QP39q2SB22NMeqieOzJDiDICpCHFBNkMnujexg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727693135; c=relaxed/simple;
	bh=yWkGfseix6bQYfNn9FA4/Pv2OClFqZivZEl2MDtFNKI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=t9PhNQ1yel652YHWfgWjBbCLIAcGwoHGGCXR+TpYQbY0YshfsRYgEFj+8h++jar+7AWOIbM2TP2iTpIer1GSeGE4srT1UJUzUCzrtI6F9vegp0LWvH635woXKnKjdEbDBAiVg26hFdKvB/gpJOVL9US70yL5cHgiB4I3IGz5ry4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XHHkr1sdXz1SC6m;
	Mon, 30 Sep 2024 18:44:36 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 9B941180041;
	Mon, 30 Sep 2024 18:45:30 +0800 (CST)
Received: from huawei.com (10.175.104.67) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 30 Sep
 2024 18:45:29 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <chandanbabu@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>
Subject: [next] xfs: remove the redundant xfs_alloc_log_agf
Date: Mon, 30 Sep 2024 18:42:17 +0800
Message-ID: <20240930104217.2184941-1-leo.lilong@huawei.com>
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
 dggpemf500017.china.huawei.com (7.185.36.126)

There are two invocations of xfs_alloc_log_agf in xfs_alloc_put_freelist.
The AGF does not change between the two calls. Although this does not pose
any practical problems, it seems like a small mistake. Therefore, fix it
by removing the first xfs_alloc_log_agf invocation.

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 59326f84f6a5..cce32b2f3ffd 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3159,8 +3159,6 @@ xfs_alloc_put_freelist(
 		logflags |= XFS_AGF_BTREEBLKS;
 	}
 
-	xfs_alloc_log_agf(tp, agbp, logflags);
-
 	ASSERT(be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp));
 
 	agfl_bno = xfs_buf_to_agfl_bno(agflbp);
-- 
2.39.2

