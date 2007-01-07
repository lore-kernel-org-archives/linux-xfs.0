Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Jan 2007 15:34:43 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l07NYaqw020499
	for <linux-xfs@oss.sgi.com>; Sun, 7 Jan 2007 15:34:37 -0800
Date: Mon, 8 Jan 2007 10:33:34 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [Fwd: [Fwd: xfs write speed regression 2.6.18.1 to 2.6.19.1]]
Message-ID: <20070107233334.GW44411608@melbourne.sgi.com>
References: <459ECF04.4090803@exegy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <459ECF04.4090803@exegy.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Lloyd <dlloyd@exegy.com>
Cc: linux-xfs@oss.sgi.com

On Fri, Jan 05, 2007 at 04:19:48PM -0600, Dave Lloyd wrote:
> From a co-worker. Anyone know what might have changed this between
> 2.6.18 and 2.6.19 when the issue first appeared?

IIRC< a bunch of changes went into the generic buffered I/O
path to fix deadlocks on writes if we take a page fault during
the copyin. That caused a performance regression for buffered
I/O of around that sort of figure, and the regression is slowly
being fixed up as per:

> under 2.6.20-rc3 the speeds have gone back up some, but they are 10%
> slower than 2.6.18.

So I don't think this is an XFS problem as such. Still, I will try
to do some local tests to check it out.

> and the allocations, as shown by the sequential writes (attached) are
> random.

????

> If I went all the way out to the inside tracks, you would be at about
> 490MB/Sec.
> 
> Something changed. 2.6.19 was unstable, with XFS panics on a regular basis.

Got any stack traces?

> 2.6.19.1 has not had an error yet.. (knock head on wall repeatedly).

We didn't push any changes into 2.6.19.1, so that implies bugs in
the generic code, not XFS....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
