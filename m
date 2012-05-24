Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4O01q1T028493 for <xfs@oss.sgi.com>; Wed, 23 May 2012 19:01:52 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	YmvG4z1O3MY0MGC8 for <xfs@oss.sgi.com>;
	Wed, 23 May 2012 17:01:50 -0700 (PDT)
Date: Thu, 24 May 2012 10:01:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH v3 2/2] xfs: fix xfsaild hang due to lost wake ups
Message-ID: <20120524000148.GO25351@dastard>
References: <1337704714-50235-1-git-send-email-bfoster@redhat.com>
	<1337704714-50235-3-git-send-email-bfoster@redhat.com>
	<20120523005830.GL25351@dastard> <4FBCE081.7050003@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FBCE081.7050003@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

[ Brian, can you line wrap your text at 72 columns? ]

On Wed, May 23, 2012 at 09:05:05AM -0400, Brian Foster wrote:
> On 05/22/2012 08:58 PM, Dave Chinner wrote:
> snip
> 
> > 
> > Hi Brian - here's kind of what I was thinking when we were talking
> > on IRC. basically we move all the idling logic into xfsaild() to
> > keep it out of xfsaild_push(), and make sure we only idle on an
> > empty AIL when we haven't raced with a target update.
> > 
> > So, I was thinking that we add a previous target variable to the
> > xfs_ail structure. Then xfsaild would become something like:
> > 
> > 
> > 	while (!kthread_should_stop()) {
> > 
> > 		spin_lock(&ailp->xa_lock);
> > 		__set_current_state(TASK_INTERRUPTIBLE);
> > 
> > 		/* barrier matches the xa_target update in xfs_ail_push() */
> > 		smp_rmb();
> > 		if (!xfs_ail_min(ailp) && ailp->xa_target == ailp->xa_prev_target) {
> 
> Ok... IIUC, two things can happen here: 1.) we either detect an
> xa_target update and continue on or 2.) if an _ail_push() occurs
> any time between now and when we schedule out, it will issue the
> wakeup successfully because we've already set the task state above
> (thus avoiding the race).

Exactly.

> > FWIW, you might be able to do this without the idle wait queue
> > and just use wake_up_process() - 
> > 
> 
> Ok... I'll look into using a wait queue once I have the basics
> working as is and put the whole thing through my reproducer.

Ah, I forgot to remove that line from the email before I sent it. I
originally thought an idle wake queue would be necessary, but then
realised it wasn't and removed it from the code I wrote
above. So, no, and idle wait queue is not necessary....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
