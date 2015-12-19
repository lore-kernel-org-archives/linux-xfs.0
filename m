Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 639C529E37
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:08:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2A273304059
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:08:02 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id qTbnR31fmRHOcoAu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:07:59 -0800 (PST)
Subject: [PATCH 28/53] xfs_repair: create a slab API for allocating arrays
	in large chunks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:07:56 -0800
Message-ID: <20151219090756.14255.59497.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Create a slab-based array and a bag-of-pointers data structure to
facilitate rapid linear scans of reverse-mapping data for later
reconstruction of the refcount and rmap btrees.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/Makefile |    4 
 repair/slab.c   |  473 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/slab.h   |   58 +++++++
 3 files changed, 533 insertions(+), 2 deletions(-)
 create mode 100644 repair/slab.c
 create mode 100644 repair/slab.h


diff --git a/repair/Makefile b/repair/Makefile
index 251722b..756ba95 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -11,13 +11,13 @@ LTCOMMAND = xfs_repair
 
 HFILES = agheader.h attr_repair.h avl.h avl64.h bmap.h btree.h \
 	da_util.h dinode.h dir2.h err_protos.h globals.h incore.h protos.h \
-	rt.h progress.h scan.h versions.h prefetch.h threads.h
+	rt.h progress.h scan.h versions.h prefetch.h slab.h threads.h
 
 CFILES = agheader.c attr_repair.c avl.c avl64.c bmap.c btree.c \
 	da_util.c dino_chunks.c dinode.c dir2.c globals.c incore.c \
 	incore_bmc.c init.c incore_ext.c incore_ino.c phase1.c \
 	phase2.c phase3.c phase4.c phase5.c phase6.c phase7.c \
-	progress.c prefetch.c rt.c sb.c scan.c threads.c \
+	progress.c prefetch.c rt.c sb.c scan.c slab.c threads.c \
 	versions.c xfs_repair.c
 
 LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
