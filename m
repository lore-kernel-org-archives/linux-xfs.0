Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2278D1C84DC;
	Thu, 23 Jul 2026 20:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784840160; cv=none; b=icfV1viztRl9Ofit9ylsV/O82Zjw9yHrvLDeU3jdgChidZCqKweDW/mr/0jv1SK4Vf7NgLBN1Q7hviOrEjoNa0pHlrQ/k20HfLrV+x9ItHoveA3ZgJmelgZYNb1EPwLpHwoEXBWxfoXvXG5r2rAnMxnIknUZUCH79t8dWYxdVY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784840160; c=relaxed/simple;
	bh=nR8k/2Z/WjH8+hVccw/Um+2bsR1MyCGLl+4DrytPH0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rhjoqI1xdVTlEc0d4AQgm1SPq1Nx3LZN2SNSB17cWfjcsAXCb8WogYqZO+yLctkvK5bqg/9MtbRxu24KS8WhyoRoBSD9R/M3aTz1xzFbSuZsJWgvnHxa2mh7p+LMvTNbiY4oFZwQgP6y+mtXBDlJoQv223wVVHtzM4YCEJXCI/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jLYs3daQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jLYs3daQ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5E4951F000E9;
	Thu, 23 Jul 2026 20:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784840156;
	bh=3EmdX1shdP9imqi50JbnFaT470of3tR1en7wf1iYsm4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jLYs3daQuaJNoGyV1SAgwQgFtfiWAxF22al54ljA7oVmI9qktSCXM3o1j0Z7ZqgJh
	 CB3XbXustcy9rd15bsnS3cJY36qjQ2xOoMEsEyUWc8EfZvaz6vNU2mxzqCJ++wIAwd
	 u+7qwEaQM8s9b/Cin1qcDum4UbOmmiH/usr0OxOs81n0tMFY6G4Kh0jH0aPAgBdWSQ
	 KdbkHJQKJt+sqZDJjDzCzu6dr/vQ3APD5y1IJkQ9BapBxhQ3a62rcvr6J0UQH5D6/d
	 NyelmTNZx6BbmarJOw69OlrOHc8HHnYlj41z1NWjVQT7cCQCWhvOfewaJbq4hGnF+a
	 wWXKsu5pstRJQ==
Date: Thu, 23 Jul 2026 13:55:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 17/22] xfs: split ioend handling into a separate source
 file
Message-ID: <20260723205556.GG2901224@frogsfrogsfrogs>
References: <20260723145000.116419-1-hch@lst.de>
 <20260723145000.116419-18-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723145000.116419-18-hch@lst.de>

