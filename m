Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56346 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750936AbdGIOIV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 9 Jul 2017 10:08:21 -0400
Date: Sun, 9 Jul 2017 22:08:18 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [BUG] sb_fdblocks counting error caused by too large indlen
 returned from xfs_bmap_worst_indlen()
Message-ID: <20170709140818.GI29475@eguan.usersys.redhat.com>
References: <20170707120040.GG29475@eguan.usersys.redhat.com>
 <20170708064937.GH4103@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170708064937.GH4103@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jul 07, 2017 at 11:49:37PM -0700, Darrick J. Wong wrote:
> On Fri, Jul 07, 2017 at 08:01:43PM +0800, Eryu Guan wrote:
> > Hi all,
> > 
> > I recently hit a repeatable sb_fdblocks corruption as below:
> > 
> > Phase 1 - find and verify superblock...
> > Phase 2 - using internal log
> >         - zero log...
> >         - scan filesystem freespace and inode maps...
> > sb_fdblocks 14538692, counted 14669764
> >         - found root inode chunk
> > Phase 3 - for each AG...
> > ...
> > 
> > And the count diff is always 14669764 - 14538692 = 131072 (128k). The
> > XFS in question was formated with "-m rmapbt=1 -b 1k" option.
> > 
> > After turning on XFS_WARN and adding some debug printks (I appended the
> > detailed logs at the end of mail), I found that this was caused by too
> > large 'indlen' returned by xfs_bmap_worst_indlen(), which can't fit in a
> > 17 bits value (STARTBLOCKVALBITS is defined as 17), so the assert in
> > nullstartblock() failed: ASSERT(k < (1 << STARTBLOCKVALBITS));
> > 
> > From the log, newlen = 151513, which needs 18 bits, so nullstartblock()
> > throws away the 18th bit, and the sb_fdblocks difference is always 2^17
> > = 131072.
> 
> br_startblock is encoded in memory (and in the on-disk bmbt records) as
> a 52-bit unsigned integer.  We signal a delayed allocation record by
> setting the uppermost STARTBLOCKMASKBITS (35) bits to 1 and stash the
> 'indlen' reservation (i.e. the worst case estimate of the space we need
> to grow the bmbt/rmapbt to map the entire delayed allocation) in the
> lower 17 bits of br_startblock.  In theory this is ok because we're
> still quite a ways from having enough storage to create an fs where
> the upper bits in the agno part of an xfs_fsblock_t are actually set.

This confirms what I read from the code, thanks! But I'm still curious
about how these numbers are chosen, especially STARTBLOCKMASKBITS is
defined as (15 + 20), where are they from?

> 
> > To reproduce this, you need to keep enough dirty data in memory, so that
> > you can keep a large enough delay allocated extent in memory (not
> > converted to allocated by writeback thread), then speculative
> > preallocation could allocate large number of blocks based on the
> > existing extent size.
> > 
> > I first saw this by running xfs/217 on a ppc64 host with 18G memory, and
> > the default vm.dirty_background_ratio is 10, so it could keep around
> > 1.8G dirty memory. Now I can reproduce by tuning
> > vm.dirty_background_ratio and vm.dirty_ratio on a x86_64 host with 4G
> > memory.
> > 
> > ---- 8< ----
> > #!/bin/bash
> > dev=/dev/sdc1
> > mnt=/mnt/xfs
> > 
> > # write 1G file
> > size=$((1024*1024*1024))
> > 
> > echo 90 > /proc/sys/vm/dirty_background_ratio
> > echo 90 > /proc/sys/vm/dirty_ratio
> > 
> > mkfs -t xfs -m rmapbt=1 -b size=1k -f $dev
> > mount $dev $mnt
> > 
> > xfs_io -fc "pwrite -b 1m 0 $size" $mnt/testfile
> > umount $mnt
> > 
> > xfs_repair -n $dev
> > exit $?
> > ---- >8 ----
> > 
> > This is uncovered by commit fd26a88093ba ("xfs: factor rmap btree size
> > into the indlen calculations"), which adds worst-case size of rmapbt
> > into account. But I'm not sure what's the best fix.
> 
> Aha, that old silly fix.  In theory the per-AG reservation code is
> supposed to reserve enough backup AGFL space to handle a reasonable
> amount of rmapbt expansion, but then we double that up by adding
> additional rmapbt block estimates to indlen, presumably so that we favor
> returning ENOSPC when we go making delalloc reservations at
> write_begin/page_mkwrite time.
> 
> However, we drop the indlen reservation as soon as the first transaction
> in a allocate -> map -> rmap chain commits.  Since rmap is never the
> first transaction in a complex transaction series, it never gets its
> hands on that indlen.  Furthermore, indlen blocks are reserved from the
> /global/ free block counter and not at a per-AG level, that means that
> even with the indlen reservation we can still blow up during the rmap
> step because a particular AG might be totally out of blocks.
> 
> So maybe the solution is to revert this patch and see if generic/224
> still blows up when suint/swidth are set?  I tried the steps given in
> your email from 18 Nov 2016 ("[BUG] dd doesn't return on ENOSPC and hang
> when fulfilling rmapbt XFS") with sunit=32,swidth=224 (numbers I
> entirely made up) and it ran just fine.  I then ran it with the
> reproducer steps you outlined above, and that ran just fine too.
> I did not run the rest of xfstests.

Reverting commit fd26a88093ba works for me, I can't reproduce the
sb_fdblocks accounting error nor the dd hang bug.

> 
> > BTW, what are these magic numbers? What's the reason behind
> > STARTBLOCKVALBITS being 17? I can't find any explanation..
> 
> (See above)

Thanks!

Eryu
