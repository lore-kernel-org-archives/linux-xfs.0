Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6FI9VAH216485 for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 13:09:31 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FC3215C0F0F
	for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 11:18:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id WMEUv79y4EyQquNA for
	<xfs@oss.sgi.com>; Thu, 15 Jul 2010 11:18:45 -0700 (PDT)
Date: Thu, 15 Jul 2010 14:12:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfs: track AGs with reclaimable inodes in per-ag
	radix tree
Message-ID: <20100715181228.GC14554@infradead.org>
References: <1279194418-16119-1-git-send-email-david@fromorbit.com>
	<1279194418-16119-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1279194418-16119-4-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

> + */
> +static struct xfs_perag *
> +xfs_inode_ag_iter_next_pag(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		*first,
> +	int			tag)
> +{
> +	struct xfs_perag	*pag = NULL;
> +
> +	if (tag == XFS_ICI_RECLAIM_TAG) {
> +		int found;
> +		int ref;
> +
> +		spin_lock(&mp->m_perag_lock);
> +		found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
> +				(void **)&pag, *first, 1, tag);
> +		if (found <= 0) {
> +			spin_unlock(&mp->m_perag_lock);
> +			return NULL;
> +		}
> +		*first = pag->pag_agno + 1;
> +		/* open coded pag reference increment */
> +		ref = atomic_inc_return(&pag->pag_ref);
> +		spin_unlock(&mp->m_perag_lock);
> +		trace_xfs_perag_get_reclaim(mp, pag->pag_agno, ref, _RET_IP_);
> +	} else {
> +		pag = xfs_perag_get(mp, *first);
> +		(*first)++;
> +	}

I wonder if we should just split the AG iterator for inode reclaim vs
the rest.  We now have this difference in addition to taking the per-AG
lock exclusive instead of shared.

Anyway, the patch looks good for now,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
