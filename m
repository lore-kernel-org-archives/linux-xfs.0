Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29840 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753082AbdKQUN5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 15:13:57 -0500
Subject: [PATCH 04/12] libfrog: move list_sort out of libxfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 12:13:49 -0800
Message-ID: <151094962905.29763.4056876750893707110.stgit@magnolia>
In-Reply-To: <151094960522.29763.11622891165765932168.stgit@magnolia>
References: <151094960522.29763.11622891165765932168.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

List operations aren't really a part of libxfs, so move them to libfrog.
This is purely a directory tree restructuring; no functional changes,
though some indentation fixes are included.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 Makefile             |    8 
 copy/Makefile        |    4 
 db/Makefile          |    4 
 growfs/Makefile      |    4 
 io/Makefile          |    4 
 libfrog/Makefile     |    2 
 libfrog/list_sort.c  |  140 +++++++++
 libfrog/radix-tree.c |  810 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/Makefile      |    2 
 libxfs/list_sort.c   |  141 ---------
 libxfs/radix-tree.c  |  808 --------------------------------------------------
 logprint/Makefile    |    4 
 mdrestore/Makefile   |    4 
 13 files changed, 969 insertions(+), 966 deletions(-)
 create mode 100644 libfrog/list_sort.c
 create mode 100644 libfrog/radix-tree.c
 delete mode 100644 libxfs/list_sort.c
 delete mode 100644 libxfs/radix-tree.c


diff --git a/Makefile b/Makefile
index 4146473..0dce80a 100644
--- a/Makefile
+++ b/Makefile
@@ -44,7 +44,8 @@ endif
 # header install rules to populate include/xfs correctly
 HDR_SUBDIRS = include libxfs
 
-DLIB_SUBDIRS = libfrog libxlog libxcmd libhandle
+LIBFROG_SUBDIR = libfrog
+DLIB_SUBDIRS = libxlog libxcmd libhandle
 LIB_SUBDIRS = libxfs $(DLIB_SUBDIRS)
 TOOL_SUBDIRS = copy db estimate fsck growfs io logprint mkfs quota \
 		mdrestore repair rtcp m4 man doc debian spaceman
@@ -66,7 +67,7 @@ LIBTOOLIZE_BIN=glibtoolize
 endif
 
 # include is listed last so it is processed last in clean rules.
-SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS) include
+SUBDIRS = $(LIBFROG_SUBDIR) $(LIB_SUBDIRS) $(TOOL_SUBDIRS) include
 
 default: include/builddefs include/platform_defs.h
 ifeq ($(HAVE_BUILDDEFS), no)
@@ -78,7 +79,8 @@ endif
 
 # tool/lib dependencies
 # note: include/xfs is set up by libxfs, too, so everything is dependent on it.
-$(LIB_SUBDIRS) $(TOOL_SUBDIRS): include
+$(LIBFROG_SUBDIR): include
+$(LIB_SUBDIRS) $(TOOL_SUBDIRS): include libfrog
 $(DLIB_SUBDIRS) $(TOOL_SUBDIRS): libxfs
 db logprint: libxlog
 fsr: libhandle
diff --git a/copy/Makefile b/copy/Makefile
index e630b17..f86f2d7 100644
--- a/copy/Makefile
+++ b/copy/Makefile
@@ -9,8 +9,8 @@ LTCOMMAND = xfs_copy
 CFILES = xfs_copy.c
 HFILES = xfs_copy.h
 
-LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBPTHREAD) $(LIBRT)
-LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
+LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBPTHREAD) $(LIBRT)
+LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
 default: depend $(LTCOMMAND)
diff --git a/db/Makefile b/db/Makefile
index 8111bf1..6caa634 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -17,8 +17,8 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
 CFILES = $(HFILES:.h=.c) btdump.c
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
-LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
-LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
+LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
+LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
 LLDFLAGS += -static-libtool-libs
 
 ifeq ($(ENABLE_READLINE),yes)
diff --git a/growfs/Makefile b/growfs/Makefile
index 19616de..f0190e4 100644
--- a/growfs/Makefile
+++ b/growfs/Makefile
@@ -9,7 +9,7 @@ LTCOMMAND = xfs_growfs
 
 CFILES = xfs_growfs.c
 
-LLDLIBS = $(LIBXFS) $(LIBXCMD) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
+LLDLIBS = $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
 ifeq ($(ENABLE_READLINE),yes)
 LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
 endif
@@ -18,7 +18,7 @@ ifeq ($(ENABLE_EDITLINE),yes)
 LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
 endif
 
-LTDEPENDENCIES = $(LIBXFS) $(LIBXCMD)
+LTDEPENDENCIES = $(LIBXFS) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 LSRCFILES = xfs_info.sh
 
diff --git a/io/Makefile b/io/Makefile
index b983bcc..2f11451 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -14,8 +14,8 @@ CFILES = init.c \
 	pwrite.c reflink.c scrub.c seek.c shutdown.c stat.c sync.c truncate.c \
 	utimes.c
 
-LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBPTHREAD)
-LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE)
+LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD)
+LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
 ifeq ($(HAVE_FADVISE),yes)
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 6d9ed07..6034da5 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -11,6 +11,8 @@ LT_REVISION = 0
 LT_AGE = 0
 
 CFILES = \
