Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73CC4C0032E
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Oct 2023 03:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjJZDVH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Oct 2023 23:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjJZDVF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2023 23:21:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A611D18B
        for <linux-xfs@vger.kernel.org>; Wed, 25 Oct 2023 20:21:03 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E18C433C7;
        Thu, 26 Oct 2023 03:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698290463;
        bh=1zHDZb+d0PLgVgULIOKnF/qkEVaXMYiWzCMKwpJmM/4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lsinzh2aliQiRX7Og38VUiyhM39y9Y6JkmMTAcL6Sf2blREA5fJTfVDLnMjnMd6OR
         ii1zNb/9rVhHbBYyh6VG05+6vRrLTLlGnUQ/tkAayk87FCv1gtkyGc+g6lf8J3ZaEm
         DTk/Z0tKRQIzaZ6WdzLshkQGGo8qTWfFPEYr85IEMQ2auL8+0RVcWoyyuiJ4o+Vk0P
         H4plvYiqBHFVoUpbWW/w1VxOFS3e/JDsKWu5Qbob0EMfYkxdUAuBXBuLR1iMTwafVa
         mo4I7BXUVS2H/81H51IQYc2X7I1pWSW6HY4AoGqGyk+otwyZ/IvOWNOuj2U2qouMDi
         MO2R35tVy4mlQ==
Date:   Wed, 25 Oct 2023 20:21:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Omar Sandoval <osandov@osandov.com>, linux-xfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] xfs: fix internal error from AGFL exhaustion
Message-ID: <20231026032102.GI3195650@frogsfrogsfrogs>
References: <013168d2de9d25c56fe45ad75e9257cf9664f2d6.1698190191.git.osandov@fb.com>
 <ZTibBf0ef5PMcJiH@dread.disaster.area>
 <ZTikH67goprXtn1+@telecaster>
 <20231025155046.GF3195650@frogsfrogsfrogs>
 <ZTl0dH7kztlRNFe/@telecaster>
 <20231025223909.GG3195650@frogsfrogsfrogs>
 <ZTmmw7jDuEeBFbd3@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTmmw7jDuEeBFbd3@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 26, 2023 at 10:37:39AM +1100, Dave Chinner wrote:
