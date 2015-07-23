Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 68D507F86
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 12:08:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D8464AC005
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 10:08:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gJNmgc6WBFdk8hJ6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Jul 2015 10:08:38 -0700 (PDT)
Date: Thu, 23 Jul 2015 13:08:36 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [RFC PATCH] block: xfs: dm thin: train XFS to give
	up on retrying IO if thinp is out of space
In-Reply-To: <20150722010056.GC7943@dastard>
Message-ID: <alpine.LRH.2.02.1507231306160.16526@file01.intranet.prod.int.rdu2.redhat.com>
References: <20150720151849.GA2282@redhat.com> <20150720223610.GV7943@dastard>
	<55AE6670.40903@redhat.com> <20150721174753.GA8563@redhat.com>
	<20150722000923.GB7943@dastard> <20150722010056.GC7943@dastard>
MIME-Version: 1.0
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
To: device-mapper development <dm-devel@redhat.com>
Cc: axboe@kernel.dk, Eric Sandeen <sandeen@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, hch@lst.de, Vivek Goyal <vgoyal@redhat.com>



On Wed, 22 Jul 2015, Dave Chinner wrote:

> On Wed, Jul 22, 2015 at 10:09:23AM +1000, Dave Chinner wrote:
> > On Tue, Jul 21, 2015 at 01:47:53PM -0400, Mike Snitzer wrote:
> > > On Tue, Jul 21 2015 at 11:34am -0400, Eric Sandeen <sandeen@redhat.com> wrote:
> > > > On 7/20/15 5:36 PM, Dave Chinner wrote:
> > > > The issue we had discussed previously is that there is no agreement
> > > > across block devices about whether ENOSPC is a permanent or temporary
> > > > condition.  Asking the admin to tune  the fs to each block device's
> > > > behavior sucks, IMHO.
> > > 
> > > It does suck, but it beats the alternative of XFS continuing to do
> > > nothing about the problem.
> > 
> > Just a comment on that: doing nothing is better than doing the wrong
> > thing and being stuck with it forever. :)
> > 
> > > Disucssing more with Vivek, might be that XFS would be best served to
> > > model what dm-thinp has provided with its 'no_space_timeout'.  It
> > > defaults to queueing IO for 60 seconds, once the timeout expires the
> > > queued IOs getted errored.  If set to 0 dm-thinp will queue IO
> > > indefinitely.
> > 
> > Yes, that's exactly what I proposed in the thread I referenced in
> > my previous email, and what got stuck on the bikeshed wall because
> > of these concerns about knob twiddling:
> > 
> > http://oss.sgi.com/archives/xfs/2015-02/msg00346.html
> > 
> > | e.g. if we need configurable error handling, it needs to be
> > | configurable for different error types, and it needs to be
> > | configurable on a per-mount basis. And it needs to be configurable
> > | at runtime, not just at mount time. That kind of leads to using
> > | sysfs for this. e.g. for each error type we ned to handle different
> > | behaviour for:
> > | 
> > | $ cat /sys/fs/xfs/vda/meta_write_errors/enospc/type
> > | [transient] permanent
> > | $ cat /sys/fs/xfs/vda/meta_write_errors/enospc/perm_timeout_seconds
> > | 300
> > | $ cat
> > | /sys/fs/xfs/vda/meta_write_errors/enospc/perm_max_retry_attempts
> > | 50
> > | $ cat
> > | /sys/fs/xfs/vda/meta_write_errors/enospc/transient_fail_at_umount
> > | 1
> > 
> > I've rebased this patchset, and I'm cleaning it up now, so in a few
> > days I'll have something for review, likely for the 4.3 merge
> > window....
> 
> Just thinking a bit more on how to make this simpler to configure,
> is there a simple way for the filesystem to determine the current
> config of the dm thinp volume?

You can just stop retrying the I/Os when the user attempts to unmount the 
filesystem - then, you don't need any configuration option.

Mikulas

> i.e. if the dm-thinp volume is
> configured to error out immediately on enospc, then XFS should
> default to doing the same thing. having XFS be able to grab this
> status at mount time and change the default ENOSPC error config from
> transient to permanent on such dm-thinp volumes would go a long way
> to making these configs Just Do The Right Thing on block dev enospc
> errors...
> 
> e.g. if dm-thinp is configured to queue for 60s and then fail on
> ENOSPC, we want XFS to fail immediately on ENOSPC in metadata IO. If
> dm-thinp is configured to ENOSPC instantly (i.e. no queueing) then
> we want XFS to retry and use it's default retry maximums before
> failing permanently.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
