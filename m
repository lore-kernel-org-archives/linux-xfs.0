Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99200C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Sep 2021 05:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E9BC6108E
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Sep 2021 05:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhIGF6i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Sep 2021 01:58:38 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:31532 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbhIGF6c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Sep 2021 01:58:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630994246; x=1662530246;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OKrrjd5/k06akLaoTcfUXhPC0E5xy6Ir73X/CYOw89Q=;
  b=LAnoRLmyeuT85a/3lMm7RHn8bhNBPNWcRHOHLMG/IO0X5l7fwpMXceMg
   npp+i+bLcPHaCW9FzUVjPOicW5ftffoSVp8FeV0byklHFipGoDEji/3eC
   lSVh6Bslr4SvWchQcgfYvVJGfGuuDiYXyqxU+Gu+27EbxbQnL+iTSeE3v
   up69k5Gda7qaLOc3l2aMMQdxZba2KZ4ku3GPbbXi6puOM2dhA1lTWH+uV
   i6mUSeHn9DfcIXjNUPAVRnycioC78UfCVO20+W6cVlvSdAVyeTOc7wIFj
   2y6d3iG2e+ckbDxyEnKuKYk+6JxOf/k8RdaBvMe3ldgb1oII3cLTv/KgW
   g==;
X-IronPort-AV: E=Sophos;i="5.85,274,1624291200"; 
   d="scan'208";a="283140188"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Sep 2021 13:57:25 +0800
IronPort-SDR: 69v33UjgevRDlYTx8A8zq3BYKhQH3+/vT2hQBXKGNU5tRR4w0hZhmh594QbiwDksN1MpCQi2eh
 mGu4sLTRSpK4qUi+C53puAu0yvANm1JrGPx7yjpNC2RgGSBOMsZhFbr7LeB82YGQZOKcMgFQJR
 TtGpc6PrmogVZeSBnVZuKIuPibjvbY/vSUOMbozGsNH7ibf11IScuCLVvzerZ27U6GURL9/lbv
 ozmjZ6Wx87of91zOMUUQCBAfu3HAR010IRy8KKl40mx3FzFJVSOga6mWtHbCb4xWb71A4AYc0B
 Hj4hkDMALwmD3JqzWQ7yA2ne
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2021 22:32:24 -0700
IronPort-SDR: 2fHs2u0F9TaKHNkAk6xLEH5I74JO0rwGC1Ose72vkKLdk4vtXXft64/sF5+kalOwJIXZ2hvJ2v
 sKwFYTJfkn83pod1D5zUjRBtFtzrXX8SSIEFoxf+v+qLmcm7YGoKpEueAMPgBKzCUhNi2eGkX7
 N0fLXnSByEsKvm5Dw9MrdnrVphruJlM0eI+eLE/wN8iyTvFMiisjM/T/qC/XsqDX2A/uKYoK0t
 nG96DWLU6ny3M3B84uN+lR39lXwv6PSXHsdXsvflDpQFth2x5tscHID/giJpxgOjpXjYSNsFZv
 4rs=
