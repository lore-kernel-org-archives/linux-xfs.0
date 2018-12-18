Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58652 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbeLRVpr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 16:45:47 -0500
Date: Tue, 18 Dec 2018 13:45:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/11] xfs: remove the io_type field from the writeback
 context and ioend
Message-ID: <20181218214533.GN27208@magnolia>
References: <20181203222503.30649-1-hch@lst.de>
 <20181203222503.30649-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203222503.30649-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 03, 2018 at 05:24:54PM -0500, Christoph Hellwig wrote:
> The io_type field contains what is basically a summary of information
> from the inode fork and the imap.  But we can just as easily use that
> information directly, simplifying a few bits here and there and
> improving the trace points.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_aops.c    | 91 ++++++++++++++++++++------------------------
>  fs/xfs/xfs_aops.h    | 21 +---------
>  fs/xfs/xfs_iomap.c   |  8 ++--
>  fs/xfs/xfs_reflink.c |  2 +-
>  fs/xfs/xfs_trace.h   | 28 +++++++-------
>  5 files changed, 62 insertions(+), 88 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index d7275075878e..8fec6fd4c632 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -28,7 +28,7 @@
>   */
>  struct xfs_writepage_ctx {
>  	struct xfs_bmbt_irec    imap;
> -	unsigned int		io_type;
> +	int			fork;
>  	unsigned int		cow_seq;
>  	struct xfs_ioend	*ioend;
>  };
> @@ -255,30 +255,20 @@ xfs_end_io(
>  	 */
>  	error = blk_status_to_errno(ioend->io_bio->bi_status);
>  	if (unlikely(error)) {
> -		switch (ioend->io_type) {
> -		case XFS_IO_COW:
> +		if (ioend->io_fork == XFS_COW_FORK)
>  			xfs_reflink_cancel_cow_range(ip, offset, size, true);
> -			break;
> -		}
> -
>  		goto done;
>  	}
>  
>  	/*
> -	 * Success:  commit the COW or unwritten blocks if needed.
> +	 * Success: commit the COW or unwritten blocks if needed.
>  	 */
> -	switch (ioend->io_type) {
> -	case XFS_IO_COW:
> +	if (ioend->io_fork == XFS_COW_FORK)
>  		error = xfs_reflink_end_cow(ip, offset, size);
> -		break;
> -	case XFS_IO_UNWRITTEN:
> -		/* writeback should never update isize */
> +	else if (ioend->io_state == XFS_EXT_UNWRITTEN)
>  		error = xfs_iomap_write_unwritten(ip, offset, size, false);
> -		break;
> -	default:
> +	else
>  		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_append_trans);
> -		break;
> -	}
>  
>  done:
>  	if (ioend->io_append_trans)
> @@ -293,7 +283,8 @@ xfs_end_bio(
>  	struct xfs_ioend	*ioend = bio->bi_private;
>  	struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
>  
> -	if (ioend->io_type == XFS_IO_UNWRITTEN || ioend->io_type == XFS_IO_COW)
> +	if (ioend->io_fork == XFS_COW_FORK ||
> +	    ioend->io_state == XFS_EXT_UNWRITTEN)
>  		queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
>  	else if (ioend->io_append_trans)
>  		queue_work(mp->m_data_workqueue, &ioend->io_work);
> @@ -313,7 +304,6 @@ xfs_map_blocks(
>  	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset), end_fsb;
>  	xfs_fileoff_t		cow_fsb = NULLFILEOFF;
>  	struct xfs_bmbt_irec	imap;
> -	int			whichfork = XFS_DATA_FORK;
>  	struct xfs_iext_cursor	icur;
>  	bool			imap_valid;
>  	int			error = 0;
> @@ -350,7 +340,7 @@ xfs_map_blocks(
>  		     offset_fsb < wpc->imap.br_startoff + wpc->imap.br_blockcount;
>  	if (imap_valid &&
>  	    (!xfs_inode_has_cow_data(ip) ||
> -	     wpc->io_type == XFS_IO_COW ||
> +	     wpc->fork == XFS_COW_FORK ||
>  	     wpc->cow_seq == READ_ONCE(ip->i_cowfp->if_seq)))
>  		return 0;
>  
> @@ -382,6 +372,9 @@ xfs_map_blocks(
>  	if (cow_fsb != NULLFILEOFF && cow_fsb <= offset_fsb) {
>  		wpc->cow_seq = READ_ONCE(ip->i_cowfp->if_seq);
>  		xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +
> +		wpc->fork = XFS_COW_FORK;
> +
>  		/*
>  		 * Truncate can race with writeback since writeback doesn't
>  		 * take the iolock and truncate decreases the file size before
> @@ -394,11 +387,13 @@ xfs_map_blocks(
>  		 * will kill the contents anyway.
>  		 */
>  		if (offset > i_size_read(inode)) {
> -			wpc->io_type = XFS_IO_HOLE;
> +			wpc->imap.br_blockcount = end_fsb - offset_fsb;
> +			wpc->imap.br_startoff = offset_fsb;
> +			wpc->imap.br_startblock = HOLESTARTBLOCK;
> +			wpc->imap.br_state = XFS_EXT_NORM;
>  			return 0;
>  		}
> -		whichfork = XFS_COW_FORK;
> -		wpc->io_type = XFS_IO_COW;
> +
>  		goto allocate_blocks;
>  	}
>  
> @@ -419,12 +414,14 @@ xfs_map_blocks(
>  		imap.br_startoff = end_fsb;	/* fake a hole past EOF */
>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  
> +	wpc->fork = XFS_DATA_FORK;
> +
>  	if (imap.br_startoff > offset_fsb) {
>  		/* landed in a hole or beyond EOF */
>  		imap.br_blockcount = imap.br_startoff - offset_fsb;
>  		imap.br_startoff = offset_fsb;
>  		imap.br_startblock = HOLESTARTBLOCK;
> -		wpc->io_type = XFS_IO_HOLE;
> +		imap.br_state = XFS_EXT_NORM;
>  	} else {
>  		/*
>  		 * Truncate to the next COW extent if there is one.  This is the
> @@ -436,30 +433,23 @@ xfs_map_blocks(
>  		    cow_fsb < imap.br_startoff + imap.br_blockcount)
>  			imap.br_blockcount = cow_fsb - imap.br_startoff;
>  
> -		if (isnullstartblock(imap.br_startblock)) {
> -			/* got a delalloc extent */
> -			wpc->io_type = XFS_IO_DELALLOC;
> +		/* got a delalloc extent? */
> +		if (isnullstartblock(imap.br_startblock))
>  			goto allocate_blocks;
> -		}
> -
> -		if (imap.br_state == XFS_EXT_UNWRITTEN)
> -			wpc->io_type = XFS_IO_UNWRITTEN;
> -		else
> -			wpc->io_type = XFS_IO_OVERWRITE;
>  	}
>  
>  	wpc->imap = imap;
> -	trace_xfs_map_blocks_found(ip, offset, count, wpc->io_type, &imap);
> +	trace_xfs_map_blocks_found(ip, offset, count, wpc->fork, &imap);
>  	return 0;
>  allocate_blocks:
> -	error = xfs_iomap_write_allocate(ip, whichfork, offset, &imap,
> +	error = xfs_iomap_write_allocate(ip, wpc->fork, offset, &imap,
>  			&wpc->cow_seq);
>  	if (error)
>  		return error;
> -	ASSERT(whichfork == XFS_COW_FORK || cow_fsb == NULLFILEOFF ||
> +	ASSERT(wpc->fork == XFS_COW_FORK || cow_fsb == NULLFILEOFF ||
>  	       imap.br_startoff + imap.br_blockcount <= cow_fsb);
>  	wpc->imap = imap;
> -	trace_xfs_map_blocks_alloc(ip, offset, count, wpc->io_type, &imap);
> +	trace_xfs_map_blocks_alloc(ip, offset, count, wpc->fork, &imap);
>  	return 0;
>  }
>  
> @@ -484,7 +474,7 @@ xfs_submit_ioend(
>  	int			status)
>  {
>  	/* Convert CoW extents to regular */
> -	if (!status && ioend->io_type == XFS_IO_COW) {
> +	if (!status && ioend->io_fork == XFS_COW_FORK) {
>  		/*
>  		 * Yuk. This can do memory allocation, but is not a
>  		 * transactional operation so everything is done in GFP_KERNEL
> @@ -502,7 +492,8 @@ xfs_submit_ioend(
>  
>  	/* Reserve log space if we might write beyond the on-disk inode size. */
>  	if (!status &&
> -	    ioend->io_type != XFS_IO_UNWRITTEN &&
> +	    (ioend->io_fork == XFS_COW_FORK ||
> +	     ioend->io_state != XFS_EXT_UNWRITTEN) &&
>  	    xfs_ioend_is_append(ioend) &&
>  	    !ioend->io_append_trans)
>  		status = xfs_setfilesize_trans_alloc(ioend);
> @@ -531,7 +522,8 @@ xfs_submit_ioend(
>  static struct xfs_ioend *
>  xfs_alloc_ioend(
>  	struct inode		*inode,
> -	unsigned int		type,
> +	int			fork,
> +	xfs_exntst_t		state,
>  	xfs_off_t		offset,
>  	struct block_device	*bdev,
>  	sector_t		sector)
> @@ -545,7 +537,8 @@ xfs_alloc_ioend(
>  
>  	ioend = container_of(bio, struct xfs_ioend, io_inline_bio);
>  	INIT_LIST_HEAD(&ioend->io_list);
> -	ioend->io_type = type;
> +	ioend->io_fork = fork;
> +	ioend->io_state = state;
>  	ioend->io_inode = inode;
>  	ioend->io_size = 0;
>  	ioend->io_offset = offset;
> @@ -606,13 +599,15 @@ xfs_add_to_ioend(
>  	sector = xfs_fsb_to_db(ip, wpc->imap.br_startblock) +
>  		((offset - XFS_FSB_TO_B(mp, wpc->imap.br_startoff)) >> 9);
>  
> -	if (!wpc->ioend || wpc->io_type != wpc->ioend->io_type ||
> +	if (!wpc->ioend ||
> +	    wpc->fork != wpc->ioend->io_fork ||
> +	    wpc->imap.br_state != wpc->ioend->io_state ||
>  	    sector != bio_end_sector(wpc->ioend->io_bio) ||
>  	    offset != wpc->ioend->io_offset + wpc->ioend->io_size) {
>  		if (wpc->ioend)
>  			list_add(&wpc->ioend->io_list, iolist);
> -		wpc->ioend = xfs_alloc_ioend(inode, wpc->io_type, offset,
> -				bdev, sector);
> +		wpc->ioend = xfs_alloc_ioend(inode, wpc->fork,
> +				wpc->imap.br_state, offset, bdev, sector);
>  	}
>  
>  	if (!__bio_try_merge_page(wpc->ioend->io_bio, page, len, poff)) {
> @@ -721,7 +716,7 @@ xfs_writepage_map(
>  		error = xfs_map_blocks(wpc, inode, file_offset);
>  		if (error)
>  			break;
> -		if (wpc->io_type == XFS_IO_HOLE)
> +		if (wpc->imap.br_startblock == HOLESTARTBLOCK)
>  			continue;
>  		xfs_add_to_ioend(inode, file_offset, page, iop, wpc, wbc,
>  				 &submit_list);
> @@ -916,9 +911,7 @@ xfs_vm_writepage(
>  	struct page		*page,
>  	struct writeback_control *wbc)
>  {
> -	struct xfs_writepage_ctx wpc = {
> -		.io_type = XFS_IO_HOLE,
> -	};
> +	struct xfs_writepage_ctx wpc = { };
>  	int			ret;
>  
>  	ret = xfs_do_writepage(page, wbc, &wpc);
> @@ -932,9 +925,7 @@ xfs_vm_writepages(
>  	struct address_space	*mapping,
>  	struct writeback_control *wbc)
>  {
> -	struct xfs_writepage_ctx wpc = {
> -		.io_type = XFS_IO_HOLE,
> -	};
> +	struct xfs_writepage_ctx wpc = { };
>  	int			ret;
>  
>  	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> index 494b4338446e..6c2615b83c5d 100644
> --- a/fs/xfs/xfs_aops.h
> +++ b/fs/xfs/xfs_aops.h
> @@ -8,30 +8,13 @@
>  
>  extern struct bio_set xfs_ioend_bioset;
>  
> -/*
> - * Types of I/O for bmap clustering and I/O completion tracking.
> - */
> -enum {
> -	XFS_IO_HOLE,		/* covers region without any block allocation */
> -	XFS_IO_DELALLOC,	/* covers delalloc region */
> -	XFS_IO_UNWRITTEN,	/* covers allocated but uninitialized data */
> -	XFS_IO_OVERWRITE,	/* covers already allocated extent */
> -	XFS_IO_COW,		/* covers copy-on-write extent */
> -};
> -
> -#define XFS_IO_TYPES \
> -	{ XFS_IO_HOLE,			"hole" },	\
> -	{ XFS_IO_DELALLOC,		"delalloc" },	\
> -	{ XFS_IO_UNWRITTEN,		"unwritten" },	\
> -	{ XFS_IO_OVERWRITE,		"overwrite" },	\
> -	{ XFS_IO_COW,			"CoW" }
> -
>  /*
>   * Structure for buffered I/O completions.
>   */
>  struct xfs_ioend {
>  	struct list_head	io_list;	/* next ioend in chain */
> -	unsigned int		io_type;	/* delalloc / unwritten */
> +	int			io_fork;	/* inode fork written back */
> +	xfs_exntst_t		io_state;	/* extent state */
>  	struct inode		*io_inode;	/* file being written to */
>  	size_t			io_size;	/* size of the extent */
>  	xfs_off_t		io_offset;	/* offset in the file */
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 27c93b5f029d..32a7c169e096 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -575,7 +575,7 @@ xfs_file_iomap_begin_delay(
>  				goto out_unlock;
>  		}
>  
> -		trace_xfs_iomap_found(ip, offset, count, 0, &got);
> +		trace_xfs_iomap_found(ip, offset, count, XFS_DATA_FORK, &got);
>  		goto done;
>  	}
>  
> @@ -647,7 +647,7 @@ xfs_file_iomap_begin_delay(
>  	 * them out if the write happens to fail.
>  	 */
>  	iomap->flags |= IOMAP_F_NEW;
> -	trace_xfs_iomap_alloc(ip, offset, count, 0, &got);
> +	trace_xfs_iomap_alloc(ip, offset, count, XFS_DATA_FORK, &got);
>  done:
>  	if (isnullstartblock(got.br_startblock))
>  		got.br_startblock = DELAYSTARTBLOCK;
> @@ -1139,7 +1139,7 @@ xfs_file_iomap_begin(
>  		return error;
>  
>  	iomap->flags |= IOMAP_F_NEW;
> -	trace_xfs_iomap_alloc(ip, offset, length, 0, &imap);
> +	trace_xfs_iomap_alloc(ip, offset, length, XFS_DATA_FORK, &imap);
>  
>  out_finish:
>  	if (xfs_ipincount(ip) && (ip->i_itemp->ili_fsync_fields
> @@ -1155,7 +1155,7 @@ xfs_file_iomap_begin(
>  out_found:
>  	ASSERT(nimaps);
>  	xfs_iunlock(ip, lockmode);
> -	trace_xfs_iomap_found(ip, offset, length, 0, &imap);
> +	trace_xfs_iomap_found(ip, offset, length, XFS_DATA_FORK, &imap);
>  	goto out_finish;
>  
>  out_unlock:
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 322a852ce284..a8c32632090c 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1148,7 +1148,7 @@ xfs_reflink_remap_blocks(
>  			break;
>  		ASSERT(nimaps == 1);
>  
> -		trace_xfs_reflink_remap_imap(src, srcoff, len, XFS_IO_OVERWRITE,
> +		trace_xfs_reflink_remap_imap(src, srcoff, len, XFS_DATA_FORK,
>  				&imap);
>  
>  		/* Translate imap into the destination file. */
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 8a6532aae779..870865913bd8 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1210,15 +1210,15 @@ DEFINE_READPAGE_EVENT(xfs_vm_readpages);
>  
>  DECLARE_EVENT_CLASS(xfs_imap_class,
>  	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,
> -		 int type, struct xfs_bmbt_irec *irec),
> -	TP_ARGS(ip, offset, count, type, irec),
> +		 int whichfork, struct xfs_bmbt_irec *irec),
> +	TP_ARGS(ip, offset, count, whichfork, irec),
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(xfs_ino_t, ino)
>  		__field(loff_t, size)
>  		__field(loff_t, offset)
>  		__field(size_t, count)
> -		__field(int, type)
> +		__field(int, whichfork)
>  		__field(xfs_fileoff_t, startoff)
>  		__field(xfs_fsblock_t, startblock)
>  		__field(xfs_filblks_t, blockcount)
> @@ -1229,33 +1229,33 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
>  		__entry->size = ip->i_d.di_size;
>  		__entry->offset = offset;
>  		__entry->count = count;
> -		__entry->type = type;
> +		__entry->whichfork = whichfork;
>  		__entry->startoff = irec ? irec->br_startoff : 0;
>  		__entry->startblock = irec ? irec->br_startblock : 0;
>  		__entry->blockcount = irec ? irec->br_blockcount : 0;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx size 0x%llx offset 0x%llx count %zd "
> -		  "type %s startoff 0x%llx startblock %lld blockcount 0x%llx",
> +		  "fork %s startoff 0x%llx startblock %lld blockcount 0x%llx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->size,
>  		  __entry->offset,
>  		  __entry->count,
> -		  __print_symbolic(__entry->type, XFS_IO_TYPES),
> +		  __entry->whichfork == XFS_COW_FORK ? "cow" : "data",
>  		  __entry->startoff,
>  		  (int64_t)__entry->startblock,
>  		  __entry->blockcount)
>  )
>  
> -#define DEFINE_IOMAP_EVENT(name)	\
> +#define DEFINE_IMAP_EVENT(name)	\
>  DEFINE_EVENT(xfs_imap_class, name,	\
>  	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,	\
> -		 int type, struct xfs_bmbt_irec *irec),		\
> -	TP_ARGS(ip, offset, count, type, irec))
> -DEFINE_IOMAP_EVENT(xfs_map_blocks_found);
> -DEFINE_IOMAP_EVENT(xfs_map_blocks_alloc);
> -DEFINE_IOMAP_EVENT(xfs_iomap_alloc);
> -DEFINE_IOMAP_EVENT(xfs_iomap_found);
> +		 int whichfork, struct xfs_bmbt_irec *irec),		\
> +	TP_ARGS(ip, offset, count, whichfork, irec))
> +DEFINE_IMAP_EVENT(xfs_map_blocks_found);
> +DEFINE_IMAP_EVENT(xfs_map_blocks_alloc);
> +DEFINE_IMAP_EVENT(xfs_iomap_alloc);
> +DEFINE_IMAP_EVENT(xfs_iomap_found);
>  
>  DECLARE_EVENT_CLASS(xfs_simple_io_class,
>  	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),
> @@ -3055,7 +3055,7 @@ DEFINE_EVENT(xfs_inode_irec_class, name, \
>  DEFINE_INODE_EVENT(xfs_reflink_set_inode_flag);
>  DEFINE_INODE_EVENT(xfs_reflink_unset_inode_flag);
>  DEFINE_ITRUNC_EVENT(xfs_reflink_update_inode_size);
> -DEFINE_IOMAP_EVENT(xfs_reflink_remap_imap);
> +DEFINE_IMAP_EVENT(xfs_reflink_remap_imap);
>  TRACE_EVENT(xfs_reflink_remap_blocks_loop,
>  	TP_PROTO(struct xfs_inode *src, xfs_fileoff_t soffset,
>  		 xfs_filblks_t len, struct xfs_inode *dest,
> -- 
> 2.19.1
> 
