Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 23 Nov 2007 09:50:54 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lANHojw3031319
	for <xfs@oss.sgi.com>; Fri, 23 Nov 2007 09:50:47 -0800
Date: Fri, 23 Nov 2007 17:50:53 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/9] Don't block pdflush when flushing inodes
Message-ID: <20071123175053.GA12649@infradead.org>
References: <20071122003817.GK114266761@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122003817.GK114266761@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>

> +++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2007-11-22 10:33:51.037704348 +1100
> @@ -183,12 +183,20 @@ xfs_imap_to_bp(
>  	int		ni;
>  	xfs_buf_t	*bp;
>  
> +	if (buf_flags == 0)
> +		buf_flags = XFS_BUF_LOCK;

There's just two caller and they never pass 0, so this is not needed.

> +	error = xfs_itobp_flags(mp, NULL, ip, &dip, &bp, 0, 0,
> +				(noblock) ? XFS_BUF_TRYLOCK : XFS_BUF_LOCK);

no need for the braces around noblock.

> +int		xfs_itobp_flags(struct xfs_mount *, struct xfs_trans *,
>  			  xfs_inode_t *, struct xfs_dinode **, struct xfs_buf **,
> -			  xfs_daddr_t, uint);
> +			  xfs_daddr_t, uint, uint);
> +#define xfs_itobp(mp, tp, ip, dipp, bpp, bno, iflags)	\
> +	xfs_itobp_flags(mp, tp, ip, dipp, bpp, bno, iflags, XFS_BUF_LOCK)

I'd say just convert xfs_itobp and all it's user to take the additional
argument.
