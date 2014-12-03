Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AF0247F54
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2014 04:53:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3C394AC001
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2014 02:53:45 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id IA7w2e7le8U7GFn7 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Dec 2014 02:53:42 -0800 (PST)
Date: Wed, 3 Dec 2014 02:53:41 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: lobotomise xfs_trans_read_buf_map()
Message-ID: <20141203105341.GB3727@infradead.org>
References: <1417473290-17544-1-git-send-email-david@fromorbit.com>
	<20141202165930.GA28571@infradead.org>
	<20141202224518.GG18131@dastard> <20141202230706.GH18131@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141202230706.GH18131@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

>  /*
>   * Get and lock the buffer for the caller if it is not already
>   * locked within the given transaction.  If it has not yet been
> @@ -255,46 +248,11 @@ xfs_trans_read_buf_map(
>  	struct xfs_buf		**bpp,
>  	const struct xfs_buf_ops *ops)
>  {
> -	xfs_buf_t		*bp;
> -	xfs_buf_log_item_t	*bip;
> +	struct xfs_buf		*bp = NULL;
> +	struct xfs_buf_log_item	*bip;
>  	int			error;
>  
>  	*bpp = NULL;
> +	/*
> +	 * If we've had a read error, then the contents of the buffer are
> +	 * invalid and shoul dnot be used. To ensure that a followup read tries

			should not

Otherwise looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
