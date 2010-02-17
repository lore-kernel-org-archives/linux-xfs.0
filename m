Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1H4a8wA205028 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 22:36:08 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D5C011D799B
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 20:37:24 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	WmNxHxKfipwenWWF for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2010 20:37:24 -0800 (PST)
Date: Wed, 17 Feb 2010 15:37:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: split xfs_bmap_btalloc
Message-ID: <20100217043721.GN28392@discord.disaster>
References: <20100215233442.GA28817@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100215233442.GA28817@infradead.org>
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

On Mon, Feb 15, 2010 at 06:34:42PM -0500, Christoph Hellwig wrote:
> Split out the nullfb case into a separate function to reduce the stack
> footprint and make the code more readable.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I'm not sure this does reduce stack footprint - whenever we allocate
the first block of a file we hit the nullfb case, and this adds
another function call to that stack.

However, from the cleanup POV, I can't complain ;)

> 
> Index: xfs/fs/xfs/xfs_bmap.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap.c	2010-01-17 14:46:43.326254284 +0100
> +++ xfs/fs/xfs/xfs_bmap.c	2010-01-17 15:04:47.016005768 +0100
> @@ -2550,22 +2550,134 @@ xfs_bmap_rtalloc(
>  }
>  
>  STATIC int
> +xfs_bmap_btalloc_nullfb(
> +	struct xfs_bmalloca	*ap,
> +	struct xfs_alloc_arg	*args,
> +	xfs_extlen_t		*blen)
> +{
> +	struct xfs_mount	*mp = ap->ip->i_mount;
> +	struct xfs_perag	*pag;
> +	xfs_agnumber_t		ag, startag;
> +	int			notinit = 0;
> +	int			error;
> +
> +	if (ap->userdata && xfs_inode_is_filestream(ap->ip))
> +		args->type = XFS_ALLOCTYPE_NEAR_BNO;
> +	else
> +		args->type = XFS_ALLOCTYPE_START_BNO;
> +	args->total = ap->total;
> +
> +	/*
> +	 * Search for an allocation group with a single extent large enough
> +	 * for the request.  If one isn't found, then adjust the minimum
> +	 * allocation size to the largest space found.
> +	 */
> +	startag = ag = XFS_FSB_TO_AGNO(mp, args->fsbno);
> +	if (startag == NULLAGNUMBER)
> +		startag = ag = 0;
> +
> +	pag = xfs_perag_get(mp, ag);
> +	while (*blen < ap->alen) {
> +		if (!pag->pagf_init) {
> +			error = xfs_alloc_pagf_init(mp, args->tp, ag,
> +						    XFS_ALLOC_FLAG_TRYLOCK);
> +			if (error) {
> +				xfs_perag_put(pag);
> +				return error;
> +			}
> +		}
> +
> +		/*
> +		 * See xfs_alloc_fix_freelist...
> +		 */

This comment is pretty much useless - if we are changing code then
I'd say kill it. Also the other comments in this function could be
reformatted as the indent has changed and so might be a bit more
readable with longer lines. This is not really that critical,
though, so it's good as it stands.

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
