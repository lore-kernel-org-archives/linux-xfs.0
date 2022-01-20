Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A1DC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345480AbiATA0t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbiATA0s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:26:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4660EC061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:26:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8524614DF
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B93C004E1;
        Thu, 20 Jan 2022 00:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638407;
        bh=EfAzIboOJK8hxfhKkPnScIuacFXejO8fBXpxG0nT2Bg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nTP4Wt0EQh1pg5YIIOHj346m9mu9tIwPYAZFjQdnOCOQiVpxgLt+3de+PTyCOf1v6
         +s+QX9K7ZElwH/rpo0xZ8VVJbLFwEzVP5/3jRfq3dM8Z0QdcoOSDI3UaYp1dieMiXH
         2LFAFALlLnEauRvjB2Xb0Uz5EOdNpgdrlmARxxs8chuhRZNr6GajaLAw+goHIvrwDp
         osOzXvhoRi2bdGho6REwAJYeEoca7XkTbrqYZSpepvMIg4iKRrDiFE26rp5wEBRG5X
         kkWi1OY/MpbEle4wOt9O0UUhBC8hSnnWe8AbK9Ai+iEb63uScs/t0TxungxJNMDODD
         LdoAeCK6QovgA==
Subject: [PATCH 39/48] libxfs: rename all the other _zone variables to _cache
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:26:46 -0800
Message-ID: <164263840689.865554.257197920220925329.stgit@magnolia>
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

Convert all the other _zone variables that we didn't catch in the libxfs
porting patches.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c        |   24 ++++++++++++------------
 libxfs/libxfs_priv.h |   10 +++++-----
 libxfs/logitem.c     |    8 ++++----
 libxfs/rdwr.c        |   16 ++++++++--------
 libxfs/trans.c       |   14 +++++++-------
 5 files changed, 36 insertions(+), 36 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 4a5b0d2e..1978a01f 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -229,20 +229,20 @@ check_open(char *path, int flags, char **rawfile, char **blockfile)
  * Initialize/destroy all of the zone allocators we use.
  */
 static void
