Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 04:40:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6OBeh9k019301
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 04:40:46 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C1CD327E49
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 04:41:52 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id JHl8Us8swYqmDnvh for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 04:41:52 -0700 (PDT)
Date: Thu, 24 Jul 2008 21:41:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Prevent log tail pushing from blocking on buffer locks
Message-ID: <20080724114128.GW6761@disturbed>
References: <48857EFB.3030301@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48857EFB.3030301@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Jul 22, 2008 at 04:32:27PM +1000, Lachlan McIlroy wrote:
> This changes xfs_inode_item_push() to use XFS_IFLUSH_ASYNC_NOBLOCK when
> flushing an inode so the flush wont block on inode cluster buffer lock.
> Also change the prototype of the IOP_PUSH operation so that xfsaild_push()
> can bump it's stuck count.
>
> This change was prompted by a deadlock that would only occur on a debug
> XFS where a thread creating an inode had the buffer locked and was trying
> to allocate space for the inode tracing facility.  That recursed back into
> the filesystem to flush data which created a transaction and needed log
> space which wasn't available.

A quick question - shouldn't the allocation use KM_NOFS if it
being called in place that would cause recursion? Anywhere the
inode tracing is called with a an inode lock held outside a
transaction will also be suseptible to this deadlock.

Also, there is the possibility that aborting writeback from
the AIL in this manner could cause stalls or deadlocks
if this item is at the of the log and it doesn't get written
back straight away and the trigger thread then goes to sleep
waiting for the tail to move. In that case, everything subsequent
transaction will then go to sleep without trying to push the
log and only the watchdog timeout on aild will get things
moving again.

So to fix a deadlock in debug code, I don't think we want to
change the flush semantics of the AIL push on inodes for
production code. Prevent the debug tracing code from recursing,
instead....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
