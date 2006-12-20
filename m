Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Dec 2006 01:08:19 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBK98Bqw013112
	for <xfs@oss.sgi.com>; Wed, 20 Dec 2006 01:08:13 -0800
Date: Wed, 20 Dec 2006 20:07:18 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: Clear unwritten flag on during partial page truncation
Message-ID: <20061220090718.GY44411608@melbourne.sgi.com>
References: <20061220062813.GU44411608@melbourne.sgi.com> <4588F2A2.4000609@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4588F2A2.4000609@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev@sgi.com, xfs@oss.sgi.com

On Wed, Dec 20, 2006 at 08:21:54AM +0000, Lachlan McIlroy wrote:
> @@ -41,6 +41,8 @@
>  #include <linux/pagevec.h>
>  #include <linux/writeback.h>
> 
> +STATIC void xfs_vm_invalidatepage(struct page *, unsigned long);
> +
>  STATIC void
>  xfs_count_page_state(
>  	struct page		*page,
> @@ -1061,7 +1063,7 @@ error:
>  	 */
>  	if (err != -EAGAIN) {
>  		if (!unmapped)
> -			block_invalidatepage(page, 0);
> +			xfs_vm_invalidatepage(page, 0);
> 
> We pass in an offset of zero here...

Yup - to invalidate the whole page.

> @@ -1458,6 +1468,32 @@ xfs_vm_invalidatepage(
>  {
>  	xfs_page_trace(XFS_INVALIDPAGE_ENTER,
>  			page->mapping->host, page, offset);
> +
> +	/*
> +	 * Need to clear private flags from buffers on partial
> +	 * page truncations ourselves. Same inner loop as
> +	 * block_invalidatepage() is used.
> +	 */
> +	if (offset && page_has_buffers(page)) {
> 
> And only do this code for non-zero offsets.  Are you sure this is correct?

Yes. offset == 0 will currently just fall through to
block_invalidatepage() which removes and frees all the buffers.
Right now that first change is a no-op except on debug kernels we'll
get a trace entry to indicate that we invalidated the page.

In future, however, we may need to scan all the buffers before
freeing them, so now we'll only need to modify xfs_vm_invalidatepage()....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
