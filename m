Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 25F7F7F3F
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 16:08:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E69488F8039
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 14:08:27 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 57EcpbhbGZxJxR4z for
	<xfs@oss.sgi.com>; Wed, 05 Mar 2014 14:08:26 -0800 (PST)
Date: Wed, 5 Mar 2014 17:08:20 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: xfs_check_page_type buffer checks need help
Message-ID: <20140305220819.GC55736@bfoster.bfoster>
References: <1393981893-2497-1-git-send-email-david@fromorbit.com>
	<1393981893-2497-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393981893-2497-2-git-send-email-david@fromorbit.com>
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

On Wed, Mar 05, 2014 at 12:11:32PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_aops_discard_page() was introduced in the following commit:
> 
>   xfs: truncate delalloc extents when IO fails in writeback
> 
> ... to clean up left over delalloc ranges after I/O failure in
> ->writepage(). generic/224 tests for this scenario and occasionally
> reproduces panics on sub-4k blocksize filesystems.
> 
> The cause of this is failure to clean up the delalloc range on a
> page where the first buffer does not match one of the expected
> states of xfs_check_page_type(). If a buffer is not unwritten,
> delayed or dirty&mapped, xfs_check_page_type() stops and
> immediately returns 0.
> 
> The stress test of generic/224 creates a scenario where the first
> several buffers of a page with delayed buffers are mapped & uptodate
> and some subsequent buffer is delayed. If the ->writepage() happens
> to fail for this page, xfs_aops_discard_page() incorrectly skips
> the entire page.
> 
> This then causes later failures either when direct IO maps the range
> and finds the stale delayed buffer, or we evict the inode and find
> that the inode still has a delayed block reservation accounted to
> it.
> 
> We can easily fix this xfs_aops_discard_page() failure by making
> xfs_check_page_type() check all buffers, but this breaks
> xfs_convert_page() more than it is already broken. Indeed,
> xfs_convert_page() wants xfs_check_page_type() to tell it if the
> first buffers on the pages are of a type that can be aggregated into
> the contiguous IO that is already being built.
> 
> xfs_convert_page() should not be writing random buffers out of a
> page, but the current behaviour will cause it to do so if there are
> buffers that don't match the current specification on the page.
> Hence for xfs_convert_page() we need to:
> 
> 	a) return "not ok" if the first buffer on the page does not
> 	match the specification provided to we don't write anything;
> 	and
> 	b) abort it's buffer-add-to-io loop the moment we come
> 	across a buffer that does not match the specification.
> 
> Hence we need to fix both xfs_check_page_type() and
> xfs_convert_page() to work correctly with pages that have mixed
> buffer types, whilst allowing xfs_aops_discard_page() to scan all
> buffers on the page for a type match.
> 
> Reported-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

This looks pretty good to me as well. I notice one little thing that
might not be a real problem, but worth a quick thought...

>  fs/xfs/xfs_aops.c | 81 ++++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 50 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index ef62c6b..98016b3 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -632,38 +632,46 @@ xfs_map_at_offset(
>  }
>  
...
>  /*
> @@ -697,7 +705,7 @@ xfs_convert_page(
>  		goto fail_unlock_page;
>  	if (page->mapping != inode->i_mapping)
>  		goto fail_unlock_page;
> -	if (!xfs_check_page_type(page, (*ioendp)->io_type))
> +	if (!xfs_check_page_type(page, (*ioendp)->io_type, false))
>  		goto fail_unlock_page;
>  
>  	/*
> @@ -742,6 +750,15 @@ xfs_convert_page(
>  	p_offset = p_offset ? roundup(p_offset, len) : PAGE_CACHE_SIZE;
>  	page_dirty = p_offset / len;
>  
> +	/*
> +	 * The moment we find a buffer that doesn't match our current type
> +	 * specification or can't be written, abort the loop and start
> +	 * writeback. As per the above xfs_imap_valid() check, only
> +	 * xfs_vm_writepage() can handle partial page writeback fully - we are
> +	 * limited here to the buffers that are contiguous with the current
> +	 * ioend, and hence a buffer we can't write breaks that contiguity and
> +	 * we have to defer the rest of the IO to xfs_vm_writepage().
> +	 */
>  	bh = head = page_buffers(page);
>  	do {
>  		if (offset >= end_offset)
> @@ -750,7 +767,7 @@ xfs_convert_page(
>  			uptodate = 0;
>  		if (!(PageUptodate(page) || buffer_uptodate(bh))) {
>  			done = 1;
> -			continue;
> +			break;
>  		}
>  
>  		if (buffer_unwritten(bh) || buffer_delay(bh) ||
> @@ -762,10 +779,11 @@ xfs_convert_page(
>  			else
>  				type = XFS_IO_OVERWRITE;
>  
> -			if (!xfs_imap_valid(inode, imap, offset)) {
> -				done = 1;
> -				continue;
> -			}
> +			/*
> +			 * imap should always be valid because of the above
> +			 * partial page end_offset check on the imap.
> +			 */
> +			ASSERT(xfs_imap_valid(inode, imap, offset));
>  
>  			lock_buffer(bh);
>  			if (type != XFS_IO_OVERWRITE)
> @@ -777,6 +795,7 @@ xfs_convert_page(
>  			count++;
>  		} else {
>  			done = 1;
> +			break;
>  		}
>  	} while (offset += len, (bh = bh->b_this_page) != head);
> 

The next couple lines after the loop are:

	if (uptodate && bh == head)
		SetPageUptodate(page);

Now that we can break out of the loop, the "bh == head" part of that
check might not necessarily mean what it used to mean. The uptodate
variable is initialized to 1 and we reset to 0 the moment we encounter a
!uptodate buffer. Do you think it's possible to get here on the first
buffer of the page, without having reset 'uptodate,'  and potentially
incorrectly set the page uptodate?

Brian

> @@ -868,7 +887,7 @@ xfs_aops_discard_page(
>  	struct buffer_head	*bh, *head;
>  	loff_t			offset = page_offset(page);
>  
> -	if (!xfs_check_page_type(page, XFS_IO_DELALLOC))
> +	if (!xfs_check_page_type(page, XFS_IO_DELALLOC, true))
>  		goto out_invalidate;
>  
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
> -- 
> 1.9.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
