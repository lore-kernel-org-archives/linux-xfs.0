Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8PNn2wV258678 for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 18:49:02 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 780101D9483A
	for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 16:49:31 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id iDWF2qpoFpp1Stk5 for
	<xfs@oss.sgi.com>; Sat, 25 Sep 2010 16:49:31 -0700 (PDT)
Date: Sat, 25 Sep 2010 19:49:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 16/18] xfs: serialise inode reclaim within an AG
Message-ID: <20100925234929.GB23975@infradead.org>
References: <1285331476-23015-1-git-send-email-david@fromorbit.com>
	<1285331476-23015-17-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1285331476-23015-17-git-send-email-david@fromorbit.com>
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

I really don't like the way the "trylock" variable is overloaded here.
Just add a new skipped variable for restarting the scan and otherwise
use (flags & SYNC_TRYLOCK) directly.

> +	int			trylock = !!(flags & SYNC_TRYLOCK);
>  
> +restart:
>  	ag = 0;
>  	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
>  		unsigned long	first_index = 0;
> @@ -837,6 +839,17 @@ xfs_reclaim_inodes_ag(
>  
>  		ag = pag->pag_agno + 1;
>  
> +		if (!mutex_trylock(&pag->pag_ici_reclaim_lock)) {
> +			if (trylock) {
> +				trylock++;
> +				continue;
> +			}
> +			mutex_lock(&pag->pag_ici_reclaim_lock);
> +		}
> +
> +		if (trylock)
> +			first_index = pag->pag_ici_reclaim_cursor;

Also this could be made more clear by:

	if (flags & SYNC_TRYLOCK) {
		if (!mutex_trylock(&pag->pag_ici_reclaim_lock)) {
			skipped++;
			continue;
		}

		first_index = pag->pag_ici_reclaim_cursor;
	} else {
		mutex_lock(&pag->pag_ici_reclaim_lock);
	}

> +
>  		do {
>  			struct xfs_inode *batch[XFS_LOOKUP_BATCH];
>  			int	i;
> @@ -889,8 +902,19 @@ xfs_reclaim_inodes_ag(
>  
>  		} while (nr_found && !done && *nr_to_scan > 0);
>  
> +		pag->pag_ici_reclaim_cursor = (done || !trylock) ? 0 : first_index;

		if ((flags & SYNC_TRYLOCK) && !done)
			pag->pag_ici_reclaim_cursor = first_index;
		else
			pag->pag_ici_reclaim_cursor = 0;

> +	/*
> +	 * if we skipped any AG, and we still have scan count remaining, do
> +	 * another pass this time waiting on the reclaim locks.
> +	 */
> +	if (trylock > 1 && *nr_to_scan) {
> +		trylock = 0;
> +		goto restart;
> +	}

In addition to waiting on the lock this also ignores the reclaim cursor.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
