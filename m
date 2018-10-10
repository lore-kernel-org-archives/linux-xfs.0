Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56202 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727686AbeJKDZV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Oct 2018 23:25:21 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 06/18] libxfs: add several zone extern declarations to libxfs_priv.h
Date: Wed, 10 Oct 2018 15:01:10 -0500
Message-Id: <1539201682-22198-7-git-send-email-sandeen@redhat.com>
In-Reply-To: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Several zones have extern declarations in kernelspace headers we don't
have in userspace.

Adding these to the libxfs_priv.h header silences sparse warnings about
whether these should be static vars.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/init.c        | 9 ---------
 libxfs/libxfs_priv.h | 7 +++++++
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index 10dcbf3..80fbe6a 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -363,15 +363,6 @@ done:
 static int
 manage_zones(int release)
 {
-	extern kmem_zone_t	*xfs_buf_zone;
-	extern kmem_zone_t	*xfs_ili_zone;
-	extern kmem_zone_t	*xfs_inode_zone;
-	extern kmem_zone_t	*xfs_ifork_zone;
-	extern kmem_zone_t	*xfs_buf_item_zone;
-	extern kmem_zone_t	*xfs_da_state_zone;
-	extern kmem_zone_t	*xfs_btree_cur_zone;
-	extern kmem_zone_t	*xfs_bmap_free_item_zone;
-	extern kmem_zone_t	*xfs_trans_zone;
 	extern void		xfs_dir_startup();
 
 	if (release) {	/* free zone allocation */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 6df7864..b45d07e 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -55,6 +55,13 @@
 #include "xfs_fs.h"
 #include "crc32c.h"
 
+/* Zones used in libxfs allocations that aren't in shared header files */
+extern kmem_zone_t *xfs_buf_item_zone;
+extern kmem_zone_t *xfs_ili_zone;
+extern kmem_zone_t *xfs_buf_zone;
+extern kmem_zone_t *xfs_inode_zone;
+extern kmem_zone_t *xfs_trans_zone;
+
 /* CRC stuff, buffer API dependent on it */
 #define crc32c(c,p,l)	crc32c_le((c),(unsigned char const *)(p),(l))
 
-- 
1.8.3.1