On Thu, Jul 23, 2026 at 04:49:42PM +0200, Christoph Hellwig wrote:
> The ioend handling used to be only for buffered writeback, but has been
> extended to direct I/O and reads.  Split it into a new source file.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/Makefile    |   1 +
>  fs/xfs/xfs_aops.c  | 179 +------------------------------------------
>  fs/xfs/xfs_aops.h  |   1 -
>  fs/xfs/xfs_file.c  |   2 +-
>  fs/xfs/xfs_ioend.c | 184 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_ioend.h |  16 ++++

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  6 files changed, 203 insertions(+), 180 deletions(-)
>  create mode 100644 fs/xfs/xfs_ioend.c
>  create mode 100644 fs/xfs/xfs_ioend.h
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 9f7133e02576..399a207f2d0e 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -91,6 +91,7 @@ xfs-y				+= xfs_aops.o \
>  				   xfs_healthmon.o \
>  				   xfs_icache.o \
>  				   xfs_ioctl.o \
> +				   xfs_ioend.o \
>  				   xfs_iomap.o \
>  				   xfs_iops.o \
>  				   xfs_inode.o \
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 0b757b7f35c0..49d21d905cc3 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -20,6 +20,7 @@
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
>  #include "xfs_icache.h"
> +#include "xfs_ioend.h"
>  #include "xfs_zone_alloc.h"
>  #include "xfs_rtgroup.h"
>  
> @@ -35,15 +36,6 @@ XFS_WPC(struct iomap_writepage_ctx *ctx)
>  	return container_of(ctx, struct xfs_writepage_ctx, ctx);
>  }
>  
> -/*
> - * Fast and loose check if this write could update the on-disk inode size.
> - */
> -static inline bool xfs_ioend_is_append(struct iomap_ioend *ioend)
> -{
> -	return ioend->io_offset + ioend->io_size >
> -		XFS_I(ioend->io_inode)->i_disk_size;
> -}
> -
>  /*
>   * Update on-disk file size now that data has been written to disk.
>   */
> @@ -79,175 +71,6 @@ xfs_setfilesize(
>  	return xfs_trans_commit(tp);
>  }
>  
> -static void
> -xfs_ioend_put_open_zones(
> -	struct iomap_ioend	*ioend)
> -{
> -	struct iomap_ioend *tmp;
> -
> -	/*
> -	 * Put the open zone for all ioends merged into this one (if any).
> -	 */
> -	list_for_each_entry(tmp, &ioend->io_list, io_list)
> -		xfs_open_zone_put(tmp->io_private);
> -
> -	/*
> -	 * The main ioend might not have an open zone if the submission failed
> -	 * before xfs_zone_alloc_and_submit got called.
> -	 */
> -	if (ioend->io_private)
> -		xfs_open_zone_put(ioend->io_private);
> -}
> -
> -/*
> - * IO write completion.
> - */
> -STATIC void
> -xfs_end_ioend_write(
> -	struct iomap_ioend	*ioend)
> -{
> -	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
> -	struct xfs_mount	*mp = ip->i_mount;
> -	bool			is_zoned = xfs_is_zoned_inode(ip);
> -	xfs_off_t		offset = ioend->io_offset;
> -	size_t			size = ioend->io_size;
> -	unsigned int		nofs_flag;
> -	int			error;
> -
> -	/*
> -	 * We can allocate memory here while doing writeback on behalf of
> -	 * memory reclaim.  To avoid memory allocation deadlocks set the
> -	 * task-wide nofs context for the following operations.
> -	 */
> -	nofs_flag = memalloc_nofs_save();
> -
> -	/*
> -	 * Just clean up the in-memory structures if the fs has been shut down.
> -	 */
> -	if (xfs_is_shutdown(mp)) {
> -		error = -EIO;
> -		goto done;
> -	}
> -
> -	/*
> -	 * Clean up all COW blocks and underlying data fork delalloc blocks on
> -	 * I/O error. The delalloc punch is required because this ioend was
> -	 * mapped to blocks in the COW fork and the associated pages are no
> -	 * longer dirty. If we don't remove delalloc blocks here, they become
> -	 * stale and can corrupt free space accounting on unmount.
> -	 */
> -	error = blk_status_to_errno(ioend->io_bio.bi_status);
> -	if (unlikely(error)) {
> -		/*
> -		 * Zoned writes update the in-core open zone accounting before
> -		 * I/O submission.  A failed write leaves that state
> -		 * inconsistent, so shut down the filesystem instead of letting
> -		 * later writers wait forever for open zone space to become
> -		 * available.
> -		 */
> -		if (is_zoned) {
> -			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> -			goto done;
> -		}
> -		if (ioend->io_flags & IOMAP_IOEND_SHARED) {
> -			ASSERT(!is_zoned);
> -			xfs_reflink_cancel_cow_range(ip, offset, size, true);
> -			xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK, offset,
> -					offset + size, NULL);
> -		}
> -		goto done;
> -	}
> -
> -	/*
> -	 * Success: commit the COW or unwritten blocks if needed.
> -	 */
> -	if (is_zoned)
> -		error = xfs_zoned_end_io(ip, offset, size, ioend->io_sector,
> -				ioend->io_private, NULLFSBLOCK);
> -	else if (ioend->io_flags & IOMAP_IOEND_SHARED)
> -		error = xfs_reflink_end_cow(ip, offset, size);
> -	else if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
> -		error = xfs_iomap_write_unwritten(ip, offset, size, false);
> -
> -	if (!error &&
> -	    !(ioend->io_flags & IOMAP_IOEND_DIRECT) &&
> -	    xfs_ioend_is_append(ioend))
> -		error = xfs_setfilesize(ip, offset, size);
> -done:
> -	if (is_zoned)
> -		xfs_ioend_put_open_zones(ioend);
> -	iomap_finish_ioends(ioend, error);
> -	memalloc_nofs_restore(nofs_flag);
> -}
> -
> -/*
> - * Finish all pending IO completions that require transactional modifications.
> - *
> - * We try to merge physical and logically contiguous ioends before completion to
> - * minimise the number of transactions we need to perform during IO completion.
> - * Both unwritten extent conversion and COW remapping need to iterate and modify
> - * one physical extent at a time, so we gain nothing by merging physically
> - * discontiguous extents here.
> - *
> - * The ioend chain length that we can be processing here is largely unbound in
> - * length and we may have to perform significant amounts of work on each ioend
> - * to complete it. Hence we have to be careful about holding the CPU for too
> - * long in this loop.
> - */
> -void
> -xfs_end_io(
> -	struct work_struct	*work)
> -{
> -	struct xfs_inode	*ip =
> -		container_of(work, struct xfs_inode, i_ioend_work);
> -	struct iomap_ioend	*ioend;
> -	struct list_head	tmp;
> -	unsigned long		flags;
> -
> -	spin_lock_irqsave(&ip->i_ioend_lock, flags);
> -	list_replace_init(&ip->i_ioend_list, &tmp);
> -	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
> -
> -	iomap_sort_ioends(&tmp);
> -	while ((ioend = list_first_entry_or_null(&tmp, struct iomap_ioend,
> -			io_list))) {
> -		list_del_init(&ioend->io_list);
> -		iomap_ioend_try_merge(ioend, &tmp);
> -		if (bio_op(&ioend->io_bio) == REQ_OP_READ)
> -			iomap_finish_ioends(ioend,
> -				blk_status_to_errno(ioend->io_bio.bi_status));
> -		else
> -			xfs_end_ioend_write(ioend);
> -		cond_resched();
> -	}
> -}
> -
> -void
> -xfs_end_bio(
> -	struct bio		*bio)
> -{
> -	struct iomap_ioend	*ioend = iomap_ioend_from_bio(bio);
> -	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
> -	struct xfs_mount	*mp = ip->i_mount;
> -	unsigned long		flags;
> -
> -	/*
> -	 * For Appends record the actually written block number and set the
> -	 * boundary flag if needed.
> -	 */
> -	if (IS_ENABLED(CONFIG_XFS_RT) && bio_is_zone_append(bio)) {
> -		ioend->io_sector = bio->bi_iter.bi_sector;
> -		xfs_mark_rtg_boundary(ioend);
> -	}
> -
> -	spin_lock_irqsave(&ip->i_ioend_lock, flags);
> -	if (list_empty(&ip->i_ioend_list))
> -		WARN_ON_ONCE(!queue_work(mp->m_unwritten_workqueue,
> -					 &ip->i_ioend_work));
> -	list_add_tail(&ioend->io_list, &ip->i_ioend_list);
> -	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
> -}
> -
>  /*
>   * We cannot cancel the ioend directly on error.  We may have already set other
>   * pages under writeback and hence we have to run I/O completion to mark the
> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> index 5a7a0f1a0b49..d5ae5c9d4c26 100644
> --- a/fs/xfs/xfs_aops.h
> +++ b/fs/xfs/xfs_aops.h
> @@ -10,6 +10,5 @@ extern const struct address_space_operations xfs_address_space_operations;
>  extern const struct address_space_operations xfs_dax_aops;
>  
>  int xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
> -void xfs_end_bio(struct bio *bio);
>  
>  #endif /* __XFS_AOPS_H__ */
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 2c19e69b93cd..c0c3a11e7ff2 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -25,7 +25,7 @@
>  #include "xfs_iomap.h"
>  #include "xfs_reflink.h"
>  #include "xfs_file.h"
> -#include "xfs_aops.h"
> +#include "xfs_ioend.h"
>  #include "xfs_zone_alloc.h"
>  #include "xfs_error.h"
>  #include "xfs_errortag.h"
> diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
> new file mode 100644
> index 000000000000..40695d18dac0
> --- /dev/null
> +++ b/fs/xfs/xfs_ioend.c
> @@ -0,0 +1,184 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2016-2025 Christoph Hellwig.
> + * All Rights Reserved.
> + */
> +#include "xfs_platform.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_inode.h"
> +#include "xfs_iomap.h"
> +#include "xfs_trace.h"
> +#include "xfs_bmap_util.h"
> +#include "xfs_reflink.h"
> +#include "xfs_zone_alloc.h"
> +#include "xfs_ioend.h"
> +
> +static void
> +xfs_ioend_put_open_zones(
> +	struct iomap_ioend	*ioend)
> +{
> +	struct iomap_ioend *tmp;
> +
> +	/*
> +	 * Put the open zone for all ioends merged into this one (if any).
> +	 */
> +	list_for_each_entry(tmp, &ioend->io_list, io_list)
> +		xfs_open_zone_put(tmp->io_private);
> +
> +	/*
> +	 * The main ioend might not have an open zone if the submission failed
> +	 * before xfs_zone_alloc_and_submit got called.
> +	 */
> +	if (ioend->io_private)
> +		xfs_open_zone_put(ioend->io_private);
> +}
> +
> +static void
> +xfs_end_ioend_write(
> +	struct iomap_ioend	*ioend)
> +{
> +	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	bool			is_zoned = xfs_is_zoned_inode(ip);
> +	xfs_off_t		offset = ioend->io_offset;
> +	size_t			size = ioend->io_size;
> +	unsigned int		nofs_flag;
> +	int			error;
> +
> +	/*
> +	 * We can allocate memory here while doing writeback on behalf of
> +	 * memory reclaim.  To avoid memory allocation deadlocks set the
> +	 * task-wide nofs context for the following operations.
> +	 */
> +	nofs_flag = memalloc_nofs_save();
> +
> +	/*
> +	 * Just clean up the in-memory structures if the fs has been shut down.
> +	 */
> +	if (xfs_is_shutdown(mp)) {
> +		error = -EIO;
> +		goto done;
> +	}
> +
> +	/*
> +	 * Clean up all COW blocks and underlying data fork delalloc blocks on
> +	 * I/O error. The delalloc punch is required because this ioend was
> +	 * mapped to blocks in the COW fork and the associated pages are no
> +	 * longer dirty. If we don't remove delalloc blocks here, they become
> +	 * stale and can corrupt free space accounting on unmount.
> +	 */
> +	error = blk_status_to_errno(ioend->io_bio.bi_status);
> +	if (unlikely(error)) {
> +		/*
> +		 * Zoned writes update the in-core open zone accounting before
> +		 * I/O submission.  A failed write leaves that state
> +		 * inconsistent, so shut down the filesystem instead of letting
> +		 * later writers wait forever for open zone space to become
> +		 * available.
> +		 */
> +		if (is_zoned) {
> +			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> +			goto done;
> +		}
> +		if (ioend->io_flags & IOMAP_IOEND_SHARED) {
> +			ASSERT(!is_zoned);
> +			xfs_reflink_cancel_cow_range(ip, offset, size, true);
> +			xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK, offset,
> +					offset + size, NULL);
> +		}
> +		goto done;
> +	}
> +
> +	/*
> +	 * Success: commit the COW or unwritten blocks if needed.
> +	 */
> +	if (is_zoned)
> +		error = xfs_zoned_end_io(ip, offset, size, ioend->io_sector,
> +				ioend->io_private, NULLFSBLOCK);
> +	else if (ioend->io_flags & IOMAP_IOEND_SHARED)
> +		error = xfs_reflink_end_cow(ip, offset, size);
> +	else if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
> +		error = xfs_iomap_write_unwritten(ip, offset, size, false);
> +
> +	if (!error &&
> +	    !(ioend->io_flags & IOMAP_IOEND_DIRECT) &&
> +	    xfs_ioend_is_append(ioend))
> +		error = xfs_setfilesize(ip, offset, size);
> +done:
> +	if (is_zoned)
> +		xfs_ioend_put_open_zones(ioend);
> +	iomap_finish_ioends(ioend, error);
> +	memalloc_nofs_restore(nofs_flag);
> +}
> +
> +/*
> + * Finish all pending IO completions that require transactional modifications.
> + *
> + * We try to merge physical and logically contiguous ioends before completion to
> + * minimise the number of transactions we need to perform during IO completion.
> + * Both unwritten extent conversion and COW remapping need to iterate and modify
> + * one physical extent at a time, so we gain nothing by merging physically
> + * discontiguous extents here.
> + *
> + * The ioend chain length that we can be processing here is largely unbound in
> + * length and we may have to perform significant amounts of work on each ioend
> + * to complete it. Hence we have to be careful about holding the CPU for too
> + * long in this loop.
> + */
> +void
> +xfs_end_io(
> +	struct work_struct	*work)
> +{
> +	struct xfs_inode	*ip =
> +		container_of(work, struct xfs_inode, i_ioend_work);
> +	struct iomap_ioend	*ioend;
> +	struct list_head	tmp;
> +	unsigned long		flags;
> +
> +	spin_lock_irqsave(&ip->i_ioend_lock, flags);
> +	list_replace_init(&ip->i_ioend_list, &tmp);
> +	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
> +
> +	iomap_sort_ioends(&tmp);
> +	while ((ioend = list_first_entry_or_null(&tmp, struct iomap_ioend,
> +			io_list))) {
> +		list_del_init(&ioend->io_list);
> +		iomap_ioend_try_merge(ioend, &tmp);
> +		if (bio_op(&ioend->io_bio) == REQ_OP_READ)
> +			iomap_finish_ioends(ioend,
> +				blk_status_to_errno(ioend->io_bio.bi_status));
> +		else
> +			xfs_end_ioend_write(ioend);
> +		cond_resched();
> +	}
> +}
> +
> +void
> +xfs_end_bio(
> +	struct bio		*bio)
> +{
> +	struct iomap_ioend	*ioend = iomap_ioend_from_bio(bio);
> +	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	unsigned long		flags;
> +
> +	/*
> +	 * For Appends record the actually written block number and set the
> +	 * boundary flag if needed.
> +	 */
> +	if (IS_ENABLED(CONFIG_XFS_RT) && bio_is_zone_append(bio)) {
> +		ioend->io_sector = bio->bi_iter.bi_sector;
> +		xfs_mark_rtg_boundary(ioend);
> +	}
> +
> +	spin_lock_irqsave(&ip->i_ioend_lock, flags);
> +	if (list_empty(&ip->i_ioend_list))
> +		WARN_ON_ONCE(!queue_work(mp->m_unwritten_workqueue,
> +					 &ip->i_ioend_work));
> +	list_add_tail(&ioend->io_list, &ip->i_ioend_list);
> +	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
> +}
> diff --git a/fs/xfs/xfs_ioend.h b/fs/xfs/xfs_ioend.h
> new file mode 100644
> index 000000000000..525865767fca
> --- /dev/null
> +++ b/fs/xfs/xfs_ioend.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __XFS_IOEND_H
> +#define __XFS_IOEND_H
> +
> +/*
> + * Fast and loose check if this write could update the on-disk inode size.
> + */
> +static inline bool xfs_ioend_is_append(struct iomap_ioend *ioend)
> +{
> +	return ioend->io_offset + ioend->io_size >
> +		XFS_I(ioend->io_inode)->i_disk_size;
> +}
> +
> +void xfs_end_bio(struct bio *bio);
> +
> +#endif /* __XFS_IOEND_H */
> -- 
> 2.53.0
> 
> 
