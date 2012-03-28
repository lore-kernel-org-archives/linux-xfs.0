Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2SFQfHK121147 for <xfs@oss.sgi.com>; Wed, 28 Mar 2012 10:26:41 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	F3KQrIeavOft6f5u (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 28 Mar 2012 08:26:40 -0700 (PDT)
Date: Wed, 28 Mar 2012 11:26:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfs: use blocks for counting length of buffers
Message-ID: <20120328152639.GB12205@infradead.org>
References: <1332911958-5613-1-git-send-email-david@fromorbit.com>
	<1332911958-5613-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1332911958-5613-4-git-send-email-david@fromorbit.com>
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

> +			tmp = (valuelen < BBTOB(bp->b_length))
> +				? valuelen : BBTOB(bp->b_length);

maybe use min or min_t here while you're at it?

> -		tmp = (valuelen < XFS_BUF_SIZE(bp)) ? valuelen :
> -							XFS_BUF_SIZE(bp);
> +		tmp = valuelen < BBTOB(bp->b_length) ? valuelen :
> +						       BBTOB(bp->b_length);

Same here.

>  		xfs_buf_iomove(bp, 0, tmp, src, XBRW_WRITE);
> -		if (tmp < XFS_BUF_SIZE(bp))
> -			xfs_buf_zero(bp, tmp, XFS_BUF_SIZE(bp) - tmp);
> +		if (tmp < BBTOB(bp->b_length))
> +			xfs_buf_zero(bp, tmp, BBTOB(bp->b_length) - tmp);

Also a local buf_len variable in this function would probably be useful.

> -	size_t			b_buffer_length;/* size of buffer in bytes */
> +	size_t			b_length;	/* size of buffer in BBs */

A count of blocks probably shold not be a size_t, but a uint.

>  	TP_fast_assign(
>  		__entry->dev = bp->b_target->bt_dev;
>  		__entry->bno = bp->b_bn;
> -		__entry->buffer_length = bp->b_buffer_length;
> +		__entry->buffer_length = BBTOB(bp->b_length);

Given that we print the bno in blocks it might make sense to print
this as number of blocks, too?  Change the description string to nblks
in that case as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
