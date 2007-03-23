Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 23 Mar 2007 01:00:56 -0700 (PDT)
Received: from mx2.suse.de (ns2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2N80q6p012514
	for <xfs@oss.sgi.com>; Fri, 23 Mar 2007 01:00:53 -0700
From: Neil Brown <neilb@suse.de>
Date: Fri, 23 Mar 2007 19:00:46 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17923.35118.139991.252734@notabene.brown>
Subject: Re: XFS and write barriers.
In-Reply-To: message from Timothy Shimmin on Friday March 23
References: <17923.11463.459927.628762@notabene.brown>
	<1755676AA526FF7790546385@timothy-shimmins-power-mac-g5.local>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

On Friday March 23, tes@sgi.com wrote:
> >
> > I think this test should just be removed and the xfs_barrier_test
> > should be the main mechanism for seeing if barriers work.
> >
> Oh okay.
> This is all Christoph's (hch) code, so it would be good for him to comment here.
> The external log and readonly tests can stay though.
> 

Why no barriers on an external log device??? Not important, just
curious.

> 2.
> > Secondly, if a barrier write fails due to EOPNOTSUPP, it should be
> > retried without the barrier (after possibly waiting for dependant
> > requests to complete).  This is what other filesystems do, but I
> > cannot find the code in xfs which does this.
> > The approach taken by xfs_barrier_test seems to suggest that xfs does
> > do this... could someone please point me to the code ?
> >
> You got me confused here.
> I was wondering why the test write of the superblock (in xfs_barrier_test)
> should be retried without barriers :)
> But you were referring to the writing of the log buffers using barriers.
> Yeah, if we get an EOPNOTSUPP AFAIK, we will report the error and shutdown
> the filesystem (xlog_iodone()). This will happen when one of our (up to 8)
> incore log buffers I/O completes and xlog_iodone handler is called.
> I don't believe we have a notion of barrier'ness changing for us, and
> we just test it at mount time.
> Which bit of code led you to believe we do a retry?

Uhmm.. I think I just got confused reading xfs_barrier_test,  I cannot
see it anymore (I think I didn't see the error return and so assumed
some lower layer but be setting some state flag).

> 
> > This is particularly important for md/raid1 as it is quite possible
> > that barriers will be supported at first, but after a failure and
> > different device on a different controller could be swapped in that
> > does not support barriers.
> >
> 
> Oh okay, I see. And then later one that supported them can be swapped back in?
> So the other FSs are doing a sync'ed write out and then if there is an
> EOPNOTSUPP they retry and disable barrier support henceforth?
> Yeah, I guess we could do that in xlog_iodone() on failed completion and retry the write without
> the ORDERED flag on EOPNOTSUPP error case (and turn off the flag).
> Dave (dgc) can you see a problem with that?

If an md/raid1 disables barriers and subsequently is restored to a
state where all drives support barriers, it currently does *not*
re-enable them device-wide.  This would probably be quite easy to
achieve, but as no existing filesystem would ever try barriers
again.....

Thanks,
NeilBrown
