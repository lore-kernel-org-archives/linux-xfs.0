Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0DHI55E150552 for <xfs@oss.sgi.com>; Fri, 13 Jan 2012 11:18:05 -0600
Message-ID: <4F10674B.7030904@sgi.com>
Date: Fri, 13 Jan 2012 11:18:03 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 05/12] repair: update extent count after zapping duplicate
	blocks
References: <20111202174619.179530033@bombadil.infradead.org>
	<20111202174741.904845954@bombadil.infradead.org>
In-Reply-To: <20111202174741.904845954@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 01/-10/63 13:59, Christoph Hellwig wrote:
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
> Reported-by: Arkadiusz Mi??kiewicz<arekm@maven.pl>
> Tested-by: Arkadiusz Mi??kiewicz<arekm@maven.pl>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
>
> Index: xfsprogs-dev/repair/dinode.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/dinode.c	2011-11-08 12:15:40.000000000 +0000
> +++ xfsprogs-dev/repair/dinode.c	2011-11-14 12:09:54.000000000 +0000

> @@ -2003,6 +2016,12 @@ process_inode_blocks_and_extents(
>   	xfs_ino_t	lino,
>   	int		*dirty)
>   {
> +	if (nblocks<  nextents + anextents) {
> +		do_warn(
> +_("nblocks (%" PRIu64 ") smaller than nextents for inode %" PRIu64 "\n"), nblocks, lino);
> +		return 1;
> +	}
> +

I agree with David on an inserted comment and relocation. I would not 
have figured out this test without David's observation.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
