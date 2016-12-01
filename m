Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:22204 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754940AbcLALD5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Dec 2016 06:03:57 -0500
Date: Thu, 1 Dec 2016 22:03:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS bug?
Message-ID: <20161201110347.GD11750@dastard>
References: <0F1FE7A8-D5C6-4FFD-9B9C-E03FB1962F3E@flyingcircus.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0F1FE7A8-D5C6-4FFD-9B9C-E03FB1962F3E@flyingcircus.io>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christian Theune <ct@flyingcircus.io>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 30, 2016 at 02:07:39PM +0100, Christian Theune wrote:
> Hi there,
> 
> we’re running a Ceph cluster which had a very rough outage not
> long ago[1].
> 
> When updating our previous kernels from 4.1.16 (Gentoo) to 4.4.27
> (Gentoo) we encountered the following problem in our production
> environment (but not in staging or development):

Hi Christian - thanks for perservering and getting this report to
the list. :P

> 
> - Properly shut down and reboot the machine running Ceph OSDs on XFS w/ kernel 4.1.16.
> - Boot with 4.4.27, let the machine mount the FS’ and start OSDs
> - Have everything run 20-30 minutes
> - Ceph OSDs start crashing. Kernel shows messages attached in kern.log

Which shouldn't happen. I'm pretty sure it's the AGFL packing change
that has caused the problem here, but I'm still paging all that
back into memory and clearing out all the other little things I need
to before digging back into this. I have a couple of ideas about how
this could occur:

> An interesting error we saw during repair was this (I can’t remember or reconstruct whether this was on the 4.1 or 4.4 kernel):
> 
> bad agbno 4294967295 in agfl, agno 12
> freeblk count 7 != flcount 6 in ag 12
> sb_fdblocks 82969993, counted 82969994

Because this:

> Note, that the agbno is 2**32-1 repeatedly

is NULLAGBNO, which is what the AGFL is initialised to by mkfs, and
indicates we're accessing a slot that hasn't been filled correctly.

> Also interesting: the broken filesystems and xfs_repair behaved
> completely differently whether talked to from a 4.1 or 4.4 kernel,
> thus the pattern of first running xfs_repair on 4.1 and then again
> on 4.4.

Yup, I'd expect that given that xfs_repair has the same AGFL packing
issue and what it ends up with is dependent on whether the packing
matches the kernel being run or not...

> This looks similar to [2] and may be related to the already fixed
> bug referenced by Dave in [3], but in our case there was no 32/64
> bit migration involved.

That was the initial discovery vector, but looking into this again I
suspect the issue is packing changes the slot indexing. I do have a
patchset where I started trying to fix all this up automatically,
and so I need to go back to that and sort out where I was up to and
see if I was addressing this index offset problem at all. This is
where I previously got up to:

https://www.spinics.net/lists/linux-xfs/msg00445.html

More tomorrow once I've dug in further...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
