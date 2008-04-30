Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 04:52:42 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3UBqBfD010850
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 04:52:19 -0700
Received: from mail.parisc-linux.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51E2A10E7E67
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 04:52:54 -0700 (PDT)
Received: from mail.parisc-linux.org (palinux.external.hp.com [192.25.206.14]) by cuda.sgi.com with ESMTP id Azv7qD3smOxPbrWU for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 04:52:54 -0700 (PDT)
Date: Wed, 30 Apr 2008 05:52:53 -0600
From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Remove l_flushsema
Message-ID: <20080430115253.GL14976@parisc-linux.org>
References: <20080430090502.GH14976@parisc-linux.org> <20080430104125.GM108924158@sgi.com> <20080430105832.GA20442@infradead.org> <20080430111154.GO108924158@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430111154.GO108924158@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Wed, Apr 30, 2008 at 09:11:54PM +1000, David Chinner wrote:
> On Wed, Apr 30, 2008 at 06:58:32AM -0400, Christoph Hellwig wrote:
> > On Wed, Apr 30, 2008 at 08:41:25PM +1000, David Chinner wrote:
> > > The only thing that I'm concerned about here is that this will
> > > substantially increase the time the l_icloglock is held. This is
> > > a severely contended lock on large cpu count machines and putting
> > > the wakeup inside this lock will increase the hold time.
> > > 
> > > I guess I can address this by adding a new lock for the waitqueue
> > > in a separate patch set.
> > 
> > waitqueues are loked internally and don't need synchronization.  With
> > a little bit of re-arranging the code the wake_up could probably be
> > moved out of the critical section.
> 
> Yeah, I just realised that myself and was about to reply as such....
> 
> I'll move the wakeup outside the lock.

I can't tell whether this race matters ... probably not:

N processes come in and queue up waiting for the flush
xlog_state_do_callback() is called
it unlocks the spinlock
a new task comes in and takes the spinlock
wakeups happen

ie do we care about 'fairness' here, or is it OK for a new task to jump
the queue?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
