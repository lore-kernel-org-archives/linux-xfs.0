Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B7348C8AF;
	Wed,  2 Sep 2026 13:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788355027; cv=none; b=kmyrPIgIyJsABhec52E6c9UskuOL+5nJrpjrHZZDzRUitZTpIK4otep1REds1aR5saJwexT3nI0r4ozGvQHqL76QON5nTlyBVf+hQDe06bRDJLyTtcWcT2s88pvmPDoJI6KMdbNuaBZ28I5ZQaT2S0ObUec7+OwHg4X+ZPIGi+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788355027; c=relaxed/simple;
	bh=Y6ZMkcQu7k15mSxiuSv0YF3tYm3dKpM75JU24537c9k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aIGFQHkF/YIotcuqZCTCZfGpwkyUSV/wF2uAQbFu5p5SFTvqP/1QJDDzD6+H2QyT+eN4sNlFxmZKT2vpF+UJbVUp/MHZfxFLCvrATYpuiLUX9buZEEDScaFyCk6CLKp+TuGfVdKw2d5GGWrdQGpoofi+tpf5wvVy0tMu8uRxEnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=VFXbj+lH; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="VFXbj+lH"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ow5+5zT/Qz68HwOR7hge2aByrndRNdMarakE/QBZiCg=;
	b=VFXbj+lHggagP9n/+yQoCKVOFSLN5qmHvAnRjc2SuoDmJBsGdpPCXwi+W2WH7xOFN+Duw+met
	4pa0nh3ChZr4eZ/gMFSfxyKgyVzUWeIRpZU2PL5uAcSir8zGNthTUTV+CBUW+Cfiv++XPqmCWGl
	sjTRNDtuTETjbI1+REajJNU=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hZjf663f0zmV7C;
	Wed,  2 Sep 2026 21:06:06 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 1D00940586;
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
Subject: [PATCH 3/4] mm: replace PF_KSWAPD flag with kthread_func() check
Date: Wed, 2 Sep 2026 21:16:52 +0800
Message-ID: <20260902131653.1338227-4-wangkefeng.wang@huawei.com>
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

The preceding commits removed the last consumer that propagated
PF_KSWAPD beyond kswapd itself (XFS btree split worker inheritance).
The only remaining setter of PF_KSWAPD is kswapd(), and every
current_is_kswapd() caller only needs to check whether the current
task *is* the kswapd thread, not whether it inherited the flag.

Replace the flag-based test with kthread_func(current) == kswapd,
freeing the 0x00020000 PF flag bit.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/sched.h                    |  2 +-
 include/linux/swap.h                     |  7 +------
 mm/vmscan.c                              | 10 ++++++++--
 tools/sched_ext/include/scx/common.bpf.h |  1 -
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8b3d47a325cc..86394121b6c0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1809,7 +1809,7 @@ extern struct pid *cad_pid;
 #define PF_USER_WORKER		0x00004000	/* Kernel thread cloned from userspace thread */
 #define PF_NOFREEZE		0x00008000	/* This thread should not be frozen */
 #define PF_KCOMPACTD		0x00010000	/* I am kcompactd */
-#define PF_KSWAPD		0x00020000	/* I am kswapd */
+#define PF__HOLE__00020000	0x00020000
 #define PF_MEMALLOC_NOFS	0x00040000	/* All allocations inherit GFP_NOFS. See memalloc_nfs_save() */
 #define PF_MEMALLOC_NOIO	0x00080000	/* All allocations inherit GFP_NOIO. See memalloc_noio_save() */
 #define PF_LOCAL_THROTTLE	0x00100000	/* Throttle writes only against the bdi I write to,
diff --git a/include/linux/swap.h b/include/linux/swap.h
index a72ecf12c00d..fc290e29e4a9 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -25,12 +25,6 @@
 #define SWAP_FLAGS_VALID	(SWAP_FLAG_PRIO_MASK | SWAP_FLAG_PREFER | \
 				 SWAP_FLAG_DISCARD | SWAP_FLAG_DISCARD_ONCE | \
 				 SWAP_FLAG_DISCARD_PAGES)
-
-static inline int current_is_kswapd(void)
-{
-	return current->flags & PF_KSWAPD;
-}
-
 /*
  * MAX_SWAPFILES defines the maximum number of swaptypes: things which can
  * be swapped to.  The swap type and the offset into that swap type are
@@ -339,6 +333,7 @@ void check_move_unevictable_folios(struct folio_batch *fbatch);
 
 extern void __meminit kswapd_run(int nid);
 extern void __meminit kswapd_stop(int nid);
+bool current_is_kswapd(void);
 
 #ifdef CONFIG_SWAP
 int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 07ba86634b84..775d3f71a9de 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7468,7 +7468,7 @@ static int kswapd(void *p)
 	 * us from recursively trying to free more memory as we're
 	 * trying to free the first piece of memory in the first place).
 	 */
-	tsk->flags |= PF_MEMALLOC | PF_KSWAPD;
+	tsk->flags |= PF_MEMALLOC;
 	set_freezable();
 
 	WRITE_ONCE(pgdat->kswapd_order, 0);
@@ -7518,11 +7518,17 @@ static int kswapd(void *p)
 			goto kswapd_try_sleep;
 	}
 
-	tsk->flags &= ~(PF_MEMALLOC | PF_KSWAPD);
+	tsk->flags &= ~PF_MEMALLOC;
 
 	return 0;
 }
 
+bool current_is_kswapd(void)
+{
+	return kthread_func(current) == kswapd;
+}
+EXPORT_SYMBOL_GPL(current_is_kswapd);
+
 /*
  * A zone is low on free memory or too fragmented for high-order memory.  If
  * kswapd should reclaim (direct reclaim is deferred), wake it up for the zone's
diff --git a/tools/sched_ext/include/scx/common.bpf.h b/tools/sched_ext/include/scx/common.bpf.h
index 76f5e025e107..3e095343ae84 100644
--- a/tools/sched_ext/include/scx/common.bpf.h
+++ b/tools/sched_ext/include/scx/common.bpf.h
@@ -32,7 +32,6 @@
 #define PF_IO_WORKER			0x00000010	/* Task is an IO worker */
 #define PF_WQ_WORKER			0x00000020	/* I'm a workqueue worker */
 #define PF_KCOMPACTD			0x00010000      /* I am kcompactd */
-#define PF_KSWAPD			0x00020000      /* I am kswapd */
 #define PF_KTHREAD			0x00200000	/* I am a kernel thread */
 #define PF_EXITING			0x00000004
 #define CLOCK_MONOTONIC			1
-- 
2.55.0

