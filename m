Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749161514CE
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 11:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724411378; cv=none; b=iJlSEkBo3h+AROa6JZk1HbuJ25tpI2ltwBeTIF+oGuYWG/BTQfxrS7Ff9LRAkeLYG8EMdeS/Eg6beancDPPhLjn9oY6/szkxQNgoS3cM8OVP9s+HUHT5DmGjlXcyFoTr6NmSlcWoQCRjMeyQgxKUzs0jQKJhU5POh1nPuq5wKs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724411378; c=relaxed/simple;
	bh=OY3f8qWwhoKwmht4EJD0rARQyAWl74BWn7bk9rxSP9g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=adM/aRkvoxSAyNjOlhbznjfEQn8/qmTey4YvHBFvneqWuKXcXD9J6lnUOmvJm8JcWsOuB3WO5khqoxeYJssKQbQprbiv1uTVUjShwvjKE4wRBzHTcd+dQJHCW258Sas+v0zGO+VzNL81jKWp2NDnzflOB0Glv/WQH9kY/25CO/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Wqy541m3sz1j6fC;
	Fri, 23 Aug 2024 19:09:28 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id EFDAF1402C7;
	Fri, 23 Aug 2024 19:09:32 +0800 (CST)
Received: from localhost.localdomain (10.175.104.67) by
 dggpemf500017.china.huawei.com (7.185.36.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 23 Aug 2024 19:09:32 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <chandanbabu@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH 2/5] xfs: ensuere deleting item from AIL after shutdown in dquot flush
Date: Fri, 23 Aug 2024 19:04:36 +0800
Message-ID: <20240823110439.1585041-3-leo.lilong@huawei.com>
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

Deleting items from the AIL before the log is shut down can result in the
log tail moving forward in the journal on disk because log writes can still
be taking place. As a result, items that have been deleted from the AIL
might not be recovered during the next mount, even though they should be,
as they were never written back to disk.

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_dquot.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index c1b211c260a9..4cbe3db6fc32 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1332,9 +1332,15 @@ xfs_qm_dqflush(
 	return 0;
 
 out_abort:
+	/*
+	 * Shutdown first to stop the log before deleting items from the AIL.
+	 * Deleting items from the AIL before the log is shut down can result
+	 * in the log tail moving forward in the journal on disk because log
+	 * writes can still be taking place.
+	 */
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 	dqp->q_flags &= ~XFS_DQFLAG_DIRTY;
 	xfs_trans_ail_delete(lip, 0);
-	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 out_unlock:
 	xfs_dqfunlock(dqp);
 	return error;
-- 
2.39.2

