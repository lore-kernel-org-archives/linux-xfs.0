Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADB8CC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jan 2022 08:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237098AbiAFIwc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Jan 2022 03:52:32 -0500
Received: from beige.elm.relay.mailchannels.net ([23.83.212.16]:20085 "EHLO
        beige.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237097AbiAFIwb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jan 2022 03:52:31 -0500
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id B63F212177C
        for <linux-xfs@vger.kernel.org>; Thu,  6 Jan 2022 08:52:30 +0000 (UTC)
Received: from pdx1-sub0-mail-a305.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 52B0512171D
        for <linux-xfs@vger.kernel.org>; Thu,  6 Jan 2022 08:52:30 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from pdx1-sub0-mail-a305.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.99.165.222 (trex/6.4.3);
        Thu, 06 Jan 2022 08:52:30 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Bitter-Bored: 34a27d79253cbce4_1641459150568_368578095
X-MC-Loop-Signature: 1641459150568:2385509568
X-MC-Ingress-Time: 1641459150567
Received: from kmjvbox (c-98-207-114-56.hsd1.ca.comcast.net [98.207.114.56])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kjlx@templeofstupid.com)
        by pdx1-sub0-mail-a305.dreamhost.com (Postfix) with ESMTPSA id 4JV0V574ZQz1NX
        for <linux-xfs@vger.kernel.org>; Thu,  6 Jan 2022 00:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=templeofstupid.com;
        s=templeofstupid.com; t=1641459150; bh=qIWl+il/0Dg3vkEnphVDzGJiZa4=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=IoI1P27YXsjv3x28Ul25X86/DYBMEIURJLbXJPK6pMdtoXmAhrmpIt+qqvSnxKBLh
         jmw5ipYqzH4Yg1rclWxitQlB53qwwGhhH9Ynlwbmp0Ta7dy61XN7raUetsMbVYIHI7
         ynVE1oDcQ9mIfq8Mw8aQRMfS7w8HKpMRyXxtgYqM=
Received: from johansen (uid 1000)
        (envelope-from kjlx@templeofstupid.com)
        id e0066
        by kmjvbox (DragonFly Mail Agent v0.9);
        Thu, 06 Jan 2022 00:52:28 -0800
Date:   Thu, 6 Jan 2022 00:52:28 -0800
From:   Krister Johansen <kjlx@templeofstupid.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: xfs_bmap_extents_to_btree allocation warnings
Message-ID: <20220106085228.GA19131@templeofstupid.com>
References: <20220105071052.GD20464@templeofstupid.com>
 <20220106010123.GP945095@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106010123.GP945095@dread.disaster.area>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi David,
Thanks for the response.

