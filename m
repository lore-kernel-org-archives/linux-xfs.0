Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054B4185B74
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 11:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724411378; cv=none; b=UBHTSAH9i0+xs4YkYtivz8aILe4AnESaBcNXynWuNAxYIvHX2ocWxRbryQJ46Oal1IYqLhFpipM4n0Z8bF1TRyLpOu85qGpgKYIPOYBX443nRzHP/EakCQ2UxmYXMVealfvToTcoD13wjbcwMCUkQ1j8PejUsKl2nrnQ+Vu47l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724411378; c=relaxed/simple;
	bh=HOvRv1bsMNftolvaxhCDWF8zdq1ve6WgqOM+lL2CbIM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o4K8m9sHh96b9UQcJn5Gp7NeNRxjpW9AH3mDBJUaEoeTZfvBCsFnLNeukCV6tqmympwZclE/sMAxgnmzlkqkV0VjF7+gY31cpY2T3/lqxZqSLxhGa1ffhUXlQpMElP+3rxznPhhIgmZ5pvKkkTK1m3AHZp+GOJ97RIhJOyvsiGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Wqy4j0RyrzyR8J;
	Fri, 23 Aug 2024 19:09:09 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id E483A1800A4;
	Fri, 23 Aug 2024 19:09:33 +0800 (CST)
Received: from localhost.localdomain (10.175.104.67) by
 dggpemf500017.china.huawei.com (7.185.36.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 23 Aug 2024 19:09:33 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <chandanbabu@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH 4/5] xfs: fix a UAF when dquot item push
Date: Fri, 23 Aug 2024 19:04:38 +0800
Message-ID: <20240823110439.1585041-5-leo.lilong@huawei.com>
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

If errors are encountered while pushing a dquot log item, the dquot dirty
flag is cleared. Without the protection of dqlock and dqflock locks, the
dquot reclaim thread may free the dquot. Accessing the log item in xfsaild
after this can trigger a UAF.

  CPU0                              CPU1
  push item                         reclaim dquot
  -----------------------           -----------------------
  xfsaild_push_item
    xfs_qm_dquot_logitem_push(lip)
      xfs_dqlock_nowait(dqp)
      xfs_dqflock_nowait(dqp)
      spin_unlock(&lip->li_ailp->ail_lock)
      xfs_qm_dqflush(dqp, &bp)
                       <encountered some errors>
        xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE)
        dqp->q_flags &= ~XFS_DQFLAG_DIRTY
                       <dquot is not diry>
        xfs_trans_ail_delete(lip, 0)
        xfs_dqfunlock(dqp)
      spin_lock(&lip->li_ailp->ail_lock)
      xfs_dqunlock(dqp)
                                    xfs_qm_shrink_scan
                                      list_lru_shrink_walk
                                        xfs_qm_dquot_isolate
                                          xfs_dqlock_nowait(dqp)
                                          xfs_dqfunlock(dqp)
                                          //dquot is clean, not flush it
                                          xfs_dqfunlock(dqp)
                                          dqp->q_flags |= XFS_DQFLAG_FREEING
                                          xfs_dqunlock(dqp)
                                          //add dquot to dispose list
                                      //free dquot in dispose list
                                      xfs_qm_dqfree_one(dqp)
  trace_xfs_ail_xxx(lip)  //UAF

Fix this by returning XFS_ITEM_UNSAFE in xfs_qm_dquot_logitem_push() when
dquot flush encounters errors (excluding EAGAIN error), ensuring xfsaild
does not access the log item after it is pushed.

Fixes: 9e4c109ac822 ("xfs: add AIL pushing tracepoints")
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_dquot_item.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 7d19091215b0..afc7ad91ddef 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -160,8 +160,16 @@ xfs_qm_dquot_logitem_push(
 		if (!xfs_buf_delwri_queue(bp, buffer_list))
 			rval = XFS_ITEM_FLUSHING;
 		xfs_buf_relse(bp);
-	} else if (error == -EAGAIN)
+	} else if (error == -EAGAIN) {
 		rval = XFS_ITEM_LOCKED;
+	} else {
+		/*
+		 * The dirty flag has been cleared; the dquot may be reclaimed
+		 * after unlock. It's unsafe to access the item after it has
+		 * been pushed.
+		 */
+		rval = XFS_ITEM_UNSAFE;
+	}
 
 	spin_lock(&lip->li_ailp->ail_lock);
 out_unlock:
-- 
2.39.2

