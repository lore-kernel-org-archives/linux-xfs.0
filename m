Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58350 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751179AbeDEMLt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Apr 2018 08:11:49 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2D4A67F7B6
        for <linux-xfs@vger.kernel.org>; Thu,  5 Apr 2018 12:11:49 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11DA382AC3
        for <linux-xfs@vger.kernel.org>; Thu,  5 Apr 2018 12:11:49 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/2] xfs: reset xfs_inode struct on reclaim in debug mode
Date: Thu,  5 Apr 2018 08:11:46 -0400
Message-Id: <20180405121147.60897-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

A test case to reproduce a filestream/MRU use-after-free of a
reclaimed inode requires bits (e.g., ip->i_mount) of the inode to be
reset/reused once the inode memory is freed. This normally only
occurs when a new page is cycled into the zone, however.

Perform the "one-time" inode init immediately prior to freeing
inodes when in DEBUG mode. This will zero the inode, init the low
level structures (locks, lists, etc.) and otherwise ensure each
inode is in a purely uninitialized state while sitting in the zone
as free memory.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

I'll post a test that depends on this once this is worked out... one
concern this raised is if we consider any future bugs in the inode
initialization code (suppose we initialize some field once that should
be initialized on every allocation, for example), this code has the
potential to suppress such problems in debug mode. So an alternative to
this approach is to perhaps tie this to an errortag and let the
associated xfstests test enable it appropriately. Thoughts or
preferences?

Brian

 fs/xfs/xfs_icache.c | 5 ++++-
 fs/xfs/xfs_super.c  | 2 +-
 fs/xfs/xfs_super.h  | 1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 9a18f69f6e96..86dc4c8a4e1d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -111,7 +111,10 @@ xfs_inode_free_callback(
 		xfs_inode_item_destroy(ip);
 		ip->i_itemp = NULL;
 	}
-
+#ifdef DEBUG
+	/* facilitate catching use-after-free problems */
+	xfs_fs_inode_init_once(ip);
+#endif
 	kmem_zone_free(xfs_inode_zone, ip);
 }
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 612c1d5348b3..29b1be5dfebf 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1030,7 +1030,7 @@ xfs_fs_dirty_inode(
  * fields in the xfs inode that left in the initialise state
  * when freeing the inode.
  */
-STATIC void
+void
 xfs_fs_inode_init_once(
 	void			*inode)
 {
diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index 8cee8e8050e3..aae8a778f378 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -70,6 +70,7 @@ struct block_device;
 
 extern void xfs_quiesce_attr(struct xfs_mount *mp);
 extern void xfs_flush_inodes(struct xfs_mount *mp);
+extern void xfs_fs_inode_init_once(void *);
 extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
 extern xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *,
 					   xfs_agnumber_t agcount);
-- 
2.13.6

