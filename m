Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACED4C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 05:31:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92EED60ED4
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 05:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237705AbhJMFda (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Oct 2021 01:33:30 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:50653 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229817AbhJMFd3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Oct 2021 01:33:29 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 00B635E8069;
        Wed, 13 Oct 2021 16:31:23 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1maWrK-005elC-Lq; Wed, 13 Oct 2021 16:31:22 +1100
Date:   Wed, 13 Oct 2021 16:31:22 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/15] xfs: support dynamic btree cursor heights
Message-ID: <20211013053122.GX2361455@dread.disaster.area>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
 <163408158126.4151249.1899753599807152513.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163408158126.4151249.1899753599807152513.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61666f2c
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=2tvEX67dFfg8pie47JMA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 12, 2021 at 04:33:01PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Split out the btree level information into a separate struct and put it
> at the end of the cursor structure as a VLA.  The realtime rmap btree
> (which is rooted in an inode) will require the ability to support many
> more levels than a per-AG btree cursor, which means that we're going to
> create two btree cursor caches to conserve memory for the more common
> case.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_alloc.c |    6 +-
>  fs/xfs/libxfs/xfs_bmap.c  |   10 +--
>  fs/xfs/libxfs/xfs_btree.c |  168 +++++++++++++++++++++++----------------------
>  fs/xfs/libxfs/xfs_btree.h |   28 ++++++--
>  fs/xfs/scrub/bitmap.c     |   22 +++---
>  fs/xfs/scrub/bmap.c       |    2 -
>  fs/xfs/scrub/btree.c      |   47 +++++++------
>  fs/xfs/scrub/trace.c      |    7 +-
>  fs/xfs/scrub/trace.h      |   10 +--
>  fs/xfs/xfs_super.c        |    2 -
>  fs/xfs/xfs_trace.h        |    2 -
>  11 files changed, 164 insertions(+), 140 deletions(-)

Hmmm - subject of the patch doesn't really match the changes being
made - there's nothing here that makes the btree cursor heights
dynamic. It's just a structure layout change...

> @@ -415,9 +415,9 @@ xfs_btree_dup_cursor(
>  	 * For each level current, re-get the buffer and copy the ptr value.
>  	 */
>  	for (i = 0; i < new->bc_nlevels; i++) {
> -		new->bc_ptrs[i] = cur->bc_ptrs[i];
> -		new->bc_ra[i] = cur->bc_ra[i];
> -		bp = cur->bc_bufs[i];
> +		new->bc_levels[i].ptr = cur->bc_levels[i].ptr;
> +		new->bc_levels[i].ra = cur->bc_levels[i].ra;
> +		bp = cur->bc_levels[i].bp;
>  		if (bp) {
>  			error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
>  						   xfs_buf_daddr(bp), mp->m_bsize,
> @@ -429,7 +429,7 @@ xfs_btree_dup_cursor(
>  				return error;
>  			}
>  		}
> -		new->bc_bufs[i] = bp;
> +		new->bc_levels[i].bp = bp;
>  	}
>  	*ncur = new;
>  	return 0;

ObHuh: that dup_cursor code seems like a really obtuse way of doing:

	bip = cur->bc_levels[i].bp->b_log_item;
	bip->bli_recur++;
	new->bc_levels[i] = cur->bc_levels[i];

But that's not a problem this patch needs to solve. Just something
that made me go hmmmm...

> @@ -922,11 +922,11 @@ xfs_btree_readahead(
>  	    (lev == cur->bc_nlevels - 1))
>  		return 0;
>  
> -	if ((cur->bc_ra[lev] | lr) == cur->bc_ra[lev])
> +	if ((cur->bc_levels[lev].ra | lr) == cur->bc_levels[lev].ra)
>  		return 0;

That's whacky logic. Surely that's just:

	if (cur->bc_levels[lev].ra & lr)
		return 0;

> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 1018bcc43d66..f31f057bec9d 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -212,6 +212,19 @@ struct xfs_btree_cur_ino {
>  #define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)
>  };
>  
> +struct xfs_btree_level {
> +	/* buffer pointer */
> +	struct xfs_buf		*bp;
> +
> +	/* key/record number */
> +	uint16_t		ptr;
> +
> +	/* readahead info */
> +#define XFS_BTCUR_LEFTRA	1	/* left sibling has been read-ahead */
> +#define XFS_BTCUR_RIGHTRA	2	/* right sibling has been read-ahead */
> +	uint16_t		ra;
> +};

The ra variable is a bit field. Can we define the values obviously
as bit fields with (1 << 0) and (1 << 1) instead of 1 and 2?

> @@ -242,8 +250,17 @@ struct xfs_btree_cur
>  		struct xfs_btree_cur_ag	bc_ag;
>  		struct xfs_btree_cur_ino bc_ino;
>  	};
> +
> +	/* Must be at the end of the struct! */
> +	struct xfs_btree_level	bc_levels[];
>  };
>  
> +static inline size_t
> +xfs_btree_cur_sizeof(unsigned int nlevels)
> +{
> +	return struct_size((struct xfs_btree_cur *)NULL, bc_levels, nlevels);
> +}

Ooooh, yeah, we really need comments explaining how many btree
levels these VLAs are tracking, because this one doesn't have a "-
1" in it like the previous one I commented on....

> diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
> index c0ef53fe6611..816dfc8e5a80 100644
> --- a/fs/xfs/scrub/trace.c
> +++ b/fs/xfs/scrub/trace.c
> @@ -21,10 +21,11 @@ xchk_btree_cur_fsbno(
>  	struct xfs_btree_cur	*cur,
>  	int			level)
>  {
> -	if (level < cur->bc_nlevels && cur->bc_bufs[level])
> +	if (level < cur->bc_nlevels && cur->bc_levels[level].bp)
>  		return XFS_DADDR_TO_FSB(cur->bc_mp,
> -				xfs_buf_daddr(cur->bc_bufs[level]));
> -	if (level == cur->bc_nlevels - 1 && cur->bc_flags & XFS_BTREE_LONG_PTRS)
> +				xfs_buf_daddr(cur->bc_levels[level].bp));
> +	else if (level == cur->bc_nlevels - 1 &&
> +		 cur->bc_flags & XFS_BTREE_LONG_PTRS)

No need for an else there as the first if () clause returns.
Also, needs more () around that "a & b" second line.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
