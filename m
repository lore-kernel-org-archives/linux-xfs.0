Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7C5857FBC
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2015 19:58:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 59FD78F8050
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2015 17:58:02 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	J9Knon6ge3DRLB3I for <xfs@oss.sgi.com>;
	Tue, 27 Jan 2015 17:57:59 -0800 (PST)
Date: Wed, 28 Jan 2015 12:57:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs_spaceman: Accounting for AGFL blocks
Message-ID: <20150128015757.GT16552@dastard>
References: <54c1c12e.230a460a.4729.11fc@mx.google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54c1c12e.230a460a.4729.11fc@mx.google.com>
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
To: Dhruvesh Rathore <adrscube@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Jan 23, 2015 at 09:04:00AM +0530, Dhruvesh Rathore wrote:
> Here is the original discussion that Dave wrote for xfs_spaceman:
> 
> http://oss.sgi.com/archives/xfs/2012-10/msg00363.html
> 
> These patches were not posted and were just forward ported to a current 
> 3.18-rc7+ for-next XFS tree and were pushed to the fiemapfs branch in Dave's
> kernel tree at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git
> 
> The original xfs_spaceman tool that Dave wrote is here:
> 
> http://oss.sgi.com/archives/xfs/2012-10/msg00366.html
> 
> Dave just updated it to the 3.2.2 code base and pushed it to the
> spaceman branch in this tree:
> 
> git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

As per last patch, this is series description so it doesn't need to
be repeated in every patch ;)

>From here:

> This xfs_spaceman utility previously failed to account for AGFL blocks.
> Old output (Before changes).
> 
> $ sudo xfs_spaceman -c "freesp" /media/xfs
>    from      to extents  blocks    pct
>    1024    2047       1    1262   0.04
>    4096    8191       1    5126   0.15
>    8192   16383       3   35344   1.05
>   32768   65535       1   43989   1.31
>  262144  524287       3 1334894  39.78
>  524288  967428       2 1934840  57.66
> 
> As you can see the AGFL blocks were unaccounted (4 per AG, and there 
> were 4 AGs in this filesystem).
> 
> This patch is concerned with adding a new function which will walk the free
> extents in AGFL and account for these AGFL blocks, while file system scanning.
> 
> New output (After implementing this patch).
> 
> $ uname -a
> Linux dhruv-MacBookAir 3.18.0-rc7+ #3 SMP Thu Dec 25 15:29:59 IST 2014 x86_64 x86_64 x86_64 GNU/Linux
> $ sudo xfs_spaceman -V
> xfs_spaceman version 3.2.2
> $ sudo xfs_spaceman -c "freesp" /media/xfs
>    from      to extents  blocks    pct
>       1       1      16      16   0.00
>    1024    2047       1    1262   0.04
>    4096    8191       1    5126   0.15
>    8192   16383       3   35344   1.05
>   32768   65535       1   43989   1.31
>  262144  524287       3 1334894  39.78
>  524288  967428       2 1934840  57.66

to here, this is a good patch description. :)

> Please do comment.

No need to ask in each patch description - the series description if
the place for that....

> +
> +/*
> + * Walk the free extents in the AGFL (AG Free List) of each AG, and dump

No need to explain what AGFL means - anyone reading the code already
knows....

> + * them all into the fieinfo.
> + * 
> + * With a freshly made filesystem, 4 blocks are reserved immediately after
> + * the free space B+tree root blocks (blocks 4 to 7). As they are used up

The number of blocks is actually dependent on filesystem geometry,
but again there isn't a need to describe the exact workings of the
AGFL here.

> + * additional blocks are reserved from the AG and added to the free list
> + * array. A typical device will have space for 128 elements in the array.
> + * The actual size can be determined using XFS_AGFL_SIZE macro. The array
> + * is maintained as a circular list and active elements are pointed by 
> + * AGF's agf_flfirst, agf_fllast and agf_flcount values.

Yup, you're describing the code, not /why/ the function exists.

/*
 * When we map free space we need to take into account the blocks
 * that are indexed by the AGFL. There aren't found by walking the
 * free space btrees, so we have to walk each AGFL to find them.
 */

