Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA31AC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jan 2022 08:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241963AbiAJIoB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jan 2022 03:44:01 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:56885 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242013AbiAJIl7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jan 2022 03:41:59 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 49CFE10C0769;
        Mon, 10 Jan 2022 19:41:53 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1n6qFU-00DXbS-EB; Mon, 10 Jan 2022 19:41:52 +1100
Date:   Mon, 10 Jan 2022 19:41:52 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Krister Johansen <kjlx@templeofstupid.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: xfs_bmap_extents_to_btree allocation warnings
Message-ID: <20220110084152.GX945095@dread.disaster.area>
References: <20220105071052.GD20464@templeofstupid.com>
 <20220106010123.GP945095@dread.disaster.area>
 <20220106085228.GA19131@templeofstupid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106085228.GA19131@templeofstupid.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61dbf153
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=7-415B0cAAAA:8
        a=J4HbylmhB1wtlE8kDu4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 06, 2022 at 12:52:28AM -0800, Krister Johansen wrote:
> On Thu, Jan 06, 2022 at 12:01:23PM +1100, Dave Chinner wrote:
> > On Tue, Jan 04, 2022 at 11:10:52PM -0800, Krister Johansen wrote:
> > > However, linux is using 64-bit block
> > > pointers in the inode now and the XFS_ALLOCTYPE_START_BNO case in
> > > xfs_alloc_vextent() seems to try to ensure that it never considers an AG
> > > that's less than the agno for the fsbno passed in via args.
> > 
> > Because otherwise allocations ABBA deadlock on AG locking.
> 
> Sorry, what I'm really trying to ask is: are there still cases in XFS
> where using XFS_ALLOCTYPE_START_BNO can give you this kind of deadlock?

I'd say yes - I can think of several scenarios where we make
multiple allocations per transaction (directory and attribute code)
and I think that they don't actually use t_firstblock correctly to
avoid AGF locking issues. i.e. I think that tp->t_firstblock should
actually be tracking the highest locked AGF in the transaction, not
the first AGF we locked...

> There's some deadlock avoidance in the START_BNO implementation, but
> there are plenty of places where XFS_ALLOCTYPE_NEAR_BNO is still used if
> t_firstblock is not NULLFSBLOCK.

Right, NEAR_BNO is used because we likely have physical locality
constraints (e.g. seek minimisation by placing related blocks as
close to each other as possible) and potentially other limits, like
the allocations are for per-AG data and therefore must be placed
within the specified AG...

> I'm trying to work out if that code
> still exists because of concerns about deadlocks, or if its an attempt
> to limit the number of AGs searched instead.  (Or some other policy
> choice, even.)

All of the above, and more... :(

> > > be a reasonable way to address the WARN?  Or does this open a box of
> > > problems that obvious to the experienced, but just subtle enough to
> > > elude the unfamiliar?
> > 
> > No, yes, and yes.
> 
> Thank you humoring my questions nonetheless.
> 
> > > The xfs_db freesp report after the problem occurred.  (N.B. it was a few
> > > hours before I was able to get to this machine to investigate)
> > > 
> > > xfs_db -r -c 'freesp -a 47 -s' /dev/mapper/db-vol
> > >    from      to extents  blocks    pct
> > >       1       1      48      48   0.00
> > >       2       3     119     303   0.02
> > >       4       7      46     250   0.01
> > >       8      15      22     255   0.01
> > >      16      31      17     374   0.02
> > >      32      63      16     728   0.04
> > >      64     127       9     997   0.05
> > >     128     255     149   34271   1.83
> > >     256     511       7    2241   0.12
> > >     512    1023       4    2284   0.12
> > >    1024    2047       1    1280   0.07
> > >    2048    4095       1    3452   0.18
> > > 1048576 2097151       1 1825182  97.52
> > > total free extents 440
> > > total free blocks 1871665
> > > average free extent size 4253.78
> > 
> > So 1,871,665 of 228,849,020 blocks free in the AG. That's 99.2%
> > full, so it's extremely likely you are hitting a full AG condition.
> > 
> > /me goes and looks at xfs_iomap_write_direct()....
> > 
> > .... and notices that it passes "0" as the total allocation block
> > count, which means it isn't reserving space in the AG for both the
> > data extent and the BMBT blocks...
> > 
> > ... and several other xfs_bmapi_write() callers have the same
> > issue...
> > 
> > Ok, let me spend a bit more looking into this in more depth, but it
> > looks like the problem is at the xfs_bmapi_write() caller level, not
> > deep in the allocator itself.
> 
> At least on 5.4 xfs_bmapi_write is still passing resblks instead of
> zero, which is computed in xfs_iomap_write_direct.

yup, I missed commit da781e64b28c ("xfs: don't set bmapi total block
req where minleft is") back in 2019 where that behaviour was
changed, and instead it changes xfs_bmapi_write() to implcitly
manage space for BMBT blocks via args->minleft whilst still
explicitly requiring the caller to reserve those blocks at
transaction allocation time.

Bit of a mess, really, because multi-allocation transactions are
still required to pass both the data blocks + the possible BMBT
blocks that might be needed to xfs_bmapi_write(). I suspect that for
this case the implicit args->minleft reservation is double
accounted...

> Related to your comment about alloc_args.total, I did a bit of tracing
> of the xfs_alloc tracepoints on my system and found that total seems to
> be getting set in both cases, but that a) it's actually a larger value
> for directio; and b) in the buffered write case the code is requesting
> more blocks at one time which causes a larger allocation to occur.  I'm
> not certain, but wondered if this could be causing us to select an AG
> with more space by luck.
> 
> directio:
> 
>               dd-102229  [005] .... 4969662.383215: xfs_alloc_exact_done: dev 253:1 agno 0 agbno 14240 minlen 4 maxlen 4 mod 0 prod 1 minleft 2 total 8 alignment 1 minalignslop 3 len 4 type THIS_BNO otype THIS_BNO wasdel 0 wasfromfl 0 resv 0 datatype 0x9 firstblock 0xffffffffffffffff

That one is correct - 4 extra blocks on top of the data extent...

> buffered write + fsync:
> 
>               dd-109921  [010] .... 4972814.844429: xfs_alloc_exact_done: dev 253:1 agno 0 agbno 21280 minlen 16 maxlen 16 mod 0 prod 1 minleft 2 total 4 alignment 1 minalignslop 3 len 16 type THIS_BNO otype THIS_BNO wasdel 1 wasfromfl 0 resv 0 datatype 0x9 firstblock 0xffffffffffffffff

But that one is clearly wrong - we're asking for 16 blocks for the
data extent, and a total block count of the allocation of 4 blocks.
Even though we've reserved 16 blocks during the initial delayed
allocation, we've still got to have 16 + 4 blocks free in the AG for
the allocation to succced. That's one of the bugs the commit I
mentioned above fixed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
