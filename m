Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:50829 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727687AbeJ3UN6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Oct 2018 16:13:58 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gHS4k-0005bs-UI
        for linux-xfs@vger.kernel.org; Tue, 30 Oct 2018 22:20:47 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gHS4k-0001jc-So
        for linux-xfs@vger.kernel.org; Tue, 30 Oct 2018 22:20:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/7] cache: prevent expansion races
Date: Tue, 30 Oct 2018 22:20:39 +1100
Message-Id: <20181030112043.6034-4-david@fromorbit.com>
In-Reply-To: <20181030112043.6034-1-david@fromorbit.com>
References: <20181030112043.6034-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When a sudden buffer cache growth demand occurs from multiple
concurrent sources, they can all fail shaking the cache at the same
time and expand the cache. This results in the cache doubling in
size multiple times when only a single expansion was really
necessary. The resultant massive cache can cause repair to OOM as
the cache will grow to much larger than memory can actually hold.

Prevent this sudden and unnecessary expansion by rate limiting cache
growth to one size increase every tens seconds. This is sufficient
to prevent racing expansion calls from doing the wrong thing, but
not too long to prevent necesary cache growth when it is undersized.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/cache.h |  1 +
 libxfs/cache.c  | 17 ++++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index 552b92489e46..1b774619f7a0 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -114,6 +114,7 @@ struct cache {
 	unsigned long long	c_misses;	/* cache misses */
 	unsigned long long	c_hits;		/* cache hits */
 	unsigned int 		c_max;		/* max nodes ever used */
+	time_t			expand_time;	/* time of last expansion */
 };
 
 struct cache *cache_init(int, unsigned int, struct cache_operations *);
diff --git a/libxfs/cache.c b/libxfs/cache.c
index 139c7c1b9e71..e10df395e60e 100644
--- a/libxfs/cache.c
+++ b/libxfs/cache.c
@@ -62,6 +62,7 @@ cache_init(
 	cache->bulkrelse = cache_operations->bulkrelse ?
 		cache_operations->bulkrelse : cache_generic_bulkrelse;
 	pthread_mutex_init(&cache->c_mutex, NULL);
+	time(&cache->expand_time);
 
 	for (i = 0; i < hashsize; i++) {
 		list_head_init(&cache->c_hash[i].ch_list);
@@ -77,15 +78,25 @@ cache_init(
 	return cache;
 }
 
+/*
+ * rate limit expansion so several concurrent shakes don't instantly all
+ * expand the cache multiple times and blow repair to OOM death.
+ */
 static void
 cache_expand(
-	struct cache *		cache)
+	struct cache	*cache)
 {
+	time_t		now;
+
 	pthread_mutex_lock(&cache->c_mutex);
+	time(&now);
+	if (now - cache->expand_time > 10) {
 #ifdef CACHE_DEBUG
-	fprintf(stderr, "doubling cache size to %d\n", 2 * cache->c_maxcount);
+		fprintf(stderr, "doubling cache size to %d\n", 2 * cache->c_maxcount);
 #endif
-	cache->c_maxcount *= 2;
+		cache->c_maxcount *= 2;
+		cache->expand_time = now;
+	}
 	pthread_mutex_unlock(&cache->c_mutex);
 }
 
-- 
2.19.1
