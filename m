Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C960C432BE
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 05:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62F7B60F6C
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 05:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234948AbhH0Fus (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Aug 2021 01:50:48 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:47465 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229645AbhH0Fus (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Aug 2021 01:50:48 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3A4A0104C37B;
        Fri, 27 Aug 2021 15:49:57 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mJUkW-005RpL-FI; Fri, 27 Aug 2021 15:49:56 +1000
Date:   Fri, 27 Aug 2021 15:49:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: XFS fallocate implementation incorrectly reports ENOSPC
Message-ID: <20210827054956.GP3657114@dread.disaster.area>
References: <20210826020637.GA2402680@onthe.net.au>
 <335ae292-cb09-6e6e-9673-68cfae666fc0@sandeen.net>
 <20210826205635.GA2453892@onthe.net.au>
 <20210827025539.GA3583175@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827025539.GA3583175@onthe.net.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=7-415B0cAAAA:8
        a=3troFyTL9SjXjzNIr18A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 27, 2021 at 12:55:39PM +1000, Chris Dunlop wrote:
> On Fri, Aug 27, 2021 at 06:56:35AM +1000, Chris Dunlop wrote:
> > On Thu, Aug 26, 2021 at 10:05:00AM -0500, Eric Sandeen wrote:
> > > On 8/25/21 9:06 PM, Chris Dunlop wrote:
> > > > 
> > > > fallocate -l 1GB image.img
> > > > mkfs.xfs -f image.img
> > > > mkdir mnt
> > > > mount -o loop ./image.img mnt
> > > > fallocate -o 0 -l 700mb mnt/image.img
> > > > fallocate -o 0 -l 700mb mnt/image.img
> > > > 
> > > > Why does the second fallocate fail with ENOSPC, and is that considered an XFS bug?
> > > 
> > > Interesting.  Off the top of my head, I assume that xfs is not looking at
> > > current file space usage when deciding how much is needed to satisfy the
> > > fallocate request.  While filesystems can return ENOSPC at any time for
> > > any reason, this does seem a bit suboptimal.
> > 
> > Yes, I would have thought the second fallocate should be a noop.
> 
> On further reflection, "filesystems can return ENOSPC at any time" is
> certainly something apps need to be prepared for (and in this case, it's
> doing the right thing, by logging the error and aborting), but it's not
> really a "not a bug" excuse for the filesystem in all circumstances (or this
> one?), is it? E.g. a write(fd, buf, 1) returning ENOSPC on an fresh
> filesystem would be considered a bug, no?

Sure, but the fallocate case here is different. You're asking to
preallocate up to 700MB of space on a filesystem that only has 300MB
of space free. Up front, without knowing anything about the layout
of the file we might need to allocate 700MB of space into, there's a
very good chance that we'll get ENOSPC partially through the
operation.

The real problem with preallocation failing part way through due to
overcommit of space is that we can't go back an undo the
allocation(s) made by fallocate because when we get ENOSPC we have
lost all the state of the previous allocations made. If fallocate is
filling holes between unwritten extents already in the file, then we
have no way of knowing where the holes we filled were and hence
cannot reliably free the space we've allocated before ENOSPC was
hit.

Hence if we allow the fallocate to go ahead and preallocate space
until we hit ENOSPC, we still end up returning to userspace with
ENOSPC, but we've also consumed all the remaining space in the
filesystem.

So there's a very good argument for simply rejecting any attempt to
preallocate space that has the possibility of over-committing space
and hence hitting ENOSPC part way through. Given that we spend a lot
of effort in XFS to avoid over-committing resources so that ENOSPC
is reliable and not prone to deadlocks, the choice to make fallocate
avoid a potential over-commit is at least internally consistent with
the XFS ENOSPC architecture.

IOWs, either behaviour could be considered a "bug" because it is
sub-optimal behaviour, but at some point you've got to choose what
is the least worst behaviour and run with it.

> ...or maybe your "suboptimal" was entirely tongue in cheek?
> 
> > > > Background: I'm chasing a mysterious ENOSPC error on an XFS
> > > > filesystem with way more space than the app should be asking
> > > > for. There are no quotas on the fs. Unfortunately it's a third
> > > > party app and I can't tell what sequence is producing the error,
> > > > but this fallocate issue is a possibility.

More likely speculative preallocation is causing this than
fallocate. However, we've had a background worker that cleans up
speculative prealloc before reporting ENOSPC for a while now - what
kernel version are seeing this on?

Also, it might not even be data allocation that is the issue - if
the filesystem is full and free space is fragmented, you could be
getting ENOSPC because inodes cannot be allocated. In which case,
the output of xfs-info would be useful so we can see if sparse inode
clusters are enabled or not....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
