Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F1CE7F8A
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:18:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1BF86304039
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:18:54 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	5z0R8B5DQ3EK76Gx for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 22:18:38 -0700 (PDT)
Date: Wed, 19 Jun 2013 15:18:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: garbage block(s) after powercycle/reboot + sparse writes
Message-ID: <20130619051824.GH29338@dastard>
References: <alpine.DEB.2.00.1306041210070.15156@cobra.newdream.net>
	<51AE84C9.5030903@sandeen.net>
	<alpine.DEB.2.00.1306120955460.15386@cobra.newdream.net>
	<20130619014646.GF29338@dastard>
	<alpine.DEB.2.00.1306181959250.27409@cobra.newdream.net>
	<20130619040547.GG29338@dastard>
	<alpine.DEB.2.00.1306182109340.27409@cobra.newdream.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1306182109340.27409@cobra.newdream.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Sage Weil <sage@inktank.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Jun 18, 2013 at 09:15:31PM -0700, Sage Weil wrote:
> On Wed, 19 Jun 2013, Dave Chinner wrote:
> > On Tue, Jun 18, 2013 at 08:12:01PM -0700, Sage Weil wrote:
> > > > I'd love to see the code that is writing the files in the first
> > > > place - it's not playing silly buggers with sync_file_range(), is
> > > > it?
> > > 
> > > Actually, it is!
> > > 
> > > ...
> > > 	  ::sync_file_range(fd, off, len, SYNC_FILE_RANGE_WRITE);
> > > ...
> > > 	    int fa_r = posix_fadvise(fd, off, len, POSIX_FADV_DONTNEED);
> > > 
> > > ...and a call to close(2).
> > 
> > <sigh>
> > 
> > > The intent was just to push things out of the disk so that a syncfs() 
> > > that comes later will take less time.  I wouldn't have expected this to 
> > > change the commit ordering semantics, though; only to initiate writeback 
> > > sooner.
> > 
> > It initiates writeback on certain ranges of the file before others,
> > and so therefore can expose issues related to ordering of writeback.
> > It's made worse by the fact that, by definition, both
> > sync_file_range() and posix_fadvise(POSIX_FADV_DONTNEED) provide no
> > data integrity guarantees. And, further, neither are vectored
> > through the filesystem like fsync is and so the filesystem can't
> > provide any integrity guarantees, either.
> 
> Sigh... well that explains that.  I realize that these calls don't provide 
> any guarantees themselves (hence the syncfs(2) call later), but I did 
> not expect them to break zeroing. 

Neither did I.

> (That sounds problematic from a 
> security perspective?)

Yes, it is. I think i can fix the problem fairly easily, though, as
we have these things called unwritten extents and a function that
can convert an arbitrary byte range of a file to unwritten extents..

FWIW, what I've been seeing over the past few months is that people
responsible for distributed storage software that uses
posix_fadvise(POSIX_FADV_DONTNEED) has been getting much more
testing as there have been lots of strange side effects being
noticed.  What it tells me is that these interfaces are not very
well tested even though they have been around for years and are
considered "mature". 

e.g. even the fact that POSIX_FADV_DONTNEED could not stop cache
growth under typical object storage server loads was not discovered
until recently - it was fixed in 3.9-rc1. This is probably due to
the fact that these interfaces have, historically, not had wide use
in applications that make heavy use of them and/or care about data
integrity.

Given that problems with data integrity are much harder to trigger,
much harder to test and are much less tested, I'm not surprised by
the fact that these "mature" interfaces are being found to be
extremely unreliable from an application POV...

> Is sync_file_range(2) similarly problematic with ext4?

In data=writeback mode, most definitely. For data=ordered, I have no
idea - the writeack paths in ext4 are ... convoluted, and I hurt my
brain every time I look at them. I wouldn't be surprised if there
are problems, but they'll be different problems because ext4 doesn't
do speculative prealloc...

> > Hence if you use range based posix_fadvise(DONTNEED) and/or
> > sync_file_range(), you can get real strange things happening as data
> > writeback ordering is fully under the control of the user, not the
> > filesystem, and the user, in general, has no clue about what the
> > filesystem is doing under the covers.
> > 
> > > (Coincidentally, all of this code was just recently rewritten to do a 
> > > simple fsync.  I haven't retested the powercycling since then, though.)
> > 
> > fsync should work just fine, as it does increasing offset writeback
> > and that means the zeroed blocks will get written before the data
> > blocks and so uninitialised data won't get exposed....
> 
> For the stable bugfix fdatasync(2) is preferred; that will do the same 
> increasing offset writeback I assume?

Yup.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