+list_sort.c \
+radix-tree.c \
 util.c
 
 default: ltdepend $(LTLIBRARY)
diff --git a/libfrog/list_sort.c b/libfrog/list_sort.c
new file mode 100644
index 0000000..b77eece
--- /dev/null
+++ b/libfrog/list_sort.c
@@ -0,0 +1,140 @@
+/* List sorting code from Linux::lib/list_sort.c. */
+#include <stdlib.h>
+#include <string.h>
+#include "list.h"
+
+#define unlikely(x)	(x)
+#define MAX_LIST_LENGTH_BITS 20
+
+/*
+ * Returns a list organized in an intermediate format suited
+ * to chaining of merge() calls: null-terminated, no reserved or
+ * sentinel head node, "prev" links not maintained.
+ */
+static struct list_head *merge(void *priv,
+				int (*cmp)(void *priv, struct list_head *a,
+					struct list_head *b),
+				struct list_head *a, struct list_head *b)
+{
+	struct list_head head, *tail = &head;
+
+	while (a && b) {
+		/* if equal, take 'a' -- important for sort stability */
+		if ((*cmp)(priv, a, b) <= 0) {
+			tail->next = a;
+			a = a->next;
+		} else {
+			tail->next = b;
+			b = b->next;
+		}
+		tail = tail->next;
+	}
+	tail->next = a?:b;
+	return head.next;
+}
+
+/*
+ * Combine final list merge with restoration of standard doubly-linked
+ * list structure.  This approach duplicates code from merge(), but
+ * runs faster than the tidier alternatives of either a separate final
+ * prev-link restoration pass, or maintaining the prev links
+ * throughout.
+ */
+static void merge_and_restore_back_links(void *priv,
+				int (*cmp)(void *priv, struct list_head *a,
+					struct list_head *b),
+				struct list_head *head,
+				struct list_head *a, struct list_head *b)
+{
+	struct list_head *tail = head;
+	unsigned count = 0;
+
+	while (a && b) {
+		/* if equal, take 'a' -- important for sort stability */
+		if ((*cmp)(priv, a, b) <= 0) {
+			tail->next = a;
+			a->prev = tail;
+			a = a->next;
+		} else {
+			tail->next = b;
+			b->prev = tail;
+			b = b->next;
+		}
+		tail = tail->next;
+	}
+	tail->next = a ? : b;
+
+	do {
+		/*
+		 * In worst cases this loop may run many iterations.
+		 * Continue callbacks to the client even though no
+		 * element comparison is needed, so the client's cmp()
+		 * routine can invoke cond_resched() periodically.
+		 */
+		if (unlikely(!(++count)))
+			(*cmp)(priv, tail->next, tail->next);
+
+		tail->next->prev = tail;
+		tail = tail->next;
+	} while (tail->next);
+
+	tail->next = head;
+	head->prev = tail;
+}
+
+/**
+ * list_sort - sort a list
+ * @priv: private data, opaque to list_sort(), passed to @cmp
+ * @head: the list to sort
+ * @cmp: the elements comparison function
+ *
+ * This function implements "merge sort", which has O(nlog(n))
+ * complexity.
+ *
+ * The comparison function @cmp must return a negative value if @a
+ * should sort before @b, and a positive value if @a should sort after
+ * @b. If @a and @b are equivalent, and their original relative
+ * ordering is to be preserved, @cmp must return 0.
+ */
+void list_sort(void *priv, struct list_head *head,
+		int (*cmp)(void *priv, struct list_head *a,
+			struct list_head *b))
+{
+	struct list_head *part[MAX_LIST_LENGTH_BITS+1]; /* sorted partial lists
+						-- last slot is a sentinel */
+	int lev;  /* index into part[] */
+	int max_lev = 0;
+	struct list_head *list;
+
+	if (list_empty(head))
+		return;
+
+	memset(part, 0, sizeof(part));
+
+	head->prev->next = NULL;
+	list = head->next;
+
+	while (list) {
+		struct list_head *cur = list;
+		list = list->next;
+		cur->next = NULL;
+
+		for (lev = 0; part[lev]; lev++) {
+			cur = merge(priv, cmp, part[lev], cur);
+			part[lev] = NULL;
+		}
+		if (lev > max_lev) {
+			if (unlikely(lev >= ARRAY_SIZE(part)-1)) {
+				lev--;
+			}
+			max_lev = lev;
+		}
+		part[lev] = cur;
+	}
+
+	for (lev = 0; lev < max_lev; lev++)
+		if (part[lev])
+			list = merge(priv, cmp, part[lev], list);
+
+	merge_and_restore_back_links(priv, cmp, head, part[max_lev], list);
+}
diff --git a/libfrog/radix-tree.c b/libfrog/radix-tree.c
new file mode 100644
index 0000000..9fe5dd9
--- /dev/null
+++ b/libfrog/radix-tree.c
@@ -0,0 +1,810 @@
+/*
+ * Copyright (C) 2001 Momchil Velikov
+ * Portions Copyright (C) 2001 Christoph Hellwig
+ * Copyright (C) 2005 SGI, Christoph Lameter <clameter@sgi.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2, or (at
+ * your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <stdint.h>
+#include "platform_defs.h"
+#include "radix-tree.h"
+
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+#endif
+
+#define RADIX_TREE_MAP_SHIFT	6
+#define RADIX_TREE_MAP_SIZE	(1UL << RADIX_TREE_MAP_SHIFT)
+#define RADIX_TREE_MAP_MASK	(RADIX_TREE_MAP_SIZE-1)
+
+#ifdef RADIX_TREE_TAGS
+#define RADIX_TREE_TAG_LONGS	\
+	((RADIX_TREE_MAP_SIZE + BITS_PER_LONG - 1) / BITS_PER_LONG)
+#endif
+
+struct radix_tree_node {
+	unsigned int	count;
+	void		*slots[RADIX_TREE_MAP_SIZE];
+#ifdef RADIX_TREE_TAGS
+	unsigned long	tags[RADIX_TREE_MAX_TAGS][RADIX_TREE_TAG_LONGS];
+#endif
+};
+
+struct radix_tree_path {
+	struct radix_tree_node *node;
+	int offset;
+};
+
+#define RADIX_TREE_INDEX_BITS  (8 /* CHAR_BIT */ * sizeof(unsigned long))
+#define RADIX_TREE_MAX_PATH (RADIX_TREE_INDEX_BITS/RADIX_TREE_MAP_SHIFT + 2)
+
+static unsigned long height_to_maxindex[RADIX_TREE_MAX_PATH];
+
+/*
+ * Radix tree node cache.
+ */
+
+#define radix_tree_node_alloc(r)	((struct radix_tree_node *) \
+		calloc(1, sizeof(struct radix_tree_node)))
+#define radix_tree_node_free(n)		free(n)
+
+#ifdef RADIX_TREE_TAGS
+
+static inline void tag_set(struct radix_tree_node *node, unsigned int tag,
+		int offset)
+{
+	*((uint32_t *)node->tags[tag] + (offset >> 5)) |= (1 << (offset & 31));
+}
+
+static inline void tag_clear(struct radix_tree_node *node, unsigned int tag,
+		int offset)
+{
+	uint32_t	*p = (uint32_t*)node->tags[tag] + (offset >> 5);
+	uint32_t	m = 1 << (offset & 31);
+	*p &= ~m;
+}
+
+static inline int tag_get(struct radix_tree_node *node, unsigned int tag,
+		int offset)
+{
+	return 1 & (((const uint32_t *)node->tags[tag])[offset >> 5] >> (offset & 31));
+}
+
+/*
+ * Returns 1 if any slot in the node has this tag set.
+ * Otherwise returns 0.
+ */
+static inline int any_tag_set(struct radix_tree_node *node, unsigned int tag)
+{
+	int idx;
+	for (idx = 0; idx < RADIX_TREE_TAG_LONGS; idx++) {
+		if (node->tags[tag][idx])
+			return 1;
+	}
+	return 0;
+}
+
+#endif
+
+/*
+ *	Return the maximum key which can be store into a
+ *	radix tree with height HEIGHT.
+ */
+static inline unsigned long radix_tree_maxindex(unsigned int height)
+{
+	return height_to_maxindex[height];
+}
+
+/*
+ *	Extend a radix tree so it can store key @index.
+ */
+static int radix_tree_extend(struct radix_tree_root *root, unsigned long index)
+{
+	struct radix_tree_node *node;
+	unsigned int height;
+#ifdef RADIX_TREE_TAGS
+	char tags[RADIX_TREE_MAX_TAGS];
+	int tag;
+#endif
+
+	/* Figure out what the height should be.  */
+	height = root->height + 1;
+	while (index > radix_tree_maxindex(height))
+		height++;
+
+	if (root->rnode == NULL) {
+		root->height = height;
+		goto out;
+	}
+
+#ifdef RADIX_TREE_TAGS
+	/*
+	 * Prepare the tag status of the top-level node for propagation
+	 * into the newly-pushed top-level node(s)
+	 */
+	for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
+		tags[tag] = 0;
+		if (any_tag_set(root->rnode, tag))
+			tags[tag] = 1;
+	}
+#endif
+	do {
+		if (!(node = radix_tree_node_alloc(root)))
+			return -ENOMEM;
+
+		/* Increase the height.  */
+		node->slots[0] = root->rnode;
+
+#ifdef RADIX_TREE_TAGS
+		/* Propagate the aggregated tag info into the new root */
+		for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
+			if (tags[tag])
+				tag_set(node, tag, 0);
+		}
+#endif
+		node->count = 1;
+		root->rnode = node;
+		root->height++;
+	} while (height > root->height);
+out:
+	return 0;
+}
+
+/**
+ *	radix_tree_insert    -    insert into a radix tree
+ *	@root:		radix tree root
+ *	@index:		index key
+ *	@item:		item to insert
+ *
+ *	Insert an item into the radix tree at position @index.
+ */
+int radix_tree_insert(struct radix_tree_root *root,
+			unsigned long index, void *item)
+{
+	struct radix_tree_node *node = NULL, *slot;
+	unsigned int height, shift;
+	int offset;
+	int error;
+
+	/* Make sure the tree is high enough.  */
+	if ((!index && !root->rnode) ||
+			index > radix_tree_maxindex(root->height)) {
+		error = radix_tree_extend(root, index);
+		if (error)
+			return error;
+	}
+
+	slot = root->rnode;
+	height = root->height;
+	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
+
+	offset = 0;			/* uninitialised var warning */
+	do {
+		if (slot == NULL) {
+			/* Have to add a child node.  */
+			if (!(slot = radix_tree_node_alloc(root)))
+				return -ENOMEM;
+			if (node) {
+				node->slots[offset] = slot;
+				node->count++;
+			} else
+				root->rnode = slot;
+		}
+
+		/* Go a level down */
+		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+		node = slot;
+		slot = node->slots[offset];
+		shift -= RADIX_TREE_MAP_SHIFT;
+		height--;
+	} while (height > 0);
+
+	if (slot != NULL)
+		return -EEXIST;
+
+	ASSERT(node);
+	node->count++;
+	node->slots[offset] = item;
+#ifdef RADIX_TREE_TAGS
+	ASSERT(!tag_get(node, 0, offset));
+	ASSERT(!tag_get(node, 1, offset));
+#endif
+	return 0;
+}
+
+static inline void **__lookup_slot(struct radix_tree_root *root,
+				   unsigned long index)
+{
+	unsigned int height, shift;
+	struct radix_tree_node **slot;
+
+	height = root->height;
+	if (index > radix_tree_maxindex(height))
+		return NULL;
+
+	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
+	slot = &root->rnode;
+
+	while (height > 0) {
+		if (*slot == NULL)
+			return NULL;
+
+		slot = (struct radix_tree_node **)
+			((*slot)->slots +
+				((index >> shift) & RADIX_TREE_MAP_MASK));
+		shift -= RADIX_TREE_MAP_SHIFT;
+		height--;
+	}
+
+	return (void **)slot;
+}
+
+/**
+ *	radix_tree_lookup_slot    -    lookup a slot in a radix tree
+ *	@root:		radix tree root
+ *	@index:		index key
+ *
+ *	Lookup the slot corresponding to the position @index in the radix tree
+ *	@root. This is useful for update-if-exists operations.
+ */
+void **radix_tree_lookup_slot(struct radix_tree_root *root, unsigned long index)
+{
+	return __lookup_slot(root, index);
+}
+
+/**
+ *	radix_tree_lookup    -    perform lookup operation on a radix tree
+ *	@root:		radix tree root
+ *	@index:		index key
+ *
+ *	Lookup the item at the position @index in the radix tree @root.
+ */
+void *radix_tree_lookup(struct radix_tree_root *root, unsigned long index)
+{
+	void **slot;
+
+	slot = __lookup_slot(root, index);
+	return slot != NULL ? *slot : NULL;
+}
+
+/**
+ *	raid_tree_first_key - find the first index key in the radix tree
+ *	@root:		radix tree root
+ *	@index:		where the first index will be placed
+ *
+ *	Returns the first entry and index key in the radix tree @root.
+ */
+void *radix_tree_lookup_first(struct radix_tree_root *root, unsigned long *index)
+{
+	unsigned int height, shift;
+	struct radix_tree_node *slot;
+	unsigned long i;
+
+	height = root->height;
+	*index = 0;
+	if (height == 0)
+		return NULL;
+
+	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
+	slot = root->rnode;
+
+	for (; height > 1; height--) {
+		for (i = 0; i < RADIX_TREE_MAP_SIZE; i++) {
+			if (slot->slots[i] != NULL)
+				break;
+		}
+		ASSERT(i < RADIX_TREE_MAP_SIZE);
+
+		*index |= (i << shift);
+		shift -= RADIX_TREE_MAP_SHIFT;
+		slot = slot->slots[i];
+	}
+	for (i = 0; i < RADIX_TREE_MAP_SIZE; i++) {
+		if (slot->slots[i] != NULL) {
+			*index |= i;
+			return slot->slots[i];
+		}
+	}
+	return NULL;
+}
+
+#ifdef RADIX_TREE_TAGS
+
+/**
+ *	radix_tree_tag_set - set a tag on a radix tree node
+ *	@root:		radix tree root
+ *	@index:		index key
+ *	@tag:		tag index
+ *
+ *	Set the search tag (which must be < RADIX_TREE_MAX_TAGS)
+ *	corresponding to @index in the radix tree.  From
+ *	the root all the way down to the leaf node.
+ *
+ *	Returns the address of the tagged item.   Setting a tag on a not-present
+ *	item is a bug.
+ */
+void *radix_tree_tag_set(struct radix_tree_root *root,
+			unsigned long index, unsigned int tag)
+{
+	unsigned int height, shift;
+	struct radix_tree_node *slot;
+
+	height = root->height;
+	if (index > radix_tree_maxindex(height))
+		return NULL;
+
+	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
+	slot = root->rnode;
+
+	while (height > 0) {
+		int offset;
+
+		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+		if (!tag_get(slot, tag, offset))
+			tag_set(slot, tag, offset);
+		slot = slot->slots[offset];
+		ASSERT(slot != NULL);
+		shift -= RADIX_TREE_MAP_SHIFT;
+		height--;
+	}
+
+	return slot;
+}
+
+/**
+ *	radix_tree_tag_clear - clear a tag on a radix tree node
+ *	@root:		radix tree root
+ *	@index:		index key
+ *	@tag:		tag index
+ *
+ *	Clear the search tag (which must be < RADIX_TREE_MAX_TAGS)
+ *	corresponding to @index in the radix tree.  If
+ *	this causes the leaf node to have no tags set then clear the tag in the
+ *	next-to-leaf node, etc.
+ *
+ *	Returns the address of the tagged item on success, else NULL.  ie:
+ *	has the same return value and semantics as radix_tree_lookup().
+ */
+void *radix_tree_tag_clear(struct radix_tree_root *root,
+			unsigned long index, unsigned int tag)
+{
+	struct radix_tree_path path[RADIX_TREE_MAX_PATH + 1], *pathp = path;
+	struct radix_tree_node *slot;
+	unsigned int height, shift;
+	void *ret = NULL;
+
+	height = root->height;
+	if (index > radix_tree_maxindex(height))
+		goto out;
+
+	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
+	pathp->node = NULL;
+	slot = root->rnode;
+
+	while (height > 0) {
+		int offset;
+
+		if (slot == NULL)
+			goto out;
+
+		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+		pathp[1].offset = offset;
+		pathp[1].node = slot;
+		slot = slot->slots[offset];
+		pathp++;
+		shift -= RADIX_TREE_MAP_SHIFT;
+		height--;
+	}
+
+	ret = slot;
+	if (ret == NULL)
+		goto out;
+
+	do {
+		if (!tag_get(pathp->node, tag, pathp->offset))
+			goto out;
+		tag_clear(pathp->node, tag, pathp->offset);
+		if (any_tag_set(pathp->node, tag))
+			goto out;
+		pathp--;
+	} while (pathp->node);
+out:
+	return ret;
+}
+
+#endif
+
+static unsigned int
+__lookup(struct radix_tree_root *root, void **results, unsigned long index,
+	unsigned int max_items, unsigned long *next_index)
+{
+	unsigned int nr_found = 0;
+	unsigned int shift, height;
+	struct radix_tree_node *slot;
+	unsigned long i;
+
+	height = root->height;
+	if (height == 0)
+		goto out;
+
+	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
+	slot = root->rnode;
+
+	for ( ; height > 1; height--) {
+
+		for (i = (index >> shift) & RADIX_TREE_MAP_MASK ;
+				i < RADIX_TREE_MAP_SIZE; i++) {
+			if (slot->slots[i] != NULL)
+				break;
+			index &= ~((1UL << shift) - 1);
+			index += 1UL << shift;
+			if (index == 0)
+				goto out;	/* 32-bit wraparound */
+		}
+		if (i == RADIX_TREE_MAP_SIZE)
+			goto out;
+
+		shift -= RADIX_TREE_MAP_SHIFT;
+		slot = slot->slots[i];
+	}
+
+	/* Bottom level: grab some items */
+	for (i = index & RADIX_TREE_MAP_MASK; i < RADIX_TREE_MAP_SIZE; i++) {
+		index++;
+		if (slot->slots[i]) {
+			results[nr_found++] = slot->slots[i];
+			if (nr_found == max_items)
+				goto out;
+		}
+	}
+out:
+	*next_index = index;
+	return nr_found;
+}
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
+ */
+unsigned int
+radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
+			unsigned long first_index, unsigned int max_items)
+{
+	const unsigned long max_index = radix_tree_maxindex(root->height);
+	unsigned long cur_index = first_index;
+	unsigned int ret = 0;
+
+	while (ret < max_items) {
+		unsigned int nr_found;
+		unsigned long next_index;	/* Index of next search */
+
+		if (cur_index > max_index)
+			break;
+		nr_found = __lookup(root, results + ret, cur_index,
+					max_items - ret, &next_index);
+		ret += nr_found;
+		if (next_index == 0)
+			break;
+		cur_index = next_index;
+	}
+	return ret;
+}
+
+/**
+ *	radix_tree_gang_lookup_ex - perform multiple lookup on a radix tree
+ *	@root:		radix tree root
+ *	@results:	where the results of the lookup are placed
+ *	@first_index:	start the lookup from this key
+ *	@last_index:	don't lookup past this key
+ *	@max_items:	place up to this many items at *results
+ *
+ *	Performs an index-ascending scan of the tree for present items starting
+ *	@first_index until @last_index up to as many as @max_items.  Places
+ *	them at *@results and returns the number of items which were placed
+ *	at *@results.
+ *
+ *	The implementation is naive.
+ */
+unsigned int
+radix_tree_gang_lookup_ex(struct radix_tree_root *root, void **results,
+			unsigned long first_index, unsigned long last_index,
+			unsigned int max_items)
+{
+	const unsigned long max_index = radix_tree_maxindex(root->height);
+	unsigned long cur_index = first_index;
+	unsigned int ret = 0;
+
+	while (ret < max_items && cur_index < last_index) {
+		unsigned int nr_found;
+		unsigned long next_index;	/* Index of next search */
+
+		if (cur_index > max_index)
+			break;
+		nr_found = __lookup(root, results + ret, cur_index,
+					max_items - ret, &next_index);
+		ret += nr_found;
+		if (next_index == 0)
+			break;
+		cur_index = next_index;
+	}
+	return ret;
+}
+
+#ifdef RADIX_TREE_TAGS
+
+static unsigned int
+__lookup_tag(struct radix_tree_root *root, void **results, unsigned long index,
+	unsigned int max_items, unsigned long *next_index, unsigned int tag)
+{
+	unsigned int nr_found = 0;
+	unsigned int shift;
+	unsigned int height = root->height;
+	struct radix_tree_node *slot;
+
+	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
+	slot = root->rnode;
+
+	while (height > 0) {
+		unsigned long i = (index >> shift) & RADIX_TREE_MAP_MASK;
+
+		for ( ; i < RADIX_TREE_MAP_SIZE; i++) {
+			if (tag_get(slot, tag, i)) {
+				ASSERT(slot->slots[i] != NULL);
+				break;
+			}
+			index &= ~((1UL << shift) - 1);
+			index += 1UL << shift;
+			if (index == 0)
+				goto out;	/* 32-bit wraparound */
+		}
+		if (i == RADIX_TREE_MAP_SIZE)
+			goto out;
+		height--;
+		if (height == 0) {	/* Bottom level: grab some items */
+			unsigned long j = index & RADIX_TREE_MAP_MASK;
+
+			for ( ; j < RADIX_TREE_MAP_SIZE; j++) {
+				index++;
+				if (tag_get(slot, tag, j)) {
+					ASSERT(slot->slots[j] != NULL);
+					results[nr_found++] = slot->slots[j];
+					if (nr_found == max_items)
+						goto out;
+				}
+			}
+		}
+		shift -= RADIX_TREE_MAP_SHIFT;
+		slot = slot->slots[i];
+	}
+out:
+	*next_index = index;
+	return nr_found;
+}
+
+/**
+ *	radix_tree_gang_lookup_tag - perform multiple lookup on a radix tree
+ *	                             based on a tag
+ *	@root:		radix tree root
+ *	@results:	where the results of the lookup are placed
+ *	@first_index:	start the lookup from this key
+ *	@max_items:	place up to this many items at *results
+ *	@tag:		the tag index (< RADIX_TREE_MAX_TAGS)
+ *
+ *	Performs an index-ascending scan of the tree for present items which
+ *	have the tag indexed by @tag set.  Places the items at *@results and
+ *	returns the number of items which were placed at *@results.
+ */
+unsigned int
+radix_tree_gang_lookup_tag(struct radix_tree_root *root, void **results,
+		unsigned long first_index, unsigned int max_items,
+		unsigned int tag)
+{
+	const unsigned long max_index = radix_tree_maxindex(root->height);
+	unsigned long cur_index = first_index;
+	unsigned int ret = 0;
+
+	while (ret < max_items) {
+		unsigned int nr_found;
+		unsigned long next_index;	/* Index of next search */
+
+		if (cur_index > max_index)
+			break;
+		nr_found = __lookup_tag(root, results + ret, cur_index,
+					max_items - ret, &next_index, tag);
+		ret += nr_found;
+		if (next_index == 0)
+			break;
+		cur_index = next_index;
+	}
+	return ret;
+}
+
+#endif
+
+/**
+ *	radix_tree_shrink    -    shrink height of a radix tree to minimal
+ *	@root		radix tree root
+ */
+static inline void radix_tree_shrink(struct radix_tree_root *root)
+{
+	/* try to shrink tree height */
+	while (root->height > 1 &&
+			root->rnode->count == 1 &&
+			root->rnode->slots[0]) {
+		struct radix_tree_node *to_free = root->rnode;
+
+		root->rnode = to_free->slots[0];
+		root->height--;
+		/* must only free zeroed nodes into the slab */
+#ifdef RADIX_TREE_TAGS
+		tag_clear(to_free, 0, 0);
+		tag_clear(to_free, 1, 0);
+#endif
+		to_free->slots[0] = NULL;
+		to_free->count = 0;
+		radix_tree_node_free(to_free);
+	}
+}
+
+/**
+ *	radix_tree_delete    -    delete an item from a radix tree
+ *	@root:		radix tree root
+ *	@index:		index key
+ *
+ *	Remove the item at @index from the radix tree rooted at @root.
+ *
+ *	Returns the address of the deleted item, or NULL if it was not present.
+ */
+void *radix_tree_delete(struct radix_tree_root *root, unsigned long index)
+{
+	struct radix_tree_path path[RADIX_TREE_MAX_PATH + 1], *pathp = path;
+	struct radix_tree_path *orig_pathp;
+	struct radix_tree_node *slot;
+	unsigned int height, shift;
+	void *ret = NULL;
+#ifdef RADIX_TREE_TAGS
+	char tags[RADIX_TREE_MAX_TAGS];
+	int nr_cleared_tags;
+	int tag;
+#endif
+	int offset;
+
+	height = root->height;
+	if (index > radix_tree_maxindex(height))
+		goto out;
+
+	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
+	pathp->node = NULL;
+	slot = root->rnode;
+
+	for ( ; height > 0; height--) {
+		if (slot == NULL)
+			goto out;
+
+		pathp++;
+		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+		pathp->offset = offset;
+		pathp->node = slot;
+		slot = slot->slots[offset];
+		shift -= RADIX_TREE_MAP_SHIFT;
+	}
+
+	ret = slot;
+	if (ret == NULL)
+		goto out;
+
+	orig_pathp = pathp;
+
+#ifdef RADIX_TREE_TAGS
+	/*
+	 * Clear all tags associated with the just-deleted item
+	 */
+	nr_cleared_tags = 0;
+	for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
+		tags[tag] = 1;
+		if (tag_get(pathp->node, tag, pathp->offset)) {
+			tag_clear(pathp->node, tag, pathp->offset);
+			if (!any_tag_set(pathp->node, tag)) {
+				tags[tag] = 0;
+				nr_cleared_tags++;
+			}
+		}
+	}
+
+	for (pathp--; nr_cleared_tags && pathp->node; pathp--) {
+		for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
+			if (tags[tag])
+				continue;
+
+			tag_clear(pathp->node, tag, pathp->offset);
+			if (any_tag_set(pathp->node, tag)) {
+				tags[tag] = 1;
+				nr_cleared_tags--;
+			}
+		}
+	}
+#endif
+	/* Now free the nodes we do not need anymore */
+	for (pathp = orig_pathp; pathp->node; pathp--) {
+		pathp->node->slots[pathp->offset] = NULL;
+		pathp->node->count--;
+
+		if (pathp->node->count) {
+			if (pathp->node == root->rnode)
+				radix_tree_shrink(root);
+			goto out;
+		}
+
+		/* Node with zero slots in use so free it */
+		radix_tree_node_free(pathp->node);
+	}
+	root->rnode = NULL;
+	root->height = 0;
+out:
+	return ret;
+}
+
+#ifdef RADIX_TREE_TAGS
+/**
+ *	radix_tree_tagged - test whether any items in the tree are tagged
+ *	@root:		radix tree root
+ *	@tag:		tag to test
+ */
+int radix_tree_tagged(struct radix_tree_root *root, unsigned int tag)
+{
+	struct radix_tree_node *rnode;
+	rnode = root->rnode;
+	if (!rnode)
+		return 0;
+	return any_tag_set(rnode, tag);
+}
+#endif
+
+static unsigned long __maxindex(unsigned int height)
+{
+	unsigned int width = height * RADIX_TREE_MAP_SHIFT;
+	int shift = RADIX_TREE_INDEX_BITS - width;
+
+	if (shift < 0)
+		return ~0UL;
+	if (shift >= BITS_PER_LONG)
+		return 0UL;
+	return ~0UL >> shift;
+}
+
+static void radix_tree_init_maxindex(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(height_to_maxindex); i++)
+		height_to_maxindex[i] = __maxindex(i);
+}
+
+void radix_tree_init(void)
+{
+	radix_tree_init_maxindex();
+}
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 994b1e5..0470f5f 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -58,9 +58,7 @@ CFILES = cache.c \
 	defer_item.c \
 	init.c \
 	kmem.c \
