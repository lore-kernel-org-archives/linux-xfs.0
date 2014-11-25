Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C06D37F3F
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 17:32:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5DED0AC00B
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 15:32:12 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	50DH89Z4LANzo0KF for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2014 15:32:08 -0800 (PST)
Date: Wed, 26 Nov 2014 10:18:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: overflow in xfs_iomap_eof_align_last_fsb
Message-ID: <20141125231828.GA9561@dastard>
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

Change of allocator behaviour that will cause significant problems
for applications that depend on deterministic behaviour from the
extent size hint.

i.e. The extsize hint is supposed to override all other alignments
that are made - extent size hints are effectively a "unit of
allocation".  Hence we round up to stripe unit/width, then apply the
extent size hint alignment so that extent sizes are always aligned
to the extent size hint....

....
> @@ -52,7 +52,7 @@ xfs_iomap_eof_align_last_fsb(
>  	xfs_extlen_t	extsize,
>  	xfs_fileoff_t	*last_fsb)
>  {
> -	xfs_fileoff_t	new_last_fsb = 0;
> +	xfs_fileoff_t	new_last_fsb;

That can be declared in the context that uses it now.

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

Drop the comment change...

>  	if (extsize) {
> -		if (new_last_fsb)
> -			align = roundup_64(new_last_fsb, extsize);
> +		if (align)
> +			align = roundup_64(extsize, align);

			align = roundup(align, extsize);

>  		else
>  			align = extsize;
> -		new_last_fsb = roundup_64(*last_fsb, align);
>  	}
>  
> -	if (new_last_fsb) {
> +	if (align) {
> +		new_last_fsb = roundup_64(*last_fsb, align);

		xfs_fileoff_t	new_last_fsb = roundup_64(*last_fsb, align);

>  		error = xfs_bmap_eof(ip, new_last_fsb, XFS_DATA_FORK, &eof);
>  		if (error)
>  			return error;

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
