Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2435C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Nov 2022 20:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbiKWUBe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Nov 2022 15:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239572AbiKWUBD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2022 15:01:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C286742F4
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 12:00:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CB5261ED7
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 20:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E790CC433D7;
        Wed, 23 Nov 2022 20:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669233656;
        bh=UcoGKsbJw4jlUOzYoD9wYrOrsZjUjeOnHMwOO/HkMto=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bGZucrUwjiQBUhl8vCeTMCKvjWlD4IDZ0Ub8YdYYXh2EPECZ5/lRZLzghNTSnCY1m
         E2BRtS2FXbEyNgWi7BlowbU5JewGw+4smPgpCN9GbJlYc/pqsZtQJu+ih8ITSJoAyd
         SW920IGLowkO7lm+EUvF9XThaEzFDxXHQRPxwep+N0X9mtCz+U+zzn20Lj6esOWjZF
         g04HQE5yRFO2vcY3ciFlKiLGyeiQs/i+08CSAWCK2TNJIkC/6Epx4QkjJFQPaezXaB
         BsTrlaOpGL0iMwXMORACO054Jgb/ctH3kiZIYcO0fSbvFWK1NwH0MO2hRZYvKjbTi+
         nPnPlLd8DTNvA==
Date:   Wed, 23 Nov 2022 12:00:55 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: moar weird metadata corruptions, this time on arm64
Message-ID: <Y3579xWtwQEdBFw6@magnolia>
References: <Y3wUwvcxijj0oqBl@magnolia>
 <20221122015806.GQ3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122015806.GQ3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 22, 2022 at 12:58:06PM +1100, Dave Chinner wrote:
> On Mon, Nov 21, 2022 at 04:16:02PM -0800, Darrick J. Wong wrote:
> > Hi all,
> > 
> > I've been running near-continuous integration testing of online fsck,
> > and I've noticed that once a day, one of the ARM VMs will fail the test
> > with out of order records in the data fork.
> > 
> > xfs/804 races fsstress with online scrub (aka scan but do not change
> > anything), so I think this might be a bug in the core xfs code.  This
> > also only seems to trigger if one runs the test for more than ~6 minutes
> > via TIME_FACTOR=13 or something.
> > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/tree/tests/xfs/804?h=djwong-wtf
> > 
> > I added a debugging patch to the kernel to check the data fork extents
> > after taking the ILOCK, before dropping ILOCK, and before and after each
> > bmapping operation.  So far I've narrowed it down to the delalloc code
> > inserting a record in the wrong place in the iext tree:
> > 
> > xfs_bmap_add_extent_hole_delay, near line 2691:
> > 
> > 	case 0:
> > 		/*
> > 		 * New allocation is not contiguous with another
> > 		 * delayed allocation.
> > 		 * Insert a new entry.
> > 		 */
> > 		oldlen = newlen = 0;
> > 		xfs_iunlock_check_datafork(ip);		<-- ok here
> > 		xfs_iext_insert(ip, icur, new, state);
> > 		xfs_iunlock_check_datafork(ip);		<-- bad here
> > 		break;
> .....
> > XFS (sda3): ino 0x6095c72 nr 0x4 offset 0x6a nextoff 0x85
> > XFS: Assertion failed: got.br_startoff >= nextoff, file: fs/xfs/xfs_inode.c, line: 136
> ....
> > XFS (sda3): ino 0x6095c72 func xfs_bmap_add_extent_hole_delay line 2691 data fork:
> > XFS (sda3):    ino 0x6095c72 nr 0x0 nr_real 0x0 offset 0x26 blockcount 0x4 startblock 0xc119c4 state 0
> > XFS (sda3):    ino 0x6095c72 nr 0x1 nr_real 0x1 offset 0x2a blockcount 0x26 startblock 0xcc457e state 1
> > XFS (sda3):    ino 0x6095c72 nr 0x2 nr_real 0x2 offset 0x58 blockcount 0x12 startblock 0xcc45ac state 1
> > XFS (sda3):    ino 0x6095c72 nr 0x3 nr_real 0x3 offset 0x70 blockcount 0x15 startblock 0xffffffffe0007 state 0
> > XFS (sda3):    ino 0x6095c72 nr 0x4 nr_real 0x3 offset 0x6a blockcount 0x6 startblock 0xcc45be state 0
> > XFS (sda3):    ino 0x6095c72 nr 0x5 nr_real 0x4 offset 0xa7 blockcount 0x19 startblock 0x17ff88 state 0
> 
> So icur prior to insertion should point to record 0x5, offset 0xa7
> (right).  Prev (left) should point to record 0x4, offset 0x6a.
> 
> This makes both left and right valid, and while left is adjacent,
> it's a different type so isn't contiguous.
> 
> So falling through to "case 0" is correct.
> 
> But then it inserts it at index 0x3 before record 0x4, not
> at index 0x4 before record 0x5.
> 
> From xfs_iext_insert():
> 
>         for (i = nr_entries; i > cur->pos; i--)
> 		cur->leaf->recs[i] = cur->leaf->recs[i - 1];
> 	xfs_iext_set(cur_rec(cur), irec);
> 
> This implies cur->pos is wrong. i.e. it made a hole cur->pos = 0x3
> and inserted there, not at cur->pos = 0x4.
> 
> Can you add debug to trace the iext cursor as
> xfs_buffered_write_iomap_begin() ->
>   xfs_bmapi_reserve_delalloc() ->
>     xfs_bmap_add_extent_hole_delay()->
>       xfs_iext_insert()
> 
> runs? The iext cursor could have been wrong for some time before
> this insert tripped over it, so this may just be the messenger that
> something has just smashed the stack (icur is a stack variable).

