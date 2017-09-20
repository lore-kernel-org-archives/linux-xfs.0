Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:52544 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751724AbdITUp7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2017 16:45:59 -0400
Received: by mail-pg0-f51.google.com with SMTP id i195so2326149pgd.9
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2017 13:45:59 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v3 03/31] usercopy: Mark kmalloc caches as usercopy caches
Date: Wed, 20 Sep 2017 13:45:09 -0700
Message-Id: <1505940337-79069-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1505940337-79069-1-git-send-email-keescook@chromium.org>
References: <1505940337-79069-1-git-send-email-keescook@chromium.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, David Windsor <dave@nullcore.net>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, kernel-hardening@lists.openwall.com

From: David Windsor <dave@nullcore.net>

Mark the kmalloc slab caches as entirely whitelisted. These caches
are frequently used to fulfill kernel allocations that contain data
to be copied to/from userspace. Internal-only uses are also common,
but are scattered in the kernel. For now, mark all the kmalloc caches
as whitelisted.

This patch is modified from Brad Spengler/PaX Team's PAX_USERCOPY
whitelisting code in the last public patch of grsecurity/PaX based on my
understanding of the code. Changes or omissions from the original code are
mine and don't reflect the original grsecurity/PaX code.

Signed-off-by: David Windsor <dave@nullcore.net>
[kees: merged in moved kmalloc hunks, adjust commit log]
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-xfs@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 mm/slab.c        |  3 ++-
 mm/slab.h        |  3 ++-
 mm/slab_common.c | 10 ++++++----
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index df268999cf02..9af16f675927 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1291,7 +1291,8 @@ void __init kmem_cache_init(void)
 	 */
 	kmalloc_caches[INDEX_NODE] = create_kmalloc_cache(
 				kmalloc_info[INDEX_NODE].name,
-				kmalloc_size(INDEX_NODE), ARCH_KMALLOC_FLAGS);
+				kmalloc_size(INDEX_NODE), ARCH_KMALLOC_FLAGS,
+				0, kmalloc_size(INDEX_NODE));
 	slab_state = PARTIAL_NODE;
 	setup_kmalloc_cache_index_table();
 
diff --git a/mm/slab.h b/mm/slab.h
index 044755ff9632..2e0fe357d777 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -97,7 +97,8 @@ struct kmem_cache *kmalloc_slab(size_t, gfp_t);
 extern int __kmem_cache_create(struct kmem_cache *, unsigned long flags);
 
 extern struct kmem_cache *create_kmalloc_cache(const char *name, size_t size,
-			unsigned long flags);
+			unsigned long flags, size_t useroffset,
+			size_t usersize);
 extern void create_boot_cache(struct kmem_cache *, const char *name,
 			size_t size, unsigned long flags, size_t useroffset,
 			size_t usersize);
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 36408f5f2a34..d4e6442f9bbc 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -920,14 +920,15 @@ void __init create_boot_cache(struct kmem_cache *s, const char *name, size_t siz
 }
 
 struct kmem_cache *__init create_kmalloc_cache(const char *name, size_t size,
-				unsigned long flags)
+				unsigned long flags, size_t useroffset,
+				size_t usersize)
 {
 	struct kmem_cache *s = kmem_cache_zalloc(kmem_cache, GFP_NOWAIT);
 
 	if (!s)
 		panic("Out of memory when creating slab %s\n", name);
 
-	create_boot_cache(s, name, size, flags, 0, size);
+	create_boot_cache(s, name, size, flags, useroffset, usersize);
 	list_add(&s->list, &slab_caches);
 	memcg_link_cache(s);
 	s->refcount = 1;
@@ -1081,7 +1082,8 @@ void __init setup_kmalloc_cache_index_table(void)
 static void __init new_kmalloc_cache(int idx, unsigned long flags)
 {
 	kmalloc_caches[idx] = create_kmalloc_cache(kmalloc_info[idx].name,
-					kmalloc_info[idx].size, flags);
+					kmalloc_info[idx].size, flags, 0,
+					kmalloc_info[idx].size);
 }
 
 /*
@@ -1122,7 +1124,7 @@ void __init create_kmalloc_caches(unsigned long flags)
 
 			BUG_ON(!n);
 			kmalloc_dma_caches[i] = create_kmalloc_cache(n,
-				size, SLAB_CACHE_DMA | flags);
+				size, SLAB_CACHE_DMA | flags, 0, 0);
 		}
 	}
 #endif
-- 
2.7.4

