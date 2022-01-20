Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35601C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344774AbiATA00 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:26:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbiATA00 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:26:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3578EC061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:26:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6B2261511
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274D8C004E1;
        Thu, 20 Jan 2022 00:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638385;
        bh=fY9WkZ6L+oIaIsdiwbHYtPXBKc+S93y2WmghOWclxvY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=i9Wd9VeazAuzpLAuHzcwv2DbrM4/TlLAz1EzWcN8G0wnZWyULLUvV7wiXR4COLvT5
         BNSbF2UriK9jLgQpflB3Fd8l6c1ueqqCaBuEPPwGrxPoVLKM7/xHKpJtf+kqTLzZiJ
         7TZIVTGXTkzhfB18g+o3nTIWsTB8zepTzTnEN8iRZLPWVwnzCtQXiu6rhBpYXfiMGM
         mu7ed3l54qaq6etZHOEclsJDkas3cJ4drmAxwq+H38FTjWNGLUO/1WKTOABtgW5GgO
         P7kiz9/bE/fF2Qs5PqlQIJRNckanclCGkcPeJadmGbbseJFhNNiJTWwKW9ZH4fHKSI
         Ozo2G3/ZpFYdw==
Subject: [PATCH 35/48] libxfs: remove kmem_zone_destroy
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:26:24 -0800
Message-ID: <164263838482.865554.14373297919353166186.stgit@magnolia>
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

Convert all kmem cache users to call kmem_cache_destroy, and make leak
checking an explicit operation.  This gets us closer to the kernel
interface.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/kmem.h |   14 +++++---------
 libxfs/init.c  |   32 ++++++++++++++------------------
 libxfs/kmem.c  |   21 +++++++++++++++------
 3 files changed, 34 insertions(+), 33 deletions(-)


diff --git a/include/kmem.h b/include/kmem.h
index c710635d..53a2b37a 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -6,6 +6,9 @@
 #ifndef __KMEM_H__
 #define __KMEM_H__
 
+void kmem_start_leak_check(void);
+bool kmem_found_leaks(void);
+
 #define KM_NOFS		0x0004u
 #define KM_MAYFAIL	0x0008u
 #define KM_LARGE	0x0010u
@@ -38,17 +41,10 @@ kmem_zone_init(unsigned int size, const char *name)
 	return kmem_cache_create(name, size, 0, 0, NULL);
 }
 
+void kmem_cache_destroy(kmem_zone_t *);
+
 extern void	*kmem_cache_alloc(kmem_zone_t *, gfp_t);
 extern void	*kmem_cache_zalloc(kmem_zone_t *, gfp_t);
-extern int	kmem_zone_destroy(kmem_zone_t *);
-
-
-static inline void
-kmem_cache_destroy(kmem_zone_t *zone)
-{
-	kmem_zone_destroy(zone);
-}
-
 
 static inline void
 kmem_cache_free(kmem_zone_t *zone, void *ptr)
diff --git a/libxfs/init.c b/libxfs/init.c
index 3c1639db..0d693848 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -255,22 +255,18 @@ init_zones(void)
 			sizeof(struct xfs_trans), "xfs_trans");
 }
 
-static int
-destroy_zones(void)
+static void
+destroy_kmem_caches(void)
 {
-	int	leaked = 0;
-
-	leaked += kmem_zone_destroy(xfs_buf_zone);
-	leaked += kmem_zone_destroy(xfs_ili_zone);
-	leaked += kmem_zone_destroy(xfs_inode_zone);
-	leaked += kmem_zone_destroy(xfs_ifork_zone);
-	leaked += kmem_zone_destroy(xfs_buf_item_zone);
-	leaked += kmem_zone_destroy(xfs_da_state_zone);
+	kmem_cache_destroy(xfs_buf_zone);
+	kmem_cache_destroy(xfs_ili_zone);
+	kmem_cache_destroy(xfs_inode_zone);
+	kmem_cache_destroy(xfs_ifork_zone);
+	kmem_cache_destroy(xfs_buf_item_zone);
+	kmem_cache_destroy(xfs_da_state_zone);
 	xfs_btree_destroy_cur_caches();
-	leaked += kmem_zone_destroy(xfs_bmap_free_item_zone);
-	leaked += kmem_zone_destroy(xfs_trans_zone);
-
-	return leaked;
+	kmem_cache_destroy(xfs_bmap_free_item_zone);
+	kmem_cache_destroy(xfs_trans_zone);
 }
 
 static void
@@ -1025,17 +1021,17 @@ void
 libxfs_destroy(
 	struct libxfs_xinit	*li)
 {
-	int			leaked;
-
+	kmem_start_leak_check();
 	libxfs_close_devices(li);
 
 	/* Free everything from the buffer cache before freeing buffer zone */
 	libxfs_bcache_purge();
 	libxfs_bcache_free();
 	cache_destroy(libxfs_bcache);
-	leaked = destroy_zones();
+	destroy_kmem_caches();
 	rcu_unregister_thread();
-	if (getenv("LIBXFS_LEAK_CHECK") && leaked)
+
+	if (kmem_found_leaks())
 		exit(1);
 }
 
diff --git a/libxfs/kmem.c b/libxfs/kmem.c
index 221b3480..804d4b3c 100644
--- a/libxfs/kmem.c
+++ b/libxfs/kmem.c
@@ -3,6 +3,18 @@
 
 #include "libxfs_priv.h"
 
+static bool leaked;
+
+void kmem_start_leak_check(void)
+{
+	leaked = false;
+}
+
+bool kmem_found_leaks(void)
+{
+	return leaked;
+}
+
 /*
  * Simple memory interface
  */
@@ -27,18 +39,15 @@ kmem_cache_create(const char *name, unsigned int size, unsigned int align,
 	return ptr;
 }
 
-int
-kmem_zone_destroy(kmem_zone_t *zone)
+void
+kmem_cache_destroy(kmem_zone_t *zone)
 {
-	int	leaked = 0;
-
 	if (getenv("LIBXFS_LEAK_CHECK") && zone->allocated) {
-		leaked = 1;
+		leaked = true;
 		fprintf(stderr, "zone %s freed with %d items allocated\n",
 				zone->zone_name, zone->allocated);
 	}
 	free(zone);
-	return leaked;
 }
 
 void *

