Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82Hvi8H034369 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 12:57:59 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5EBC841E03E
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 10:58:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id aPadCMhukC8Dav4Y for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 10:58:41 -0700 (PDT)
Message-Id: <20090902175840.740632507@bombadil.infradead.org>
Date: Wed, 02 Sep 2009 13:55:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 06/14] repair: use a btree instead of a radix tree for the
	prefetch queue
References: <20090902175531.469184575@bombadil.infradead.org>
Content-Disposition: inline; filename=repair-radix-to-btree
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
To: xfs@oss.sgi.com
Cc: Barry Naujok <bnaujok@sgi.com>

Currently the prefetch queue in xfs_repair uses a radix tree implementation
derived from the Linux kernel one to manage it's prefetch queue.

The radix tree implement is not very memory efficient for sparse indices,
so replace it with a btree implementation that is much more efficient.
This is not that important for the prefetch queue but will be very important
for the next memory optimization patches which need a tree to store things
like the block map which are very sparse, and we do not want to deal with
two tree implementations (or rather three given that we still have avl.c
around)

Signed-off-by: Barry Naujok <bnaujok@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/Makefile
===================================================================
--- xfsprogs-dev.orig/repair/Makefile	2009-08-20 00:01:58.000000000 +0000
+++ xfsprogs-dev/repair/Makefile	2009-08-20 00:06:43.000000000 +0000
@@ -9,15 +9,15 @@
 
 LTCOMMAND = xfs_repair
 
-HFILES = agheader.h attr_repair.h avl.h avl64.h bmap.h dinode.h dir.h \
-	dir2.h err_protos.h globals.h incore.h protos.h rt.h \
-	progress.h scan.h versions.h prefetch.h radix-tree.h threads.h
+HFILES = agheader.h attr_repair.h avl.h avl64.h bmap.h btree.h \
+	dinode.h dir.h dir2.h err_protos.h globals.h incore.h protos.h rt.h \
+	progress.h scan.h versions.h prefetch.h threads.h
 
-CFILES = agheader.c attr_repair.c avl.c avl64.c bmap.c dino_chunks.c \
-	dinode.c dir.c dir2.c globals.c incore.c \
+CFILES = agheader.c attr_repair.c avl.c avl64.c bmap.c btree.c \
+	dino_chunks.c dinode.c dir.c dir2.c globals.c incore.c \
 	incore_bmc.c init.c incore_ext.c incore_ino.c phase1.c \
 	phase2.c phase3.c phase4.c phase5.c phase6.c phase7.c \
-	progress.c prefetch.c radix-tree.c rt.c sb.c scan.c threads.c \
+	progress.c prefetch.c rt.c sb.c scan.c threads.c \
 	versions.c xfs_repair.c
 
 LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
