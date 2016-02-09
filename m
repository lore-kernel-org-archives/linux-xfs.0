Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E827C29DF5
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 08:22:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C984C304043
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 06:22:29 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OlcKOAbqKwiNFF6A (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2016 06:22:28 -0800 (PST)
Date: Tue, 9 Feb 2016 09:22:26 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/5] xfs: Introduce writeback context for writepages
Message-ID: <20160209142224.GA25829@bfoster.bfoster>
References: <1454910258-7578-1-git-send-email-david@fromorbit.com>
	<1454910258-7578-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454910258-7578-3-git-send-email-david@fromorbit.com>
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

On Mon, Feb 08, 2016 at 04:44:15PM +1100, Dave Chinner wrote:
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
> index 00452cb..4453d1d 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
...
> @@ -1163,29 +1147,36 @@ xfs_vm_writepage(
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

We make the xfs_writepage_submit() error case call here because...

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
> @@ -1195,12 +1186,36 @@ redirty:
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


... the callers only call it when ret == 0. Can we eliminate the error
call down in xfs_do_writepage() and just invoke this consistently from
the writepage(s) callers?

Brian

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
