Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE4F7C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Mar 2022 06:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbiC2GZ2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 02:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbiC2GZ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Mar 2022 02:25:27 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7922C275E2
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 23:23:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7283B534114;
        Tue, 29 Mar 2022 17:23:41 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nZ5GW-00BC5g-7r; Tue, 29 Mar 2022 17:23:40 +1100
Date:   Tue, 29 Mar 2022 17:23:40 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V8 15/19] xfs: Directory's data fork extent counter can
 never overflow
Message-ID: <20220329062340.GY1544202@dread.disaster.area>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
 <20220321051750.400056-16-chandan.babu@oracle.com>
 <20220324221406.GL1544202@dread.disaster.area>
 <87sfr1nxj7.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sfr1nxj7.fsf@debian-BULLSEYE-live-builder-AMD64>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6242a5ee
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=3oxm8aAQO6cuux8T2-kA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 29, 2022 at 10:52:04AM +0530, Chandan Babu R wrote:
> On 25 Mar 2022 at 03:44, Dave Chinner wrote:
> > On Mon, Mar 21, 2022 at 10:47:46AM +0530, Chandan Babu R wrote:
> >> The maximum file size that can be represented by the data fork extent counter
> >> in the worst case occurs when all extents are 1 block in length and each block
> >> is 1KB in size.
> >> 
> >> With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and with
> >> 1KB sized blocks, a file can reach upto,
> >> (2^31) * 1KB = 2TB
> >> 
> >> This is much larger than the theoretical maximum size of a directory
> >> i.e. 32GB * 3 = 96GB.
> >> 
> >> Since a directory's inode can never overflow its data fork extent counter,
> >> this commit replaces checking the return value of
> >> xfs_iext_count_may_overflow() with calls to ASSERT(error == 0).
> >
> > I'd really prefer that we don't add noise like this to a bunch of
> > call sites.  If directories can't overflow the extent count in
> > normal operation, then why are we even calling
> > xfs_iext_count_may_overflow() in these paths? i.e. an overflow would
> > be a sign of an inode corruption, and we should have flagged that
> > long before we do an operation that might overflow the extent count.
> >
> > So, really, I think you should document the directory size
> > constraints at the site where we define all the large extent count
> > values in xfs_format.h, remove the xfs_iext_count_may_overflow()
> > checks from the directory code and replace them with a simple inode
> > verifier check that we haven't got more than 100GB worth of
> > individual extents in the data fork for directory inodes....
> 
> I don't think that we could trivially verify if the extents in a directory's
> data fork add up to more than 96GB.

dip->di_nextents tells us how many extents there are in the data
fork, we know what the block size of the filesystem is, so it should
be pretty easy to calculate a maximum extent count for 96GB of
space. i.e. absolute maximum valid dir data fork extent count
is (96GB / blocksize).

> 
> xfs_dinode->di_size tracks the size of XFS_DIR2_DATA_SPACE. This also includes
> holes that could be created by freeing directory entries in a single directory
> block. Also, there is no easy method to determine the space occupied by
> XFS_DIR2_LEAF_SPACE and XFS_DIR2_FREE_SPACE segments of a directory.

Sure there is. We do this sort of calc for things like transaction
reservations via definitions like XFS_DA_NODE_MAXDEPTH. That tells us
immediately how many blocks can be in the XFS_DIR2_LEAF_SPACE
segement....

We also know the maximum number of individual directory blocks in
the 32GB segment (fixed at 32GB / dir block size), so the free space
array is also a fixed size at (32GB / dir block size / free space
entries per block).

It's easy to just use (96GB / block size) and that will catch most
corruptions with no risk of a false positive detection, but we could
quite easily refine this to something like:

data	(32GB +				
leaf	 btree blocks(XFS_DA_NODE_MAXDEPTH) +
freesp	 (32GB / free space records per block))
frags					/ filesystem block size

> May be the following can be added to xfs_dinode_verify(),
> 
> 	if (S_ISDIR(mode) && ((xfs_dinode->di_size + 2 * 32GB) > 96GB))
>     		return __this_address

That doesn't validate that the on disk or in-memory di_nextents
value is withing the known valid range or not. We can do that
directly (as per above), so we shouldn't need a hueristic like this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