In the latest run, I got this trace data:

ino 0x600a754 nr 0x5 offset 0x304 nextoff 0x31e
ino 0x600a754 func xfs_bmapi_reserve_delalloc line 4152 data fork:
    ino 0x600a754 nr 0x0 nr_real 0x0 offset 0x7 blockcount 0xe startblock 0xc12867 state 0
    ino 0x600a754 nr 0x1 nr_real 0x1 offset 0x78 blockcount 0xc8 startblock 0xc70d25 state 1
    ino 0x600a754 nr 0x2 nr_real 0x2 offset 0x150 blockcount 0x16 startblock 0xc70dfd state 1
    ino 0x600a754 nr 0x3 nr_real 0x3 offset 0x2a5 blockcount 0x5f startblock 0xc9f218 state 1
    ino 0x600a754 nr 0x4 nr_real 0x4 offset 0x318 blockcount 0x6 startblock 0xffffffffe0007 state 0
    ino 0x600a754 nr 0x5 nr_real 0x4 offset 0x304 blockcount 0x14 startblock 0xc9f277 state 0
    ino 0x600a754 nr 0x6 nr_real 0x5 offset 0xaf8 blockcount 0x1a startblock 0xd17aa3 state 0
    ino 0x600a754 nr 0x7 nr_real 0x6 offset 0x12f7 blockcount 0x40 startblock 0xcca511 state 1
    ino 0x600a754 nr 0x8 nr_real 0x7 offset 0x307c blockcount 0x3 startblock 0xc70ded state 0
    ino 0x600a754 nr 0x9 nr_real 0x8 offset 0x307f blockcount 0x1 startblock 0xc70df0 state 1

Here we again see that a delalloc extent was inserted into the wrong
position in the iext leaf, same as last time.  The extra trace data I
collected are as follows:

ino 0x600a754 fork 0 oldoff 0x318 oldlen 0x6 oldprealloc 0x0 isize 0x307e14c
    ino 0x600a754 oldgotoff 0xaf8 oldgotstart 0xd17aa3 oldgotcount 0x1a oldgotstate 0
    ino 0x600a754 freshgotoff 0xe0e46156d65cb freshgotstart 0xd178b5 freshgotcount 0x1a freshgotstate 0
    ino 0x600a754 nowgotoff 0x318 nowgotstart 0xffffffffe0007 nowgotcount 0x6 nowgotstate 0
    ino 0x600a754 oldicurpos 4 oldleafnr 9 oldleaf 0xfffffc012d8f4680
    ino 0x600a754 newicurpos 4 newleafnr 10 newleaf 0xfffffc012304d800

The first line shows that xfs_bmapi_reserve_delalloc was called with
whichfork=XFS_DATA_FORK, off=0x318, len=0x6, prealloc=0.

The second line shows the contents of @got at the beginning of the call,
which are the results of the first iext lookup in
xfs_buffered_write_iomap_begin.

"freshgot" (line 3) are the results of a new xfs_iext_get_extent right
before the call to xfs_bmap_add_extent_hole_delay.  Totally garbage.

"nowgot" (line 4) is contents of @got after the
xfs_bmap_add_extent_hole_delay call.

Line 5 is a copy of @icur at the beginning fo the call, and line 6 is
the contents of @icur after the xfs_bmap_add_extent_hole_delay call.
Notice that the cursor positions are the same, but the leaf pointers are
different.  I suspect that leaf ~d8f4680 has been freed, and this is the
reason why freshgot is totally garbage.  I wonder if the leaf pointers
being different is the result of an iext btree splitting into 2 objects
and then being recombined into one?

I augmented the xfs_iext_* functions to check the ILOCK state in all
functions that are passed an xfs_inode.  None of them tripped across the
entire fstests cloud run last night, so there's no obvious problem
there.  The buffered write path takes ILOCK_EXCL and keeps it right up
to where the debug splat happens, so there's no locking problem there.

So I started looking for things that could shift the extent count by one.
Looking for semi-adjacent records, I noticed this:

nr 0x1 nr_real 0x1 offset 0x78 blockcount 0xc8 startblock 0xc70d25 state 1
nr 0x2 nr_real 0x2 offset 0x150 blockcount 0x16 startblock 0xc70dfd state 1

0xc70d25+0xc8 == 0xc70ded, so this could be the result of someone
punching 0x10 blocks.

ino 0x600a754 nr 0x3 nr_real 0x3 offset 0x2a5 blockcount 0x5f startblock 0xc9f218 state 1
ino 0x600a754 nr 0x5 nr_real 0x4 offset 0x304 blockcount 0x14 startblock 0xc9f277 state 0

The incorrect delalloc reservation notwithstanding, these two records
are logically and physically adjacent, with the only difference being
that one is unwritten and the other is not.  Someone could have
converted an unwritten extent to written, possibly as a result of a
post-write conversion?

ino 0x600a754 nr 0x8 nr_real 0x7 offset 0x307c blockcount 0x3 startblock 0xc70ded state 0
ino 0x600a754 nr 0x9 nr_real 0x8 offset 0x307f blockcount 0x1 startblock 0xc70df0 state 1

The 0xc70ded here is familiar -- I wonder if this got mapped here as a
result of an FIEXCHANGE'd with offset 0x140?  Extent 9 is adjacent with
extent 8, except for the state difference.  Hmm.  I guess I better go
check the FIEXCHANGE code...

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
