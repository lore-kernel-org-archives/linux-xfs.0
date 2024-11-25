Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B455632
	for <linux-xfs@vger.kernel.org>; Mon, 25 Nov 2024 01:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732499730; cv=none; b=L0XIjoKHQOSOzQbPuBVZfVG2qaDos9pAcWFWv2xm2S3/kHydP3QAaTLihUCoRHWBpSO16mdn1w14OB1AM7ZDTLB1UHMvkxi/WzBGoFat11E8Ea+i0w6YLrZonD3MoZeBrcstpTEtEZJzyA10tDpmAt6r2lWcCSJfBKcue2Xd764=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732499730; c=relaxed/simple;
	bh=9N9pFwVxn5OrS1J7OjEG+0HjPO45DZiqqFEEYdLXmHg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VQcPBlG3Kig5Tq7tsOkIioZqly+V49H+RXAJrL78Jehrlj7jvVprfeTc3FjrMDre2L5y10SGaIIpsoCQi+lz0GUWwOGm40GScI+eXioaBNpgQZa7XDYg2PggpBvI0KW2yCnKrlhh4aW07BHoFn7TVUe/TuFQU0/uSeUMjNXh/Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4XxTJY6LNzzRhp7;
	Mon, 25 Nov 2024 09:53:49 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 47C3D18009B;
	Mon, 25 Nov 2024 09:55:17 +0800 (CST)
Received: from huawei.com (10.175.104.67) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 25 Nov
 2024 09:55:16 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH] xfs: fix race condition in inodegc list and cpumask handling
Date: Mon, 25 Nov 2024 09:52:58 +0800
Message-ID: <20241125015258.2652325-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
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

There is a race condition between inodegc queue and inodegc worker where
the cpumask bit may not be set when concurrent operations occur.

Current problematic sequence:

  CPU0                             CPU1
  --------------------             ---------------------
  xfs_inodegc_queue()              xfs_inodegc_worker()
                                     llist_del_all(&gc->list)
    llist_add(&ip->i_gclist, &gc->list)
    cpumask_test_and_set_cpu()
                                     cpumask_clear_cpu()
                  < cpumask not set >

Fix this by moving llist_del_all() after cpumask_clear_cpu() to ensure
proper ordering. This change ensures that when the worker thread clears
the cpumask, any concurrent queue operations will either properly set
the cpumask bit or have already emptied the list.

Also remove unnecessary smp_mb__{before/after}_atomic() barriers since
the llist_* operations already provide required ordering semantics. it
make the code cleaner.

Fixes: 62334fab4762 ("xfs: use per-mount cpumask to track nonempty percpu inodegc lists")
Reported-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_icache.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 7b6c026d01a1..fba784d7a146 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1948,19 +1948,20 @@ xfs_inodegc_worker(
 {
 	struct xfs_inodegc	*gc = container_of(to_delayed_work(work),
 						struct xfs_inodegc, work);
-	struct llist_node	*node = llist_del_all(&gc->list);
+	struct llist_node	*node;
 	struct xfs_inode	*ip, *n;
 	struct xfs_mount	*mp = gc->mp;
 	unsigned int		nofs_flag;
 
+	cpumask_clear_cpu(gc->cpu, &mp->m_inodegc_cpumask);
+
 	/*
-	 * Clear the cpu mask bit and ensure that we have seen the latest
-	 * update of the gc structure associated with this CPU. This matches
-	 * with the release semantics used when setting the cpumask bit in
-	 * xfs_inodegc_queue.
+	 * llist_del_all provides ordering semantics that ensure the CPU mask
+	 * clearing is always visible before removing all entries from the gc
+	 * list. This prevents list being added while the CPU mask bit is
+	 * unset in xfs_inodegc_queue()
 	 */
-	cpumask_clear_cpu(gc->cpu, &mp->m_inodegc_cpumask);
-	smp_mb__after_atomic();
+	node = llist_del_all(&gc->list);
 
 	WRITE_ONCE(gc->items, 0);
 
@@ -2188,13 +2189,11 @@ xfs_inodegc_queue(
 	shrinker_hits = READ_ONCE(gc->shrinker_hits);
 
 	/*
-	 * Ensure the list add is always seen by anyone who finds the cpumask
-	 * bit set. This effectively gives the cpumask bit set operation
-	 * release ordering semantics.
+	 * llist_add provides necessary ordering semantics to ensure list
+	 * additions are visible when cpumask bit is found set, so no
+	 * additional memory barrier is needed.
 	 */
-	smp_mb__before_atomic();
-	if (!cpumask_test_cpu(cpu_nr, &mp->m_inodegc_cpumask))
-		cpumask_test_and_set_cpu(cpu_nr, &mp->m_inodegc_cpumask);
+	cpumask_test_and_set_cpu(cpu_nr, &mp->m_inodegc_cpumask);
 
 	/*
 	 * We queue the work while holding the current CPU so that the work
-- 
2.39.2

