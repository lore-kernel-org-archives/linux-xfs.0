Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Aug 2008 15:00:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7FM0jNU021694
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2008 15:00:45 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C1753A0CBB
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2008 15:02:03 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id dDoBReOy1rN8xetm for <xfs@oss.sgi.com>; Fri, 15 Aug 2008 15:02:03 -0700 (PDT)
Date: Sat, 16 Aug 2008 00:02:03 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] btree test harness
Message-ID: <20080815220203.GA25942@lst.de>
References: <20080813223022.GA15025@lst.de> <20080814005755.GF6119@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814005755.GF6119@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

> > does it's own freelist to avoid having to call in the alloc code
> > and make it even slower.
> 
> I'll have a closer look in a while. It's just a bitmap array, right?

Yes, it's just a trivial bitmap of all blocks.

> > I'd also like some input on how interface to userspace.  Doing it during
> > mount but conditional would be one option, the other one an ioctl -
> > in both cases I'd like to be able to specify up to which maxlevel to go
> > as the tests for higher levels can take forever.
> 
> I was thinking of a couple of approaches when I started on this
> harness:
> 
> 	- similar to RCU torture tests, the btree test harness is
> 	  run on XFS intialisation if config'd in. Requires faking a
> 	  struct xfs_mount, though, and isn't configurable.
> 	- ioctl interface to run each test operation individually,
> 	  and hook that up to an xfsqa test that used a sparse
> 	  loopback mounted filesytem to exercise AG sizes up to 1TB.
> 
> I think the second approach allows us to test btrees on demand on
> arbitrary disposable filesystems. It would also allow us to easily
> extend the test harness over time - a new xfsqa test group could be
> added so that each test can be written as a standalone test so
> that we can easily isolate regressions.

Faking up the mount doesn't really wrok, we need a _lot_ of fields
in there, plus a buftarg plus a real xfs_trans and thus the whole log
subsystem, so we need a real filesystem anyway.  With the way I use a
separate btree I can just use up the whole filesystem without making
it sprase.  But yes, splitting things into individual ioctls makes sense
to make the tests a little more flexible.
