Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3TLtQba162879 for <xfs@oss.sgi.com>; Sun, 29 Apr 2012 16:55:26 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	gftSNXs4ugA8bSHV (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 29 Apr 2012 14:55:25 -0700 (PDT)
Date: Sun, 29 Apr 2012 17:55:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 34/37] xfs: clean up xfs_bit.h includes
Message-ID: <20120429215525.GM19889@infradead.org>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-35-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1335160747-17254-35-git-send-email-david@fromorbit.com>
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

>   * Visible inode allocation functions.
>   */
> +/*
> + * Find a free (set) bit in the inode bitmask.
> + */
> +static inline int xfs_ialloc_find_free(xfs_inofree_t *fp)
> +{
> +	return xfs_lowbit64(*fp);
> +}

I'd suggest killing this helper entirely - there is just a single
caller, and using the lowbit helper directly actually is even more
obvious.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
