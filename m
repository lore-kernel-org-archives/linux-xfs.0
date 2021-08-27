Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C704AC432BE
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 22:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A58C260EFE
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 22:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbhH0WEl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Aug 2021 18:04:41 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:47331 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232082AbhH0WEl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Aug 2021 18:04:41 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id DE8741B7BAC;
        Sat, 28 Aug 2021 08:03:48 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mJjwt-005iJ6-Iq; Sat, 28 Aug 2021 08:03:43 +1000
Date:   Sat, 28 Aug 2021 08:03:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: XFS fallocate implementation incorrectly reports ENOSPC
Message-ID: <20210827220343.GQ3657114@dread.disaster.area>
References: <20210826020637.GA2402680@onthe.net.au>
 <335ae292-cb09-6e6e-9673-68cfae666fc0@sandeen.net>
 <20210826205635.GA2453892@onthe.net.au>
 <20210827025539.GA3583175@onthe.net.au>
 <20210827054956.GP3657114@dread.disaster.area>
 <20210827065347.GA3594069@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827065347.GA3594069@onthe.net.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=OLL_FvSJAAAA:8 a=20KFwNOVAAAA:8
        a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=da2HoZOAeGtcy1VL7foA:9 a=CjuIK1q_8ugA:10 a=2wtbIlPCfvEA:10
        a=CCiWsZzRJ6MA:10 a=oIrB72frpwYPwTMnlWqB:22 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 27, 2021 at 04:53:47PM +1000, Chris Dunlop wrote:
> G'day Dave,
> 
> On Fri, Aug 27, 2021 at 03:49:56PM +1000, Dave Chinner wrote:
> > On Fri, Aug 27, 2021 at 12:55:39PM +1000, Chris Dunlop wrote:
> > > On Fri, Aug 27, 2021 at 06:56:35AM +1000, Chris Dunlop wrote:
> > > > On Thu, Aug 26, 2021 at 10:05:00AM -0500, Eric Sandeen wrote:
> > > > > On 8/25/21 9:06 PM, Chris Dunlop wrote:
> > > > > > 
> > > > > > fallocate -l 1GB image.img
> > > > > > mkfs.xfs -f image.img
> > > > > > mkdir mnt
> > > > > > mount -o loop ./image.img mnt
> > > > > > fallocate -o 0 -l 700mb mnt/image.img
> > > > > > fallocate -o 0 -l 700mb mnt/image.img
> > > > > > 
> > > > > > Why does the second fallocate fail with ENOSPC, and is that considered an XFS bug?
> > > > > 
> > > > > Interesting.  Off the top of my head, I assume that xfs is not looking at
> > > > > current file space usage when deciding how much is needed to satisfy the
> > > > > fallocate request.  While filesystems can return ENOSPC at any time for
> > > > > any reason, this does seem a bit suboptimal.
> > > > 
> > > > Yes, I would have thought the second fallocate should be a noop.
> > > 
> > > On further reflection, "filesystems can return ENOSPC at any time" is
> > > certainly something apps need to be prepared for (and in this case, it's
> > > doing the right thing, by logging the error and aborting), but it's not
> > > really a "not a bug" excuse for the filesystem in all circumstances (or this
> > > one?), is it? E.g. a write(fd, buf, 1) returning ENOSPC on an fresh
> > > filesystem would be considered a bug, no?
> > 
> > Sure, but the fallocate case here is different. You're asking to
> > preallocate up to 700MB of space on a filesystem that only has 300MB
> > of space free. Up front, without knowing anything about the layout
> > of the file we might need to allocate 700MB of space into, there's a
> > very good chance that we'll get ENOSPC partially through the
> > operation.
> 
> But I'm not asking for more space - the space is already there:

"Up front, without knowing anything about the layout of the file..."

[....]

> Sigh. On the other hand that might be a case of "play stupid
> games, win stupid prizes". On the gripping hand I can imagine the emails to
> the mailing list from people like me asking why their "simple" fallocate is
> taking 20 minutes...

Yup, we have to chose between behaviours people will complain about.
We chose the behaviour that doesn't happen except on really small
filesystems because, in practice, we almost never see production
workloads asking to fallocate() more than half the entire filesystem
capacity at a time.....

