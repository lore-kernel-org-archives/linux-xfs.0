Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6533AB460
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 05:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143200; cv=none; b=aLLKQJFYG9G9hRT53ycMuJaDL5kJ1jLy04bHLLS4BLXRz0c/WXto64QAAHGS3wbP/eb4Du48vW/y7oj14CX/FFLsRLlvv8GI9XbPtWllu9iJ2uEbcneDMfZn+LDWe0GwbUF0cs2u84h/oqxwb++afdHHvBSStod9TKFSbOMqUT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143200; c=relaxed/simple;
	bh=WjntsYGqLXiT+6TqdIegxFESeHVwZlmpMFUIebdipnY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kpqd0lTih92bC62c6aMoSXWEDS1Ihz4UsxWn5lj/rZfjg7vNk+ly3yF2bsozplhg554GWMwWLfVQZZygONKP7/9tT+g0FbtqCnVmewBKvIf6jA1j2up0KkTvWh96dWQy+qIQK/55gWkEj19n7xIw36FPL8wVyXYBnZj/QASOf0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MbidnkUN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MbidnkUN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 493431F000FF;
	Wed, 23 Sep 2026 05:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143198;
	bh=KItibDo5IYuorBYwtY84fG13pz+URIeqjEPlxKHQPS8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=MbidnkUNPfPG3eHRhGVaaK7UkonaKxV+tGBY2+vKNPcIRQnoxAF6+bJ8+eRqgYf9C
	 MJp7nfJrPkaJ6zDyUPQEaROeOy2EhfZBjh3CHOIMu5tinLMwXB9D3Wa5tbc2qlJCmE
	 x+yZuL0pDcOrU5L+OF2uBmJmPgS6T0JDl9POv/0Yumjgd6BiKuRpMvC2D8xkBt1SX2
	 op9OXsa+YGyKpYDMo4yE49PUcqwExXaMXGqe0Wh+bnJ7opETz1TLDTQoADPTahrYID
	 oM+qUMFeuO9LIl5DJTL48EjqrSsbdHuhVcf4OOdwuQNhQJkGt8Y+SjmsqIS2eGBxLa
	 KcQcRFP9bJZcw==
Date: Tue, 22 Sep 2026 22:59:57 -0700
Subject: [PATCH 10/13] xfarray: don't allow users to unset in the middle of an
 array
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179014159141.1874904.9474944005398438284.stgit@frogsfrogsfrogs>
In-Reply-To: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
References: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we've merged online repair and removed some clunky parts of the
original online checking code, the only user of xfarray_unset is the
free space btree repair code, and it only needs to be able to remove
records from the end of the array.  Let's remove all the code that
handles "unset" array elements that are not at the end, because we can
just reduce the array element count.

Remove the "store anywhere" function because it was only ever used by
the callers who used unset to remove elements in the middle of the
array.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/xfarray.h                             |    6 -
 .../filesystems/xfs/xfs-online-fsck-design.rst     |   13 +-
 fs/xfs/scrub/alloc_repair.c                        |    2 
 fs/xfs/scrub/xfarray.c                             |  108 ++------------------
 4 files changed, 15 insertions(+), 114 deletions(-)


