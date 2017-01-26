Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41782 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752470AbdAZC3X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2017 21:29:23 -0500
Date: Wed, 25 Jan 2017 18:29:19 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix bmv_count confusion
Message-ID: <20170126022919.GR9134@birch.djwong.org>
References: <20170125195854.GP9134@birch.djwong.org>
 <390ab2d8-b97b-50c0-968c-9825ca86c0c9@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <390ab2d8-b97b-50c0-968c-9825ca86c0c9@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Jan 25, 2017 at 06:20:54PM -0600, Eric Sandeen wrote:
> On 1/25/17 1:58 PM, Darrick J. Wong wrote:
> > In a bmapx call, bmv_count is the total size of the array, including the
> > zeroth element that userspace uses to supply the search key.  The output
> > array starts at offset 1 so that we can set up the user for the next
> > invocationn.  Therefore, we must ensure that cur_ext (which indexes the
> > output array) never exceeds bmv_count-1, not bmv_count.  Failure to do
> > this causes heap corruption in bmapx callers such as xfs_io and
> > xfs_scrub when the formatter overflows the array.  xfs/348 can reproduce
> > this problem.
> 
> Ok, well, this worked until f86f40379 :)  nexleft (number extents
> left) used to keep an accurate count and break when done.  That
> loop condition is getting a bit insane, but *shrug* for now.
> 
> It would be worth making the commit log more clear that the problem
> currently exists only for shared extents (right?)
> 
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_bmap_util.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index b9abce5..883e55f 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -698,7 +698,7 @@ xfs_getbmap(
> >  		ASSERT(nmap <= subnex);
> >  
> >  		for (i = 0; i < nmap && nexleft && bmv->bmv_length &&
> > -				cur_ext < bmv->bmv_count; i++) {
> > +				cur_ext < bmv->bmv_count - 1; i++) {
> 
> ok, so the cur_ext vs. bmv_count test was added w/ the above commit.
> 
> >  			out[cur_ext].bmv_oflags = 0;
> >  			if (map[i].br_state == XFS_EXT_UNWRITTEN)
> >  				out[cur_ext].bmv_oflags |= BMV_OF_PREALLOC;
> > @@ -769,7 +769,7 @@ xfs_getbmap(
> >  			cur_ext++;
> >  		}
> >  	} while (nmap && nexleft && bmv->bmv_length &&
> > -		 cur_ext < bmv->bmv_count);
> > +		 cur_ext < bmv->bmv_count - 1);
> 
> at the bottom of the loop we have:
> 
>                         if (inject_map.br_startblock != NULLFSBLOCK) {
>                                 map[i] = inject_map;
>                                 i--;
>                         } else
>                                 nexleft--;
>                         bmv->bmv_entries++;
> 
> nexleft used to be our "should we stop" counter, if we have extents
> left, keep going, if not, stop.  It was initialized in a roundabout
> way from bmv->bmv_count - 1;, via the "nex" variable.
> 
> So nexleft started out as the maximum times through the loop,
> but now you're resetting i, advancing the cur_ext anyway,
> going through the loop again, but not decrementing nexleft.

Ah yes, I was trying to gate the loop on the output index variable
cur_ext, but your suggestion of using the slots-remaining counter is
simpler.  I will resubmit the patch.

--D

> 
> If you revert the loop condition to:
> 
>                for (i = 0; i < nmap && nexleft && bmv->bmv_length; i++) {
> 
> and set the end of the loop nextent handling to:
> 
>                        nexleft--;
>                        if (inject_map.br_startblock != NULLFSBLOCK) {
>                                map[i] = inject_map;
>                                i--;
>                        }
> 
> does that not fix it?  i.e.:
> 
> 
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index b9abce5..95dd839 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -697,8 +697,7 @@
>  			goto out_free_map;
>  		ASSERT(nmap <= subnex);
>  
> -		for (i = 0; i < nmap && nexleft && bmv->bmv_length &&
> -				cur_ext < bmv->bmv_count; i++) {
> +		for (i = 0; i < nmap && nexleft && bmv->bmv_length; i++) {
>  			out[cur_ext].bmv_oflags = 0;
>  			if (map[i].br_state == XFS_EXT_UNWRITTEN)
>  				out[cur_ext].bmv_oflags |= BMV_OF_PREALLOC;
> @@ -760,11 +759,11 @@
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
> 
> 
> 
> 
> >   out_free_map:
> >  	kmem_free(map);
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
