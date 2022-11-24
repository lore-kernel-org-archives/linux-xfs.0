Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE080C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Nov 2022 16:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiKXQop (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Nov 2022 11:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKXQoo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Nov 2022 11:44:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FF8E6373
        for <linux-xfs@vger.kernel.org>; Thu, 24 Nov 2022 08:44:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA455B8284C
        for <linux-xfs@vger.kernel.org>; Thu, 24 Nov 2022 16:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6A0C433D6;
        Thu, 24 Nov 2022 16:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669308280;
        bh=PwhJN4UNwKWvalQzmQ/X+IjobxxuYA0J6NRKCv1trE0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dmy+jQJAN0FalQyOUgPeob8jz8js6EISvT5KL04R5OPAIMISJbczr4os8EtpLwb1X
         Hkld+QCJH0KqiigsSIvMb6H4ipSefYOqYKindiQzt/T60ZolwlZgR1CDGv5ZVrqrmo
         6EkF/fFtO+J54C32jzHTdd5KZal2EOTLoth6mVafhsM5KsK3gfwTmsiaNR+Q3lEsh3
         tC/XSSKcToatpMUbLGf3mdWQ5wu/GdJFj5TA/GQ+qyd+PzPJkgzmozISDas6A3VkvP
         1z3SStsnhcSwUrtaQo2J5ljzi9x0A1pt7b+OyuHhAburARfsJiWc927K6u8/4duf6e
         Ou76R4entjJjA==
Date:   Thu, 24 Nov 2022 08:44:39 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: moar weird metadata corruptions, this time on arm64
Message-ID: <Y3+fdyRj6tV9/WZu@magnolia>
References: <Y3wUwvcxijj0oqBl@magnolia>
 <20221122015806.GQ3600936@dread.disaster.area>
 <Y3579xWtwQEdBFw6@magnolia>
 <20221124044023.GU3600936@dread.disaster.area>
 <Y38TNTspBy9RPuBz@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y38TNTspBy9RPuBz@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 23, 2022 at 10:46:13PM -0800, Darrick J. Wong wrote:
> On Thu, Nov 24, 2022 at 03:40:23PM +1100, Dave Chinner wrote:
> > On Wed, Nov 23, 2022 at 12:00:55PM -0800, Darrick J. Wong wrote:
> > > On Tue, Nov 22, 2022 at 12:58:06PM +1100, Dave Chinner wrote:
> > > > On Mon, Nov 21, 2022 at 04:16:02PM -0800, Darrick J. Wong wrote:
> > > > > Hi all,
> > > > > 
> > > > > I've been running near-continuous integration testing of online fsck,
> > > > > and I've noticed that once a day, one of the ARM VMs will fail the test
> > > > > with out of order records in the data fork.
> > .....
> > > In the latest run, I got this trace data:
> > > 
> > > ino 0x600a754 nr 0x5 offset 0x304 nextoff 0x31e
> > > ino 0x600a754 func xfs_bmapi_reserve_delalloc line 4152 data fork:
> > >     ino 0x600a754 nr 0x0 nr_real 0x0 offset 0x7 blockcount 0xe startblock 0xc12867 state 0
> > >     ino 0x600a754 nr 0x1 nr_real 0x1 offset 0x78 blockcount 0xc8 startblock 0xc70d25 state 1
> > >     ino 0x600a754 nr 0x2 nr_real 0x2 offset 0x150 blockcount 0x16 startblock 0xc70dfd state 1
> > >     ino 0x600a754 nr 0x3 nr_real 0x3 offset 0x2a5 blockcount 0x5f startblock 0xc9f218 state 1
> > >     ino 0x600a754 nr 0x4 nr_real 0x4 offset 0x318 blockcount 0x6 startblock 0xffffffffe0007 state 0
> > >     ino 0x600a754 nr 0x5 nr_real 0x4 offset 0x304 blockcount 0x14 startblock 0xc9f277 state 0
> > >     ino 0x600a754 nr 0x6 nr_real 0x5 offset 0xaf8 blockcount 0x1a startblock 0xd17aa3 state 0
> > >     ino 0x600a754 nr 0x7 nr_real 0x6 offset 0x12f7 blockcount 0x40 startblock 0xcca511 state 1
> > >     ino 0x600a754 nr 0x8 nr_real 0x7 offset 0x307c blockcount 0x3 startblock 0xc70ded state 0
> > >     ino 0x600a754 nr 0x9 nr_real 0x8 offset 0x307f blockcount 0x1 startblock 0xc70df0 state 1
> > > 
> > > Here we again see that a delalloc extent was inserted into the wrong
> > > position in the iext leaf, same as last time.  The extra trace data I
> > > collected are as follows:
> > > 
> > > ino 0x600a754 fork 0 oldoff 0x318 oldlen 0x6 oldprealloc 0x0 isize 0x307e14c
> > >     ino 0x600a754 oldgotoff 0xaf8 oldgotstart 0xd17aa3 oldgotcount 0x1a oldgotstate 0
> > >     ino 0x600a754 freshgotoff 0xe0e46156d65cb freshgotstart 0xd178b5 freshgotcount 0x1a freshgotstate 0
> > >     ino 0x600a754 nowgotoff 0x318 nowgotstart 0xffffffffe0007 nowgotcount 0x6 nowgotstate 0
> > >     ino 0x600a754 oldicurpos 4 oldleafnr 9 oldleaf 0xfffffc012d8f4680
> > >     ino 0x600a754 newicurpos 4 newleafnr 10 newleaf 0xfffffc012304d800
> > 
> > .....
> > 
> > > Line 5 is a copy of @icur at the beginning fo the call, and line 6 is
> > > the contents of @icur after the xfs_bmap_add_extent_hole_delay call.
> > > Notice that the cursor positions are the same, but the leaf pointers are
> > > different.  I suspect that leaf ~d8f4680 has been freed, and this is the
> > > reason why freshgot is totally garbage. 
> > 
> > That implies that a extent tree modification is being made whilst
> > the delalloc function is holding the ILOCK_EXCL. Either rwsems on
> > ARM are broken (entirely possible given the subtle memory ordering
> > of the slow paths has caused this sort of problem on x64-64 multiple
> > times in the past), or something else isn't holding the ILOCK_EXCL
> > while modifying the iext tree.
> 
> Hmm, maybe I'll try turning on lockdep for arm64 and see if it has
> anythign interesting (ha!) to say.  Well, it /is/ a long holiday
> weekend....
> 
> > > I wonder if the leaf pointers
> > > being different is the result of an iext btree splitting into 2 objects
> > > and then being recombined into one?
> > 
> > That implies multiple operations occurred - the single leaf won't
> > split until it is full - that's when we add the 15th record to the
> > tree. We're nowhere near that. And it won't attempt a rebalance that
> > may merge the the two leaf nodes until a remove occurs and the
> > number of entries in that leaf drops to half full (7 entries) and
> > the combined total is less that a full leaf.
> > 
> > Further, this is the left-most leaf, so any split will allocate a
> > new right sibling and move the entries right in to the new node. If
> > either the new right or the left node then rebalance, they will
> > always merge to the left-most leaf and free the right leaf. IOWs,
> > a grow-split-shrink-merge on the left most leaf in the tree will not
> > change the address of that left-most leaf - the right leave will get
> > allocated then freed...
> > 
> > So I'm not sure that even a grow-split-shrink-merge has occurred
> > concurrently here.....
> > 
> > Oh.... inserting into the root block of the tree results in
> > xfs_iext_realloc_root() being called, and krealloc() is called to
> > grow the root leaf block. that points cur->leaf at the newly
> > reallocated chunk of memory.
> > 
> > Ok, so the change in cursor is to be expected. There's nothing wrong
> > with the cursor, or that we have a reallocated the root leaf.
> 
> Ah, ok.
> 
> > That leaves something not holding the right lock when inserting
> > a new extent,, or rwsems are broken on ARM.
> 
> That reminded me that a month or two back I also saw this crash when
> alwasycow is turned on and we start runnng generic/522:
> 
> stack segment: 0000 [#1] PREEMPT SMP
> CPU: 0 PID: 430863 Comm: fsstress Not tainted 6.0.0-xfsx #6.0.0 ae8d0391a7a281b411e9d54eb9b1c5c85ef7dbc0
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20171121_152543-x86-ol7-builder-01.us.oracle.com-4.el7.1 04/01/2014
> RIP: 0010:xfs_iext_prev+0x71/0x150 [xfs]
> Code: 41 89 5c 24 08 74 33 85 db 41 8b 55 14 78 38 83 fa 01 b8 0f 00 00 00 74 4c 39 c3 7d 1d 48 63 f3 48 83 fe 0f 0f 87 c4 00 00 00 <48> 83 7d 00 00 74 09 5b 5d 41 5c 41 5d 4
> d 10 85 db
> RSP: 0018:ffffc9000207fab8 EFLAGS: 00010297
> RAX: 000000000000000f RBX: 000000000000000e RCX: 000000000000000c
> RDX: 0000000000000002 RSI: 000000000000000e RDI: ffff88815598d6c0
> RBP: 000229e31f0000e9 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000001000 R12: ffffc9000207fb10
> R13: ffff88815598d6c0 R14: 000229e31f000001 R15: 000ffffffffe0000
> FS:  00007f46c03c4740(0000) GS:ffff88842d000000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f46c03c3000 CR3: 000000014b16c000 CR4: 00000000003506f0
> Call Trace:
>  <TASK>
>  xfs_iomap_prealloc_size.constprop.0.isra.0+0x1a6/0x410 [xfs 71c030f9aed06cc72c1a12695c507ccebedb1b15]
>  ? __filemap_add_folio+0x1d9/0x590
>  ? xfs_ilock+0xb5/0x1f0 [xfs 71c030f9aed06cc72c1a12695c507ccebedb1b15]
>  xfs_buffered_write_iomap_begin+0xa66/0xbc0 [xfs 71c030f9aed06cc72c1a12695c507ccebedb1b15]
>  ? __filemap_get_folio+0x15c/0x330
>  ? xfs_buffered_write_iomap_end+0x63/0x190 [xfs 71c030f9aed06cc72c1a12695c507ccebedb1b15]
>  iomap_iter+0x122/0x2c0
>  iomap_file_buffered_write+0x92/0x360
>  xfs_file_buffered_write+0xb1/0x330 [xfs 71c030f9aed06cc72c1a12695c507ccebedb1b15]
>  vfs_write+0x2eb/0x410
>  ksys_write+0x65/0xe0
>  do_syscall_64+0x2b/0x80
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> RIP: 0033:0x7f46c04dba37
> Code: 10 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
> RSP: 002b:00007fffd7ea9858 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 000000000001192f RCX: 00007f46c04dba37
> RDX: 000000000001192f RSI: 0000558ce0a4f600 RDI: 0000000000000004
> RBP: 0000000000000004 R08: 0000000000000000 R09: 0000558ce0a4f600
> R10: 00007f46c05e1430 R11: 0000000000000246 R12: 00000000000000e8
> R13: 000000000005c0fe R14: 0000558ce0a4f600 R15: 0000000000000000
> 
> So I wonder if this is the same kind of thing -- someone kreallocates
> the iext leaf block without taking ILOCK, and now our poor thread here
> walks off the dead leaf pointer in the cursor.
> 
> Or maybe this is a totally separate problem, who knows.  I've only seen
> it twice in the last 6 months.
> 
> > > I augmented the xfs_iext_* functions to check the ILOCK state in all
> > > functions that are passed an xfs_inode.  None of them tripped across the
> > > entire fstests cloud run last night, so there's no obvious problem
> > > there.  The buffered write path takes ILOCK_EXCL and keeps it right up
> > > to where the debug splat happens, so there's no locking problem there.
> > > 
> > > So I started looking for things that could shift the extent count by one.
> > > Looking for semi-adjacent records, I noticed this:
> > > 
> > > nr 0x1 nr_real 0x1 offset 0x78 blockcount 0xc8 startblock 0xc70d25 state 1
> > > nr 0x2 nr_real 0x2 offset 0x150 blockcount 0x16 startblock 0xc70dfd state 1
> > > 
> > > 0xc70d25+0xc8 == 0xc70ded, so this could be the result of someone
> > > punching 0x10 blocks.
> > > 
> > > ino 0x600a754 nr 0x3 nr_real 0x3 offset 0x2a5 blockcount 0x5f startblock 0xc9f218 state 1
> > > ino 0x600a754 nr 0x5 nr_real 0x4 offset 0x304 blockcount 0x14 startblock 0xc9f277 state 0
> > > 
> > > The incorrect delalloc reservation notwithstanding, these two records
> > > are logically and physically adjacent, with the only difference being
> > > that one is unwritten and the other is not.  Someone could have
> > > converted an unwritten extent to written, possibly as a result of a
> > > post-write conversion?
> > > 
> > > ino 0x600a754 nr 0x8 nr_real 0x7 offset 0x307c blockcount 0x3 startblock 0xc70ded state 0
> > > ino 0x600a754 nr 0x9 nr_real 0x8 offset 0x307f blockcount 0x1 startblock 0xc70df0 state 1
> > > 
> > > The 0xc70ded here is familiar -- I wonder if this got mapped here as a
> > > result of an FIEXCHANGE'd with offset 0x140?  Extent 9 is adjacent with
> > > extent 8, except for the state difference.  Hmm.  I guess I better go
> > > check the FIEXCHANGE code...
> > 
> > And there's no such thing a FIEXCHANGE in the upstream current code
> > base, so that would be a good place to look for shenanigans.... :)
> 
> Hm.  I looked over the code for that, and it takes ILOCK_EXCL on both
> inodes involved in the file contents exchange, and holds it past the
> final transaction commit + defer chain processing.  So I don't think
> it's there.

Also, last night's run produced this:

ino 0x140bb3 func xfs_bmapi_reserve_delalloc line 4164 data fork:
    ino 0x140bb3 nr 0x0 nr_real 0x0 offset 0xb9 blockcount 0x1f startblock 0x935de2 state 1
    ino 0x140bb3 nr 0x1 nr_real 0x1 offset 0xe6 blockcount 0xa startblock 0xffffffffe0007 state 0
    ino 0x140bb3 nr 0x2 nr_real 0x1 offset 0xd8 blockcount 0xe startblock 0x935e01 state 0
ino 0x140bb3 fork 0 oldoff 0xe6 oldlen 0x4 oldprealloc 0x6 isize 0xe6000
    ino 0x140bb3 oldgotoff 0xea oldgotstart 0xfffffffffffffffe oldgotcount 0x0 oldgotstate 0
    ino 0x140bb3 crapgotoff 0x0 crapgotstart 0x0 crapgotcount 0x0 crapgotstate 0
    ino 0x140bb3 freshgotoff 0xd8 freshgotstart 0x935e01 freshgotcount 0xe freshgotstate 0
    ino 0x140bb3 nowgotoff 0xe6 nowgotstart 0xffffffffe0007 nowgotcount 0xa nowgotstate 0
    ino 0x140bb3 oldicurpos 1 oldleafnr 2 oldleaf 0xfffffc00f0609a00
    ino 0x140bb3 crapicurpos 2 crapleafnr 2 crapleaf 0xfffffc00f0609a00
    ino 0x140bb3 freshicurpos 1 freshleafnr 2 freshleaf 0xfffffc00f0609a00
    ino 0x140bb3 newicurpos 1 newleafnr 3 newleaf 0xfffffc00f0609a00

The old/fresh/nowgot have the same meaning as yesterday.  "crapgot" is
the results of duplicating the cursor at the start of the body of
xfs_bmapi_reserve_delalloc and performing a fresh lookup at @off.
I think @oldgot is a HOLESTARTBLOCK extent because the first lookup
didn't find anything, so we filled in imap with "fake hole until the
end".  At the time of the first lookup, I suspect that there's only one
32-block unwritten extent in the mapping (hence oldicurpos==1) but by
the time we get to recording crapgot, crapicurpos==2.

IOWS, I think I can safely eliminate FIEXCHANGE shenanigans and
concentrate on finding an unlocked unwritten -> written extent
conversion.  Or possibly a written -> unwritten extent conversion?

Anyway, long holiday weekend, so I won't get back to this until Monday.
Just wanted to persist my notes to the mailing list so I can move on to
testing the write race fixes with djwong-dev.

--D

> --D
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
