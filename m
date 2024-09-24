Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B3E1AC898;
	Tue, 24 Sep 2024 18:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203143; cv=none; b=J55C13Bs5NgGM50JeBP1DtbKmDW0YBM/7iSi5krpMB89ANavT9Ff1m3Au60pFtnDgvzLWvxhJhit8ny6HmDiNGLXh2zthjmVQK8AgTvZpZ4+J+VL+P2tWkBK/d2LOB2EQ2g21oFmm8/Wr7Ve/Fgl/lC0wRphK2FBZBZ1hi670+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203143; c=relaxed/simple;
	bh=5/evbgZJpBDHqo8Z6QJmTNsvi1Z9bsk7VzcU+ReHC5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/rWUFCb45uNUape9dmL4KYQBNqTb8p5melRBonCGyviU0YmO1TIf3ThaZj0K8NU99qKwJOyT6UyPKbeKj26Jjx7p4QVsodOIabp+lTrVKO0mzc1Rkm3Dd0+Jyy6e1zxa8W54kum9ByURM7rTy2ryZM3hX4v9/yVwrP9fjzrIjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d42aQIN5; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d42aQIN5"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2d87176316eso126793a91.0;
        Tue, 24 Sep 2024 11:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203141; x=1727807941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ZRLOpJJYBLWAfm8yXjQKXJS6QubtWuMo+I+IUyXbVQ=;
        b=d42aQIN5BwKJLoZUMOTOBrUhBzUq9ZOoppW8fG3iD61ryPHqN4hjll+Ygyf6am21Ut
         WclhAd6KMTmv3K+U4ZF30A0aYguxWIPPRNF7MQc5kXlnq7UPR1dMrq4B8ffH+0UMzVmE
         0cSoNogT/ZR5wb9OJCxeevpVBZyMgrz4JvKm/alNwwpzU3XyXXLWUUO31vVy1ZeggXS/
         RtKbMvsHkLpfLRdhKvDUY475IH9raRfcIMRVhGWLWUTBNgjpOjlpkdCIqsUPbX5zqoyn
         lgIP+SOpBUIsYKCfIJEfAKAfqi+O4smDVL/lxzBEK8GSjXokmOwcdcB3PwnSxu8JeTQ7
         xdNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203141; x=1727807941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ZRLOpJJYBLWAfm8yXjQKXJS6QubtWuMo+I+IUyXbVQ=;
        b=jXWp7GEm/wO1krDuttg/MjxHZpM15zpPb2C20nddIEDKS7QvV+DRed+9AAe94IkL+j
         I0JI8KrvHlnMeocFghBGT3+6pSCADugQy5BRa6iTIx9cEMe5UnqZi8JoQp1IaytGQ0oY
         qT8pDG2NgAdAPo8CO3+GwPVJKm2QZ7dd5tMWFbuEMUkKRoEe5D5K75mk3icpqpqIIsb9
         aYmwL/WUWLK4+FHY/MhwB8CWU+w1o001y717bOm/EiA1Sa18YbEXKVWt96us/5R6N65Q
         tyzebNNkSclzq7N3FjJ1sukeK7lOCjBziSUGeqVv7ygVmiSWWOkFa3dNg9kuckrUJ+WX
         5gcA==
X-Gm-Message-State: AOJu0YwOYoPhJABZn1g2sCHwyyGnttyiMFbgFZZwqTV7kYBRgFYJBhPJ
	ScOUJluj33p3/+Vr/dEw6G44HNhRnCl2cnQRIVgg9moU6lRmLeRux/bOND7Q
X-Google-Smtp-Source: AGHT+IGgs00Oed+XnEr+N2n8jAufX9x4DAAPkzn/VHK4zxoyzLNGLvMa9biK7kRvu1grdzmc5emOZQ==
X-Received: by 2002:a17:90b:17c5:b0:2d8:e6d8:14c8 with SMTP id 98e67ed59e1d1-2e06ac38666mr232684a91.15.1727203140375;
        Tue, 24 Sep 2024 11:39:00 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:38:59 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	Wu Guanghao <wuguanghao3@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 02/26] xfs: Fix deadlock on xfs_inodegc_worker
Date: Tue, 24 Sep 2024 11:38:27 -0700
Message-ID: <20240924183851.1901667-3-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
In-Reply-To: <20240924183851.1901667-1-leah.rumancik@gmail.com>
References: <20240924183851.1901667-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wu Guanghao <wuguanghao3@huawei.com>

[ Upstream commit 4da112513c01d7d0acf1025b8764349d46e177d6 ]

We are doing a test about deleting a large number of files
when memory is low. A deadlock problem was found.

