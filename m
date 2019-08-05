Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54876 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbfHEAfF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Aug 2019 20:35:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750NtB7029663
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:35:04 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2u52wqv6r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:35:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750MxUN195535
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:35:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2u4ycttvv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:35:03 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x750Z2Je017121
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:35:02 GMT
Subject: [PATCH 03/18] xfs: create a big array data structure
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 04 Aug 2019 17:35:01 -0700
Message-ID: <156496530168.804304.3167782358783074423.stgit@magnolia>
In-Reply-To: <156496528310.804304.8105015456378794397.stgit@magnolia>
References: <156496528310.804304.8105015456378794397.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a simple 'big array' data structure for storage of fixed-size
metadata records that will be used to reconstruct a btree index.  For
repair operations, the most important operations are append, iterate,
and sort; while supported, get and put are not for frequent use.

For the initial implementation we will use linked-list containers,
though a subsequent patch will restructure the backend to avoid using
pinned kernel memory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile      |    1 
 fs/xfs/scrub/array.c |  283 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/array.h |   53 +++++++++
 3 files changed, 337 insertions(+)
 create mode 100644 fs/xfs/scrub/array.c
 create mode 100644 fs/xfs/scrub/array.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 06b68b6115bc..0ace13e94d98 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -160,6 +160,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
+				   array.o \
 				   bitmap.o \
 				   repair.o \
 				   )