Index: xfsprogs-dev/repair/btree.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfsprogs-dev/repair/btree.c	2009-08-20 00:06:44.000000000 +0000
@@ -0,0 +1,1234 @@
+/*
+ * Copyright (c) 2007, Silicon Graphics, Inc. Barry Naujok <bnaujok@sgi.com>
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <libxfs.h>
+#include "btree.h"
+
+
+#define BTREE_KEY_MAX		7
+#define BTREE_KEY_MIN		(BTREE_KEY_MAX / 2)
+
+#define BTREE_PTR_MAX		(BTREE_KEY_MAX + 1)
+
+struct btree_node {
+	unsigned long		num_keys;
+	unsigned long		keys[BTREE_KEY_MAX];
+	struct btree_node *	ptrs[BTREE_PTR_MAX];
+};
+
+struct btree_cursor {
+	struct btree_node	*node;
+	int			index;
+};
+
+struct btree_root {
+	struct btree_node	*root_node;
+	struct btree_cursor	*cursor;	/* track path to end leaf */
+	int			height;
+	/* lookup cache */
+	int			keys_valid;	/* set if the cache is valid */
+	unsigned long		cur_key;
+	unsigned long		next_key;
+	void			*next_value;
+	unsigned long		prev_key;
+	void			*prev_value;
+#ifdef BTREE_STATS
+	struct btree_stats {
+		unsigned long	num_items;
+		unsigned long	max_items;
+		int		alloced;
+		int		cache_hits;
+		int		cache_misses;
+		int		lookup;
+		int		find;
+		int		key_update;
+		int		value_update;
+		int		insert;
+		int		delete;
+		int		inc_height;
+		int		dec_height;
+		int		shift_prev;
+		int		shift_next;
+		int		split;
+		int		merge_prev;
+		int		merge_next;
+		int		balance_prev;
+		int		balance_next;
+	} stats;
+#endif
+};
+
+
+static struct btree_node *
+btree_node_alloc(void)
+{
+	return calloc(1, sizeof(struct btree_node));
+}
+
+static void
+btree_node_free(
+	struct btree_node 	*node)
+{
+	free(node);
+}
+
+static void
+btree_free_nodes(
+	struct btree_node	*node,
+	int			level)
+{
+	int			i;
+
+	if (level)
+		for (i = 0; i <= node->num_keys; i++)
+			btree_free_nodes(node->ptrs[i], level - 1);
+	btree_node_free(node);
+}
+
+static void
+__btree_init(
+	struct btree_root	*root)
+{
+	memset(root, 0, sizeof(struct btree_root));
+	root->height = 1;
+	root->cursor = calloc(1, sizeof(struct btree_cursor));
+	root->root_node = btree_node_alloc();
+	ASSERT(root->root_node);
+#ifdef BTREE_STATS
+	root->stats.max_items = 1;
+	root->stats.alloced += 1;
+#endif
+}
+
+static void
+__btree_free(
+	struct btree_root	*root)
+{
+	btree_free_nodes(root->root_node, root->height - 1);
+	free(root->cursor);
+	root->height = 0;
+	root->cursor = NULL;
+	root->root_node = NULL;
+}
+
+void
+btree_init(
+	struct btree_root	**root)
+{
+	*root = calloc(1, sizeof(struct btree_root));
+	__btree_init(*root);
+}
+
+void
+btree_clear(
+	struct btree_root	*root)
+{
+	__btree_free(root);
+	__btree_init(root);
+}
+
+void
+btree_destroy(
+	struct btree_root	*root)
+{
+	__btree_free(root);
+	free(root);
+}
+
+int
+btree_is_empty(
+	struct btree_root	*root)
+{
+	return root->root_node->num_keys == 0;
+}
+
+static inline void
+btree_invalidate_cursor(
+	struct btree_root	*root)
+{
+	root->cursor[0].node = NULL;
+	root->keys_valid = 0;
+}
+
+static inline unsigned long
+btree_key_of_cursor(
+	struct btree_cursor	*cursor,
+	int			height)
+{
+	while (cursor->node->num_keys == cursor->index && --height > 0)
+		cursor++;
+	return cursor->node->keys[cursor->index];
+}
+
+static void *
+btree_get_prev(
+	struct btree_root	*root,
+	unsigned long		*key)
+{
+	struct btree_cursor	*cur = root->cursor;
+	int			level = 0;
+	struct btree_node	*node;
+
+	if (cur->index > 0) {
+		if (key)
+			*key = cur->node->keys[cur->index - 1];
+		return cur->node->ptrs[cur->index - 1];
+	}
+
+	/* else need to go up and back down the tree to find the previous */
+
+	while (cur->index == 0) {
+		if (++level == root->height)
+			return NULL;
+		cur++;
+	}
+
+	/* the key is in the current level */
+	if (key)
+		*key = cur->node->keys[cur->index - 1];
+
+	/* descend back down the right side to get the pointer */
+	node = cur->node->ptrs[cur->index - 1];
+	while (level--)
+		node = node->ptrs[node->num_keys];
+	return node;
+}
+
+static void *
+btree_get_next(
+	struct btree_root	*root,
+	unsigned long		*key)
+{
+	struct btree_cursor	*cur = root->cursor;
+	int			level = 0;
+	struct btree_node	*node;
+
+	while (cur->index == cur->node->num_keys) {
+		if (++level == root->height)
+			return NULL;
+		cur++;
+	}
+	if (level == 0) {
+		if (key) {
+			cur->index++;
+			*key = btree_key_of_cursor(cur, root->height);
+			cur->index--;
+		}
+		return cur->node->ptrs[cur->index + 1];
+	}
+
+	node = cur->node->ptrs[cur->index + 1];
+	while (--level > 0)
+		node = node->ptrs[0];
+	if (key)
+		*key = node->keys[0];
+	return node->ptrs[0];
+}
+
+/*
+ * Lookup/Search functions
+ */
+
+static int
+btree_do_search(
+	struct btree_root	*root,
+	unsigned long		key)
+{
+	unsigned long		k = 0;
+	struct btree_cursor	*cur = root->cursor + root->height;
+	struct btree_node	*node = root->root_node;
+	int			height = root->height;
+	int			key_found = 0;
+	int			i;
+
+	while (--height >= 0) {
+		cur--;
+		for (i = 0; i < node->num_keys; i++)
+			if (node->keys[i] >= key) {
+				k = node->keys[i];
+				key_found = 1;
+				break;
+			}
+		cur->node = node;
+		cur->index = i;
+		node = node->ptrs[i];
+	}
+	root->keys_valid = key_found;
+	if (!key_found)
+		return 0;
+
+	root->cur_key = k;
+	root->next_value = NULL;	/* do on-demand next value lookup */
+	root->prev_value = btree_get_prev(root, &root->prev_key);
+	return 1;
+}
+
+static int
+btree_search(
+	struct btree_root	*root,
+	unsigned long		key)
+{
+	if (root->keys_valid && key <= root->cur_key &&
+				(!root->prev_value || key > root->prev_key)) {
+#ifdef BTREE_STATS
+		root->stats.cache_hits++;
+#endif
+		return 1;
+	}
+#ifdef BTREE_STATS
+	root->stats.cache_misses++;
+#endif
+	return btree_do_search(root, key);
+}
+
+void *
+btree_find(
+	struct btree_root	*root,
+	unsigned long		key,
+	unsigned long		*actual_key)
+{
+#ifdef BTREE_STATS
+	root->stats.find += 1;
+#endif
+	if (!btree_search(root, key))
+		return NULL;
+
+	if (actual_key)
+		*actual_key = root->cur_key;
+	return root->cursor->node->ptrs[root->cursor->index];
+}
+
+void *
+btree_lookup(
+	struct btree_root	*root,
+	unsigned long		key)
+{
+#ifdef BTREE_STATS
+	root->stats.lookup += 1;
+#endif
+	if (!btree_search(root, key) || root->cur_key != key)
+		return NULL;
+	return root->cursor->node->ptrs[root->cursor->index];
+}
+
+void *
+btree_peek_prev(
+	struct btree_root	*root,
+	unsigned long		*key)
+{
+	if (!root->keys_valid)
+		return NULL;
+	if (key)
+		*key = root->prev_key;
+	return root->prev_value;
+}
+
+void *
+btree_peek_next(
+	struct btree_root	*root,
+	unsigned long		*key)
+{
+	if (!root->keys_valid)
+		return NULL;
+	if (!root->next_value)
+		root->next_value = btree_get_next(root, &root->next_key);
+	if (key)
+		*key = root->next_key;
+	return root->next_value;
+}
+
+static void *
+btree_move_cursor_to_next(
+	struct btree_root	*root,
+	unsigned long		*key)
+{
+	struct btree_cursor	*cur = root->cursor;
+	int			level = 0;
+
+	while (cur->index == cur->node->num_keys) {
+		if (++level == root->height)
+			return NULL;
+		cur++;
+	}
+	cur->index++;
+	if (level == 0) {
+		if (key)
+			*key = btree_key_of_cursor(cur, root->height);
+		return cur->node->ptrs[cur->index];
+	}
+
+	while (--level >= 0) {
+		root->cursor[level].node = cur->node->ptrs[cur->index];
+		root->cursor[level].index = 0;
+		cur--;
+	}
+	if (key)
+		*key = cur->node->keys[0];
+	return cur->node->ptrs[0];
+}
+
+void *
+btree_lookup_next(
+	struct btree_root	*root,
+	unsigned long		*key)
+{
+	void			*value;
+
+	if (!root->keys_valid)
+		return NULL;
+
+	root->prev_key = root->cur_key;
+	root->prev_value = root->cursor->node->ptrs[root->cursor->index];
+
+	value = btree_move_cursor_to_next(root, &root->cur_key);
+	if (!value) {
+		btree_invalidate_cursor(root);
+		return NULL;
+ 	}
+ 	root->next_value = NULL;	/* on-demand next value fetch */
+	if (key)
+		*key = root->cur_key;
+	return value;
+}
+
+static void *
+btree_move_cursor_to_prev(
+	struct btree_root	*root,
+	unsigned long		*key)
+{
+	struct btree_cursor	*cur = root->cursor;
+	int			level = 0;
+
+	while (cur->index == 0) {
+		if (++level == root->height)
+			return NULL;
+		cur++;
+	}
+	cur->index--;
+	if (key)	/* the key is in the current level */
+		*key = cur->node->keys[cur->index];
+	while (level > 0) {
+		level--;
+		root->cursor[level].node = cur->node->ptrs[cur->index];
+		root->cursor[level].index = root->cursor[level].node->num_keys;
+		cur--;
+	}
+	return cur->node->ptrs[cur->index];
+}
+
+void *
+btree_lookup_prev(
+	struct btree_root	*root,
+	unsigned long		*key)
+{
+	void			*value;
+
+	if (!root->keys_valid)
+		return NULL;
+
+	value = btree_move_cursor_to_prev(root, &root->cur_key);
+	if (!value)
+		return NULL;
+	root->prev_value = btree_get_prev(root, &root->prev_key);
+ 	root->next_value = NULL;	/* on-demand next value fetch */
+	if (key)
+		*key = root->cur_key;
+	return value;
+}
+
+void *
+btree_uncached_lookup(
+	struct btree_root	*root,
+	unsigned long		key)
+{
+	/* cursor-less (ie. uncached) lookup */
+	int			height = root->height - 1;
+	struct btree_node	*node = root->root_node;
+	int			i;
+	int			key_found = 0;
+
+	while (height >= 0) {
+		for (i = 0; i < node->num_keys; i++)
+			if (node->keys[i] >= key) {
+				key_found = node->keys[i] == key;
+				break;
+			}
+		node = node->ptrs[i];
+		height--;
+	}
+	return key_found ? node : NULL;
+}
+
+/* Update functions */
+
+static inline void
+btree_update_node_key(
+	struct btree_root	*root,
+	struct btree_cursor	*cursor,
+	int			level,
+	unsigned long		new_key)
+{
+	int			i;
+
+#ifdef BTREE_STATS
+	root->stats.key_update += 1;
+#endif
+
+	cursor += level;
+	for (i = level; i < root->height; i++) {
+		if (cursor->index < cursor->node->num_keys) {
+			cursor->node->keys[cursor->index] = new_key;
+			break;
+		}
+		cursor++;
+	}
+}
+
+int
+btree_update_key(
+	struct btree_root	*root,
+	unsigned long		old_key,
+	unsigned long		new_key)
+{
+	if (!btree_search(root, old_key) || root->cur_key != old_key)
+		return ENOENT;
+
+	if (root->next_value && new_key >= root->next_key)
+		return EINVAL;
+
+	if (root->prev_value && new_key <= root->prev_key)
+		return EINVAL;
+
+	btree_update_node_key(root, root->cursor, 0, new_key);
+
+	return 0;
+}
+
+int
+btree_update_value(
+	struct btree_root	*root,
+	unsigned long		key,
+	void			*new_value)
+{
+	if (!new_value)
+		return EINVAL;
+
+	if (!btree_search(root, key) || root->cur_key != key)
+		return ENOENT;
+
+#ifdef BTREE_STATS
+	root->stats.value_update += 1;
+#endif
+	root->cursor->node->ptrs[root->cursor->index] = new_value;
+
+	return 0;
+}
+
+/*
+ * Cursor modification functions - used for inserting and deleting
+ */
+
+static struct btree_cursor *
+btree_copy_cursor_prev(
+	struct btree_root	*root,
+	struct btree_cursor	*dest_cursor,
+	int			level)
+{
+	struct btree_cursor	*src_cur = root->cursor + level;
+	struct btree_cursor	*dst_cur;
+	int			l = level;
+	int			i;
+
+	if (level >= root->height)
+		return NULL;
+
+	while (src_cur->index == 0) {
+		if (++l >= root->height)
+			return NULL;
+		src_cur++;
+	}
+	for (i = l; i < root->height; i++)
+		dest_cursor[i] = *src_cur++;
+
+	dst_cur = dest_cursor + l;
+	dst_cur->index--;
+	while (l-- >= level) {
+		dest_cursor[l].node = dst_cur->node->ptrs[dst_cur->index];
+		dest_cursor[l].index = dest_cursor[l].node->num_keys;
+		dst_cur--;
+	}
+	return dest_cursor;
+}
+
+static struct btree_cursor *
+btree_copy_cursor_next(
+	struct btree_root	*root,
+	struct btree_cursor	*dest_cursor,
+	int			level)
+{
+	struct btree_cursor	*src_cur = root->cursor + level;
+	struct btree_cursor	*dst_cur;
+	int			l = level;
+	int			i;
+
+	if (level >= root->height)
+		return NULL;
+
+	while (src_cur->index == src_cur->node->num_keys) {
+		if (++l >= root->height)
+			return NULL;
+		src_cur++;
+	}
+	for (i = l; i < root->height; i++)
+		dest_cursor[i] = *src_cur++;
+
+	dst_cur = dest_cursor + l;
+	dst_cur->index++;
+	while (l-- >= level) {
+		dest_cursor[l].node = dst_cur->node->ptrs[dst_cur->index];
+		dest_cursor[l].index = 0;
+		dst_cur--;
+	}
+	return dest_cursor;
+}
+
+/*
+ * Shift functions
+ *
+ * Tries to move items in the current leaf to its sibling if it has space.
+ * Used in both insert and delete functions.
+ * Returns the number of items shifted.
+ */
+
+static int
+btree_shift_to_prev(
+	struct btree_root	*root,
+	int			level,
+	struct btree_cursor	*prev_cursor,
+	int			num_children)
+{
+	struct btree_node	*node;
+	struct btree_node	*prev_node;
+	int			num_remain;	/* # of keys left in "node" */
+	unsigned long		key;
+	int			i;
+
+	if (!prev_cursor || !num_children)
+		return 0;
+
+	prev_node = prev_cursor[level].node;
+	node = root->cursor[level].node;
+
+	ASSERT(num_children > 0 && num_children <= node->num_keys + 1);
+
+	if ((prev_node->num_keys + num_children) > BTREE_KEY_MAX)
+		return 0;
+
+#ifdef BTREE_STATS
+	root->stats.shift_prev += 1;
+#endif
+
+	num_remain = node->num_keys - num_children;
+	ASSERT(num_remain == -1 || num_remain >= BTREE_KEY_MIN);
+
+	/* shift parent keys around */
+	level++;
+	if (num_remain > 0)
+		key = node->keys[num_children - 1];
+	else
+		key = btree_key_of_cursor(root->cursor + level,
+						root->height - level);
+	while (prev_cursor[level].index == prev_cursor[level].node->num_keys) {
+		level++;
+		ASSERT(level < root->height);
+	}
+	prev_node->keys[prev_node->num_keys] =
+			prev_cursor[level].node->keys[prev_cursor[level].index];
+	prev_cursor[level].node->keys[prev_cursor[level].index] = key;
+
+	/* copy pointers and keys to the end of the prev node */
+	for (i = 0; i < num_children - 1; i++) {
+		prev_node->keys[prev_node->num_keys + 1 + i] = node->keys[i];
+		prev_node->ptrs[prev_node->num_keys + 1 + i] = node->ptrs[i];
+	}
+	prev_node->ptrs[prev_node->num_keys + 1 + i] = node->ptrs[i];
+	prev_node->num_keys += num_children;
+
+	/* move remaining pointers/keys to start of node */
+	if (num_remain >= 0) {
+		for (i = 0; i < num_remain; i++) {
+			node->keys[i] = node->keys[num_children + i];
+			node->ptrs[i] = node->ptrs[num_children + i];
+		}
+		node->ptrs[i] = node->ptrs[num_children + i];
+		node->num_keys = num_remain;
+	} else
+		node->num_keys = 0;
+
+	return num_children;
+}
+
+static int
+btree_shift_to_next(
+	struct btree_root	*root,
+	int			level,
+	struct btree_cursor	*next_cursor,
+	int			num_children)
+{
+	struct btree_node	*node;
+	struct btree_node	*next_node;
+	int			num_remain;	/* # of children left in node */
+	int			i;
+
+	if (!next_cursor || !num_children)
+		return 0;
+
+	node = root->cursor[level].node;
+	next_node = next_cursor[level].node;
+
+	ASSERT(num_children > 0 && num_children <= node->num_keys + 1);
+
+	if ((next_node->num_keys + num_children) > BTREE_KEY_MAX)
+		return 0;
+
+	num_remain = node->num_keys + 1 - num_children;
+	ASSERT(num_remain == 0 || num_remain > BTREE_KEY_MIN);
+
+#ifdef BTREE_STATS
+	root->stats.shift_next += 1;
+#endif
+
+	/* make space for "num_children" items at beginning of next-leaf */
+	i = next_node->num_keys;
+	next_node->ptrs[num_children + i] = next_node->ptrs[i];
+	while (--i >= 0) {
+		next_node->keys[num_children + i] = next_node->keys[i];
+		next_node->ptrs[num_children + i] = next_node->ptrs[i];
+	}
+
+	/* update keys in parent and next node from parent */
+	do {
+		level++;
+		ASSERT(level < root->height);
+	} while (root->cursor[level].index == root->cursor[level].node->num_keys);
+
+	next_node->keys[num_children - 1] =
+		root->cursor[level].node->keys[root->cursor[level].index];
+	root->cursor[level].node->keys[root->cursor[level].index] =
+		node->keys[node->num_keys - num_children];
+
+	/* copy last "num_children" items from node into start of next-node */
+	for (i = 0; i < num_children - 1; i++) {
+		next_node->keys[i] = node->keys[num_remain + i];
+		next_node->ptrs[i] = node->ptrs[num_remain + i];
+	}
+	next_node->ptrs[i] = node->ptrs[num_remain + i];
+	next_node->num_keys += num_children;
+
+	if (num_remain > 0)
+		node->num_keys -= num_children;
+	else
+		node->num_keys = 0;
+
+	return num_children;
+}
+
+/*
+ * Insertion functions
+ */
+
+static struct btree_node *
+btree_increase_height(
+	struct btree_root	*root)
+{
+	struct btree_node	*new_root;
+	struct btree_cursor	*new_cursor;
+
+	new_cursor = realloc(root->cursor, (root->height + 1) *
+				sizeof(struct btree_cursor));
+	if (!new_cursor)
+		return NULL;
+	root->cursor = new_cursor;
+
+	new_root = btree_node_alloc();
+	if (!new_root)
+		return NULL;
+
+#ifdef BTREE_STATS
+	root->stats.alloced += 1;
+	root->stats.inc_height += 1;
+	root->stats.max_items *= BTREE_PTR_MAX;
+#endif
+
+	new_root->ptrs[0] = root->root_node;
+	root->root_node = new_root;
+
+	root->cursor[root->height].node = new_root;
+	root->cursor[root->height].index = 0;
+
+	root->height++;
+
+	return new_root;
+}
+
+static int
+btree_insert_item(
+	struct btree_root	*root,
+	int			level,
+	unsigned long		key,
+	void			*value);
+
+
+static struct btree_node *
+btree_split(
+	struct btree_root	*root,
+	int			level,
+	unsigned long		key,
+	int			*index)
+{
+	struct btree_node	*node = root->cursor[level].node;
+	struct btree_node	*new_node;
+	int			i;
+
+	new_node = btree_node_alloc();
+	if (!new_node)
+		return NULL;
+
+	if (btree_insert_item(root, level + 1, node->keys[BTREE_KEY_MIN],
+							new_node) != 0) {
+		btree_node_free(new_node);
+		return NULL;
+	}
+
+#ifdef BTREE_STATS
+	root->stats.alloced += 1;
+	root->stats.split += 1;
+#endif
+
+	for (i = 0; i < BTREE_KEY_MAX - BTREE_KEY_MIN - 1; i++) {
+		new_node->keys[i] = node->keys[BTREE_KEY_MIN + 1 + i];
+		new_node->ptrs[i] = node->ptrs[BTREE_KEY_MIN + 1 + i];
+	}
+	new_node->ptrs[i] = node->ptrs[BTREE_KEY_MIN + 1 + i];
+	new_node->num_keys = BTREE_KEY_MAX - BTREE_KEY_MIN - 1;
+
+	node->num_keys = BTREE_KEY_MIN;
+	if (key < node->keys[BTREE_KEY_MIN])
+		return node;	/* index doesn't change */
+
+	/* insertion point is in new node... */
+	*index -= BTREE_KEY_MIN + 1;
+	return new_node;
+}
+
+static int
+btree_insert_shift_to_prev(
+	struct btree_root	*root,
+	int			level,
+	int			*index)
+{
+	struct btree_cursor	tmp_cursor[root->height];
+	int			n;
+
+	if (*index <= 0)
+		return -1;
+
+	if (!btree_copy_cursor_prev(root, tmp_cursor, level + 1))
+		return -1;
+
+	n = MIN(*index, (BTREE_PTR_MAX - tmp_cursor[level].node->num_keys) / 2);
+	if (!n || !btree_shift_to_prev(root, level, tmp_cursor, n))
+		return -1;
+
+	*index -= n;
+	return 0;
+}
+
+static int
+btree_insert_shift_to_next(
+	struct btree_root	*root,
+	int			level,
+	int			*index)
+{
+	struct btree_cursor	tmp_cursor[root->height];
+	int			n;
+
+	if (*index >= BTREE_KEY_MAX)
+		return -1;
+
+	if (!btree_copy_cursor_next(root, tmp_cursor, level + 1))
+		return -1;
+
+	n = MIN(BTREE_KEY_MAX - *index,
+		(BTREE_PTR_MAX - tmp_cursor[level].node->num_keys) / 2);
+	if (!n || !btree_shift_to_next(root, level, tmp_cursor, n))
+		return -1;
+	return 0;
+}
+
+static int
+btree_insert_item(
+	struct btree_root	*root,
+	int			level,
+	unsigned long		key,
+	void			*value)
+{
+	struct btree_node	*node = root->cursor[level].node;
+	int			index = root->cursor[level].index;
+	int			i;
+
+	if (node->num_keys == BTREE_KEY_MAX) {
+		if (btree_insert_shift_to_prev(root, level, &index) == 0)
+			goto insert;
+		if (btree_insert_shift_to_next(root, level, &index) == 0)
+			goto insert;
+		if (level == root->height - 1) {
+			if (!btree_increase_height(root))
+				return ENOMEM;
+		}
+		node = btree_split(root, level, key, &index);
+		if (!node)
+			return ENOMEM;
+	}
+insert:
+	ASSERT(index <= node->num_keys);
+
+	i = node->num_keys;
+	node->ptrs[i + 1] = node->ptrs[i];
+	while (--i >= index) {
+		node->keys[i + 1] = node->keys[i];
+		node->ptrs[i + 1] = node->ptrs[i];
+	}
+
+	node->num_keys++;
+	node->keys[index] = key;
+
+	if (level == 0)
+		node->ptrs[index] = value;
+	else
+		node->ptrs[index + 1] = value;
+
+	return 0;
+}
+
+
+
+int
+btree_insert(
+	struct btree_root	*root,
+	unsigned long		key,
+	void			*value)
+{
+	int			result;
+
+	if (!value)
+		return EINVAL;
+
+	if (btree_search(root, key) && root->cur_key == key)
+		return EEXIST;
+
+#ifdef BTREE_STATS
+	root->stats.insert += 1;
+	root->stats.num_items += 1;
+#endif
+
+	result = btree_insert_item(root, 0, key, value);
+
+	btree_invalidate_cursor(root);
+
+	return result;
+}
+
+
+/*
+ * Deletion functions
+ *
+ * Rather more complicated as deletions has 4 ways to go once a node
+ * ends up with less than the minimum number of keys:
+ *   - move remainder to previous node
+ *   - move remainder to next node
+ *       (both will involve a parent deletion which may recurse)
+ *   - balance by moving some items from previous node
+ *   - balance by moving some items from next node
+ */
+
+static void
+btree_decrease_height(
+	struct btree_root	*root)
+{
+	struct btree_node	*old_root = root->root_node;
+
+	ASSERT(old_root->num_keys == 0);
+
+#ifdef BTREE_STATS
+	root->stats.alloced -= 1;
+	root->stats.dec_height += 1;
+	root->stats.max_items /= BTREE_PTR_MAX;
+#endif
+	root->root_node = old_root->ptrs[0];
+	btree_node_free(old_root);
+	root->height--;
+}
+
+static int
+btree_merge_with_prev(
+	struct btree_root	*root,
+	int			level,
+	struct btree_cursor	*prev_cursor)
+{
+	if (!prev_cursor)
+		return 0;
+
+	if (!btree_shift_to_prev(root, level, prev_cursor,
+					root->cursor[level].node->num_keys + 1))
+		return 0;
+
+#ifdef BTREE_STATS
+	root->stats.merge_prev += 1;
+#endif
+	return 1;
+}
+
+static int
+btree_merge_with_next(
+	struct btree_root	*root,
+	int			level,
+	struct btree_cursor	*next_cursor)
+{
+	if (!next_cursor)
+		return 0;
+
+	if (!btree_shift_to_next(root, level, next_cursor,
+					root->cursor[level].node->num_keys + 1))
+		return 0;
+
+#ifdef BTREE_STATS
+	root->stats.merge_next += 1;
+#endif
+	return 1;
+}
+
+static int
+btree_balance_with_prev(
+	struct btree_root	*root,
+	int			level,
+	struct btree_cursor	*prev_cursor)
+{
+	struct btree_cursor	*root_cursor = root->cursor;
+
+	if (!prev_cursor)
+		return 0;
+	ASSERT(prev_cursor[level].node->num_keys > BTREE_KEY_MIN);
+
+#ifdef BTREE_STATS
+	root->stats.balance_prev += 1;
+#endif
+	/*
+	 * Move some nodes from the prev node into the current node.
+	 * As the shift operation is a right shift and is relative to
+	 * the root cursor, make the root cursor the prev cursor and
+	 * pass in the root cursor as the next cursor.
+	 */
+
+	root->cursor = prev_cursor;
+	if (!btree_shift_to_next(root, level, root_cursor,
+		(prev_cursor[level].node->num_keys + 1 - BTREE_KEY_MIN) / 2))
+			abort();
+	root->cursor = root_cursor;
+
+	return 1;
+}
+
+static int
+btree_balance_with_next(
+	struct btree_root	*root,
+	int			level,
+	struct btree_cursor	*next_cursor)
+{
+	struct btree_cursor	*root_cursor = root->cursor;
+
+	if (!next_cursor)
+		return 0;
+	assert(next_cursor[level].node->num_keys > BTREE_KEY_MIN);
+
+#ifdef btree_stats
+	root->stats.balance_next += 1;
+#endif
+	/*
+	 * move some nodes from the next node into the current node.
+	 * as the shift operation is a left shift and is relative to
+	 * the root cursor, make the root cursor the next cursor and
+	 * pass in the root cursor as the prev cursor.
+	 */
+
+	root->cursor = next_cursor;
+	if (!btree_shift_to_prev(root, level, root_cursor,
+		(next_cursor[level].node->num_keys + 1 - BTREE_KEY_MIN) / 2))
+			abort();
+	root->cursor = root_cursor;
+
+	return 1;
+
+}
+
+static void
+btree_delete_key(
+	struct btree_root	*root,
+	int			level);
+
+/*
+ * btree_delete_node:
+ *
+ * Return 0 if it's done or 1 if the next level needs to be collapsed
+ */
+static void
+btree_delete_node(
+	struct btree_root	*root,
+	int			level)
+{
+	struct btree_cursor	prev_cursor[root->height];
+	struct btree_cursor	next_cursor[root->height];
+	struct btree_cursor	*pc;
+	struct btree_cursor	*nc;
+
+	/*
+	 * the node has underflowed, grab or merge keys/items from a
+	 * neighbouring node.
+	 */
+
+	if (level == root->height - 1) {
+		if (level > 0 && root->root_node->num_keys == 0)
+			btree_decrease_height(root);
+		return;
+	}
+
+	pc = btree_copy_cursor_prev(root, prev_cursor, level + 1);
+	if (!btree_merge_with_prev(root, level, pc)) {
+		nc = btree_copy_cursor_next(root, next_cursor, level + 1);
+		if (!btree_merge_with_next(root, level, nc)) {
+			/* merging failed, try redistrubution */
+			if (!btree_balance_with_prev(root, level, pc) &&
+			    !btree_balance_with_next(root, level, nc))
+				abort();
+			return;	/* when balancing, then the node isn't freed */
+		}
+	}
+
+#ifdef BTREE_STATS
+	root->stats.alloced -= 1;
+#endif
+	btree_node_free(root->cursor[level].node);
+
+	btree_delete_key(root, level + 1);
+}
+
+static void
+btree_delete_key(
+	struct btree_root	*root,
+	int			level)
+{
+	struct btree_node	*node = root->cursor[level].node;
+	int			index = root->cursor[level].index;
+
+	node->num_keys--;
+	if (index <= node->num_keys) {
+		/*
+		 * if not deleting the last item, shift higher items down
+		 * to cover the item being deleted
+		 */
+		while (index < node->num_keys) {
+			node->keys[index] = node->keys[index + 1];
+			node->ptrs[index] = node->ptrs[index + 1];
+			index++;
+		}
+		node->ptrs[index] = node->ptrs[index + 1];
+	} else {
+		/*
+		 * else update the associated parent key as the last key
+		 * in the leaf has changed
+		 */
+		btree_update_node_key(root, root->cursor, level + 1,
+						node->keys[node->num_keys]);
+	}
+	/*
+	 * if node underflows, either merge with sibling or rebalance
+	 * with sibling.
+	 */
+	if (node->num_keys < BTREE_KEY_MIN)
+		btree_delete_node(root, level);
+}
+
+void *
+btree_delete(
+	struct btree_root	*root,
+	unsigned long		key)
+{
+	void			*value;
+
+	value = btree_lookup(root, key);
+	if (!value)
+		return NULL;
+
+#ifdef BTREE_STATS
+	root->stats.delete += 1;
+	root->stats.num_items -= 1;
+#endif
+
+	btree_delete_key(root, 0);
+
+	btree_invalidate_cursor(root);
+
+	return value;
+}
+
+#ifdef BTREE_STATS
+void
+btree_print_stats(
+	struct btree_root	*root,
+	FILE			*f)
+{
+	unsigned long		max_items = root->stats.max_items *
+						(root->root_node->num_keys + 1);
+
+	fprintf(f, "\tnum_items = %lu, max_items = %lu (%lu%%)\n",
+			root->stats.num_items, max_items,
+			root->stats.num_items * 100 / max_items);
+	fprintf(f, "\talloced = %d nodes, %lu bytes, %lu bytes per item\n",
+			root->stats.alloced,
+			root->stats.alloced * sizeof(struct btree_node),
+			root->stats.alloced * sizeof(struct btree_node) /
+							root->stats.num_items);
+	fprintf(f, "\tlookup = %d\n", root->stats.lookup);
+	fprintf(f, "\tfind = %d\n", root->stats.find);
+	fprintf(f, "\tcache_hits = %d\n", root->stats.cache_hits);
+	fprintf(f, "\tcache_misses = %d\n", root->stats.cache_misses);
+	fprintf(f, "\tkey_update = %d\n", root->stats.key_update);
+	fprintf(f, "\tvalue_update = %d\n", root->stats.value_update);
+	fprintf(f, "\tinsert = %d\n", root->stats.insert);
+	fprintf(f, "\tshift_prev = %d\n", root->stats.shift_prev);
+	fprintf(f, "\tshift_next = %d\n", root->stats.shift_next);
+	fprintf(f, "\tsplit = %d\n", root->stats.split);
+	fprintf(f, "\tinc_height = %d\n", root->stats.inc_height);
+	fprintf(f, "\tdelete = %d\n", root->stats.delete);
+	fprintf(f, "\tmerge_prev = %d\n", root->stats.merge_prev);
+	fprintf(f, "\tmerge_next = %d\n", root->stats.merge_next);
+	fprintf(f, "\tbalance_prev = %d\n", root->stats.balance_prev);
+	fprintf(f, "\tbalance_next = %d\n", root->stats.balance_next);
+	fprintf(f, "\tdec_height = %d\n", root->stats.dec_height);
+}
+#endif
Index: xfsprogs-dev/repair/btree.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfsprogs-dev/repair/btree.h	2009-08-20 00:06:44.000000000 +0000
@@ -0,0 +1,102 @@
+/*
+ * Copyright (c) 2007 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#ifndef _BTREE_H
+#define _BTREE_H
+
+
+struct btree_root;
+
+void
+btree_init(
+	struct btree_root	**root);
+
+void
+btree_destroy(
+	struct btree_root	*root);
+
+int
+btree_is_empty(
+	struct btree_root	*root);
+
+void *
+btree_lookup(
+	struct btree_root	*root,
+	unsigned long		key);
+
+void *
+btree_find(
+	struct btree_root	*root,
+	unsigned long		key,
+	unsigned long		*actual_key);
+
+void *
+btree_peek_prev(
+	struct btree_root	*root,
+	unsigned long		*key);
+
+void *
+btree_peek_next(
+	struct btree_root	*root,
+	unsigned long		*key);
+
+void *
+btree_lookup_next(
+	struct btree_root	*root,
+	unsigned long		*key);
+
+void *
+btree_lookup_prev(
+	struct btree_root	*root,
+	unsigned long		*key);
+
+int
+btree_insert(
+	struct btree_root	*root,
+	unsigned long		key,
+	void			*value);
+
+void *
+btree_delete(
+	struct btree_root	*root,
+	unsigned long		key);
+
+int
+btree_update_key(
+	struct btree_root	*root,
+	unsigned long		old_key,
+	unsigned long		new_key);
+
+int
+btree_update_value(
+	struct btree_root	*root,
+	unsigned long		key,
+	void 			*new_value);
+
+void
+btree_clear(
+	struct btree_root	*root);
+
+#ifdef BTREE_STATS
+void
+btree_print_stats(
+	struct btree_root	*root,
+	FILE			*f);
+#endif
+
+#endif /* _BTREE_H */
Index: xfsprogs-dev/repair/init.c
===================================================================
--- xfsprogs-dev.orig/repair/init.c	2009-08-20 00:01:58.000000000 +0000
+++ xfsprogs-dev/repair/init.c	2009-08-20 00:06:44.000000000 +0000
@@ -26,7 +26,6 @@
 #include "dir.h"
 #include "incore.h"
 #include "prefetch.h"
