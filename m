Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 05:14:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3UCDkw2012526
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 05:13:49 -0700
Date: Wed, 30 Apr 2008 22:14:14 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Remove l_flushsema
Message-ID: <20080430121414.GQ108924158@sgi.com>
References: <20080430090502.GH14976@parisc-linux.org> <20080430104125.GM108924158@sgi.com> <20080430105832.GA20442@infradead.org> <20080430111154.GO108924158@sgi.com> <20080430115253.GL14976@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430115253.GL14976@parisc-linux.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matthew Wilcox <matthew@wil.cx>
Cc: David Chinner <dgc@sgi.com>, Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Wed, Apr 30, 2008 at 05:52:53AM -0600, Matthew Wilcox wrote:
> On Wed, Apr 30, 2008 at 09:11:54PM +1000, David Chinner wrote:
> > On Wed, Apr 30, 2008 at 06:58:32AM -0400, Christoph Hellwig wrote:
> > > On Wed, Apr 30, 2008 at 08:41:25PM +1000, David Chinner wrote:
> > > > The only thing that I'm concerned about here is that this will
> > > > substantially increase the time the l_icloglock is held. This is
> > > > a severely contended lock on large cpu count machines and putting
> > > > the wakeup inside this lock will increase the hold time.
> > > > 
> > > > I guess I can address this by adding a new lock for the waitqueue
> > > > in a separate patch set.
> > > 
> > > waitqueues are loked internally and don't need synchronization.  With
> > > a little bit of re-arranging the code the wake_up could probably be
> > > moved out of the critical section.
> > 
> > Yeah, I just realised that myself and was about to reply as such....
> > 
> > I'll move the wakeup outside the lock.
> 
> I can't tell whether this race matters ... probably not:
> 
> N processes come in and queue up waiting for the flush
> xlog_state_do_callback() is called
> it unlocks the spinlock
> a new task comes in and takes the spinlock
> wakeups happen
> 
> ie do we care about 'fairness' here, or is it OK for a new task to jump
> the queue?

This has always been a possibility here. However, this deep inside the log code
I don't think it really matters because the waiters have log space
reservations. In overload conditions, fairness is handled when obtaining
a reservation via a ordered ticket queue (see xlog_grant_log_space()).
Thundering herds tend to be thinned to smaller bursts by this queue, too...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
