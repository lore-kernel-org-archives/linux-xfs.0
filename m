Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B160C47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C72FE218DE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:50:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G3vOYx2D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731850AbfJIQuX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 12:50:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57470 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730546AbfJIQuW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 12:50:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GjbLF003527
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:50:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=mG5dkgjE3VvOCAzJ3LegUzPfGT5dVgufoxGWozla+2k=;
 b=G3vOYx2DLf4lG1UY9/tFeKq834mSpQi4Ax02G0ljLP5fOkBJfno/h+Dkn2F/a5emsSqx
 LQPIHWHyxwFNqG+sKO05PqGR/+FTX9BTBKoIdkIvrCDWcaOjYRm3XpH0LAZmsDvLQtG4
 4lY9HD8VKJ8/sd2NcNCsuGm+Fg4Aifakt9DnKLYdqG6H5gpum4EJUFtWkuJBPKfOOMxi
 65QJTmBtGa8gBWzSThcJ53oq6ew1iFPwWU/bUMTYLI0uXICbDFv/ux2puAN5i48wTvpa
 Vxft9mEMaJLo6lDO/d2ngmXnENGPLI6iOWYxTz1OeoiWEyxNSjXUqo/TKUrBl7L0xqY6 Ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vek4qnyyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:50:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GjWkv054923
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:50:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2vh5cb21t7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:50:19 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x99GoIk5023011
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:50:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 09:50:16 -0700
Subject: [PATCH 1/4] xfs: create a big array data structure
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 09 Oct 2019 09:50:15 -0700
Message-ID: <157063981530.2915883.16336807056103657059.stgit@magnolia>
In-Reply-To: <157063980873.2915883.8510302923584220865.stgit@magnolia>
References: <157063980873.2915883.8510302923584220865.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910090147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910090147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a simple 'big array' data structure for storage of fixed-size
metadata records that will be used to reconstruct a btree index.  For
repair operations, the most important operations are append, iterate,
and sort.

Earlier implementations of the big array used linked lists and suffered
from severe problems -- pinning all records in kernel memory was not a
good idea and frequently lead to OOM situations; random access was very
inefficient; and record overhead for the lists was unacceptably high at
40-60%.

Therefore, the big memory array relies on the 'xfile' abstraction, which
creates a memfd file and stores the records in page cache pages.  Since
the memfd is created in tmpfs, the memory pages can be pushed out to
disk if necessary and we have a built-in usage limit of 50% of physical
memory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile      |    2 
 fs/xfs/scrub/array.c |  630 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/array.h |   44 +++
 fs/xfs/scrub/trace.h |   23 ++
 fs/xfs/scrub/xfile.c |   82 +++++++
 fs/xfs/scrub/xfile.h |   21 ++
 6 files changed, 802 insertions(+)
 create mode 100644 fs/xfs/scrub/array.c
 create mode 100644 fs/xfs/scrub/array.h
 create mode 100644 fs/xfs/scrub/xfile.c
 create mode 100644 fs/xfs/scrub/xfile.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 06b68b6115bc..d21b59cfc530 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -160,8 +160,10 @@ xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
+				   array.o \
 				   bitmap.o \
 				   repair.o \
+				   xfile.o \
 				   )
 endif
 endif
