Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5271mdx180591 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 02:01:48 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 265D51ED1909
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 00:01:47 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	vHd2hKWMEjbvgMP6 for <xfs@oss.sgi.com>;
	Thu, 02 Jun 2011 00:01:47 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/12] inode: remove iprune_sem
Date: Thu,  2 Jun 2011 17:01:04 +1000
Message-Id: <1306998067-27659-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1306998067-27659-1-git-send-email-david@fromorbit.com>
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Now that we have per-sb shrinkers and they are unregistered before
evict_inode() is called, there is not longer any race condition for
the iprune_sem to protect against. Hence we can remove it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c |   21 ---------------------
 1 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 890d95e..167adfd 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -68,17 +68,6 @@ __cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_sb_list_lock);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_wb_list_lock);
 
 /*
- * iprune_sem provides exclusion between the icache shrinking and the
- * umount path.
- *
- * We don't actually need it to protect anything in the umount path,
- * but only need to cycle through it to make sure any inode that
- * prune_icache_sb took off the LRU list has been fully torn down by the
- * time we are past evict_inodes.
- */
-static DECLARE_RWSEM(iprune_sem);
-
-/*
  * Empty aops. Can be used for the cases where the user does not
  * define any of the address_space operations.
  */
@@ -535,14 +524,6 @@ void evict_inodes(struct super_block *sb)
 	spin_unlock(&inode_sb_list_lock);
 
 	dispose_list(&dispose);
-
-	/*
-	 * Cycle through iprune_sem to make sure any inode that prune_icache_sb
-	 * moved off the list before we took the lock has been fully torn
-	 * down.
-	 */
-	down_write(&iprune_sem);
-	up_write(&iprune_sem);
 }
 
 /**
@@ -628,7 +609,6 @@ void prune_icache_sb(struct super_block *sb, int nr_to_scan)
 	int nr_scanned;
 	unsigned long reap = 0;
 
-	down_read(&iprune_sem);
 	spin_lock(&sb->s_inode_lru_lock);
 	for (nr_scanned = nr_to_scan; nr_scanned >= 0; nr_scanned--) {
 		struct inode *inode;
@@ -704,7 +684,6 @@ void prune_icache_sb(struct super_block *sb, int nr_to_scan)
 	spin_unlock(&sb->s_inode_lru_lock);
 
 	dispose_list(&freeable);
-	up_read(&iprune_sem);
 }
 
 static void __wait_on_freeing_inode(struct inode *inode);
-- 
1.7.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
