Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBANjC6w127429 for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 17:45:13 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E11ADFAB6D
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 15:45:48 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ojuGLcBs3ncoIOJG for
	<xfs@oss.sgi.com>; Thu, 10 Dec 2009 15:45:48 -0800 (PST)
Date: Thu, 10 Dec 2009 18:45:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] [XFS] Replace per-ag array with a radix tree
Message-ID: <20091210234547.GA28289@infradead.org>
References: <1259734299-20306-1-git-send-email-david@fromorbit.com>
	<1259734299-20306-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1259734299-20306-6-git-send-email-david@fromorbit.com>
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

On Wed, Dec 02, 2009 at 05:11:38PM +1100, Dave Chinner wrote:
> -		down_read(&mp->m_peraglock);
> +		pag = xfs_perag_get(mp, ag);
>  		while (blen < ap->alen) {
> -			pag = xfs_perag_get(mp, ag);
>  			if (!pag->pagf_init &&
>  			    (error = xfs_alloc_pagf_init(mp, args.tp,
>  				    ag, XFS_ALLOC_FLAG_TRYLOCK))) {
>  				xfs_perag_put(pag);
> -				up_read(&mp->m_peraglock);
>  				return error;
>  			}
>  			/*
> @@ -2801,7 +2799,6 @@ xfs_bmap_btalloc(
>  			} else
>  				notinit = 1;
>  
> -			xfs_perag_put(pag);

There's a lot of those xfs_perag_get/put moved around here.  Having
those merged into the patch that adds them would be a lot cleaner.

> +	/* allocate the new per-ag structures */
>  	if (nagcount > oagcount) {
> +		/* XXX: (dgc) We don't need the filestream flush anymore? */
>  		xfs_filestream_flush(mp);

What was the reason to have it in the first time?

> index 3727104..d6de63d 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -207,13 +207,17 @@ STATIC void
>  xfs_free_perag(
>  	xfs_mount_t	*mp)
>  {
> +	xfs_agnumber_t	agno;
> +	struct xfs_perag *pag;
> +
> +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> +		spin_lock(&mp->m_perag_lock);
> +		pag = radix_tree_delete(&mp->m_perag_tree, agno);
> +		spin_unlock(&mp->m_perag_lock);
> +		if (!pag)
> +			continue;

Shouldn't this be a BUG_ON/ASSERT?

> +	/*
> +	 * Walk the current per-ag tree so we don't try to initialise AGs
> +	 * that already exist (growfs case). Allocate and insert all the
> +	 * AGs we don't find ready for initialisation.
> +	 */
> +	for (index = 0; index < agcount; index++) {
> +		pag = xfs_perag_get(mp, index);
> +		if (pag) {
> +			xfs_perag_put(pag);
> +			continue;
> +		}
> +		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
> +		if (!pag)
> +			return -ENOMEM;
> +		if (radix_tree_preload(GFP_NOFS))
> +			return -ENOMEM;

Leaks the pag object on failure.

>  	mp->m_maxagi = xfs_initialize_perag(mp, sbp->sb_agcount);
> +	if ((int)mp->m_maxagi < 0) {
> +		cmn_err(CE_WARN, "XFS: Failed per-ag initialisation: %d",
> +				(int)mp->m_maxagi);
> +		error = mp->m_maxagi;
>
Just assign it to error first and then later to mp->m_maxagi to avoid
the cast?

>  static inline xfs_perag_t *
>  xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
>  {
> -	return &mp->m_perag[agno];
> +	struct xfs_perag	*pag;
> +
> +	spin_lock(&mp->m_perag_lock);
> +	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
> +	spin_unlock(&mp->m_perag_lock);
> +	return pag;

Can't we do this as a lock-less (at least for lookups) radix tree?

And btw, I think we should still have a global sleeping lock to
serialize the whole growfs operation against other potentional growfs
callers.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
