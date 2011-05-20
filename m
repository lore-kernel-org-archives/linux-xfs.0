Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4KLW25x113266 for <xfs@oss.sgi.com>; Fri, 20 May 2011 16:32:03 -0500
Subject: Re: [PATCH 2/9] xfs: remove if_lastex
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110511150711.549194744@bombadil.infradead.org>
References: <20110511150402.258164661@bombadil.infradead.org>
	<20110511150711.549194744@bombadil.infradead.org>
Date: Fri, 20 May 2011 15:17:47 -0500
Message-ID: <1305922667.1964.58.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, 2011-05-11 at 11:04 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-kill-if_lastex)
> The if_lastex field in struct xfs_ifork is only used as a temporary index
> during xfs_bmapi and xfs_bmapi.  Instead of using the inode fork to store

                      xfs_bunmapi

(I'll fix this for you when I commit the change.)

> it keep it local in the callchain.  Fortunately this is very easy as
> we already pass a stack copy of it down the whole chain which can simplify
> be changed to be passed by reference.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This looks good to me.  I have a few comments below but
nothing looks incorrect.

Reviewed-by: Alex Elder <aelder@sgi.com>

I will continue with patches 3-9 a little later on.

> Index: xfs/fs/xfs/xfs_bmap.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap.c	2011-05-10 13:20:21.182349200 +0200
> +++ xfs/fs/xfs/xfs_bmap.c	2011-05-10 13:29:40.618349159 +0200

. . .

> @@ -725,14 +709,13 @@ xfs_bmap_add_extent_delay_real(
>  		 * Filling in all of a previously delayed allocation extent.
>  		 * The left and right neighbors are both contiguous with new.
>  		 */

Couldn't you decrement *idx here, and use its value
(without subtracting 1) in almost all spots below...

> -		trace_xfs_bmap_pre_update(ip, idx - 1, state, _THIS_IP_);
> -		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
> +		trace_xfs_bmap_pre_update(ip, *idx - 1, state, _THIS_IP_);
> +		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx - 1),
>  			LEFT.br_blockcount + PREV.br_blockcount +
>  			RIGHT.br_blockcount);
> -		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
> +		trace_xfs_bmap_post_update(ip, *idx - 1, state, _THIS_IP_);
>  
> -		xfs_iext_remove(ip, idx, 2, state);
> -		ip->i_df.if_lastex = idx - 1;
> +		xfs_iext_remove(ip, *idx, 2, state);
...(but pass *idx + 1 here)...
>  		ip->i_d.di_nextents--;
>  		if (cur == NULL)
>  			rval = XFS_ILOG_CORE | XFS_ILOG_DEXT;
> @@ -756,6 +739,8 @@ xfs_bmap_add_extent_delay_real(
>  					RIGHT.br_blockcount, LEFT.br_state)))
>  				goto done;
>  		}
> +
> +		--*idx;

...rather than waiting until here to do the decrement?

>  		*dnew = 0;
>  		break;
>  
> @@ -764,13 +749,12 @@ xfs_bmap_add_extent_delay_real(
>  		 * Filling in all of a previously delayed allocation extent.
>  		 * The left neighbor is contiguous, the right is not.
>  		 */

Same general comment in this section (and in some others
that follow).

This is not a big deal at all, but I did notice that you
did the decrement (or increment) earlier in some spots
below, but not in these.  I see nothing incorrect,
just saw what seemed like inconsistency and wondered
if there was a reasaon.

> -		trace_xfs_bmap_pre_update(ip, idx - 1, state, _THIS_IP_);
> -		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, idx - 1),
> +		trace_xfs_bmap_pre_update(ip, *idx - 1, state, _THIS_IP_);
> +		xfs_bmbt_set_blockcount(xfs_iext_get_ext(ifp, *idx - 1),
>  			LEFT.br_blockcount + PREV.br_blockcount);
> -		trace_xfs_bmap_post_update(ip, idx - 1, state, _THIS_IP_);
> +		trace_xfs_bmap_post_update(ip, *idx - 1, state, _THIS_IP_);
>  
> -		ip->i_df.if_lastex = idx - 1;
> -		xfs_iext_remove(ip, idx, 1, state);
> +		xfs_iext_remove(ip, *idx, 1, state);
>  		if (cur == NULL)
>  			rval = XFS_ILOG_DEXT;
>  		else {
. . .

> @@ -1468,17 +1458,19 @@ xfs_bmap_add_extent_unwritten_real(
>  		 * Setting the last part of a previous oldext extent to newext.
>  		 * The right neighbor is contiguous with the new allocation.
>  		 */
> -		trace_xfs_bmap_pre_update(ip, idx, state, _THIS_IP_);
> -		trace_xfs_bmap_pre_update(ip, idx + 1, state, _THIS_IP_);

This one was a bit weird (second trace call being out of place).

> +		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
>  		xfs_bmbt_set_blockcount(ep,
>  			PREV.br_blockcount - new->br_blockcount);
> -		trace_xfs_bmap_post_update(ip, idx, state, _THIS_IP_);
> -		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, idx + 1),
> +		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
> +
> +		++*idx;
> +
> +		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
> +		xfs_bmbt_set_allf(xfs_iext_get_ext(ifp, *idx),
>  			new->br_startoff, new->br_startblock,
>  			new->br_blockcount + RIGHT.br_blockcount, newext);
> -		trace_xfs_bmap_post_update(ip, idx + 1, state, _THIS_IP_);
> +		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
>  
> -		ip->i_df.if_lastex = idx + 1;
>  		if (cur == NULL)
>  			rval = XFS_ILOG_DEXT;
>  		else {

. . .



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
