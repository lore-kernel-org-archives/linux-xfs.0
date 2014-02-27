Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1A35B7F52
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 03:51:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0901C304051
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 01:51:34 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	lHbTsH0GWFCRzxC2 for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 01:51:33 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WIxcb-0007bz-D5
	for xfs@oss.sgi.com; Thu, 27 Feb 2014 20:51:17 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WIxcb-0007sb-C8
	for xfs@oss.sgi.com; Thu, 27 Feb 2014 20:51:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/10] libxfs: remove a couple of locks
Date: Thu, 27 Feb 2014 20:51:15 +1100
Message-Id: <1393494675-30194-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1393494675-30194-1-git-send-email-david@fromorbit.com>
References: <1393494675-30194-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

THe libxfs cache has a lot of false scalability about it. I can't
get lookups to scale past about one and half CPUs, with one of the
key problems being a preponderance of global locks.

Like just after doing a hash lookup, that is careful only to take
the hash chain lock, it takes a global cache lock to update the
cache hit statistic. Scalable? Not at all.

The node priority stuff is protected by the object locks (i.e the
buffer lock) and so it doesn't need locks, either.

This doesn't do very much to improve scalability, but it's a small
start.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/cache.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/libxfs/cache.c b/libxfs/cache.c
index dc69689..9f7f8f4 100644
--- a/libxfs/cache.c
+++ b/libxfs/cache.c
@@ -391,9 +391,7 @@ cache_node_get(
 			pthread_mutex_unlock(&node->cn_mutex);
 			pthread_mutex_unlock(&hash->ch_mutex);
 
-			pthread_mutex_lock(&cache->c_mutex);
 			cache->c_hits++;
-			pthread_mutex_unlock(&cache->c_mutex);
 
 			*nodep = node;
 			return 0;
@@ -482,10 +480,8 @@ cache_node_set_priority(
 	else if (priority > CACHE_MAX_PRIORITY)
 		priority = CACHE_MAX_PRIORITY;
 
-	pthread_mutex_lock(&node->cn_mutex);
 	ASSERT(node->cn_count > 0);
 	node->cn_priority = priority;
-	pthread_mutex_unlock(&node->cn_mutex);
 }
 
 int
@@ -494,9 +490,7 @@ cache_node_get_priority(
 {
 	int			priority;
 
-	pthread_mutex_lock(&node->cn_mutex);
 	priority = node->cn_priority;
-	pthread_mutex_unlock(&node->cn_mutex);
 
 	return priority;
 }
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
