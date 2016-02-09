Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E436529DF5
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 08:23:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D347E304048
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 06:23:58 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FYHC2Dz6lH6n8QGu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2016 06:23:57 -0800 (PST)
Date: Tue, 9 Feb 2016 09:23:55 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/5] xfs: don't chain ioends during writepage submission
Message-ID: <20160209142355.GB25829@bfoster.bfoster>
References: <1454910258-7578-1-git-send-email-david@fromorbit.com>
	<1454910258-7578-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454910258-7578-6-git-send-email-david@fromorbit.com>
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

On Mon, Feb 08, 2016 at 04:44:18PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently we can build a long ioend chain during ->writepages that
> gets attached to the writepage context. IO submission only then
> occurs when we finish all the writepage processing. This means we
> can have many ioends allocated and pending, and this violates the
> mempool guarantees that we need to give about forwards progress.
> i.e. we really should only have one ioend being built at a time,
> otherwise we may drain the mempool trying to allocate a new ioend
> and that blocks submission, completion and freeing of ioends that
> are already in progress.
> 
> To prevent this situation from happening, we need to submit ioends
> for IO as soon as they are ready for dispatch rather than queuing
> them for later submission. This means the ioends have bios built
> immediately and they get queued on any plug that is current active.
> Hence if we schedule away from writeback, the ioends that have been
> built will make forwards progress due to the plug flushing on
> context switch. This will also prevent context switches from
> creating unnecessary IO submission latency.
> 
> We can't completely avoid having nested IO allocation - when we have
> a block size smaller than a page size, we still need to hold the
> ioend submission until after we have marked the current page dirty.
> Hence we may need multiple ioends to be held while the current page
> is completely mapped and made ready for IO dispatch. We cannot avoid
> this problem - the current code already has this ioend chaining
> within a page so we can mostly ignore that it occurs.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_aops.c | 94 ++++++++++++++++++++++++++++---------------------------
>  1 file changed, 48 insertions(+), 46 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index e5b8214..852ecf2 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
...
> @@ -738,29 +726,22 @@ xfs_writepage_submit(
>  	struct writeback_control *wbc,
>  	int			status)
>  {
> -	struct blk_plug		plug;
> -
> -	/* Reserve log space if we might write beyond the on-disk inode size. */
> -	if (!status && wpc->ioend && wpc->ioend->io_type != XFS_IO_UNWRITTEN &&
> -	    xfs_ioend_is_append(wpc->ioend))
> -		status = xfs_setfilesize_trans_alloc(wpc->ioend);
> -
> -	if (wpc->iohead) {
> -		blk_start_plug(&plug);
> -		xfs_submit_ioend(wbc, wpc->iohead, status);
> -		blk_finish_plug(&plug);
> -	}

We've dropped our plug here but I don't see anything added in
xfs_vm_writepages(). Shouldn't we have one there now that ioends are
submitted as we go? generic_writepages() uses one around its
write_cache_pages() call..

> +	if (wpc->ioend)
> +		xfs_submit_ioend(wbc, wpc->ioend, status);
>  	return status;
>  }
>  
>  static int
>  xfs_writepage_map(
>  	struct xfs_writepage_ctx *wpc,
> +	struct writeback_control *wbc,
>  	struct inode		*inode,
>  	struct page		*page,
>  	loff_t			offset,
>  	__uint64_t              end_offset)
>  {
> +	struct xfs_ioend	*ioend_to_submit = NULL;
> +	struct xfs_ioend	*ioend_tail = NULL;
>  	struct buffer_head	*bh, *head;
>  	ssize_t			len = 1 << inode->i_blkbits;
>  	int			error = 0;
> @@ -827,23 +808,37 @@ xfs_writepage_map(
>  							 offset);
>  		}
>  		if (wpc->imap_valid) {
> +			struct xfs_ioend *ioend;
> +
>  			lock_buffer(bh);
>  			if (wpc->io_type != XFS_IO_OVERWRITE)
>  				xfs_map_at_offset(inode, bh, &wpc->imap, offset);
> -			xfs_add_to_ioend(inode, bh, offset, wpc);

"Big picture" comment here please, i.e. something along the lines of
(feel free to rewrite/fix/enhance):

"This implements an immediate ioend submission policy. If a new ioend is
required, the old ioend is returned and slated for submission on
function exit. The purpose of this policy is to avoid creating and
holding large chains of ioend objects in memory. While ioends are
submitted immediately after they are completed, block plugging helps
provide batching."

> +			ioend = xfs_add_to_ioend(inode, bh, offset, wpc);
> +			if (ioend) {
> +				ioend->io_list = NULL;
> +				if (!ioend_to_submit)
> +					ioend_to_submit = ioend;
> +				else
> +					ioend_tail->io_list = ioend;
> +				ioend_tail = ioend;
> +			}
>  			count++;
>  		}
>  
> -		if (!wpc->iohead)
> -			wpc->iohead = wpc->ioend;
> -
>  	} while (offset += len, ((bh = bh->b_this_page) != head));
>  
>  	if (uptodate && bh == head)
>  		SetPageUptodate(page);
>  
>  	xfs_start_page_writeback(page, 1, count);
> -	ASSERT(wpc->iohead || !count);
> +	ASSERT(wpc->ioend || !count);
> +	while (ioend_to_submit) {
> +		struct xfs_ioend *next = ioend_to_submit->io_list;
> +
> +		ioend_to_submit->io_list = NULL;
> +		xfs_submit_ioend(wbc, ioend_to_submit, 0);
> +		ioend_to_submit = next;
> +	}
>  	return 0;
>  
>  out_error:
> @@ -853,9 +848,16 @@ out_error:
>  	 * ioend, then we can't touch it here and need to rely on IO submission
>  	 * to unlock it.
>  	 */
> -	if (count)
> +	if (count) {
>  		xfs_start_page_writeback(page, 0, count);
> -	else {
> +		while (ioend_to_submit) {
> +			struct xfs_ioend *next = ioend_to_submit->io_list;
> +
> +			ioend_to_submit->io_list = NULL;
> +			xfs_submit_ioend(wbc, ioend_to_submit, 0);
> +			ioend_to_submit = next;
> +		}
> +	} else {
>  		xfs_aops_discard_page(page);
>  		ClearPageUptodate(page);
>  		unlock_page(page);

If we have an error and count == 0, we know that ioend_to_submit is NULL
because that is only potentially set once the first buffer is added.
That said, this doesn't mean that we don't have an ioend waiting on the
wpc. If we do, we still return the error and the ioend is errored out.

I wonder if that is really necessary if we haven't added any buffers
from the page..? Could we submit the ioend properly in that case? OTOH,
that might complicate the error reporting and an error here might be
serious enough that it isn't worth it, as opposed to just making sure we
clean up everything appropriately.

Brian

> @@ -975,14 +977,14 @@ xfs_do_writepage(
>  		end_offset = offset;
>  	}
>  
> -	error = xfs_writepage_map(wpc, inode, page, offset, end_offset);
> +	error = xfs_writepage_map(wpc, wbc, inode, page, offset, end_offset);
>  	if (error)
>  		goto out_error;
>  	return 0;
>  
>  out_error:
>  	/*
> -	 * We have to fail the iohead here because we buffers locked in the
> +	 * We have to fail the ioend here because we buffers locked in the
>  	 * ioend chain. If we don't do this, we'll deadlock invalidating the
>  	 * page as that tries to lock the buffers on the page. Also, because we
>  	 * have set pages under writeback, we have to run IO completion to mark
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