diff --git a/repair/slab.c b/repair/slab.c
new file mode 100644
index 0000000..bb7019a
--- /dev/null
+++ b/repair/slab.c
@@ -0,0 +1,473 @@
+/*
+ * Copyright (c) 2015 Oracle.
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
+#include "slab.h"
+
+#undef SLAB_DEBUG
+
+#ifdef SLAB_DEBUG
+# define dbg_printf(f, a...)  do {printf(f, ## a); fflush(stdout); } while (0)
+#else
+# define dbg_printf(f, a...)
+#endif
+
+/*
+ * Slab Arrays and Bags
+ *
+ * The slab array is a dynamically growable linear array.  Internally it
+ * maintains a list of slabs of increasing size; when a slab fills up, another
+ * is allocated.  Each slab is sorted individually, which means that one must
+ * use an iterator to walk the entire logical array, sorted order or otherwise.
+ * Array items can neither be removed nor accessed randomly, since (at the
+ * moment) the only user of them (storing reverse mappings) doesn't need either
+ * piece.  Pointers are not stable across sort operations.
+ *
+ * A bag is a collection of pointers.  The bag can be added to or removed from
+ * arbitrarily, and the bag items can be iterated.  Bags are used to process
+ * rmaps into refcount btree entries.
+ */
+
+/*
+ * Slabs -- each slab_hdr holds an array of items; when a slab_hdr fills up, we
+ * allocate a new one and add to that one.  The slab object coordinates the
+ * slab_hdrs.
+ */
+
+/* Each slab holds at least 4096 items */
+#define MIN_SLAB_NR		4096
+/* and cannot be larger than 128M */
+#define MAX_SLAB_SIZE		(128 * 1048576)
+struct xfs_slab_hdr {
+	size_t			sh_nr;
+	size_t			sh_inuse;	/* items in use */
+	struct xfs_slab_hdr	*sh_next;	/* next slab hdr */
+						/* objects follow */
+};
+
+struct xfs_slab {
+	size_t			s_item_sz;	/* item size */
+	size_t			s_nr_slabs;	/* # of slabs */
+	size_t			s_nr_items;	/* # of items */
+	struct xfs_slab_hdr	*s_first;	/* first slab header */
+	struct xfs_slab_hdr	*s_last;	/* last sh_next pointer */
+};
+
+/*
+ * Slab cursors -- each slab_hdr_cursor tracks a slab_hdr; the slab_cursor
+ * tracks the slab_hdr_cursors.  If a compare_fn is specified, the cursor
+ * returns objects in increasing order (if you've previously sorted the
+ * slabs with qsort_slab()).  If compare_fn == NULL, it returns slab items
+ * in order.
+ */
+struct xfs_slab_hdr_cursor {
+	struct xfs_slab_hdr	*hdr;		/* a slab header */
+	size_t			loc;		/* where we are in the slab */
+};
+
+struct xfs_slab_cursor {
+	size_t				nr;		/* # of per-slab cursors */
+	struct xfs_slab			*slab;		/* pointer to the slab */
+	struct xfs_slab_hdr_cursor	*last_hcur;	/* last header we took from */
+	int (*compare_fn)(const void *, const void *);	/* compare function */
+	struct xfs_slab_hdr_cursor	hcur[0];	/* per-slab curosr */
+};
+
+/*
+ * Bags -- each bag is an array of pointers items; when a bag fills up, we
+ * resize it.
+ */
+#define MIN_BAG_SIZE	4096
+struct xfs_bag {
+	size_t			bg_nr;		/* number of pointers */
+	size_t			bg_inuse;	/* number of slots in use */
+	void			**bg_ptrs;	/* pointers */
+};
+#define BAG_SIZE(nr)	(sizeof(struct xfs_bag) + ((nr) * sizeof(void *)))
+#define BAG_END(bag)	(&(bag)->bg_ptrs[(bag)->bg_nr])
+
+/**
+ * init_slab() -- Create a slab to hold some objects.
+ *
+ * @slab: The slab.
+ * @item_size: Create items of this size.
+ */
+int
+init_slab(
+	struct xfs_slab	**slab,
+	size_t		item_size)
+{
+	struct xfs_slab	*ptr;
+
+	ptr = calloc(1, sizeof(struct xfs_slab));
+	if (!ptr)
+		return -ENOMEM;
+	ptr->s_item_sz = item_size;
+	ptr->s_last = NULL;
+	*slab = ptr;
+
+	return 0;
+}
+
+/**
+ * free_slab() -- Frees a slab.
+ */
+void
+free_slab(
+	struct xfs_slab		**slab)
+{
+	struct xfs_slab		*ptr;
+	struct xfs_slab_hdr	*hdr;
+	struct xfs_slab_hdr	*nhdr;
+
+	ptr = *slab;
+	if (!ptr)
+		return;
+	hdr = ptr->s_first;
+	while (hdr) {
+		nhdr = hdr->sh_next;
+		free(hdr);
+		hdr = nhdr;
+	}
+	free(ptr);
+	*slab = NULL;
+}
+
+static void *
+slab_ptr(
+	struct xfs_slab		*slab,
+	struct xfs_slab_hdr	*hdr,
+	size_t			idx)
+{
+	char			*p;
+
+	ASSERT(idx < hdr->sh_inuse);
+	p = (char *)(hdr + 1);
+	p += slab->s_item_sz * idx;
+	return p;
+}
+
+/**
+ * slab_add() -- Add an item to the slab.
+ */
+int
+slab_add(
+	struct xfs_slab		*slab,
+	void			*item)
+{
+	struct xfs_slab_hdr		*hdr;
+	void			*p;
+
+	hdr = slab->s_last;
+	if (!hdr || hdr->sh_inuse == hdr->sh_nr) {
+		size_t n;
+
+		n = (hdr ? hdr->sh_nr * 2 : MIN_SLAB_NR);
+		if (n * slab->s_item_sz > MAX_SLAB_SIZE)
+			n = MAX_SLAB_SIZE / slab->s_item_sz;
+		hdr = malloc(sizeof(struct xfs_slab_hdr) + (n * slab->s_item_sz));
+		if (!hdr)
+			return -ENOMEM;
+		hdr->sh_nr = n;
+		hdr->sh_inuse = 0;
+		hdr->sh_next = NULL;
+		if (slab->s_last)
+			slab->s_last->sh_next = hdr;
+		if (!slab->s_first)
+			slab->s_first = hdr;
+		slab->s_last = hdr;
+		slab->s_nr_slabs++;
+	}
+	hdr->sh_inuse++;
+	p = slab_ptr(slab, hdr, hdr->sh_inuse - 1);
+	memcpy(p, item, slab->s_item_sz);
+	slab->s_nr_items++;
+
+	return 0;
+}
+
+/**
+ * qsort_slab() -- Sort the items in the slab.  Do not run this method
+ * if there are any cursors holding on to the slab.
+ */
+void
+qsort_slab(
+	struct xfs_slab		*slab,
+	int (*compare_fn)(const void *, const void *))
+{
+	struct xfs_slab_hdr	*hdr;
+
+	hdr = slab->s_first;
+	while (hdr) {
+		qsort(slab_ptr(slab, hdr, 0), hdr->sh_inuse, slab->s_item_sz,
+		      compare_fn);
+		hdr = hdr->sh_next;
+	}
+}
+
+/*
+ * init_slab_cursor() -- Create a slab cursor to iterate the slab items.
+ *
+ * @slab: The slab.
+ * @compare_fn: If specified, use this function to return items in ascending order.
+ * @cur: The new cursor.
+ */
+int
+init_slab_cursor(
+	struct xfs_slab		*slab,
+	int (*compare_fn)(const void *, const void *),
+	struct xfs_slab_cursor	**cur)
+{
+	struct xfs_slab_cursor	*c;
+	struct xfs_slab_hdr_cursor	*hcur;
+	struct xfs_slab_hdr	*hdr;
+
+	c = malloc(sizeof(struct xfs_slab_cursor) +
+		   (sizeof(struct xfs_slab_hdr_cursor) * slab->s_nr_slabs));
+	if (!c)
+		return -ENOMEM;
+	c->nr = slab->s_nr_slabs;
+	c->slab = slab;
+	c->compare_fn = compare_fn;
+	c->last_hcur = NULL;
+	hcur = (struct xfs_slab_hdr_cursor *)(c + 1);
+	hdr = slab->s_first;
+	while (hdr) {
+		hcur->hdr = hdr;
+		hcur->loc = 0;
+		hcur++;
+		hdr = hdr->sh_next;
+	}
+	*cur = c;
+	return 0;
+}
+
+/**
+ * free_slab_cursor() -- Free the slab cursor.
+ */
+void
+free_slab_cursor(
+	struct xfs_slab_cursor	**cur)
+{
+	if (!*cur)
+		return;
+	free(*cur);
+	*cur = NULL;
+}
+
+/**
+ * peek_slab_cursor() -- Return the smallest item in the slab, without
+ * advancing the iterator.  The slabs must be sorted prior to the creation
+ * of the cursor.
+ */
+void *
+peek_slab_cursor(
+	struct xfs_slab_cursor	*cur)
+{
+	struct xfs_slab_hdr_cursor	*hcur;
+	void			*p = NULL;
+	void			*q;
+	size_t			i;
+
+	cur->last_hcur = NULL;
+
+	/* no compare function; inorder traversal */
+	if (!cur->compare_fn) {
+		if (!cur->last_hcur)
+			cur->last_hcur = &cur->hcur[0];
+		hcur = cur->last_hcur;
+		while (hcur < &cur->hcur[cur->nr] &&
+			hcur->loc >= hcur->hdr->sh_inuse)
+			hcur++;
+		if (hcur == &cur->hcur[cur->nr])
+			return NULL;
+		p = slab_ptr(cur->slab, hcur->hdr, hcur->loc);
+		cur->last_hcur = hcur;
+		return p;
+	}
+
+	/* otherwise return things in increasing order */
+	for (i = 0, hcur = &cur->hcur[i]; i < cur->nr; i++, hcur++) {
+		if (hcur->loc >= hcur->hdr->sh_inuse)
+			continue;
+		q = slab_ptr(cur->slab, hcur->hdr, hcur->loc);
+		if (!p || cur->compare_fn(p, q) > 0) {
+			p = q;
+			cur->last_hcur = hcur;
+		}
+	}
+
+	return p;
+}
+
+/**
+ * advance_slab_cursor() -- After a peek operation, advance the cursor.
+ */
+void
+advance_slab_cursor(
+	struct xfs_slab_cursor	*cur)
+{
+	ASSERT(cur->last_hcur);
+	cur->last_hcur->loc++;
+}
+
+/**
+ * pop_slab_cursor() -- Retrieve the next item in the slab and advance the
+ * cursor.
+ */
+void *
+pop_slab_cursor(
+	struct xfs_slab_cursor	*cur)
+{
+	void			*p;
+
+	p = peek_slab_cursor(cur);
+	if (p)
+		advance_slab_cursor(cur);
+	return p;
+}
+
+/**
+ * slab_count() -- Return the number of items in the slab.
+ */
+size_t
+slab_count(
+	struct xfs_slab	*slab)
+{
+	return slab->s_nr_items;
+}
+
+/**
+ * init_bag() -- Create a bag to point to some objects.
+ *
+ * @bag: The bag.
+ */
+int
+init_bag(
+	struct xfs_bag	**bag)
+{
+	struct xfs_bag	*ptr;
+
+	ptr = calloc(1, sizeof(struct xfs_bag));
+	if (!ptr)
+		return -ENOMEM;
+	ptr->bg_ptrs = calloc(MIN_BAG_SIZE, sizeof(void *));
+	if (!ptr->bg_ptrs) {
+		free(ptr);
+		return -ENOMEM;
+	}
+	ptr->bg_nr = MIN_BAG_SIZE;
+	*bag = ptr;
+	return 0;
+}
+
+/**
+ * free_bag() - Free a bag of pointers.
+ *
+ * @bag: The bag to free.
+ */
+void
+free_bag(
+	struct xfs_bag	**bag)
+{
+	struct xfs_bag	*ptr;
+
+	ptr = *bag;
+	if (!ptr)
+		return;
+	free(ptr->bg_ptrs);
+	free(ptr);
+	*bag = NULL;
+}
+
+/**
+ * bag_add() - Add an object to the pointer bag.
+ *
+ * @bag: The bag.
+ * @ptr: The pointer to add to the bag.
+ */
+int
+bag_add(
+	struct xfs_bag	*bag,
+	void		*ptr)
+{
+	void		**p, **x;
+
+	p = &bag->bg_ptrs[bag->bg_inuse];
+	if (p == BAG_END(bag)) {
+		/* No free space, alloc more pointers */
+		size_t nr;
+
+		nr = bag->bg_nr * 2;
+		x = realloc(bag->bg_ptrs, nr * sizeof(void *));
+		if (!x)
+			return -ENOMEM;
+		bag->bg_ptrs = x;
+		memset(BAG_END(bag), 0, bag->bg_nr * sizeof(void *));
+		bag->bg_nr = nr;
+	}
+	bag->bg_ptrs[bag->bg_inuse] = ptr;
+	bag->bg_inuse++;
+	return 0;
+}
+
+/**
+ * bag_remove() - Remove a pointer from a bag.
+ *
+ * @bag: The bag.
+ * @idx: The number of the pointer to remove.
+ */
+int
+bag_remove(
+	struct xfs_bag	*bag,
+	size_t		nr)
+{
+	ASSERT(nr < bag->bg_inuse);
+	memmove(&bag->bg_ptrs[nr], &bag->bg_ptrs[nr + 1],
+		(bag->bg_inuse - nr) * sizeof(void *));
+	bag->bg_inuse--;
+	return 0;
+}
+
+/**
+ * bag_count() - Return the number of items in a bag.
+ *
+ * @bag: The bag.
+ */
+size_t
+bag_count(
+	struct xfs_bag	*bag)
+{
+	return bag->bg_inuse;
+}
+
+/**
+ * bag_item() - Return the nth item in a bag.
+ *
+ * @bag: The bag.
+ * @nr: The item number.
+ */
+void *
+bag_item(
+	struct xfs_bag	*bag,
+	size_t		nr)
+{
+	if (nr >= bag->bg_inuse)
+		return NULL;
+	return bag->bg_ptrs[nr];
+}
diff --git a/repair/slab.h b/repair/slab.h
new file mode 100644
index 0000000..8142914
--- /dev/null
+++ b/repair/slab.h
@@ -0,0 +1,58 @@
+/*
+ * Copyright (c) 2015 Oracle.
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
+#ifndef SLAB_H_
+#define SLAB_H_
+
+struct xfs_slab;
+struct xfs_slab_cursor;
+
+extern int init_slab(struct xfs_slab **, size_t);
+extern void free_slab(struct xfs_slab **);
+
+extern int slab_add(struct xfs_slab *, void *);
+extern void qsort_slab(struct xfs_slab *, int (*)(const void *, const void *));
+extern size_t slab_count(struct xfs_slab *);
+
+extern int init_slab_cursor(struct xfs_slab *,
+	int (*)(const void *, const void *), struct xfs_slab_cursor **);
+extern void free_slab_cursor(struct xfs_slab_cursor **);
+
+extern void *peek_slab_cursor(struct xfs_slab_cursor *);
+extern void advance_slab_cursor(struct xfs_slab_cursor *);
+extern void *pop_slab_cursor(struct xfs_slab_cursor *);
+
+struct xfs_bag;
+
+extern int init_bag(struct xfs_bag **);
+extern void free_bag(struct xfs_bag **);
+extern int bag_add(struct xfs_bag *, void *);
+extern int bag_remove(struct xfs_bag *, size_t);
+extern size_t bag_count(struct xfs_bag *);
+extern void *bag_item(struct xfs_bag *, size_t);
+
+#define foreach_bag_ptr(bag, idx, ptr) \
+	for ((idx) = 0, (ptr) = bag_item((bag), (idx)); \
+	     (idx) < bag_count(bag); \
+	     (idx)++, (ptr) = bag_item((bag), (idx)))
+
+#define foreach_bag_ptr_reverse(bag, idx, ptr) \
+	for ((idx) = bag_count(bag) - 1, (ptr) = bag_item((bag), (idx)); \
+	     (idx) >= 0 && (ptr) != NULL; \
+	     (idx)--, (ptr) = bag_item((bag), (idx)))
+
+#endif /* SLAB_H_ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