-	list_sort.c \
 	logitem.c \
-	radix-tree.c \
 	rdwr.c \
 	trans.c \
 	util.c \
diff --git a/libxfs/list_sort.c b/libxfs/list_sort.c
deleted file mode 100644
index 16258d9..0000000
--- a/libxfs/list_sort.c
+++ /dev/null
@@ -1,141 +0,0 @@
-/* List sorting code from Linux::lib/list_sort.c. */
-
-#include "libxfs_priv.h"
-#include "libxfs_io.h"
-#include "init.h"
-#include "list.h"
-
-#define MAX_LIST_LENGTH_BITS 20
-
-/*
- * Returns a list organized in an intermediate format suited
- * to chaining of merge() calls: null-terminated, no reserved or
- * sentinel head node, "prev" links not maintained.
- */
-static struct list_head *merge(void *priv,
-				int (*cmp)(void *priv, struct list_head *a,
-					struct list_head *b),
-				struct list_head *a, struct list_head *b)
-{
-	struct list_head head, *tail = &head;
-
-	while (a && b) {
-		/* if equal, take 'a' -- important for sort stability */
-		if ((*cmp)(priv, a, b) <= 0) {
-			tail->next = a;
-			a = a->next;
-		} else {
-			tail->next = b;
-			b = b->next;
-		}
-		tail = tail->next;
-	}
-	tail->next = a?:b;
-	return head.next;
-}
-
-/*
- * Combine final list merge with restoration of standard doubly-linked
- * list structure.  This approach duplicates code from merge(), but
- * runs faster than the tidier alternatives of either a separate final
- * prev-link restoration pass, or maintaining the prev links
- * throughout.
- */
-static void merge_and_restore_back_links(void *priv,
-				int (*cmp)(void *priv, struct list_head *a,
-					struct list_head *b),
-				struct list_head *head,
-				struct list_head *a, struct list_head *b)
-{
-	struct list_head *tail = head;
-	unsigned count = 0;
-
-	while (a && b) {
-		/* if equal, take 'a' -- important for sort stability */
-		if ((*cmp)(priv, a, b) <= 0) {
-			tail->next = a;
-			a->prev = tail;
-			a = a->next;
-		} else {
-			tail->next = b;
-			b->prev = tail;
-			b = b->next;
-		}
-		tail = tail->next;
-	}
-	tail->next = a ? : b;
-
-	do {
-		/*
-		 * In worst cases this loop may run many iterations.
-		 * Continue callbacks to the client even though no
-		 * element comparison is needed, so the client's cmp()
-		 * routine can invoke cond_resched() periodically.
-		 */
-		if (unlikely(!(++count)))
-			(*cmp)(priv, tail->next, tail->next);
-
-		tail->next->prev = tail;
-		tail = tail->next;
-	} while (tail->next);
-
-	tail->next = head;
-	head->prev = tail;
-}
-
-/**
- * list_sort - sort a list
- * @priv: private data, opaque to list_sort(), passed to @cmp
- * @head: the list to sort
- * @cmp: the elements comparison function
- *
- * This function implements "merge sort", which has O(nlog(n))
- * complexity.
- *
- * The comparison function @cmp must return a negative value if @a
- * should sort before @b, and a positive value if @a should sort after
- * @b. If @a and @b are equivalent, and their original relative
- * ordering is to be preserved, @cmp must return 0.
- */
-void list_sort(void *priv, struct list_head *head,
-		int (*cmp)(void *priv, struct list_head *a,
-			struct list_head *b))
-{
-	struct list_head *part[MAX_LIST_LENGTH_BITS+1]; /* sorted partial lists
-						-- last slot is a sentinel */
-	int lev;  /* index into part[] */
-	int max_lev = 0;
-	struct list_head *list;
-
-	if (list_empty(head))
-		return;
-
-	memset(part, 0, sizeof(part));
-
-	head->prev->next = NULL;
-	list = head->next;
-
-	while (list) {
-		struct list_head *cur = list;
-		list = list->next;
-		cur->next = NULL;
-
-		for (lev = 0; part[lev]; lev++) {
-			cur = merge(priv, cmp, part[lev], cur);
-			part[lev] = NULL;
-		}
-		if (lev > max_lev) {
-			if (unlikely(lev >= ARRAY_SIZE(part)-1)) {
-				lev--;
-			}
-			max_lev = lev;
-		}
-		part[lev] = cur;
-	}
-
-	for (lev = 0; lev < max_lev; lev++)
-		if (part[lev])
-			list = merge(priv, cmp, part[lev], list);
-
-	merge_and_restore_back_links(priv, cmp, head, part[max_lev], list);
-}
diff --git a/libxfs/radix-tree.c b/libxfs/radix-tree.c
deleted file mode 100644
index 3f0257f..0000000
--- a/libxfs/radix-tree.c
+++ /dev/null
@@ -1,808 +0,0 @@
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
-#include "platform_defs.h"
-#include "xfs.h"
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
-	*((uint32_t *)node->tags[tag] + (offset >> 5)) |= (1 << (offset & 31));
-}
-
-static inline void tag_clear(struct radix_tree_node *node, unsigned int tag,
-		int offset)
-{
-	uint32_t 	*p = (uint32_t*)node->tags[tag] + (offset >> 5);
-	uint32_t 	m = 1 << (offset & 31);
-	*p &= ~m;
-}
-
-static inline int tag_get(struct radix_tree_node *node, unsigned int tag,
-		int offset)
-{
-	return 1 & (((const uint32_t *)node->tags[tag])[offset >> 5] >> (offset & 31));
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
-	struct radix_tree_path path[RADIX_TREE_MAX_PATH + 1], *pathp = path;
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
-	struct radix_tree_path path[RADIX_TREE_MAX_PATH + 1], *pathp = path;
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
-	unsigned int width = height * RADIX_TREE_MAP_SHIFT;
-	int shift = RADIX_TREE_INDEX_BITS - width;
-
-	if (shift < 0)
-		return ~0UL;
-	if (shift >= BITS_PER_LONG)
-		return 0UL;
-	return ~0UL >> shift;
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
diff --git a/logprint/Makefile b/logprint/Makefile
index 534bf5b..7fbbc98 100644
--- a/logprint/Makefile
+++ b/logprint/Makefile
@@ -12,8 +12,8 @@ CFILES = logprint.c \
 	 log_copy.c log_dump.c log_misc.c \
 	 log_print_all.c log_print_trans.c log_redo.c
 
-LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
-LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
+LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
+LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
 default: depend $(LTCOMMAND)
diff --git a/mdrestore/Makefile b/mdrestore/Makefile
index 5171306..136ae71 100644
--- a/mdrestore/Makefile
+++ b/mdrestore/Makefile
@@ -8,8 +8,8 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_mdrestore
 CFILES = xfs_mdrestore.c
 
-LLDLIBS = $(LIBXFS) $(LIBRT) $(LIBPTHREAD) $(LIBUUID)
-LTDEPENDENCIES = $(LIBXFS)
+LLDLIBS = $(LIBXFS) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBUUID)
+LTDEPENDENCIES = $(LIBXFS) $(LIBFROG)
 LLDFLAGS = -static
 
 default: depend $(LTCOMMAND)

