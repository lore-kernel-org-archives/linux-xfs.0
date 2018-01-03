Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57984 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751514AbeACN2F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Jan 2018 08:28:05 -0500
Date: Wed, 3 Jan 2018 08:28:03 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: speed up directory bestfree block scanning
Message-ID: <20180103132802.GA17932@bfoster.bfoster>
References: <20180103062748.16400-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180103062748.16400-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 03, 2018 at 05:27:48PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When running a "create millions inodes in a directory" test
> recently, I noticed we were spending a huge amount of time
> converting freespace block headers from disk format to in-memory
> format:
> 
>  31.47%  [kernel]  [k] xfs_dir2_node_addname
>  17.86%  [kernel]  [k] xfs_dir3_free_hdr_from_disk
>   3.55%  [kernel]  [k] xfs_dir3_free_bests_p
> 
> We shouldn't be hitting the best free block scanning code so hard
> when doing sequential directory creates, and it turns out there's
> a highly suboptimal loop searching the the best free array in
> the freespace block - it decodes the block header before checking
> each entry inside a loop, instead of decoding the header once before
> running the entry search loop.
> 
> This makes a massive difference to create rates. Profile now looks
> like this:
> 
>   13.15%  [kernel]  [k] xfs_dir2_node_addname
>    3.52%  [kernel]  [k] xfs_dir3_leaf_check_int
>    3.11%  [kernel]  [k] xfs_log_commit_cil
> 
> And the wall time/average file create rate differences are
> just as stark:
> 
> 		create time(sec) / rate (files/s)
> File count	     vanilla		    patched
>   10k		   0.54 / 18.5k		   0.53 / 18.9k
>   20k		   1.10	/ 18.1k		   1.05 / 19.0k
>  100k		   4.21	/ 23.8k		   3.91 / 25.6k
>  200k		   9.66	/ 20,7k		   7.37 / 27.1k
>    1M		  86.61	/ 11.5k		  48.26 / 20.7k
>    2M		 206.13	/  9.7k		 129.71 / 15.4k
> 
> The larger the directory, the bigger the performance improvement.
> 

Interesting..

> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_dir2_node.c | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 682e2bf370c7..bcf0d43cd6a8 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -1829,24 +1829,24 @@ xfs_dir2_node_addname_int(
>  		 */
>  		bests = dp->d_ops->free_bests_p(free);
>  		dp->d_ops->free_hdr_from_disk(&freehdr, free);
> -		if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
> -		    be16_to_cpu(bests[findex]) >= length)
> -			dbno = freehdr.firstdb + findex;
> -		else {
> -			/*
> -			 * Are we done with the freeblock?
> -			 */
> -			if (++findex == freehdr.nvalid) {
> -				/*
> -				 * Drop the block.
> -				 */
> -				xfs_trans_brelse(tp, fbp);
> -				fbp = NULL;
> -				if (fblk && fblk->bp)
> -					fblk->bp = NULL;

Ok, so we're adding a dir entry to a node dir and walking the free space
blocks to see if we have space somewhere to insert the entry without
growing the dir. The current code reads the free block, converts the
header, checks bests[findex], then bumps findex or invalidates the free
block if we're done with it.

The updated code reads the free block, converts the header, iterates the
free index range then invalidates the block when complete (assuming we
don't find suitable free space). The end result is that we don't convert
the block header over and over for each index in the individual block.
Seems reasonable to me, just a couple nits...

> +		do {
> +

Extra space above.

> +			if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
> +			    be16_to_cpu(bests[findex]) >= length) {
> +				dbno = freehdr.firstdb + findex;
> +				break;
>  			}
> +		} while (++findex < freehdr.nvalid);
> +
> +		/* Drop the block if we done with the freeblock */

"... if we're done ..."

Also FWIW, according to the comment it looks like the only reason the
freehdr conversion is elevated to this scope is to accommodate gcc
foolishness. If so, I'm wondering if a simple NULL init of bests at the
top of the function would avoid that problem and allow us to move the
code to where it was apparently intended to be in the first place. Hm?

Brian

> +		if (findex == freehdr.nvalid) {
> +			xfs_trans_brelse(tp, fbp);
> +			fbp = NULL;
> +			if (fblk)
> +				fblk->bp = NULL;
>  		}
>  	}
> +
>  	/*
>  	 * If we don't have a data block, we need to allocate one and make
>  	 * the freespace entries refer to it.
> -- 
> 2.15.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
