Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 41AB47FA7
	for <xfs@oss.sgi.com>; Wed, 22 Jul 2015 11:51:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0AB508F8052
	for <xfs@oss.sgi.com>; Wed, 22 Jul 2015 09:51:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id INHbZUo2ETSvpleW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Jul 2015 09:51:20 -0700 (PDT)
Date: Wed, 22 Jul 2015 12:51:18 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] block: xfs: dm thin: train XFS to give up on
	retrying IO if thinp is out of space
Message-ID: <20150722165117.GA17738@redhat.com>
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
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, hch@lst.de, Vivek Goyal <vgoyal@redhat.com>

On Wed, Jul 22 2015 at 12:28pm -0400,
Eric Sandeen <sandeen@redhat.com> wrote:

> On 7/22/15 8:34 AM, Mike Snitzer wrote:
> > On Tue, Jul 21 2015 at 10:37pm -0400,
> > Dave Chinner <david@fromorbit.com> wrote:
> > 
> >> On Tue, Jul 21, 2015 at 09:40:29PM -0400, Mike Snitzer wrote:
> >>
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
> 
> IOWS do we really care if it's failing fast or slow, vs. simply knowing
> whether it has now permanently failed?
> 
> So rather than "bdev_get_nospace_strategy" it seems like all we need
> to know is "bdev_has_failed" - do we really care about the details?

My bdev_has_space() proposal is no different then bdev_has_failed().  If
you prefer the more generic name then fine.  But bdev_has_failed() is of
limited utlity outside of devices that provide support.  So I can see
why Dave is resisting it.

Anyway, the benefit of XFS tailoring its independent config based on
dm-thinp's comparable config makes sense to me.  The reason for XFS's
independent config is it could be deployed on any storage (e.g. not
dm-thinp).

Affords XFS to defer to DM thinp but still have comparable functionality
for HW thinp or some other storage.

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

Dave is already saying XFS will have a timeout it'll be managing.
Stands to reason that XFS would base its timeout on DM thinp's timeout.
But yeah it does allow the stacked timeout that XFS uses to be out of
sync if the lower timeout changes (no different than blk_stack_limits).

Please fix this however you see fit.  I'll assist anywhere that makes
sense.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
