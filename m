Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D47448989A
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 18:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790100876; cv=none; b=urTS1I7CfBwL6ThULmpVbgb70XewRtd2Lv7I/8Rlz0Qb2JKeQSfz4pBcQYRjTZ0FE/qgHygG+ZOzCekWYg3gNM4XuNSmfLqQxu9eqdqqgp99RyL1zL7jVwPCmq1tBiXLhuLq++cAxhcvSzI072BqqeDI17VTHNAwcMw2iilKay4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790100876; c=relaxed/simple;
	bh=BzGainBax3iedRP8KbhKiVXwADN82zbltBhhMKj29eU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L+8wSyhYAy0Gbonh0zOMjsy/cWUUm5nZsraPrebBnxCJLsrZNvg6T7v6pRqLsKtXw+J+RgQ6IcflZYhhfhTMuWu09wDaYLHCN2Cal7JrvnV0F8z9lIiJ8BoIVCfKBhmvePkbVMeXWZvIk8mTWe9v+AIBGIIGNqW8ntYCH2Rl/0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gISvLx7g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gISvLx7g"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6D8151F000FF;
	Tue, 22 Sep 2026 18:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790100874;
	bh=G22LDOHJCmBLy8Xzu8WC+iQB8x0g7B7x/cVOR8TNNAQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gISvLx7gxmydhq4lPkNOzpulNuhLfFzkpGXlR9xgBd/bcmuGOG2fPcPSJ2GKK/q3f
	 B8aMRzNSn0l8Na4+70LYfqXeu4vlHsGBQp/lz1rbdRyf83stC/xUstpT/H4ajFeOJ6
	 QYHLDiVU9Q4ddoUhuLoNYXojazTXR/5kFjVOFaHYjo/Ec8IWTE8jT2hYU/hNiVIRhH
	 gx1sNm9ZFxzSyu31gSh7ptJ5y9D4XyArGeN8kzuUns5V+aM59kN8d4SH2PpQVDNVci
	 zHw3yD+8IJk41vPqEJ5OSQ7QGqP4Pg6zEvYSqKiHdc/e03t8kxfvqFj7oPEec65Jbx
	 VDZJmnFaCCdEg==
Date: Tue, 22 Sep 2026 11:14:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/14] xfarray: don't allow users to unset in the middle
 of an array
Message-ID: <20260922181433.GA2705364@frogsfrogsfrogs>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120785.181988.9998461891697022684.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996120785.181988.9998461891697022684.stgit@frogsfrogsfrogs>

