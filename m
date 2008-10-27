Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 00:35:32 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9R7ZTRn026186
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 00:35:30 -0700
Message-ID: <49056ED7.7030303@sgi.com>
Date: Mon, 27 Oct 2008 18:33:43 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: deadlock with latest xfs
References: <4900412A.2050802@sgi.com> <20081023205727.GA28490@infradead.org> <49013C47.4090601@sgi.com> <20081026223940.GN18495@disturbed>
In-Reply-To: <20081026223940.GN18495@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Fri, Oct 24, 2008 at 01:08:55PM +1000, Lachlan McIlroy wrote:
>> Christoph Hellwig wrote:
>>> On Thu, Oct 23, 2008 at 07:17:30PM +1000, Lachlan McIlroy wrote:
>>>> another problem with latest xfs
>>> Is this with the 2.6.27-based ptools/cvs tree or with the 2.6.28 based
>>> git tree?  It does looks more like a VM issue than a XFS issue to me.
>>>
>> It's with the 2.6.27-rc8 based ptools tree.  Prior to checking
>> in these patches:
>>
>> Can't lock inodes in radix tree preload region
>> stop using xfs_itobp in xfs_bulkstat
>> free partially initialized inodes using destroy_inode
>>
>> I was able to stress a system for about 4 hours before it ran out
>> of memory.  Now I hit the deadlock within a few minutes.  I need
>> to roll back to find which patch changed the behaviour.
> 
> Ok, I think I've found the regression - it's introduced by the AIL
> cursor modifications. The patch below has been running for 15
> minutes now on my UML box that would have hung in a couple of
> minutes otherwise.
Yep, looks good here too.  My test system has been up at least an hour
and still chugging.

> 
> FYI, the way I found this was:
> 
> 	- put a breakpoint on xfs_create() once the fs hung
> 	- `touch /mnt/xfs2/fred` to trigger the break point.
> 	- look at:
> 		- mp->m_ail->xa_target
> 		- mp->m_ail->xa_ail.next->li_lsn
> 		- mp->m_log->l_tail_lsn
> 	  which indicated the push target was way ahead the
> 	  tail of the log, so AIL pushing was obviously not
> 	  happening otherwise we'd be making progress.
> 	- added breakpoint on xfsaild_push() and continued
> 	- xfsaild_push() bp triggered, looked at *last_lsn
> 	  and found it way behind the tail of the log (like
> 	  3 cycle behind), which meant that would return
> 	  NULL instead of the first object and AIL pushing
> 	  would abort. Confirmed with single stepping.
> 
> Cheers,
> 
> Dave.
