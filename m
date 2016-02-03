Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BE5447CA3
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 07:52:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 945B6304043
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 05:52:23 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2vC2FokvQ3tpeyD5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2016 05:52:18 -0800 (PST)
Date: Wed, 3 Feb 2016 08:52:16 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: don't use ioends for direct write completions
Message-ID: <20160203135216.GC20211@bfoster.bfoster>
References: <1454444257-9086-1-git-send-email-hch@lst.de>
	<1454444257-9086-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454444257-9086-3-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, darrick.wong@oracle.com, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On Tue, Feb 02, 2016 at 09:17:36PM +0100, Christoph Hellwig wrote:
> We only need to communicate two bits of information to the direct I/O
> completion handler:
> 
>  (1) do we need to convert any unwritten extents in the range
>  (2) do we need to check if we need to update the inode size based
>      on the range passed to the completion handler
> 
> We can use the private data passed to the get_block handler and the
> completion handler as a simple bitmask to communicate this information
> instead of the current complicated infrastructure reusing the ioends
> from the buffer I/O path, and thus avoiding a memory allocation and
> a context switch for any non-trivial direct write.  As a nice side
> effect we also decouple the direct I/O path implementation from that
> of the buffered I/O path.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c  | 216 ++++++++++++++++++-----------------------------------
>  fs/xfs/xfs_trace.h |   9 +--
>  2 files changed, 77 insertions(+), 148 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index c318e9f..f6b08ea 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
...
> @@ -1570,42 +1516,50 @@ xfs_get_blocks_dax_fault(
>  	return __xfs_get_blocks(inode, iblock, bh_result, create, true, true);
>  }
>  
> -static void
> -__xfs_end_io_direct_write(
> -	struct inode		*inode,
> -	struct xfs_ioend	*ioend,
> +/*
> + * Complete a direct I/O write request.
> + *
> + * xfs_map_direct passes us some flags in the private data to tell us what to
> + * do.  If not flags are set, then the write IO is an overwrite wholly within

	  "If no flags ..."

Otherwise, looks fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> + * the existing allocated file size and so there is nothing for us to do.
> + *
> + * Note that in this case the completion can be called in interrupt context,
> + * whereas if we have flags set we will always be called in task context
> + * (i.e. from a workqueue).
> + */
> +STATIC void
> +xfs_end_io_direct_write(
> +	struct kiocb		*iocb,
>  	loff_t			offset,
> -	ssize_t			size)
> +	ssize_t			size,
> +	void			*private)
>  {
> -	struct xfs_mount	*mp = XFS_I(inode)->i_mount;
> +	struct inode		*inode = file_inode(iocb->ki_filp);
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	uintptr_t		flags = (uintptr_t)private;
> +	int			error = 0;
>  
> -	if (XFS_FORCED_SHUTDOWN(mp) || ioend->io_error)
> -		goto out_end_io;
> +	trace_xfs_end_io_direct_write(ip, offset, size);
>  
> -	/*
> -	 * dio completion end_io functions are only called on writes if more
> -	 * than 0 bytes was written.
> -	 */
> -	ASSERT(size > 0);
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return;
>  
> -	/*
> -	 * The ioend only maps whole blocks, while the IO may be sector aligned.
> -	 * Hence the ioend offset/size may not match the IO offset/size exactly.
> -	 * Because we don't map overwrites within EOF into the ioend, the offset
> -	 * may not match, but only if the endio spans EOF.  Either way, write
> -	 * the IO sizes into the ioend so that completion processing does the
> -	 * right thing.
> -	 */
> -	ASSERT(offset + size <= ioend->io_offset + ioend->io_size);
> -	ioend->io_size = size;
> -	ioend->io_offset = offset;
> +	if (size <= 0)
> +		return;
>  
>  	/*
> -	 * The ioend tells us whether we are doing unwritten extent conversion
> +	 * The flags tell us whether we are doing unwritten extent conversion
>  	 * or an append transaction that updates the on-disk file size. These
>  	 * cases are the only cases where we should *potentially* be needing
>  	 * to update the VFS inode size.
> -	 *
> +	 */
> +	if (flags == 0) {
> +		ASSERT(offset + size <= i_size_read(inode));
> +		return;
> +	}
> +
> +	/*
>  	 * We need to update the in-core inode size here so that we don't end up
>  	 * with the on-disk inode size being outside the in-core inode size. We
>  	 * have no other method of updating EOF for AIO, so always do it here
> @@ -1616,57 +1570,33 @@ __xfs_end_io_direct_write(
>  	 * here can result in EOF moving backwards and Bad Things Happen when
>  	 * that occurs.
>  	 */
> -	spin_lock(&XFS_I(inode)->i_flags_lock);
> +	spin_lock(&ip->i_flags_lock);
>  	if (offset + size > i_size_read(inode))
>  		i_size_write(inode, offset + size);
> -	spin_unlock(&XFS_I(inode)->i_flags_lock);
> +	spin_unlock(&ip->i_flags_lock);
>  
> -	/*
> -	 * If we are doing an append IO that needs to update the EOF on disk,
> -	 * do the transaction reserve now so we can use common end io
> -	 * processing. Stashing the error (if there is one) in the ioend will
> -	 * result in the ioend processing passing on the error if it is
> -	 * possible as we can't return it from here.
> -	 */
> -	if (ioend->io_type == XFS_IO_OVERWRITE)
> -		ioend->io_error = xfs_setfilesize_trans_alloc(ioend);
> +	if (flags & XFS_DIO_FLAG_UNWRITTEN) {
> +		trace_xfs_end_io_direct_write_unwritten(ip, offset, size);
>  
> -out_end_io:
> -	xfs_end_io(&ioend->io_work);
> -	return;
> -}
> +		error = xfs_iomap_write_unwritten(ip, offset, size);
>  
> -/*
> - * Complete a direct I/O write request.
> - *
> - * The ioend structure is passed from __xfs_get_blocks() to tell us what to do.
> - * If no ioend exists (i.e. @private == NULL) then the write IO is an overwrite
> - * wholly within the EOF and so there is nothing for us to do. Note that in this
> - * case the completion can be called in interrupt context, whereas if we have an
> - * ioend we will always be called in task context (i.e. from a workqueue).
> - */
> -STATIC void
> -xfs_end_io_direct_write(
> -	struct kiocb		*iocb,
> -	loff_t			offset,
> -	ssize_t			size,
> -	void			*private)
> -{
> -	struct inode		*inode = file_inode(iocb->ki_filp);
> -	struct xfs_ioend	*ioend = private;
> +		WARN_ON_ONCE(error);
> +	} else if (flags & XFS_DIO_FLAG_APPEND) {
> +		struct xfs_trans *tp;
>  
> -	if (size <= 0)
> -		return;
> +		trace_xfs_end_io_direct_write_append(ip, offset, size);
>  
> -	trace_xfs_gbmap_direct_endio(XFS_I(inode), offset, size,
> -				     ioend ? ioend->io_type : 0, NULL);
> +		tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
>  
> -	if (!ioend) {
> -		ASSERT(offset + size <= i_size_read(inode));
> -		return;
> +		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_fsyncts, 0, 0);
> +		if (error) {
> +			xfs_trans_cancel(tp);
> +			WARN_ON_ONCE(error);
> +			return;
> +		}
> +		error = xfs_setfilesize(ip, tp, offset, size);
> +		WARN_ON_ONCE(error);
>  	}
> -
> -	__xfs_end_io_direct_write(inode, ioend, offset, size);
>  }
>  
>  static inline ssize_t
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 391d797..c8d5842 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1296,11 +1296,7 @@ DEFINE_IOMAP_EVENT(xfs_map_blocks_found);
>  DEFINE_IOMAP_EVENT(xfs_map_blocks_alloc);
>  DEFINE_IOMAP_EVENT(xfs_get_blocks_found);
>  DEFINE_IOMAP_EVENT(xfs_get_blocks_alloc);
> -DEFINE_IOMAP_EVENT(xfs_gbmap_direct);
> -DEFINE_IOMAP_EVENT(xfs_gbmap_direct_new);
> -DEFINE_IOMAP_EVENT(xfs_gbmap_direct_update);
> -DEFINE_IOMAP_EVENT(xfs_gbmap_direct_none);
> -DEFINE_IOMAP_EVENT(xfs_gbmap_direct_endio);
> +DEFINE_IOMAP_EVENT(xfs_get_blocks_map_direct);
>  
>  DECLARE_EVENT_CLASS(xfs_simple_io_class,
>  	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),
> @@ -1340,6 +1336,9 @@ DEFINE_SIMPLE_IO_EVENT(xfs_unwritten_convert);
>  DEFINE_SIMPLE_IO_EVENT(xfs_get_blocks_notfound);
>  DEFINE_SIMPLE_IO_EVENT(xfs_setfilesize);
>  DEFINE_SIMPLE_IO_EVENT(xfs_zero_eof);
> +DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write);
> +DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write_unwritten);
> +DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write_append);
>  
>  DECLARE_EVENT_CLASS(xfs_itrunc_class,
>  	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size),
> -- 
> 2.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
