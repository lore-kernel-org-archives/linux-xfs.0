Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8C51D7F47
	for <xfs@oss.sgi.com>; Sat, 11 Apr 2015 16:15:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7C47B8F8049
	for <xfs@oss.sgi.com>; Sat, 11 Apr 2015 14:15:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ryCYOr2oyA23UjpW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 11 Apr 2015 14:15:22 -0700 (PDT)
Date: Sat, 11 Apr 2015 17:15:18 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/5] xfs: direct IO needs to use append ioends
Message-ID: <20150411211517.GB4039@bfoster.bfoster>
References: <1428673080-23052-1-git-send-email-david@fromorbit.com>
	<1428673080-23052-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1428673080-23052-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 10, 2015 at 11:37:57PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now we have an ioend being passed unconditionally to the direct IO
> write completion context, we can pass a preallocated transaction
> handle for on-disk inode size updates that are run in completion.
> 
> At this point we really need to be passing the correct block range
> that the IO spans through the ioend, so calculate the last block in
> the mapping before we map the allocated range and use that instead
> of the size desired by the direct IO.
> 
> This enables us to keep track of multiple get-blocks calls in the
> same direct IO - the ioend will keep coming back to us, and we can
> keep extending it's range as new allocations and mappings are done.
> 
> There are some new trace points added for debugging, and a small
> hack to actually make the tracepoints work (enums in tracepoints
> that use __print_symbolic don't work correctly) that should be fixed
> in the 4.1 merge window. THis hack can be removed when the
> tracepoint fix is upstream.
> 
> There are lots of comments explaining the intricacies of passing the
> ioend and append transaction in the code; they are better placed in
> the code because we're going to need them to understand why this
> code does what it does in a few years time....
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_aops.c  | 262 +++++++++++++++++++++++++++++++++++++----------------
>  fs/xfs/xfs_trace.h |  10 +-
>  2 files changed, 194 insertions(+), 78 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index d95a42b..52c7e46 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -178,6 +178,25 @@ xfs_setfilesize_ioend(
>  	return xfs_setfilesize(ip, tp, ioend->io_offset, ioend->io_size);
>  }
>  
> +STATIC void
> +xfs_setfilesize_ioend_cancel(
> +	struct xfs_ioend	*ioend)
> +{
> +	struct xfs_trans	*tp = ioend->io_append_trans;
> +
> +	/*
> +	 * The transaction may have been allocated in the I/O submission thread,
> +	 * thus we need to mark ourselves as being in a transaction manually.
> +	 * Similarly for freeze protection.
> +	 */

This threw me off at first because we can call this from either the
submission or the completion context, unlike the commit case where this
comment is copied from. Could we move the comment above the function and
clarify a bit? E.g., something like the following is a bit more clear to
me:

/*
 * The process transaction and freeze protection state is cleared immediately
 * after setfilesize transaction allocation to support transfer of the tp from
 * submission to completion context. Restore the context appropriately to cancel
 * the transaction.
 */

> +	current_set_flags_nested(&tp->t_pflags, PF_FSTRANS);
> +	rwsem_acquire_read(&ioend->io_inode->i_sb->s_writers.lock_map[SB_FREEZE_FS-1],
> +			   0, 1, _THIS_IP_);
> +
> +	xfs_trans_cancel(tp, 0);
> +	ioend->io_append_trans = NULL;
> +}
> +
>  /*
>   * Schedule IO completion handling on the final put of an ioend.
>   *
> @@ -1233,18 +1252,18 @@ xfs_vm_releasepage(
>  	return try_to_free_buffers(page);
>  }
>  
> -static void
> +static int
>  xfs_get_blocks_map_buffer(
>  	struct inode		*inode,
>  	struct buffer_head	*bh_result,
>  	int			create,
>  	int			direct,
>  	struct xfs_bmbt_irec	*imap,
> -	xfs_off_t		offset,
> -	ssize_t			size)
> +	xfs_off_t		offset)
>  {
>  	struct xfs_ioend	*ioend;
>  	int			type;
> +	loff_t			size;
>  
>  	if (!create) {
>  		/*
> @@ -1253,7 +1272,7 @@ xfs_get_blocks_map_buffer(
>  		 */
>  		if (!ISUNWRITTEN(imap))
>  			xfs_map_buffer(inode, bh_result, imap, offset);
> -		return;
> +		return 0;
>  	}
>  
>  	xfs_map_buffer(inode, bh_result, imap, offset);
> @@ -1262,26 +1281,93 @@ xfs_get_blocks_map_buffer(
>  		set_buffer_unwritten(bh_result);
>  
>  	if (!direct)
> -		return;
> +		return 0;
>  
>  	/*
> -	 * Direct IO writes require an ioend to be allocated and
> -	 * passed via the returned mapping. This allows the end
> -	 * io function to determine the correct course of
> -	 * action.
> +	 * Direct IO writes require an ioend to be allocated and passed via the
> +	 * returned mapping. This allows the end io function to determine the
> +	 * correct course of action.
> +	 *
> +	 * Unwritten extents will need transactions at completion, so is known
> +	 * to need deferring to a workqueue. However, for writes into written
> +	 * extents, we *may* need a transaction if this IO extends the on-disk
> +	 * EOF. Because we can race with other IOs the file may already be
> +	 * extended by the time we get to the transaction. IO completion already
> +	 * handles that case so all we will have done is incurred the overhead
> +	 * of workqueue deferral for completion. This is acceptable overhead for
> +	 * the rare case that this occurs.
>  	 */
> -
>  	if (ISUNWRITTEN(imap)) {
>  		type = XFS_IO_UNWRITTEN;
>  		set_buffer_defer_completion(bh_result);
>  	} else
>  		type = XFS_IO_OVERWRITE;
> -	ioend = xfs_alloc_ioend(inode, type);
> -	ioend->io_offset = offset;
> -	ioend->io_size = size;
> -	bh_result->b_private = ioend;
>  
> -	return;
> +	/*
> +	 * The offset that is passed in is the first block the DIO will fall
> +	 * into. The size supplied by the DIO layer is what it thinks it needs
> +	 * but the mapping may not span this entire range. Hence we use the
> +	 * truncated mapping size that's already been stashed in the bh_result
> +	 * to calculate the range covered by the ioend.
> +	 */
> +	size = bh_result->b_size;
> +	trace_xfs_gbmap_direct(XFS_I(inode), offset, size, type, imap);
> +
> +	/*
> +	 * If we get multiple mappings to in a single IO, we might be mapping
> +	 * dfferent types. But because the direct IO can only have a single

	   different

> +	 * private pointer, we need to ensure that:
> +	 *
> +	 * a) the ioend spans the entire region of the IO; and
> +	 * b) if it contains unwritten extents, it is *permanently* marked as
> +	 *    such and we cancel any append transaction attached to the ioend.
> +	 *
> +	 * We could do this by chaining ioends like buffered IO does, but
> +	 * we only actually get one IO completion callback from the direct IO,
> +	 * and that spans the entire IO regardless of how many mappings and IOs
> +	 * are needed to complete the DIO. There is only going to be one
> +	 * reference to the ioend and it's life cycle is constrained by the
> +	 * DIO completion code. hence we don't need reference counting here.
> +	 */
> +	if (bh_result->b_private) {
> +		ioend = bh_result->b_private;
> +		ASSERT(ioend->io_size > 0);
> +		ASSERT(offset >= ioend->io_offset);
> +
> +		if (offset + size > ioend->io_offset + ioend->io_size)
> +			ioend->io_size = offset - ioend->io_offset + size;
> +
> +		if (type == XFS_IO_UNWRITTEN) {

		if (type == XFS_IO_UNWRITTEN &&
		    ioend->io_type != XFS_IO_UNWRITTEN)

... makes that a bit easier to follow imo.

> +			if (ioend->io_append_trans)
> +				xfs_setfilesize_ioend_cancel(ioend);
> +			ioend->io_type = XFS_IO_UNWRITTEN;
> +		}
> +		trace_xfs_gbmap_direct_update(XFS_I(inode), ioend->io_offset,
> +					      ioend->io_size, ioend->io_type,
> +					      imap);
> +	} else {
> +		ioend = xfs_alloc_ioend(inode, type);
> +		ioend->io_offset = offset;
> +		ioend->io_size = size;
> +		bh_result->b_private = ioend;
> +		trace_xfs_gbmap_direct_new(XFS_I(inode), offset, size, type,
> +					   imap);
> +	}
> +
> +	/* check if we need an append transaction allocated. */
> +	if (ioend->io_type == XFS_IO_OVERWRITE &&
> +	    xfs_ioend_is_append(ioend) && !ioend->io_append_trans) {
> +		int	error;
> +
> +		error = xfs_setfilesize_trans_alloc(ioend);

I'm not totally convinced this is safe. We previously moved this tp
allocation from before a potential xfs_iomap_direct_write() call to the
completion side to avoid nesting this allocation with unwritten extent
allocation transactions. See the following for reference:

	437a255a xfs: fix direct IO nested transaction deadlock

Now we move it after that point of the codepath, and even then we know
that this is an overwrite if we do the allocation here. If we continue
on and hit a hole, it looks like there's still a sequence to allocate
this transaction and call xfs_iomap_write_direct(), nesting the
associated transaction reservations. Am I missing something?

Brian

> +		ASSERT(!error);
> +		if (error) {
> +			xfs_destroy_ioend(ioend);
> +			return error;
> +		}
> +		set_buffer_defer_completion(bh_result);
> +	}
> +	return 0;
>  }
>  
>  STATIC int
> @@ -1374,50 +1460,19 @@ __xfs_get_blocks(
>  			xfs_iunlock(ip, lockmode);
>  		}
>  
> -		trace_xfs_get_blocks_alloc(ip, offset, size, 0, &imap);
> +		trace_xfs_get_blocks_alloc(ip, offset, size,
> +				ISUNWRITTEN(&imap) ? XFS_IO_UNWRITTEN
> +						   : XFS_IO_DELALLOC, &imap);
>  	} else if (nimaps) {
> -		trace_xfs_get_blocks_found(ip, offset, size, 0, &imap);
> +		trace_xfs_get_blocks_found(ip, offset, size,
> +				ISUNWRITTEN(&imap) ? XFS_IO_UNWRITTEN
> +						   : XFS_IO_OVERWRITE, &imap);
>  		xfs_iunlock(ip, lockmode);
>  	} else {
>  		trace_xfs_get_blocks_notfound(ip, offset, size);
>  		goto out_unlock;
>  	}
>  
> -	if (imap.br_startblock != HOLESTARTBLOCK &&
> -	    imap.br_startblock != DELAYSTARTBLOCK)
> -		xfs_get_blocks_map_buffer(inode, bh_result, create, direct,
> -					  &imap, offset, size);
> -
> -	/*
> -	 * If this is a realtime file, data may be on a different device.
> -	 * to that pointed to from the buffer_head b_bdev currently.
> -	 */
> -	bh_result->b_bdev = xfs_find_bdev_for_inode(inode);
> -
> -	/*
> -	 * If we previously allocated a block out beyond eof and we are now
> -	 * coming back to use it then we will need to flag it as new even if it
> -	 * has a disk address.
> -	 *
> -	 * With sub-block writes into unwritten extents we also need to mark
> -	 * the buffer as new so that the unwritten parts of the buffer gets
> -	 * correctly zeroed.
> -	 */
> -	if (create &&
> -	    ((!buffer_mapped(bh_result) && !buffer_uptodate(bh_result)) ||
> -	     (offset >= i_size_read(inode)) ||
> -	     (new || ISUNWRITTEN(&imap))))
> -		set_buffer_new(bh_result);
> -
> -	if (imap.br_startblock == DELAYSTARTBLOCK) {
> -		BUG_ON(direct);
> -		if (create) {
> -			set_buffer_uptodate(bh_result);
> -			set_buffer_mapped(bh_result);
> -			set_buffer_delay(bh_result);
> -		}
> -	}
> -
>  	/*
>  	 * If this is O_DIRECT or the mpage code calling tell them how large
>  	 * the mapping is, so that we can avoid repeated get_blocks calls.
> @@ -1451,6 +1506,46 @@ __xfs_get_blocks(
>  		bh_result->b_size = mapping_size;
>  	}
>  
> +	if (imap.br_startblock != HOLESTARTBLOCK &&
> +	    imap.br_startblock != DELAYSTARTBLOCK) {
> +		error = xfs_get_blocks_map_buffer(inode, bh_result, create,
> +						  direct, &imap, offset);
> +		if (error)
> +			return error;
> +	}
> +	if (create && direct)
> +		ASSERT(bh_result->b_private);
> +
> +	/*
> +	 * If this is a realtime file, data may be on a different device.
> +	 * to that pointed to from the buffer_head b_bdev currently.
> +	 */
> +	bh_result->b_bdev = xfs_find_bdev_for_inode(inode);
> +
> +	/*
> +	 * If we previously allocated a block out beyond eof and we are now
> +	 * coming back to use it then we will need to flag it as new even if it
> +	 * has a disk address.
> +	 *
> +	 * With sub-block writes into unwritten extents we also need to mark
> +	 * the buffer as new so that the unwritten parts of the buffer gets
> +	 * correctly zeroed.
> +	 */
> +	if (create &&
> +	    ((!buffer_mapped(bh_result) && !buffer_uptodate(bh_result)) ||
> +	     (offset >= i_size_read(inode)) ||
> +	     (new || ISUNWRITTEN(&imap))))
> +		set_buffer_new(bh_result);
> +
> +	if (imap.br_startblock == DELAYSTARTBLOCK) {
> +		BUG_ON(direct);
> +		if (create) {
> +			set_buffer_uptodate(bh_result);
> +			set_buffer_mapped(bh_result);
> +			set_buffer_delay(bh_result);
> +		}
> +	}
> +
>  	return 0;
>  
>  out_unlock:
> @@ -1501,38 +1596,51 @@ xfs_end_io_direct_write(
>  		goto out_destroy_ioend;
>  
>  	/*
> -	 * While the generic direct I/O code updates the inode size, it does
> -	 * so only after the end_io handler is called, which means our
> -	 * end_io handler thinks the on-disk size is outside the in-core
> -	 * size.  To prevent this just update it a little bit earlier here.
> +	 * dio completion end_io functions are only called on writes if more
> +	 * than 0 bytes was written.
>  	 */
> -	if (offset + size > i_size_read(inode))
> -		i_size_write(inode, offset + size);
> +	ASSERT(size > 0);
>  
>  	/*
> -	 * For direct I/O we do not know if we need to allocate blocks or not,
> -	 * so we can't preallocate an append transaction, as that results in
> -	 * nested reservations and log space deadlocks. Hence allocate the
> -	 * transaction here. While this is sub-optimal and can block IO
> -	 * completion for some time, we're stuck with doing it this way until
> -	 * we can pass the ioend to the direct IO allocation callbacks and
> -	 * avoid nesting that way.
> +	 * The ioend only maps whole blocks, while the IO may be sector aligned.
> +	 * Hence the ioend offset/size may not match the IO offset/size exactly,
> +	 * but should span it completely. Write the IO sizes into the ioend so
> +	 * that completion processing does the right thing.
>  	 */
> -	if (ioend->io_type == XFS_IO_UNWRITTEN && size > 0) {
> -		xfs_iomap_write_unwritten(ip, offset, size);
> -	} else if (offset + size > ip->i_d.di_size) {
> -		struct xfs_trans	*tp;
> -		int			error;
> +	ASSERT(size <= ioend->io_size);
> +	ASSERT(offset >= ioend->io_offset);
> +	ASSERT(offset + size <= ioend->io_offset + ioend->io_size);
> +	ioend->io_size = size;
> +	ioend->io_offset = offset;
>  
> -		tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
> -		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_fsyncts, 0, 0);
> -		if (error) {
> -			xfs_trans_cancel(tp, 0);
> -			goto out_destroy_ioend;
> -		}
> +	/*
> +	 * The ioend tells us whether we are doing unwritten extent conversion
> +	 * or an append transaction that updates the on-disk file size. These
> +	 * cases are the only cases where we should *potentially* be needing
> +	 * to update the VFS inode size. When the ioend indicates this, we
> +	 * are *guaranteed* to be running in non-interrupt context.
> +	 *
> +	 * We need to update the in-core inode size here so that we don't end up
> +	 * with the on-disk inode size being outside the in-core inode size.
> +	 * While we can do this in the process context after the IO has
> +	 * completed, this does not work for AIO and hence we always update
> +	 * the in-core inode size here if necessary.
> +	 */
> +	if (ioend->io_type == XFS_IO_UNWRITTEN || ioend->io_append_trans) {
> +		if (offset + size > i_size_read(inode))
> +			i_size_write(inode, offset + size);
> +	} else
> +		ASSERT(offset + size <= i_size_read(inode));
>  
> -		xfs_setfilesize(ip, tp, offset, size);
> +	/* Ugh. No way to propagate errors, so ignore them. */
> +	if (ioend->io_type == XFS_IO_UNWRITTEN) {
> +		xfs_iomap_write_unwritten(ip, offset, size);
> +	} else if (ioend->io_append_trans) {
> +		xfs_setfilesize_ioend(ioend);
> +	} else {
> +		ASSERT(!xfs_ioend_is_append(ioend));
>  	}
> +
>  out_destroy_ioend:
>  	xfs_destroy_ioend(ioend);
>  }
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index b2a45cc..a584c27 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1200,13 +1200,18 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
>  		__entry->blockcount = irec ? irec->br_blockcount : 0;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx size 0x%llx offset 0x%llx count %zd "
> -		  "type %s startoff 0x%llx startblock %lld blockcount 0x%llx",
> +		  "type %d startoff 0x%llx startblock %lld blockcount 0x%llx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->size,
>  		  __entry->offset,
>  		  __entry->count,
> +		  /*
> +		   * XXX: __print_symbolic broken for enums, fix coming in 4.1
> +		   * cycle from Mr Rostedt. Need to know type now, so...
>  		  __print_symbolic(__entry->type, XFS_IO_TYPES),
> +		   */
> +		  __entry->type,
>  		  __entry->startoff,
>  		  (__int64_t)__entry->startblock,
>  		  __entry->blockcount)
> @@ -1221,6 +1226,9 @@ DEFINE_IOMAP_EVENT(xfs_map_blocks_found);
>  DEFINE_IOMAP_EVENT(xfs_map_blocks_alloc);
>  DEFINE_IOMAP_EVENT(xfs_get_blocks_found);
>  DEFINE_IOMAP_EVENT(xfs_get_blocks_alloc);
> +DEFINE_IOMAP_EVENT(xfs_gbmap_direct);
> +DEFINE_IOMAP_EVENT(xfs_gbmap_direct_new);
> +DEFINE_IOMAP_EVENT(xfs_gbmap_direct_update);
>  
>  DECLARE_EVENT_CLASS(xfs_simple_io_class,
>  	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
