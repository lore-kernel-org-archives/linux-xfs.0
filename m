Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Aug 2006 11:56:31 -0700 (PDT)
Received: from mail.max-t.com (h216-18-124-229.gtcust.grouptelecom.net [216.18.124.229])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7NIu5DW020946
	for <linux-xfs@oss.sgi.com>; Wed, 23 Aug 2006 11:56:06 -0700
Date: Wed, 23 Aug 2006 11:00:43 -0400 (EDT)
From: Stephane Doyon <sdoyon@max-t.com>
In-Reply-To: <20060823044829.GD807872@melbourne.sgi.com>
Message-ID: <Pine.LNX.4.64.0608231056370.3139@madrid.max-t.internal>
References: <Pine.LNX.4.64.0608221318300.3139@madrid.max-t.internal>
 <20060823040218.GC807872@melbourne.sgi.com> <20060823044829.GD807872@melbourne.sgi.com>
MIME-Version: 1.0
Subject: Re: Infinite loop in xfssyncd on full file system
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-xfs@oss.sgi.com, lnx1138@us.ibm.com

On Wed, 23 Aug 2006, David Chinner wrote:

> On Wed, Aug 23, 2006 at 02:02:18PM +1000, David Chinner wrote:
>> On Tue, Aug 22, 2006 at 04:01:10PM -0400, Stephane Doyon wrote:
>>> I'm seeing what appears to be an infinite loop in xfssyncd. It is
>>> triggered when writing to a file system that is full or nearly full. I
>>> have pinpointed the change that introduced this problem: it's
>>>
>>>     "TAKE 947395 - Fixing potential deadlock in space allocation and
>>>     freeing due to ENOSPC"
>>>
>>> git commit d210a28cd851082cec9b282443f8cc0e6fc09830.
>>
>> Thanks for tracking that down - I've been trying to isolate a test case
>> for another report of this looping in xfssyncd.
>>
>> [Luciano - this is the same problem we've been trying to track down.]
>>
>>> I hope you XFS experts see what might be wrong with that bug fix. It's
>>> ironic but for me, this (apparent) infinite loop seems much easier to hit
>>> than the out-of-order locking problem that the commit in question was
>>> supposed to fix. Let me know if I can get you any more info.
>>
>> Now we know what patch introduces the problem, we know where to look.
>> Stay tuned...
>
> I've had a quick look at the above commit. I'm not yet certain that
> everything is correct in terms of the semantics laid down in the
> change or that enough blocks are reserved for btree splits , but I

I actually tried, naively, to bump up SET_ASIDE_BLOCKS from 8 to 32. I 
won't claim to understand half of what's going on but I wondered whether 
that might make the problem noticeably harder to reproduce at least, but 
it had no effect ;-).

> can see a hole in the implementation on multiprocessor machines.
>
> Stephane/Luciano - can you test the following patch (note: compile
> tested only) and see if it fixes the problem?

I just tried it, unfortunately no effect. Stil went into a loop, on the 
second attempt.

Thanks
