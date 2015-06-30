Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 59EE729E03
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 22:26:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 491AD304043
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 20:26:51 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id sygCTwNfPz0fdr05 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 20:26:49 -0700 (PDT)
Subject: [PATCH 10/15] xfs_repair: create a slab API for allocating arrays
	in large chunks
From: "Darrick J. Wong" <djwong@birch.djwong.org>
Date: Mon, 29 Jun 2015 20:26:43 -0700
Message-ID: <20150630032643.572.67268.stgit@birch.djwong.org>
In-Reply-To: <20150630032538.572.20293.stgit@birch.djwong.org>
References: <20150630032538.572.20293.stgit@birch.djwong.org>
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

Create a slab-based allocator and a bag-of-pointers data structure to
facilitate rapid linear scans of reverse-mapping data for later
reconstruction of the reflink and rmap btrees.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/Makefile |    4 
 repair/slab.c   |  457 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/slab.h   |   64 ++++++++
 3 files changed, 523 insertions(+), 2 deletions(-)
 create mode 100644 repair/slab.c
 create mode 100644 repair/slab.h


diff --git a/repair/Makefile b/repair/Makefile
index 6d84ade..82cba8e 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -11,14 +11,14 @@ LTCOMMAND = xfs_repair
 
 HFILES = agheader.h attr_repair.h avl.h avl64.h bmap.h btree.h \
 	dinode.h dir2.h err_protos.h globals.h incore.h protos.h rt.h \
-	progress.h scan.h versions.h prefetch.h threads.h
+	progress.h scan.h versions.h prefetch.h threads.h slab.h
 
 CFILES = agheader.c attr_repair.c avl.c avl64.c bmap.c btree.c \
 	dino_chunks.c dinode.c dir2.c globals.c incore.c \
 	incore_bmc.c init.c incore_ext.c incore_ino.c phase1.c \
 	phase2.c phase3.c phase4.c phase5.c phase6.c phase7.c \
 	progress.c prefetch.c rt.c sb.c scan.c threads.c \
-	versions.c xfs_repair.c
+	versions.c xfs_repair.c slab.c
 
 LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
