Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5271hSc180529 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 02:01:43 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B59B44963C0
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 00:01:41 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	5WeyqZcvQR1BSsoY for <xfs@oss.sgi.com>;
	Thu, 02 Jun 2011 00:01:41 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/12] inode: convert inode_stat.nr_unused to per-cpu counters
Date: Thu,  2 Jun 2011 17:01:00 +1000
Message-Id: <1306998067-27659-6-git-send-email-david@fromorbit.com>
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

Before we split up the inode_lru_lock, the unused inode counter
needs to be made independent of the global inode_lru_lock. Convert
it to per-cpu counters to do this.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 0f7e88a..17fea5b 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -95,6 +95,7 @@ EXPORT_SYMBOL(empty_aops);
 struct inodes_stat_t inodes_stat;
 
 static DEFINE_PER_CPU(unsigned int, nr_inodes);
+static DEFINE_PER_CPU(unsigned int, nr_unused);
 
 static struct kmem_cache *inode_cachep __read_mostly;
 
@@ -109,7 +110,11 @@ static int get_nr_inodes(void)
 
 static inline int get_nr_inodes_unused(void)
 {
-	return inodes_stat.nr_unused;
+	int i;
+	int sum = 0;
+	for_each_possible_cpu(i)
+		sum += per_cpu(nr_unused, i);
+	return sum < 0 ? 0 : sum;
 }
 
 int get_nr_dirty_inodes(void)
@@ -127,6 +132,7 @@ int proc_nr_inodes(ctl_table *table, int write,
 		   void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	inodes_stat.nr_inodes = get_nr_inodes();
+	inodes_stat.nr_unused = get_nr_inodes_unused();
 	return proc_dointvec(table, write, buffer, lenp, ppos);
 }
 #endif
@@ -340,7 +346,7 @@ static void inode_lru_list_add(struct inode *inode)
 	spin_lock(&inode_lru_lock);
 	if (list_empty(&inode->i_lru)) {
 		list_add(&inode->i_lru, &inode_lru);
-		inodes_stat.nr_unused++;
+		this_cpu_inc(nr_unused);
 	}
 	spin_unlock(&inode_lru_lock);
 }
@@ -350,7 +356,7 @@ static void inode_lru_list_del(struct inode *inode)
 	spin_lock(&inode_lru_lock);
 	if (!list_empty(&inode->i_lru)) {
 		list_del_init(&inode->i_lru);
-		inodes_stat.nr_unused--;
+		this_cpu_dec(nr_unused);
 	}
 	spin_unlock(&inode_lru_lock);
 }
@@ -649,7 +655,7 @@ static void prune_icache(int nr_to_scan)
 		    (inode->i_state & ~I_REFERENCED)) {
 			list_del_init(&inode->i_lru);
 			spin_unlock(&inode->i_lock);
-			inodes_stat.nr_unused--;
+			this_cpu_dec(nr_unused);
 			continue;
 		}
 
@@ -686,7 +692,7 @@ static void prune_icache(int nr_to_scan)
 		spin_unlock(&inode->i_lock);
 
 		list_move(&inode->i_lru, &freeable);
-		inodes_stat.nr_unused--;
+		this_cpu_dec(nr_unused);
 	}
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
-- 
1.7.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
