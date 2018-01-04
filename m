Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38862 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbeADAyL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jan 2018 19:54:11 -0500
Date: Wed, 3 Jan 2018 16:52:48 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [ZOMG RFCRAP PATCH 0/2] xfs: horrifying eBPF hacks
Message-ID: <20180104005248.GD16402@magnolia>
References: <20171213061825.GO19219@magnolia>
 <20171221133338.GD1567@infradead.org>
 <20171221164535.GS12613@magnolia>
 <F1508AF4-D241-47AA-B690-6AF6073D0E25@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F1508AF4-D241-47AA-B690-6AF6073D0E25@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "david@fromorbit.com" <david@fromorbit.com>

On Thu, Jan 04, 2018 at 12:05:21AM +0000, Richard Wareing wrote:
> Hey Darrick,
> 
> I'll try to get to testing this out early next week, I was out on vacation 
> the last couple weeks so I kinda fell off the earth for a bit.
> 
> I will test for functionality & performance as best I can, but we'll probably
> want to explore everyone's concerns on leveraging eBPF in this way as
> well.  I have pretty limited experience with BPF, so I'm probably not going
> to be super useful in such a discussion, though I'll certainly try to get read
> up on it.
> 
> Is there any precedence for doing this sort of thing with BPF anywhere
> else in the kernel?

Well, we use JIT compiled eBPF to allow userspace to read kernel memory
now, so it's probably fine to let it fiddle with XFS since we've all
already lost anyway. ;)

Seriously, no, there isn't any precedent, hence the ZOMFG RFCRAP tags.
I'm pretty sure that at best BPF XFS falls into a gray area where in
theory all the protections are sufficient but nobody will ever believe
it...

...but that doesn't mean it isn't worth giving the idea a healthy shake
on the mailing list.  <cue flames>

--D

> Richard
> 
> 
> > On Dec 21, 2017, at 8:45 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > 
> > On Thu, Dec 21, 2017 at 05:33:38AM -0800, Christoph Hellwig wrote:
> >> Eek.  Whie eBPF is a really nice debug tool we should never use
> >> it for actual required kernel I/O functionality.
> > 
> > Certainly not in its current hacky form.  I'm curious if Richard has had
> > a chance to try out these patches to see if it affects performance in a
> > noticeable way?
> > 
> > I /think/ bpf has enough safety mechanisms (no loops, no direct writing
> > to kernel memory, bytecode verifiers, opcode count limits) that such a
> > beast could be hidden behind a kconfig option that isn't turned for the
> > general public.  For people who have these particularly specific use
> > cases I think it better to have a general mechanism to accomodate them
> > vs. scattering code all over xfs vs. "no sorry go away", though this
> > ebpf thing isn't necessarily the final answer.  We do validate that the
> > proposed iflags are allowed for the fs geometry, though I acknowledge
> > that the prospect of running ebpf with ilock_excl does give me pause.
> > 
> > I'm curious, though, what are your (and everyone else's) concerns about
> > this?
> > 
> > --D
> > 
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
