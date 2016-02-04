Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8A81729E00
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 17:07:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6BDBD30405F
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 15:07:37 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Au3Uz2y3g5COds5N for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 15:07:35 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aRSxa-0000Eg-DC
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 10:05:10 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aRSxa-0004zL-Cb
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 10:05:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/7] libxfs: reset dirty buffer priority on lookup
Date: Fri,  5 Feb 2016 10:05:08 +1100
Message-Id: <1454627108-19036-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1454627108-19036-1-git-send-email-david@fromorbit.com>
References: <1454627108-19036-1-git-send-email-david@fromorbit.com>
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

When a buffer on the dirty MRU is looked up and found, we remove the
buffer from the MRU. However, we've already set the priority ofthe
buffer to "dirty" so when we are donw with it it will go back on the
dirty buffer MRU regardless of whether it needs to or not.

Hence when we move a buffer to a the dirty MRU, reocrd the old
priority and restore it when we remove the buffer from the MRU on
lookup. This will prevent us from putting fixed, now writeable
buffers back on the dirty MRU and allow the cache routine to write,
shake and reclaim the buffers once they are clean.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/cache.h | 1 +
 libxfs/cache.c  | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/include/cache.h b/include/cache.h
index 55761d3..3a989d7 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -99,6 +99,7 @@ struct cache_node {
 	unsigned int		cn_count;	/* reference count */
 	unsigned int		cn_hashidx;	/* hash chain index */
 	int			cn_priority;	/* priority, -1 = free list */
+	int			cn_old_priority;/* saved pre-dirty prio */
 	pthread_mutex_t		cn_mutex;	/* node mutex */
 };
 
diff --git a/libxfs/cache.c b/libxfs/cache.c
index d4b4a4e..0398be3 100644
--- a/libxfs/cache.c
+++ b/libxfs/cache.c
@@ -197,6 +197,7 @@ cache_move_to_dirty_mru(
 	mru = &cache->c_mrus[CACHE_DIRTY_PRIORITY];
 
 	pthread_mutex_lock(&mru->cm_mutex);
+	node->cn_old_priority = node->cn_priority;
 	node->cn_priority = CACHE_DIRTY_PRIORITY;
 	list_move(&node->cn_mru, &mru->cm_list);
 	mru->cm_count++;
@@ -325,6 +326,7 @@ cache_node_allocate(
 	list_head_init(&node->cn_mru);
 	node->cn_count = 1;
 	node->cn_priority = 0;
+	node->cn_old_priority = -1;
 	return node;
 }
 
@@ -434,6 +436,10 @@ cache_node_get(
 				mru->cm_count--;
 				list_del_init(&node->cn_mru);
 				pthread_mutex_unlock(&mru->cm_mutex);
+				if (node->cn_old_priority != -1) {
+					node->cn_priority = node->cn_old_priority;
+					node->cn_old_priority = -1;
+				}
 			}
 			node->cn_count++;
 
@@ -534,6 +540,7 @@ cache_node_set_priority(
 	pthread_mutex_lock(&node->cn_mutex);
 	ASSERT(node->cn_count > 0);
 	node->cn_priority = priority;
+	node->cn_old_priority = -1;
 	pthread_mutex_unlock(&node->cn_mutex);
 }
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
