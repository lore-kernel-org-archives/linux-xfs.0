Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F6549EC70;
	Wed,  2 Sep 2026 13:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788355030; cv=none; b=MbtFhuaiv47rtrncYnD1D7Z2PKd0MioVw92wjSHVJ8X94A/iPyE+23ROYzuids4NA/fEa7GWvsoXdetyFOgJDWEyJWIAtDgohm5lkMgmEHly4MK6GcYEkJbD7TtzWcLvVdqeVum9pDvq9k1fKoOuBmTK6VcbYA5gy+rXkvBoRhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788355030; c=relaxed/simple;
	bh=pgNslJrKhmPb1hHc6kl0vAueUScUWIrh8wDYsXrwges=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kZA9wjjpgkjbOcpcg0rIqQoK/4TvGXS7tiw90f+t5LlrFaFVcpiskeQaVSucLor3M6+pYkXP2Y8/acEGYRf5BfZ0elyuRvzjSD4HKcte9UTfL56fWMSLujh/nnP+pGHebNkV2FpPWG0W/oyOnAFdRCi1B16L+l9vOIHEJ+nAlEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=mw4c/0xt; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="mw4c/0xt"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ysZbMcSHTTzwuIanrUUU6kasifEXs9ieZAuSRi3i5b8=;
	b=mw4c/0xtanmWd0QxLrju3Xztcdo7XZF0X2hkxOoQgxfwaKUn6tAlOoKJkZUSwlRvdVMwiRtSF
	RrVNqdP5C9qZVKF3UgdGBuF0ZuabhGmBs+LBxg+fDrrWYFvP6qlNNHw5F5HsWYSaf3FlLv7uepA
	C97OE8HihM640DhopBVYge8=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hZjdb5PRKz12LGW;
	Wed,  2 Sep 2026 21:05:39 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id ECAED40579;
	Wed,  2 Sep 2026 21:16:55 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 2 Sep
 2026 21:16:55 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
	<akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <david@kernel.org>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <ljs@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 1/4] xfs: remove dead kswapd flag inheritance from btree split worker
Date: Wed, 2 Sep 2026 21:16:50 +0800
Message-ID: <20260902131653.1338227-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk300003.china.huawei.com (7.202.195.93)

Commit 1f6d64829db7 ("xfs: block allocation work needs to be kswapd
aware") added PF_MEMALLOC | PF_KSWAPD inheritance to
xfs_btree_split_worker() so that block allocation offloaded from
kswapd to a workqueue thread could access emergency memory reserves
and avoid reclaim throttling.

pageout() no longer calls ->writepage() for filesystem folios -- it
returns PAGE_ACTIVATE for non-shmem, non-anon pages.  kswapd therefore
never enters XFS writeback and cannot reach btree split.  The only
path that offloads btree splits is unwritten extent conversion at IO
completion (xfs_end_io -> xfs_iomap_write_unwritten), which runs in
a workqueue context where current_is_kswapd() is always false.

Let's remove the dead kswapd flag and related codes.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 fs/xfs/libxfs/xfs_btree.c | 18 +-----------------
 fs/xfs/xfs_platform.h     |  4 ----
 2 files changed, 1 insertion(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 60ef7f08b1d3..6738d9d1511b 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2994,7 +2994,6 @@ struct xfs_btree_split_args {
 	struct xfs_btree_cur	**curp;
 	int			*stat;		/* success/failure */
 	int			result;
-	bool			kswapd;	/* allocation in kswapd context */
 	struct completion	*done;
 	struct work_struct	work;
 };
@@ -3008,33 +3007,18 @@ xfs_btree_split_worker(
 {
 	struct xfs_btree_split_args	*args = container_of(work,
 						struct xfs_btree_split_args, work);
-	unsigned long		pflags;
-	unsigned long		new_pflags = 0;
-
-	/*
-	 * we are in a transaction context here, but may also be doing work
-	 * in kswapd context, and hence we may need to inherit that state
-	 * temporarily to ensure that we don't block waiting for memory reclaim
-	 * in any way.
-	 */
-	if (args->kswapd)
-		new_pflags |= PF_MEMALLOC | PF_KSWAPD;
-
-	current_set_flags_nested(&pflags, new_pflags);
 	xfs_trans_set_context(args->cur->bc_tp);
 
 	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
 					 args->key, args->curp, args->stat);
 
 	xfs_trans_clear_context(args->cur->bc_tp);
-	current_restore_flags_nested(&pflags, new_pflags);
 
 	/*
 	 * Do not access args after complete() has run here. We don't own args
 	 * and the owner may run and free args before we return here.
 	 */
 	complete(args->done);
-
 }
 
 /*
@@ -3078,7 +3062,7 @@ xfs_btree_split(
 	args.curp = curp;
 	args.stat = stat;
 	args.done = &done;
-	args.kswapd = current_is_kswapd();
+
 	INIT_WORK_ONSTACK(&args.work, xfs_btree_split_worker);
 	queue_work(xfs_alloc_wq, &args.work);
 	wait_for_completion(&done);
diff --git a/fs/xfs/xfs_platform.h b/fs/xfs/xfs_platform.h
index 5d542e95fe44..a49fa159894d 100644
--- a/fs/xfs/xfs_platform.h
+++ b/fs/xfs/xfs_platform.h
@@ -115,10 +115,6 @@ typedef __u32			xfs_nlink_t;
 #define xfs_blockgc_secs	xfs_params.blockgc_timer.val
 
 #define current_cpu()		(raw_smp_processor_id())
-#define current_set_flags_nested(sp, f)		\
-		(*(sp) = current->flags, current->flags |= (f))
-#define current_restore_flags_nested(sp, f)	\
-		(current->flags = ((current->flags & ~(f)) | (*(sp) & (f))))
 
 #define NBBY		8		/* number of bits per byte */
 
-- 
2.55.0

