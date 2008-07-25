Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 18:25:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6P1Pevi024652
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 18:25:41 -0700
Message-ID: <48892D26.8060407@sgi.com>
Date: Fri, 25 Jul 2008 11:32:22 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Prevent log tail pushing from blocking on buffer locks
References: <48857EFB.3030301@sgi.com> <20080724114128.GW6761@disturbed>
In-Reply-To: <20080724114128.GW6761@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Tue, Jul 22, 2008 at 04:32:27PM +1000, Lachlan McIlroy wrote:
>> This changes xfs_inode_item_push() to use XFS_IFLUSH_ASYNC_NOBLOCK when
>> flushing an inode so the flush wont block on inode cluster buffer lock.
>> Also change the prototype of the IOP_PUSH operation so that xfsaild_push()
>> can bump it's stuck count.
>>
>> This change was prompted by a deadlock that would only occur on a debug
>> XFS where a thread creating an inode had the buffer locked and was trying
>> to allocate space for the inode tracing facility.  That recursed back into
>> the filesystem to flush data which created a transaction and needed log
>> space which wasn't available.
> 
> A quick question - shouldn't the allocation use KM_NOFS if it
> being called in place that would cause recursion? Anywhere the
> inode tracing is called with a an inode lock held outside a
> transaction will also be suseptible to this deadlock.
> 
> Also, there is the possibility that aborting writeback from
> the AIL in this manner could cause stalls or deadlocks
> if this item is at the of the log and it doesn't get written
> back straight away and the trigger thread then goes to sleep
> waiting for the tail to move. In that case, everything subsequent
> transaction will then go to sleep without trying to push the
> log and only the watchdog timeout on aild will get things
> moving again.
> 
> So to fix a deadlock in debug code, I don't think we want to
> change the flush semantics of the AIL push on inodes for
> production code. Prevent the debug tracing code from recursing,
> instead....

I have a patch for using KM_NOFS in the debug code too and will
post it soon.  It just looked like the IOP_PUSH could be improved
so that it didn't block on the buffer.  Since we can already abort
the push if IOP_TRYLOCK fails I didn't think I'd be introducing any
new failure scenarios.
