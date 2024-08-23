Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16BB149C46
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 11:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724411379; cv=none; b=Y7pnVsZb3IzYttALIbu2k/ioLLwlFGxa3pF51cX3IxiC22MoacVbP+JNDCwNiZIT28alD6uJbbuHoO6ANVOcDJjKDmewQD/XJofPpyMarvKzJcWkM5iTVnT3fCfwxy5eeu7OLbO6BhimfCyGLzOPEPN6I+uxnBmAw2kpjphOXHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724411379; c=relaxed/simple;
	bh=/5n8hzWgz/HuQgiUpMiAmUNXf8su2E3o1Qj6bFxF41U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ezwosEoZpqQgyl1CKuBdC7wFNLpHDOx8l1o68W2xfBRA9uJdvNW0gzJ6zOpCEaVTvqUJ4e+nlPYbTSIolSaFIYnkoFJ7Za0sPgd8axJO+tbj5JnI/ZbZWSrd/Lyri+UIFKsKYyWdmMlj0ue73AhvW4OsrnqDI0GzO2dqYE1pDrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Wqy536v4Jz1S8Nh;
	Fri, 23 Aug 2024 19:09:27 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 72CE1180042;
	Fri, 23 Aug 2024 19:09:33 +0800 (CST)
Received: from localhost.localdomain (10.175.104.67) by
 dggpemf500017.china.huawei.com (7.185.36.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 23 Aug 2024 19:09:32 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <chandanbabu@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH 3/5] xfs: add XFS_ITEM_UNSAFE for log item push return result
Date: Fri, 23 Aug 2024 19:04:37 +0800
Message-ID: <20240823110439.1585041-4-leo.lilong@huawei.com>
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

After pushing log items, the log item may have been freed, making it
unsafe to access in tracepoints. This commit introduces XFS_ITEM_UNSAFE
to indicate when an item might be freed during the item push operation.

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_stats.h     | 1 +
 fs/xfs/xfs_trans.h     | 1 +
 fs/xfs/xfs_trans_ail.c | 7 +++++++
 3 files changed, 9 insertions(+)

diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index a61fb56ed2e6..9a7a020587cf 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -86,6 +86,7 @@ struct __xfsstats {
 	uint32_t		xs_push_ail_pushbuf;
 	uint32_t		xs_push_ail_pinned;
 	uint32_t		xs_push_ail_locked;
+	uint32_t		xs_push_ail_unsafe;
 	uint32_t		xs_push_ail_flushing;
 	uint32_t		xs_push_ail_restarts;
 	uint32_t		xs_push_ail_flush;
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index f06cc0f41665..fd4f04853fe2 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -117,6 +117,7 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
 #define XFS_ITEM_PINNED		1
 #define XFS_ITEM_LOCKED		2
 #define XFS_ITEM_FLUSHING	3
+#define XFS_ITEM_UNSAFE		4
 
 /*
  * This is the structure maintained for every active transaction.
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 8ede9d099d1f..a5ab1ffb8937 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -561,6 +561,13 @@ xfsaild_push(
 
 			stuck++;
 			break;
+		case XFS_ITEM_UNSAFE:
+			/*
+			 * The item may have been freed, so we can't access the
+			 * log item here.
+			 */
+			XFS_STATS_INC(mp, xs_push_ail_unsafe);
+			break;
 		default:
 			ASSERT(0);
 			break;
-- 
2.39.2