> > > > > > Background: I'm chasing a mysterious ENOSPC error on an XFS
> > > > > > filesystem with way more space than the app should be asking
> > > > > > for. There are no quotas on the fs. Unfortunately it's a third
> > > > > > party app and I can't tell what sequence is producing the error,
> > > > > > but this fallocate issue is a possibility.
> > 
> > More likely speculative preallocation is causing this than
> > fallocate. However, we've had a background worker that cleans up
> > speculative prealloc before reporting ENOSPC for a while now - what
> > kernel version are seeing this on?
> 
> 5.10.60. How long is "a while now"? I vaguely recall something about that
> going through.

Longer than that.

> > Also, it might not even be data allocation that is the issue - if
> > the filesystem is full and free space is fragmented, you could be
> > getting ENOSPC because inodes cannot be allocated. In which case,
> > the output of xfs-info would be useful so we can see if sparse inode
> > clusters are enabled or not....
> 
> $ xfs_info /chroot
> meta-data=/dev/mapper/vg00-chroot isize=512    agcount=32, agsize=244184192 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1    bigtime=0 inobtcount=0
> data     =                       bsize=4096   blocks=7813893120, imaxpct=5
>          =                       sunit=128    swidth=512 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=521728, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> It's currently fuller than I like:
> 
> $ df /chroot
> Filesystem                1K-blocks        Used  Available Use% Mounted on
> /dev/mapper/vg00-chroot 31253485568 24541378460 6712107108  79% /chroot
> 
> ...so that's 6.3T free, but this problem was happening with 71% (8.5T) free.
> The /maximum/ the app could conceivably be asking for is around 1.1T (to
> entirely duplicate an existing file), but it really shouldn't be doing
> anywhere near that: I can see it doing write-in-place on the existing file
> and should be asking for modest amounts of extention (then again, userland
> developers, so who knows, right? ;-}).
> 
> Oh, another reference: this is extensive reflinking happening on this
> filesystem. I don't know if that's a factor. You may remember my previous
> email relating to that:
> 
> Extreme fragmentation ho!
> https://www.spinics.net/lists/linux-xfs/msg47707.html

Ah. Details that are likely extremely important. The workload,
layout problems and ephemeral ENOSPC symptoms match the description
of the problem that was fixed by the series of commits that went
into 5.13 that ended in this one:

commit fd43cf600cf61c66ae0a1021aca2f636115c7fcb
Author: Brian Foster <bfoster@redhat.com>
Date:   Wed Apr 28 15:06:05 2021 -0700

    xfs: set aside allocation btree blocks from block reservation
    
    The blocks used for allocation btrees (bnobt and countbt) are
    technically considered free space. This is because as free space is
    used, allocbt blocks are removed and naturally become available for
    traditional allocation. However, this means that a significant
    portion of free space may consist of in-use btree blocks if free
    space is severely fragmented.
    
    On large filesystems with large perag reservations, this can lead to
    a rare but nasty condition where a significant amount of physical
    free space is available, but the majority of actual usable blocks
    consist of in-use allocbt blocks. We have a record of a (~12TB, 32
    AG) filesystem with multiple AGs in a state with ~2.5GB or so free
    blocks tracked across ~300 total allocbt blocks, but effectively at
    100% full because the the free space is entirely consumed by
    refcountbt perag reservation.
    
    Such a large perag reservation is by design on large filesystems.
    The problem is that because the free space is so fragmented, this AG
    contributes the 300 or so allocbt blocks to the global counters as
    free space. If this pattern repeats across enough AGs, the
    filesystem lands in a state where global block reservation can
    outrun physical block availability. For example, a streaming
    buffered write on the affected filesystem continues to allow delayed
    allocation beyond the point where writeback starts to fail due to
    physical block allocation failures. The expected behavior is for the
    delalloc block reservation to fail gracefully with -ENOSPC before
    physical block allocation failure is a possibility.
    
    To address this problem, set aside in-use allocbt blocks at
    reservation time and thus ensure they cannot be reserved until truly
    available for physical allocation. This allows alloc btree metadata
    to continue to reside in free space, but dynamically adjusts
    reservation availability based on internal state. Note that the
    logic requires that the allocbt counter is fully populated at
    reservation time before it is fully effective. We currently rely on
    the mount time AGF scan in the perag reservation initialization code
    for this dependency on filesystems where it's most important (i.e.
    with active perag reservations).
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
    Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
    Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
