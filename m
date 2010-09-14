Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8ENFtjF152960 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 18:15:56 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2612914687FD
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 16:16:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id kX7HCpP0EfZcNn99 for
	<xfs@oss.sgi.com>; Tue, 14 Sep 2010 16:16:45 -0700 (PDT)
Date: Tue, 14 Sep 2010 19:16:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 17/18] xfs: add a lru to the XFS buffer cache
Message-ID: <20100914231644.GB29338@infradead.org>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-18-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1284461777-1496-18-git-send-email-david@fromorbit.com>
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


Looks correct to me, although probably indeed a bit simplistic.

> +		/* add to LRU */
> +		spin_lock(&btp->bt_lru_lock);
> +		list_add_tail(&new_bp->b_lru, &btp->bt_lru);
> +		btp->bt_lru_nr++;
> +		atomic_inc(&new_bp->b_hold);
> +		spin_unlock(&btp->bt_lru_lock);

Just for clarity it would be nice to have this as an xfs_buf_lru_add
helper.

> +			/* remove from LRU */
> +			spin_lock(&btp->bt_lru_lock);
> +			list_del_init(&bp->b_lru);
> +			btp->bt_lru_nr--;
> +			spin_unlock(&btp->bt_lru_lock);

And this ad xfs_buf_lru_del.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
