Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:63555 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752192AbdIFDos (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2017 23:44:48 -0400
Date: Wed, 6 Sep 2017 13:44:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/3] XFS real-time device tweaks
Message-ID: <20170906034443.GQ17782@dastard>
References: <20170902224145.1291030-1-rwareing@fb.com>
 <20170903085602.GF32385@infradead.org>
 <30E1D468-6E15-469E-8026-8EE542201422@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30E1D468-6E15-469E-8026-8EE542201422@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>

On Sun, Sep 03, 2017 at 10:02:41PM +0000, Richard Wareing wrote:
> 
> > On Sep 3, 2017, at 1:56 AM, Christoph Hellwig
> > <hch@infradead.org> wrote:
> > 
> > On Sat, Sep 02, 2017 at 03:41:42PM -0700, Richard Wareing
> > wrote:
> >> - Replaced rtdefault with rtdisable, this yields similar
> >> operational benefits when combined with the existing mkfs time
> >> setting of the inheritance flag on the root directory.  Allows
> >> temporary disabling of real-time allocation without having to
> >> walk entire FS to remove flags (which could be time consuming).
> >> I still don't think it's super obvious to an admin the
> >> real-time flag was put there at mkfs time (vs. rtdefault being
> >> in mount flags), but this gets me half of what I'm after.
> > 
> > I still don't understand this option.  What is the use case of
> > dynamically switching on/off these default to the rt device?
> > 
> 
> Say you are in a bit of an emergency, and you need IOPs *now*
> (incident recovery), w/ rtdisable you could funnel the IO to the
> SSD

But it /doesn't do that/. It only disables new files from writing to
the rt device. All reads for data in the RT device and writes to
existing files still go to the RT device.


> without having to strip the inheritance bits from all the
> directories (which would require two walks....one to remove and
> one to add them all back).    I think this is about having some
> options during incidents, and a "kill-switch" should the need
> arise.

And soon after the kill switch is triggered, your tiny data device
will go ENOSPC because changing that mount option effective removed
TBs of free space from the filesystem. Then things will really start
going bad.

So maybe you didn't think this through properly - the last thing a
typical user would expect is a filesystem reporting TBs of free
space to go ENOSPC and not being able to recover, regardless of what
mount options are present. iAnd they'll be especially confused when
they start looking at inodes and seeing RT bits set all over the
place...

It's just a recipe for confusion, unexpected behaviour and all I
see here is a support and triage nightmare. Not to mention FB will
move on to something else in a couple of years, and we get stuck
having to maintain it forever more (*cough* filestreams *cough*).

> The other problem I see is accessibility and usability.  By making
> these decisions buried in more generic XFS allocation mechanisms
> or fnctl's, few developers are going to really understand how to
> safely use them (e.g. without blowing up their SSD's WAF or
> endurance). 

The whole point of putting them into the XFS allocator as admin
policies is that *applications developers don't need to know they
exist*.

> Fallocation is a better understood notion, easier to
> use and has wider support amongst existing utilities.

Almost every application I've seen that uses fallocate does
something wrong and/or breaks a longevity or performance
optimisation that filesystems have been making for years. 

fallocate is "easy to understand" but *difficult to use optimally*
because it's behaviour is tightly bound to the filesystem allocator
algorithms. i.e. it's easy to defeat hidden filesystem optimisations
with fallocate, but it's difficult to understand a sub-optimal
corner case in the filesystem allocator that fallocate could be used
to avoid.

In reality, we don't want people using fallocate - the filesystem
algorithms should do the right thing so people don't need to modify
their applications. In cases like this, having the filesystem decide
automatically at first allocation what device to use is the right
way to integrate the functionality, not require users to use
fallocate to trigger such a decision and, as a side effect, prevent
the filesystem from making all the other optimisations they still
want it to make.

> Keep in
> mind, we need our SSDs to last >3 years (w/ only a mere 70-80 TBW;
> 300TBW if we are lucky), so we want to design things such that
> application developers are less likely to step on land mines
> causing pre-mature SSD failure.

Hmmm. I don't think they way you are using fallocate is doing what
you think it is doing.

That is, using fallocate to preallocate all files so you can direct
allocation to a different device means that delayed allocation is
turned off. Hence XFS cannot optimise allocation across multiple
files at writeback time. This means that writeback across multiple
files will be sprayed around disjointed preallocated regions. When
using delayed allocation, the filesystem will allocate the blocks
for all the files sequentially and so the block layer merge will
them all into one big contiguous IO.

IOWs, fallocate sprays write IO around because they decouple
allocation locality from temporal writeback locality and this causes
non-contiguous write patterns which are a significant contributin
factor to write amplification in SSDs.  In comparison, delayed
allocation results in large sequential IOs that minimise write
amplification in the SSD...

Hence the method you describe that "maximises SSD life" won't help
- if anything it's going to actively harm the SSD life when
compared to just letting the filesystem use delayed allocation and
choose what device to write to at that time....

Hacking one-off high level controls into APIs like fallocate does
not work. Allocation policies need to be integrated into the
filesystem allocators for them to be effective and useful to
administrators and applications alike. fallocate is no sustitute for
the black magic that filesystems do to optimise allocation and IO
patterns....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
