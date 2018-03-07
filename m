Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48290 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754834AbeCGXdu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Mar 2018 18:33:50 -0500
Subject: [PATCH 2/2] xfs: don't dirty snapshot logs for unlinked inode
 recovery
References: <83696ce6-4054-0e77-b4b8-e82a1a9fbbc3@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <896a0202-aac8-e43f-7ea6-3718591e32aa@sandeen.net>
Date: Wed, 7 Mar 2018 17:33:48 -0600
MIME-Version: 1.0
In-Reply-To: <83696ce6-4054-0e77-b4b8-e82a1a9fbbc3@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Now that unlinked inode recovery is done outside of
log recovery, there is no need to dirty the log on
snapshots just to handle unlinked inodes.  This means
that readonly snapshots can be mounted without requiring
-o ro,norecovery to avoid the log replay that can't happen
on a readonly block device.

(unlinked inodes will just hang out in the agi buckets until
the next writable mount)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 93588ea..5669525 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1419,9 +1419,10 @@ struct proc_xfs_info {
 
 /*
  * Second stage of a freeze. The data is already frozen so we only
- * need to take care of the metadata. Once that's done sync the superblock
- * to the log to dirty it in case of a crash while frozen. This ensures that we
- * will recover the unlinked inode lists on the next mount.
+ * need to take care of the metadata.
+ * Any unlinked inode lists will remain at this point, and be recovered
+ * on the next writable mount if we crash while frozen, or create
+ * a snapshot from the frozen filesystem.
  */
 STATIC int
 xfs_fs_freeze(
@@ -1431,7 +1432,7 @@ struct proc_xfs_info {
 
 	xfs_save_resvblks(mp);
 	xfs_quiesce_attr(mp);
-	return xfs_sync_sb(mp, true);
+	return 0;
 }
 
 STATIC int

