Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7928C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 03:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbiC3DpY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 23:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiC3DpX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Mar 2022 23:45:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDF460F6
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 20:43:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC03CB81B2B
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 03:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F43DC340EC;
        Wed, 30 Mar 2022 03:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648611814;
        bh=faMv6j7PzjnTl9+bizmhdUF/O4GabjegauFbmNczHS4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FxAyBxytNPmohZ8cf+//jACSDro071WCWx4d36nVHbfCwp/PpQHIl4vya/hK2ngEI
         xaN4FP1tP72YEXW+g9e6qeTO3mLSTTb7oYthlGMwD2XelUI1JR/bnLmUgvboHFodax
         1pwaeNLpWgzDbelHgQhHjQJCPkoxYaqcrwLzli6DcSoCa+nk3c6R6lGbDMX1MRTH7s
         MNpoEwfhAYD14ud0Dkd/Chc7/7w2IYgNg7R3J3Rv8ytvKCql61JEtm5LKHU+pv8SP3
         jdslQY4dEGZ8JONWefR1N0ngmU3HOlbDkv+BfS2q2/KJoj4qSXmC1GJhSxQRieCs92
         kjL0NNmenqTKg==
Date:   Tue, 29 Mar 2022 20:43:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V8 15/19] xfs: Directory's data fork extent counter can
 never overflow
Message-ID: <20220330034333.GG27690@magnolia>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
 <20220321051750.400056-16-chandan.babu@oracle.com>
 <20220324221406.GL1544202@dread.disaster.area>
 <87sfr1nxj7.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220329062340.GY1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220329062340.GY1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 29, 2022 at 05:23:40PM +1100, Dave Chinner wrote:
> On Tue, Mar 29, 2022 at 10:52:04AM +0530, Chandan Babu R wrote:
> > On 25 Mar 2022 at 03:44, Dave Chinner wrote:
> > > On Mon, Mar 21, 2022 at 10:47:46AM +0530, Chandan Babu R wrote:
> > >> The maximum file size that can be represented by the data fork extent counter
> > >> in the worst case occurs when all extents are 1 block in length and each block
> > >> is 1KB in size.
> > >> 
> > >> With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and with
> > >> 1KB sized blocks, a file can reach upto,
> > >> (2^31) * 1KB = 2TB
> > >> 
> > >> This is much larger than the theoretical maximum size of a directory
> > >> i.e. 32GB * 3 = 96GB.
> > >> 
> > >> Since a directory's inode can never overflow its data fork extent counter,
> > >> this commit replaces checking the return value of
> > >> xfs_iext_count_may_overflow() with calls to ASSERT(error == 0).
> > >
> > > I'd really prefer that we don't add noise like this to a bunch of
> > > call sites.  If directories can't overflow the extent count in
> > > normal operation, then why are we even calling
> > > xfs_iext_count_may_overflow() in these paths? i.e. an overflow would
> > > be a sign of an inode corruption, and we should have flagged that
> > > long before we do an operation that might overflow the extent count.
> > >
> > > So, really, I think you should document the directory size
> > > constraints at the site where we define all the large extent count
> > > values in xfs_format.h, remove the xfs_iext_count_may_overflow()
> > > checks from the directory code and replace them with a simple inode
> > > verifier check that we haven't got more than 100GB worth of
> > > individual extents in the data fork for directory inodes....
> > 
> > I don't think that we could trivially verify if the extents in a directory's
> > data fork add up to more than 96GB.
> 
> dip->di_nextents tells us how many extents there are in the data
> fork, we know what the block size of the filesystem is, so it should
> be pretty easy to calculate a maximum extent count for 96GB of
> space. i.e. absolute maximum valid dir data fork extent count
> is (96GB / blocksize).
> 
> > 
> > xfs_dinode->di_size tracks the size of XFS_DIR2_DATA_SPACE. This also includes
> > holes that could be created by freeing directory entries in a single directory
> > block. Also, there is no easy method to determine the space occupied by
> > XFS_DIR2_LEAF_SPACE and XFS_DIR2_FREE_SPACE segments of a directory.
> 
> Sure there is. We do this sort of calc for things like transaction
> reservations via definitions like XFS_DA_NODE_MAXDEPTH. That tells us

Hmmm.  Seeing as I just replaced XFS_BTREE_MAXLEVELS with dynamic limits
set for each filesytem, is XFS_DA_NODE_MAXDEPTH even appropriate for
modern filesystems?  We're about to start allowing far more extended
attributes in the form of parent pointers, so we should be careful about
this.

For a directory, there can be at most 32GB of directory entries, so the
maximum number of directory entries is...

32GB / (directory block size) * (max entries per dir block)

The dabtree stores (u32 hash, u32 offset) records, so I guess it
wouldn't be so hard to compute the number of blocks needed for each node
level until we only need one block, and that's our real
XFS_DA_NODE_MAXEPTH.

But then the second question is: what's the maximum height of a dabtree
that indexes an xattr structure?  I don't think there's any maximum
limit within XFS on the number of attrs you can set on a file, is there?
At least until you hit the iext_max_count check.  I think the VFS
institutes its own limit of 64k for the llistxattr buffer, but that's
about all I can think of.

I suppose right now the xattr structure can't grow larger than 2^(16+21)
blocks in size, which is 2^49 bytes, but that's a mix of attr leaves and
dabtree blocks, unlike directories, right?

> immediately how many blocks can be in the XFS_DIR2_LEAF_SPACE
> segement....
> 
> We also know the maximum number of individual directory blocks in
> the 32GB segment (fixed at 32GB / dir block size), so the free space
> array is also a fixed size at (32GB / dir block size / free space
> entries per block).
> 
> It's easy to just use (96GB / block size) and that will catch most
> corruptions with no risk of a false positive detection, but we could
> quite easily refine this to something like:
> 
> data	(32GB +				
> leaf	 btree blocks(XFS_DA_NODE_MAXDEPTH) +
> freesp	 (32GB / free space records per block))
> frags					/ filesystem block size

I think we ought to do a more careful study of XFS_DA_NODE_MAXDEPTH, but
it could become more involved than we think.  In the interest of keeping
this series moving, can we start with a new verifier check that
(di_nextents < that formula from above) and then refine that based on
whatever improvements we may or may not come up with for
XFS_DA_NODE_MAXDEPTH?

> 
> > May be the following can be added to xfs_dinode_verify(),
> > 
> > 	if (S_ISDIR(mode) && ((xfs_dinode->di_size + 2 * 32GB) > 96GB))
> >     		return __this_address
> 
> That doesn't validate that the on disk or in-memory di_nextents
> value is withing the known valid range or not. We can do that
> directly (as per above), so we shouldn't need a hueristic like this.

Indeed, inode size is not a good proxy variable for extent count.

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