> On Wed, Oct 25, 2023 at 03:39:09PM -0700, Darrick J. Wong wrote:
> > On Wed, Oct 25, 2023 at 01:03:00PM -0700, Omar Sandoval wrote:
> > > On Wed, Oct 25, 2023 at 08:50:46AM -0700, Darrick J. Wong wrote:
> > > > On Tue, Oct 24, 2023 at 10:14:07PM -0700, Omar Sandoval wrote:
> > > > > On Wed, Oct 25, 2023 at 03:35:17PM +1100, Dave Chinner wrote:
> > > > > > On Tue, Oct 24, 2023 at 04:37:33PM -0700, Omar Sandoval wrote:
> > > > > > > From: Omar Sandoval <osandov@fb.com>
> > > > > > > Fix it by adding an extra block of slack in the freelist for the
> > > > > > > potential leaf split in each of the bnobt and cntbt.
> > > > 
> > > > I see how the cntbt can split because changing the length of a freespace
> > > > extent can require the record to move to a totally different part of the
> > > > cntbt.  The reinsertion causes the split.
> > > > 
> > > > How does the bnobt split during a refresh of the AGFL?  Will we ever
> > > > allocate a block from the /middle/ of a free space extent?
> > > 
> > > That's the case I was worried about for the bnobt. I see two ways that
> > > can happen:
> > > 
> > > 1. alignment, prod, or mod requirements, which the freelist doesn't
> > >    have.
> > > 2. Busy extents. I don't know enough about XFS to say whether or not
> > >    this is applicable, but at first glance I don't see why not.
> > 
> > Yes, I think it is possible -- we allocate an extent to fill the AGFL,
> > the beginning of that extent is still busy due to slow discard, so
> > xfs_alloc_compute_aligned gives us a block from the middle of the free
> > space.  Since AGFL filling has no particular alignment/prod/mod, any
> > number of blocks are good enough, so we end up taking the blocks from
> > the middle of the extent.
> 
> *nod*
> 
> That's exactly the conclusion I came to when I wondered how it was
> possible...
> 
> > > > > > Hmmm. yeah - example given is 2->3 level split, hence only need to
> > > > > > handle a single level leaf split before path intersection occurs.
> > > > > > Yup, adding an extra block will make the exact problem being seen go
> > > > > > away.
> > > > > > 
> > > > > > Ok, what's the general solution? 4-level, 5-level or larger trees?
> > > > > > 
> > > > > > Worst split after a full split is up to the level below the old root
> > > > > > block. the root block was split, so it won't need a split again, so
> > > > > > only it's children could split again. OK, so that's (height - 1)
> > > > > > needed for a max split to refill the AGFL after a full height split
> > > > > > occurred.
> > > > > > 
> > > > > > Hence it looks like the minimum AGFL space for any given
> > > > > > allocation/free operation needs to be:
> > > > > > 
> > > > > > 	(full height split reservation) + (AGFL refill split height)
> > > > > > 
> > > > > > which is:
> > > > > > 
> > > > > > 	= (new height) + (new height - 2)
> > > > > > 	= 2 * new height - 2
> > > > > > 	= 2 * (current height + 1) - 2
> > > > > > 	= 2 * current height
> > > > > > 
> > > > > > Ok, so we essentially have to double the AGFL minimum size to handle
> > > > > > the generic case of AGFL refill splitting free space trees after a
> > > > > > transaction that has exhausted it's AGFL reservation.
> > > > > > 
> > > > > > Now, did I get that right?
> > > > > 
> > > > > That sounds right, but I'll have to think about it more after some sleep
> > > > > :)
> > > > 
> > > > I think that's correct, assuming that (2 * current_height) is the
> > > > per-btree calcluation.
> > > 
> > > Agreed, except when the tree is already the maximum level. In that case,
> > > the worst case is splitting up to but not including the root node twice,
> > > which is 2 * height - 2 (i.e., stopping before Dave substituted new
> > > height with current height + 1). So I think we want:
> > > 
> > > min_free = min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
> > > 			       mp->m_alloc_maxlevels) * 2 - 2;
> > > 
> > > > > Assuming that is correct, your LE search suggestion sounds kind of nice
> > > > > rather than such a drastic change to the AGFL size.
> > > 
> > > Come to think of it, if there is nothing <= the desired size but there
> > > is something >, we have no choice but to do the split, so that doesn't
> > > work.
> > 
> > Yeah, I was kind of wondering that myself.
> 
> Ok, I'm glad to see there are enough eyes on this to point out the
> things I missed when musing about it as a possible solution...
> 
> > > > The absolute maximum height of a free space btree is 7 blocks, according
> > > > to xfs_db:
> > > > 
> > > > # xfs_db /dev/sda -c 'btheight -w absmax all'
> > > > bnobt: 7
> > > > cntbt: 7
> > > > inobt: 6
> > > > finobt: 6
> > > > bmapbt: 14
> > > > refcountbt: 6
> > > > rmapbt: 10
> > > > 
> > > > The smallest AGFL is 62 records long (V4 fs, 512b blocks) so I don't
> > > > think it's /that/ drastic.  For a filesystem with rmapbt (V5, 1k blocks)
> > > > that minimum jumps to 121 blocks.
> 
> Yup. keep in mind this comment in xfs_alloc_fix_freelist():
> 
> 	 * XXX (dgc): When we have lots of free space, does this buy us
>          * anything other than extra overhead when we need to put more blocks
>          * back on the free list? Maybe we should only do this when space is
>          * getting low or the AGFL is more than half full?
> 
> IOWs, I've previously mused about keeping the AGFL much fuller than
> the absolute minimum. There doesn't seem to be any real gain to
> keeping it at just the minimum size when we are nowhere near ENOSPC,
> it just means we are doing lots of management operations like
> reducing it immediately after a transaction that has released blocks
> to the freelist, then only to have to extend it again when we do an
> operation that consumes blocks from the free list.
> 
> i.e. should we add also hysteresis to limit the number of AGFL
> size manipulations we need to do in mixed workloads? i.e. we don't free
> blocks from the AGFL until it might get overfilled by an operation
> (i.e. max size - max merge free blocks) or we are nearing ENOSPC,
> and we don't fill till we are at the minimum. In either case, the
> target for empty or fill operations is "half full"...

Hmm.   What if we kept the AGFL completely full?

On that 512b-fsblock V4 filesystem, that'd use up 128 blocks instead of 7
blocks.  128 blocks == 64K per AG.

On a 64K-fsblock V5 filesystem, that'd use up 16370 64K blocks per AG, or
~1GB per AG.  Ok, that might be too much.

On a 4K-fsblock V5 fs, that's 1010 4K blocks per AG, or ~4MB per AG.

A gigabyte is a bit ridiculous, but what if we always did the maximum
bnobt/cntbt/rmapbt height instead of current_height + 1?

For that 4K-fsblock filesystem, that's 24 blocks per AG, or 96K.  Given
that we only support 300M+ filesystems now, that's 75M per AG.  I feel
like we could go crazy and try to keep 640K in the AGFL.

640K ought to be enough for anyone.

(Numbers chosen arbitrarily, of course.)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
