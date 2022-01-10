Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F5C7C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jan 2022 08:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238643AbiAJIwo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jan 2022 03:52:44 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:52888 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241880AbiAJIuj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jan 2022 03:50:39 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 360E062C1B7;
        Mon, 10 Jan 2022 19:50:37 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1n6qNw-00DXh9-AR; Mon, 10 Jan 2022 19:50:36 +1100
Date:   Mon, 10 Jan 2022 19:50:36 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Krister Johansen <kjlx@templeofstupid.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: xfs_bmap_extents_to_btree allocation warnings
Message-ID: <20220110085036.GY945095@dread.disaster.area>
References: <20220105071052.GD20464@templeofstupid.com>
 <20220106010123.GP945095@dread.disaster.area>
 <20220108054014.GA3611@templeofstupid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220108054014.GA3611@templeofstupid.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61dbf35d
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=7-415B0cAAAA:8
        a=QwsbgIsdJNw6LhbZA2wA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 07, 2022 at 09:40:14PM -0800, Krister Johansen wrote:
> On Thu, Jan 06, 2022 at 12:01:23PM +1100, Dave Chinner wrote:
> > On Tue, Jan 04, 2022 at 11:10:52PM -0800, Krister Johansen wrote:
> I wondered if perhaps the problem was related to other problems in
> xfs_alloc_fix_freelist.  Taking inspiration from some of the fixes that
> Brian made here, it looks like there's a possibility of the freelist
> refill code grabbing blocks that were assumed to be available by
> previous checks in that function.
> 
> For example, using some values from a successful trace of a directio
> allocation:
> 
>               dd-102227  [027] .... 4969662.381037: xfs_alloc_near_first: dev 25
> 3:1 agno 0 agbno 5924 minlen 4 maxlen 4 mod 0 prod 1 minleft 1 total 8 alignment
>  4 minalignslop 0 len 4 type NEAR_BNO otype START_BNO wasdel 0 wasfromfl 0 resv
> 0 datatype 0x9 firstblock 0xffffffffffffffff
> 
>               dd-102227  [027] .... 4969662.381047: xfs_alloc_near_first: dev 25
> 3:1 agno 0 agbno 5921 minlen 1 maxlen 1 mod 0 prod 1 minleft 0 total 0 alignment
>  1 minalignslop 0 len 1 type NEAR_BNO otype NEAR_BNO wasdel 0 wasfromfl 0 resv 0
>  datatype 0x0 firstblock 0x1724
> 
> [first is the bmap alloc, second is the extents_to_btree alloc]
>  
> if agflcount = min(pagf_flcount, min_free)
>    agflcount = min(3, 8)
> 
> and available = pagf_freeblks + agflcount - reservation - min_free - minleft
>     available = 14 + 3 - 0 - 8 - 1
> 
>     available = 8
> 
> which satisfies the total from the first allocation request; however, if
> this code path needs to refill the freelists and the ag btree is full
> because a lot of space is allocated and not much is free, then inserts
> here may trigger rebalances.  Usage might look something like this:
> 
>    pagf_freeblks = 14
>    allocate 5 blocks to fill freelist
>    pags_freeblks = 9
>    fill of freelist triggers split that requires 4 nodes
>    next iteration allocates 4 blocks to refill freelist
>    pages_freeblks = 5
>    refill requires rebalance and another node
>    next iteration allocates 1 block to refill freelist
>    pages_freeblks = 4
>    freelist filled; return to caller
> 
>    caller consumes remaining 4 blocks for bmap allocation
> 
>    pages_freeblks = 0
> 
>    no blocks available for xfs_bmap_extents_to_btree

No, can't happen.

When the AG is nearly empty, there is only one block in the AG
freespace trees - the root block. Those root blocks can hold ~500
free space extents. Hence if there are only 14 free blocks left in
the AG, then by definition we have a single level tree and a split
cannot ever occur.

Remember, the AGFL is for space management btree splits and merges,
not for BMBT splits/merges. BMBT blocks are user metadata and have
to be reserved up front from the AG, they are not allocated
from/accounted via the free lists that the AGF freespace and rmap
btrees use for their block management.


> I'm not sure if this is possible, but I thought I'd mention it since
> Brian's prior work here got me thinking about it.  If this does sound
> plausible, what do you think about re-validating the space_available
> conditions after refilling the freelist?  Something like:
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 353e53b..d235744 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2730,6 +2730,16 @@ xfs_alloc_fix_freelist(
>  		}
>  	}
>  	xfs_trans_brelse(tp, agflbp);
> +
> +	/*
> +	 * Freelist refill may have consumed blocks from pagf_freeblks.  Ensure
> +	 * that this allocation still meets its requested constraints by
> +	 * revalidating the min_freelist and space_available checks.
> +	 */
> +	need = xfs_alloc_min_freelist(mp, pag);
> +	if (!xfs_alloc_space_available(args, need, flags))
> +		goto out_agbp_relse;

No, that will just lead to a filesystem shutdown because at ENOSPC
we'll have a transaction containing a dirty AGF/AGFL and freespace
btrees. At that point, the transaction cancellation will see that it
can't cleanly back out and at that point it's all over...

This is also an AGF ABBA deadlock vector, because now we have
a dirty AGF locked in the transaction that we haven't tracked via
t_firstblock....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