[ 1240.279183] -> #1 (fs_reclaim){+.+.}-{0:0}:
[ 1240.280450]        lock_acquire+0x197/0x460
[ 1240.281548]        fs_reclaim_acquire.part.0+0x20/0x30
[ 1240.282625]        kmem_cache_alloc+0x2b/0x940
[ 1240.283816]        xfs_trans_alloc+0x8a/0x8b0
[ 1240.284757]        xfs_inactive_ifree+0xe4/0x4e0
[ 1240.285935]        xfs_inactive+0x4e9/0x8a0
[ 1240.286836]        xfs_inodegc_worker+0x160/0x5e0
[ 1240.287969]        process_one_work+0xa19/0x16b0
[ 1240.289030]        worker_thread+0x9e/0x1050
[ 1240.290131]        kthread+0x34f/0x460
[ 1240.290999]        ret_from_fork+0x22/0x30
[ 1240.291905]
[ 1240.291905] -> #0 ((work_completion)(&gc->work)){+.+.}-{0:0}:
[ 1240.293569]        check_prev_add+0x160/0x2490
[ 1240.294473]        __lock_acquire+0x2c4d/0x5160
[ 1240.295544]        lock_acquire+0x197/0x460
[ 1240.296403]        __flush_work+0x6bc/0xa20
[ 1240.297522]        xfs_inode_mark_reclaimable+0x6f0/0xdc0
[ 1240.298649]        destroy_inode+0xc6/0x1b0
[ 1240.299677]        dispose_list+0xe1/0x1d0
[ 1240.300567]        prune_icache_sb+0xec/0x150
[ 1240.301794]        super_cache_scan+0x2c9/0x480
[ 1240.302776]        do_shrink_slab+0x3f0/0xaa0
[ 1240.303671]        shrink_slab+0x170/0x660
[ 1240.304601]        shrink_node+0x7f7/0x1df0
[ 1240.305515]        balance_pgdat+0x766/0xf50
[ 1240.306657]        kswapd+0x5bd/0xd20
[ 1240.307551]        kthread+0x34f/0x460
[ 1240.308346]        ret_from_fork+0x22/0x30
[ 1240.309247]
[ 1240.309247] other info that might help us debug this:
[ 1240.309247]
[ 1240.310944]  Possible unsafe locking scenario:
[ 1240.310944]
[ 1240.312379]        CPU0                    CPU1
[ 1240.313363]        ----                    ----
[ 1240.314433]   lock(fs_reclaim);
[ 1240.315107]                                lock((work_completion)(&gc->work));
[ 1240.316828]                                lock(fs_reclaim);
[ 1240.318088]   lock((work_completion)(&gc->work));
[ 1240.319203]
[ 1240.319203]  *** DEADLOCK ***
...
[ 2438.431081] Workqueue: xfs-inodegc/sda xfs_inodegc_worker
[ 2438.432089] Call Trace:
[ 2438.432562]  __schedule+0xa94/0x1d20
[ 2438.435787]  schedule+0xbf/0x270
[ 2438.436397]  schedule_timeout+0x6f8/0x8b0
[ 2438.445126]  wait_for_completion+0x163/0x260
[ 2438.448610]  __flush_work+0x4c4/0xa40
[ 2438.455011]  xfs_inode_mark_reclaimable+0x6ef/0xda0
[ 2438.456695]  destroy_inode+0xc6/0x1b0
[ 2438.457375]  dispose_list+0xe1/0x1d0
[ 2438.458834]  prune_icache_sb+0xe8/0x150
[ 2438.461181]  super_cache_scan+0x2b3/0x470
[ 2438.461950]  do_shrink_slab+0x3cf/0xa50
[ 2438.462687]  shrink_slab+0x17d/0x660
[ 2438.466392]  shrink_node+0x87e/0x1d40
[ 2438.467894]  do_try_to_free_pages+0x364/0x1300
[ 2438.471188]  try_to_free_pages+0x26c/0x5b0
[ 2438.473567]  __alloc_pages_slowpath.constprop.136+0x7aa/0x2100
[ 2438.482577]  __alloc_pages+0x5db/0x710
[ 2438.485231]  alloc_pages+0x100/0x200
[ 2438.485923]  allocate_slab+0x2c0/0x380
[ 2438.486623]  ___slab_alloc+0x41f/0x690
[ 2438.490254]  __slab_alloc+0x54/0x70
[ 2438.491692]  kmem_cache_alloc+0x23e/0x270
[ 2438.492437]  xfs_trans_alloc+0x88/0x880
[ 2438.493168]  xfs_inactive_ifree+0xe2/0x4e0
[ 2438.496419]  xfs_inactive+0x4eb/0x8b0
[ 2438.497123]  xfs_inodegc_worker+0x16b/0x5e0
[ 2438.497918]  process_one_work+0xbf7/0x1a20
[ 2438.500316]  worker_thread+0x8c/0x1060
[ 2438.504938]  ret_from_fork+0x22/0x30

When the memory is insufficient, xfs_inonodegc_worker will trigger memory
reclamation when memory is allocated, then flush_work() may be called to
wait for the work to complete. This causes a deadlock.

So use memalloc_nofs_save() to avoid triggering memory reclamation in
xfs_inodegc_worker.

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_icache.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index dd5a664c294f..f5568fa54039 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1858,6 +1858,7 @@ xfs_inodegc_worker(
 						struct xfs_inodegc, work);
 	struct llist_node	*node = llist_del_all(&gc->list);
 	struct xfs_inode	*ip, *n;
+	unsigned int		nofs_flag;
 
 	ASSERT(gc->cpu == smp_processor_id());
 
@@ -1866,6 +1867,13 @@ xfs_inodegc_worker(
 	if (!node)
 		return;
 
+	/*
+	 * We can allocate memory here while doing writeback on behalf of
+	 * memory reclaim.  To avoid memory allocation deadlocks set the
+	 * task-wide nofs context for the following operations.
+	 */
+	nofs_flag = memalloc_nofs_save();
+
 	ip = llist_entry(node, struct xfs_inode, i_gclist);
 	trace_xfs_inodegc_worker(ip->i_mount, READ_ONCE(gc->shrinker_hits));
 
@@ -1874,6 +1882,8 @@ xfs_inodegc_worker(
 		xfs_iflags_set(ip, XFS_INACTIVATING);
 		xfs_inodegc_inactivate(ip);
 	}
+
+	memalloc_nofs_restore(nofs_flag);
 }
 
 /*
-- 
2.46.0.792.g87dc391469-goog

