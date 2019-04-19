Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44328 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbfDSTVi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Apr 2019 15:21:38 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 84E28308A113
        for <linux-xfs@vger.kernel.org>; Fri, 19 Apr 2019 16:55:28 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C0B375D70A
        for <linux-xfs@vger.kernel.org>; Fri, 19 Apr 2019 16:55:26 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] libxfs: refactor manage_zones()
Message-ID: <c2e6e3a1-f6cd-2883-8383-e308bcd5f610@redhat.com>
Date: Fri, 19 Apr 2019 11:55:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

It's bizarre to have manage_zones() both set up and tear down zones.
It's even more bizarre to have xfs_dir_startup() buried in there.

Refactor init/destory into 2 functions, and call xfs_dir_startup()
separately from zone init similar to what kernelspace does.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/init.c b/libxfs/init.c
index 37bd2829..2a65ba9a 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -31,8 +31,6 @@ int libxfs_bhash_size;		/* #buckets in bcache */
 
 int	use_xfs_buf_lock;	/* global flag: use xfs_buf_t locks for MT */
 
-static int manage_zones(int);	/* setup/teardown global zones */
-
 /*
  * dev_map - map open devices to fd.
  */
@@ -217,6 +215,49 @@ check_open(char *path, int flags, char **rawfile, char **blockfile)
 	return 1;
 }
 
+/*
+ * Initialize/destroy all of the zone allocators we use.
+ */
+static void
+init_zones(void)
+{
+	/* initialise zone allocation */
+	xfs_buf_zone = kmem_zone_init(sizeof(xfs_buf_t), "xfs_buffer");
+	xfs_inode_zone = kmem_zone_init(sizeof(struct xfs_inode), "xfs_inode");
+	xfs_ifork_zone = kmem_zone_init(sizeof(struct xfs_ifork), "xfs_ifork");
+	xfs_ili_zone = kmem_zone_init(
+			sizeof(xfs_inode_log_item_t), "xfs_inode_log_item");
+	xfs_buf_item_zone = kmem_zone_init(
+			sizeof(xfs_buf_log_item_t), "xfs_buf_log_item");
+	xfs_da_state_zone = kmem_zone_init(
+			sizeof(xfs_da_state_t), "xfs_da_state");
+	xfs_btree_cur_zone = kmem_zone_init(
+			sizeof(xfs_btree_cur_t), "xfs_btree_cur");
+	xfs_bmap_free_item_zone = kmem_zone_init(
+			sizeof(struct xfs_extent_free_item),
+			"xfs_bmap_free_item");
+	xfs_trans_zone = kmem_zone_init(
+			sizeof(struct xfs_trans), "xfs_trans");
+}
+
+static int
+destroy_zones(void)
+{
+	int	leaked = 0;
+
+	leaked += kmem_zone_destroy(xfs_buf_zone);
+	leaked += kmem_zone_destroy(xfs_ili_zone);
+	leaked += kmem_zone_destroy(xfs_inode_zone);
+	leaked += kmem_zone_destroy(xfs_ifork_zone);
+	leaked += kmem_zone_destroy(xfs_buf_item_zone);
+	leaked += kmem_zone_destroy(xfs_da_state_zone);
+	leaked += kmem_zone_destroy(xfs_btree_cur_zone);
+	leaked += kmem_zone_destroy(xfs_bmap_free_item_zone);
+	leaked += kmem_zone_destroy(xfs_trans_zone);
+
+	return leaked;
+}
+
 /*
  * libxfs initialization.
  * Caller gets a 0 on failure (and we print a message), 1 on success.
@@ -331,7 +372,8 @@ libxfs_init(libxfs_init_t *a)
 	libxfs_bcache = cache_init(a->bcache_flags, libxfs_bhash_size,
 				   &libxfs_bcache_operations);
 	use_xfs_buf_lock = a->usebuflock;
-	manage_zones(0);
+	xfs_dir_startup();
+	init_zones();
 	rval = 1;
 done:
 	if (dpath[0])
@@ -352,51 +394,6 @@ done:
 }
 
 
-/*
- * Initialize/destroy all of the zone allocators we use.
- */
-static int
-manage_zones(int release)
-{
-	extern void		xfs_dir_startup();
-
-	if (release) {	/* free zone allocation */
-		int	leaked = 0;
-
-		leaked += kmem_zone_destroy(xfs_buf_zone);
-		leaked += kmem_zone_destroy(xfs_ili_zone);
-		leaked += kmem_zone_destroy(xfs_inode_zone);
-		leaked += kmem_zone_destroy(xfs_ifork_zone);
-		leaked += kmem_zone_destroy(xfs_buf_item_zone);
-		leaked += kmem_zone_destroy(xfs_da_state_zone);
-		leaked += kmem_zone_destroy(xfs_btree_cur_zone);
-		leaked += kmem_zone_destroy(xfs_bmap_free_item_zone);
-		leaked += kmem_zone_destroy(xfs_trans_zone);
-
-		return leaked;
-	}
-	/* otherwise initialise zone allocation */
-	xfs_buf_zone = kmem_zone_init(sizeof(xfs_buf_t), "xfs_buffer");
-	xfs_inode_zone = kmem_zone_init(sizeof(struct xfs_inode), "xfs_inode");
-	xfs_ifork_zone = kmem_zone_init(sizeof(struct xfs_ifork), "xfs_ifork");
-	xfs_ili_zone = kmem_zone_init(
-			sizeof(xfs_inode_log_item_t), "xfs_inode_log_item");
-	xfs_buf_item_zone = kmem_zone_init(
-			sizeof(xfs_buf_log_item_t), "xfs_buf_log_item");
-	xfs_da_state_zone = kmem_zone_init(
-			sizeof(xfs_da_state_t), "xfs_da_state");
-	xfs_btree_cur_zone = kmem_zone_init(
-			sizeof(xfs_btree_cur_t), "xfs_btree_cur");
-	xfs_bmap_free_item_zone = kmem_zone_init(
-			sizeof(struct xfs_extent_free_item),
-			"xfs_bmap_free_item");
-	xfs_trans_zone = kmem_zone_init(
-			sizeof(struct xfs_trans), "xfs_trans");
-	xfs_dir_startup();
-
-	return 0;
-}
-
 /*
  * Initialize realtime fields in the mount structure.
  */
@@ -874,7 +871,7 @@ libxfs_destroy(void)
 	libxfs_bcache_purge();
 	libxfs_bcache_free();
 	cache_destroy(libxfs_bcache);
-	leaked = manage_zones(1);
+	leaked = destroy_zones();
 	if (getenv("LIBXFS_LEAK_CHECK") && leaked)
 		exit(1);
 }
