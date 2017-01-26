Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57748 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752538AbdAZXiE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Jan 2017 18:38:04 -0500
Subject: Re: [PATCH v100] xfs: fix bmv_count confusion w/ shared extents
References: <20170126225714.GX9134@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <dd395728-9c26-ee89-663d-82c6c636af00@sandeen.net>
Date: Thu, 26 Jan 2017 17:38:02 -0600
MIME-Version: 1.0
In-Reply-To: <20170126225714.GX9134@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 1/26/17 4:57 PM, Darrick J. Wong wrote:
> In a bmapx call, bmv_count is the total size of the array, including the
> zeroth element that userspace uses to supply the search key.  The output
> array starts at offset 1 so that we can set up the user for the next
> invocation.  Since we now can split an extent into multiple bmap records
> due to shared/unshared status, we have to be careful that we don't
> overflow the output array.
> 
> In the original patch f86f403794b ("xfs: teach get_bmapx about shared
> extents and the CoW fork") I used cur_ext (the output index) to check
> for overflows, albeit with an off-by-one error.  Since nexleft is no
> longer useful, we can rip all that out and use cur_ext (the output array
> index) for the overflow check directly.
> 
> Failure to do this causes heap corruption in bmapx callers such as
> xfs_io and xfs_scrub.  xfs/328 can reproduce this problem.

Yeah, I think this makes sense.  cur_ext counted up, nexleft counted
down.  Either one should have worked*, but we don't need to limit
on both.

> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Assuming you've successfully run this through all the bmap tests?

This-version-really-reviewed-by: Eric Sandeen <sandeen@redhat.com>


*would have worked if we hadn't limited nex for no apparent reason...
 This does essentially take that limit out of the equation, but as
 far as I can tell that's ok.  We stop when xfs_bmapi_read returns
 "0 more maps" in nmap, asking for more shouldn't matter.  AFAICT
 the limit:

        /*
         * Don't let nex be bigger than the number of extents
         * we can have assuming alternating holes and real extents.
         */
        if (nex > XFS_IFORK_NEXTENTS(ip, whichfork) * 2 + 1)
                nex = XFS_IFORK_NEXTENTS(ip, whichfork) * 2 + 1;

 can go away, but this patch really should be just a targeted
 bugfix and it's already a bit more than that, so ...


> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_bmap_util.c |   28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index b9abce5..c141791 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -528,7 +528,6 @@ xfs_getbmap(
>  	xfs_bmbt_irec_t		*map;		/* buffer for user's data */
>  	xfs_mount_t		*mp;		/* file system mount point */
>  	int			nex;		/* # of user extents can do */
> -	int			nexleft;	/* # of user extents left */
>  	int			subnex;		/* # of bmapi's can do */
>  	int			nmap;		/* number of map entries */
>  	struct getbmapx		*out;		/* output structure */
> @@ -686,10 +685,8 @@ xfs_getbmap(
>  		goto out_free_map;
>  	}
>  
> -	nexleft = nex;
> -
>  	do {
> -		nmap = (nexleft > subnex) ? subnex : nexleft;
> +		nmap = (nex > subnex) ? subnex : nex;
>  		error = xfs_bmapi_read(ip, XFS_BB_TO_FSBT(mp, bmv->bmv_offset),
>  				       XFS_BB_TO_FSB(mp, bmv->bmv_length),
>  				       map, &nmap, bmapi_flags);
> @@ -697,8 +694,8 @@ xfs_getbmap(
>  			goto out_free_map;
>  		ASSERT(nmap <= subnex);
>  
> -		for (i = 0; i < nmap && nexleft && bmv->bmv_length &&
> -				cur_ext < bmv->bmv_count; i++) {
> +		for (i = 0; i < nmap && bmv->bmv_length &&
> +				cur_ext < bmv->bmv_count - 1; i++) {
>  			out[cur_ext].bmv_oflags = 0;
>  			if (map[i].br_state == XFS_EXT_UNWRITTEN)
>  				out[cur_ext].bmv_oflags |= BMV_OF_PREALLOC;
> @@ -760,16 +757,27 @@ xfs_getbmap(
>  				continue;
>  			}
>  
> +			/*
> +			 * In order to report shared extents accurately,
> +			 * we report each distinct shared/unshared part
> +			 * of a single bmbt record using multiple bmap
> +			 * extents.  To make that happen, we iterate the
> +			 * same map array item multiple times, each
> +			 * time trimming out the subextent that we just
> +			 * reported.
> +			 *
> +			 * Because of this, we must check the out array
> +			 * index (cur_ext) directly against bmv_count-1
> +			 * to avoid overflows.
> +			 */
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
> +	} while (nmap && bmv->bmv_length && cur_ext < bmv->bmv_count - 1);
>  
>   out_free_map:
>  	kmem_free(map);
> 
