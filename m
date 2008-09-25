Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 18:06:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8P16hAl002586
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 18:06:44 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ADC761AEA475
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 18:08:17 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id 12pqJEYotT9rdDkv for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 18:08:17 -0700 (PDT)
Date: Thu, 25 Sep 2008 11:08:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] Use atomic_t and wait_event to track dquot pincount
Message-ID: <20080925010815.GC27997@disturbed>
References: <48D9C1DD.6030607@sgi.com> <48D9EB8F.1070104@sgi.com> <48D9EF6E.8010505@sgi.com> <20080924074604.GK5448@disturbed> <20080924144121.GA349@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924144121.GA349@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Lachlan McIlroy <lachlan@sgi.com>, Peter Leckie <pleckie@sgi.com>, xfs@oss.sgi.com, xfs-dev@sgi.com

On Wed, Sep 24, 2008 at 10:41:21AM -0400, Christoph Hellwig wrote:
> On Wed, Sep 24, 2008 at 05:46:04PM +1000, Dave Chinner wrote:
> > On Wed, Sep 24, 2008 at 05:42:38PM +1000, Lachlan McIlroy wrote:
> > > Looks good Pete.
> > 
> > No, it is not yet good. Pete cannot explain the underlying problem
> > and we need to understand if this is fixing the problem or just
> > changing the timing so it doesn't show up....
> 
> The patch does not only cause timing but also makes sure
> xfs_qm_dqunpin_wait sleeps again when woken up but the condition it was
> waiting on is not met.  That's the reason why we have wait_event in
> Linux instead of the more traditional sv-style conditional variables.
> 
> Now the spurious wakeup from scheduler argument doesn't make any sense,
> so this spurious wakeup we're protecting from must come from XFS itself.
> The way this could happen is when a task trying to pin the dquot gets
> qi_pinlock before the one waiting for q_pincount to reach zero.

Can't happen. To pin the dquot you have to hold the dquot lock. That
dquot lock is held by the one waiting for the q_pincount to reach
zero. i.e. pin and unpin_wait are mutually exclusive.

Also, qi_pinlock is a spinlock, so it should not be triggering
any spurious scheduler events that wake up threads sleeping on some
unrelated wait queue....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