diff --git a/repair/slab.c b/repair/slab.c
new file mode 100644
index 0000000..469db73
--- /dev/null
+++ b/repair/slab.c
@@ -0,0 +1,457 @@
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
+ * Slabs -- each slab_hdr holds an array of items; when a slab_hdr fills up, we
+ * allocate a new one and add to that one.  The slab object coordinates the
+ * slab_hdrs.
+ */
+
+/* Each slab holds at least 4096 items */
+#define MIN_SLAB_NR		4096
+/* and cannot be larger than 128M */
+#define MAX_SLAB_SIZE		(128 * 1048576)
+typedef struct xfs_slab_hdr {
+	size_t			sh_nr;
+	size_t			sh_inuse;	/* items in use */
+	struct xfs_slab_hdr	*sh_next;	/* next slab hdr */
+						/* objects follow */
+} xfs_slab_hdr_t;
+
+typedef struct xfs_slab {
+	size_t			s_item_sz;	/* item size */
+	size_t			s_nr_slabs;	/* # of slabs */
+	size_t			s_nr_items;	/* # of items */
+	xfs_slab_hdr_t		*s_first;	/* first slab header */
+	xfs_slab_hdr_t		*s_last;	/* last sh_next pointer */
+} xfs_slab_t;
+
+/*
+ * Slab cursors -- each slab_hdr_cursor tracks a slab_hdr; the slab_cursor
+ * tracks the slab_hdr_cursors.  If a compare_fn is specified, the cursor
+ * returns objects in increasing order (if you've previously sorted the
+ * slabs with qsort_slab()).  If compare_fn == NULL, it returns slab items
+ * in order.
+ */
+typedef struct xfs_slab_hdr_cursor {
+	xfs_slab_hdr_t		*hdr;		/* a slab header */
+	size_t			loc;		/* where we are in the slab */
+} xfs_slab_hdr_cursor_t;
+
+typedef struct xfs_slab_cursor {
+	size_t			nr;		/* # of per-slab cursors */
+	xfs_slab_t		*slab;		/* pointer to the slab */
+	xfs_slab_hdr_cursor_t	*last_hcur;	/* last header we took from */
+	int (*compare_fn)(const void *, const void *);	/* compare function */
+	xfs_slab_hdr_cursor_t	hcur[0];	/* per-slab curosr */
+} xfs_slab_cursor_t;
+
+/*
+ * Bags -- each bag is an array of pointers items; when a bag fills up, we
+ * resize it.
+ */
+#define MIN_BAG_SIZE	4096
+typedef struct xfs_bag {
+	size_t			bg_nr;		/* number of pointers */
+	size_t			bg_inuse;	/* number of slots in use */
+	void			**bg_ptrs;	/* pointers */
+} xfs_bag_t;
+#define BAG_SIZE(nr)	(sizeof(xfs_bag_t) + ((nr) * sizeof(void *)))
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
+	xfs_slab_t	**slab,
+	size_t		item_size)
+{
+	xfs_slab_t	*ptr;
+
+	ptr = calloc(1, sizeof(xfs_slab_t));
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
+	xfs_slab_t	**slab)
+{
+	xfs_slab_t	*ptr;
+	xfs_slab_hdr_t	*hdr;
+	xfs_slab_hdr_t	*nhdr;
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
+	xfs_slab_t		*slab,
+	xfs_slab_hdr_t		*hdr,
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
+	xfs_slab_t		*slab,
+	void			*item)
+{
+	xfs_slab_hdr_t		*hdr;
+	void			*p;
+
+	hdr = slab->s_last;
+	if (!hdr || hdr->sh_inuse == hdr->sh_nr) {
+		size_t n;
+
+		n = (hdr ? hdr->sh_nr * 2 : MIN_SLAB_NR);
+		if (n * slab->s_item_sz > MAX_SLAB_SIZE)
+			n = MAX_SLAB_SIZE / slab->s_item_sz;
+		hdr = malloc(sizeof(xfs_slab_hdr_t) + (n * slab->s_item_sz));
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
+	xfs_slab_t		*slab,
+	int (*compare_fn)(const void *, const void *))
+{
+	xfs_slab_hdr_t		*hdr;
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
+	xfs_slab_t		*slab,
+	int (*compare_fn)(const void *, const void *),
+	xfs_slab_cursor_t	**cur)
+{
+	xfs_slab_cursor_t	*c;
+	xfs_slab_hdr_cursor_t	*hcur;
+	xfs_slab_hdr_t		*hdr;
+
+	c = malloc(sizeof(xfs_slab_cursor_t) +
+		   (sizeof(xfs_slab_hdr_cursor_t) * slab->s_nr_slabs));
+	if (!c)
+		return -ENOMEM;
+	c->nr = slab->s_nr_slabs;
+	c->slab = slab;
+	c->compare_fn = compare_fn;
+	c->last_hcur = NULL;
+	hcur = (xfs_slab_hdr_cursor_t *)(c + 1);
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
+	xfs_slab_cursor_t	**cur)
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
+	xfs_slab_cursor_t	*cur)
+{
+	xfs_slab_hdr_cursor_t	*hcur;
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
+	xfs_slab_cursor_t	*cur)
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
+	xfs_slab_cursor_t	*cur)
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
+	xfs_slab_t *slab)
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
+	xfs_bag_t	**bag)
+{
+	xfs_bag_t	*ptr;
+
+	ptr = calloc(1, sizeof(xfs_bag_t));
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
+	xfs_bag_t	**bag)
+{
+	xfs_bag_t	*ptr;
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
+	xfs_bag_t	*bag,
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
+	xfs_bag_t	*bag,
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
+	xfs_bag_t	*bag)
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
+	xfs_bag_t	*bag,
+	size_t		nr)
+{
+	if (nr >= bag->bg_inuse)
+		return NULL;
+	return bag->bg_ptrs[nr];
+}
diff --git a/repair/slab.h b/repair/slab.h
new file mode 100644
index 0000000..4e56fc5
--- /dev/null
+++ b/repair/slab.h
@@ -0,0 +1,64 @@
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
+typedef struct xfs_slab xfs_slab_t;
+
+struct xfs_slab_cursor;
+typedef struct xfs_slab_cursor xfs_slab_cursor_t;
+
+extern int init_slab(xfs_slab_t **slab, size_t item_size);
+extern void free_slab(xfs_slab_t **slab);
+
+extern int slab_add(xfs_slab_t *slab, void *item);
+extern void qsort_slab(xfs_slab_t *slab,
+	int (*compare_fn)(const void *, const void *));
+extern size_t slab_count(xfs_slab_t *slab);
+
+extern int init_slab_cursor(xfs_slab_t *slab,
+	int (*compare_fn)(const void *, const void *),
+	xfs_slab_cursor_t **cur);
+extern void free_slab_cursor(xfs_slab_cursor_t **cur);
+
+extern void *peek_slab_cursor(xfs_slab_cursor_t *cur);
+extern void advance_slab_cursor(xfs_slab_cursor_t *cur);
+extern void * pop_slab_cursor(xfs_slab_cursor_t *cur);
+
+struct xfs_bag;
+typedef struct xfs_bag xfs_bag_t;
+
+extern int init_bag(xfs_bag_t **bag);
+extern void free_bag(xfs_bag_t **bag);
+extern int bag_add(xfs_bag_t *bag, void *ptr);
+extern int bag_remove(xfs_bag_t *bag, size_t nr);
+extern size_t bag_count(xfs_bag_t *bag);
+extern void *bag_item(xfs_bag_t *bag, size_t nr);
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
