Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43708 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965733AbeAKThw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 14:37:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 8/8] libxfs: Catch non-empty zones on destroy
Date: Thu, 11 Jan 2018 13:37:38 -0600
Message-Id: <1515699458-6925-9-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1515699458-6925-1-git-send-email-sandeen@sandeen.net>
References: <1515699458-6925-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Move xfs_inode_zone definition to its primary file, and add
it to the list of zones to release; properly release
xfs_ili_zone as well.

Create and use a kmem_zone_destroy which warns if we are
releasing a non-empty zone when the LIBXFS_LEAK_CHECK
environment variable is set, wire this into libxfs_destroy(),
and call that when various tools exit.

The LIBXFS_LEAK_CHECK environment variable also causes
the program to exit with failure when a leak is detected.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 copy/xfs_copy.c     |  1 +
 db/init.c           |  2 ++
 include/kmem.h      |  1 +
 libxfs/init.c       | 38 +++++++++++++++++++++++---------------
 libxfs/kmem.c       | 14 ++++++++++++++
 libxfs/rdwr.c       |  2 +-
 mkfs/xfs_mkfs.c     |  1 +
 repair/xfs_repair.c |  1 +
 8 files changed, 44 insertions(+), 16 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index fb37375..648db86 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -1214,6 +1214,7 @@ main(int argc, char **argv)
 
 	check_errors();
 	libxfs_umount(mp);
+	libxfs_destroy();
 
 	return 0;
 }
diff --git a/db/init.c b/db/init.c
index b108a06..29fc344 100644
--- a/db/init.c
+++ b/db/init.c
@@ -236,5 +236,7 @@ close_devices:
 		libxfs_device_close(x.logdev);
 	if (x.rtdev)
 		libxfs_device_close(x.rtdev);
+	libxfs_destroy();
+
 	return exitcode;
 }
diff --git a/include/kmem.h b/include/kmem.h
index 65f0ade..80ce25b 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -31,6 +31,7 @@ typedef struct kmem_zone {
 } kmem_zone_t;
 
 extern kmem_zone_t *kmem_zone_init(int, char *);
+extern int	kmem_zone_destroy(kmem_zone_t *);
 extern void	*kmem_zone_alloc(kmem_zone_t *, int);
 extern void	*kmem_zone_zalloc(kmem_zone_t *, int);
 
diff --git a/libxfs/init.c b/libxfs/init.c
index aea308b..e32f27c 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -43,9 +43,7 @@ int libxfs_bhash_size;		/* #buckets in bcache */
 
 int	use_xfs_buf_lock;	/* global flag: use xfs_buf_t locks for MT */
 
-static void manage_zones(int);	/* setup global zones */
-
-kmem_zone_t	*xfs_inode_zone;
+static int manage_zones(int);	/* setup/teardown global zones */
 
 /*
  * dev_map - map open devices to fd.
@@ -374,11 +372,12 @@ done:
 /*
  * Initialize/destroy all of the zone allocators we use.
  */
-static void
+static int 
 manage_zones(int release)
 {
 	extern kmem_zone_t	*xfs_buf_zone;
 	extern kmem_zone_t	*xfs_ili_zone;
+	extern kmem_zone_t	*xfs_inode_zone;
 	extern kmem_zone_t	*xfs_ifork_zone;
 	extern kmem_zone_t	*xfs_buf_item_zone;
 	extern kmem_zone_t	*xfs_da_state_zone;
@@ -389,16 +388,19 @@ manage_zones(int release)
 	extern void		xfs_dir_startup();
 
 	if (release) {	/* free zone allocation */
-		kmem_free(xfs_buf_zone);
-		kmem_free(xfs_inode_zone);
-		kmem_free(xfs_ifork_zone);
-		kmem_free(xfs_buf_item_zone);
-		kmem_free(xfs_da_state_zone);
-		kmem_free(xfs_btree_cur_zone);
-		kmem_free(xfs_bmap_free_item_zone);
-		kmem_free(xfs_trans_zone);
-		kmem_free(xfs_log_item_desc_zone);
-		return;
+		int	leaked = 0;
+
+		leaked += kmem_zone_destroy(xfs_buf_zone);
+		leaked += kmem_zone_destroy(xfs_ili_zone);
+		leaked += kmem_zone_destroy(xfs_inode_zone);
+		leaked += kmem_zone_destroy(xfs_ifork_zone);
+		leaked += kmem_zone_destroy(xfs_buf_item_zone);
+		leaked += kmem_zone_destroy(xfs_da_state_zone);
+		leaked += kmem_zone_destroy(xfs_btree_cur_zone);
+		leaked += kmem_zone_destroy(xfs_bmap_free_item_zone);
+		leaked += kmem_zone_destroy(xfs_trans_zone);
+		leaked += kmem_zone_destroy(xfs_log_item_desc_zone);
+		return leaked;
 	}
 	/* otherwise initialise zone allocation */
 	xfs_buf_zone = kmem_zone_init(sizeof(xfs_buf_t), "xfs_buffer");
@@ -420,6 +422,8 @@ manage_zones(int release)
 	xfs_log_item_desc_zone = kmem_zone_init(
 			sizeof(struct xfs_log_item_desc), "xfs_log_item_desc");
 	xfs_dir_startup();
+
+	return 0;
 }
 
 /*
@@ -888,10 +892,14 @@ libxfs_umount(xfs_mount_t *mp)
 void
 libxfs_destroy(void)
 {
-	manage_zones(1);
+	int	leaked;
+
+	leaked = manage_zones(1);
 	libxfs_bcache_purge();
 	libxfs_bcache_free();
 	cache_destroy(libxfs_bcache);
+	if (getenv("LIBXFS_LEAK_CHECK") && leaked)
+		exit(1);
 }
 
 int
diff --git a/libxfs/kmem.c b/libxfs/kmem.c
index c8bcb50..d599b3d 100644
--- a/libxfs/kmem.c
+++ b/libxfs/kmem.c
@@ -23,6 +23,20 @@ kmem_zone_init(int size, char *name)
 	return ptr;
 }
 
+int
+kmem_zone_destroy(kmem_zone_t *zone)
+{
+	int	leaked = 0;
+
+	if (getenv("LIBXFS_LEAK_CHECK") && zone->allocated) {
+		leaked = 1;
+		printf("zone %s freed with %d items allocated\n",
+					zone->zone_name, zone->allocated);
+	}
+	free(zone);
+	return leaked;
+}
+
 void *
 kmem_zone_alloc(kmem_zone_t *zone, int flags)
 {
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 1dcabdd..fdb2865 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1352,8 +1352,8 @@ struct cache_operations libxfs_bcache_operations = {
  * Inode cache stubs.
  */
 
+kmem_zone_t		*xfs_inode_zone;
 extern kmem_zone_t	*xfs_ili_zone;
-extern kmem_zone_t	*xfs_inode_zone;
 
 int
 libxfs_iget(xfs_mount_t *mp, xfs_trans_t *tp, xfs_ino_t ino, uint lock_flags,
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 5f1ac9f..e08d1d1 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4028,6 +4028,7 @@ main(
 	if (xi.logdev && xi.logdev != xi.ddev)
 		libxfs_device_close(xi.logdev);
 	libxfs_device_close(xi.ddev);
+	libxfs_destroy();
 
 	return 0;
 }
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index b2dd91b..312a0d0 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1082,6 +1082,7 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 	if (x.logdev && x.logdev != x.ddev)
 		libxfs_device_close(x.logdev);
 	libxfs_device_close(x.ddev);
+	libxfs_destroy();
 
 	if (verbose)
 		summary_report();
-- 
1.8.3.1

