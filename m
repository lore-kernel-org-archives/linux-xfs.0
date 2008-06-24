Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jun 2008 21:57:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5O4vj6v002224
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 21:57:46 -0700
Date: Mon, 23 Jun 2008 21:58:41 -0700
From: Dave Chinner <dchinner@agami.com>
Subject: Re: [PATCH 1/2] set minleft in xfs_bmbt_split()
Message-ID: <20080624045841.GN16257@build-svl-1.agami.com>
References: <48605744.8070400@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48605744.8070400@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Jun 24, 2008 at 12:09:08PM +1000, Lachlan McIlroy wrote:
> The bmap btree split code relies on a previous data extent allocation
> (from xfs_bmap_btalloc()) to find an AG that has sufficient space
> to perform a full btree split, when inserting the extent.  When
> converting unwritten extents we don't allocate a data extent so a
> btree split will be the first allocation.  In this case we need to
> set minleft so the allocator will pick an AG that has space to
> complete the split(s).

looks good, execpt...

> 
> Lachlan
> 
> --- 2.6.x-agno2.orig/fs/xfs/xfs_bmap_btree.c
> +++ 2.6.x-agno2/fs/xfs/xfs_bmap_btree.c
> @@ -1493,12 +1493,20 @@ xfs_bmbt_split(
> 	left = XFS_BUF_TO_BMBT_BLOCK(lbp);
> 	args.fsbno = cur->bc_private.b.firstblock;
> 	args.firstblock = args.fsbno;
> +	args.minleft = 0;
> 	if (args.fsbno == NULLFSBLOCK) {
> 		args.fsbno = lbno;
> 		args.type = XFS_ALLOCTYPE_START_BNO;
> +		/*
> +		 * Make sure there is sufficient room left in the AG to
> +		 * complete a full tree split for an extent insert.  If
> +		 * we are converting the middle part of an extent then
> +		 * we may need space for two tree splits.
> +		 */
> +		args.minleft = xfs_trans_get_block_res(args.tp);

I'd mention in this comment that transaction reservation needs to
take this specifically into account. It is probably also worth
adding a matching comment to xfs_iomap_write_unwritten() where
the double reservation is done (i.e. explain the magic "<< 1").

Cheers,

Dave.
-- 
Dave Chinner
dchinner@agami.com
