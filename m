Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 May 2007 23:30:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4L6UHfB004904
	for <xfs@oss.sgi.com>; Sun, 20 May 2007 23:30:18 -0700
Date: Mon, 21 May 2007 16:34:26 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: Review: ensure EOF writes into existing extents update filesize
Message-ID: <738172E9F9634F7FC01B5B3C@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20070520233417.GA85884050@sgi.com>
References: <20070520233417.GA85884050@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Hi,

Trying to understand how the initialisers prior to the loop
are used during the loop.
It looks like the initial "type" isn't used now with this change
as we always assign to it near to where we access it.
Previously, we did access it in the already mapped case (type != IOMAP_READ).
So why do we initialise "type" prior to the loop then?

The inited "flags" var is 1st accessed in the unmapped/allocated
codepath to set iomap_valid to zero on BMAPI_READ
or now also in the other path where it is already mapped.
Previously, flags was init to -1 (not one of the BMAPI macros) and
now it is set to BMAPI_READ.
So, previously if we came straight to an unwritten/delayed/unmapped buffer
we would not set iomap_valid to 0, as flags==-1, whereas now
we will reset it. But what is this doing anyway - is it really needed
to reset iomap_valid.

Nor sure if there are any ramifications of this but just trying to see differences.

So, xfs_add_to_ioend() sets up the io completion handlers.
Previously, we would have set up xfs_end_bio_read (for IOMAP_READ)
and now we set up xfs_end_bio_written (for IOMAP_NEW).
xfs_end_bio_written does an xfs_setfilesize(ioend)
which an xfs_end_bio_read does not.
Which I guess is the crux of this change and
that is apparent.

I'm having trouble following the existing code to understand what it is currently doing.
So you are better off with a reviewer that knows this code (but thought I'd
have a look:)
We seem to be continually testing for iomap_valid which I believe checks whether
the offset is within the mapped range.
If the offset is not within the mapping then we try mapping the <offset, size>
and then retest for validity.
So what happens when it is not valid even after mapping and why wouldn't it be valid.
I need a better understanding of the background code I guess.

Sorry,
Tim.


--On 21 May 2007 9:34:17 AM +1000 David Chinner <dgc@sgi.com> wrote:

>
> As reported a coupl eof times on lkml since the 2.6.22 window opened,
> XFS is not updating the file size corectly in all cases. This is a
> result of the null files fix not updating the file size when the
> write extending the file does not need to allocate a block.
>
> In that case, we use a read mapping of the extent, and this also
> happens to use the read I/O completion handler instead of the
> write I/O completion handle. Hence the file size was not updated
> on I/O completion.
>
> Comments?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
>
> ---
>  fs/xfs/linux-2.6/xfs_aops.c |   23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
>
> Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-05-11 16:03:59.000000000 +1000
> +++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c	2007-05-12 23:46:54.379994052 +1000
> @@ -973,8 +973,9 @@ xfs_page_state_convert(
>
>  	bh = head = page_buffers(page);
>  	offset = page_offset(page);
> -	flags = -1;
> -	type = IOMAP_READ;
> +	iomap_valid = 0;
> +	flags = BMAPI_READ;
> +	type = IOMAP_NEW;
>
>  	/* TODO: cleanup count and page_dirty */
>
> @@ -1004,14 +1005,14 @@ xfs_page_state_convert(
>  		 *
>  		 * Third case, an unmapped buffer was found, and we are
>  		 * in a path where we need to write the whole page out.
> - 		 */
> +		 */
>  		if (buffer_unwritten(bh) || buffer_delay(bh) ||
>  		    ((buffer_uptodate(bh) || PageUptodate(page)) &&
>  		     !buffer_mapped(bh) && (unmapped || startio))) {
> -		     	/*
> +			/*
>  			 * Make sure we don't use a read-only iomap
>  			 */
> -		     	if (flags == BMAPI_READ)
> +			if (flags == BMAPI_READ)
>  				iomap_valid = 0;
>
>  			if (buffer_unwritten(bh)) {
> @@ -1060,7 +1061,7 @@ xfs_page_state_convert(
>  			 * That means it must already have extents allocated
>  			 * underneath it. Map the extent by reading it.
>  			 */
> -			if (!iomap_valid || type != IOMAP_READ) {
> +			if (!iomap_valid || flags != BMAPI_READ) {
>  				flags = BMAPI_READ;
>  				size = xfs_probe_cluster(inode, page, bh,
>  								head, 1);
> @@ -1071,7 +1072,15 @@ xfs_page_state_convert(
>  				iomap_valid = xfs_iomap_valid(&iomap, offset);
>  			}
>
> -			type = IOMAP_READ;
> +			/*
> +			 * We set the type to IOMAP_NEW in case we are doing a
> +			 * small write at EOF that is extending the file but
> +			 * without needing an allocation. We need to update the
> +			 * file size on I/O completion in this case so it is
> +			 * the same case as having just allocated a new extent
> +			 * that we are writing into for the first time.
> +			 */
> +			type = IOMAP_NEW;
>  			if (!test_and_set_bit(BH_Lock, &bh->b_state)) {
>  				ASSERT(buffer_mapped(bh));
>  				if (iomap_valid)
