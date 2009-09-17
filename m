Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8HG5BIK206962 for <xfs@oss.sgi.com>; Thu, 17 Sep 2009 11:05:12 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4B241687694
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2009 09:06:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GUDpImOIGP00GO1Q for
	<xfs@oss.sgi.com>; Thu, 17 Sep 2009 09:06:25 -0700 (PDT)
Message-ID: <4AB25E78.8050001@redhat.com>
Date: Thu, 17 Sep 2009 11:06:16 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] libxfs: increase hash chain depth when we run out of slots
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>
Cc: Tomek Kruszona <bloodyscarion@gmail.com>, Riku Paananen <riku.paananen@helsinki.fi>

A couple people reported xfs_repair hangs after
"Traversing filesystem ..." in xfs_repair.  This happens
when all slots in the cache are full and referenced, and the
loop in cache_node_get() which tries to shake unused entries
fails to find any - it just keeps upping the priority and goes
forever.

This can be worked around by restarting xfs_repair with
-P and/or "-o bhash=<largersize>" for older xfs_repair.

I started down the path of increasing the number of hash buckets
on the fly, but Barry suggested simply increasing the max allowed
depth which is much simpler (thanks!)

Resizing the hash lengths does mean that cache_report ends up with
most things in the "greater-than" category:

...
Hash buckets with  23 entries      3 (  3%)
Hash buckets with  24 entries      3 (  3%)
Hash buckets with >24 entries     50 ( 85%)

but I think I'll save that fix for another patch unless there's
real concern right now.

I tested this on the metadump image provided by Tomek.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
Reported-by: Tomek Kruszona <bloodyscarion@gmail.com>
Reported-by: Riku Paananen <riku.paananen@helsinki.fi>
---

diff --git a/libxfs/cache.c b/libxfs/cache.c
index 48f91d7..56b24e7 100644
--- a/libxfs/cache.c
+++ b/libxfs/cache.c
@@ -83,6 +83,18 @@ cache_init(
 }
 
 void
+cache_expand(
+	struct cache *		cache)
+{
+	pthread_mutex_lock(&cache->c_mutex);
+#ifdef CACHE_DEBUG
+	fprintf(stderr, "doubling cache size to %d\n", 2 * cache->c_maxcount);
+#endif
+	cache->c_maxcount *= 2;
+	pthread_mutex_unlock(&cache->c_mutex);
+}
+
+void
 cache_walk(
 	struct cache *		cache,
 	cache_walk_t		visit)
@@ -344,6 +356,15 @@ cache_node_get(
 		if (node)
 			break;
 		priority = cache_shake(cache, priority, 0);
+		/*
+		 * We start at 0; if we free CACHE_SHAKE_COUNT we get
+		 * back the same priority, if not we get back priority+1.
+		 * If we exceed CACHE_MAX_PRIORITY all slots are full; grow it.
+		 */
+		if (priority > CACHE_MAX_PRIORITY) {
+			priority = 0;
+			cache_expand(cache);
+		}
 	}
 
 	node->cn_hashidx = hashidx;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
