Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Nov 2007 16:32:18 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAM0W7s4010383
	for <xfs@oss.sgi.com>; Wed, 21 Nov 2007 16:32:12 -0800
Date: Thu, 22 Nov 2007 11:32:11 +1100
From: David Chinner <dgc@sgi.com>
Subject: [PATCH 1/9]: introduce radix_tree_gang_lookup_range
Message-ID: <20071122003211.GG114266761@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>


Introduce radix_tree_gang_lookup_range()

The inode clustering in XFS requires a gang lookup on the radix tree to
find all the inodes in the cluster.  The gang lookup has to set the
maximum items to that of a fully populated cluster so we get all the
inodes in the cluster, but we only populate the radix tree sparsely (on
demand).

As a result, the gang lookup can search way, way past the index of end
of the cluster because it is looking for a fixed number of entries to
return.

We know we want to terminate the search at either a specific index or a
maximum number of items, so we need to add a "last_index" parameter to
the lookup.

Furthermore, the existing radix_tree_gang_lookup() can use this same
function if we define a RADIX_TREE_MAX_INDEX value so the search is not
limited by the last_index.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 include/linux/radix-tree.h |    7 ++++-
 lib/radix-tree.c           |   55 ++++++++++++++++++++++++++++++++++++---------
 2 files changed, 51 insertions(+), 11 deletions(-)

