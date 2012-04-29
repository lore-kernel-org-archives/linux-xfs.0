Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3TLvTiF163136 for <xfs@oss.sgi.com>; Sun, 29 Apr 2012 16:57:29 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	DshKju5LddNAO1cF (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 29 Apr 2012 14:57:28 -0700 (PDT)
Date: Sun, 29 Apr 2012 17:57:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 37/37] xfs: make XBF_MAPPED the default behaviour
Message-ID: <20120429215728.GP19889@infradead.org>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-38-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1335160747-17254-38-git-send-email-david@fromorbit.com>
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

> @@ -399,8 +399,9 @@ _xfs_buf_map_pages(
>  	if (bp->b_page_count == 1) {
>  		/* A single page buffer is always mappable */
>  		bp->b_addr = page_address(bp->b_pages[0]) + bp->b_offset;
> -		bp->b_flags |= XBF_MAPPED;
> -	} else if (flags & XBF_MAPPED) {
> +	} else if (flags & XBF_UNMAPPED) {
> +		bp->b_addr = NULL;

Do we need this explicit assigned?  The buffer should always have
b_addr == NULL at this point.

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
