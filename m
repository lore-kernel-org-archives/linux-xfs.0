Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49628 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfHEAgx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Aug 2019 20:36:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750Obvu023953
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:36:48 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u51ptmbdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:36:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750N0fs195597
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:36:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2u51kktu5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:36:47 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x750al27013208
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:36:47 GMT
Subject: [PATCH 18/18] xfs: convert big array and blob array to use memfd
 backend
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 04 Aug 2019 17:36:46 -0700
Message-ID: <156496540609.804304.199956930600327951.stgit@magnolia>
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

There are several problems with the initial implementations of the big
array and the blob array data structures.  First, using linked lists
imposes a two-pointer overhead on every record stored.  For blobs this
isn't serious, but for fixed-size records this increases memory
requirements by 40-60%.  Second, we're using kernel memory to store the
intermediate records.  Kernel memory cannot be paged out, which means we
run the risk of OOMing the machine when we run out of physical memory.

Therefore, replace the linked lists in both structures with memfd files.
Random access becomes much easier, memory overhead drops to a negligible
amount, and because memfd pages can be swapped, we have considerably
more flexibility for memory use.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile      |    1 
 fs/xfs/scrub/array.c |  607 +++++++++++++++++++++++++++++++++++++++-----------
 fs/xfs/scrub/array.h |   16 -
 fs/xfs/scrub/blob.c  |   94 +++++---
 fs/xfs/scrub/blob.h  |    5 
 fs/xfs/scrub/trace.h |   23 ++
 fs/xfs/scrub/xfile.c |  121 ++++++++++
 fs/xfs/scrub/xfile.h |   21 ++
 8 files changed, 708 insertions(+), 180 deletions(-)
 create mode 100644 fs/xfs/scrub/xfile.c
 create mode 100644 fs/xfs/scrub/xfile.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index a2461621ac26..4a4f8121499b 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -171,6 +171,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   refcount_repair.o \
 				   repair.o \
 				   symlink_repair.o \
+				   xfile.o \
 				   )
 xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota_repair.o
 endif
diff --git a/fs/xfs/scrub/array.c b/fs/xfs/scrub/array.c
index 4089e595df8b..1b3635a115b2 100644
--- a/fs/xfs/scrub/array.c
+++ b/fs/xfs/scrub/array.c
@@ -6,24 +6,41 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
 #include "scrub/array.h"
+#include "scrub/scrub.h"
+#include "scrub/trace.h"
+#include "scrub/xfile.h"
 
 /*
  * XFS Fixed-Size Big Memory Array
  * ===============================
- * The big memory array uses a list to store large numbers of fixed-size
- * records in memory.  Access to the array is performed via indexed get and put
- * methods, and an append method is provided for convenience.  Array elements
- * can be set to all zeroes, which means that the entry is NULL and will be
- * skipped during iteration.
+ * The file-backed memory array uses a memfd "file" to store large numbers of
+ * fixed-size records in memory that can be paged out.  This puts less stress
+ * on the memory reclaim algorithms because memfd file pages are not pinned and
+ * can be paged out; however, array access is less direct than would be in a
+ * regular memory array.  Access to the array is performed via indexed get and
+ * put methods, and an append method is provided for convenience.  Array
+ * elements can be set to all zeroes, which means that the entry is NULL and
+ * will be skipped during iteration.
  */
 
-struct xa_item {
-	struct list_head	list;
-	/* array item comes after here */
-};
+#define XFBMA_MAX_TEMP	(2)
 
-#define XA_ITEM_SIZE(sz)	(sizeof(struct xa_item) + (sz))
+/*
+ * Pointer to temp space.  Because we can't access the memfd data directly, we
+ * allocate a small amount of memory on the end of the xfbma to buffer array
+ * items when we need space to store values temporarily.
+ */
+static inline void *
+xfbma_temp(
+	struct xfbma	*array,
+	unsigned int	nr)
+{
+	ASSERT(nr < XFBMA_MAX_TEMP);
+
+	return ((char *)(array + 1)) + (nr * array->obj_size);
+}
 
 /* Initialize a big memory array. */
 struct xfbma *
@@ -31,97 +48,47 @@ xfbma_init(
 	size_t		obj_size)
 {
 	struct xfbma	*array;
+	struct file	*filp;
 	int		error;
 
+	filp = xfile_create("big array");
+	if (!filp)
+		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(filp))
+		return ERR_CAST(filp);
+
 	error = -ENOMEM;
