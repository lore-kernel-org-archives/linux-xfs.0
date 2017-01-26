Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57810 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754118AbdAZR4g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Jan 2017 12:56:36 -0500
Subject: Re: [PATCH] xfs: fix bmv_count confusion w/ shared extents
References: <20170126031114.GS9134@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9febe373-bada-4219-e684-297f4eb54d8e@sandeen.net>
Date: Thu, 26 Jan 2017 11:33:03 -0600
MIME-Version: 1.0
In-Reply-To: <20170126031114.GS9134@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 1/25/17 9:11 PM, Darrick J. Wong wrote:
> In a bmapx call, bmv_count is the total size of the array, including the
> zeroth element that userspace uses to supply the search key.  The output
> array starts at offset 1 so that we can set up the user for the next
> invocation.  Since we now can split an extent into multiple bmap records
> due to shared/unshared status, we have to be careful that we don't
> overflow the output array.
> 
> In the original patch f86f403794b ("xfs: teach get_bmapx about shared
> extents and the CoW fork") I used cur_ext (the output index) to check
> for overflows, albeit with an off-by-one error.  Since nexleft describes
> the number of unfilled slots in the output, we can rip all that out and
> use nexleft for the check directly.
> 
> Failure to do this causes heap corruption in bmapx callers such as
> xfs_io and xfs_scrub.  xfs/328 can reproduce this problem.
> 
> Suggested-by: Eric Sandeen <sandeen@sandeen.net>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Yup, I think this is better, thanks.  Comments around the
whole inject_map business would be nice, but *shrug* doesn't
have to be in this patch.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> v2: simplify the loop accounting to use nexleft for the output checks
> ---
>  fs/xfs/xfs_bmap_util.c |   10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index b9abce5..fc6bdaf 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -697,8 +697,7 @@ xfs_getbmap(
>  			goto out_free_map;
>  		ASSERT(nmap <= subnex);
>  
> -		for (i = 0; i < nmap && nexleft && bmv->bmv_length &&
> -				cur_ext < bmv->bmv_count; i++) {
> +		for (i = 0; i < nmap && nexleft && bmv->bmv_length; i++) {
>  			out[cur_ext].bmv_oflags = 0;
>  			if (map[i].br_state == XFS_EXT_UNWRITTEN)
>  				out[cur_ext].bmv_oflags |= BMV_OF_PREALLOC;
> @@ -760,16 +759,15 @@ xfs_getbmap(
>  				continue;
>  			}
>  
> +			nexleft--;
>  			if (inject_map.br_startblock != NULLFSBLOCK) {
>  				map[i] = inject_map;
>  				i--;
> -			} else
> -				nexleft--;
> +			}
>  			bmv->bmv_entries++;
>  			cur_ext++;
>  		}
> -	} while (nmap && nexleft && bmv->bmv_length &&
> -		 cur_ext < bmv->bmv_count);
> +	} while (nmap && nexleft && bmv->bmv_length);
>  
>   out_free_map:
>  	kmem_free(map);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
