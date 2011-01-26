Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0QLKQgk165826 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 15:20:26 -0600
Subject: Re: [PATCH 4/8] xfs: limit extent length for allocation to AG size
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1295945444-29488-5-git-send-email-david@fromorbit.com>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
	<1295945444-29488-5-git-send-email-david@fromorbit.com>
Date: Wed, 26 Jan 2011 15:22:48 -0600
Message-ID: <1296076968.1980.941.camel@doink>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, 2011-01-25 at 19:50 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Delayed allocation extents can be larger than AGs, so when trying to
> convert a large range we may scan every AG inside
> xfs_bmap_alloc_nullfb() trying to find an AG with a size larger than
> an AG. We should stop when we find the first AG with a maximum
> possible allocation size. This causes excessive CPU usage when there
> are lots of AGs.
> 
> The same problem occurs when doing preallocation of a range larger
> than an AG.
> 
> Fix the problem by limiting real allocation lengths to the maximum
> that an AG can support. This means if we have empty AGs, we'll stop
> the search at the first of them. If there are no empty AGs, we'll
> still scan them all, but that is a different problem....

Maybe I'm wrong but I think you need to change a "+"
to a "-" (shown below).

And I have a few really minor suggestions:
- You should update a comment (which I point
  out below) to match your change.
- Maybe make use of a local variable, at least
  in xfs_bmap_btalloc_nullfb(), such as:
    xfs_extlen_t requested = args->maxlen;

Otherwise it looks good to me.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_alloc.h |   16 ++++++++++++++++
>  fs/xfs/xfs_bmap.c  |   16 +++++++++-------
>  2 files changed, 25 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_alloc.h b/fs/xfs/xfs_alloc.h
> index 0ab56b3..6ad45b9 100644
> --- a/fs/xfs/xfs_alloc.h
> +++ b/fs/xfs/xfs_alloc.h
> @@ -75,6 +75,22 @@ typedef unsigned int xfs_alloctype_t;
>  #define XFS_ALLOC_SET_ASIDE(mp)  (4 + ((mp)->m_sb.sb_agcount * 4))
>  
>  /*
> + * When deciding how much space to allocate out of an AG, we limit the
> + * allocation maximum size to the size the AG. However, we cannot use all the
> + * blocks in the AG - some are permanently used by metadata. These
> + * blocks are generally:
> + *	- the AG superblock, AGF, AGI and AGFL
> + *	- the AGF (bno and cnt) and AGI btree root blocks
> + *	- 4 blocks on the AGFL according to XFS_ALLOC_SET_ASIDE() limits
> + *
> + * The AG headers are sector sized, so the amount of space they take up is
> + * dependent on filesystem geometry. The others are all single blocks.
> + */
> +#define XFS_ALLOC_AG_MAX_USABLE(mp)	\
> +	((mp)->m_sb.sb_agblocks - XFS_BB_TO_FSB(mp, XFS_FSS_TO_BB(mp, 4)) + 7)

Is this right?  Shouldn't the 7 be subtracted (or combined using
parentheses with the 4 FS sectors)?

> +
> +
> +/*
>   * Argument structure for xfs_alloc routines.
>   * This is turned into a structure to avoid having 20 arguments passed
>   * down several levels of the stack.
> diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> index 4111cd3..74861c6 100644
> --- a/fs/xfs/xfs_bmap.c
> +++ b/fs/xfs/xfs_bmap.c
. . .
> @@ -2498,14 +2498,14 @@ xfs_bmap_btalloc_nullfb(
>  	 * If the best seen length is less than the request
>  	 * length, use the best as the minimum.
>  	 */
> -	else if (*blen < ap->alen)
> +	else if (*blen < args->maxlen)
>  		args->minlen = *blen;
>  	/*
>  	 * Otherwise we've seen an extent as big as alen,

Ought to adjust this comment to better reflect your updated
code ("alen" doesn't really fit any more).

>  	 * use that as the minimum.
>  	 */
>  	else
> -		args->minlen = ap->alen;
> +		args->minlen = args->maxlen;
>  
>  	/*
>  	 * set the failure fallback case to look in the selected


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
