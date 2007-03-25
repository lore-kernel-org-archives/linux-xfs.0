Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 24 Mar 2007 20:19:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2P3Jj6p018695
	for <xfs@oss.sgi.com>; Sat, 24 Mar 2007 20:19:47 -0700
Date: Sun, 25 Mar 2007 14:19:27 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS and write barriers.
Message-ID: <20070325031927.GG32602149@melbourne.sgi.com>
References: <17923.11463.459927.628762@notabene.brown> <1755676AA526FF7790546385@timothy-shimmins-power-mac-g5.local> <17923.35118.139991.252734@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17923.35118.139991.252734@notabene.brown>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Neil Brown <neilb@suse.de>
Cc: Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

On Fri, Mar 23, 2007 at 07:00:46PM +1100, Neil Brown wrote:
> On Friday March 23, tes@sgi.com wrote:
> > >
> > > I think this test should just be removed and the xfs_barrier_test
> > > should be the main mechanism for seeing if barriers work.
> > >
> > Oh okay.
> > This is all Christoph's (hch) code, so it would be good for him to comment here.
> > The external log and readonly tests can stay though.
> > 
> 
> Why no barriers on an external log device??? Not important, just
> curious.

because we need to synchronize across 2 devices, not one, so issuing
barriers on an external log device does nothing to order the metadata
written to the other device...

> > > This is particularly important for md/raid1 as it is quite possible
> > > that barriers will be supported at first, but after a failure and
> > > different device on a different controller could be swapped in that
> > > does not support barriers.
> > >
> > 
> > Oh okay, I see. And then later one that supported them can be swapped back in?
> > So the other FSs are doing a sync'ed write out and then if there is an
> > EOPNOTSUPP they retry and disable barrier support henceforth?
> > Yeah, I guess we could do that in xlog_iodone() on failed completion and retry the write without
> > the ORDERED flag on EOPNOTSUPP error case (and turn off the flag).
> > Dave (dgc) can you see a problem with that?
> 
> If an md/raid1 disables barriers and subsequently is restored to a
> state where all drives support barriers, it currently does *not*
> re-enable them device-wide.  This would probably be quite easy to
> achieve, but as no existing filesystem would ever try barriers
> again.....

And this is exactly why I think we need a block->fs communications
channel for these sorts of things. Think of something like the CPU
hotplug notifier mechanisms as a rough example framework....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
