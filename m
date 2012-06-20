Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5KN4nHN184448 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 18:04:49 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	hjLoWKTAH0GCleDq for <xfs@oss.sgi.com>;
	Wed, 20 Jun 2012 16:04:47 -0700 (PDT)
Date: Thu, 21 Jun 2012 09:04:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/9] xfs: convert internal buffer functions to pass maps
Message-ID: <20120620230446.GO30705@dastard>
References: <20120618204325.GX4721@sgi.com> <20120618210713.GY4721@sgi.com>
	<20120619071552.GA23093@infradead.org>
	<20120619155946.GA2676@sgi.com>
	<20120619170304.GC7554@infradead.org>
	<20120619171153.GD2676@sgi.com> <20120620055619.GA30705@dastard>
	<20120620060400.GA5617@infradead.org>
	<20120620062931.GC30705@dastard> <20120620153659.GI2676@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120620153659.GI2676@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jun 20, 2012 at 10:36:59AM -0500, Ben Myers wrote:
> Hey Fellas,
> 
> On Wed, Jun 20, 2012 at 04:29:31PM +1000, Dave Chinner wrote:
> > On Wed, Jun 20, 2012 at 02:04:00AM -0400, Christoph Hellwig wrote:
> > > On Wed, Jun 20, 2012 at 03:56:19PM +1000, Dave Chinner wrote:
> > > > > they are rebased not to require the inode allocator patchset.  I think that Jan
> > > > > is also going to repost his 'Fix overallocation in xfs_buf_allocate_memory()'
> > > > > based upon Dave's suggestions.  It's best not to depend upon that either.  What
> > > > > do you say, Dave?
> > > > 
> > > > I reorder my local patch set and repost it after running it through
> > > > some testing....
> > > 
> > > Sorry, I totally misunderstood the initial issue - I though Ben had my
> > > series applied, and thus yours didn't apply.
> > 
> > No, other way around ;)
> 
> Right.  Dave's buffer changes don't apply without Christoph's inode allocator
> patchset and Jan's overallocation fix.

No, it only requires Jan's buffer allocation fix. I reordered my
series on a curent tre here yesterday afternoon, and it applied
without conflicts or fuzz on top of jan's patch....

> That'll be great... I too will make reviewing (and testing) these a high
> priority.  Just keep in mind we don't control Jan's schedule...

If that' such a problem, I'll do the one line change and resend it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