diff --git a/fs/xfs/scrub/array.c b/fs/xfs/scrub/array.c
new file mode 100644
index 000000000000..4089e595df8b
--- /dev/null
+++ b/fs/xfs/scrub/array.c
@@ -0,0 +1,283 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "scrub/array.h"
+
+/*
+ * XFS Fixed-Size Big Memory Array
+ * ===============================
+ * The big memory array uses a list to store large numbers of fixed-size
+ * records in memory.  Access to the array is performed via indexed get and put
+ * methods, and an append method is provided for convenience.  Array elements
+ * can be set to all zeroes, which means that the entry is NULL and will be
+ * skipped during iteration.
+ */
+
+struct xa_item {
+	struct list_head	list;
+	/* array item comes after here */
+};
+
+#define XA_ITEM_SIZE(sz)	(sizeof(struct xa_item) + (sz))
+
+/* Initialize a big memory array. */
+struct xfbma *
+xfbma_init(
+	size_t		obj_size)
+{
+	struct xfbma	*array;
+	int		error;
+
+	error = -ENOMEM;
+	array = kmem_alloc(sizeof(struct xfbma) + obj_size,
+			KM_NOFS | KM_MAYFAIL);
+	if (!array)
+		return ERR_PTR(error);
+
+	array->obj_size = obj_size;
+	array->nr = 0;
+	INIT_LIST_HEAD(&array->list);
+	memset(&array->cache, 0, sizeof(array->cache));
+
+	return array;
+}
+
+void
+xfbma_destroy(
+	struct xfbma	*array)
+{
+	struct xa_item	*item, *n;
+
+	list_for_each_entry_safe(item, n, &array->list, list) {
+		list_del(&item->list);
+		kmem_free(item);
+	}
+	kmem_free(array);
+}
+
+/* Find something in the cache. */
+static struct xa_item *
+xfbma_cache_lookup(
+	struct xfbma	*array,
+	uint64_t	nr)
+{
+	uint64_t	i;
+
+	for (i = 0; i < XMA_CACHE_SIZE; i++)
+		if (array->cache[i].nr == nr && array->cache[i].item)
+			return array->cache[i].item;
+	return NULL;
+}
+
+/* Invalidate the lookup cache. */
+static void
+xfbma_cache_invalidate(
+	struct xfbma	*array)
+{
+	memset(array->cache, 0, sizeof(array->cache));
+}
+
+/* Put something in the cache. */
+static void
+xfbma_cache_store(
+	struct xfbma	*array,
+	uint64_t	nr,
+	struct xa_item	*item)
+{
+	memmove(array->cache + 1, array->cache,
+			sizeof(struct xma_cache) * (XMA_CACHE_SIZE - 1));
+	array->cache[0].item = item;
+	array->cache[0].nr = nr;
+}
+
+/* Find a particular array item. */
+static struct xa_item *
+xfbma_lookup(
+	struct xfbma	*array,
+	uint64_t	nr)
+{
+	struct xa_item	*item;
+	uint64_t	i;
+
+	if (nr >= array->nr) {
+		ASSERT(0);
+		return NULL;
+	}
+
+	item = xfbma_cache_lookup(array, nr);
+	if (item)
+		return item;
+
+	i = 0;
+	list_for_each_entry(item, &array->list, list) {
+		if (i == nr) {
+			xfbma_cache_store(array, nr, item);
+			return item;
+		}
+		i++;
+	}
+	return NULL;
+}
+
+/* Get an element from the array. */
+int
+xfbma_get(
+	struct xfbma	*array,
+	uint64_t	nr,
+	void		*ptr)
+{
+	struct xa_item	*item;
+
+	item = xfbma_lookup(array, nr);
+	if (!item)
+		return -ENODATA;
+	memcpy(ptr, item + 1, array->obj_size);
+	return 0;
+}
+
+/* Put an element in the array. */
+int
+xfbma_set(
+	struct xfbma	*array,
+	uint64_t	nr,
+	void		*ptr)
+{
+	struct xa_item	*item;
+
+	item = xfbma_lookup(array, nr);
+	if (!item)
+		return -ENODATA;
+	memcpy(item + 1, ptr, array->obj_size);
+	return 0;
+}
+
+/* Is this array element NULL? */
+bool
+xfbma_is_null(
+	struct xfbma	*array,
+	void		*ptr)
+{
+	return !memchr_inv(ptr, 0, array->obj_size);
+}
+
+/* Put an element anywhere in the array that isn't NULL. */
+int
+xfbma_insert_anywhere(
+	struct xfbma	*array,
+	void		*ptr)
+{
+	struct xa_item	*item;
+
+	/* Find a null slot to put it in. */
+	list_for_each_entry(item, &array->list, list) {
+		if (!xfbma_is_null(array, item + 1))
+			continue;
+		memcpy(item + 1, ptr, array->obj_size);
+		return 0;
+	}
+
+	/* No null slots, just dump it on the end. */
+	return xfbma_append(array, ptr);
+}
+
+/* NULL an element in the array. */
+int
+xfbma_nullify(
+	struct xfbma	*array,
+	uint64_t	nr)
+{
+	struct xa_item	*item;
+
+	item = xfbma_lookup(array, nr);
+	if (!item)
+		return -ENODATA;
+	memset(item + 1, 0, array->obj_size);
+	return 0;
+}
+
+/* Append an element to the array. */
+int
+xfbma_append(
+	struct xfbma	*array,
+	void		*ptr)
+{
+	struct xa_item	*item;
+
+	item = kmem_alloc(XA_ITEM_SIZE(array->obj_size), KM_NOFS | KM_MAYFAIL);
+	if (!item)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&item->list);
+	memcpy(item + 1, ptr, array->obj_size);
+	list_add_tail(&item->list, &array->list);
+	array->nr++;
+	return 0;
+}
+
+/*
+ * Iterate every element in this array, freeing each element as we go.
+ * Array elements will be shifted down.
+ */
+int
+xfbma_iter_del(
+	struct xfbma	*array,
+	xfbma_iter_fn	iter_fn,
+	void		*priv)
+{
+	struct xa_item	*item, *n;
+	int		error = 0;
+
+	list_for_each_entry_safe(item, n, &array->list, list) {
+		if (xfbma_is_null(array, item + 1))
+			goto next;
+		memcpy(array + 1, item + 1, array->obj_size);
+		error = iter_fn(array + 1, priv);
+		if (error)
+			break;
+next:
+		list_del(&item->list);
+		kmem_free(item);
+		array->nr--;
+	}
+
+	xfbma_cache_invalidate(array);
+	return error;
+}
+
+/* Return length of array. */
+uint64_t
+xfbma_length(
+	struct xfbma	*array)
+{
+	return array->nr;
+}
+
+static int
+xfbma_item_cmp(
+	void			*priv,
+	struct list_head	*a,
+	struct list_head	*b)
+{
+	int			(*cmp_fn)(void *a, void *b) = priv;
+	struct xa_item		*ai, *bi;
+
+	ai = container_of(a, struct xa_item, list);
+	bi = container_of(b, struct xa_item, list);
+
+	return cmp_fn(ai + 1, bi + 1);
+}
+
+/* Sort everything in this array. */
+int
+xfbma_sort(
+	struct xfbma	*array,
+	xfbma_cmp_fn	cmp_fn)
+{
+	list_sort(cmp_fn, &array->list, xfbma_item_cmp);
+	return 0;
+}
diff --git a/fs/xfs/scrub/array.h b/fs/xfs/scrub/array.h
new file mode 100644
index 000000000000..607e664147b3
--- /dev/null
+++ b/fs/xfs/scrub/array.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef __XFS_SCRUB_ARRAY_H__
+#define __XFS_SCRUB_ARRAY_H__
+
+struct xma_item;
+
+struct xma_cache {
+	uint64_t	nr;
+	struct xa_item	*item;
+};
+
+#define XMA_CACHE_SIZE	(8)
+
+struct xfbma {
+	struct list_head	list;
+	size_t			obj_size;
+	uint64_t		nr;
+	struct xma_cache	cache[XMA_CACHE_SIZE];
+};
+
+struct xfbma *xfbma_init(size_t obj_size);
+void xfbma_destroy(struct xfbma *array);
+int xfbma_get(struct xfbma *array, uint64_t nr, void *ptr);
+int xfbma_set(struct xfbma *array, uint64_t nr, void *ptr);
+int xfbma_insert_anywhere(struct xfbma *array, void *ptr);
+bool xfbma_is_null(struct xfbma *array, void *ptr);
+int xfbma_nullify(struct xfbma *array, uint64_t nr);
+int xfbma_append(struct xfbma *array, void *ptr);
+uint64_t xfbma_length(struct xfbma *array);
+
+/*
+ * Iterator functions return zero for success, a negative error code to abort
+ * with an error, or XFBMA_ITERATE_ABORT to stop iterating.
+ */
+#define XFBMA_ITERATE_ABORT	(1)
+typedef int (*xfbma_iter_fn)(const void *item, void *priv);
+
+int xfbma_iter_del(struct xfbma *array, xfbma_iter_fn iter_fn, void *priv);
+
+typedef int (*xfbma_cmp_fn)(const void *a, const void *b);
+
+int xfbma_sort(struct xfbma *array, xfbma_cmp_fn cmp_fn);
+
+#define foreach_xfbma_item(array, i, rec) \
+	for ((i) = 0; (i) < xfbma_length((array)); (i)++) \
+		if (xfbma_get((array), (i), &(rec)) == 0 && \
+		    !xfbma_is_null((array), &(rec)))
+
+#endif /* __XFS_SCRUB_ARRAY_H__ */