diff --git a/fs/xfs/scrub/array.c b/fs/xfs/scrub/array.c
new file mode 100644
index 000000000000..1b3635a115b2
--- /dev/null
+++ b/fs/xfs/scrub/array.c
@@ -0,0 +1,630 @@
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
+
+/*
+ * XFS Fixed-Size Big Memory Array
+ * ===============================
+ * The file-backed memory array uses a memfd "file" to store large numbers of
+ * fixed-size records in memory that can be paged out.  This puts less stress
+ * on the memory reclaim algorithms because memfd file pages are not pinned and
+ * can be paged out; however, array access is less direct than would be in a
+ * regular memory array.  Access to the array is performed via indexed get and
+ * put methods, and an append method is provided for convenience.  Array
+ * elements can be set to all zeroes, which means that the entry is NULL and
+ * will be skipped during iteration.
+ */
+
+#define XFBMA_MAX_TEMP	(2)
+
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
+
+/* Initialize a big memory array. */
+struct xfbma *
+xfbma_init(
+	size_t		obj_size)
+{
+	struct xfbma	*array;
+	struct file	*filp;
+	int		error;
+
+	filp = xfile_create("big array");
+	if (!filp)
+		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(filp))
+		return ERR_CAST(filp);
+
+	error = -ENOMEM;
+	array = kmem_alloc(sizeof(struct xfbma) + (XFBMA_MAX_TEMP * obj_size),
+			KM_NOFS | KM_MAYFAIL);
+	if (!array)
+		goto out_filp;
+
+	array->filp = filp;
+	array->obj_size = obj_size;
+	array->nr = 0;
+	return array;
+out_filp:
+	fput(filp);
+	return ERR_PTR(error);
+}
+
+void
+xfbma_destroy(
+	struct xfbma	*array)
+{
+	xfile_destroy(array->filp);
+	kmem_free(array);
+}
+
+/* Compute offset of array element. */
+static inline loff_t
+xfbma_offset(
+	struct xfbma	*array,
+	uint64_t	nr)
+{
+	if (nr >= array->nr)
+		return -1;
+	return nr * array->obj_size;
+}
+
+/* Get an element from the array. */
+int
+xfbma_get(
+	struct xfbma	*array,
+	uint64_t	nr,
+	void		*ptr)
+{
+	loff_t		pos = xfbma_offset(array, nr);
+
+	if (pos < 0) {
+		ASSERT(0);
+		return -ENODATA;
+	}
+
+	return xfile_io(array->filp, XFILE_IO_READ, &pos, ptr, array->obj_size);
+}
+
+/* Put an element in the array. */
+int
+xfbma_set(
+	struct xfbma	*array,
+	uint64_t	nr,
+	void		*ptr)
+{
+	loff_t		pos = xfbma_offset(array, nr);
+
+	if (pos < 0) {
+		ASSERT(0);
+		return -ENODATA;
+	}
+
+	return xfile_io(array->filp, XFILE_IO_WRITE, &pos, ptr,
+			array->obj_size);
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
+	void		*temp = xfbma_temp(array, 0);
+	uint64_t	i;
+	int		error;
+
+	/* Find a null slot to put it in. */
+	for (i = 0; i < array->nr; i++) {
+		error = xfbma_get(array, i, temp);
+		if (error || !xfbma_is_null(array, temp))
+			continue;
+		return xfbma_set(array, i, ptr);
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
+	void		*temp = xfbma_temp(array, 0);
+	loff_t		pos = xfbma_offset(array, nr);
+
+	if (pos < 0) {
+		ASSERT(0);
+		return -ENODATA;
+	}
+
+	memset(temp, 0, array->obj_size);
+	return xfile_io(array->filp, XFILE_IO_WRITE, &pos, temp,
+			array->obj_size);
+}
+
+/* Append an element to the array. */
+int
+xfbma_append(
+	struct xfbma	*array,
+	void		*ptr)
+{
+	loff_t		pos = array->obj_size * array->nr;
+	int		error;
+
+	if (pos < 0) {
+		ASSERT(0);
+		return -ENODATA;
+	}
+
+	error = xfile_io(array->filp, XFILE_IO_WRITE, &pos, ptr,
+			array->obj_size);
+	if (error)
+		return error;
+	array->nr++;
+	return 0;
+}
+
+/*
+ * Iterate every element in this array, freeing each element as we go.
+ * Array elements will be nulled out.
+ */
+int
+xfbma_iter_del(
+	struct xfbma	*array,
+	xfbma_iter_fn	iter_fn,
+	void		*priv)
+{
+	void		*temp = xfbma_temp(array, 0);
+	pgoff_t		oldpagenr = 0;
+	uint64_t	max_bytes;
+	uint64_t	i;
+	loff_t		pos;
+	int		error = 0;
+
+	max_bytes = array->nr * array->obj_size;
+	for (pos = 0, i = 0; pos < max_bytes; i++) {
+		pgoff_t	pagenr;
+
+		error = xfile_io(array->filp, XFILE_IO_READ, &pos, temp,
+				array->obj_size);
+		if (error)
+			break;
+		if (xfbma_is_null(array, temp))
+			goto next;
+		error = iter_fn(temp, priv);
+		if (error)
+			break;
+next:
+		/* Release the previous page if possible. */
+		pagenr = pos >> PAGE_SHIFT;
+		if (pagenr != oldpagenr)
+			xfile_discard(array->filp, oldpagenr << PAGE_SHIFT,
+					pos - 1);
+		oldpagenr = pagenr;
+	}
+
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
+{
+	void		*a = xfbma_temp(array, 0);
+	void		*b = xfbma_temp(array, 1);
+	int		error;
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
+
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
+}
+
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
+int
+xfbma_sort(
+	struct xfbma	*array,
+	xfbma_cmp_fn	cmp_fn)
+{
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
+}
diff --git a/fs/xfs/scrub/array.h b/fs/xfs/scrub/array.h
new file mode 100644
index 000000000000..7108d02cfdcd
--- /dev/null
+++ b/fs/xfs/scrub/array.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef __XFS_SCRUB_ARRAY_H__
+#define __XFS_SCRUB_ARRAY_H__
+
+struct xfbma {
+	struct file	*filp;
+	size_t		obj_size;
+	uint64_t	nr;
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
+ * Return codes for the array iterator function are 0 to continue iterating,
+ * and non-zero to stop iterating.  Any non-zero value will be passed up to the
+ * iteration caller.  The special value -ECANCELED can be used to stop
+ * iteration, because the iterator never generates that error code on its own.
+ */
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
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index deb177abf652..ec6774d03dd2 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -962,6 +962,29 @@ TRACE_EVENT(xrep_newbt_alloc_block,
 		  __entry->owner)
 );
 
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
index 000000000000..2d96e2f9917c
--- /dev/null
+++ b/fs/xfs/scrub/xfile.c
@@ -0,0 +1,82 @@
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
+	filp->f_mode |= FMODE_PREAD | FMODE_PWRITE | FMODE_NOCMTIME;
+	filp->f_flags |= O_RDWR | O_LARGEFILE | O_NOATIME;
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
+	ssize_t		ret;
+	unsigned int	pflags = memalloc_nofs_save();
+
+	if ((cmd_flags & XFILE_IO_MASK) == XFILE_IO_READ)
+		ret = kernel_read(filp, ptr, count, pos);
+	else
+		ret = kernel_write(filp, ptr, count, pos);
+	memalloc_nofs_restore(pflags);
+
+	/*
+	 * Since we're treating this file as "memory", any IO error should be
+	 * treated as a failure to find any memory.
+	 */
+	return ret == count ? 0 : -ENOMEM;
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