On Sun, Sep 20, 2026 at 11:17:51PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we've merged online fsck, the only user of xfarray_unset is the
> free space btree repair code, and it only needs to be able to remove
> records from the end of the array.  Let's remove all the code that
> handles "unset" array elements that are not at the end, because we can
> just reduce the array element count.
> 
> Remove the "store anywhere" function because it was only ever used by
> the callers who used unset to remove elements in the middle of the
> array.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/scrub/xfarray.h                             |    6 -
>  .../filesystems/xfs/xfs-online-fsck-design.rst     |   13 +--
>  fs/xfs/scrub/alloc_repair.c                        |    2 
>  fs/xfs/scrub/xfarray.c                             |   92 ++------------------
>  4 files changed, 14 insertions(+), 99 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/xfarray.h b/fs/xfs/scrub/xfarray.h
> index 5eeeeed13ae24a..d55225c7885b25 100644
> --- a/fs/xfs/scrub/xfarray.h
> +++ b/fs/xfs/scrub/xfarray.h
> @@ -27,9 +27,6 @@ struct xfarray {
>  	/* Maximum possible array size. */
>  	xfarray_idx_t	max_nr;
>  
> -	/* Number of unset slots in the array below @nr. */
> -	uint64_t	unset_slots;
> -
>  	/* Size of an array element. */
>  	size_t		obj_size;
>  
> @@ -41,9 +38,8 @@ int xfarray_create(const char *descr, unsigned long long required_capacity,
>  		size_t obj_size, struct xfarray **arrayp);
>  void xfarray_destroy(struct xfarray *array);
>  int xfarray_load(struct xfarray *array, xfarray_idx_t idx, void *ptr);
> -int xfarray_unset(struct xfarray *array, xfarray_idx_t idx);
> +int xfarray_trim(struct xfarray *array, unsigned long long nr);
>  int xfarray_store(struct xfarray *array, xfarray_idx_t idx, const void *ptr);
> -int xfarray_store_anywhere(struct xfarray *array, const void *ptr);
>  bool xfarray_element_is_null(struct xfarray *array, const void *ptr);
>  void xfarray_truncate(struct xfarray *array);
>  unsigned long long xfarray_bytes(struct xfarray *array);
> diff --git a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
> index 3d9233f403dbb1..14767ce9fad43f 100644
> --- a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
> +++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
> @@ -1973,8 +1973,7 @@ provide loading and storing of array elements at arbitrary array indices.
>  Gaps are defined to be null records, and null records are defined to be a
>  sequence of all zero bytes.
>  Null records are detected by calling ``xfarray_element_is_null``.
> -They are created either by calling ``xfarray_unset`` to null out an existing
> -record or by never storing anything to an array index.
> +They are created by never storing anything to an array index.
>  
>  The second type of caller handles records that are not indexed by position
>  and do not require multiple updates to a record.
> @@ -1991,9 +1990,7 @@ The typical use case here is constructing space extent reference counts from
>  reverse mapping information.
>  Records can be put in the bag in any order, they can be removed from the bag
>  at any time, and uniqueness of records is left to callers.
> -The ``xfarray_store_anywhere`` function is used to insert a record in any
> -null record slot in the bag; and the ``xfarray_unset`` function removes a
> -record from the bag.
> +Note: Bags are now implemented with in-memory btrees for faster access.
>  
>  Iterating Array Elements
>  ^^^^^^^^^^^^^^^^^^^^^^^^
> @@ -2643,11 +2640,7 @@ generate refcount information from reverse mapping records.
>        refcount record associating the block number range that we just walked to
>        the size of the bag.
>  
> -The bag-like structure in this case is a type 2 xfarray as discussed in the
> -:ref:`xfarray access patterns<xfarray_access_patterns>` section.
> -Reverse mappings are added to the bag using ``xfarray_store_anywhere`` and
> -removed via ``xfarray_unset``.
> -Bag members are examined through ``xfarray_iter`` loops.
> +The bag-like structure in this case is an in-memory btree.
>  
>  Case Study: Rebuilding File Fork Mapping Indices
>  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
> index 95e318e4f3a6c7..b37b80af52a03b 100644
> --- a/fs/xfs/scrub/alloc_repair.c
> +++ b/fs/xfs/scrub/alloc_repair.c
> @@ -517,7 +517,7 @@ xrep_abt_reserve_space(
>  		 * records (but doesn't break the sorting order), so we must
>  		 * go around the loop once more to re-run _bload_init.
>  		 */
> -		error = xfarray_unset(ra->free_records, record_nr);
> +		error = xfarray_trim(ra->free_records, 1);
>  		if (error)
>  			break;
>  		ra->nr_real_records--;
> diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
> index 30a58e9d4378e4..ee3f0bf87433f1 100644
> --- a/fs/xfs/scrub/xfarray.c
> +++ b/fs/xfs/scrub/xfarray.c
> @@ -149,9 +149,6 @@ xfarray_is_unset(

Shashiko writes:

"Is this function now entirely dead code? The patch removes xfarray_unset(),
which was the only caller of the xfarray_is_unset() static inline helper.
Should the entire xfarray_is_unset() function be removed?"

Yes.

>  	void		*temp = xfarray_scratch(array);
>  	int		error;
>  
> -	if (array->unset_slots == 0)
> -		return false;
> -
>  	error = xfile_load(array->xfile, temp, array->obj_size, pos);
>  	if (!error && xfarray_element_is_null(array, temp))
>  		return true;
> @@ -159,36 +156,18 @@ xfarray_is_unset(
>  	return false;
>  }
>  
> -/*
> - * Unset an array element.  If @idx is the last element in the array, the
> - * array will be truncated.  Otherwise, the entry will be zeroed.
> - */
> +/* Remove the elements at the end of an array. */
>  int
> -xfarray_unset(
> -	struct xfarray	*array,
> -	xfarray_idx_t	idx)
> +xfarray_trim(
> +	struct xfarray		*array,
> +	unsigned long long	nr)
>  {
> -	void		*temp = xfarray_scratch(array);
> -	loff_t		pos = xfarray_pos(array, idx);
> -	int		error;
> -
> -	if (idx >= array->nr)
> +	if (nr > array->nr)
>  		return -ENODATA;
>  
> -	if (idx == array->nr - 1) {
> -		array->nr--;
> -		return 0;
> -	}
> -
> -	if (xfarray_is_unset(array, pos))
> -		return 0;
> -
> -	memset(temp, 0, array->obj_size);
> -	error = xfile_store(array->xfile, temp, array->obj_size, pos);
> -	if (error)
> -		return error;
> -
> -	array->unset_slots++;
> +	array->nr -= nr;
> +	xfile_discard(array->xfile, xfarray_pos(array, array->nr),
> +			MAX_LFS_FILESIZE);

"Can passing MAX_LFS_FILESIZE here cause a silent memory leak on 32-bit
architectures?
In xfarray_trim(), MAX_LFS_FILESIZE is passed as the count to
xfile_discard(), which passes it directly to shmem_truncate_range().
On 32-bit systems, MAX_LFS_FILESIZE is 0xFFFFFFFF000. When pos >= 0x1000
(4KB), the lend calculation (pos + count - 1) inside shmem_undo_range()
evaluates to at least 0x100000000000.
The truncation endpoint is calculated as:
end = (lend + 1) >> PAGE_SHIFT;
This results in an end value of 0x100000000. Since pgoff_t is a 32-bit
unsigned long on 32-bit systems, this truncates to exactly 0.
Because start would be at least 1, the loop "while (index < end)" evaluates
1 < 0, which is false. The loop terminates immediately without discarding any
pages, causing a memory leak during XFS free space btree repair.
Should count be clamped, such as passing MAX_LFS_FILESIZE - pos?"

Yes.

--D

>  	return 0;
>  }
>  
> @@ -227,43 +206,6 @@ xfarray_element_is_null(
>  	return !memchr_inv(ptr, 0, array->obj_size);
>  }
>  
> -/*
> - * Store an element anywhere in the array that is unset.  If there are no
> - * unset slots, append the element to the array.
> - */
> -int
> -xfarray_store_anywhere(
> -	struct xfarray	*array,
> -	const void	*ptr)
> -{
> -	void		*temp = xfarray_scratch(array);
> -	loff_t		endpos = xfarray_pos(array, array->nr);
> -	loff_t		pos;
> -	int		error;
> -
> -	/* Find an unset slot to put it in. */
> -	for (pos = 0;
> -	     pos < endpos && array->unset_slots > 0;
> -	     pos += array->obj_size) {
> -		error = xfile_load(array->xfile, temp, array->obj_size,
> -				pos);
> -		if (error || !xfarray_element_is_null(array, temp))
> -			continue;
> -
> -		error = xfile_store(array->xfile, ptr, array->obj_size,
> -				pos);
> -		if (error)
> -			return error;
> -
> -		array->unset_slots--;
> -		return 0;
> -	}
> -
> -	/* No unset slots found; attach it on the end. */
> -	array->unset_slots = 0;
> -	return xfarray_append(array, ptr);
> -}
> -
>  /* Return length of array. */
>  uint64_t
>  xfarray_length(
> @@ -677,26 +619,10 @@ xfarray_qsort_pivot(
>  
>  	/* Load the selected xfarray records into the pivot array. */
>  	for (i = 0; i < XFARRAY_QSORT_PIVOT_NR; i++) {
> -		xfarray_idx_t	idx;
> -
>  		recp = xfarray_pivot_array_rec(parray, pivot_rec_sz, i);
>  		idxp = xfarray_pivot_array_idx(parray, pivot_rec_sz, i);
>  
> -		/* No unset records; load directly into the array. */
> -		if (likely(si->array->unset_slots == 0)) {
> -			error = xfarray_sort_load(si, *idxp, recp);
> -			if (error)
> -				return error;
> -			continue;
> -		}
> -
> -		/*
> -		 * Load non-null records into the scratchpad without changing
> -		 * the xfarray_idx_t in the pivot array.
> -		 */
> -		idx = *idxp;
> -		xfarray_sort_bump_loads(si);
> -		error = xfarray_load_next(si->array, &idx, recp);
> +		error = xfarray_sort_load(si, *idxp, recp);
>  		if (error)
>  			return error;
>  	}
> 
> 
