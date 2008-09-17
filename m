Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 17 Sep 2008 11:32:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8HIVwfG029350
	for <xfs@oss.sgi.com>; Wed, 17 Sep 2008 11:32:00 -0700
Received: from an-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50E0444F314
	for <xfs@oss.sgi.com>; Wed, 17 Sep 2008 11:33:28 -0700 (PDT)
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.249]) by cuda.sgi.com with ESMTP id zgT6lKQnzBqqjtAw for <xfs@oss.sgi.com>; Wed, 17 Sep 2008 11:33:28 -0700 (PDT)
Received: by an-out-0708.google.com with SMTP id d30so348459and.75
        for <xfs@oss.sgi.com>; Wed, 17 Sep 2008 11:33:28 -0700 (PDT)
Message-ID: <a4423d670809171133r39260814y211ba8104698d5f2@mail.gmail.com>
Date: Wed, 17 Sep 2008 22:33:28 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: Re: 2.6.27-rc6: lockdep warning: iprune_mutex at shrink_icache_memory+0x38/0x1a8
In-Reply-To: <a4423d670809160035s25fd5227j831492b3f43daa6a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080913233138.GA19576@orion> <20080916025204.GL5811@disturbed>
	 <a4423d670809160035s25fd5227j831492b3f43daa6a@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alexander Beregalov <a.beregalov@gmail.com>, rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

2008/9/16 Alexander Beregalov <a.beregalov@gmail.com>:
> 2008/9/16 Dave Chinner <david@fromorbit.com>:
>> On Sun, Sep 14, 2008 at 03:31:38AM +0400, Alexander Beregalov wrote:
>>> Hi
>>>
>>> [ INFO: possible circular locking dependency detected ]
>>> 2.6.27-rc6-00034-gd1c6d2e #3
>>> -------------------------------------------------------
>>> nfsd/1766 is trying to acquire lock:
>>>  (iprune_mutex){--..}, at: [<c01743fb>] shrink_icache_memory+0x38/0x1a8
>>>
>>>  but task is already holding lock:
>>>   (&(&ip->i_iolock)->mr_lock){----}, at: [<c021134f>]
>>>   xfs_ilock+0xa2/0xd6
>>>
>>>
>>> I read files through nfs and saw delay for few seconds.
>>> System is x86_32, nfs, xfs.
>>> The last working kernel is 2.6.27-rc5,
>>> I do not know yet is it reproducible or not.
>>
>> <sigh>
>>
>> We need a FAQ for this one. It's a false positive.  Google for an
>> explanation - I've explained it 4 or 5 times in the past year and
>> asked that the lockdep folk invent a special annotation for the
>> iprune_mutex (or memory reclaim) because of the way it can cause
>> recursion into the filesystem and hence invert lock orders without
>> causing deadlocks.....
>
> Hi Dave
>
> Yes, you already explained a similar message to me, but it was a bug,
> not false positive.
> http://lkml.org/lkml/2008/7/3/29
> http://lkml.org/lkml/2008/7/3/315
>
> I will try to bisect.
> It is not a OOM case.
>
I can not reproduce it.
