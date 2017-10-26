Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39202 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932394AbdJZT7c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 15:59:32 -0400
Date: Thu, 26 Oct 2017 12:59:23 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfsprogs: Issue smaller discards at mkfs
Message-ID: <20171026195923.GB5483@magnolia>
References: <20171026144131.26885-1-keith.busch@intel.com>
 <20171026162518.GW5483@magnolia>
 <3ad1751a-a4df-b0ee-d2c5-d1ac4deb5b46@sandeen.net>
 <0d50ca3b-0b27-8ac1-c102-9ea656f3f926@sandeen.net>
 <20171026183216.GA27317@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171026183216.GA27317@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Keith Busch <keith.busch@intel.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Thu, Oct 26, 2017 at 12:32:17PM -0600, Keith Busch wrote:
> On Thu, Oct 26, 2017 at 01:01:29PM -0500, Eric Sandeen wrote:
> > On 10/26/17 12:49 PM, Eric Sandeen wrote:
> > > Yeah, lots of devices are unhappy with large discards.  And yeah, in the
> > > end I think this papers over a kernel and/or hardware problem.
> > > 
> > > But sometimes we do that, if only to keep things working reasonably
> > > well with older kernels or hardware that'll never get fixed...
> > > 
> > > (TBH sometimes I regret putting mkfs-time discard in by default in the
> > > first place.)
> > 
> > I think I left this on a too-positive note.  It seems pretty clear that there
> > is no way to fix all of userspace to not issue "too big" discards, when
> > "too big" isn't even well-defined, or specified by anything at all.
> 
> Yeah, I totally get this proposal is just a bandaid, and other user
> space programs may suffer when used with devices behaving this way. XFS
> is just very popular, so it's frequently reported as problematic against
> large capacity devices.

Sure, but now you have to go fix mke2fs and everything /else/ that
issues BLKDISCARD (or FALLOC_FL_PUNCH) on a large file / device, and
until you fix every program to work around this weird thing in the
kernel there'll still be someone somewhere with this timeout problem...

...so I started digging into what the kernel does with a BLKDISCARD
request, which is to say that I looked at blkdev_issue_discard.  That
function uses blk_*_plug() to wrap __blkdev_issue_discard, which in turn
splits the request into a chain of UINT_MAX-sized struct bios.

128G's worth of 4G ios == 32 chained bios.

2T worth of 4G ios == 512 chained bios.

So now I'm wondering, is the problem more that the first bio in the
chain times out because the last one hasn't finished yet, so the whole
thing gets aborted because we chained too much work together?

Would it make sense to fix __blkdev_issue_discard to chain fewer bios
together?  Or just issue the bios independently and track the
completions individually?

> > I'm not wise in the ways of queueing and throttling, but from my naiive
> > perspective, it seems like something to be fixed in the kernel, or if it
> > can't, export some new "maximum discard request size" which can be trusted?

I would've thought that's what max_discard_sectors was for, but... eh.

How big is the device you were trying to mkfs, anyway?

--D

> The problem isn't really that a discard sent to the device was "too
> big". It's that "too many" are issued at the same time, and there isn't
> a way for a driver to limit the number of outstanding discards without
> affecting read/write.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
