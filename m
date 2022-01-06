Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE9C2C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jan 2022 01:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240032AbiAFBB2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 20:01:28 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55295 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240018AbiAFBB1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 20:01:27 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1B71110C00D5;
        Thu,  6 Jan 2022 12:01:25 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1n5H9f-00BqJY-LV; Thu, 06 Jan 2022 12:01:23 +1100
Date:   Thu, 6 Jan 2022 12:01:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Krister Johansen <kjlx@templeofstupid.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: xfs_bmap_extents_to_btree allocation warnings
Message-ID: <20220106010123.GP945095@dread.disaster.area>
References: <20220105071052.GD20464@templeofstupid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105071052.GD20464@templeofstupid.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61d63f66
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=7-415B0cAAAA:8
        a=j3tFSnce2iJBKk_aEHIA:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 04, 2022 at 11:10:52PM -0800, Krister Johansen wrote:
> Hi,
> I've been running into occasional WARNs related to allocating a block to
> hold the new btree that XFS is attempting to create when calling this
> function.  The problem is sporadic -- once every 10-40 days and a
> different system each time.

The warning is:

> WARNING: CPU: 4 PID: 115756 at fs/xfs/libxfs/xfs_bmap.c:716 xfs_bmap_extents_to_btree+0x3dc/0x610 [xfs]
> RIP: 0010:xfs_bmap_extents_to_btree+0x3dc/0x610 [xfs]
> Call Trace:
>  xfs_bmap_add_extent_hole_real+0x7d9/0x8f0 [xfs]
>  xfs_bmapi_allocate+0x2a8/0x2d0 [xfs]
>  xfs_bmapi_write+0x3a9/0x5f0 [xfs]
>  xfs_iomap_write_direct+0x293/0x3c0 [xfs]
>  xfs_file_iomap_begin+0x4d2/0x5c0 [xfs]
>  iomap_apply+0x68/0x160
>  iomap_dio_rw+0x2c1/0x450
>  xfs_file_dio_aio_write+0x103/0x2e0 [xfs]
>  xfs_file_write_iter+0x99/0xe0 [xfs]
>  new_sync_write+0x125/0x1c0
>  __vfs_write+0x29/0x40
>  vfs_write+0xb9/0x1a0
>  ksys_write+0x67/0xe0
>  __x64_sys_write+0x1a/0x20
>  do_syscall_64+0x57/0x190
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Which is indicative of a multi-extent allocation (i.e. data extent +
BMBT indexing btree block allocations) not selecting an AG that has
enough space for both data and BMBT blocks to be allocated.

