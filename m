Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E8C49F101;
	Wed,  2 Sep 2026 13:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788355032; cv=none; b=frCXdzbeJZ8uPNXJ6VX2BM7lrF5BOFZAD/8Q1ydmAC+xy16lRjIkI4j1t0HydsRi5MgvcQ5VFeouSCTahWiFkhrAoOyuOom5VQbUqRCXBzfRauRJ30/6Ycqlk8/JCMDq1xqiGPpG/ZBlH4XAtFrU88aQPncGUlezgssBS7eq1Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788355032; c=relaxed/simple;
	bh=9bt6NMV9ceOL/vjGrcjGG7cSY+UGf1eV85GtEuj2XLE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H8uSJHvb8eYHp4xM0kpXtWHUB2qh6Dsuhrfa5pH9G9t9/VHjUS/JaSpQr2xkfDF10hKQoM+bCtPxNVRvdhm6IPdZqyFDrRRHmUs6nSBTFsaYIOm0f9M3dxM+tTV2lrJsKKg8Q+nODjOcgxEMfBdierB0Fw858kHPuJR6tK5Coxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=4yWgN6Ji; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="4yWgN6Ji"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FMutdLgk3E5wynZZWQtCn7gpgPrrKwjYS6nAK+VT9Fs=;
	b=4yWgN6Ji+pHgL66Tyv+Pt77YqPukAmGoBSzl5v4R65ckzp0UVzPnbqeLlchftp40qqfRVot4Z
	2ZRwspAsOcgeVFqX5YMlApaiQQg/fJWcH8YGibc2ccDZmQbhIqZs3Xi5VBZWOy5hjR2dtHz41FH
	sKO8x2guDQ5cD05eT0Grjig=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hZjf81NP9z1cyPY;
	Wed,  2 Sep 2026 21:06:08 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 9CB424057C;
	Wed,  2 Sep 2026 21:16:57 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 2 Sep
 2026 21:16:56 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: <brauner@kernel.org>, <djwong@kernel.org>, <cem@kernel.org>,
	<akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <david@kernel.org>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <ljs@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 4/4] mm: replace PF_KCOMPACTD flag with kthread_func() check
Date: Wed, 2 Sep 2026 21:16:53 +0800
Message-ID: <20260902131653.1338227-5-wangkefeng.wang@huawei.com>
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

PF_KCOMPACTD was introduced by commit ce6d9c1c2b5c ("NFS: fix
nfs_release_folio() to not deadlock via kcompactd writeback") so
nfs_release_folio() could detect kcompactd context and skip
writeback.  The flag is only consumed by current_is_kcompactd(),
whose sole caller is nfs_release_folio().

Replace the flag-based check with kthread_func(current) == kcompactd,
freeing the 0x00010000 PF flag bit.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/compaction.h               | 11 ++++++-----
 include/linux/sched.h                    |  2 +-
 mm/compaction.c                          |  9 ++++++---
 tools/sched_ext/include/scx/common.bpf.h |  1 -
 4 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index 66a2f70e9e01..691c09f0a697 100644
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -81,10 +81,6 @@ static inline unsigned long compact_gap(unsigned int order)
 	return min(2UL << order, COMPACT_CLUSTER_MAX);
 }
 
-static inline int current_is_kcompactd(void)
-{
-	return current->flags & PF_KCOMPACTD;
-}
 
 #ifdef CONFIG_COMPACTION
 
@@ -103,7 +99,7 @@ extern void compaction_defer_reset(struct zone *zone, int order,
 
 bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
 					int alloc_flags, gfp_t gfp_mask);
-
+bool current_is_kcompactd(void);
 extern void __meminit kcompactd_run(int nid);
 extern void __meminit kcompactd_stop(int nid);
 extern void wakeup_kcompactd(pg_data_t *pgdat, int order, int highest_zoneidx);
@@ -120,6 +116,11 @@ static inline bool compaction_suitable(struct zone *zone, int order,
 	return false;
 }
 
+static inline bool current_is_kcompactd(void)
+{
+	return false;
+}
+
 static inline void kcompactd_run(int nid)
 {
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 86394121b6c0..eb12ff4cea6c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1808,7 +1808,7 @@ extern struct pid *cad_pid;
 #define PF_USED_MATH		0x00002000	/* If unset the fpu must be initialized before use */
 #define PF_USER_WORKER		0x00004000	/* Kernel thread cloned from userspace thread */
 #define PF_NOFREEZE		0x00008000	/* This thread should not be frozen */
-#define PF_KCOMPACTD		0x00010000	/* I am kcompactd */
+#define PF__HOLE__00010000	0x00010000
 #define PF__HOLE__00020000	0x00020000
 #define PF_MEMALLOC_NOFS	0x00040000	/* All allocations inherit GFP_NOFS. See memalloc_nfs_save() */
 #define PF_MEMALLOC_NOIO	0x00080000	/* All allocations inherit GFP_NOIO. See memalloc_noio_save() */
diff --git a/mm/compaction.c b/mm/compaction.c
index a049415512c6..4994e200bbec 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -3197,7 +3197,6 @@ static int kcompactd(void *p)
 	long default_timeout = msecs_to_jiffies(HPAGE_FRAG_CHECK_INTERVAL_MSEC);
 	long timeout = default_timeout;
 
-	current->flags |= PF_KCOMPACTD;
 	set_freezable();
 
 	pgdat->kcompactd_max_order = 0;
@@ -3254,11 +3253,15 @@ static int kcompactd(void *p)
 			pgdat->proactive_compact_trigger = false;
 	}
 
-	current->flags &= ~PF_KCOMPACTD;
-
 	return 0;
 }
 
+bool current_is_kcompactd(void)
+{
+	return kthread_func(current) == kcompactd;
+}
+EXPORT_SYMBOL_GPL(current_is_kcompactd);
+
 /*
  * This kcompactd start function will be called by init and node-hot-add.
  * On node-hot-add, kcompactd will moved to proper cpus if cpus are hot-added.
diff --git a/tools/sched_ext/include/scx/common.bpf.h b/tools/sched_ext/include/scx/common.bpf.h
index 3e095343ae84..807ef881ce2d 100644
--- a/tools/sched_ext/include/scx/common.bpf.h
+++ b/tools/sched_ext/include/scx/common.bpf.h
@@ -31,7 +31,6 @@
 #define PF_IDLE				0x00000002	/* I am an IDLE thread */
 #define PF_IO_WORKER			0x00000010	/* Task is an IO worker */
 #define PF_WQ_WORKER			0x00000020	/* I'm a workqueue worker */
-#define PF_KCOMPACTD			0x00010000      /* I am kcompactd */
 #define PF_KTHREAD			0x00200000	/* I am a kernel thread */
 #define PF_EXITING			0x00000004
 #define CLOCK_MONOTONIC			1
-- 
2.55.0

