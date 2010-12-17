Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBHBN9G9222564 for <xfs@oss.sgi.com>; Fri, 17 Dec 2010 05:23:09 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6AA59145EDFD
	for <xfs@oss.sgi.com>; Fri, 17 Dec 2010 03:25:03 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id r1q6OZCPUJtsvk5M for
	<xfs@oss.sgi.com>; Fri, 17 Dec 2010 03:25:03 -0800 (PST)
Date: Fri, 17 Dec 2010 06:25:02 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/9] xfs: bulk AIL insertion during transaction commit
Message-ID: <20101217112502.GC12965@infradead.org>
References: <1292214743-18073-1-git-send-email-david@fromorbit.com>
	<1292214743-18073-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292214743-18073-5-git-send-email-david@fromorbit.com>
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


Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Minor style nipicks below:

> +			/*
> +			 * Not a bulk update option due to unusual item_lsn.
> +			 * Push into AIL immediately, rechecking the lsn once
> +			 * we have the ail lock. Then unpin the item.
> +			 */
> +			spin_lock(&ailp->xa_lock);
> +			if (XFS_LSN_CMP(item_lsn, lip->li_lsn) > 0) {
> +				xfs_trans_ail_update(ailp, lip, item_lsn);
> +			} else {
> +				spin_unlock(&ailp->xa_lock);
> +			}

No need for the curly braces.

> +	ASSERT((&next_lip->li_ail == &ailp->xa_ail) ||
> +	       (XFS_LSN_CMP(next_lip->li_lsn, lsn) <= 0));

No need for the inner braces.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
