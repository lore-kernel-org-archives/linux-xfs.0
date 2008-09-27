Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 18:07:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8R17J1G017983
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 18:07:19 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E239848BC71
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 18:08:53 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id 26nxOip86SOLZk5K for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 18:08:53 -0700 (PDT)
Date: Sat, 27 Sep 2008 11:08:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] Use atomic_t and wait_event to track dquot pincount
Message-ID: <20080927010850.GQ27997@disturbed>
References: <48D9C1DD.6030607@sgi.com> <48D9EB8F.1070104@sgi.com> <48D9EF6E.8010505@sgi.com> <20080924074604.GK5448@disturbed> <48D9F718.4010905@sgi.com> <20080925010318.GB27997@disturbed> <48DB4F3F.8040307@sgi.com> <20080926003401.GG27997@disturbed> <48DC3638.3050601@sgi.com> <48DC3A4E.7010602@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DC3A4E.7010602@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Peter Leckie <pleckie@sgi.com>, xfs@oss.sgi.com, xfs-dev@sgi.com

On Fri, Sep 26, 2008 at 11:26:38AM +1000, Lachlan McIlroy wrote:
> Peter Leckie wrote:
>> Dave Chinner wrote:
>>> but it doesn't fix the underlying problem that was causing the
>>> spurious wakeups, which is the fact that xfs_qm_dqflush() is not
>>> obeying non-blocking flush directions. The patch below should fix
>>> that. Can you please test it before you add your patch?
>>>   
>> Yeah I already had this idea I  just have not posted a patch because  
>> Lachlan though
>> it might introduce a deadlock.
> I suggested some changes a while back to make tail pushing non-blocking
> and Dave thought it might cause a deadlock.
>
> http://oss.sgi.com/archives/xfs/2008-07/msg00472.html

That is a different case - the aborting of writeback due to a locked
inode cluster buffer could be problematic for the AIL code
because it already has special code to handle cluster buffer pushing
in the case of DELWRI flushed inodes.

The case I described is what the xfsaild "watchdog timeout" really
catches - before the aild the filesystem would simply lock up, and
one way to trigger that was to have the AIL traversal restart too
many times without making progress. The AIL cursor patch series I
posted fixes the excessive restart problem, but doesn't prevent
problem from occurring if the async push doesn't actually write the
item back in IOP_PUSH(). Effectively we need to tweak the ail
push-wait-push loops in the log grant code to avoid this problem.

FWIW, IOP_TRYLOCK() will return ITEM_PINNED for any object
that is still pinned, and hence the AIL does not call IOP_PUSH()
for such items. Instead it schedules a non-blocking log force
for the end of the traversal to get things moving for the next
push to flush it out. Hence the AIL pushing should never, ever be
trying to push a pinned inode or dquot to disk, and hence the
proposed change will not affect AIL pushing at all....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