That's likely because args.total was not set correctly before AG
selection was made. This exact sort of bug can be seen in the fix
for recent error injection debug code in commit 6e8bd39d7227 ("xfs:
Initialize xfs_alloc_arg->total correctly when allocating minlen
extents"). You're not running a CONFIG_XFS_DEBUG=y kernel are you?

In this case:

> The process that's triggering the problem is dd punching a hole into
> file via direct I/O.  It's doing this as part of a watchdog process to
> ensure that the system remains able to issue read and write requests.
> The direct I/O is an attempt to avoid reading/writing cached data from
> this process.
> 
> I'm hardly an expert; however, after some digging it appears that the
> direct I/O path for this particular workload is more susceptible to the
> problem because its tp->t_firstblock is always set to a block in an
> existing AG,

Which is always true for BMBT block allocation - we've already
allocated the data extent in the transaction in
xfs_bmap_add_extent_hole_real(), and now we are doing the BMBT block
allocation needed to convert the extent list inline in the inode
literal area into external btree block format.

> while the rest of the I/O on this filesystem goes through
> the page cache and uses the delayed allocation mechanism by default.
> (IOW, t_firstblock is NULLFSBLOCK most of the time.)

Has nothing to do with delayed allocation - the physical allocation
that occurs in writeback will do exactly the same thing as direct IO
allocation....

> It seemed like one reason for keeping the bmap and the inode in the same
> AG might be that with 32-bit block pointers in an inode there wouldn't
> be space to store the AG and the block if the btree were allocated in a
> different AG.

The BMBT is a 64 bit btree so can index blocks anywhere in the
filesystem. 32 bit btree indexes are only used for internal
references within an AG, not for user data.

> It also seemed like there were lock order concerns when
> iterating over multiple AGs.

yes, that's what t_firstblock is used to avoid - AGFs must be locked
in ascending order only.

> However, linux is using 64-bit block
> pointers in the inode now and the XFS_ALLOCTYPE_START_BNO case in
> xfs_alloc_vextent() seems to try to ensure that it never considers an AG
> that's less than the agno for the fsbno passed in via args.

Because otherwise allocations ABBA deadlock on AG locking.

> Would something like this:
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 4dccd4d90622..5d949ac1ecae 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -664,6 +664,13 @@ xfs_bmap_extents_to_btree(
>  	if (error)
>  		goto out_root_realloc;
>  
> +	if (args.fsbno == NULLFSBLOCK && args.type == XFS_ALLOCTYPE_NEAR_BNO) {
> +		args.type = XFS_ALLOCTYPE_START_BNO;
> +		error = xfs_alloc_vextent(&args);
> +		if (error)
> +			goto out_root_realloc;
> +	}
> +
>  	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
>  		error = -ENOSPC;
>  		goto out_root_realloc;

It might, but it doesn't fix the root cause which is that we
selected an AG without enough space in it for the entire chain of
allocations in the first place.

> Or this:
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 4dccd4d90622..94e4ecb75561 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -647,14 +647,10 @@ xfs_bmap_extents_to_btree(
>  	args.tp = tp;
>  	args.mp = mp;
>  	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, whichfork);
> +	args.type = XFS_ALLOCTYPE_START_BNO;
>  	if (tp->t_firstblock == NULLFSBLOCK) {
> -		args.type = XFS_ALLOCTYPE_START_BNO;
>  		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
> -	} else if (tp->t_flags & XFS_TRANS_LOWMODE) {
> -		args.type = XFS_ALLOCTYPE_START_BNO;
> -		args.fsbno = tp->t_firstblock;
>  	} else {
> -		args.type = XFS_ALLOCTYPE_NEAR_BNO;
>  		args.fsbno = tp->t_firstblock;
>  	}
>  	args.minlen = args.maxlen = args.prod = 1;

Same again - hides the symptom, doesn't address the root cause.

> be a reasonable way to address the WARN?  Or does this open a box of
> problems that obvious to the experienced, but just subtle enough to
> elude the unfamiliar?

No, yes, and yes.

> I ask because these filesystems are pretty busy on a day to day basis
> and the path where t_firstblock is NULLFSBLOCK is never hitting this
> problem.  The overall workload is a btree based database.  Lots of
> random reads and writes to many files that all live in the same
> directory.

Which indicates that you are likely hitting AG full conditions more
frequently than not.

> meta-data=/dev/mapper/db-vol     isize=512    agcount=32, agsize=228849020 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1
....
> The xfs_db freesp report after the problem occurred.  (N.B. it was a few
> hours before I was able to get to this machine to investigate)
> 
> xfs_db -r -c 'freesp -a 47 -s' /dev/mapper/db-vol
>    from      to extents  blocks    pct
>       1       1      48      48   0.00
>       2       3     119     303   0.02
>       4       7      46     250   0.01
>       8      15      22     255   0.01
>      16      31      17     374   0.02
>      32      63      16     728   0.04
>      64     127       9     997   0.05
>     128     255     149   34271   1.83
>     256     511       7    2241   0.12
>     512    1023       4    2284   0.12
>    1024    2047       1    1280   0.07
>    2048    4095       1    3452   0.18
> 1048576 2097151       1 1825182  97.52
> total free extents 440
> total free blocks 1871665
> average free extent size 4253.78

So 1,871,665 of 228,849,020 blocks free in the AG. That's 99.2%
full, so it's extremely likely you are hitting a full AG condition.

/me goes and looks at xfs_iomap_write_direct()....

.... and notices that it passes "0" as the total allocation block
count, which means it isn't reserving space in the AG for both the
data extent and the BMBT blocks...

... and several other xfs_bmapi_write() callers have the same
issue...

Ok, let me spend a bit more looking into this in more depth, but it
looks like the problem is at the xfs_bmapi_write() caller level, not
deep in the allocator itself.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
