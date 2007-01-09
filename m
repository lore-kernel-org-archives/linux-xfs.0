Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 19:13:39 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l093DYqw030656
	for <xfs@oss.sgi.com>; Mon, 8 Jan 2007 19:13:35 -0800
Message-ID: <45A30828.6000508@sandeen.net>
Date: Mon, 08 Jan 2007 21:12:40 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: bd_mount_mutex -> bd_mount_sem (was Re: xfs_file_ioctl / xfs_freeze:
 BUG: warning at kernel/mutex-debug.c:80/debug_mutex_unlock())
References: <20070104001420.GA32440@m.safari.iki.fi>	<20070107213734.GS44411608@melbourne.sgi.com>	<20070108110323.GA3803@m.safari.iki.fi>	<45A27416.8030600@sandeen.net>	<20070108234728.GC33919298@melbourne.sgi.com> <20070108161917.73a4c2c6.akpm@osdl.org>
In-Reply-To: <20070108161917.73a4c2c6.akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@osdl.org>
Cc: David Chinner <dgc@sgi.com>, linux-kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Andrew Morton wrote:
> On Tue, 9 Jan 2007 10:47:28 +1100
> David Chinner <dgc@sgi.com> wrote:
> 
>> On Mon, Jan 08, 2007 at 10:40:54AM -0600, Eric Sandeen wrote:
>>> Sami Farin wrote:
>>>> On Mon, Jan 08, 2007 at 08:37:34 +1100, David Chinner wrote:
>>>> ...
>>>>>> fstab was there just fine after -u.
>>>>> Oh, that still hasn't been fixed?
>>>> Looked like it =)
>>> Hm, it was proposed upstream a while ago:
>>>
>>> http://lkml.org/lkml/2006/9/27/137
>>>
>>> I guess it got lost?
>> Seems like it. Andrew, did this ever get queued for merge?
> 
> Seems not.  I think people were hoping that various nasties in there
> would go away.  We return to userspace with a kernel lock held??

Is a semaphore any worse than the current mutex in this respect?  At 
least unlocking from another thread doesn't violate semaphore rules.  :)

-Eric
