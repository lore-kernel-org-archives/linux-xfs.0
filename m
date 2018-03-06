Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58506 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753904AbeCFVzz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Mar 2018 16:55:55 -0500
Subject: [PATCH 3/5] libxfs: move xfs_inode_zone to rdwr.c
References: <d81cf576-6082-008b-761e-82c487e6a87a@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ab899bab-b034-1167-21e7-073ce5258082@sandeen.net>
Date: Tue, 6 Mar 2018 15:55:54 -0600
MIME-Version: 1.0
In-Reply-To: <d81cf576-6082-008b-761e-82c487e6a87a@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

The zone itself is created in rdwr.c, so define it there as
well, and add it to the list of externs in manage_zones along
with all the rest, for consistency.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/init.c | 3 +--
 libxfs/rdwr.c | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index c7d73b6..3456cb5 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -45,8 +45,6 @@ int	use_xfs_buf_lock;	/* global flag: use xfs_buf_t locks for MT */
 
 static void manage_zones(int);	/* setup global zones */
 
-kmem_zone_t	*xfs_inode_zone;
-
 /*
  * dev_map - map open devices to fd.
  */
@@ -379,6 +377,7 @@ manage_zones(int release)
 {
 	extern kmem_zone_t	*xfs_buf_zone;
 	extern kmem_zone_t	*xfs_ili_zone;
+	extern kmem_zone_t	*xfs_inode_zone;
 	extern kmem_zone_t	*xfs_ifork_zone;
 	extern kmem_zone_t	*xfs_buf_item_zone;
 	extern kmem_zone_t	*xfs_da_state_zone;
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 81701b7..3142094 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1351,8 +1351,8 @@ struct cache_operations libxfs_bcache_operations = {
  * Inode cache stubs.
  */
 
+kmem_zone_t		*xfs_inode_zone;
 extern kmem_zone_t	*xfs_ili_zone;
-extern kmem_zone_t	*xfs_inode_zone;
 
 /*
  * If there are inline format data / attr forks attached to this inode,
-- 
1.8.3.1

