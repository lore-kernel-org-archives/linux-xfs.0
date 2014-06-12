Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DD0647F53
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 18:57:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 58DB1AC008
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 16:57:26 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ESBcqRgwBUcLE042 for <xfs@oss.sgi.com>;
	Thu, 12 Jun 2014 16:57:24 -0700 (PDT)
Date: Fri, 13 Jun 2014 09:57:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] xfs: wire up aio_fsync method
Message-ID: <20140612235710.GU9508@dastard>
References: <1402562047-31276-1-git-send-email-david@fromorbit.com>
	<20140612152458.GB3148@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140612152458.GB3148@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 12, 2014 at 11:24:58AM -0400, Brian Foster wrote:
> On Thu, Jun 12, 2014 at 06:34:07PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We've had plenty of requests for an asynchronous fsync over the past
> > few years, and we've got the infrastructure there to do it. But
> > nobody has wired it up to test it. The common request we get from
> > userspace storage applications is to do a post-write pass over a set
> > of files that were just written (i.e. bulk background fsync) for
> > point-in-time checkpointing or flushing purposes.
> > 
> > So, just to see if I could brute force an effective implementation,
> > wire up aio_fsync, add a workqueue and push all the fsync calls off
> > to the workqueue. The workqueue will allow parallel dispatch, switch
> > execution if a fsync blocks for any reason, etc. Brute force and
> > very effective....
....
> That looks great. This is something that could be quite beneficial to
> glusterfs, as a real world example. The replication mechanism does an
> xattr dance across servers and required addition of fsync's into the
> algorithm to ensure correctness in the case of failures. This had a
> notable impact on performance.

*nod*

> We thought a bit about hooking up aio_fsync(), but more along the lines
> of waiting for the log to force rather than forcing it explicitly, but
> didn't really go anywhere with it. I didn't consider we'd get such a
> benefit from simply dropping it into a workqueue. :)

Neither did I. I was expecting a small performance increase, not a
4-5x improvement.  I'm quite surprised that the log sustained that
level of force operations, too, but it's quite inefficient because
we don't need to do all those log forces and they are causing lock
contention at higher thread counts.

> I do like Christoph's idea... perhaps create a generic_file_aio_fsync()
> or some such?

Perhaps, but XFS won't use it because I really want to optimise away
the majority of the redundant log forces before pushing this
further. This patch is a proof of concept for XFS, not a generic
solution for all filesystems.  That's not to say it can't be made a
generic solution, but that's a different story altogether, and
something that can happen after I've got XFS sorted out...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
