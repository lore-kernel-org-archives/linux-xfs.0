Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740D617BEC1
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560515; cv=none; b=t/gfux88aiVywx4IDSoMW1/hEoUUpVs2vls/nRzGxNQ8B+3A9aGhp5+UCHJIqQPdlAVGBnFrDjwhNzTr0EhH4tMhXLJoF0g4e7WmErnSoEGGBe62fEqfxzZMqfJQAgnzOChSGfTejilVu6FafL9YiqLFFg3hpI/Pwi4L2prjlHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560515; c=relaxed/simple;
	bh=3SWavtPxKwtYrAcbNdUS6BZdFZuaQnzQYdrYu9pISz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPjQ/EvpbFG7je2+I74Fh5nHoOnOBvA05FhRVrpC9fSkww2A0zTywfe9F2x9RFc1bK6n3qQBx49N5J7vp9clSFooS0lqZcAVP+OTbsves/ywqD/HM3+s5mSQBayNefGHG0ePU9bBfrxY424V7GussKc/2kv9NeysRZ0e2SzrHA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EaGMBc74; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EaGMBc74"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2057835395aso11023225ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560513; x=1726165313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D9ROGkXsssELCpFIc+wpYnNlFRb4wx11f/vrf8GjhkI=;
        b=EaGMBc74LpSmRIV410BVnt0SWZV/uuA83dY0C6QiF+nsPiLCizz/hb9N4iOp9k1V9Z
         T3kVlV0DsJ57a/ybpbvU2T+lI4aNSdMTo/mS+yAFlFPJ7U1y4yt3cg4QJGQ2ue7dnuh1
         iomcw4r+FUhHt/EDEcEpGF6dQMEbC5WpSaBg0UuVd8WiprclAtG2cDttU26dYO0aAxGM
         W2HQODJNbe8FEQ++IQGTNyi8heQ0K7mgiV7C0f6qVJvK9UqwpSAR2Z14TsdW8xghrQHb
         +LthewRKvuEfAa1NUgc3eUvWjU4UFXBUh+HOvc7jHj7rxgNitEs3kh3ELKL8Xu1WnNKZ
         YmBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560513; x=1726165313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D9ROGkXsssELCpFIc+wpYnNlFRb4wx11f/vrf8GjhkI=;
        b=vQeF9aZ1Y8bde4nKwnQUzJ1Et4J7NwDVpM1Z0dChUdF5FCyIjY+Fn5EaOZbYcz5v+Q
         9JQCWEoKTESIhp9LeFRC0ILBF4GlDPhwH6oy8+4QpyNTM0I5edxn7/sqPA9o7JgzOWFh
         QCI8vInYYKkms2eov5jZ6m+ZxG2vXQKdhjs2yCD/iz4QbXoewVWxk2VIbt3ZdAfZ47Wi
         AgQubzD0F2Gd5bsV05NzszeG1h58xiCIXavmCAyJSJptCJDvCDZ0EOJgx90ZyApYgDi5
         PT9bcpJvDDQTr23DKS9cp6iv2hzeCr1WT32/HGvQb6OShadvC+41Qs96t+yP+BI6+X+D
         96jw==
X-Gm-Message-State: AOJu0YxCKDxGZQ7EZGV154Df08rPAJic2j/C1zYcwgdTE0fRFg4umdis
	2nCTDOSjYA4zfQiUREQ/5FKqC12MAaBq7xaj72dglQdw0n5x6ap2AKdjnnzv
X-Google-Smtp-Source: AGHT+IEftiwE6wXigV6Bs0JBxoW/je5Iz+AxK0sSulWHCWqBZ46+Dd8iFV8NH2fESPbctFly+ET1HQ==
X-Received: by 2002:a17:902:daca:b0:205:5d12:3f24 with SMTP id d9443c01a7336-2055d12474cmr143702615ad.20.1725560513661;
        Thu, 05 Sep 2024 11:21:53 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:21:53 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	Wu Guanghao <wuguanghao3@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 02/26] xfs: Fix deadlock on xfs_inodegc_worker
Date: Thu,  5 Sep 2024 11:21:19 -0700
Message-ID: <20240905182144.2691920-3-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905182144.2691920-1-leah.rumancik@gmail.com>
References: <20240905182144.2691920-1-leah.rumancik@gmail.com>
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
2.46.0.598.g6f2099f65c-goog

