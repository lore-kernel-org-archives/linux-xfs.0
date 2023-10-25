Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9A25C25B6B
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Oct 2023 22:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjJYWjN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Oct 2023 18:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjJYWjM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2023 18:39:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FD2CC
        for <linux-xfs@vger.kernel.org>; Wed, 25 Oct 2023 15:39:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79193C433C8;
        Wed, 25 Oct 2023 22:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698273550;
        bh=owglZK27q/LWlFWZqjVODnlx7z+dwoncR9bqql7VeZA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dfqiYtNYeiTh+mRxVfU9NNYZ8FP4h+sCdsykNsDlLm4lNRdKwAdC1zwZfl7uGIMHv
         M4H+izMo/VVvwleA5mJ5MMhoWMyMMRFFXvJVmLJdobWUK8XGXU89pEYY20W5B5ZmCD
         5F2lW4tRvqqyrJNP0UKV4ngJtKHxCpLQ4Itj7GvMJZhxdPfdMS6HxgcY88gqioDVqh
         rdY5J9CqIUqTwuRZtFTwl5C7iE+D2VIaJwL+195AbSrCywmoSbrCTvUgDaoTKUzaxA
         XdMEwzszX4b/5dsr+yzVXDz81pnUeu+tkkp8VYtnZ0UlroNivOS+tWZsN7E+S04LNV
         Rsc11rw8wqPrQ==
Date:   Wed, 25 Oct 2023 15:39:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] xfs: fix internal error from AGFL exhaustion
Message-ID: <20231025223909.GG3195650@frogsfrogsfrogs>
References: <013168d2de9d25c56fe45ad75e9257cf9664f2d6.1698190191.git.osandov@fb.com>
 <ZTibBf0ef5PMcJiH@dread.disaster.area>
 <ZTikH67goprXtn1+@telecaster>
 <20231025155046.GF3195650@frogsfrogsfrogs>
 <ZTl0dH7kztlRNFe/@telecaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTl0dH7kztlRNFe/@telecaster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 25, 2023 at 01:03:00PM -0700, Omar Sandoval wrote:
> On Wed, Oct 25, 2023 at 08:50:46AM -0700, Darrick J. Wong wrote:
> > On Tue, Oct 24, 2023 at 10:14:07PM -0700, Omar Sandoval wrote:
> > > On Wed, Oct 25, 2023 at 03:35:17PM +1100, Dave Chinner wrote:
> > > > On Tue, Oct 24, 2023 at 04:37:33PM -0700, Omar Sandoval wrote:
> > > > > From: Omar Sandoval <osandov@fb.com>
> > > > > Fix it by adding an extra block of slack in the freelist for the
> > > > > potential leaf split in each of the bnobt and cntbt.
> > 
> > I see how the cntbt can split because changing the length of a freespace
> > extent can require the record to move to a totally different part of the
> > cntbt.  The reinsertion causes the split.
> > 
> > How does the bnobt split during a refresh of the AGFL?  Will we ever
> > allocate a block from the /middle/ of a free space extent?
> 
> That's the case I was worried about for the bnobt. I see two ways that
> can happen:
> 
> 1. alignment, prod, or mod requirements, which the freelist doesn't
>    have.
> 2. Busy extents. I don't know enough about XFS to say whether or not
>    this is applicable, but at first glance I don't see why not.

Yes, I think it is possible -- we allocate an extent to fill the AGFL,
the beginning of that extent is still busy due to slow discard, so
xfs_alloc_compute_aligned gives us a block from the middle of the free
space.  Since AGFL filling has no particular alignment/prod/mod, any
number of blocks are good enough, so we end up taking the blocks from
the middle of the extent.

> > > > Hmmm. yeah - example given is 2->3 level split, hence only need to
> > > > handle a single level leaf split before path intersection occurs.
> > > > Yup, adding an extra block will make the exact problem being seen go
> > > > away.
> > > > 
> > > > Ok, what's the general solution? 4-level, 5-level or larger trees?
> > > > 
> > > > Worst split after a full split is up to the level below the old root
> > > > block. the root block was split, so it won't need a split again, so
> > > > only it's children could split again. OK, so that's (height - 1)
> > > > needed for a max split to refill the AGFL after a full height split
> > > > occurred.
> > > > 
> > > > Hence it looks like the minimum AGFL space for any given
> > > > allocation/free operation needs to be:
> > > > 
> > > > 	(full height split reservation) + (AGFL refill split height)
> > > > 
> > > > which is:
> > > > 
> > > > 	= (new height) + (new height - 2)
> > > > 	= 2 * new height - 2
> > > > 	= 2 * (current height + 1) - 2
> > > > 	= 2 * current height
> > > > 
> > > > Ok, so we essentially have to double the AGFL minimum size to handle
> > > > the generic case of AGFL refill splitting free space trees after a
> > > > transaction that has exhausted it's AGFL reservation.
> > > > 
> > > > Now, did I get that right?
> > > 
> > > That sounds right, but I'll have to think about it more after some sleep
> > > :)
> > 
> > I think that's correct, assuming that (2 * current_height) is the
> > per-btree calcluation.
> 
> Agreed, except when the tree is already the maximum level. In that case,
> the worst case is splitting up to but not including the root node twice,
> which is 2 * height - 2 (i.e., stopping before Dave substituted new
> height with current height + 1). So I think we want:
> 
> min_free = min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
> 			       mp->m_alloc_maxlevels) * 2 - 2;
> 
> > > Assuming that is correct, your LE search suggestion sounds kind of nice
> > > rather than such a drastic change to the AGFL size.
> 
> Come to think of it, if there is nothing <= the desired size but there
> is something >, we have no choice but to do the split, so that doesn't
> work.

Yeah, I was kind of wondering that myself.

> > The absolute maximum height of a free space btree is 7 blocks, according
> > to xfs_db:
> > 
> > # xfs_db /dev/sda -c 'btheight -w absmax all'
> > bnobt: 7
> > cntbt: 7
> > inobt: 6
> > finobt: 6
> > bmapbt: 14
> > refcountbt: 6
> > rmapbt: 10
> > 
> > The smallest AGFL is 62 records long (V4 fs, 512b blocks) so I don't
> > think it's /that/ drastic.  For a filesystem with rmapbt (V5, 1k blocks)
> > that minimum jumps to 121 blocks.
> > 
> > > > The rmapbt case will need this change, too, because rmapbt blocks
> > > > are allocated from the free list and so an rmapbt update can exhaust
> > > > the free list completely, too.
> > > 
> > > Ah, I missed where the rmapbt is updated since it was slightly removed
> > > from the xfs_alloc_fixup_trees() code path I was looking at.
> > 
> > The rmapbt has its own accounting tricks (XFS_AG_RESV_RMAPBT) to ensure
> > that there's always enough free space to refill the AGFL.  Is that why
> > the testcase turns off rmapbt?
> 
> Nope, I turned it off in my test case because with the rmapbt enabled,
> the freelist is larger. Therefore, for this bug to happen, the bnobt,
> cntbt, and rmapbt all need a maximum split at the same time. This is
> "easy" to do for just the bnobt and cntbt since they store the same
> records, but it's a lot harder to get the rmapbt in on it, too.

<nod>

> Nevertheless, it seems possible, right? XFS_AG_RESV_RMAPBT only seems to
> guarantee that there is space in the AG to refill the AGFL, but that
> doesn't mean we won't need to split the rmapbt at an inopportune time?

Ooh, good point.  Just because we have plenty of free space doesn't mean
the AGFL actually has one free block to handle an rmapbt split resulting
from filling the AGFL.

--D
