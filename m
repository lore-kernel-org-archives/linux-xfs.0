Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 47D477FB5
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2015 02:33:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 176878F8049
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2015 00:33:16 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	XHzaOWeJ3Q6QTXxq for <xfs@oss.sgi.com>;
	Thu, 05 Nov 2015 00:33:13 -0800 (PST)
Date: Thu, 5 Nov 2015 19:33:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC 00/11] DAX fsynx/msync support
Message-ID: <20151105083309.GJ19199@dastard>
References: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
	<20151030035533.GU19199@dastard>
	<20151030183938.GC24643@linux.intel.com>
	<20151101232948.GF10656@dastard>
	<x49vb9kqy5k.fsf@segfault.boston.devel.redhat.com>
	<20151102201029.GI10656@dastard>
	<x49twp4p11j.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49twp4p11j.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-nvdimm@ml01.01.org, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, Dan Williams <dan.j.williams@intel.com>, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, axboe@kernel.dk, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

[ sorry for slow response, been without an internet connection for
~36 hours ]

On Mon, Nov 02, 2015 at 04:02:48PM -0500, Jeff Moyer wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > On Mon, Nov 02, 2015 at 09:22:15AM -0500, Jeff Moyer wrote:
> >> Dave Chinner <david@fromorbit.com> writes:
> >> 
> >> > Further, REQ_FLUSH/REQ_FUA are more than just "put the data on stable
> >> > storage" commands. They are also IO barriers that affect scheduling
> >> > of IOs in progress and in the request queues.  A REQ_FLUSH/REQ_FUA
> >> > IO cannot be dispatched before all prior IO has been dispatched and
> >> > drained from the request queue, and IO submitted after a queued
> >> > REQ_FLUSH/REQ_FUA cannot be scheduled ahead of the queued
> >> > REQ_FLUSH/REQ_FUA operation.
> >> >
> >> > IOWs, REQ_FUA/REQ_FLUSH not only guarantee data is on stable
> >> > storage, they also guarantee the order of IO dispatch and
> >> > completion when concurrent IO is in progress.
> >> 
> >> This hasn't been the case for several years, now.  It used to work that
> >> way, and that was deemed a big performance problem.  Since file systems
> >> already issued and waited for all I/O before sending down a barrier, we
> >> decided to get rid of the I/O ordering pieces of barriers (and stop
> >> calling them barriers).
> >> 
> >> See commit 28e7d184521 (block: drop barrier ordering by queue draining).
> >
> > Yes, I realise that, even if I wasn't very clear about how I wrote
> > it. ;)
> >
> > Correct me if I'm wrong: AFAIA, dispatch ordering (i.e. the "IO
> > barrier") is still enforced by the scheduler via REQ_FUA|REQ_FLUSH
> > -> ELEVATOR_INSERT_FLUSH -> REQ_SOFTBARRIER and subsequent IO
> > scheduler calls to elv_dispatch_sort() that don't pass
> > REQ_SOFTBARRIER in the queue.
> 
> This part is right.
> 
> > IOWs, if we queue a bunch of REQ_WRITE IOs followed by a
> > REQ_WRITE|REQ_FLUSH IO, all of the prior REQ_WRITE IOs will be
> > dispatched before the REQ_WRITE|REQ_FLUSH IO and hence be captured
> > by the cache flush.
> 
> But this part is not.  It is up to the I/O scheduler to decide when to
> dispatch requests.  It can hold on to them for a variety of reasons.
> Flush requests, however, do not go through the I/O scheduler.  At the

That's pure REQ_FLUSH bios, right? Aren't data IOs with
REQ_FLUSH|REQ_FUA sorted like any other IO?

> very moment that the flush request is inserted, it goes directly to the
> dispatch queue (assuming no other flush is in progress).  The prior
> requests may still be waiting in the I/O scheduler's internal lists.
> 
> So, any newly dispatched I/Os will certainly not get past the REQ_FLUSH.
> However, the REQ_FLUSH is very likely to jump ahead of prior I/Os in the
> queue.

Uh, ok, that's different, and most definitely not the "IO barrier" I
was under the impression REQ_FLUSH|REQ_FUA gave us.

> > Hence once the filesystem has waited on the REQ_WRITE|REQ_FLUSH IO
> > to complete, we know that all the earlier REQ_WRITE IOs are on
> > stable storage, too. Hence there's no need for the elevator to drain
> > the queue to guarantee completion ordering - the dispatch ordering
> > and flush/fua write semantics guarantee that when the flush/fua
> > completes, all the IOs dispatch prior to that flush/fua write are
> > also on stable storage...
> 
> Des xfs rely on this model for correctness?  If so, I'd say we've got a
> problem

No, it doesn't. The XFS integrity model doesn't trust the IO layers
to tell the truth about IO ordering and completion or for it's
developers to fully understand how IO layer ordering works. :P

i.e. we wait for full completions of all dependent IO before issuing
flushes or log writes that use REQ_FLUSH|REQ_FUA semantics to ensure
the dependent IOs are fully caught by the cache flushes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
