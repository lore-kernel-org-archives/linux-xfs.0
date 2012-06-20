Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5K6mRNl252005 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 01:48:27 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	BEKloT8OHWk0MyQh (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 19 Jun 2012 23:48:25 -0700 (PDT)
Date: Wed, 20 Jun 2012 02:48:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/9] xfs: convert internal buffer functions to pass maps
Message-ID: <20120620064824.GC14760@infradead.org>
References: <1339133914-11148-1-git-send-email-david@fromorbit.com>
	<1339133914-11148-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1339133914-11148-3-git-send-email-david@fromorbit.com>
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

> +STATIC int
> +_xfs_buf_get_maps(

Should this really be STATIC which prevents inlining even if the
compiler thinks that's a good idea?  (Same for the free side)

Also any reason for the underscore in the naming?

> +	bp->b_bn = map[0].bm_bn;
> +	bp->b_length = 0;
> +	for (i = 0; i < nmaps; i++) {
> +		bp->b_maps[i].bm_bn = map[i].bm_bn;
> +		bp->b_maps[i].bm_len = map[i].bm_len;
> +		bp->b_length += map[i].bm_len;
> +	}
> +	bp->b_io_length = bp->b_length;
> +

> +	for (i = 0; i < nmaps; i++) {
> +		numblks += map[i].bm_len;
> +	}

no need for the curly braces here.

> +	struct xfs_buf	*bp,
> +	int		map,
> +	int		*buf_offset,
> +	int		*count,
> +	int		rw)
>  {
> -	int			rw, map_i, total_nr_pages, nr_pages;
> +	int			page_index;

The indentation for the arguments and local variables doesn't seem to
line up here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