WDCIronportException: Internal
Received: from jpf009007.ad.shared (HELO naota-xeon.wdc.com) ([10.225.51.79])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Sep 2021 22:57:24 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     Catalin Marinas <catalin.marinas@arm.com>, linux-mm@kvack.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH] mm/kmemleak: allow __GFP_NOLOCKDEP passed to kmemleak's gfp
Date:   Tue,  7 Sep 2021 14:56:59 +0900
Message-Id: <20210907055659.3182992-1-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In a memory pressure situation, I'm seeing the lockdep WARNING below.
Actually, this is similar to a known false positive which is already
addressed by commit 6dcde60efd94 ("xfs: more lockdep whackamole with
kmem_alloc*").

This warning still persists because it's not from kmalloc() itself but
from an allocation for kmemleak object. While kmalloc() itself suppress
the warning with __GFP_NOLOCKDEP, gfp_kmemleak_mask() is dropping the
flag for the kmemleak's allocation.

Allow __GFP_NOLOCKDEP to be passed to kmemleak's allocation, so that the
warning for it is also suppressed.

  ======================================================
  WARNING: possible circular locking dependency detected
  5.14.0-rc7-BTRFS-ZNS+ #37 Not tainted
  ------------------------------------------------------
  kswapd0/288 is trying to acquire lock:
  ffff88825ab45df0 (&xfs_nondir_ilock_class){++++}-{3:3}, at: xfs_ilock+0x8a/0x250

  but task is already holding lock:
  ffffffff848cc1e0 (fs_reclaim){+.+.}-{0:0}, at: __fs_reclaim_acquire+0x5/0x30

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #1 (fs_reclaim){+.+.}-{0:0}:
         fs_reclaim_acquire+0x112/0x160
         kmem_cache_alloc+0x48/0x400
         create_object.isra.0+0x42/0xb10
         kmemleak_alloc+0x48/0x80
         __kmalloc+0x228/0x440
         kmem_alloc+0xd3/0x2b0
         kmem_alloc_large+0x5a/0x1c0
         xfs_attr_copy_value+0x112/0x190
         xfs_attr_shortform_getvalue+0x1fc/0x300
         xfs_attr_get_ilocked+0x125/0x170
         xfs_attr_get+0x329/0x450
         xfs_get_acl+0x18d/0x430
         get_acl.part.0+0xb6/0x1e0
         posix_acl_xattr_get+0x13a/0x230
         vfs_getxattr+0x21d/0x270
         getxattr+0x126/0x310
         __x64_sys_fgetxattr+0x1a6/0x2a0
         do_syscall_64+0x3b/0x90
         entry_SYSCALL_64_after_hwframe+0x44/0xae

  -> #0 (&xfs_nondir_ilock_class){++++}-{3:3}:
         __lock_acquire+0x2c0f/0x5a00
         lock_acquire+0x1a1/0x4b0
         down_read_nested+0x50/0x90
         xfs_ilock+0x8a/0x250
         xfs_can_free_eofblocks+0x34f/0x570
         xfs_inactive+0x411/0x520
         xfs_fs_destroy_inode+0x2c8/0x710
         destroy_inode+0xc5/0x1a0
         evict+0x444/0x620
         dispose_list+0xfe/0x1c0
         prune_icache_sb+0xdc/0x160
         super_cache_scan+0x31e/0x510
         do_shrink_slab+0x337/0x8e0
         shrink_slab+0x362/0x5c0
         shrink_node+0x7a7/0x1a40
         balance_pgdat+0x64e/0xfe0
         kswapd+0x590/0xa80
         kthread+0x38c/0x460
         ret_from_fork+0x22/0x30

  other info that might help us debug this:
   Possible unsafe locking scenario:
         CPU0                    CPU1
         ----                    ----
    lock(fs_reclaim);
                                 lock(&xfs_nondir_ilock_class);
                                 lock(fs_reclaim);
    lock(&xfs_nondir_ilock_class);

   *** DEADLOCK ***
  3 locks held by kswapd0/288:
   #0: ffffffff848cc1e0 (fs_reclaim){+.+.}-{0:0}, at: __fs_reclaim_acquire+0x5/0x30
   #1: ffffffff848a08d8 (shrinker_rwsem){++++}-{3:3}, at: shrink_slab+0x269/0x5c0
   #2: ffff8881a7a820e8 (&type->s_umount_key#60){++++}-{3:3}, at: super_cache_scan+0x5a/0x510

Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 mm/kmemleak.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 73d46d16d575..1f4868cbba22 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -113,7 +113,8 @@
 #define BYTES_PER_POINTER	sizeof(void *)
 
 /* GFP bitmask for kmemleak internal allocations */
-#define gfp_kmemleak_mask(gfp)	(((gfp) & (GFP_KERNEL | GFP_ATOMIC)) | \
+#define gfp_kmemleak_mask(gfp)	(((gfp) & (GFP_KERNEL | GFP_ATOMIC | \
+					   __GFP_NOLOCKDEP)) | \
 				 __GFP_NORETRY | __GFP_NOMEMALLOC | \
 				 __GFP_NOWARN)
 
-- 
2.33.0

