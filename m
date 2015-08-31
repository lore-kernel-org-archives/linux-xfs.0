Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9BBDA7F47
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 13:02:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7C5288F804B
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 11:02:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WB3qEWNkey6eAQGN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 31 Aug 2015 11:02:25 -0700 (PDT)
Date: Mon, 31 Aug 2015 14:02:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs: Introduce writeback context for writepages
Message-ID: <20150831180221.GA16371@bfoster.bfoster>
References: <1440479153-1584-1-git-send-email-david@fromorbit.com>
	<1440479153-1584-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1440479153-1584-3-git-send-email-david@fromorbit.com>
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

On Tue, Aug 25, 2015 at 03:05:51PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_vm_writepages() calls generic_writepages to writeback a range of
> a file, but then xfs_vm_writepage() clusters pages itself as it does
> not have any context it can pass between->writepage calls from
> __write_cache_pages().
> 
> Introduce a writeback context for xfs_vm_writepages() and call
> __write_cache_pages directly with our own writepage callback so that
> we can pass that context to each writepage invocation. This
> encapsulates the current mapping, whether it is valid or not, the
> current ioend and it's IO type and the ioend chain being built.
> 
> This requires us to move the ioend submission up to the level where
> the writepage context is declared. This does mean we do not submit
> IO until we packaged the entire writeback range, but with the block
> plugging in the writepages call this is the way IO is submitted,
> anyway.
> 

Ok, but the comment for blk_start_plug() mentions some kind of flush on
task sleep mechanism. I could be wrong, but I take this to mean there
are cases where I/O can initiate before the plug is stopped. Does
deferring the I/O submission across writepages defeat that heuristic in
any way? My (preliminary) understanding is that while the I/O submission
would still be deferred by the plug in the same way in most cases, we're
potentially holding back I/Os from the block infrastructure until the
entire writepages sequence is complete.

> It also means that we need to handle discontiguous page ranges.  If
> the pages sent down by write_cache_pages to the writepage callback
> are discontiguous, we need to detect this and put each discontiguous
> page range into individual ioends. This is needed to ensure that the
> ioend accurately represents the range of the file that it covers so
> that file size updates during IO completion set the size correctly.
> Failure to take into account the discontiguous ranges results in
> files being too small when writeback patterns are non-sequential.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_aops.c | 277 ++++++++++++++++++++++++++++--------------------------
>  1 file changed, 146 insertions(+), 131 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 89fad6b..93bf13c 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -36,6 +36,18 @@
>  #include <linux/pagevec.h>
>  #include <linux/writeback.h>
>  
...
> @@ -1151,29 +1135,36 @@ xfs_vm_writepage(
>  		if (end_index > last_index)
>  			end_index = last_index;
>  
> -		xfs_cluster_write(inode, page->index + 1, &imap, &ioend,
> -				  wbc, end_index);
> +		xfs_cluster_write(inode, page->index + 1, wpc, wbc, end_index);
>  	}
>  
> -
> -	/*
> -	 * Reserve log space if we might write beyond the on-disk inode size.
> -	 */
> -	err = 0;
> -	if (ioend->io_type != XFS_IO_UNWRITTEN && xfs_ioend_is_append(ioend))
> -		err = xfs_setfilesize_trans_alloc(ioend);
> -
> -	xfs_submit_ioend(wbc, iohead, err);
> -
>  	return 0;
>  
>  error:
> -	if (iohead)
> -		xfs_cancel_ioend(iohead);
> +	/*
> +	 * We have to fail the iohead here because we buffers locked in the
> +	 * ioend chain. If we don't do this, we'll deadlock invalidating the
> +	 * page as that tries to lock the buffers on the page. Also, because we
> +	 * have set pages under writeback, we have to run IO completion to mark
> +	 * the error state of the IO appropriately, so we can't cancel the ioend
> +	 * directly here. That means we have to mark this page as under
> +	 * writeback if we included any buffers from it in the ioend chain.
> +	 */
> +	if (count)
> +		xfs_start_page_writeback(page, 0, count);
> +	xfs_writepage_submit(wpc, wbc, err);

What are the error handling ramifications here for the previous, pending
ioends? Previously, it looks like we would either fail in
xfs_map_blocks() or submit I/O for each extent mapping. In other words,
errors were not taken into consideration by the time we get into/past
xfs_cluster_write().

Now it looks as though writepages carries on chaining ioends until we're
done or hit an error, and then the entire ioend chain is subject to the
error. I suppose a mapping error here is indicative of a larger problem,
but do we really want to fail the entire writeback here? (If nothing
else, the comments above should probably touch on this case).

Brian

>  
> -	xfs_aops_discard_page(page);
> -	ClearPageUptodate(page);
> -	unlock_page(page);
> +	/*
> +	 * We can only discard the page we had the IO error on if we haven't
> +	 * included it in the ioend above. If it has already been errored out,
> +	 * the it is unlocked and we can't touch it here.
> +	 */
> +	if (!count) {
> +		xfs_aops_discard_page(page);
> +		ClearPageUptodate(page);
> +		unlock_page(page);
> +	}
> +	mapping_set_error(page->mapping, err);
>  	return err;
>  
>  redirty:
> @@ -1183,12 +1174,36 @@ redirty:
>  }
>  
>  STATIC int
> +xfs_vm_writepage(
> +	struct page		*page,
> +	struct writeback_control *wbc)
> +{
> +	struct xfs_writepage_ctx wpc = {
> +		.io_type = XFS_IO_OVERWRITE,
> +	};
> +	int			ret;
> +
> +	ret = xfs_do_writepage(page, wbc, &wpc);
> +	if (ret)
> +		return ret;
> +	return xfs_writepage_submit(&wpc, wbc, ret);
> +}
> +
> +STATIC int
>  xfs_vm_writepages(
>  	struct address_space	*mapping,
>  	struct writeback_control *wbc)
>  {
> +	struct xfs_writepage_ctx wpc = {
> +		.io_type = XFS_IO_OVERWRITE,
> +	};
> +	int			ret;
> +
>  	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
> -	return generic_writepages(mapping, wbc);
> +	ret = write_cache_pages(mapping, wbc, xfs_do_writepage, &wpc);
> +	if (ret)
> +		return ret;
> +	return xfs_writepage_submit(&wpc, wbc, ret);
>  }
>  
>  /*
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
