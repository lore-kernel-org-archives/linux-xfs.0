Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 30 Jul 2007 22:31:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6V5V0bm005989
	for <xfs@oss.sgi.com>; Mon, 30 Jul 2007 22:31:04 -0700
Date: Tue, 31 Jul 2007 15:30:48 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: RFC: log record CRC validation
Message-ID: <20070731053048.GP31489@sgi.com>
References: <20070725092445.GT12413810@sgi.com> <46A7226D.8080906@sgi.com> <46A8DF7E.4090006@agami.com> <20070726233129.GM12413810@sgi.com> <46AAA340.60208@agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AAA340.60208@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "William J. Earl" <earl@agami.com>
Cc: xfs-oss <xfs@oss.sgi.com>, David Chinner <dgc@sgi.com>, Michael Nishimoto <miken@agami.com>, markgw@sgi.com

On Fri, Jul 27, 2007 at 07:00:32PM -0700, William J. Earl wrote:
> David Chinner wrote:
> >On Thu, Jul 26, 2007 at 10:53:02AM -0700, Michael Nishimoto wrote:
> >  
> >...
> >>Is CRC checking being added to xfs log data?
> >>    
> >
> >Yes. it's a little used debug option right now, and I'm
> >planning on making it default behaviour.
> >
> >  
> >>If so, what data has been collected to show that this needs to be added?
> >>    
> >
> >The size of high-end filesystems are now at the same order of
> >magnitude as the bit error rate of the storage hardware. e.g. 1PB =
> >10^16 bits. The bit error rate of high end FC drives? 1 in 10^16
> >bits.  For "enterprise" SATA drives? 1 in 10^15 bits. For desktop
> >SATA drives it's 1 in 10^14 bits (i.e. 1 in 10TB).
> 
>       First, note that the claimed bit error rates are rates of 
> reported bad blocks, not rates of silent data corruption.   The latter, 
> while not quoted, are far lower.

Ok, fair enough, but in the absense of numbers and the fact that
real world MTBF numbers are lower than what mfg's quote I'm
always going to assume that this is the ballpark.

[snip stuff about raid6, drive data, I/O path corruptions, etc]

In summary you are effectively saying this: "if you spend enough
money on your storage, then the filesystem doesn't need to worry
about integrity."

I've heard exactly the same lecture you've just given from other
(ex-)XFS engineers that integrity is the total responsibility of the
block device. SGI used to ensure that XFS only ran on hardware that
followed this mantra and so could get away with that approach to
filesystem error detection.

But XFS doesn't live in that world any more. It stopped being true
when XFS got ported to linux. XFS lives in the world of commodity
hardware as well as the high end now and we are getting more and more
situations where we are having to make tradeoffs for preventing
corruption on commodity hardware. e.g. I/O barrier support for disks
with volatile write caches.

IMO, continuing down this same "the block device is perfect" path is
a "head in the sand" approach.  By ignoring the fact that errors can
and do occur, we're screwing ourselves when something does actually
go wrong because we haven't put in place the mechanisms to detect
errors because we've assumed they will never happen.

We've spent 15 years so far trying to work out what has gone wrong
in XFS by adding more and more reactive debug into the code without
an eye to a robust solution. We add a chunk of code here to detect
that problem, a chunk of code there to detect this problem, and so
on. It's just not good enough anymore.

Like good security, filesystem integrity is not provided by a single
mechanism. "Defense in depth" is what we are aiming to provide here
and to do that you have to assume that errors can propagate through
every interface into the filesystem.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