Index: 2.6.x-xfs-new/include/linux/radix-tree.h
===================================================================
--- 2.6.x-xfs-new.orig/include/linux/radix-tree.h	2007-11-22 10:25:23.834502553 +1100
+++ 2.6.x-xfs-new/include/linux/radix-tree.h	2007-11-22 10:31:46.689597763 +1100
@@ -98,10 +98,11 @@ do {									\
  * radix_tree_lookup
  * radix_tree_tag_get
  * radix_tree_gang_lookup
+ * radix_tree_gang_lookup_range
  * radix_tree_gang_lookup_tag
  * radix_tree_tagged
  *
- * The first 4 functions are able to be called locklessly, using RCU. The
+ * The first 5 functions are able to be called locklessly, using RCU. The
  * caller must ensure calls to these functions are made within rcu_read_lock()
  * regions. Other readers (lock-free or otherwise) and modifications may be
  * running concurrently.
@@ -155,6 +156,10 @@ void *radix_tree_delete(struct radix_tre
 unsigned int
 radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
 			unsigned long first_index, unsigned int max_items);
+unsigned int
+radix_tree_gang_lookup_range(struct radix_tree_root *root, void **results,
+			unsigned long first_index, unsigned long last_index,
+			unsigned int max_items);
 int radix_tree_preload(gfp_t gfp_mask);
 void radix_tree_init(void);
 void *radix_tree_tag_set(struct radix_tree_root *root,
Index: 2.6.x-xfs-new/lib/radix-tree.c
===================================================================
--- 2.6.x-xfs-new.orig/lib/radix-tree.c	2007-11-22 10:31:24.564425190 +1100
+++ 2.6.x-xfs-new/lib/radix-tree.c	2007-11-22 10:31:46.693597252 +1100
@@ -62,6 +62,8 @@ struct radix_tree_path {
 #define RADIX_TREE_INDEX_BITS  (8 /* CHAR_BIT */ * sizeof(unsigned long))
 #define RADIX_TREE_MAX_PATH (RADIX_TREE_INDEX_BITS/RADIX_TREE_MAP_SHIFT + 2)
 
+#define RADIX_TREE_MAX_KEY	~0UL
+
 static unsigned long height_to_maxindex[RADIX_TREE_MAX_PATH] __read_mostly;
 
 /*
@@ -599,7 +601,8 @@ EXPORT_SYMBOL(radix_tree_tag_get);
 
 static unsigned int
 __lookup(struct radix_tree_node *slot, void **results, unsigned long index,
-	unsigned int max_items, unsigned long *next_index)
+	unsigned long last_index, unsigned int max_items,
+	unsigned long *next_index)
 {
 	unsigned int nr_found = 0;
 	unsigned int shift, height;
@@ -640,6 +643,8 @@ __lookup(struct radix_tree_node *slot, v
 			if (nr_found == max_items)
 				goto out;
 		}
+		if (index > last_index)
+			goto out;
 	}
 out:
 	*next_index = index;
@@ -647,27 +652,29 @@ out:
 }
 
 /**
- *	radix_tree_gang_lookup - perform multiple lookup on a radix tree
+ *	radix_tree_gang_lookup_range - perform multiple lookup on a radix tree
  *	@root:		radix tree root
  *	@results:	where the results of the lookup are placed
  *	@first_index:	start the lookup from this key
+ *	@last_index:	end the lookup at this key
  *	@max_items:	place up to this many items at *results
  *
- *	Performs an index-ascending scan of the tree for present items.  Places
- *	them at *@results and returns the number of items which were placed at
- *	*@results.
+ *	Performs an index-ascending scan of the tree for present items up to
+ *	@last_index in the tree.  Places them at *@results and returns the
+ *	number of items which were placed at *@results.
  *
  *	The implementation is naive.
  *
- *	Like radix_tree_lookup, radix_tree_gang_lookup may be called under
+ *	Like radix_tree_lookup, radix_tree_gang_lookup_range may be called under
  *	rcu_read_lock. In this case, rather than the returned results being
  *	an atomic snapshot of the tree at a single point in time, the semantics
  *	of an RCU protected gang lookup are as though multiple radix_tree_lookups
  *	have been issued in individual locks, and results stored in 'results'.
  */
 unsigned int
-radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
-			unsigned long first_index, unsigned int max_items)
+radix_tree_gang_lookup_range(struct radix_tree_root *root, void **results,
+			unsigned long first_index, unsigned long last_index,
+			unsigned int max_items)
 {
 	unsigned long max_index;
 	struct radix_tree_node *node;
@@ -686,7 +693,7 @@ radix_tree_gang_lookup(struct radix_tree
 		return 1;
 	}
 
-	max_index = radix_tree_maxindex(node->height);
+	max_index = min(last_index, radix_tree_maxindex(node->height));
 
 	ret = 0;
 	while (ret < max_items) {
@@ -695,7 +702,7 @@ radix_tree_gang_lookup(struct radix_tree
 
 		if (cur_index > max_index)
 			break;
-		nr_found = __lookup(node, results + ret, cur_index,
+		nr_found = __lookup(node, results + ret, cur_index, max_index,
 					max_items - ret, &next_index);
 		ret += nr_found;
 		if (next_index == 0)
@@ -705,6 +712,34 @@ radix_tree_gang_lookup(struct radix_tree
 
 	return ret;
 }
+EXPORT_SYMBOL(radix_tree_gang_lookup_range);
+
+/**
+ *	radix_tree_gang_lookup - perform multiple lookup on a radix tree
+ *	@root:		radix tree root
+ *	@results:	where the results of the lookup are placed
+ *	@first_index:	start the lookup from this key
+ *	@max_items:	place up to this many items at *results
+ *
+ *	Performs an index-ascending scan of the tree for present items.  Places
+ *	them at *@results and returns the number of items which were placed at
+ *	*@results.
+ *
+ *	The implementation is naive.
+ *
+ *	Like radix_tree_lookup, radix_tree_gang_lookup may be called under
+ *	rcu_read_lock. In this case, rather than the returned results being
+ *	an atomic snapshot of the tree at a single point in time, the semantics
+ *	of an RCU protected gang lookup are as though multiple radix_tree_lookups
+ *	have been issued in individual locks, and results stored in 'results'.
+ */
+unsigned int
+radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
+			unsigned long first_index, unsigned int max_items)
+{
+	return radix_tree_gang_lookup_range(root, results, first_index,
+						RADIX_TREE_MAX_KEY, max_items);
+}
 EXPORT_SYMBOL(radix_tree_gang_lookup);
 
 /*