-#include "radix-tree.h"
 #include <sys/resource.h>
 
 static pthread_key_t dirbuf_key;
@@ -151,5 +150,4 @@
 	ts_create();
 	ts_init();
 	increase_rlimit();
-	radix_tree_init();
 }
Index: xfsprogs-dev/repair/prefetch.c
===================================================================
--- xfsprogs-dev.orig/repair/prefetch.c	2009-08-20 00:05:36.000000000 +0000
+++ xfsprogs-dev/repair/prefetch.c	2009-08-20 00:14:08.000000000 +0000
@@ -1,6 +1,7 @@
 #include <libxfs.h>
 #include <pthread.h>
 #include "avl.h"
+#include "btree.h"
 #include "globals.h"
 #include "agheader.h"
 #include "incore.h"
@@ -14,7 +15,6 @@
 #include "threads.h"
 #include "prefetch.h"
 #include "progress.h"
-#include "radix-tree.h"
 
 int do_prefetch = 1;
 
@@ -129,10 +129,8 @@
 	pthread_mutex_lock(&args->lock);
 
 	if (fsbno > args->last_bno_read) {
-		radix_tree_insert(&args->primary_io_queue, fsbno, bp);
-		if (!B_IS_INODE(flag))
-			radix_tree_tag_set(&args->primary_io_queue, fsbno, 0);
-		else {
+		btree_insert(args->primary_io_queue, fsbno, bp);
+		if (B_IS_INODE(flag)) {
 			args->inode_bufs_queued++;
 			if (args->inode_bufs_queued == IO_THRESHOLD)
 				pf_start_io_workers(args);
@@ -154,7 +152,7 @@
 #endif
 		ASSERT(!B_IS_INODE(flag));
 		XFS_BUF_SET_PRIORITY(bp, B_DIR_META_2);
-		radix_tree_insert(&args->secondary_io_queue, fsbno, bp);
+		btree_insert(args->secondary_io_queue, fsbno, bp);
 	}
 
 	pf_start_processing(args);
@@ -407,7 +405,7 @@
 	pf_which_t		which,
 	void			*buf)
 {
-	struct radix_tree_root	*queue;
+	struct btree_root	*queue;
 	xfs_buf_t		*bplist[MAX_BUFS];
 	unsigned int		num;
 	off64_t			first_off, last_off, next_off;
@@ -415,27 +413,25 @@
 	int			i;
 	int			inode_bufs;
 	unsigned long		fsbno;
+	unsigned long		max_fsbno;
 	char			*pbuf;
 
-	queue = (which != PF_SECONDARY) ? &args->primary_io_queue
-				: &args->secondary_io_queue;
+	queue = (which != PF_SECONDARY) ? args->primary_io_queue
+				: args->secondary_io_queue;
 
-	while (radix_tree_lookup_first(queue, &fsbno) != NULL) {
-
-		if (which != PF_META_ONLY) {
-			num = radix_tree_gang_lookup_ex(queue,
-					(void**)&bplist[0], fsbno,
-					fsbno + pf_max_fsbs, MAX_BUFS);
-			ASSERT(num > 0);
-			ASSERT(XFS_FSB_TO_DADDR(mp, fsbno) ==
-				XFS_BUF_ADDR(bplist[0]));
-		} else {
-			num = radix_tree_gang_lookup_tag(queue,
-					(void**)&bplist[0], fsbno,
-					MAX_BUFS / 4, 0);
-			if (num == 0)
-				return;
+	while (btree_find(queue, 0, &fsbno) != NULL) {
+		max_fsbno = fsbno + pf_max_fsbs;
+		num = 0;
+
+		bplist[0] = btree_lookup(queue, fsbno);
+		while (bplist[num] && num < MAX_BUFS && fsbno < max_fsbno) {
+			if (which != PF_META_ONLY ||
+			    !B_IS_INODE(XFS_BUF_PRIORITY(bplist[num])))
+				num++;
+			bplist[num] = btree_lookup_next(queue, &fsbno);
 		}
+		if (!num)
+			return;
 
 		/*
 		 * do a big read if 25% of the potential buffer is useful,
@@ -467,7 +463,7 @@
 		}
 
 		for (i = 0; i < num; i++) {
-			if (radix_tree_delete(queue, XFS_DADDR_TO_FSB(mp,
+			if (btree_delete(queue, XFS_DADDR_TO_FSB(mp,
 					XFS_BUF_ADDR(bplist[i]))) == NULL)
 				do_error(_("prefetch corruption\n"));
 		}
@@ -570,7 +566,7 @@
 		return NULL;
 
 	pthread_mutex_lock(&args->lock);
-	while (!args->queuing_done || args->primary_io_queue.height) {
+	while (!args->queuing_done || btree_find(args->primary_io_queue, 0, NULL)) {
 
 #ifdef XR_PF_TRACE
 		pftrace("waiting to start prefetch I/O for AG %d", args->agno);
@@ -696,8 +692,8 @@
 #endif
 	pthread_mutex_lock(&args->lock);
 
-	ASSERT(args->primary_io_queue.height == 0);
-	ASSERT(args->secondary_io_queue.height == 0);
+	ASSERT(btree_find(args->primary_io_queue, 0, NULL) == NULL);
+	ASSERT(btree_find(args->secondary_io_queue, 0, NULL) == NULL);
 
 	args->prefetch_done = 1;
 	if (args->next_args)
@@ -755,8 +751,8 @@
 
 	args = calloc(1, sizeof(prefetch_args_t));
 
-	INIT_RADIX_TREE(&args->primary_io_queue, 0);
-	INIT_RADIX_TREE(&args->secondary_io_queue, 0);
+	btree_init(&args->primary_io_queue);
+	btree_init(&args->secondary_io_queue);
 	if (pthread_mutex_init(&args->lock, NULL) != 0)
 		do_error(_("failed to initialize prefetch mutex\n"));
 	if (pthread_cond_init(&args->start_reading, NULL) != 0)
@@ -835,6 +831,8 @@
 	pthread_cond_destroy(&args->start_reading);
 	pthread_cond_destroy(&args->start_processing);
 	sem_destroy(&args->ra_count);
+	btree_destroy(args->primary_io_queue);
+	btree_destroy(args->secondary_io_queue);
 
 	free(args);
 }
Index: xfsprogs-dev/repair/prefetch.h
===================================================================
--- xfsprogs-dev.orig/repair/prefetch.h	2009-08-20 00:01:58.000000000 +0000
+++ xfsprogs-dev/repair/prefetch.h	2009-08-20 00:06:44.000000000 +0000
@@ -3,7 +3,6 @@
 
 #include <semaphore.h>
 #include "incore.h"
-#include "radix-tree.h"
 
 
 extern int 	do_prefetch;
@@ -14,8 +13,8 @@
 	pthread_mutex_t		lock;
 	pthread_t		queuing_thread;
 	pthread_t		io_threads[PF_THREAD_COUNT];
-	struct radix_tree_root	primary_io_queue;
-	struct radix_tree_root	secondary_io_queue;
+	struct btree_root	*primary_io_queue;
+	struct btree_root	*secondary_io_queue;
 	pthread_cond_t		start_reading;
 	pthread_cond_t		start_processing;
 	int			agno;
Index: xfsprogs-dev/repair/radix-tree.c
===================================================================
--- xfsprogs-dev.orig/repair/radix-tree.c	2009-08-20 00:01:58.000000000 +0000
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,805 +0,0 @@
-/*
- * Copyright (C) 2001 Momchil Velikov
- * Portions Copyright (C) 2001 Christoph Hellwig
- * Copyright (C) 2005 SGI, Christoph Lameter <clameter@sgi.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2, or (at
- * your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include <libxfs.h>
-#include "radix-tree.h"
-
-#ifndef ARRAY_SIZE
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
-#endif
-
-#define RADIX_TREE_MAP_SHIFT	6
-#define RADIX_TREE_MAP_SIZE	(1UL << RADIX_TREE_MAP_SHIFT)
-#define RADIX_TREE_MAP_MASK	(RADIX_TREE_MAP_SIZE-1)
-
-#ifdef RADIX_TREE_TAGS
-#define RADIX_TREE_TAG_LONGS	\
-	((RADIX_TREE_MAP_SIZE + BITS_PER_LONG - 1) / BITS_PER_LONG)
-#endif
-
-struct radix_tree_node {
-	unsigned int	count;
-	void		*slots[RADIX_TREE_MAP_SIZE];
-#ifdef RADIX_TREE_TAGS
-	unsigned long	tags[RADIX_TREE_MAX_TAGS][RADIX_TREE_TAG_LONGS];
-#endif
-};
-
-struct radix_tree_path {
-	struct radix_tree_node *node;
-	int offset;
-};
-
-#define RADIX_TREE_INDEX_BITS  (8 /* CHAR_BIT */ * sizeof(unsigned long))
-#define RADIX_TREE_MAX_PATH (RADIX_TREE_INDEX_BITS/RADIX_TREE_MAP_SHIFT + 2)
-
-static unsigned long height_to_maxindex[RADIX_TREE_MAX_PATH];
-
-/*
- * Radix tree node cache.
- */
-
-#define radix_tree_node_alloc(r) 	((struct radix_tree_node *) \
-		calloc(1, sizeof(struct radix_tree_node)))
-#define radix_tree_node_free(n) 	free(n)
-
-#ifdef RADIX_TREE_TAGS
-
-static inline void tag_set(struct radix_tree_node *node, unsigned int tag,
-		int offset)
-{
-	*((__uint32_t *)node->tags[tag] + (offset >> 5)) |= (1 << (offset & 31));
-}
-
-static inline void tag_clear(struct radix_tree_node *node, unsigned int tag,
-		int offset)
-{
-	__uint32_t 	*p = (__uint32_t*)node->tags[tag] + (offset >> 5);
-	__uint32_t 	m = 1 << (offset & 31);
-	*p &= ~m;
-}
-
-static inline int tag_get(struct radix_tree_node *node, unsigned int tag,
-		int offset)
-{
-	return 1 & (((const __uint32_t *)node->tags[tag])[offset >> 5] >> (offset & 31));
-}
-
-/*
- * Returns 1 if any slot in the node has this tag set.
- * Otherwise returns 0.
- */
-static inline int any_tag_set(struct radix_tree_node *node, unsigned int tag)
-{
-	int idx;
-	for (idx = 0; idx < RADIX_TREE_TAG_LONGS; idx++) {
-		if (node->tags[tag][idx])
-			return 1;
-	}
-	return 0;
-}
-
-#endif
-
-/*
- *	Return the maximum key which can be store into a
- *	radix tree with height HEIGHT.
- */
-static inline unsigned long radix_tree_maxindex(unsigned int height)
-{
-	return height_to_maxindex[height];
-}
-
-/*
- *	Extend a radix tree so it can store key @index.
- */
-static int radix_tree_extend(struct radix_tree_root *root, unsigned long index)
-{
-	struct radix_tree_node *node;
-	unsigned int height;
-#ifdef RADIX_TREE_TAGS
-	char tags[RADIX_TREE_MAX_TAGS];
-	int tag;
-#endif
-
-	/* Figure out what the height should be.  */
-	height = root->height + 1;
-	while (index > radix_tree_maxindex(height))
-		height++;
-
-	if (root->rnode == NULL) {
-		root->height = height;
-		goto out;
-	}
-
-#ifdef RADIX_TREE_TAGS
-	/*
-	 * Prepare the tag status of the top-level node for propagation
-	 * into the newly-pushed top-level node(s)
-	 */
-	for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
-		tags[tag] = 0;
-		if (any_tag_set(root->rnode, tag))
-			tags[tag] = 1;
-	}
-#endif
-	do {
-		if (!(node = radix_tree_node_alloc(root)))
-			return -ENOMEM;
-
-		/* Increase the height.  */
-		node->slots[0] = root->rnode;
-
-#ifdef RADIX_TREE_TAGS
-		/* Propagate the aggregated tag info into the new root */
-		for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
-			if (tags[tag])
-				tag_set(node, tag, 0);
-		}
-#endif
-		node->count = 1;
-		root->rnode = node;
-		root->height++;
-	} while (height > root->height);
-out:
-	return 0;
-}
-
-/**
- *	radix_tree_insert    -    insert into a radix tree
- *	@root:		radix tree root
- *	@index:		index key
- *	@item:		item to insert
- *
- *	Insert an item into the radix tree at position @index.
- */
-int radix_tree_insert(struct radix_tree_root *root,
-			unsigned long index, void *item)
-{
-	struct radix_tree_node *node = NULL, *slot;
-	unsigned int height, shift;
-	int offset;
-	int error;
-
-	/* Make sure the tree is high enough.  */
-	if ((!index && !root->rnode) ||
-			index > radix_tree_maxindex(root->height)) {
-		error = radix_tree_extend(root, index);
-		if (error)
-			return error;
-	}
-
-	slot = root->rnode;
-	height = root->height;
-	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
-
-	offset = 0;			/* uninitialised var warning */
-	do {
-		if (slot == NULL) {
-			/* Have to add a child node.  */
-			if (!(slot = radix_tree_node_alloc(root)))
-				return -ENOMEM;
-			if (node) {
-				node->slots[offset] = slot;
-				node->count++;
-			} else
-				root->rnode = slot;
-		}
-
-		/* Go a level down */
-		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-		node = slot;
-		slot = node->slots[offset];
-		shift -= RADIX_TREE_MAP_SHIFT;
-		height--;
-	} while (height > 0);
-
-	if (slot != NULL)
-		return -EEXIST;
-
-	ASSERT(node);
-	node->count++;
-	node->slots[offset] = item;
-#ifdef RADIX_TREE_TAGS
-	ASSERT(!tag_get(node, 0, offset));
-	ASSERT(!tag_get(node, 1, offset));
-#endif
-	return 0;
-}
-
-static inline void **__lookup_slot(struct radix_tree_root *root,
-				   unsigned long index)
-{
-	unsigned int height, shift;
-	struct radix_tree_node **slot;
-
-	height = root->height;
-	if (index > radix_tree_maxindex(height))
-		return NULL;
-
-	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
-	slot = &root->rnode;
-
-	while (height > 0) {
-		if (*slot == NULL)
-			return NULL;
-
-		slot = (struct radix_tree_node **)
-			((*slot)->slots +
-				((index >> shift) & RADIX_TREE_MAP_MASK));
-		shift -= RADIX_TREE_MAP_SHIFT;
-		height--;
-	}
-
-	return (void **)slot;
-}
-
-/**
- *	radix_tree_lookup_slot    -    lookup a slot in a radix tree
- *	@root:		radix tree root
- *	@index:		index key
- *
- *	Lookup the slot corresponding to the position @index in the radix tree
- *	@root. This is useful for update-if-exists operations.
- */
-void **radix_tree_lookup_slot(struct radix_tree_root *root, unsigned long index)
-{
-	return __lookup_slot(root, index);
-}
-
-/**
- *	radix_tree_lookup    -    perform lookup operation on a radix tree
- *	@root:		radix tree root
- *	@index:		index key
- *
- *	Lookup the item at the position @index in the radix tree @root.
- */
-void *radix_tree_lookup(struct radix_tree_root *root, unsigned long index)
-{
-	void **slot;
-
-	slot = __lookup_slot(root, index);
-	return slot != NULL ? *slot : NULL;
-}
-
-/**
- *	raid_tree_first_key - find the first index key in the radix tree
- *	@root:		radix tree root
- *	@index:		where the first index will be placed
- *
- *	Returns the first entry and index key in the radix tree @root.
- */
-void *radix_tree_lookup_first(struct radix_tree_root *root, unsigned long *index)
-{
-	unsigned int height, shift;
-	struct radix_tree_node *slot;
-	unsigned long i;
-
-	height = root->height;
-	*index = 0;
-	if (height == 0)
-		return NULL;
-
-	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
-	slot = root->rnode;
-
-	for (; height > 1; height--) {
-		for (i = 0; i < RADIX_TREE_MAP_SIZE; i++) {
-			if (slot->slots[i] != NULL)
-				break;
-		}
-		ASSERT(i < RADIX_TREE_MAP_SIZE);
-
-		*index |= (i << shift);
-		shift -= RADIX_TREE_MAP_SHIFT;
-		slot = slot->slots[i];
-	}
-	for (i = 0; i < RADIX_TREE_MAP_SIZE; i++) {
-		if (slot->slots[i] != NULL) {
-			*index |= i;
-			return slot->slots[i];
-		}
-	}
-	return NULL;
-}
-
-#ifdef RADIX_TREE_TAGS
-
-/**
- *	radix_tree_tag_set - set a tag on a radix tree node
- *	@root:		radix tree root
- *	@index:		index key
- *	@tag: 		tag index
- *
- *	Set the search tag (which must be < RADIX_TREE_MAX_TAGS)
- *	corresponding to @index in the radix tree.  From
- *	the root all the way down to the leaf node.
- *
- *	Returns the address of the tagged item.   Setting a tag on a not-present
- *	item is a bug.
- */
-void *radix_tree_tag_set(struct radix_tree_root *root,
-			unsigned long index, unsigned int tag)
-{
-	unsigned int height, shift;
-	struct radix_tree_node *slot;
-
-	height = root->height;
-	if (index > radix_tree_maxindex(height))
-		return NULL;
-
-	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
-	slot = root->rnode;
-
-	while (height > 0) {
-		int offset;
-
-		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-		if (!tag_get(slot, tag, offset))
-			tag_set(slot, tag, offset);
-		slot = slot->slots[offset];
-		ASSERT(slot != NULL);
-		shift -= RADIX_TREE_MAP_SHIFT;
-		height--;
-	}
-
-	return slot;
-}
-
-/**
- *	radix_tree_tag_clear - clear a tag on a radix tree node
- *	@root:		radix tree root
- *	@index:		index key
- *	@tag: 		tag index
- *
- *	Clear the search tag (which must be < RADIX_TREE_MAX_TAGS)
- *	corresponding to @index in the radix tree.  If
- *	this causes the leaf node to have no tags set then clear the tag in the
- *	next-to-leaf node, etc.
- *
- *	Returns the address of the tagged item on success, else NULL.  ie:
- *	has the same return value and semantics as radix_tree_lookup().
- */
-void *radix_tree_tag_clear(struct radix_tree_root *root,
-			unsigned long index, unsigned int tag)
-{
-	struct radix_tree_path path[RADIX_TREE_MAX_PATH], *pathp = path;
-	struct radix_tree_node *slot;
-	unsigned int height, shift;
-	void *ret = NULL;
-
-	height = root->height;
-	if (index > radix_tree_maxindex(height))
-		goto out;
-
-	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
-	pathp->node = NULL;
-	slot = root->rnode;
-
-	while (height > 0) {
-		int offset;
-
-		if (slot == NULL)
-			goto out;
-
-		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-		pathp[1].offset = offset;
-		pathp[1].node = slot;
-		slot = slot->slots[offset];
-		pathp++;
-		shift -= RADIX_TREE_MAP_SHIFT;
-		height--;
-	}
-
-	ret = slot;
-	if (ret == NULL)
-		goto out;
-
-	do {
-		if (!tag_get(pathp->node, tag, pathp->offset))
-			goto out;
-		tag_clear(pathp->node, tag, pathp->offset);
-		if (any_tag_set(pathp->node, tag))
-			goto out;
-		pathp--;
-	} while (pathp->node);
-out:
-	return ret;
-}
-
-#endif
-
-static unsigned int
-__lookup(struct radix_tree_root *root, void **results, unsigned long index,
-	unsigned int max_items, unsigned long *next_index)
-{
-	unsigned int nr_found = 0;
-	unsigned int shift, height;
-	struct radix_tree_node *slot;
-	unsigned long i;
-
-	height = root->height;
-	if (height == 0)
-		goto out;
-
-	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
-	slot = root->rnode;
-
-	for ( ; height > 1; height--) {
-
-		for (i = (index >> shift) & RADIX_TREE_MAP_MASK ;
-				i < RADIX_TREE_MAP_SIZE; i++) {
-			if (slot->slots[i] != NULL)
-				break;
-			index &= ~((1UL << shift) - 1);
-			index += 1UL << shift;
-			if (index == 0)
-				goto out;	/* 32-bit wraparound */
-		}
-		if (i == RADIX_TREE_MAP_SIZE)
-			goto out;
-
-		shift -= RADIX_TREE_MAP_SHIFT;
-		slot = slot->slots[i];
-	}
-
-	/* Bottom level: grab some items */
-	for (i = index & RADIX_TREE_MAP_MASK; i < RADIX_TREE_MAP_SIZE; i++) {
-		index++;
-		if (slot->slots[i]) {
-			results[nr_found++] = slot->slots[i];
-			if (nr_found == max_items)
-				goto out;
-		}
-	}
-out:
-	*next_index = index;
-	return nr_found;
-}
-
-/**
- *	radix_tree_gang_lookup - perform multiple lookup on a radix tree
- *	@root:		radix tree root
- *	@results:	where the results of the lookup are placed
- *	@first_index:	start the lookup from this key
- *	@max_items:	place up to this many items at *results
- *
- *	Performs an index-ascending scan of the tree for present items.  Places
- *	them at *@results and returns the number of items which were placed at
- *	*@results.
- *
- *	The implementation is naive.
- */
-unsigned int
-radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
-			unsigned long first_index, unsigned int max_items)
-{
-	const unsigned long max_index = radix_tree_maxindex(root->height);
-	unsigned long cur_index = first_index;
-	unsigned int ret = 0;
-
-	while (ret < max_items) {
-		unsigned int nr_found;
-		unsigned long next_index;	/* Index of next search */
-
-		if (cur_index > max_index)
-			break;
-		nr_found = __lookup(root, results + ret, cur_index,
-					max_items - ret, &next_index);
-		ret += nr_found;
-		if (next_index == 0)
-			break;
-		cur_index = next_index;
-	}
-	return ret;
-}
-
-/**
- *	radix_tree_gang_lookup_ex - perform multiple lookup on a radix tree
- *	@root:		radix tree root
- *	@results:	where the results of the lookup are placed
- *	@first_index:	start the lookup from this key
- *	@last_index:	don't lookup past this key
- *	@max_items:	place up to this many items at *results
- *
- *	Performs an index-ascending scan of the tree for present items starting
- *	@first_index until @last_index up to as many as @max_items.  Places
- *	them at *@results and returns the number of items which were placed
- *	at *@results.
- *
- *	The implementation is naive.
- */
-unsigned int
-radix_tree_gang_lookup_ex(struct radix_tree_root *root, void **results,
-			unsigned long first_index, unsigned long last_index,
-			unsigned int max_items)
-{
-	const unsigned long max_index = radix_tree_maxindex(root->height);
-	unsigned long cur_index = first_index;
-	unsigned int ret = 0;
-
-	while (ret < max_items && cur_index < last_index) {
-		unsigned int nr_found;
-		unsigned long next_index;	/* Index of next search */
-
-		if (cur_index > max_index)
-			break;
-		nr_found = __lookup(root, results + ret, cur_index,
-					max_items - ret, &next_index);
-		ret += nr_found;
-		if (next_index == 0)
-			break;
-		cur_index = next_index;
-	}
-	return ret;
-}
-
-#ifdef RADIX_TREE_TAGS
-
-static unsigned int
-__lookup_tag(struct radix_tree_root *root, void **results, unsigned long index,
-	unsigned int max_items, unsigned long *next_index, unsigned int tag)
-{
-	unsigned int nr_found = 0;
-	unsigned int shift;
-	unsigned int height = root->height;
-	struct radix_tree_node *slot;
-
-	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
-	slot = root->rnode;
-
-	while (height > 0) {
-		unsigned long i = (index >> shift) & RADIX_TREE_MAP_MASK;
-
-		for ( ; i < RADIX_TREE_MAP_SIZE; i++) {
-			if (tag_get(slot, tag, i)) {
-				ASSERT(slot->slots[i] != NULL);
-				break;
-			}
-			index &= ~((1UL << shift) - 1);
-			index += 1UL << shift;
-			if (index == 0)
-				goto out;	/* 32-bit wraparound */
-		}
-		if (i == RADIX_TREE_MAP_SIZE)
-			goto out;
-		height--;
-		if (height == 0) {	/* Bottom level: grab some items */
-			unsigned long j = index & RADIX_TREE_MAP_MASK;
-
-			for ( ; j < RADIX_TREE_MAP_SIZE; j++) {
-				index++;
-				if (tag_get(slot, tag, j)) {
-					ASSERT(slot->slots[j] != NULL);
-					results[nr_found++] = slot->slots[j];
-					if (nr_found == max_items)
-						goto out;
-				}
-			}
-		}
-		shift -= RADIX_TREE_MAP_SHIFT;
-		slot = slot->slots[i];
-	}
-out:
-	*next_index = index;
-	return nr_found;
-}
-
-/**
- *	radix_tree_gang_lookup_tag - perform multiple lookup on a radix tree
- *	                             based on a tag
- *	@root:		radix tree root
- *	@results:	where the results of the lookup are placed
- *	@first_index:	start the lookup from this key
- *	@max_items:	place up to this many items at *results
- *	@tag:		the tag index (< RADIX_TREE_MAX_TAGS)
- *
- *	Performs an index-ascending scan of the tree for present items which
- *	have the tag indexed by @tag set.  Places the items at *@results and
- *	returns the number of items which were placed at *@results.
- */
-unsigned int
-radix_tree_gang_lookup_tag(struct radix_tree_root *root, void **results,
-		unsigned long first_index, unsigned int max_items,
-		unsigned int tag)
-{
-	const unsigned long max_index = radix_tree_maxindex(root->height);
-	unsigned long cur_index = first_index;
-	unsigned int ret = 0;
-
-	while (ret < max_items) {
-		unsigned int nr_found;
-		unsigned long next_index;	/* Index of next search */
-
-		if (cur_index > max_index)
-			break;
-		nr_found = __lookup_tag(root, results + ret, cur_index,
-					max_items - ret, &next_index, tag);
-		ret += nr_found;
-		if (next_index == 0)
-			break;
-		cur_index = next_index;
-	}
-	return ret;
-}
-
-#endif
-
-/**
- *	radix_tree_shrink    -    shrink height of a radix tree to minimal
- *	@root		radix tree root
- */
-static inline void radix_tree_shrink(struct radix_tree_root *root)
-{
-	/* try to shrink tree height */
-	while (root->height > 1 &&
-			root->rnode->count == 1 &&
-			root->rnode->slots[0]) {
-		struct radix_tree_node *to_free = root->rnode;
-
-		root->rnode = to_free->slots[0];
-		root->height--;
-		/* must only free zeroed nodes into the slab */
-#ifdef RADIX_TREE_TAGS
-		tag_clear(to_free, 0, 0);
-		tag_clear(to_free, 1, 0);
-#endif
-		to_free->slots[0] = NULL;
-		to_free->count = 0;
-		radix_tree_node_free(to_free);
-	}
-}
-
-/**
- *	radix_tree_delete    -    delete an item from a radix tree
- *	@root:		radix tree root
- *	@index:		index key
- *
- *	Remove the item at @index from the radix tree rooted at @root.
- *
- *	Returns the address of the deleted item, or NULL if it was not present.
- */
-void *radix_tree_delete(struct radix_tree_root *root, unsigned long index)
-{
-	struct radix_tree_path path[RADIX_TREE_MAX_PATH], *pathp = path;
-	struct radix_tree_path *orig_pathp;
-	struct radix_tree_node *slot;
-	unsigned int height, shift;
-	void *ret = NULL;
-#ifdef RADIX_TREE_TAGS
-	char tags[RADIX_TREE_MAX_TAGS];
-	int nr_cleared_tags;
-	int tag;
-#endif
-	int offset;
-
-	height = root->height;
-	if (index > radix_tree_maxindex(height))
-		goto out;
-
-	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
-	pathp->node = NULL;
-	slot = root->rnode;
-
-	for ( ; height > 0; height--) {
-		if (slot == NULL)
-			goto out;
-
-		pathp++;
-		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-		pathp->offset = offset;
-		pathp->node = slot;
-		slot = slot->slots[offset];
-		shift -= RADIX_TREE_MAP_SHIFT;
-	}
-
-	ret = slot;
-	if (ret == NULL)
-		goto out;
-
-	orig_pathp = pathp;
-
-#ifdef RADIX_TREE_TAGS
-	/*
-	 * Clear all tags associated with the just-deleted item
-	 */
-	nr_cleared_tags = 0;
-	for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
-		tags[tag] = 1;
-		if (tag_get(pathp->node, tag, pathp->offset)) {
-			tag_clear(pathp->node, tag, pathp->offset);
-			if (!any_tag_set(pathp->node, tag)) {
-				tags[tag] = 0;
-				nr_cleared_tags++;
-			}
-		}
-	}
-
-	for (pathp--; nr_cleared_tags && pathp->node; pathp--) {
-		for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
-			if (tags[tag])
-				continue;
-
-			tag_clear(pathp->node, tag, pathp->offset);
-			if (any_tag_set(pathp->node, tag)) {
-				tags[tag] = 1;
-				nr_cleared_tags--;
-			}
-		}
-	}
-#endif
-	/* Now free the nodes we do not need anymore */
-	for (pathp = orig_pathp; pathp->node; pathp--) {
-		pathp->node->slots[pathp->offset] = NULL;
-		pathp->node->count--;
-
-		if (pathp->node->count) {
-			if (pathp->node == root->rnode)
-				radix_tree_shrink(root);
-			goto out;
-		}
-
-		/* Node with zero slots in use so free it */
-		radix_tree_node_free(pathp->node);
-	}
-	root->rnode = NULL;
-	root->height = 0;
-out:
-	return ret;
-}
-
-#ifdef RADIX_TREE_TAGS
-/**
- *	radix_tree_tagged - test whether any items in the tree are tagged
- *	@root:		radix tree root
- *	@tag:		tag to test
- */
-int radix_tree_tagged(struct radix_tree_root *root, unsigned int tag)
-{
-  	struct radix_tree_node *rnode;
-  	rnode = root->rnode;
-  	if (!rnode)
-  		return 0;
-	return any_tag_set(rnode, tag);
-}
-#endif
-
-static unsigned long __maxindex(unsigned int height)
-{
-	unsigned int tmp = height * RADIX_TREE_MAP_SHIFT;
-	unsigned long index = (~0UL >> (RADIX_TREE_INDEX_BITS - tmp - 1)) >> 1;
-
-	if (tmp >= RADIX_TREE_INDEX_BITS)
-		index = ~0UL;
-	return index;
-}
-
-static void radix_tree_init_maxindex(void)
-{
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(height_to_maxindex); i++)
-		height_to_maxindex[i] = __maxindex(i);
-}
-
-void radix_tree_init(void)
-{
-	radix_tree_init_maxindex();
-}
Index: xfsprogs-dev/repair/radix-tree.h
===================================================================
--- xfsprogs-dev.orig/repair/radix-tree.h	2009-08-20 00:01:58.000000000 +0000
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,76 +0,0 @@
-/*
- * Copyright (C) 2001 Momchil Velikov
- * Portions Copyright (C) 2001 Christoph Hellwig
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2, or (at
- * your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-#ifndef __XFS_SUPPORT_RADIX_TREE_H__
-#define __XFS_SUPPORT_RADIX_TREE_H__
-
-#define RADIX_TREE_TAGS
-
-struct radix_tree_root {
-	unsigned int		height;
-	struct radix_tree_node	*rnode;
-};
-
-#define RADIX_TREE_INIT(mask)	{					\
-	.height = 0,							\
-	.rnode = NULL,							\
-}
-
-#define RADIX_TREE(name, mask) \
-	struct radix_tree_root name = RADIX_TREE_INIT(mask)
-
-#define INIT_RADIX_TREE(root, mask)					\
-do {									\
-	(root)->height = 0;						\
-	(root)->rnode = NULL;						\
-} while (0)
-
-#ifdef RADIX_TREE_TAGS
-#define RADIX_TREE_MAX_TAGS 2
-#endif
-
-int radix_tree_insert(struct radix_tree_root *, unsigned long, void *);
-void *radix_tree_lookup(struct radix_tree_root *, unsigned long);
-void **radix_tree_lookup_slot(struct radix_tree_root *, unsigned long);
-void *radix_tree_lookup_first(struct radix_tree_root *, unsigned long *);
-void *radix_tree_delete(struct radix_tree_root *, unsigned long);
-unsigned int
-radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
-			unsigned long first_index, unsigned int max_items);
-unsigned int
-radix_tree_gang_lookup_ex(struct radix_tree_root *root, void **results,
-			unsigned long first_index, unsigned long last_index,
-			unsigned int max_items);
-
-void radix_tree_init(void);
-
-#ifdef RADIX_TREE_TAGS
-void *radix_tree_tag_set(struct radix_tree_root *root,
-			unsigned long index, unsigned int tag);
-void *radix_tree_tag_clear(struct radix_tree_root *root,
-			unsigned long index, unsigned int tag);
-int radix_tree_tag_get(struct radix_tree_root *root,
-			unsigned long index, unsigned int tag);
-unsigned int
-radix_tree_gang_lookup_tag(struct radix_tree_root *root, void **results,
-			unsigned long first_index, unsigned int max_items,
-			unsigned int tag);
-int radix_tree_tagged(struct radix_tree_root *root, unsigned int tag);
-#endif
-
-#endif /* __XFS_SUPPORT_RADIX_TREE_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
