Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 16 Sep 2008 00:34:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8G7Xs10019995
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2008 00:33:55 -0700
Received: from yx-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BA39E1275EC1
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2008 00:35:21 -0700 (PDT)
Received: from yx-out-1718.google.com (yx-out-1718.google.com [74.125.44.156]) by cuda.sgi.com with ESMTP id pVsV8Qa90tbBozjW for <xfs@oss.sgi.com>; Tue, 16 Sep 2008 00:35:21 -0700 (PDT)
Received: by yx-out-1718.google.com with SMTP id 36so731183yxh.32
        for <xfs@oss.sgi.com>; Tue, 16 Sep 2008 00:35:20 -0700 (PDT)
Message-ID: <a4423d670809160035s25fd5227j831492b3f43daa6a@mail.gmail.com>
Date: Tue, 16 Sep 2008 11:35:20 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: Re: 2.6.27-rc6: lockdep warning: iprune_mutex at shrink_icache_memory+0x38/0x1a8
In-Reply-To: <20080916025204.GL5811@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080913233138.GA19576@orion> <20080916025204.GL5811@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alexander Beregalov <a.beregalov@gmail.com>, rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

2008/9/16 Dave Chinner <david@fromorbit.com>:
> On Sun, Sep 14, 2008 at 03:31:38AM +0400, Alexander Beregalov wrote:
>> Hi
>>
>> [ INFO: possible circular locking dependency detected ]
>> 2.6.27-rc6-00034-gd1c6d2e #3
>> -------------------------------------------------------
>> nfsd/1766 is trying to acquire lock:
>>  (iprune_mutex){--..}, at: [<c01743fb>] shrink_icache_memory+0x38/0x1a8
>>
>>  but task is already holding lock:
>>   (&(&ip->i_iolock)->mr_lock){----}, at: [<c021134f>]
>>   xfs_ilock+0xa2/0xd6
>>
>>
>> I read files through nfs and saw delay for few seconds.
>> System is x86_32, nfs, xfs.
>> The last working kernel is 2.6.27-rc5,
>> I do not know yet is it reproducible or not.
>
> <sigh>
>
> We need a FAQ for this one. It's a false positive.  Google for an
> explanation - I've explained it 4 or 5 times in the past year and
> asked that the lockdep folk invent a special annotation for the
> iprune_mutex (or memory reclaim) because of the way it can cause
> recursion into the filesystem and hence invert lock orders without
> causing deadlocks.....

Hi Dave

Yes, you already explained a similar message to me, but it was a bug,
not false positive.
http://lkml.org/lkml/2008/7/3/29
http://lkml.org/lkml/2008/7/3/315

I will try to bisect.
It is not a OOM case.
