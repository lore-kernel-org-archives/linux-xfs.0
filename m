Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 08:41:57 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l08Gfnqw019671
	for <xfs@oss.sgi.com>; Mon, 8 Jan 2007 08:41:50 -0800
Message-ID: <45A27416.8030600@sandeen.net>
Date: Mon, 08 Jan 2007 10:40:54 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_file_ioctl / xfs_freeze: BUG: warning at kernel/mutex-debug.c:80/debug_mutex_unlock()
References: <20070104001420.GA32440@m.safari.iki.fi> <20070107213734.GS44411608@melbourne.sgi.com> <20070108110323.GA3803@m.safari.iki.fi>
In-Reply-To: <20070108110323.GA3803@m.safari.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Sami Farin wrote:
> On Mon, Jan 08, 2007 at 08:37:34 +1100, David Chinner wrote:
> ...
>>> fstab was there just fine after -u.
>> Oh, that still hasn't been fixed?
> 
> Looked like it =)

Hm, it was proposed upstream a while ago:

http://lkml.org/lkml/2006/9/27/137

I guess it got lost?

-Eric

>> Generic bug, not XFS - the global
>> semaphore->mutex cleanup converted the bd_mount_sem to a mutex, and
>> mutexes complain loudly when a the process unlocking the mutex is
>> not the process that locked it.
>>
>> Basically, the generic code is broken - the bd_mount_mutex needs to
>> be reverted back to a semaphore because it is locked and unlocked
>> by different processes. The following patch does this....
>>
>> BTW, Sami, can you cc xfs@oss.sgi.com on XFS bug reports in future;
>> you'll get more XFS savvy eyes there.....
> 
> Forgot to.
> 
> Thanks for patch.  It fixed the issue, no more warnings.
> 
> BTW. the fix is not in 2.6.git, either.
> 
