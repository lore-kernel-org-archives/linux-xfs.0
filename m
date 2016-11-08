Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:26674 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750938AbcKHGPz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2016 01:15:55 -0500
Date: Tue, 8 Nov 2016 17:15:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: fix the AG loop in xfs_alloc_vextent for busy
 extents
Message-ID: <20161108061539.GB28922@dastard>
References: <1476735753-5861-1-git-send-email-hch@lst.de>
 <1476735753-5861-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476735753-5861-2-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, michaelcallahan@fb.com

On Mon, Oct 17, 2016 at 10:22:31PM +0200, Christoph Hellwig wrote:
> If we have too many busy extents, or just enough to make our wanted
> allocation impossible we will never move on to another AG in
> xfs_alloc_vextent currently.  Change the loop exit condition to keep
> looking for an AG if we can't allocate an extent.
> 
> For the single AG cases we don't need to change anything as the higher
> layers need to handle this case.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index effb64c..0a04bec 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2753,13 +2753,18 @@ xfs_alloc_vextent(
>  				trace_xfs_alloc_vextent_nofix(args);
>  				goto error0;
>  			}
> +
>  			/*
> -			 * If we get a buffer back then the allocation will fly.
> +			 * If we get a buffer back then the allocation will fly,
> +			 * unless there are busy extents in the way.
>  			 */
>  			if (args->agbp) {
> -				if ((error = xfs_alloc_ag_vextent(args)))
> +				error = xfs_alloc_ag_vextent(args);
> +				if (error)
>  					goto error0;
> -				break;
> +				if (args->agbno != NULLAGBLOCK)
> +					break;
> +				xfs_trans_brelse(args->tp, args->agbp);
>  			}
>  
>  			trace_xfs_alloc_vextent_loopfailed(args);

Here's the problem: At ENOSPC, we dirty AG headers fixing freelists,
then fail to allocate inodes, resulting in a shutdown - a regression
that xfs/076 trips over quite regularly on my test machines.

XFS (pmem1): Internal error xfs_trans_cancel at line 983 of file fs/xfs/xfs_trans.c.  Caller xfs_create+0x498/0x780
CPU: 3 PID: 19236 Comm: touch Not tainted 4.9.0-rc4-dgc+ #1019
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Debian-1.8.2-1 04/01/2014
 ffffc900144dbb28 ffffffff81822480 ffff880239580500 ffff88023abd8000
 ffffc900144dbb40 ffffffff8152340c ffffffff81534708 ffffc900144dbb80
 ffffffff8154570b 0000000100000000 ffff88032e9ff800 ffff88023abd8000
Call Trace:
 [<ffffffff81822480>] dump_stack+0x63/0x83
 [<ffffffff8152340c>] xfs_error_report+0x3c/0x40
 [<ffffffff81534708>] ? xfs_create+0x498/0x780
 [<ffffffff8154570b>] xfs_trans_cancel+0x12b/0x150
 [<ffffffff81534708>] xfs_create+0x498/0x780
 [<ffffffff815325af>] xfs_generic_create+0x1df/0x2c0
 [<ffffffff815326c6>] xfs_vn_create+0x16/0x20
 [<ffffffff812120c2>] path_openat+0x1312/0x13e0
 [<ffffffff811a4c86>] ? unlock_page+0x36/0x40
 [<ffffffff8121335e>] do_filp_open+0x7e/0xe0
 [<ffffffff8121234f>] ? getname_flags+0x4f/0x1f0
 [<ffffffff811f81c2>] ? kmem_cache_alloc+0x42/0x180
 [<ffffffff81c8e960>] ? _raw_spin_unlock+0x10/0x30
 [<ffffffff812219e2>] ? __alloc_fd+0xb2/0x160
 [<ffffffff81200fe3>] do_sys_open+0x123/0x200
 [<ffffffff812010de>] SyS_open+0x1e/0x20
 [<ffffffff81c8efb7>] entry_SYSCALL_64_fastpath+0x1a/0xa9

You're going to have to rethink this one, Christoph.

Cheers,

Dave.
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Dave Chinner
david@fromorbit.com
