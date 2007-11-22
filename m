Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 Nov 2007 14:29:23 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAMMTF9g027104
	for <xfs@oss.sgi.com>; Thu, 22 Nov 2007 14:29:17 -0800
Date: Fri, 23 Nov 2007 09:29:09 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 2/9]: Reduce Log I/O latency
Message-ID: <20071122222909.GY114266761@sgi.com>
References: <20071122003339.GH114266761__34694.2978365861$1195691722$gmane$org@sgi.com> <p73oddnhzoq.fsf@bingen.suse.de> <20071122011214.GR114266761@sgi.com> <20071122025726.GG17536@waste.org> <20071122034106.GV114266761@sgi.com> <20071122072549.GQ19691@waste.org> <20071122103159.GW114266761@sgi.com> <20071122181029.GR19691@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122181029.GR19691@waste.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matt Mackall <mpm@selenic.com>
Cc: David Chinner <dgc@sgi.com>, Andi Kleen <andi@firstfloor.org>, xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>

On Thu, Nov 22, 2007 at 12:10:29PM -0600, Matt Mackall wrote:
> On Thu, Nov 22, 2007 at 09:31:59PM +1100, David Chinner wrote:
> [...]
> > > In other words, I/O priority is per-spindle and not per-filesystem and
> > > thus this change has consequences that leak outside the filesystem in
> > > question. That's bad.
> > 
> > This has nothing to do with this patch - it's a problem with sharing
> > a single resource in a RT system between two non-deterministic
> > constructs. e.g. I can put two ext3 filesystems on the one spindle,
> > run two completely independent RT workloads on the different
> > filesystems and have one workload DOS the other due to differences
> > in priority at the spindle.
> 
> Sure. And it's up to the RT system designer not to do something stupid
> like that. The problem is that your patch potentially promotes a
> non-RT I/O activity to an RT one without regard to the rest of the
> system.

So this:

http://marc.info/?l=linux-kernel&m=119247074517414&w=2

shouldn't be allowed, either? (rt kjournald for ext3)

> Perfectly understood. And that's fine. A system designer is allowed to
> shoot himself in the foot.

Ok. I'll point anyone that complains at you, Matt ;)

> I don't think there's any fundamental reason the I/O subsystem or
> filesystems can't be taught to handle priority inversion, which is
> much more acceptable and general fix.

See my reply to Andi.

> If I've got XFS on filesystems A and B on the same spindle (or volume
> group?) and my real RT I/O takes place only on B, then I want log
> flushing to happen in RT on B. But -never on A-. If I can do this with
> a tunable, I'm perfectly happy.

No, not another mount option. I'm just going to drop this one for
now...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