diff --git a/fs/xfs/scrub/xfarray.h b/fs/xfs/scrub/xfarray.h
index 5eeeeed13ae24a..d55225c7885b25 100644
--- a/fs/xfs/scrub/xfarray.h
+++ b/fs/xfs/scrub/xfarray.h
@@ -27,9 +27,6 @@ struct xfarray {
 	/* Maximum possible array size. */
 	xfarray_idx_t	max_nr;
 
-	/* Number of unset slots in the array below @nr. */
-	uint64_t	unset_slots;
-
 	/* Size of an array element. */
 	size_t		obj_size;
 
@@ -41,9 +38,8 @@ int xfarray_create(const char *descr, unsigned long long required_capacity,
 		size_t obj_size, struct xfarray **arrayp);
 void xfarray_destroy(struct xfarray *array);
 int xfarray_load(struct xfarray *array, xfarray_idx_t idx, void *ptr);
-int xfarray_unset(struct xfarray *array, xfarray_idx_t idx);
+int xfarray_trim(struct xfarray *array, unsigned long long nr);
 int xfarray_store(struct xfarray *array, xfarray_idx_t idx, const void *ptr);
-int xfarray_store_anywhere(struct xfarray *array, const void *ptr);
 bool xfarray_element_is_null(struct xfarray *array, const void *ptr);
 void xfarray_truncate(struct xfarray *array);
 unsigned long long xfarray_bytes(struct xfarray *array);
diff --git a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
index 3d9233f403dbb1..14767ce9fad43f 100644
--- a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
@@ -1973,8 +1973,7 @@ provide loading and storing of array elements at arbitrary array indices.
 Gaps are defined to be null records, and null records are defined to be a
 sequence of all zero bytes.
 Null records are detected by calling ``xfarray_element_is_null``.
-They are created either by calling ``xfarray_unset`` to null out an existing
-record or by never storing anything to an array index.
+They are created by never storing anything to an array index.
 
 The second type of caller handles records that are not indexed by position
 and do not require multiple updates to a record.
@@ -1991,9 +1990,7 @@ The typical use case here is constructing space extent reference counts from
 reverse mapping information.
 Records can be put in the bag in any order, they can be removed from the bag
 at any time, and uniqueness of records is left to callers.
-The ``xfarray_store_anywhere`` function is used to insert a record in any
-null record slot in the bag; and the ``xfarray_unset`` function removes a
-record from the bag.
+Note: Bags are now implemented with in-memory btrees for faster access.
 
 Iterating Array Elements
 ^^^^^^^^^^^^^^^^^^^^^^^^
@@ -2643,11 +2640,7 @@ generate refcount information from reverse mapping records.
       refcount record associating the block number range that we just walked to
       the size of the bag.
 
-The bag-like structure in this case is a type 2 xfarray as discussed in the
-:ref:`xfarray access patterns<xfarray_access_patterns>` section.
-Reverse mappings are added to the bag using ``xfarray_store_anywhere`` and
-removed via ``xfarray_unset``.
-Bag members are examined through ``xfarray_iter`` loops.
+The bag-like structure in this case is an in-memory btree.
 
 Case Study: Rebuilding File Fork Mapping Indices
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index 95e318e4f3a6c7..b37b80af52a03b 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -517,7 +517,7 @@ xrep_abt_reserve_space(
 		 * records (but doesn't break the sorting order), so we must
 		 * go around the loop once more to re-run _bload_init.
 		 */
-		error = xfarray_unset(ra->free_records, record_nr);
+		error = xfarray_trim(ra->free_records, 1);
 		if (error)
 			break;
 		ra->nr_real_records--;
diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index 5ea3ce4bf8d846..685824efdb93f6 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -140,55 +140,20 @@ xfarray_load(
 			xfarray_pos(array, idx));
 }
 
-/* Is this array element potentially unset? */
-static inline bool
-xfarray_is_unset(
-	struct xfarray	*array,
-	loff_t		pos)
-{
-	void		*temp = xfarray_scratch(array);
-	int		error;
-
-	if (array->unset_slots == 0)
-		return false;
-
-	error = xfile_load(array->xfile, temp, array->obj_size, pos);
-	if (!error && xfarray_element_is_null(array, temp))
-		return true;
-
-	return false;
-}
-
-/*
- * Unset an array element.  If @idx is the last element in the array, the
- * array will be truncated.  Otherwise, the entry will be zeroed.
- */
+/* Remove the elements at the end of an array. */
 int
-xfarray_unset(
-	struct xfarray	*array,
-	xfarray_idx_t	idx)
+xfarray_trim(
+	struct xfarray		*array,
+	unsigned long long	nr)
 {
-	void		*temp = xfarray_scratch(array);
-	loff_t		pos = xfarray_pos(array, idx);
-	int		error;
+	loff_t			new_eof;
 
-	if (idx >= array->nr)
+	if (nr > array->nr)
 		return -ENODATA;
 
-	if (idx == array->nr - 1) {
-		array->nr--;
-		return 0;
-	}
-
-	if (xfarray_is_unset(array, pos))
-		return 0;
-
-	memset(temp, 0, array->obj_size);
-	error = xfile_store(array->xfile, temp, array->obj_size, pos);
-	if (error)
-		return error;
-
-	array->unset_slots++;
+	array->nr -= nr;
+	new_eof = xfarray_pos(array, array->nr);
+	xfile_discard(array->xfile, new_eof, MAX_LFS_FILESIZE - new_eof);
 	return 0;
 }
 
@@ -227,43 +192,6 @@ xfarray_element_is_null(
 	return !memchr_inv(ptr, 0, array->obj_size);
 }
 
-/*
- * Store an element anywhere in the array that is unset.  If there are no
- * unset slots, append the element to the array.
- */
-int
-xfarray_store_anywhere(
-	struct xfarray	*array,
-	const void	*ptr)
-{
-	void		*temp = xfarray_scratch(array);
-	loff_t		endpos = xfarray_pos(array, array->nr);
-	loff_t		pos;
-	int		error;
-
-	/* Find an unset slot to put it in. */
-	for (pos = 0;
-	     pos < endpos && array->unset_slots > 0;
-	     pos += array->obj_size) {
-		error = xfile_load(array->xfile, temp, array->obj_size,
-				pos);
-		if (error || !xfarray_element_is_null(array, temp))
-			continue;
-
-		error = xfile_store(array->xfile, ptr, array->obj_size,
-				pos);
-		if (error)
-			return error;
-
-		array->unset_slots--;
-		return 0;
-	}
-
-	/* No unset slots found; attach it on the end. */
-	array->unset_slots = 0;
-	return xfarray_append(array, ptr);
-}
-
 /* Return length of array. */
 uint64_t
 xfarray_length(
@@ -677,26 +605,10 @@ xfarray_qsort_pivot(
 
 	/* Load the selected xfarray records into the pivot array. */
 	for (i = 0; i < XFARRAY_QSORT_PIVOT_NR; i++) {
-		xfarray_idx_t	idx;
-
 		recp = xfarray_pivot_array_rec(parray, pivot_rec_sz, i);
 		idxp = xfarray_pivot_array_idx(parray, pivot_rec_sz, i);
 
-		/* No unset records; load directly into the array. */
-		if (likely(si->array->unset_slots == 0)) {
-			error = xfarray_sort_load(si, *idxp, recp);
-			if (error)
-				return error;
-			continue;
-		}
-
-		/*
-		 * Load non-null records into the scratchpad without changing
-		 * the xfarray_idx_t in the pivot array.
-		 */
-		idx = *idxp;
-		xfarray_sort_bump_loads(si);
-		error = xfarray_load_next(si->array, &idx, recp);
+		error = xfarray_sort_load(si, *idxp, recp);
 		if (error)
 			return error;
 	}

