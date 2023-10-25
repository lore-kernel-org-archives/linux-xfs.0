Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9BD3C0032E
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Oct 2023 15:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbjJYPuu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Oct 2023 11:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234524AbjJYPuu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2023 11:50:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F3C13A
        for <linux-xfs@vger.kernel.org>; Wed, 25 Oct 2023 08:50:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DD6C433C7;
        Wed, 25 Oct 2023 15:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698249047;
        bh=1xD61dKZzRe/rzmJ3m58Uq9VTAKiJn6b6NclNNX5YMA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nMB5jeOCCQafw5aeOhAUTEr0SyusQGJTpK6uIgHFgcwX0wK8MDG625I6Doc0nP/mm
         /ZnhVESGeLW3OkAE2duS+2BNxuI2pkKcWMEY4I3yi6B7eI0tx3RHelaYp1hh620YEj
         /cxz2pla3admhUsB2eRDzMIvFFWB7v7HNP44JL+SpLDo7tXfpCzkg9jV9fwN48YsAb
         Tp3SHNsAAOYAzbdDdr/YJdz4CgrSIKfqNGdetxJy5g2d0YQYQiyojmxCeCW84WVDiN
         WcUVPQx0KYd62st84nLikPC+KAXRHB/7gRcbY96gZUVqhTkBm/kH8G4lqbQMh+VJmV
         1MRu4ZdN5AjOQ==
Date:   Wed, 25 Oct 2023 08:50:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] xfs: fix internal error from AGFL exhaustion
Message-ID: <20231025155046.GF3195650@frogsfrogsfrogs>
References: <013168d2de9d25c56fe45ad75e9257cf9664f2d6.1698190191.git.osandov@fb.com>
 <ZTibBf0ef5PMcJiH@dread.disaster.area>
 <ZTikH67goprXtn1+@telecaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTikH67goprXtn1+@telecaster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 24, 2023 at 10:14:07PM -0700, Omar Sandoval wrote:
> On Wed, Oct 25, 2023 at 03:35:17PM +1100, Dave Chinner wrote:
> > On Tue, Oct 24, 2023 at 04:37:33PM -0700, Omar Sandoval wrote:
> > > From: Omar Sandoval <osandov@fb.com>
> > > 
> > > We've been seeing XFS errors like the following:
> > > 
> > > XFS: Internal error i != 1 at line 3526 of file fs/xfs/libxfs/xfs_btree.c.  Caller xfs_btree_insert+0x1ec/0x280
> > > ...
> > > Call Trace:
> > >  xfs_corruption_error+0x94/0xa0
> > >  xfs_btree_insert+0x221/0x280
> > >  xfs_alloc_fixup_trees+0x104/0x3e0
> > >  xfs_alloc_ag_vextent_size+0x667/0x820
> > >  xfs_alloc_fix_freelist+0x5d9/0x750
> > >  xfs_free_extent_fix_freelist+0x65/0xa0
> > >  __xfs_free_extent+0x57/0x180
> > > ...
> > 
> > Good find, Omar!
> > 
> > For completeness, what's the rest of the trace? We've recently
> > changed how extent freeing path works w.r.t. busy extents so I'm
> > curious as to what the path into this code is.
> 
> This one is from my fpunch reproducer, but there were two call traces we
> actually saw in production. One from writeback:
> 
> xfs_corruption_error+0x90/0xa0
> xfs_btree_insert+0x1b1/0x1d0
> xfs_alloc_fixup_trees+0x28e/0x450
> xfs_alloc_ag_vextent_size+0x4e0/0x780
> xfs_alloc_ag_vextent+0x11c/0x140
> xfs_alloc_fix_freelist+0x3f2/0x510
> xfs_alloc_vextent+0x254/0x490
> xfs_bmap_btalloc+0x301/0x6e0
> xfs_bmapi_allocate+0x206/0x2d0
> xfs_bmapi_convert_delalloc+0x2b9/0x450
> xfs_map_blocks+0x1cc/0x470
> iomap_do_writepage+0x22b/0x860
> write_cache_pages+0x1ae/0x4c0
> iomap_writepages+0x1c/0x40
> xfs_vm_writepages+0x6b/0xa0
> do_writepages+0x6f/0x1d0
> __writeback_single_inode+0x39/0x2b0
> writeback_sb_inodes+0x277/0x510
> __writeback_inodes_wb+0x6e/0xe0
> wb_writeback+0xda/0x250
> wb_workfn+0x1f4/0x430
> process_one_work+0x12c/0x490
> worker_thread+0x143/0x3e0
> kthread+0xa3/0xd0
> ret_from_fork+0x1f/0x30
> 
> And one from inodegc:
> 
> xfs_corruption_error+0x90/0xa0
> xfs_btree_insert+0x1b1/0x1d0
> xfs_alloc_fixup_trees+0x28e/0x450
> xfs_alloc_ag_vextent_size+0x4e0/0x780
> xfs_alloc_ag_vextent+0x11c/0x140
> xfs_alloc_fix_freelist+0x3f2/0x510
> __xfs_free_extent+0xde/0x1f0
> xfs_trans_free_extent+0x54/0xd0
> xfs_extent_free_finish_item+0x69/0xa0
> xfs_defer_finish_noroll+0x163/0x510
> xfs_defer_finish+0x10/0x70
> xfs_itruncate_extents_flags+0x13a/0x250
> xfs_inactive_truncate+0xac/0xe0
> xfs_inactive+0x14f/0x160
> xfs_inodegc_worker+0x81/0x100
> process_one_work+0x12c/0x490
> worker_thread+0x143/0x3e0
> kthread+0xa3/0xd0
> ret_from_fork+0x1f/0x30
> 
> These are both from 5.19.

