Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3CEB67F47
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 09:24:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AE694AC001
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 07:24:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ltG0HlGmmk560uIk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Apr 2015 07:24:52 -0700 (PDT)
Date: Tue, 14 Apr 2015 10:24:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/8] xfs: DIO needs an ioend for writes
Message-ID: <20150414142447.GD36198@bfoster.bfoster>
References: <1428996411-1507-1-git-send-email-david@fromorbit.com>
	<1428996411-1507-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1428996411-1507-4-git-send-email-david@fromorbit.com>
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

On Tue, Apr 14, 2015 at 05:26:46PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently we can only tell DIO completion that an IO requires
> unwritten extent completion. This is done by a hacky non-null
> private pointer passed to Io completion, but the private pointer
> does not actually contain any information that is used.
> 
> We also need to pass to IO completion the fact that the IO may be
> beyond EOF and so a size update transaction needs to be done. This
> is currently determined by checks in the io completion, but we need
> to determine if this is necessary at block mapping time as we need
> to defer the size update transactions to a completion workqueue,
> just like unwritten extent conversion.
> 
> To do this, first we need to allocate and pass an ioend to to IO

Extra 'to' in there...

> completion. Add this for unwritten extent conversion; we'll do the
> EOF updates in the next commit.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_aops.c  | 92 ++++++++++++++++++++++++++++++++++++++++++++++++------
>  fs/xfs/xfs_trace.h |  3 ++
>  2 files changed, 85 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 8f63520..e1fa926 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1234,7 +1234,23 @@ xfs_vm_releasepage(
>  }
>  
>  /*
> - * do all the direct IO specific mapping buffer manipulation here.
> + * When we map a DIO buffer, we need to attach an ioend that describes the type
> + * of write IO we are doing. This passes to the completion function the
> + * operations it needs to perform.
> + *
> + * If we get multiple mappings to in a single IO, we might be mapping dfferent

s/to//
s/dfferent/different/

> + * types. But because the direct IO can only have a single private pointer, we
> + * need to ensure that:
> + *
> + * a) the ioend spans the entire region of the IO; and
> + * b) if it contains unwritten extents, it is *permanently* marked as such
> + *
> + * We could do this by chaining ioends like buffered IO does, but we only
> + * actually get one IO completion callback from the direct IO, and that spans
> + * the entire IO regardless of how many mappings and IOs are needed to complete
> + * the DIO. There is only going to be one reference to the ioend and it's life

s/it's/its/

Reviewed-by: Brian Foster <bfoster@redhat.com>

> + * cycle is constrained by the DIO completion code. hence we don't need
> + * reference counting here.
>   */
>  static void
>  xfs_map_direct(
> @@ -1243,10 +1259,42 @@ xfs_map_direct(
>  	struct xfs_bmbt_irec	*imap,
>  	xfs_off_t		offset)
>  {
> -	if (ISUNWRITTEN(imap)) {
> -		bh_result->b_private = inode;
> -		set_buffer_defer_completion(bh_result);
> +	struct xfs_ioend	*ioend;
> +	xfs_off_t		size = bh_result->b_size;
> +	int			type;
> +
> +	if (ISUNWRITTEN(imap))
> +		type = XFS_IO_UNWRITTEN;
> +	else
> +		type = XFS_IO_OVERWRITE;
> +
> +	trace_xfs_gbmap_direct(XFS_I(inode), offset, size, type, imap);
> +
> +	if (bh_result->b_private) {
> +		ioend = bh_result->b_private;
> +		ASSERT(ioend->io_size > 0);
> +		ASSERT(offset >= ioend->io_offset);
> +		if (offset + size > ioend->io_offset + ioend->io_size)
> +			ioend->io_size = offset - ioend->io_offset + size;
> +
> +		if (type == XFS_IO_UNWRITTEN && type != ioend->io_type)
> +			ioend->io_type = XFS_IO_UNWRITTEN;
> +
> +		trace_xfs_gbmap_direct_update(XFS_I(inode), ioend->io_offset,
> +					      ioend->io_size, ioend->io_type,
> +					      imap);
> +	} else {
> +		ioend = xfs_alloc_ioend(inode, type);
> +		ioend->io_offset = offset;
> +		ioend->io_size = size;
> +		bh_result->b_private = ioend;
> +
> +		trace_xfs_gbmap_direct_new(XFS_I(inode), offset, size, type,
> +					   imap);
>  	}
> +
> +	if (ioend->io_type == XFS_IO_UNWRITTEN)
> +		set_buffer_defer_completion(bh_result);
>  }
>  
>  
> @@ -1378,10 +1426,13 @@ __xfs_get_blocks(
>  
>  			xfs_iunlock(ip, lockmode);
>  		}
> -
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
> @@ -1478,9 +1529,28 @@ xfs_end_io_direct_write(
>  	struct inode		*inode = file_inode(iocb->ki_filp);
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_ioend	*ioend = private;
>  
>  	if (XFS_FORCED_SHUTDOWN(mp))
> -		return;
> +		goto out_destroy_ioend;
> +
> +	/*
> +	 * dio completion end_io functions are only called on writes if more
> +	 * than 0 bytes was written.
> +	 */
> +	ASSERT(size > 0);
> +
> +	/*
> +	 * The ioend only maps whole blocks, while the IO may be sector aligned.
> +	 * Hence the ioend offset/size may not match the IO offset/size exactly,
> +	 * but should span it completely. Write the IO sizes into the ioend so
> +	 * that completion processing does the right thing.
> +	 */
> +	ASSERT(size <= ioend->io_size);
> +	ASSERT(offset >= ioend->io_offset);
> +	ASSERT(offset + size <= ioend->io_offset + ioend->io_size);
> +	ioend->io_size = size;
> +	ioend->io_offset = offset;
>  
>  	/*
>  	 * While the generic direct I/O code updates the inode size, it does
> @@ -1500,7 +1570,7 @@ xfs_end_io_direct_write(
>  	 * we can pass the ioend to the direct IO allocation callbacks and
>  	 * avoid nesting that way.
>  	 */
> -	if (private && size > 0) {
> +	if (ioend->io_type == XFS_IO_UNWRITTEN) {
>  		xfs_iomap_write_unwritten(ip, offset, size);
>  	} else if (offset + size > ip->i_d.di_size) {
>  		struct xfs_trans	*tp;
> @@ -1510,11 +1580,13 @@ xfs_end_io_direct_write(
>  		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_fsyncts, 0, 0);
>  		if (error) {
>  			xfs_trans_cancel(tp, 0);
> -			return;
> +			goto out_destroy_ioend;
>  		}
>  
>  		xfs_setfilesize(ip, tp, offset, size);
>  	}
> +out_destroy_ioend:
> +	xfs_destroy_ioend(ioend);
>  }
>  
>  STATIC ssize_t
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index b2a45cc..e78b64e 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1221,6 +1221,9 @@ DEFINE_IOMAP_EVENT(xfs_map_blocks_found);
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
