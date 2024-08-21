Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04EB79CD
	for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2024 06:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724222199; cv=none; b=VrM4PGEbdPbrLCt+M12KgtcTTYefBF7Vtq59X7DO0Q/b2t7CQe2pgTkttzY1CzMP287pm5qUQQB7SHMe1CtxiSMZIMS0GtNPF0DTKsVLTYdiD5Mlp9oPChFvueM/D79kcpT+LbfmeJBBXy22sGZ8qvSav7kAVDwB0JH7dex/pyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724222199; c=relaxed/simple;
	bh=c2GIkGocM+Ol4iroqaRZr1NzMdnYbgUGEk+4J9D378I=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lebG3Rf7IwpuNSMoSSXy8P2eQu9yNMV9DuCajtZ8qz4m9mPK46rZ/n2SbYZKrdADIPC5GM9GAVWn+Tl7/A7KWJqDp+XzFbNQ1XBukAToIKpmuVGagfk0VKH853mc5H41Nefof8OZClXwqv+avJxnPCaKHHl1Ro5Yb6ICWVr6+Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Wpc1j1nqgzQqG8;
	Wed, 21 Aug 2024 14:31:53 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 2A90F180101;
	Wed, 21 Aug 2024 14:36:35 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 21 Aug
 2024 14:36:34 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <chandan.babu@oracle.com>, <djwong@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH -next] xfs: use LIST_HEAD() to simplify code
Date: Wed, 21 Aug 2024 14:43:55 +0800
Message-ID: <20240821064355.2293091-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)

list_head can be initialized automatically with LIST_HEAD()
instead of calling INIT_LIST_HEAD().

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/xfs/xfs_mru_cache.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index 7443debaffd6..d0f5b403bdbe 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -230,9 +230,8 @@ _xfs_mru_cache_clear_reap_list(
 		__releases(mru->lock) __acquires(mru->lock)
 {
 	struct xfs_mru_cache_elem *elem, *next;
-	struct list_head	tmp;
+	LIST_HEAD(tmp);
 
-	INIT_LIST_HEAD(&tmp);
 	list_for_each_entry_safe(elem, next, &mru->reap_list, list_node) {
 
 		/* Remove the element from the data store. */
-- 
2.34.1

