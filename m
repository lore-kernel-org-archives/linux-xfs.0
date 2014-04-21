Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 612B17F4E
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 02:03:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4EF31304032
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 00:02:57 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id UoPBDTjPHeZSXw0R (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 21 Apr 2014 00:02:53 -0700 (PDT)
Date: Mon, 21 Apr 2014 00:02:52 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/9] db: verify buffer on type change
Message-ID: <20140421070252.GD20384@infradead.org>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
	<1397550301-31883-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397550301-31883-3-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

> +void
> +set_iocur_type(
> +	const typ_t	*t)
> +{
> +	const struct xfs_buf_ops *ops = t ? t->bops : NULL;
> +	struct xfs_buf	*bp = iocur_top->bp;
> +
> +	iocur_top->typ = t;
> +
> +	/* verify the buffer if the type has one. */
> +	if (!bp)
> +		return;
> +	if (!ops) {
> +		bp->b_ops = NULL;
> +		bp->b_flags |= LIBXFS_B_UNCHECKED;
> +		return;
> +	}

The only caller currently makes sure we never pass a NULL t argument,
and I think keeping it that way is sensible.  If we want to allow
clearing the type we should add a separate clear_iocur_type helper for
it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
