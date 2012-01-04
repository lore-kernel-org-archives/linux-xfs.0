Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q04KWZoM167075 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 14:32:36 -0600
Date: Wed, 4 Jan 2012 14:32:32 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 02/11] xfs: cleanup xfs_iomap_eof_align_last_fsb
Message-ID: <20120104203232.GB6390@sgi.com>
References: <20111218200003.557507716@bombadil.infradead.org>
	<20111218200130.970786897@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111218200130.970786897@bombadil.infradead.org>
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

On Sun, Dec 18, 2011 at 03:00:05PM -0500, Christoph Hellwig wrote:
> Replace the nasty if, else if, elseif condition with more natural C flow
> that expressed the logic we want here better.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> ---
>  fs/xfs/xfs_iomap.c |   36 ++++++++++++++++++------------------
>  1 file changed, 18 insertions(+), 18 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_iomap.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_iomap.c	2011-11-17 12:07:52.580802800 +0100
> +++ xfs/fs/xfs/xfs_iomap.c	2011-11-30 10:57:35.649224495 +0100
> @@ -57,26 +57,26 @@ xfs_iomap_eof_align_last_fsb(
>  	xfs_fileoff_t	*last_fsb)
>  {
>  	xfs_fileoff_t	new_last_fsb = 0;
> -	xfs_extlen_t	align;
> +	xfs_extlen_t	align = 0;
>  	int		eof, error;
>  
> -	if (XFS_IS_REALTIME_INODE(ip))
> -		;
> -	/*
> -	 * If mounted with the "-o swalloc" option, roundup the allocation
> -	 * request to a stripe width boundary if the file size is >=
> -	 * stripe width and we are allocating past the allocation eof.
> -	 */
> -	else if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC) &&
> -	        (ip->i_size >= XFS_FSB_TO_B(mp, mp->m_swidth)))
> -		new_last_fsb = roundup_64(*last_fsb, mp->m_swidth);
> -	/*
> -	 * Roundup the allocation request to a stripe unit (m_dalign) boundary
> -	 * if the file size is >= stripe unit size, and we are allocating past
> -	 * the allocation eof.
> -	 */
> -	else if (mp->m_dalign && (ip->i_size >= XFS_FSB_TO_B(mp, mp->m_dalign)))
> -		new_last_fsb = roundup_64(*last_fsb, mp->m_dalign);
> +	if (!XFS_IS_REALTIME_INODE(ip)) {
> +		/*
> +		 * Round up the allocation request to a stripe unit
> +		 * (m_dalign) boundary if the file size is >= stripe unit
> +		 * size, and we are allocating past the allocation eof.
> +		 *
> +		 * If mounted with the "-o swalloc" option the alignment is
> +		 * increased from the strip unit size to the stripe width.
> +		 */
> +		if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> +			align = mp->m_swidth;
> +		else if (mp->m_dalign)
> +			align = mp->m_dalign;
> +
> +		if (align && ip->i_size >= XFS_FSB_TO_B(mp, align))
> +			new_last_fsb = roundup_64(*last_fsb, align);
> +	}

The behavior looks equivalent and this is much easier on the eyes.
Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
