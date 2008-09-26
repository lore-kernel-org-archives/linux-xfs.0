Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 18:22:12 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q1MA6l015019
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 18:22:10 -0700
Message-ID: <48DC3BBB.4080807@sgi.com>
Date: Fri, 26 Sep 2008 11:32:43 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH v2] Use atomic_t and wait_event to track dquot pincount
References: <48D9C1DD.6030607@sgi.com> <48D9EB8F.1070104@sgi.com> <48D9EF6E.8010505@sgi.com> <20080924074604.GK5448@disturbed> <48D9F718.4010905@sgi.com> <20080925010318.GB27997@disturbed> <48DB4F3F.8040307@sgi.com> <20080926003401.GG27997@disturbed>
In-Reply-To: <20080926003401.GG27997@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Leckie <pleckie@sgi.com>, xfs@oss.sgi.com, xfs-dev@sgi.com

Dave Chinner wrote:
> On Thu, Sep 25, 2008 at 06:43:43PM +1000, Peter Leckie wrote:
>>> Still, don't check it in until we understand whether sv_t's are
>>> completely broken or not...
>> Well I added some tracing code to the __wake_up_common, however it never  
>> tripped
>> which made me think "are we even being woken up from the wait queue", or  
>> is someone
>> directly waking us up from the task struct. So I had a look and found  
>> the following.
>>
>> xfsaild_wakeup(
>>       xfs_mount_t             *mp,
>>       xfs_lsn_t               threshold_lsn)
>> {
>>       mp->m_ail.xa_target = threshold_lsn;
>>       wake_up_process(mp->m_ail.xa_task);
>> }
>>
>> Which is indirectly called from xlog_grant_push_ail, which is called  
>> from various other
>> places.
> 
> Ok, so that one will only wake up the xfsaild, which does not flush
> pinned items - it will never end up in an unpin wait for any type
> of item, so we can rule that one out.
> 
>> In fact this bug is not restricted to the aild the xfssyncd also hit  
>> this issue a number of times
>> during todays testing where it was woken while waiting on sv_wait for  
>> the pincount to drop
>> to zero.
> 
> Ok, so there is the fundamental issue. This one is problematic
> because xfssyncd calls into xfs_sync() -> xfs_qm_sync(). It does
> so with the flag SYNC_BDFLUSH set, which means:
> 
> 1013         /*
> 1014          * We won't block unless we are asked to.
> 1015          */
> 1016         nowait = (boolean_t)(flags & SYNC_BDFLUSH || (flags & SYNC_WAIT) == 0);
> 1017
> 
> 
> We should not be blocking when flushing dquots. IOWs, we should not
> be waiting on pinned quots in xfs_qm_sync() when it calls
> xfs_dqflush(). i.e. it should behave exactly like the inode flush
> code.
> 
> i.e. the reason why we are seeing this is that xfs_dqflush is not
> obeying the non-blocking semantics of the sync that it is being
> asked to run. If we enter xfs_sync() from anywhere else, then we
> won't have task wakeups occurring to interrupt a pin wait on a
> synchronous sync....
> 
>> It also is woken up from a number of functions in xfs_super.c including
>> xfs_syncd_queue_work(), xfs_sync_worker(), xfs_fs_sync_super()
> 
> Yeah, when different work needs doing.
> 
>> The change that introduced the wake_up on the aild was introduced from
>>
>> modid: xfs-linux-melb:xfs-kern:30371a
>> Move AIL pushing into it's own thread
>>
>> However xfssyncd has had a long history of the task being woken up from  
>> other code,
>> so it looks like it's simply not safe for either the aild or xfssyncd to  
>> sleep on a queue assuming that
>> no one else will wake the processes up.
> 
> Given that both xfsaild and xfssyncd are supposed to be doing
> non-blocking flushes, neither of them should ever be waiting on a
> pinned item, therefore fixing that problem in xfs_qm_dqflush()
> should make this problem go away. It will also substantially
> reduce tehnumber of log forces being triggered by dquot writeback
> which will have positive impact on performance, too.
> 
>> So I would say the fix I proposed is a good solution for this issue.
> 
> but it doesn't fix the underlying problem that was causing the
> spurious wakeups, which is the fact that xfs_qm_dqflush() is not
> obeying non-blocking flush directions.
The underlying problem has nothing to do with xfs_qm_dqflush() - the
spurious wakeups are caused by calls to wake_up_process() that arbitrarily
wake up a process that is in a state where it shouldn't be woken up.  If
we don't fix the spurious wakeups then we could easily re-introduce this
problem again.  If xfs_qm_dqflush() should be non-blocking then that's a
separate change and it sounds like a good change too.

> The patch below should fix
> that. Can you please test it before you add your patch?
> 
>> However there are other functions that use sv_wait and should also be  
>> fixed in a similar way so I'll
>> look into the other callers and prepare a patch tomorrow.
> 
> The log force and write sv_t's are already in loops that would catch
> spurious wakeups, so I don't think there's a problem there....
> 
> Cheers,
> 
> Dave.