> + */
> +static int
> +xfs_alloc_agfl_freespace_map(
> +	struct xfs_buf		**agbp,	/* buffer for a.g. freelist header */
> +	struct xfs_btree_cur    *cur,
> +	struct fiemap_extent_info *fieinfo,
> +	xfs_agblock_t		sagbno,
> +	xfs_agblock_t		eagbno)

No need to pass the freespace btree cursor into this function,
nor the agf buffer. What is required is the struct xfs_mount,
the current agno and the agf structure. i.e.

xfs_alloc_agfl_freespace_map(
	struct xfs_mount	*mp,
	struct xfs_agf		*agf,
	struct fiemap_extent_info *fieinfo,
	xfs_agnumber_t		agno,
	xfs_agblock_t		sagbno,
	xfs_agblock_t		eagbno)

> +{
> +	xfs_agf_t	*agf;		/* a.g. freespace structure */
> +	xfs_buf_t	*agflbp;	/* buffer for a.g. freelist structure */
> +	__be32		*agfl_bno;	/* Reference to freelist block */
> +	int	 	j;
                ^
> +	int 		index;
           ^
> +	int 		error = 0;
           ^

Stray whitespace.

> +
> +	agf = XFS_BUF_TO_AGF(*agbp);
> +	error = xfs_alloc_read_agfl(cur->bc_mp, NULL, be32_to_cpu(agf->agf_seqno),
> +				    &agflbp);

	error = xfs_alloc_read_agfl(mp, NULL, agno, &agflbp);

> +	if (error)
> +		return error;
> +
> +	agfl_bno = XFS_BUF_TO_AGFL_BNO(cur->bc_mp, agflbp);
> +	
> +	index = be32_to_cpu(agf->agf_flfirst);
> +	
> +	for(j=1 ; j<=be32_to_cpu(agf->agf_flcount); j++)
> +        {

formatting, and no need for j and index parameters.

	for (i = be32_to_cpu(agf->agf_flfirst);
	     i < be32_to_cpu(agf->agf_fllast);) {
	....
		if (++i == XFS_AGFL_SIZE(mp))
			i = 0;
	}

> +	 xfs_agblock_t	fbno;
> +	 xfs_extlen_t	flen;
> +	 xfs_daddr_t	dbno;
> +	 xfs_fileoff_t	dlen;	
> +	 int		flags = 0;

all the indenting in the function needs fixing.

> +
> +	/* Relative AG block number */
> +	 fbno = be32_to_cpu(agfl_bno[index]);
> +	/* Each entry in the AGFL is a single entry i.e length is 1 block */ 
> +	 flen = 1;

These can all be folded into the code below - no need for
intermediate variables...

> +
> +	/*
> +	 * AGFL is maintained as a circular list. Following is needed
> +	 * to handle array wrapping correctly.
> +	 */	
> +         if( index == ( (XFS_AGFL_SIZE(cur->bc_mp))-1 ) )
> +	  index = 0;	/* First index of AGFL */
> +         else
> +          index++;	/* Next index in AGFL */

This is handled by the above loop construct so can be ignored.
> +        
> +	/*
> +	 * Use daddr format for all range/len calculations as that is
> +	 * the format the range/len variables are supplied in by
> +	 * userspace.
> +	 */
> +	 dbno = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno, fbno);
> +	 dlen = XFS_FSB_TO_BB(cur->bc_mp, flen);
> +	 error = -fiemap_fill_next_extent(fieinfo, BBTOB(dbno),
> +			                  BBTOB(dbno), BBTOB(dlen), flags);

This takes bytes as it's values, and we have AG block numbers and
filesystem block lengths. so:


and the entire loop becomes:

	for (i = be32_to_cpu(agf->agf_flfirst);
	     i < be32_to_cpu(agf->agf_fllast);) {
		/*
		 * Use daddr format for all range/len calculations as that is
		 * the format the range/len variables are supplied in by
		 * userspace.
		 */
		dbno = XFS_AGB_TO_DADDR(mp, agno, be32_to_cpu(agfl_bno[i]));
		error = fiemap_fill_next_extent(fieinfo,
						BBTOB(dbno), BBTOB(dbno),
						XFS_FSB_TO_B(mp, 1), flags);
		if (error)
			break;
		if (++i == XFS_AGFL_SIZE(mp))
			i = 0;
	}
	xfs_buf_relse(agflbp);
	return error;
}

Hmmm - I think something is still missing - what are the sagbno and
eagbno parameters supposed to do?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
