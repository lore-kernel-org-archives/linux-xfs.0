Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 01:42:20 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8P8gHxC012688
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 01:42:18 -0700
Message-ID: <48DB4F3F.8040307@sgi.com>
Date: Thu, 25 Sep 2008 18:43:43 +1000
From: Peter Leckie <pleckie@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] Use atomic_t and wait_event to track dquot pincount
References: <48D9C1DD.6030607@sgi.com> <48D9EB8F.1070104@sgi.com> <48D9EF6E.8010505@sgi.com> <20080924074604.GK5448@disturbed> <48D9F718.4010905@sgi.com> <20080925010318.GB27997@disturbed>
In-Reply-To: <20080925010318.GB27997@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, xfs-dev@sgi.com


> Still, don't check it in until we understand whether sv_t's are
> completely broken or not...
Well I added some tracing code to the __wake_up_common, however it never 
tripped
which made me think "are we even being woken up from the wait queue", or 
is someone
directly waking us up from the task struct. So I had a look and found 
the following.

xfsaild_wakeup(
       xfs_mount_t             *mp,
       xfs_lsn_t               threshold_lsn)
{
       mp->m_ail.xa_target = threshold_lsn;
       wake_up_process(mp->m_ail.xa_task);
}

Which is indirectly called from xlog_grant_push_ail, which is called 
from various other
places.

In fact this bug is not restricted to the aild the xfssyncd also hit 
this issue a number of times
during todays testing where it was woken while waiting on sv_wait for 
the pincount to drop
to zero.

It also is woken up from a number of functions in xfs_super.c including
xfs_syncd_queue_work(), xfs_sync_worker(), xfs_fs_sync_super()



The change that introduced the wake_up on the aild was introduced from

modid: xfs-linux-melb:xfs-kern:30371a
Move AIL pushing into it's own thread


However xfssyncd has had a long history of the task being woken up from 
other code,
so it looks like it's simply not safe for either the aild or xfssyncd to 
sleep on a queue assuming that
no one else will wake the processes up.

So I would say the fix I proposed is a good solution for this issue.

However there are other functions that use sv_wait and should also be 
fixed in a similar way so I'll
look into the other callers and prepare a patch tomorrow.

Thanks,

Pete
