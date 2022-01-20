Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E5BC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357760AbiATA0y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:26:54 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33900 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbiATA0x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:26:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D1C8614DF
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61E8C004E1;
        Thu, 20 Jan 2022 00:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638412;
        bh=Sfk8IugcCE+lPEe09oy9mYurradEL30eimntCy5rr4g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UoDS57RAxQTDRuAtQ3FrVQvBmOBKLBulUC6DZXx7zmg4TkvrB3xmLG6m35wyieJV1
         NhJXDj0sfs8hVJgOq89+TQvjLRwuoon2yQeV1il1ER95WT8o33eFs8AUwVh/7OHque
         Ch8pBITaO4uL+L0N9d+lwc6iaAfLU1i/SroU3wjRku170c6zcCo9na3i9ILBDJ30UJ
         nANAUIIqcl8JS5qGZiZ5pwj8n1vH29sQc/xufZ1H3FBKhK21AfGqE+CL9vPEZ+MdbP
         54sHbUR7cNJRnwpEyyWdiiZKbCNofihVlKYIv/EctZpk65W1Zt1KorfD7fr3+16SKl
         m5+IHWeXNQbgg==
Subject: [PATCH 40/48] libxfs: change zone to cache for all kmem functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:26:52 -0800
Message-ID: <164263841243.865554.8105465319420120565.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Finish our zone->cache conversion by changing the field names and local
variables in kmem.[ch].

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/kmem.h |    8 ++++----
 libxfs/init.c  |    6 +++---
 libxfs/kmem.c  |   40 ++++++++++++++++++++--------------------
 3 files changed, 27 insertions(+), 27 deletions(-)


diff --git a/include/kmem.h b/include/kmem.h
index 7aba4914..fd90a1bc 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -15,10 +15,10 @@ bool kmem_found_leaks(void);
 #define KM_NOLOCKDEP	0x0020u
 
 struct kmem_cache {
-	int		zone_unitsize;	/* Size in bytes of zone unit */
+	int		cache_unitsize;	/* Size in bytes of cache unit */
 	int		allocated;	/* debug: How many allocated? */
 	unsigned int	align;
-	const char	*zone_name;	/* tag name */
+	const char	*cache_name;	/* tag name */
 	void		(*ctor)(void *);
 };
 
@@ -40,9 +40,9 @@ extern void	*kmem_cache_alloc(struct kmem_cache *, gfp_t);
 extern void	*kmem_cache_zalloc(struct kmem_cache *, gfp_t);
 
 static inline void
-kmem_cache_free(struct kmem_cache *zone, void *ptr)
+kmem_cache_free(struct kmem_cache *cache, void *ptr)
 {
-	zone->allocated--;
+	cache->allocated--;
 	free(ptr);
 }
 
diff --git a/libxfs/init.c b/libxfs/init.c
index 1978a01f..b0be28e3 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -226,14 +226,14 @@ check_open(char *path, int flags, char **rawfile, char **blockfile)
 }
 
 /*
- * Initialize/destroy all of the zone allocators we use.
+ * Initialize/destroy all of the cache allocators we use.
  */
 static void
 init_caches(void)
 {
 	int		error;
 
-	/* initialise zone allocation */
+	/* initialise cache allocation */
 	xfs_buf_cache = kmem_cache_create("xfs_buffer",
 			sizeof(struct xfs_buf), 0, 0, NULL);
 	xfs_inode_cache = kmem_cache_create("xfs_inode",
@@ -1028,7 +1028,7 @@ libxfs_destroy(
 	kmem_start_leak_check();
 	libxfs_close_devices(li);
 
-	/* Free everything from the buffer cache before freeing buffer zone */
+	/* Free everything from the buffer cache before freeing buffer cache */
 	libxfs_bcache_purge();
 	libxfs_bcache_free();
 	cache_destroy(libxfs_bcache);
diff --git a/libxfs/kmem.c b/libxfs/kmem.c
index a176a9d8..f4505696 100644
--- a/libxfs/kmem.c
+++ b/libxfs/kmem.c
@@ -25,13 +25,13 @@ kmem_cache_create(const char *name, unsigned int size, unsigned int align,
 	struct kmem_cache	*ptr = malloc(sizeof(struct kmem_cache));
 
 	if (ptr == NULL) {
-		fprintf(stderr, _("%s: zone init failed (%s, %d bytes): %s\n"),
+		fprintf(stderr, _("%s: cache init failed (%s, %d bytes): %s\n"),
 			progname, name, (int)sizeof(struct kmem_cache),
 			strerror(errno));
 		exit(1);
 	}
-	ptr->zone_unitsize = size;
-	ptr->zone_name = name;
+	ptr->cache_unitsize = size;
+	ptr->cache_name = name;
 	ptr->allocated = 0;
 	ptr->align = align;
 	ptr->ctor = ctor;
@@ -40,50 +40,50 @@ kmem_cache_create(const char *name, unsigned int size, unsigned int align,
 }
 
 void
-kmem_cache_destroy(struct kmem_cache *zone)
+kmem_cache_destroy(struct kmem_cache *cache)
 {
-	if (getenv("LIBXFS_LEAK_CHECK") && zone->allocated) {
+	if (getenv("LIBXFS_LEAK_CHECK") && cache->allocated) {
 		leaked = true;
-		fprintf(stderr, "zone %s freed with %d items allocated\n",
-				zone->zone_name, zone->allocated);
+		fprintf(stderr, "cache %s freed with %d items allocated\n",
+				cache->cache_name, cache->allocated);
 	}
-	free(zone);
+	free(cache);
 }
 
 void *
-kmem_cache_alloc(struct kmem_cache *zone, gfp_t flags)
+kmem_cache_alloc(struct kmem_cache *cache, gfp_t flags)
 {
 	void	*ptr = NULL;
 
-	if (zone->align) {
+	if (cache->align) {
 		int ret;
 
-		ret = posix_memalign(&ptr, zone->align, zone->zone_unitsize);
+		ret = posix_memalign(&ptr, cache->align, cache->cache_unitsize);
 		if (ret)
 			errno = ret;
 	} else {
-		ptr = malloc(zone->zone_unitsize);
+		ptr = malloc(cache->cache_unitsize);
 	}
 
 	if (ptr == NULL) {
-		fprintf(stderr, _("%s: zone alloc failed (%s, %d bytes): %s\n"),
-			progname, zone->zone_name, zone->zone_unitsize,
+		fprintf(stderr, _("%s: cache alloc failed (%s, %d bytes): %s\n"),
+			progname, cache->cache_name, cache->cache_unitsize,
 			strerror(errno));
 		exit(1);
 	}
 
-	if (zone->ctor)
-		zone->ctor(ptr);
-	zone->allocated++;
+	if (cache->ctor)
+		cache->ctor(ptr);
+	cache->allocated++;
 	return ptr;
 }
 
 void *
-kmem_cache_zalloc(struct kmem_cache *zone, gfp_t flags)
+kmem_cache_zalloc(struct kmem_cache *cache, gfp_t flags)
 {
-	void	*ptr = kmem_cache_alloc(zone, flags);
+	void	*ptr = kmem_cache_alloc(cache, flags);
 
-	memset(ptr, 0, zone->zone_unitsize);
+	memset(ptr, 0, cache->cache_unitsize);
 	return ptr;
 }
 

