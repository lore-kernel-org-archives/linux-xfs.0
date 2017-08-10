Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43045 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbdHJFXx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Aug 2017 01:23:53 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7A5Nre1016704
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 05:23:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7A5Nrx4007981
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 05:23:53 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7A5Nr2w012942
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 05:23:53 GMT
Subject: [PATCH 2/3] xfs: evict all inodes involved with log redo item
 recovery
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 09 Aug 2017 22:23:51 -0700
Message-ID: <150234263191.13754.5037661818451431724.stgit@magnolia>
In-Reply-To: <150234262066.13754.6534116056866237943.stgit@magnolia>
References: <150234262066.13754.6534116056866237943.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we introduced the bmap redo log items, we set MS_ACTIVE on the
mountpoint and XFS_IRECOVERY on the inode to prevent unlinked inodes
from being truncated prematurely during log recovery.  This also had the
effect of putting linked inodes on the lru instead of evicting them.

Unfortunately, we neglected to find all those unreferenced lru inodes
and evict them after finishing log recovery, which means that we leak
them if anything goes wrong in the rest of xfs_mountfs, because the lru
is only cleaned out on unmount.

Therefore, look for unreferenced inodes in the lru list immediately
after clearing MS_ACTIVE.  If we find any, igrab/iput them so that
they're evicted from memory.

Fixes: 17c12bcd30 ("xfs: when replaying bmap operations, don't let unlinked inodes get reaped")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_mount.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d63a367..8da5155 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -616,6 +616,34 @@ xfs_default_resblks(xfs_mount_t *mp)
 }
 
 /*
+ * Find inodes that were put on the LRU during the last part of log
+ * recovery that are no longer referenced by anything, and igrab/iput
+ * them so that they'll be evicted now.
+ *
+ * We let all inodes involved in redo item processing end up on the LRU
+ * instead of being evicted immediately so that if we do something to an
+ * unlinked inode, the irele won't cause premature truncation and
+ * freeing of the inode, which results in log recovery failure.  We have
+ * to evict the unreferenced lru inodes here because we don't otherwise
+ * clean up the lru if there's a subsequent failure in xfs_mountfs,
+ * which leads to us leaking the inodes if nothing else (e.g. quotacheck)
+ * references the inodes before the failure occurs.
+ */
+STATIC void
+xfs_mountfs_evict_log_redo_inodes(
+	struct xfs_mount	*mp)
+{
+	struct super_block	*sb = mp->m_super;
+	struct inode		*inode;
+	struct inode		*next;
+
+	list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
+		if (!atomic_read(&inode->i_count))
+			iput(igrab(inode));
+	}
+}
+
+/*
  * This function does the following on an initial mount of a file system:
  *	- reads the superblock from disk and init the mount struct
  *	- if we're a 32-bit kernel, do a size check on the superblock
@@ -960,6 +988,7 @@ xfs_mountfs(
 	mp->m_super->s_flags |= MS_ACTIVE;
 	error = xfs_log_mount_finish(mp);
 	mp->m_super->s_flags &= ~MS_ACTIVE;
+	xfs_mountfs_evict_log_redo_inodes(mp);
 	if (error) {
 		xfs_warn(mp, "log mount finish failed");
 		goto out_rtunmount;