-	array = kmem_alloc(sizeof(struct xfbma) + obj_size,
+	array = kmem_alloc(sizeof(struct xfbma) + (XFBMA_MAX_TEMP * obj_size),
 			KM_NOFS | KM_MAYFAIL);
 	if (!array)
-		return ERR_PTR(error);
+		goto out_filp;
 
+	array->filp = filp;
 	array->obj_size = obj_size;
 	array->nr = 0;
-	INIT_LIST_HEAD(&array->list);
-	memset(&array->cache, 0, sizeof(array->cache));
-
 	return array;
+out_filp:
+	fput(filp);
+	return ERR_PTR(error);
 }
 
 void
 xfbma_destroy(
 	struct xfbma	*array)
 {
-	struct xa_item	*item, *n;
-
-	list_for_each_entry_safe(item, n, &array->list, list) {
-		list_del(&item->list);
-		kmem_free(item);
-	}
+	xfile_destroy(array->filp);
 	kmem_free(array);
 }
 
-/* Find something in the cache. */
-static struct xa_item *
-xfbma_cache_lookup(
-	struct xfbma	*array,
-	uint64_t	nr)
-{
-	uint64_t	i;
-
-	for (i = 0; i < XMA_CACHE_SIZE; i++)
-		if (array->cache[i].nr == nr && array->cache[i].item)
-			return array->cache[i].item;
-	return NULL;
-}
-
-/* Invalidate the lookup cache. */
-static void
-xfbma_cache_invalidate(
-	struct xfbma	*array)
-{
-	memset(array->cache, 0, sizeof(array->cache));
-}
-
-/* Put something in the cache. */
-static void
-xfbma_cache_store(
-	struct xfbma	*array,
-	uint64_t	nr,
-	struct xa_item	*item)
-{
-	memmove(array->cache + 1, array->cache,
-			sizeof(struct xma_cache) * (XMA_CACHE_SIZE - 1));
-	array->cache[0].item = item;
-	array->cache[0].nr = nr;
-}
-
-/* Find a particular array item. */
-static struct xa_item *
-xfbma_lookup(
+/* Compute offset of array element. */
+static inline loff_t
+xfbma_offset(
 	struct xfbma	*array,
 	uint64_t	nr)
 {
-	struct xa_item	*item;
-	uint64_t	i;
-
-	if (nr >= array->nr) {
-		ASSERT(0);
-		return NULL;
-	}
-
-	item = xfbma_cache_lookup(array, nr);
-	if (item)
-		return item;
-
-	i = 0;
-	list_for_each_entry(item, &array->list, list) {
-		if (i == nr) {
-			xfbma_cache_store(array, nr, item);
-			return item;
-		}
-		i++;
-	}
-	return NULL;
+	if (nr >= array->nr)
+		return -1;
+	return nr * array->obj_size;
 }
 
 /* Get an element from the array. */
@@ -131,13 +98,14 @@ xfbma_get(
 	uint64_t	nr,
 	void		*ptr)
 {
-	struct xa_item	*item;
+	loff_t		pos = xfbma_offset(array, nr);
 
-	item = xfbma_lookup(array, nr);
-	if (!item)
+	if (pos < 0) {
+		ASSERT(0);
 		return -ENODATA;
-	memcpy(ptr, item + 1, array->obj_size);
-	return 0;
+	}
+
+	return xfile_io(array->filp, XFILE_IO_READ, &pos, ptr, array->obj_size);
 }
 
 /* Put an element in the array. */
@@ -147,13 +115,15 @@ xfbma_set(
 	uint64_t	nr,
 	void		*ptr)
 {
-	struct xa_item	*item;
+	loff_t		pos = xfbma_offset(array, nr);
 
-	item = xfbma_lookup(array, nr);
-	if (!item)
+	if (pos < 0) {
+		ASSERT(0);
 		return -ENODATA;
-	memcpy(item + 1, ptr, array->obj_size);
-	return 0;
+	}
+
+	return xfile_io(array->filp, XFILE_IO_WRITE, &pos, ptr,
+			array->obj_size);
 }
 
 /* Is this array element NULL? */
@@ -171,14 +141,16 @@ xfbma_insert_anywhere(
 	struct xfbma	*array,
 	void		*ptr)
 {
-	struct xa_item	*item;
+	void		*temp = xfbma_temp(array, 0);
+	uint64_t	i;
+	int		error;
 
 	/* Find a null slot to put it in. */
-	list_for_each_entry(item, &array->list, list) {
-		if (!xfbma_is_null(array, item + 1))
+	for (i = 0; i < array->nr; i++) {
+		error = xfbma_get(array, i, temp);
+		if (error || !xfbma_is_null(array, temp))
 			continue;
-		memcpy(item + 1, ptr, array->obj_size);
-		return 0;
+		return xfbma_set(array, i, ptr);
 	}
 
 	/* No null slots, just dump it on the end. */
@@ -191,13 +163,17 @@ xfbma_nullify(
 	struct xfbma	*array,
 	uint64_t	nr)
 {
-	struct xa_item	*item;
+	void		*temp = xfbma_temp(array, 0);
+	loff_t		pos = xfbma_offset(array, nr);
 
-	item = xfbma_lookup(array, nr);
-	if (!item)
+	if (pos < 0) {
+		ASSERT(0);
 		return -ENODATA;
-	memset(item + 1, 0, array->obj_size);
-	return 0;
+	}
+
+	memset(temp, 0, array->obj_size);
+	return xfile_io(array->filp, XFILE_IO_WRITE, &pos, temp,
+			array->obj_size);
 }
 
 /* Append an element to the array. */
@@ -206,22 +182,25 @@ xfbma_append(
 	struct xfbma	*array,
 	void		*ptr)
 {
-	struct xa_item	*item;
+	loff_t		pos = array->obj_size * array->nr;
+	int		error;
 
-	item = kmem_alloc(XA_ITEM_SIZE(array->obj_size), KM_NOFS | KM_MAYFAIL);
-	if (!item)
-		return -ENOMEM;
+	if (pos < 0) {
+		ASSERT(0);
+		return -ENODATA;
+	}
 
-	INIT_LIST_HEAD(&item->list);
-	memcpy(item + 1, ptr, array->obj_size);
-	list_add_tail(&item->list, &array->list);
+	error = xfile_io(array->filp, XFILE_IO_WRITE, &pos, ptr,
+			array->obj_size);
+	if (error)
+		return error;
 	array->nr++;
 	return 0;
 }
 
 /*
  * Iterate every element in this array, freeing each element as we go.
- * Array elements will be shifted down.
+ * Array elements will be nulled out.
  */
 int
 xfbma_iter_del(
@@ -229,23 +208,35 @@ xfbma_iter_del(
 	xfbma_iter_fn	iter_fn,
 	void		*priv)
 {
-	struct xa_item	*item, *n;
+	void		*temp = xfbma_temp(array, 0);
+	pgoff_t		oldpagenr = 0;
+	uint64_t	max_bytes;
+	uint64_t	i;
+	loff_t		pos;
 	int		error = 0;
 
-	list_for_each_entry_safe(item, n, &array->list, list) {
-		if (xfbma_is_null(array, item + 1))
+	max_bytes = array->nr * array->obj_size;
+	for (pos = 0, i = 0; pos < max_bytes; i++) {
+		pgoff_t	pagenr;
+
+		error = xfile_io(array->filp, XFILE_IO_READ, &pos, temp,
+				array->obj_size);
+		if (error)
+			break;
+		if (xfbma_is_null(array, temp))
 			goto next;
-		memcpy(array + 1, item + 1, array->obj_size);
-		error = iter_fn(array + 1, priv);
+		error = iter_fn(temp, priv);
 		if (error)
 			break;
 next:
-		list_del(&item->list);
-		kmem_free(item);
-		array->nr--;
+		/* Release the previous page if possible. */
+		pagenr = pos >> PAGE_SHIFT;
+		if (pagenr != oldpagenr)
+			xfile_discard(array->filp, oldpagenr << PAGE_SHIFT,
+					pos - 1);
+		oldpagenr = pagenr;
 	}
 
-	xfbma_cache_invalidate(array);
 	return error;
 }
 
@@ -257,27 +248,383 @@ xfbma_length(
 	return array->nr;
 }
 
-static int
-xfbma_item_cmp(
-	void			*priv,
-	struct list_head	*a,
-	struct list_head	*b)
+/*
+ * Select the median value from a[lo], a[mid], and a[hi].  Put the median in
+ * a[lo], the lowest in a[lo], and the highest in a[hi].  Using the median of
+ * the three reduces the chances that we pick the worst case pivot value, since
+ * it's likely that our array values are nearly sorted.
+ */
+STATIC int
+xfbma_qsort_pivot(
+	struct xfbma	*array,
+	xfbma_cmp_fn	cmp_fn,
+	uint64_t	lo,
+	uint64_t	mid,
+	uint64_t	hi)
 {
-	int			(*cmp_fn)(void *a, void *b) = priv;
-	struct xa_item		*ai, *bi;
+	void		*a = xfbma_temp(array, 0);
+	void		*b = xfbma_temp(array, 1);
+	int		error;
 
-	ai = container_of(a, struct xa_item, list);
-	bi = container_of(b, struct xa_item, list);
+	/* if a[mid] < a[lo], swap a[mid] and a[lo]. */
+	error = xfbma_get(array, mid, a);
+	if (error)
+		return error;
+	error = xfbma_get(array, lo, b);
+	if (error)
+		return error;
+	if (cmp_fn(a, b) < 0) {
+		error = xfbma_set(array, lo, a);
+		if (error)
+			return error;
+		error = xfbma_set(array, mid, b);
+		if (error)
+			return error;
+	}
 
-	return cmp_fn(ai + 1, bi + 1);
+	/* if a[hi] < a[mid], swap a[mid] and a[hi]. */
+	error = xfbma_get(array, hi, a);
+	if (error)
+		return error;
+	error = xfbma_get(array, mid, b);
+	if (error)
+		return error;
+	if (cmp_fn(a, b) < 0) {
+		error = xfbma_set(array, mid, a);
+		if (error)
+			return error;
+		error = xfbma_set(array, hi, b);
+		if (error)
+			return error;
+	} else {
+		goto move_front;
+	}
+
+	/* if a[mid] < a[lo], swap a[mid] and a[lo]. */
+	error = xfbma_get(array, mid, a);
+	if (error)
+		return error;
+	error = xfbma_get(array, lo, b);
+	if (error)
+		return error;
+	if (cmp_fn(a, b) < 0) {
+		error = xfbma_set(array, lo, a);
+		if (error)
+			return error;
+		error = xfbma_set(array, mid, b);
+		if (error)
+			return error;
+	}
+move_front:
+	/* move our selected pivot to a[lo] */
+	error = xfbma_get(array, lo, b);
+	if (error)
+		return error;
+	error = xfbma_get(array, mid, a);
+	if (error)
+		return error;
+	error = xfbma_set(array, mid, b);
+	if (error)
+		return error;
+	return xfbma_set(array, lo, a);
+}
+
+/*
+ * Perform an insertion sort on a subset of the array.
+ * Though insertion sort is an O(n^2) algorithm, for small set sizes it's
+ * faster than quicksort's stack machine, so we let it take over for that.
+ */
+STATIC int
+xfbma_isort(
+	struct xfbma	*array,
+	xfbma_cmp_fn	cmp_fn,
+	uint64_t	start,
+	uint64_t	end)
+{
+	void		*a = xfbma_temp(array, 0);
+	void		*b = xfbma_temp(array, 1);
+	uint64_t	tmp;
+	uint64_t	i;
+	uint64_t	run;
+	int		error;
+
+	/*
+	 * Move the smallest element in a[start..end] to a[start].  This
+	 * simplifies the loop control logic below.
+	 */
+	tmp = start;
+	error = xfbma_get(array, tmp, b);
+	if (error)
+		return error;
+	for (run = start + 1; run <= end; run++) {
+		/* if a[run] < a[tmp], tmp = run */
+		error = xfbma_get(array, run, a);
+		if (error)
+			return error;
+		if (cmp_fn(a, b) < 0) {
+			tmp = run;
+			memcpy(b, a, array->obj_size);
+		}
+	}
+
+	/*
+	 * The smallest element is a[tmp]; swap with a[start] if tmp != start.
+	 * Recall that a[tmp] is already in *b.
+	 */
+	if (tmp != start) {
+		error = xfbma_get(array, start, a);
+		if (error)
+			return error;
+		error = xfbma_set(array, tmp, a);
+		if (error)
+			return error;
+		error = xfbma_set(array, start, b);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Perform an insertion sort on a[start+1..end].  We already made sure
+	 * that the smallest value in the original range is now in a[start],
+	 * so the inner loop should never underflow.
+	 *
+	 * For each a[start+2..end], make sure it's in the correct position
+	 * with respect to the elements that came before it.
+	 */
+	for (run = start + 2; run <= end; run++) {
+		error = xfbma_get(array, run, a);
+		if (error)
+			return error;
+
+		/*
+		 * Find the correct place for a[run] by walking leftwards
+		 * towards the start of the range until a[tmp] is no longer
+		 * greater than a[run].
+		 */
+		tmp = run - 1;
+		error = xfbma_get(array, tmp, b);
+		if (error)
+			return error;
+		while (cmp_fn(a, b) < 0) {
+			tmp--;
+			error = xfbma_get(array, tmp, b);
+			if (error)
+				return error;
+		}
+		tmp++;
+
+		/*
+		 * If tmp != run, then a[tmp..run-1] are all less than a[run],
+		 * so right barrel roll a[tmp..run] to get this range in
+		 * sorted order.
+		 */
+		if (tmp == run)
+			continue;
+
+		for (i = run; i >= tmp; i--) {
+			error = xfbma_get(array, i - 1, b);
+			if (error)
+				return error;
+			error = xfbma_set(array, i, b);
+			if (error)
+				return error;
+		}
+		error = xfbma_set(array, tmp, a);
+		if (error)
+			return error;
+	}
+
+	return 0;
 }
 
-/* Sort everything in this array. */
+/*
+ * Sort the array elements via quicksort.  This implementation incorporates
+ * four optimizations discussed in Sedgewick:
+ *
+ * 1. Use an explicit stack of array indicies to store the next array
+ *    partition to sort.  This helps us to avoid recursion in the call stack,
+ *    which is particularly expensive in the kernel.
+ *
+ * 2. Choose the pivot element using a median-of-three decision tree.  This
+ *    reduces the probability of selecting a bad pivot value which causes
+ *    worst case behavior (i.e. partition sizes of 1).  Chance are fairly good
+ *    that the list is nearly sorted, so this is important.
+ *
+ * 3. The smaller of the two sub-partitions is pushed onto the stack to start
+ *    the next level of recursion, and the larger sub-partition replaces the
+ *    current stack frame.  This guarantees that we won't need more than
+ *    log2(nr) stack space.
+ *
+ * 4. Use insertion sort for small sets since since insertion sort is faster
+ *    for small, mostly sorted array segments.  In the author's experience,
+ *    substituting insertion sort for arrays smaller than 4 elements yields
+ *    a ~10% reduction in runtime.
+ */
+
+/*
+ * Due to the use of signed indices, we can only support up to 2^63 records.
+ * Files can only grow to 2^63 bytes, so this is not much of a limitation.
+ */
+#define QSORT_MAX_RECS		(1ULL << 63)
+
+/*
+ * For array subsets smaller than 4 elements, it's slightly faster to use
+ * insertion sort than quicksort's stack machine.
+ */
+#define ISORT_THRESHOLD		(4)
 int
 xfbma_sort(
 	struct xfbma	*array,
 	xfbma_cmp_fn	cmp_fn)
 {
-	list_sort(cmp_fn, &array->list, xfbma_item_cmp);
-	return 0;
+	int64_t		*stack;
+	int64_t		*beg;
+	int64_t		*end;
+	void		*pivot = xfbma_temp(array, 0);
+	void		*temp = xfbma_temp(array, 1);
+	int64_t		lo, mid, hi;
+	const int	max_stack_depth = ilog2(array->nr) + 1;
+	int		stack_depth = 0;
+	int		max_stack_used = 0;
+	int		error = 0;
+
+	if (array->nr == 0)
+		return 0;
+	if (array->nr >= QSORT_MAX_RECS)
+		return -E2BIG;
+	if (array->nr <= ISORT_THRESHOLD)
+		return xfbma_isort(array, cmp_fn, 0, array->nr - 1);
+
+	/* Allocate our pointer stacks for sorting. */
+	stack = kmem_alloc(sizeof(int64_t) * 2 * max_stack_depth,
+			KM_NOFS | KM_MAYFAIL);
+	if (!stack)
+		return -ENOMEM;
+	beg = stack;
+	end = &stack[max_stack_depth];
+
+	beg[0] = 0;
+	end[0] = array->nr;
+	while (stack_depth >= 0) {
+		lo = beg[stack_depth];
+		hi = end[stack_depth] - 1;
+
+		/* Nothing left in this partition to sort; pop stack. */
+		if (lo >= hi) {
+			stack_depth--;
+			continue;
+		}
+
+		/* Small enough for insertion sort? */
+		if (hi - lo <= ISORT_THRESHOLD) {
+			error = xfbma_isort(array, cmp_fn, lo, hi);
+			if (error)
+				goto out_free;
+			stack_depth--;
+			continue;
+		}
+
+		/* Pick a pivot, move it to a[lo] and stash it. */
+		mid = lo + ((hi - lo) / 2);
+		error = xfbma_qsort_pivot(array, cmp_fn, lo, mid, hi);
+		if (error)
+			goto out_free;
+
+		error = xfbma_get(array, lo, pivot);
+		if (error)
+			goto out_free;
+
+		/*
+		 * Rearrange a[lo..hi] such that everything smaller than the
+		 * pivot is on the left side of the range and everything larger
+		 * than the pivot is on the right side of the range.
+		 */
+		while (lo < hi) {
+			/*
+			 * Decrement hi until it finds an a[hi] less than the
+			 * pivot value.
+			 */
+			error = xfbma_get(array, hi, temp);
+			if (error)
+				goto out_free;
+			while (cmp_fn(temp, pivot) >= 0 && lo < hi) {
+				hi--;
+				error = xfbma_get(array, hi, temp);
+				if (error)
+					goto out_free;
+			}
+
+			/* Copy that item (a[hi]) to a[lo]. */
+			if (lo < hi) {
+				error = xfbma_set(array, lo++, temp);
+				if (error)
+					goto out_free;
+			}
+
+			/*
+			 * Increment lo until it finds an a[lo] greater than
+			 * the pivot value.
+			 */
+			error = xfbma_get(array, lo, temp);
+			if (error)
+				goto out_free;
+			while (cmp_fn(temp, pivot) <= 0 && lo < hi) {
+				lo++;
+				error = xfbma_get(array, lo, temp);
+				if (error)
+					goto out_free;
+			}
+
+			/* Copy that item (a[lo]) to a[hi]. */
+			if (lo < hi) {
+				error = xfbma_set(array, hi--, temp);
+				if (error)
+					goto out_free;
+			}
+		}
+
+		/*
+		 * Put our pivot value in the correct place at a[lo].  All
+		 * values between a[beg[i]] and a[lo - 1] should be less than
+		 * the pivot; and all values between a[lo + 1] and a[end[i]-1]
+		 * should be greater than the pivot.
+		 */
+		error = xfbma_set(array, lo, pivot);
+		if (error)
+			goto out_free;
+
+		/*
+		 * Set up the pointers for the next iteration.  We push onto
+		 * the stack all of the unsorted values between a[lo + 1] and
+		 * a[end[i]], and we tweak the current stack frame to point to
+		 * the unsorted values between a[beg[i]] and a[lo] so that
+		 * those values will be sorted when we pop the stack.
+		 */
+		beg[stack_depth + 1] = lo + 1;
+		end[stack_depth + 1] = end[stack_depth];
+		end[stack_depth++] = lo;
+
+		/* Check our stack usage. */
+		max_stack_used = max(max_stack_used, stack_depth);
+		if (stack_depth >= max_stack_depth) {
+			ASSERT(0);
+			return -EFSCORRUPTED;
+		}
+
+		/*
+		 * Always start with the smaller of the two partitions to keep
+		 * the amount of recursion in check.
+		 */
+		if (end[stack_depth] - beg[stack_depth] >
+		    end[stack_depth - 1] - beg[stack_depth - 1]) {
+			swap(beg[stack_depth], beg[stack_depth - 1]);
+			swap(end[stack_depth], end[stack_depth - 1]);
+		}
+	}
+
+out_free:
+	kfree(stack);
+	trace_xfbma_sort_stats(array->nr, max_stack_depth, max_stack_used,
+			error);
+	return error;
 }
diff --git a/fs/xfs/scrub/array.h b/fs/xfs/scrub/array.h
index 607e664147b3..e002edb657f4 100644
--- a/fs/xfs/scrub/array.h
+++ b/fs/xfs/scrub/array.h
@@ -6,20 +6,10 @@
 #ifndef __XFS_SCRUB_ARRAY_H__
 #define __XFS_SCRUB_ARRAY_H__
 
-struct xma_item;
-
-struct xma_cache {
-	uint64_t	nr;
-	struct xa_item	*item;
-};
-
-#define XMA_CACHE_SIZE	(8)
-
 struct xfbma {
-	struct list_head	list;
-	size_t			obj_size;
-	uint64_t		nr;
-	struct xma_cache	cache[XMA_CACHE_SIZE];
+	struct file	*filp;
+	size_t		obj_size;
+	uint64_t	nr;
 };
 
 struct xfbma *xfbma_init(size_t obj_size);
diff --git a/fs/xfs/scrub/blob.c b/fs/xfs/scrub/blob.c
index 4928f0985d49..94912fcb1fd1 100644
--- a/fs/xfs/scrub/blob.c
+++ b/fs/xfs/scrub/blob.c
@@ -8,38 +8,48 @@
 #include "xfs_shared.h"
 #include "scrub/array.h"
 #include "scrub/blob.h"
+#include "scrub/xfile.h"
 
 /*
  * XFS Blob Storage
  * ================
- * Stores and retrieves blobs using a list.  Objects are appended to
- * the list and the pointer is returned as a magic cookie for retrieval.
+ * Stores and retrieves blobs using a memfd object.  Objects are appended to
+ * the file and the offset is returned as a magic cookie for retrieval.
  */
 
 #define XB_KEY_MAGIC	0xABAADDAD
 struct xb_key {
-	struct list_head	list;
 	uint32_t		magic;
 	uint32_t		size;
+	loff_t			offset;
 	/* blob comes after here */
 } __packed;
 
-#define XB_KEY_SIZE(sz)	(sizeof(struct xb_key) + (sz))
-
 /* Initialize a blob storage object. */
 struct xblob *
 xblob_init(void)
 {
 	struct xblob	*blob;
+	struct file	*filp;
 	int		error;
 
+	filp = xfile_create("blob storage");
+	if (!filp)
+		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(filp))
+		return ERR_CAST(filp);
+
 	error = -ENOMEM;
 	blob = kmem_alloc(sizeof(struct xblob), KM_NOFS | KM_MAYFAIL);
 	if (!blob)
-		return ERR_PTR(error);
+		goto out_filp;
 
-	INIT_LIST_HEAD(&blob->list);
+	blob->filp = filp;
+	blob->last_offset = PAGE_SIZE;
 	return blob;
+out_filp:
+	fput(filp);
+	return ERR_PTR(error);
 }
 
 /* Destroy a blob storage object. */
@@ -47,12 +57,7 @@ void
 xblob_destroy(
 	struct xblob	*blob)
 {
-	struct xb_key	*key, *n;
-
-	list_for_each_entry_safe(key, n, &blob->list, list) {
-		list_del(&key->list);
-		kmem_free(key);
-	}
+	xfile_destroy(blob->filp);
 	kmem_free(blob);
 }
 
@@ -64,19 +69,24 @@ xblob_get(
 	void		*ptr,
 	uint32_t	size)
 {
-	struct xb_key	*key = (struct xb_key *)cookie;
+	struct xb_key	key;
+	loff_t		pos = cookie;
+	int		error;
+
+	error = xfile_io(blob->filp, XFILE_IO_READ, &pos, &key, sizeof(key));
+	if (error)
+		return error;
 
-	if (key->magic != XB_KEY_MAGIC) {
+	if (key.magic != XB_KEY_MAGIC || key.offset != cookie) {
 		ASSERT(0);
 		return -ENODATA;
 	}
-	if (size < key->size) {
+	if (size < key.size) {
 		ASSERT(0);
 		return -EFBIG;
 	}
 
-	memcpy(ptr, key + 1, key->size);
-	return 0;
+	return xfile_io(blob->filp, XFILE_IO_READ, &pos, ptr, key.size);
 }
 
 /* Store a blob. */
@@ -87,19 +97,28 @@ xblob_put(
 	void		*ptr,
 	uint32_t	size)
 {
-	struct xb_key	*key;
-
-	key = kmem_alloc(XB_KEY_SIZE(size), KM_NOFS | KM_MAYFAIL);
-	if (!key)
-		return -ENOMEM;
-
-	INIT_LIST_HEAD(&key->list);
-	list_add_tail(&key->list, &blob->list);
-	key->magic = XB_KEY_MAGIC;
-	key->size = size;
-	memcpy(key + 1, ptr, size);
-	*cookie = (xblob_cookie)key;
+	struct xb_key	key = {
+		.offset = blob->last_offset,
+		.magic = XB_KEY_MAGIC,
+		.size = size,
+	};
+	loff_t		pos = blob->last_offset;
+	int		error;
+
+	error = xfile_io(blob->filp, XFILE_IO_WRITE, &pos, &key, sizeof(key));
+	if (error)
+		goto out_err;
+
+	error = xfile_io(blob->filp, XFILE_IO_WRITE, &pos, ptr, size);
+	if (error)
+		goto out_err;
+
+	*cookie = blob->last_offset;
+	blob->last_offset = pos;
 	return 0;
+out_err:
+	xfile_discard(blob->filp, blob->last_offset, pos - 1);
+	return -ENOMEM;
 }
 
 /* Free a blob. */
@@ -108,14 +127,19 @@ xblob_free(
 	struct xblob	*blob,
 	xblob_cookie	cookie)
 {
-	struct xb_key	*key = (struct xb_key *)cookie;
+	struct xb_key	key;
+	loff_t		pos = cookie;
+	int		error;
+
+	error = xfile_io(blob->filp, XFILE_IO_READ, &pos, &key, sizeof(key));
+	if (error)
+		return error;
 
-	if (key->magic != XB_KEY_MAGIC) {
+	if (key.magic != XB_KEY_MAGIC || key.offset != cookie) {
 		ASSERT(0);
 		return -ENODATA;
 	}
-	key->magic = 0;
-	list_del(&key->list);
-	kmem_free(key);
+
+	xfile_discard(blob->filp, cookie, cookie + sizeof(key) + key.size - 1);
 	return 0;
 }
diff --git a/fs/xfs/scrub/blob.h b/fs/xfs/scrub/blob.h
index 2595a15f78ac..c6f6c6a2e084 100644
--- a/fs/xfs/scrub/blob.h
+++ b/fs/xfs/scrub/blob.h
@@ -7,10 +7,11 @@
 #define __XFS_SCRUB_BLOB_H__
 
 struct xblob {
-	struct list_head	list;
+	struct file	*filp;
+	loff_t		last_offset;
 };
 
-typedef void			*xblob_cookie;
+typedef loff_t		xblob_cookie;
 
 struct xblob *xblob_init(void);
 void xblob_destroy(struct xblob *blob);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 7eb166599a61..8788030d13f6 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -906,6 +906,29 @@ TRACE_EVENT(xrep_ibt_insert,
 		  __entry->freemask)
 )
 
+TRACE_EVENT(xfbma_sort_stats,
+	TP_PROTO(uint64_t nr, unsigned int max_stack_depth,
+		 unsigned int max_stack_used, int error),
+	TP_ARGS(nr, max_stack_depth, max_stack_used, error),
+	TP_STRUCT__entry(
+		__field(uint64_t, nr)
+		__field(unsigned int, max_stack_depth)
+		__field(unsigned int, max_stack_used)
+		__field(int, error)
+	),
+	TP_fast_assign(
+		__entry->nr = nr;
+		__entry->max_stack_depth = max_stack_depth;
+		__entry->max_stack_used = max_stack_used;
+		__entry->error = error;
+	),
+	TP_printk("nr %llu max_depth %u max_used %u error %d",
+		  __entry->nr,
+		  __entry->max_stack_depth,
+		  __entry->max_stack_used,
+		  __entry->error)
+);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */
diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
new file mode 100644
index 000000000000..e0058e61202f
--- /dev/null
+++ b/fs/xfs/scrub/xfile.c
@@ -0,0 +1,121 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "scrub/array.h"
+#include "scrub/scrub.h"
+#include "scrub/trace.h"
+#include "scrub/xfile.h"
+#include <linux/shmem_fs.h>
+
+/*
+ * Create a memfd to our specifications and return a file pointer.  The file
+ * is not installed in the file description table (because userspace has no
+ * business accessing our internal data), which means that the caller /must/
+ * fput the file when finished.
+ */
+struct file *
+xfile_create(
+	const char	*description)
+{
+	struct file	*filp;
+
+	filp = shmem_file_setup(description, 0, 0);
+	if (IS_ERR_OR_NULL(filp))
+		return filp;
+
+	filp->f_mode |= FMODE_PREAD | FMODE_PWRITE;
+	filp->f_flags |= O_RDWR | O_LARGEFILE;
+	return filp;
+}
+
+void
+xfile_destroy(
+	struct file	*filp)
+{
+	fput(filp);
+}
+
+struct xfile_io_args {
+	struct work_struct	work;
+	struct completion	*done;
+
+	struct file		*filp;
+	void			*ptr;
+	loff_t			*pos;
+	size_t			count;
+	ssize_t			ret;
+	bool			is_read;
+};
+
+static void
+xfile_io_worker(
+	struct work_struct	*work)
+{
+	struct xfile_io_args	*args;
+	unsigned int		pflags;
+
+	args = container_of(work, struct xfile_io_args, work);
+	pflags = memalloc_nofs_save();
+
+	if (args->is_read)
+		args->ret = kernel_read(args->filp, args->ptr, args->count,
+				args->pos);
+	else
+		args->ret = kernel_write(args->filp, args->ptr, args->count,
+				args->pos);
+	complete(args->done);
+
+	memalloc_nofs_restore(pflags);
+}
+
+/*
+ * Perform a read or write IO to the file backing the array.  We can defer
+ * the work to a workqueue if the caller so desires, either to reduce stack
+ * usage or because the xfs is frozen and we want to avoid deadlocking on the
+ * page fault that might be about to happen.
+ */
+int
+xfile_io(
+	struct file	*filp,
+	unsigned int	cmd_flags,
+	loff_t		*pos,
+	void		*ptr,
+	size_t		count)
+{
+	DECLARE_COMPLETION_ONSTACK(done);
+	struct xfile_io_args	args = {
+		.filp = filp,
+		.ptr = ptr,
+		.pos = pos,
+		.count = count,
+		.done = &done,
+		.is_read = (cmd_flags & XFILE_IO_MASK) == XFILE_IO_READ,
+	};
+
+	INIT_WORK_ONSTACK(&args.work, xfile_io_worker);
+	schedule_work(&args.work);
+	wait_for_completion(&done);
+	destroy_work_on_stack(&args.work);
+
+	/*
+	 * Since we're treating this file as "memory", any IO error should be
+	 * treated as a failure to find any memory.
+	 */
+	return args.ret == count ? 0 : -ENOMEM;
+}
+
+/* Discard pages backing a range of the file. */
+void
+xfile_discard(
+	struct file	*filp,
+	loff_t		start,
+	loff_t		end)
+{
+	shmem_truncate_range(file_inode(filp), start, end);
+}
diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
new file mode 100644
index 000000000000..41817bcadc43
--- /dev/null
+++ b/fs/xfs/scrub/xfile.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef __XFS_SCRUB_XFILE_H__
+#define __XFS_SCRUB_XFILE_H__
+
+struct file *xfile_create(const char *description);
+void xfile_destroy(struct file *filp);
+
+/* read or write? */
+#define XFILE_IO_READ		(0)
+#define XFILE_IO_WRITE		(1)
+#define XFILE_IO_MASK		(1 << 0)
+int xfile_io(struct file *filp, unsigned int cmd_flags, loff_t *pos,
+		void *ptr, size_t count);
+
+void xfile_discard(struct file *filp, loff_t start, loff_t end);
+
+#endif /* __XFS_SCRUB_XFILE_H__ */
