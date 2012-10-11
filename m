Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9BLaUgF243187 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 16:36:31 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	VeE9jJinFHWJtxWr (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 14:38:02 -0700 (PDT)
Date: Thu, 11 Oct 2012 17:38:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/19] xfs: uncached buffer reads need to return an error
Message-ID: <20121011213802.GC6346@infradead.org>
References: <1349754670-32009-1-git-send-email-david@fromorbit.com>
	<1349754670-32009-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1349754670-32009-4-git-send-email-david@fromorbit.com>
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

> index 917e121..dee14eb 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -149,6 +149,11 @@ xfs_growfs_data_private(
>  				XFS_FSS_TO_BB(mp, 1), 0, NULL);
>  	if (!bp)
>  		return EIO;
> +	if (bp->b_error) {
> +		int	error = bp->b_error;
> +		xfs_buf_relse(bp);
> +		return error;
> +	}
>  	xfs_buf_relse(bp);

> +	if (bp->b_error) {
> +		error = bp->b_error;
> +		if (loud)
> +			xfs_warn(mp, "SB validate failed");
> +		goto release_buf;
> +	}

> +	if (bp->b_error) {
> +		error = bp->b_error;
> +		xfs_buf_relse(bp);
> +		return error;
> +	}

> +	if (!bp || bp->b_error) {
>  		xfs_warn(mp, "realtime device size check failed");
> +		if (bp)
> +			xfs_buf_relse(bp);
>  		return EIO;
>  	}
>  	xfs_buf_relse(bp);

It seems like all these callers would be a lot cleaner if we'd just
return the error as the return value, and a buffer as an indirect
pointer if and only if the read succeeded.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