-init_zones(void)
+init_caches(void)
 {
 	int		error;
 
 	/* initialise zone allocation */
-	xfs_buf_zone = kmem_cache_create("xfs_buffer",
+	xfs_buf_cache = kmem_cache_create("xfs_buffer",
 			sizeof(struct xfs_buf), 0, 0, NULL);
-	xfs_inode_zone = kmem_cache_create("xfs_inode",
+	xfs_inode_cache = kmem_cache_create("xfs_inode",
 			sizeof(struct xfs_inode), 0, 0, NULL);
 	xfs_ifork_cache = kmem_cache_create("xfs_ifork",
 			sizeof(struct xfs_ifork), 0, 0, NULL);
-	xfs_ili_zone = kmem_cache_create("xfs_inode_log_item",
+	xfs_ili_cache = kmem_cache_create("xfs_inode_log_item",
 			sizeof(struct xfs_inode_log_item), 0, 0, NULL);
-	xfs_buf_item_zone = kmem_cache_create("xfs_buf_log_item",
+	xfs_buf_item_cache = kmem_cache_create("xfs_buf_log_item",
 			sizeof(struct xfs_buf_log_item), 0, 0, NULL);
 	xfs_da_state_cache = kmem_cache_create("xfs_da_state",
 			sizeof(struct xfs_da_state), 0, 0, NULL);
@@ -255,22 +255,22 @@ init_zones(void)
 
 	xfs_bmap_free_item_cache = kmem_cache_create("xfs_bmap_free_item",
 			sizeof(struct xfs_extent_free_item), 0, 0, NULL);
-	xfs_trans_zone = kmem_cache_create("xfs_trans",
+	xfs_trans_cache = kmem_cache_create("xfs_trans",
 			sizeof(struct xfs_trans), 0, 0, NULL);
 }
 
 static void
 destroy_kmem_caches(void)
 {
-	kmem_cache_destroy(xfs_buf_zone);
-	kmem_cache_destroy(xfs_ili_zone);
-	kmem_cache_destroy(xfs_inode_zone);
+	kmem_cache_destroy(xfs_buf_cache);
+	kmem_cache_destroy(xfs_ili_cache);
+	kmem_cache_destroy(xfs_inode_cache);
 	kmem_cache_destroy(xfs_ifork_cache);
-	kmem_cache_destroy(xfs_buf_item_zone);
+	kmem_cache_destroy(xfs_buf_item_cache);
 	kmem_cache_destroy(xfs_da_state_cache);
 	xfs_btree_destroy_cur_caches();
 	kmem_cache_destroy(xfs_bmap_free_item_cache);
-	kmem_cache_destroy(xfs_trans_zone);
+	kmem_cache_destroy(xfs_trans_cache);
 }
 
 static void
@@ -405,7 +405,7 @@ libxfs_init(libxfs_init_t *a)
 				   &libxfs_bcache_operations);
 	use_xfs_buf_lock = a->usebuflock;
 	xfs_dir_startup();
-	init_zones();
+	init_caches();
 	rval = 1;
 done:
 	if (dpath[0])
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 5b04db84..67d9a8bb 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -59,11 +59,11 @@
 #include <sys/xattr.h>
 
 /* Zones used in libxfs allocations that aren't in shared header files */
-extern struct kmem_cache *xfs_buf_item_zone;
-extern struct kmem_cache *xfs_ili_zone;
-extern struct kmem_cache *xfs_buf_zone;
-extern struct kmem_cache *xfs_inode_zone;
-extern struct kmem_cache *xfs_trans_zone;
+extern struct kmem_cache *xfs_buf_item_cache;
+extern struct kmem_cache *xfs_ili_cache;
+extern struct kmem_cache *xfs_buf_cache;
+extern struct kmem_cache *xfs_inode_cache;
+extern struct kmem_cache *xfs_trans_cache;
 
 /* fake up iomap, (not) used in xfs_bmap.[ch] */
 #define IOMAP_F_SHARED			0x04
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index dde90502..98ccdaef 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -16,8 +16,8 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 
-struct kmem_cache	*xfs_buf_item_zone;
-struct kmem_cache	*xfs_ili_zone;		/* inode log item zone */
+struct kmem_cache	*xfs_buf_item_cache;
+struct kmem_cache	*xfs_ili_cache;		/* inode log item cache */
 
 /*
  * Following functions from fs/xfs/xfs_trans_buf.c
@@ -96,7 +96,7 @@ xfs_buf_item_init(
 		}
 	}
 
-	bip = kmem_cache_zalloc(xfs_buf_item_zone, 0);
+	bip = kmem_cache_zalloc(xfs_buf_item_cache, 0);
 #ifdef LI_DEBUG
 	fprintf(stderr, "adding buf item %p for not-logged buffer %p\n",
 		bip, bp);
@@ -138,7 +138,7 @@ xfs_inode_item_init(
 	struct xfs_inode_log_item	*iip;
 
 	ASSERT(ip->i_itemp == NULL);
-	iip = ip->i_itemp = kmem_cache_zalloc(xfs_ili_zone, 0);
+	iip = ip->i_itemp = kmem_cache_zalloc(xfs_ili_cache, 0);
 #ifdef LI_DEBUG
 	fprintf(stderr, "inode_item_init for inode %llu, iip=%p\n",
 		ip->i_ino, iip);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index c6a2c607..7f4aa45f 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -161,7 +161,7 @@ libxfs_getsb(
 	return bp;
 }
 
-struct kmem_cache			*xfs_buf_zone;
+struct kmem_cache			*xfs_buf_cache;
 
 static struct cache_mru		xfs_buf_freelist =
 	{{&xfs_buf_freelist.cm_list, &xfs_buf_freelist.cm_list},
@@ -327,7 +327,7 @@ __libxfs_getbufr(int blen)
 			bp->b_maps = NULL;
 		}
 	} else
-		bp = kmem_cache_zalloc(xfs_buf_zone, 0);
+		bp = kmem_cache_zalloc(xfs_buf_cache, 0);
 	pthread_mutex_unlock(&xfs_buf_freelist.cm_mutex);
 	bp->b_ops = NULL;
 	if (bp->b_flags & LIBXFS_B_DIRTY)
@@ -961,7 +961,7 @@ libxfs_bcache_free(void)
 		free(bp->b_addr);
 		if (bp->b_maps != &bp->__b_map)
 			free(bp->b_maps);
-		kmem_cache_free(xfs_buf_zone, bp);
+		kmem_cache_free(xfs_buf_cache, bp);
 	}
 }
 
@@ -1053,8 +1053,8 @@ xfs_verify_magic16(
  * Inode cache stubs.
  */
 
-struct kmem_cache		*xfs_inode_zone;
-extern struct kmem_cache	*xfs_ili_zone;
+struct kmem_cache		*xfs_inode_cache;
+extern struct kmem_cache	*xfs_ili_cache;
 
 int
 libxfs_iget(
@@ -1068,7 +1068,7 @@ libxfs_iget(
 	struct xfs_buf		*bp;
 	int			error = 0;
 
-	ip = kmem_cache_zalloc(xfs_inode_zone, 0);
+	ip = kmem_cache_zalloc(xfs_inode_cache, 0);
 	if (!ip)
 		return -ENOMEM;
 
@@ -1098,7 +1098,7 @@ libxfs_iget(
 	return 0;
 
 out_destroy:
-	kmem_cache_free(xfs_inode_zone, ip);
+	kmem_cache_free(xfs_inode_cache, ip);
 	*ipp = NULL;
 	return error;
 }
@@ -1132,7 +1132,7 @@ libxfs_irele(
 	if (VFS_I(ip)->i_count == 0) {
 		ASSERT(ip->i_itemp == NULL);
 		libxfs_idestroy(ip);
-		kmem_cache_free(xfs_inode_zone, ip);
+		kmem_cache_free(xfs_inode_cache, ip);
 	}
 }
 
diff --git a/libxfs/trans.c b/libxfs/trans.c
index f87a65c5..50d9c23d 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -30,7 +30,7 @@ static int __xfs_trans_commit(struct xfs_trans *tp, bool regrant);
  * Simple transaction interface
  */
 
-struct kmem_cache	*xfs_trans_zone;
+struct kmem_cache	*xfs_trans_cache;
 
 /*
  * Initialize the precomputed transaction reservation values
@@ -124,7 +124,7 @@ static void
 xfs_trans_free(
 	struct xfs_trans	*tp)
 {
-	kmem_cache_free(xfs_trans_zone, tp);
+	kmem_cache_free(xfs_trans_cache, tp);
 }
 
 /*
@@ -141,7 +141,7 @@ xfs_trans_dup(
 {
 	struct xfs_trans	*ntp;
 
-	ntp = kmem_cache_zalloc(xfs_trans_zone, 0);
+	ntp = kmem_cache_zalloc(xfs_trans_cache, 0);
 
 	/*
 	 * Initialize the new transaction structure.
@@ -259,7 +259,7 @@ libxfs_trans_alloc(
 	struct xfs_trans	*tp;
 	int			error;
 
-	tp = kmem_cache_zalloc(xfs_trans_zone, 0);
+	tp = kmem_cache_zalloc(xfs_trans_cache, 0);
 	tp->t_mountp = mp;
 	INIT_LIST_HEAD(&tp->t_items);
 	INIT_LIST_HEAD(&tp->t_dfops);
@@ -354,7 +354,7 @@ xfs_buf_item_put(
 	struct xfs_buf		*bp = bip->bli_buf;
 
 	bp->b_log_item = NULL;
-	kmem_cache_free(xfs_buf_item_zone, bip);
+	kmem_cache_free(xfs_buf_item_cache, bip);
 }
 
 /* from xfs_trans_buf.c */
@@ -816,7 +816,7 @@ xfs_inode_item_put(
 	ip->i_itemp = NULL;
 
 	list_del_init(&iip->ili_item.li_bio_list);
-	kmem_cache_free(xfs_ili_zone, iip);
+	kmem_cache_free(xfs_ili_cache, iip);
 }
 
 
@@ -868,7 +868,7 @@ buf_item_done(
 {
 	struct xfs_buf		*bp;
 	int			hold;
-	extern struct kmem_cache	*xfs_buf_item_zone;
+	extern struct kmem_cache	*xfs_buf_item_cache;
 
 	bp = bip->bli_buf;
 	ASSERT(bp != NULL);

