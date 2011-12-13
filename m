Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBD2E764132723 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 20:14:07 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 68FD71A67D10
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 18:12:11 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	XUum8UzvFt2sS6dN for <xfs@oss.sgi.com>;
	Mon, 12 Dec 2011 18:12:11 -0800 (PST)
Date: Tue, 13 Dec 2011 13:12:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/12] repair: update extent count after zapping
	duplicate blocks
Message-ID: <20111213021207.GY14273@dastard>
References: <20111202174619.179530033@bombadil.infradead.org>
	<20111202174741.904845954@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111202174741.904845954@bombadil.infradead.org>
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

On Fri, Dec 02, 2011 at 12:46:24PM -0500, Christoph Hellwig wrote:
> When we find a duplicate extent in an extern format inode we do not zap
> the whole inode, but just truncate it to the point where the duplicate
> extent was found.  But the current code only updates di_nblocks for the
> new size, but no di_nextents/di_anextents.  In most cases this isn't noticed,
> but when moving such an inode to the lost+found directoy the consistency
> check in xfs_iformat trips over it.  Fix this by updating the on-disk
> extent count as part of the inode repair.
> 
> Note that we zap btree format inodes with duplicate block completely
> at this point, so this fix doesn't apply to them.
> 
> Reported-by: Arkadiusz Mi??kiewicz <arekm@maven.pl>
> Tested-by: Arkadiusz Mi??kiewicz <arekm@maven.pl>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

.....

> @@ -2003,6 +2016,12 @@ process_inode_blocks_and_extents(
>  	xfs_ino_t	lino,
>  	int		*dirty)
>  {
> +	if (nblocks < nextents + anextents) {
> +		do_warn(
> +_("nblocks (%" PRIu64 ") smaller than nextents for inode %" PRIu64 "\n"), nblocks, lino);
> +		return 1;
> +	}
> +

I thikn that should be done after validating then block/extent
counts as otherwise it doesn't handle overflows.

It also took me a moment to realise the comparison was valid
- the confusion came from the fact you are comparing different units
(block count vs extent count). It didn't occur to me immediately
that this check is valid because an extent must contain one or
more blocks, so perhaps a comment is in order.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
