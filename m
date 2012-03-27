Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2R1Fjdg140821 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 20:15:46 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	rCAzObAC2J7w0BGr for <xfs@oss.sgi.com>;
	Mon, 26 Mar 2012 18:15:43 -0700 (PDT)
Date: Tue, 27 Mar 2012 12:15:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: push the ilock into xfs_zero_eof
Message-ID: <20120327011540.GS5091@dastard>
References: <20120326211421.518374058@bombadil.infradead.org>
	<20120326211603.654869525@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120326211603.654869525@bombadil.infradead.org>
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

On Mon, Mar 26, 2012 at 05:14:25PM -0400, Christoph Hellwig wrote:
> Instead of calling xfs_zero_eof with the ilock held only take it internally
> for the minimall required critical section around xfs_bmapi_read.  This
> also requires changing the calling convention for xfs_zero_last_block
> slightly.  The actual zeroing operation is still serialized by the iolock,
> which must be taken exclusively over the call to xfs_zero_eof.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
.....
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_fileoff_t		last_fsb = XFS_B_TO_FSBT(mp, isize);
> +	int			zero_offset = XFS_B_FSB_OFFSET(mp, isize);
> +	int			zero_len;
> +	int			nimaps = 1;
> +	int			error = 0;
> +	struct xfs_bmbt_irec	imap;
>  
> -	last_fsb = XFS_B_TO_FSBT(mp, isize);
> -	nimaps = 1;
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	error = xfs_bmapi_read(ip, last_fsb, 1, &imap, &nimaps, 0);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);

Does that even need to be an exclusive lock? a shared lock is all
that is needed to do a lookup, and this is just a lookup...

....

> @@ -521,23 +503,18 @@ xfs_zero_eof(
>  	while (start_zero_fsb <= end_zero_fsb) {
>  		nimaps = 1;
>  		zero_count_fsb = end_zero_fsb - start_zero_fsb + 1;
> +
> +		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		error = xfs_bmapi_read(ip, start_zero_fsb, zero_count_fsb,
>  					  &imap, &nimaps, 0);
> -		if (error) {
> -			ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);

Same question - it is a read lookup so why do we need exclusive
locking here?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
