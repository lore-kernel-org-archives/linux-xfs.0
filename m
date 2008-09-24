Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Sep 2008 23:05:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O63h1Z015792
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 23:03:43 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2171475A49
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 23:05:16 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id v55ITIlKgSwON5BH for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 23:05:16 -0700 (PDT)
Date: Wed, 24 Sep 2008 16:05:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Use atomic_t and wait_event to track dquot pincount
Message-ID: <20080924060508.GH5448@disturbed>
References: <48D9C1DD.6030607@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D9C1DD.6030607@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Leckie <pleckie@sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev@sgi.com

[ Pete, please wrap your text at 68-72 columns]

On Wed, Sep 24, 2008 at 02:28:13PM +1000, Peter Leckie wrote:
> The reason the lsn had changed was due to it not being initialized
> by  the time a copy of the lsn was taken in xfs_qm_dqflush().
> The lsn was then latter updated causing the test  in
> xfs_qm_dqflush_done() to fail.
>
> Synchronizations between the 2 functions is done by the pincount
> in  struct xfs_dquot_t  and xfs_qm_dqflush() calls
> xfs_qm_dqunpin_wait() to wait for the pincount == 0. However after
> been woken up it does not validate the pincount is actually 0,

Sure - that's because we only ever send a wakeup when the pin count
falls to zero. Because we have to be holding the dquot lock when we
either pin a dquot or wait for it to be unpinned, the act of waiting
for it to be unpinned with the dquot lock held guarantees that it
is not pinned when we wake up.

IOWs, the pin count cannot be incremented while we are waiting for
it to be unpinned, and hence it must be zero when we are woken......

> allowing a false wake up by the scheduler to  cause
> xfs_qm_dqflush() to prematurely start processing the dquot.

.... which means I can't see how that would happen...

What am I missing here?

> So this patch uses an atomic_t to track the pincount which allows
> us to easily use the wait_event macro to wait, this will guarantee
> that when we return from xfs_qm_dqunpin_wait() that the pincount
> == 0.  We also remove the global  qi_pinlock from xfs_quotainfo
> which may also reduce contention when pinning dquot's.

I have an patch series that I've been running under test for the
past two months that does exactly this - it's an optimisation,
not a bug fix. I was actually planning on posting it this afternoon.

As to the patch, your mailer has whitespace damaged it so you need
to be fix that up.

> Index: 2.6.x-xfs/fs/xfs/quota/xfs_dquot_item.c
> ===================================================================
> --- 2.6.x-xfs.orig/fs/xfs/quota/xfs_dquot_item.c    2008-09-24  
> 12:02:41.987960702 +1000
> +++ 2.6.x-xfs/fs/xfs/quota/xfs_dquot_item.c    2008-09-24  
> 14:22:01.643627312 +1000
> @@ -98,9 +98,7 @@ xfs_qm_dquot_logitem_pin(
>
>     dqp = logitem->qli_dquot;
>     ASSERT(XFS_DQ_IS_LOCKED(dqp));
> -    spin_lock(&(XFS_DQ_TO_QINF(dqp)->qi_pinlock));
> -    dqp->q_pincount++;
> -    spin_unlock(&(XFS_DQ_TO_QINF(dqp)->qi_pinlock));
> +    atomic_inc(&dqp->q_pincount);
> }

The header comment on this function needs updating - it references
the spinlock that just got removed. You can also do

	xfs_dquot_t	*dqp = logitem->qli_dquot;

> @@ -117,13 +115,9 @@ xfs_qm_dquot_logitem_unpin(
>     xfs_dquot_t *dqp;
>
>     dqp = logitem->qli_dquot;
> -    ASSERT(dqp->q_pincount > 0);
> -    spin_lock(&(XFS_DQ_TO_QINF(dqp)->qi_pinlock));
> -    dqp->q_pincount--;
> -    if (dqp->q_pincount == 0) {
> -        sv_broadcast(&dqp->q_pinwait);
> -    }
> -    spin_unlock(&(XFS_DQ_TO_QINF(dqp)->qi_pinlock));
> +    ASSERT(atomic_read(&dqp->q_pincount) > 0);
> +    if (atomic_dec_and_test(&dqp->q_pincount))
> +        wake_up(&dqp->q_pinwait);
> }

The header comment for this function references functions that
don't exist. Needs updating. same again about logitem->qli_dquot...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
