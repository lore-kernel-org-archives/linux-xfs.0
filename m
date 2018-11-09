Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f169.google.com ([209.85.214.169]:46203 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727979AbeKJJGf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Nov 2018 04:06:35 -0500
From: hmsjwzb <weizhefix@gmail.com>
Subject: [PATCH] Fix misspelling issue in fs/xfs/kmem.c
Date: Sat, 10 Nov 2018 07:23:01 +0800
Message-Id: <20181109232301.19977-1-weizhefix@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: darrick.wong@oracle.com, hmsjwzb <weizhefix@gmail.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

---
 fs/xfs/kmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index fdd9d6ede25c..73ec1f84e591 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -45,7 +45,7 @@ kmem_alloc_large(size_t size, xfs_km_flags_t flags)
 		return ptr;
 
 	/*
-	 * __vmalloc() will allocate data pages and auxillary structures (e.g.
+	 * __vmalloc() will allocate data pages and auxiliary structures (e.g.
 	 * pagetables) with GFP_KERNEL, yet we may be under GFP_NOFS context
 	 * here. Hence we need to tell memory reclaim that we are in such a
 	 * context via PF_MEMALLOC_NOFS to prevent memory reclaim re-entering
-- 
2.17.1
