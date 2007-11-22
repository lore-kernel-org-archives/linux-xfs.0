Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Nov 2007 23:27:09 -0800 (PST)
Received: from waste.org (waste.org [66.93.16.53])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAM7PrxH003055
	for <xfs@oss.sgi.com>; Wed, 21 Nov 2007 23:25:57 -0800
Date: Thu, 22 Nov 2007 01:25:49 -0600
From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/9]: Reduce Log I/O latency
Message-ID: <20071122072549.GQ19691@waste.org>
References: <20071122003339.GH114266761__34694.2978365861$1195691722$gmane$org@sgi.com> <p73oddnhzoq.fsf@bingen.suse.de> <20071122011214.GR114266761@sgi.com> <20071122025726.GG17536@waste.org> <20071122034106.GV114266761@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122034106.GV114266761@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>

On Thu, Nov 22, 2007 at 02:41:06PM +1100, David Chinner wrote:
> On Wed, Nov 21, 2007 at 08:57:27PM -0600, Matt Mackall wrote:
> > On Thu, Nov 22, 2007 at 12:12:14PM +1100, David Chinner wrote:
> > > In all the cases that I know of where ppl are using what could
> > > be considered real-time I/O (e.g. media environments where they
> > > do real-time ingest and playout from the same filesystem) the
> > > real-time ingest processes create the files and do pre-allocation
> > > before doing their I/O. This I/O can get held up behind another
> > > process that is not real time that has issued log I/O. 
> > > 
> > > Given there is no I/O priority inheritence and having log I/O stall
> > > will stall the entire filesystem, we cannot allow log I/O to
> > > stall in real-time environments. Hence it must have the highest
> > > possible priority to prevent this.
> > 
> > I've seen PVRs that would be upset by this. They put media on one
> > filesystem and database/apps/swap/etc. on another, but have everything
> > on a single spindle. Stalling a media filesystem read for a write
> > anywhere else = fail.
> 
> Sounds like the PVR is badly designed to me. If a write can cause a
> read to miss a playback deadline, then you haven't built enough
> buffering into your playback application.

Normally it's not a problem. But your proposed change can push a
working system into a non-working system by making non-critical I/O on
an unrelated filesystem have higher priority than the thing that -actually
has real-time constraints-.

In other words, I/O priority is per-spindle and not per-filesystem and
thus this change has consequences that leak outside the filesystem in
question. That's bad.

I'd further add that the kernel internals probably shouldn't wander
into RT priority levels unless it's actually doing priority
inheritance, otherwise it's quite likely to upset the careful
considerations of the RT system designer's priority schemes. For
instance, a log-heavy but otherwise non-RT load with this patch could
possibly completely starve direct I/O to another partition even though
it's marked RT, thus livelocking the system.

To the general PVR problem: they typically want to work with a minimum
of buffering to maximize responsiveness to user commands (fast
forward, jump 30 seconds, play in reverse). Now consider that you're
recording and playing back multiple HD streams on low-margin set-top
hardware and you'll see that making this work -at all- means lots of
I/O tuning.

-- 
Mathematics is the supreme nostalgia of our time.
