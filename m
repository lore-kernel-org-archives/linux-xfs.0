Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6G1x3KR230044 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 20:59:03 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EE0401507CB2
	for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 18:59:02 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	nND1diB5yhrn3c5R for <xfs@oss.sgi.com>;
	Fri, 15 Jul 2011 18:59:02 -0700 (PDT)
Date: Fri, 15 Jul 2011 21:59:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/12] xfs: Remove the macro XFS_BUF_ZEROFLAGS
Message-ID: <20110716015901.GC589@infradead.org>
References: <20110716012105.6629.24407.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110716012116.6629.48217.sendpatchset@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110716012116.6629.48217.sendpatchset@chandra-lucid.beaverton.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1367,7 +1367,7 @@ xlog_sync(xlog_t		*log,
>  	}
>  	XFS_BUF_SET_COUNT(bp, count);
>  	XFS_BUF_SET_FSPRIVATE(bp, iclog);	/* save for later */
> -	XFS_BUF_ZEROFLAGS(bp);
> +	bp->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI|XBF_ORDERED);
>  	XFS_BUF_BUSY(bp);
>  	XFS_BUF_ASYNC(bp);
>  	bp->b_flags |= XBF_LOG_BUFFER;

Note that XBF_ORDERED is gone in the current tree, you need to rebase
your patches to pick up the buffer changes I recently sent out.

I don't link this blind expansion.  For one all that flag setting is
duplicated in two places in xlog_sync, please send a patch to
consolidate it in xlog_bdstrat.  Second XBF_READ and XBF_DELWRI
won't ever be set here, so no need to clear them.  And XBF_WRITE
and XBF_ASYNC will get re-set a few lines down the code, so no need
to clear them either.  The XBF_FLUSH and XBF_FUA flag also get set
conditionally a little below, so I'd just clear them in an else
clause for the if condition checking if they should be set.

> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 04142ca..75ba081 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -261,7 +261,7 @@ xlog_bwrite(
>  	ASSERT(BBTOB(nbblks) <= XFS_BUF_SIZE(bp));
>  
>  	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
> -	XFS_BUF_ZEROFLAGS(bp);
> +	bp->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC|XBF_DELWRI|XBF_ORDERED);
>  	XFS_BUF_BUSY(bp);
>  	XFS_BUF_HOLD(bp);
>  	XFS_BUF_PSEMA(bp, PRIBIO);

XBF_READ, XBF_WRITE, XBF_ASYNC and XBF_DELWRI already get dealt with
in xfs_bwrite a few lines down, and XBF_ORDERED can't be set here. IOW
this line can simply be removed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