On Thu, Jan 06, 2022 at 12:01:23PM +1100, Dave Chinner wrote:
> On Tue, Jan 04, 2022 at 11:10:52PM -0800, Krister Johansen wrote:
> > WARNING: CPU: 4 PID: 115756 at fs/xfs/libxfs/xfs_bmap.c:716 xfs_bmap_extents_to_btree+0x3dc/0x610 [xfs]
> > RIP: 0010:xfs_bmap_extents_to_btree+0x3dc/0x610 [xfs]
> > Call Trace:
> >  xfs_bmap_add_extent_hole_real+0x7d9/0x8f0 [xfs]
> >  xfs_bmapi_allocate+0x2a8/0x2d0 [xfs]
> >  xfs_bmapi_write+0x3a9/0x5f0 [xfs]
> >  xfs_iomap_write_direct+0x293/0x3c0 [xfs]
> >  xfs_file_iomap_begin+0x4d2/0x5c0 [xfs]
> >  iomap_apply+0x68/0x160
> >  iomap_dio_rw+0x2c1/0x450
> >  xfs_file_dio_aio_write+0x103/0x2e0 [xfs]
> >  xfs_file_write_iter+0x99/0xe0 [xfs]
> >  new_sync_write+0x125/0x1c0
> >  __vfs_write+0x29/0x40
> >  vfs_write+0xb9/0x1a0
> >  ksys_write+0x67/0xe0
> >  __x64_sys_write+0x1a/0x20
> >  do_syscall_64+0x57/0x190
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Which is indicative of a multi-extent allocation (i.e. data extent +
> BMBT indexing btree block allocations) not selecting an AG that has
> enough space for both data and BMBT blocks to be allocated.
> 
> That's likely because args.total was not set correctly before AG
> selection was made. This exact sort of bug can be seen in the fix
> for recent error injection debug code in commit 6e8bd39d7227 ("xfs:
> Initialize xfs_alloc_arg->total correctly when allocating minlen
> extents"). You're not running a CONFIG_XFS_DEBUG=y kernel are you?

I am not running with CONFIG_XFS_DEBUG, no.

> > while the rest of the I/O on this filesystem goes through
> > the page cache and uses the delayed allocation mechanism by default.
> > (IOW, t_firstblock is NULLFSBLOCK most of the time.)
> 
> Has nothing to do with delayed allocation - the physical allocation
> that occurs in writeback will do exactly the same thing as direct IO
> allocation....

It must be similar, but not identical.  Though I think you're right that
I've confused myself about what's happening here.  The dd process that
is triggering this warning is an incredibly small fraction of all the
I/O that occurs on this filesystem, and yet it accounts for all of the
instances of the warning that I can find.

I looked in xfs_bmapi_convert_delalloc and saw that xfs_trans_alloc
allocated a new transaction but didn't touch t_firstblock.  What I
neglected to notice, though, was that xfs_bmap_btalloc and
xfs_bmbt_alloc_block could modify t_firstblock, and that this code path
could get there via the xfs_btree_insert calls in
xfs_bmap_add_extent_delay_real for the latter and the xfs_bmap_alloc
path for the former.

I missed the difference in the alloc_args accounting between the delayed
and real allocation paths and assumed that t_firstblock was the thing
making the difference between the regular and direct I/O cases.

> > However, linux is using 64-bit block
> > pointers in the inode now and the XFS_ALLOCTYPE_START_BNO case in
> > xfs_alloc_vextent() seems to try to ensure that it never considers an AG
> > that's less than the agno for the fsbno passed in via args.
> 
> Because otherwise allocations ABBA deadlock on AG locking.

Sorry, what I'm really trying to ask is: are there still cases in XFS
where using XFS_ALLOCTYPE_START_BNO can give you this kind of deadlock?
There's some deadlock avoidance in the START_BNO implementation, but
there are plenty of places where XFS_ALLOCTYPE_NEAR_BNO is still used if
t_firstblock is not NULLFSBLOCK.  I'm trying to work out if that code
still exists because of concerns about deadlocks, or if its an attempt
to limit the number of AGs searched instead.  (Or some other policy
choice, even.)

> > be a reasonable way to address the WARN?  Or does this open a box of
> > problems that obvious to the experienced, but just subtle enough to
> > elude the unfamiliar?
> 
> No, yes, and yes.

Thank you humoring my questions nonetheless.

> > The xfs_db freesp report after the problem occurred.  (N.B. it was a few
> > hours before I was able to get to this machine to investigate)
> > 
> > xfs_db -r -c 'freesp -a 47 -s' /dev/mapper/db-vol
> >    from      to extents  blocks    pct
> >       1       1      48      48   0.00
> >       2       3     119     303   0.02
> >       4       7      46     250   0.01
> >       8      15      22     255   0.01
> >      16      31      17     374   0.02
> >      32      63      16     728   0.04
> >      64     127       9     997   0.05
> >     128     255     149   34271   1.83
> >     256     511       7    2241   0.12
> >     512    1023       4    2284   0.12
> >    1024    2047       1    1280   0.07
> >    2048    4095       1    3452   0.18
> > 1048576 2097151       1 1825182  97.52
> > total free extents 440
> > total free blocks 1871665
> > average free extent size 4253.78
> 
> So 1,871,665 of 228,849,020 blocks free in the AG. That's 99.2%
> full, so it's extremely likely you are hitting a full AG condition.
> 
> /me goes and looks at xfs_iomap_write_direct()....
> 
> .... and notices that it passes "0" as the total allocation block
> count, which means it isn't reserving space in the AG for both the
> data extent and the BMBT blocks...
> 
> ... and several other xfs_bmapi_write() callers have the same
> issue...
> 
> Ok, let me spend a bit more looking into this in more depth, but it
> looks like the problem is at the xfs_bmapi_write() caller level, not
> deep in the allocator itself.

At least on 5.4 xfs_bmapi_write is still passing resblks instead of
zero, which is computed in xfs_iomap_write_direct.

Related to your comment about alloc_args.total, I did a bit of tracing
of the xfs_alloc tracepoints on my system and found that total seems to
be getting set in both cases, but that a) it's actually a larger value
for directio; and b) in the buffered write case the code is requesting
more blocks at one time which causes a larger allocation to occur.  I'm
not certain, but wondered if this could be causing us to select an AG
with more space by luck.

