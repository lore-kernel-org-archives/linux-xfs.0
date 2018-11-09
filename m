Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43136 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbeKJJZp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Nov 2018 04:25:45 -0500
Date: Fri, 9 Nov 2018 15:42:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: don't break integrity writeback on ->writepage()
 error
Message-Id: <20181109154251.d35772bb1cdc314a70aa90a1@linux-foundation.org>
In-Reply-To: <20181105163613.7542-1-bfoster@redhat.com>
References: <20181105163613.7542-1-bfoster@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>

On Mon,  5 Nov 2018 11:36:13 -0500 Brian Foster <bfoster@redhat.com> wrote:

> write_cache_pages() currently breaks out of the writepage loop in
> the event of a ->writepage() error. This causes problems for
> integrity writeback on XFS

For the uninitiated, please define the term "integrity writeback". 
Quite carefully ;) I'm not sure what it actually means.  grepping
fs/xfs for "integrity" doesn't reveal anything.

<reads the code>

OK, it appears the term means "to sync data to disk" as opposed to
"periodic dirty memory cleaning".  I guess we don't have particularly
well-established terms for the two concepts.

> in the event of a persistent error as XFS
> expects to process every dirty+delalloc page such that it can
> discard delalloc blocks when real block allocation fails.  Failure
> to handle all delalloc pages leaves the filesystem in an
> inconsistent state if the integrity writeback happens to be due to
> an unmount, for example.
> 
> Update write_cache_pages() to continue processing pages for
> integrity writeback regardless of ->writepage() errors. Save the
> first encountered error and return it once complete. This
> facilitates XFS or any other fs that expects integrity writeback to
> process the entire set of dirty pages regardless of errors.
> Background writeback continues to exit on the first error
> encountered.
> 
> ...
>
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2156,6 +2156,7 @@ int write_cache_pages(struct address_space *mapping,
>  {
>  	int ret = 0;
>  	int done = 0;
> +	int error;
>  	struct pagevec pvec;
>  	int nr_pages;
>  	pgoff_t uninitialized_var(writeback_index);
> @@ -2236,25 +2237,29 @@ int write_cache_pages(struct address_space *mapping,
>  				goto continue_unlock;
>  
>  			trace_wbc_writepage(wbc, inode_to_bdi(mapping->host));
> -			ret = (*writepage)(page, wbc, data);
> -			if (unlikely(ret)) {
> -				if (ret == AOP_WRITEPAGE_ACTIVATE) {
> +			error = (*writepage)(page, wbc, data);
> +			if (unlikely(error)) {
> +				if (error == AOP_WRITEPAGE_ACTIVATE) {
>  					unlock_page(page);
> -					ret = 0;
> -				} else {
> +					error = 0;
> +				} else if (wbc->sync_mode != WB_SYNC_ALL &&
> +					   !wbc->for_sync) {

And here we're determining that it is not a sync-data-to-disk
operation, hence it must be a clean-dirty-pages operation.

This isn't very well-controlled, is it?  It's an inference which was
put together by examining current callers, I assume?

It would be good if we could force callers to be explicit about their
intent here.  But I'm not sure that adding a new writeback_sync_mode is
the way to do this.

At a minimum it would be good to have careful comments in here
explaining what is going on, justifying the above inference, explaining
the xfs requirement (hopefully in a way which isn't xfs-specific).

>  					/*
> -					 * done_index is set past this page,
> -					 * so media errors will not choke
> +					 * done_index is set past this page, so
> +					 * media errors will not choke
>  					 * background writeout for the entire
>  					 * file. This has consequences for
>  					 * range_cyclic semantics (ie. it may
>  					 * not be suitable for data integrity
>  					 * writeout).
>  					 */
