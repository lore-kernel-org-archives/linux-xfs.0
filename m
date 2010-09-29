Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8TCQTij047680 for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 07:26:30 -0500
Subject: Re: [PATCH 3/3] [PATCH 3/3] xfs: do not use
	xfs_mod_incore_sb_batch for per-cpu counters
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100929072238.456748707@bombadil.infradead.org>
References: <20100929072221.583672974@bombadil.infradead.org>
	<20100929072238.456748707@bombadil.infradead.org>
Date: Wed, 29 Sep 2010 07:26:06 -0500
Message-ID: <1285763166.5108.7.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2010-09-29 at 03:22 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-simplify-icsb-updates)
> Update the per-cpu counters manually in xfs_trans_unreserve_and_mod_sb and
> remove support for per-cpu counters from xfs_mod_incore_sb_batch to
> simplify it.  And added benefit is that we don't have to take m_sb_lock
> for transactions that only modify per-cpu counters.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Two undo's have the wrong sign, but if that's fixed this
looks good.

Reviewed-by: Alex Elder <aelder@sgi.com> 

. . .

> Index: xfs/fs/xfs/xfs_trans.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_trans.c	2010-09-29 13:14:08.521557720 +0900
> +++ xfs/fs/xfs/xfs_trans.c	2010-09-29 13:21:58.164557721 +0900
> @@ -1017,55 +1017,61 @@ xfs_trans_unreserve_and_mod_sb(
. . .
> +
> +	/* apply the per-cpu counters */
> +	if (blkdelta) {
> +		error = xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
> +						 blkdelta, rsvd);
> +		if (error)
> +			goto out;
> +	}
> +
> +	if (idelta) {
> +		error = xfs_icsb_modify_counters(mp, XFS_SBS_ICOUNT,
> +						 idelta, rsvd);
> +		if (error)
> +			goto out_undo_fdblocks;
> +	}
> +
> +	if (ifreedelta) {
> +		error = xfs_icsb_modify_counters(mp, XFS_SBS_IFREE,
> +						 ifreedelta, rsvd);
> +		if (error)
> +			goto out_undo_icount;
> +	}
> +
> +	/* apply remaining deltas */
>  
. . .
> +	return;
> +
> +out_undo_ifreecount:
> +	if (ifreedelta)
> +		xfs_icsb_modify_counters(mp, XFS_SBS_IFREE, ifreedelta, rsvd);

*negative* ifreedelta

> +out_undo_icount:
> +	if (idelta)
> +		xfs_icsb_modify_counters(mp, XFS_SBS_ICOUNT, idelta, rsvd);

*negative* idelta

> +out_undo_fdblocks:
> +	if (blkdelta)
> +		xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS, -blkdelta, rsvd);
> +out:



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
