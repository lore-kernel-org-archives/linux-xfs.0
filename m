Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9Q8mTVw215977 for <xfs@oss.sgi.com>; Fri, 26 Oct 2012 03:48:29 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	hG9NNNMPaHtE5aEX (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Oct 2012 01:50:15 -0700 (PDT)
Date: Fri, 26 Oct 2012 04:50:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 21/25] xfs: add buffer pre-write callback
Message-ID: <20121026085014.GC3035@infradead.org>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-22-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351146854-19343-22-git-send-email-david@fromorbit.com>
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

>  	/*
> +	 * run the pre-io callback function if it exists. If this function
> +	 * fails it will mark the buffer with an error and the IO should
> +	 * not be dispatched.
> +	 */
> +	if (bp->b_pre_io) {
> +		bp->b_pre_io(bp);
> +		if (bp->b_error) {

Wouldn't it be a cleaner calling convention to return the erro from the
callback?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