Hey, I've seen that backtrace before!  Only a handful of times,
fortuntely.

> > > (It's guaranteed that
> > > none of the internal nodes need to be split because they were just
> > > split.)
> > 
> > Hmmm. That doesn't sound right - btrees don't work that way.
> > 
> > We don't know what path the tree split along in the previous insert
> > operation  - a split only guarantees the next insert along that same
> > path won't split if the insert hits one of the two leaf blocks from
> > the split.  Insert into a different leaf can still split interior
> > nodes all the way back up the tree the point where it intersects
> > with the previous full height split path.
> > 
> > e.g. if the previous full height split was down the left side of the
> > tree and the next insert is in the right half of the tree, the right
> > half can split on insert all the way up to the level below the old
> > root.
> 
> You're right, I was only thinking about the 2->3 level case. My
> assumption is only true in that case.
> 
> > > Fix it by adding an extra block of slack in the freelist for the
> > > potential leaf split in each of the bnobt and cntbt.

I see how the cntbt can split because changing the length of a freespace
extent can require the record to move to a totally different part of the
cntbt.  The reinsertion causes the split.

How does the bnobt split during a refresh of the AGFL?  Will we ever
allocate a block from the /middle/ of a free space extent?

> > 
> > Hmmm. yeah - example given is 2->3 level split, hence only need to
> > handle a single level leaf split before path intersection occurs.
> > Yup, adding an extra block will make the exact problem being seen go
> > away.
> > 
> > Ok, what's the general solution? 4-level, 5-level or larger trees?
> > 
> > Worst split after a full split is up to the level below the old root
> > block. the root block was split, so it won't need a split again, so
> > only it's children could split again. OK, so that's (height - 1)
> > needed for a max split to refill the AGFL after a full height split
> > occurred.
> > 
> > Hence it looks like the minimum AGFL space for any given
> > allocation/free operation needs to be:
> > 
> > 	(full height split reservation) + (AGFL refill split height)
> > 
> > which is:
> > 
> > 	= (new height) + (new height - 2)
> > 	= 2 * new height - 2
> > 	= 2 * (current height + 1) - 2
> > 	= 2 * current height
> > 
> > Ok, so we essentially have to double the AGFL minimum size to handle
> > the generic case of AGFL refill splitting free space trees after a
> > transaction that has exhausted it's AGFL reservation.
> > 
> > Now, did I get that right?
> 
> That sounds right, but I'll have to think about it more after some sleep
> :)

I think that's correct, assuming that (2 * current_height) is the
per-btree calcluation.

> Assuming that is correct, your LE search suggestion sounds kind of nice
> rather than such a drastic change to the AGFL size.

The absolute maximum height of a free space btree is 7 blocks, according
to xfs_db:

# xfs_db /dev/sda -c 'btheight -w absmax all'
bnobt: 7
cntbt: 7
inobt: 6
finobt: 6
bmapbt: 14
refcountbt: 6
rmapbt: 10

The smallest AGFL is 62 records long (V4 fs, 512b blocks) so I don't
think it's /that/ drastic.  For a filesystem with rmapbt (V5, 1k blocks)
that minimum jumps to 121 blocks.

> > The rmapbt case will need this change, too, because rmapbt blocks
> > are allocated from the free list and so an rmapbt update can exhaust
> > the free list completely, too.
> 
> Ah, I missed where the rmapbt is updated since it was slightly removed
> from the xfs_alloc_fixup_trees() code path I was looking at.

The rmapbt has its own accounting tricks (XFS_AG_RESV_RMAPBT) to ensure
that there's always enough free space to refill the AGFL.  Is that why
the testcase turns off rmapbt?

--D

> Thanks for the quick review!
> 
> Omar
