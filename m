Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B04A77F89
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 00:10:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 54CB8AC004
	for <xfs@oss.sgi.com>; Wed, 22 Jul 2015 22:10:50 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	W5Ea9NmZrvMQjpo4 for <xfs@oss.sgi.com>;
	Wed, 22 Jul 2015 22:10:47 -0700 (PDT)
Date: Thu, 23 Jul 2015 15:10:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] block: xfs: dm thin: train XFS to give up on
	retrying IO if thinp is out of space
Message-ID: <20150723051043.GB3902@dastard>
References: <20150720151849.GA2282@redhat.com> <20150720223610.GV7943@dastard>
	<55AE6670.40903@redhat.com> <20150721174753.GA8563@redhat.com>
	<20150722000923.GB7943@dastard> <20150722010056.GC7943@dastard>
	<20150722014029.GA10628@redhat.com> <20150722023711.GD7943@dastard>
	<20150722133451.GB16842@redhat.com> <55AFC496.4000009@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55AFC496.4000009@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: axboe@kernel.dk, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, hch@lst.de, Vivek Goyal <vgoyal@redhat.com>

On Wed, Jul 22, 2015 at 11:28:06AM -0500, Eric Sandeen wrote:
> On 7/22/15 8:34 AM, Mike Snitzer wrote:
> > On Tue, Jul 21 2015 at 10:37pm -0400,
> > Dave Chinner <david@fromorbit.com> wrote:
> >> On Tue, Jul 21, 2015 at 09:40:29PM -0400, Mike Snitzer wrote:
> >>> I'm open to considering alternative interfaces for getting you the info
> >>> you need.  I just don't have a great sense for what mechanism you'd like
> >>> to use.  Do we invent a new block device operations table method that
> >>> sets values in a 'struct no_space_strategy' passed in to the
> >>> blockdevice?
> >>
> >> It's long been frowned on having the filesystems dig into block
> >> device structures. We have lots of wrapper functions for getting
> >> information from or performing operations on block devices. (e.g.
> >> bdev_read_only(), bdev_get_queue(), blkdev_issue_flush(),
> >> blkdev_issue_zeroout(), etc) and so I think this is the pattern we'd
> >> need to follow. If we do that - bdev_get_nospace_strategy() - then
> >> how that information gets to the filesystem is completely opaque
> >> at the fs level, and the block layer can implement it in whatever
> >> way is considered sane...
> >>
> >> And, realistically, all we really need returned is a enum to tell us
> >> how the bdev behaves on enospc:
> >> 	- bdev fails fast, (i.e. immediate ENOSPC)
> >> 	- bdev fails slow, (i.e. queue for some time, then ENOSPC)
> >> 	- bdev never fails (i.e. queue forever)
> >> 	- bdev doesn't support this (i.e. EOPNOTSUPP)
> 
> I'm not sure how this is more useful than the bdev simply responding to
> a query of "should we keep trying IOs?"

	- bdev fails fast, (i.e. immediate ENOSPC)

XFS should use a bound retry behaviour for to allow the possiblity of
the admin adding more space before we shut down the fs. i.e.
XFS fails slow.

	- bdev fails slow, (i.e. queue for some time, then ENOSPC)

We know that IOs are going to be delayed before they are failed, so
there's no point in retrying as the admin has already had a chance
to resolve the ENOSPC condition before failure was reported. i.e.
XFS fails fast.

	- bdev never fails (i.e. queue forever)

Block device will appear to hang when it runs out of space. Nothing
XFS can do here because IOs never fail, but we need to note this in
the log at mount time so that filesystem hangs are easily explained
when reported to us.

	- bdev doesn't support this (i.e. EOPNOTSUPP)

XFS uses default "retry forever" behaviour.

> > This 'struct no_space_strategy' would be invented purely for
> > informational purposes for upper layers' benefit -- I don't consider it
> > a "block device structure" it the traditional sense.
> > 
> > I was thinking upper layers would like to know the actual timeout value
> > for the "fails slow" case.  As such the 'struct no_space_strategy' would
> > have the enum and the timeout.  And would be returned with a call:
> >      bdev_get_nospace_strategy(bdev, &no_space_strategy)
> 
> Asking for the timeout value seems to add complexity.  It could change after
> we ask, and knowing it now requires another layer to be handling timeouts...

I don't think knowing the bdev timeout is necessary because the
default is most likely to be "fail fast" in this case. i.e. no
retries, just shut down.  IOWs, if we describe the configs and
actions in neutral terms, then the default configurations easy for
users to understand. i.e:

bdev enospc		XFS default
-----------		-----------
Fail slow		Fail fast
Fail fast		Fail slow
Fail never		Fail never, Record in log
EOPNOTSUPP		Fail never

With that in mind, I'm thinking I should drop the
"permanent/transient" error classifications, and change it "failure
behaviour" with the options "fast slow [never]" and only the slow
option has retry/timeout configuration options.  I think the "never"
option still needs to "fail at unmount" config variable, but we
enable it by default rather than hanging unmount and requiring a
manual shutdown like we do now....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