directio:

              dd-102229  [005] .... 4969662.383215: xfs_alloc_exact_done: dev 253:1 agno 0 agbno 14240 minlen 4 maxlen 4 mod 0 prod 1 minleft 2 total 8 alignment 1 minalignslop 3 len 4 type THIS_BNO otype THIS_BNO wasdel 0 wasfromfl 0 resv 0 datatype 0x9 firstblock 0xffffffffffffffff
              dd-102229  [005] .... 4969662.383217: <stack trace>
 => xfs_alloc_ag_vextent_exact+0x2b4/0x2d0 [xfs]
 => xfs_alloc_ag_vextent+0x13b/0x150 [xfs]
 => xfs_alloc_vextent+0x2bc/0x550 [xfs]
 => xfs_bmap_btalloc+0x461/0x940 [xfs]
 => xfs_bmap_alloc+0x34/0x40 [xfs]
 => xfs_bmapi_allocate+0xdc/0x2d0 [xfs]
 => xfs_bmapi_write+0x3a9/0x5f0 [xfs]
 => xfs_iomap_write_direct+0x293/0x3c0 [xfs]
 => xfs_file_iomap_begin+0x4d2/0x5c0 [xfs]
 => iomap_apply+0x68/0x160
 => iomap_dio_rw+0x2c1/0x450
 => xfs_file_dio_aio_write+0x103/0x2e0 [xfs]
 => xfs_file_write_iter+0x99/0xe0 [xfs]
 => new_sync_write+0x125/0x1c0
 => __vfs_write+0x29/0x40
 => vfs_write+0xb9/0x1a0
 => ksys_write+0x67/0xe0
 => __x64_sys_write+0x1a/0x20
 => do_syscall_64+0x57/0x190
 => entry_SYSCALL_64_after_hwframe+0x44/0xa9

buffered write + fsync:

              dd-109921  [010] .... 4972814.844429: xfs_alloc_exact_done: dev 253:1 agno 0 agbno 21280 minlen 16 maxlen 16 mod 0 prod 1 minleft 2 total 4 alignment 1 minalignslop 3 len 16 type THIS_BNO otype THIS_BNO wasdel 1 wasfromfl 0 resv 0 datatype 0x9 firstblock 0xffffffffffffffff
              dd-109921  [010] .... 4972814.844433: <stack trace>
 => xfs_alloc_ag_vextent_exact+0x2b4/0x2d0 [xfs]
 => xfs_alloc_ag_vextent+0x13b/0x150 [xfs]
 => xfs_alloc_vextent+0x2bc/0x550 [xfs]
 => xfs_bmap_btalloc+0x461/0x940 [xfs]
 => xfs_bmap_alloc+0x34/0x40 [xfs]
 => xfs_bmapi_allocate+0xdc/0x2d0 [xfs]
 => xfs_bmapi_convert_delalloc+0x26f/0x4b0 [xfs]
 => xfs_map_blocks+0x15a/0x3f0 [xfs]
 => xfs_do_writepage+0x118/0x420 [xfs]
 => write_cache_pages+0x1ae/0x4b0
 => xfs_vm_writepages+0x6a/0xa0 [xfs]
 => do_writepages+0x43/0xd0
 => __filemap_fdatawrite_range+0xd5/0x110
 => file_write_and_wait_range+0x74/0xc0
 => xfs_file_fsync+0x5d/0x230 [xfs]
 => vfs_fsync_range+0x49/0x80
 => do_fsync+0x3d/0x70
 => __x64_sys_fsync+0x14/0x20
 => do_syscall_64+0x57/0x190
 => entry_SYSCALL_64_after_hwframe+0x44/0xa9

I'm not sure if this is useful, but if there's something else that you'd
like me to instrument that would be, let me know and I'll see what I can
pull together.

Thanks again,

-K
