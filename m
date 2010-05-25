Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4P8pIpK237206 for <xfs@oss.sgi.com>; Tue, 25 May 2010 03:51:18 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8CB251DFA471
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 01:53:39 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	2SskzJMHoiUkahUG for <xfs@oss.sgi.com>;
	Tue, 25 May 2010 01:53:39 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/5] superblock: add filesystem shrinker operations
Date: Tue, 25 May 2010 18:53:07 +1000
Message-Id: <1274777588-21494-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1274777588-21494-1-git-send-email-david@fromorbit.com>
References: <1274777588-21494-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4785656708750117531=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com

--===============4785656708750117531==
Content-Type: text/plain

From: Dave Chinner <dchinner@redhat.com>

Now we have a per-superblock shrinker implementation, we can add a
filesystem specific callout to it to allow filesystem internal
caches to be shrunk by the superblock shrinker.

Rather than perpetuate the multipurpose shrinker callback API (i.e.
nr_to_scan == 0 meaning "tell me how many objects freeable in the
cache), two operations will be added. The first will return the
number of objects that are freeable, the second is the actual
shrinker call.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/super.c         |   43 +++++++++++++++++++++++++++++++------------
 include/linux/fs.h |   11 +++++++++++
 2 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 07e22e3..9410218 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -40,7 +40,8 @@ DEFINE_SPINLOCK(sb_lock);
 static int prune_super(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
 {
 	struct super_block *sb;
-	int count;
+	int	fs_objects = 0;
+	int	total_objects;
 
 	sb = container_of(shrink, struct super_block, s_shrink);
 
@@ -63,22 +64,40 @@ static int prune_super(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
 		return -1;
 	}
 
-	if (nr_to_scan) {
-		/* proportion the scan between the two cacheѕ */
-		int total;
-
-		total = sb->s_nr_dentry_unused + sb->s_nr_inodes_unused + 1;
-		count = (nr_to_scan * sb->s_nr_dentry_unused) / total;
+	if (sb->s_op && sb->s_op->nr_cached_objects)
+		fs_objects = sb->s_op->nr_cached_objects(sb);
 
-		/* prune dcache first as icache is pinned by it */
-		prune_dcache_sb(sb, count);
-		prune_icache_sb(sb, nr_to_scan - count);
+	total_objects = sb->s_nr_dentry_unused +
+			sb->s_nr_inodes_unused + fs_objects + 1;
+	if (nr_to_scan) {
+		int	dentries;
+		int	inodes;
+
+		/* proportion the scan between the cacheѕ */
+		dentries = (nr_to_scan * sb->s_nr_dentry_unused) /
+							total_objects;
+		inodes = (nr_to_scan * sb->s_nr_inodes_unused) /
+							total_objects;
+		if (fs_objects)
+			fs_objects = (nr_to_scan * fs_objects) /
+							total_objects;
+		/*
+		 * prune the dcache first as the icache is pinned by it, then
+		 * prune the icache, followed by the filesystem specific caches
+		 */
+		prune_dcache_sb(sb, dentries);
+		prune_icache_sb(sb, inodes);
+		if (sb->s_op && sb->s_op->free_cached_objects) {
+			sb->s_op->free_cached_objects(sb, fs_objects);
+			fs_objects = sb->s_op->nr_cached_objects(sb);
+		}
+		total_objects = sb->s_nr_dentry_unused +
+				sb->s_nr_inodes_unused + fs_objects;
 	}
 
-	count = ((sb->s_nr_dentry_unused + sb->s_nr_inodes_unused) / 100)
-						* sysctl_vfs_cache_pressure;
+	total_objects = (total_objects / 100) * sysctl_vfs_cache_pressure;
 	up_read(&sb->s_umount);
-	return count;
+	return total_objects;
 }
 
 /**
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5bff2dc..efcdcc6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1590,6 +1590,17 @@ struct super_operations {
 	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
+
+	/*
+	 * memory shrinker operations.
+	 * ->nr_cached_objects() should return the number of freeable cached
+	 * objects the filesystem holds.
+	 * ->free_cache_objects() should attempt to free the number of cached
+	 * objects indicated. It should return how many objects it attempted to
+	 * free.
+	 */
+	int (*nr_cached_objects)(struct super_block *);
+	int (*free_cached_objects)(struct super_block *, int);
 };
 
 /*
-- 
1.5.6.5


--===============4785656708750117531==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4785656708750117531==--
