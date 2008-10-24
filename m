Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Oct 2008 00:47:26 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9O7lI1Q023364
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2008 00:47:18 -0700
Message-ID: <49018B66.9050608@sgi.com>
Date: Fri, 24 Oct 2008 18:46:30 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: deadlock with latest xfs
References: <4900412A.2050802@sgi.com> <20081023205727.GA28490@infradead.org> <49013C47.4090601@sgi.com> <20081024052418.GO25906@disturbed>
In-Reply-To: <20081024052418.GO25906@disturbed>
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
> Does it go away when you add the "XFS: Fix race when looking up
> reclaimable inodes" I sent this morning?
I haven't had a chance to test it yet - will do that on Monday.

> 
> Also, is there a thread stuck in xfs_setfilesize() waiting on an
> ilock during I/O completion?
Haven't seen one but then I haven't looked through all 1024 stuck
threads.

> 
> i.e. did the log hang because I/O completion is stuck waiting on
> an ilock that is held by a thread waiting on I/O completion?
It could be.  I was hoping that if I found the offending mod it
would be easier to find out what caused the problem.  I pulled
out each of the changes listed above in turn and I can still hit
the problem.
