Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D31737F54
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 07:50:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A430B30404E
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 05:50:10 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AWafxRgNn5WsBF3e (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2014 05:49:42 -0800 (PST)
Date: Tue, 25 Nov 2014 08:49:39 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: overflow in xfs_iomap_eof_align_last_fsb
Message-ID: <20141125134939.GB8132@bfoster.bfoster>
References: <1416855973-6359-1-git-send-email-treestem@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1416855973-6359-1-git-send-email-treestem@gmail.com>
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
To: Peter Watkins <treestem@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Nov 24, 2014 at 02:06:13PM -0500, Peter Watkins wrote:
> Someone else may have run into this already, if not please take
> a look.
> 
>  Peter
> 
> If extsize is set and new_last_fsb is larger than 32 bits, the
> roundup to extsize will overflow the align variable. Instead,
> combine alignments by rounding extsize hint up to stripe size.
> 
> Signed-off-by: Peter Watkins <treestem@gmail.com>
> Reviewed-by: Nathaniel W. Turner <nate@houseofnate.net>
> ---

So we basically assign a file offset value to an extent length variable.
Nice spot...

>  fs/xfs/xfs_iomap.c |   19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index afcf3c9..0c4abfe 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -52,7 +52,7 @@ xfs_iomap_eof_align_last_fsb(
>  	xfs_extlen_t	extsize,
>  	xfs_fileoff_t	*last_fsb)
>  {
> -	xfs_fileoff_t	new_last_fsb = 0;
> +	xfs_fileoff_t	new_last_fsb;
>  	xfs_extlen_t	align = 0;
>  	int		eof, error;
>  
> @@ -70,23 +70,24 @@ xfs_iomap_eof_align_last_fsb(
>  		else if (mp->m_dalign)
>  			align = mp->m_dalign;
>  
> -		if (align && XFS_ISIZE(ip) >= XFS_FSB_TO_B(mp, align))
> -			new_last_fsb = roundup_64(*last_fsb, align);
> +		if (align && XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, align))
> +			align = 0;
>  	}
>  
>  	/*
> -	 * Always round up the allocation request to an extent boundary
> -	 * (when file on a real-time subvolume or has di_extsize hint).
> +	 * Round up the allocation request to an extent boundary. If
> +	 * already aligned to a stripe, round extsize up to a stripe
> +	 * boundary.
>  	 */
>  	if (extsize) {
> -		if (new_last_fsb)
> -			align = roundup_64(new_last_fsb, extsize);
> +		if (align)
> +			align = roundup_64(extsize, align);

I think the previous behavior would swap this around and round up the
alignment to the extsize. Because we aligned from the actual fsb, we'd
effectively use the stripe alignment as a min. alloc and always align to
the hint. Here we simply round up extsize to the stripe alignment. IOW,
the alignment was previously always to the hint, even if smaller than
the stripe alignment, and now we align to the larger of the hint or
stripe.

That said, it's kind of a weird scenario and it's not clear to me
whether it's important or even intended. If not, the patch seems Ok to
me...

Brian

>  		else
>  			align = extsize;
> -		new_last_fsb = roundup_64(*last_fsb, align);
>  	}
>  
> -	if (new_last_fsb) {
> +	if (align) {
> +		new_last_fsb = roundup_64(*last_fsb, align);
>  		error = xfs_bmap_eof(ip, new_last_fsb, XFS_DATA_FORK, &eof);
>  		if (error)
>  			return error;
> -- 
> 1.7.9.5
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
