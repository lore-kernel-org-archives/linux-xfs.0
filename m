Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 17:32:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q0WWOP009173
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 17:32:33 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AADE148563C
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 17:34:06 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id TyDdTXghZXa29Ipu for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 17:34:06 -0700 (PDT)
Date: Fri, 26 Sep 2008 10:34:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] Use atomic_t and wait_event to track dquot pincount
Message-ID: <20080926003401.GG27997@disturbed>
References: <48D9C1DD.6030607@sgi.com> <48D9EB8F.1070104@sgi.com> <48D9EF6E.8010505@sgi.com> <20080924074604.GK5448@disturbed> <48D9F718.4010905@sgi.com> <20080925010318.GB27997@disturbed> <48DB4F3F.8040307@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DB4F3F.8040307@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Leckie <pleckie@sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev@sgi.com

On Thu, Sep 25, 2008 at 06:43:43PM +1000, Peter Leckie wrote:
>
>> Still, don't check it in until we understand whether sv_t's are
>> completely broken or not...
> Well I added some tracing code to the __wake_up_common, however it never  
> tripped
> which made me think "are we even being woken up from the wait queue", or  
> is someone
> directly waking us up from the task struct. So I had a look and found  
> the following.
>
> xfsaild_wakeup(
>       xfs_mount_t             *mp,
>       xfs_lsn_t               threshold_lsn)
> {
>       mp->m_ail.xa_target = threshold_lsn;
>       wake_up_process(mp->m_ail.xa_task);
> }
>
> Which is indirectly called from xlog_grant_push_ail, which is called  
> from various other
> places.

Ok, so that one will only wake up the xfsaild, which does not flush
pinned items - it will never end up in an unpin wait for any type
of item, so we can rule that one out.

> In fact this bug is not restricted to the aild the xfssyncd also hit  
> this issue a number of times
> during todays testing where it was woken while waiting on sv_wait for  
> the pincount to drop
> to zero.

Ok, so there is the fundamental issue. This one is problematic
because xfssyncd calls into xfs_sync() -> xfs_qm_sync(). It does
so with the flag SYNC_BDFLUSH set, which means:

1013         /*
1014          * We won't block unless we are asked to.
1015          */
1016         nowait = (boolean_t)(flags & SYNC_BDFLUSH || (flags & SYNC_WAIT) == 0);
1017


We should not be blocking when flushing dquots. IOWs, we should not
be waiting on pinned quots in xfs_qm_sync() when it calls
xfs_dqflush(). i.e. it should behave exactly like the inode flush
code.

i.e. the reason why we are seeing this is that xfs_dqflush is not
obeying the non-blocking semantics of the sync that it is being
asked to run. If we enter xfs_sync() from anywhere else, then we
won't have task wakeups occurring to interrupt a pin wait on a
synchronous sync....

> It also is woken up from a number of functions in xfs_super.c including
> xfs_syncd_queue_work(), xfs_sync_worker(), xfs_fs_sync_super()

Yeah, when different work needs doing.

> The change that introduced the wake_up on the aild was introduced from
>
> modid: xfs-linux-melb:xfs-kern:30371a
> Move AIL pushing into it's own thread
>
> However xfssyncd has had a long history of the task being woken up from  
> other code,
> so it looks like it's simply not safe for either the aild or xfssyncd to  
> sleep on a queue assuming that
> no one else will wake the processes up.

Given that both xfsaild and xfssyncd are supposed to be doing
non-blocking flushes, neither of them should ever be waiting on a
pinned item, therefore fixing that problem in xfs_qm_dqflush()
should make this problem go away. It will also substantially
reduce tehnumber of log forces being triggered by dquot writeback
which will have positive impact on performance, too.

> So I would say the fix I proposed is a good solution for this issue.

but it doesn't fix the underlying problem that was causing the
spurious wakeups, which is the fact that xfs_qm_dqflush() is not
obeying non-blocking flush directions. The patch below should fix
that. Can you please test it before you add your patch?

> However there are other functions that use sv_wait and should also be  
> fixed in a similar way so I'll
> look into the other callers and prepare a patch tomorrow.

The log force and write sv_t's are already in loops that would catch
spurious wakeups, so I don't think there's a problem there....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


XFS: don't block in xfs_qm_dqflush() during async writeback

Normally dquots are written back via delayed write mechanisms.  They
are flushed to their backing buffer by xfssyncd, which is then
pushed out by either AIL or xfsbufd flushing. The flush from the
xfssyncd is supposed to be non-blocking, but xfs_qm_dqflush() always
waits for pinned duots, which means that it will block for the
length of time it takes to do a synchronous log force. This causes
unnecessary extra log I/O to be issued whenever we try to flush a
busy dquot.

Avoid the log forces and blocking xfssyncd by making xfs_qm_dqflush()
pay attention to what type of sync it is doing when it sees a pinned
dquot and not waiting when doing non-blocking flushes.
---
 fs/xfs/quota/xfs_dquot.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index d738d37..52c8902 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -1229,8 +1229,13 @@ xfs_qm_dqflush(
 	}
 
 	/*
-	 * Cant flush a pinned dquot. Wait for it.
+	 * Cant flush a pinned dquot. If we are not supposed to block,
+	 * don't wait for it.
 	 */
+	if (!(flags & XFS_QMOPT_SYNC) && dqp->q_pincount > 0) {
+		xfs_dqfunlock(dqp);
+		return (0);
+	}
 	xfs_qm_dqunpin_wait(dqp);
 
 	/*
