Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Jul 2008 22:56:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6T5u3lm018303
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2008 22:56:03 -0700
Received: from smtp.sina.com.cn (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 388CFEC5266
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2008 22:57:14 -0700 (PDT)
Received: from smtp.sina.com.cn (smtp.sina.com.cn [202.108.3.233]) by cuda.sgi.com with ESMTP id 5HEGmBewv9uG2NKr for <xfs@oss.sgi.com>; Mon, 28 Jul 2008 22:57:14 -0700 (PDT)
Message-ID: <013c01c8f140$033e61c0$3400a8c0@xgw>
From: "Robert" <xiaguowu2004@sina.com>
References: <010901c8f11f$9a9a68f0$3400a8c0@xgw> <488E84A5.6040409@sandeen.net>
Subject: Re: linux xfs filesystem corruption
Date: Tue, 29 Jul 2008 13:57:24 +0800
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Hi, Eric,
 Thanks for your reply!

>> XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1610 of file
>> fs/xfs/xfs_alloc.c, xfs_force_shutdown(md0,0x8) called from line 4073 of
>> file fs/xfs/xfs_bmap.c
>> Filesystem "md0" corruption of in-memory data detected. Shutting down
>> filesystem.Please umount the filesystem and rectify the problem.
>
> arm has been problematic on several fronts.  The first was with the v2
> directory code...
>
> http://oss.sgi.com/archives/xfs/2008-06/msg00064.html
>
> but that doesn't appear to be what you are hitting.  There have been
> other problems with cache flushing that I don't remember all the details
> of now ...
>

I will try this method to see if there will be effective.

>>      Although the filesystem crashed, the system did not hang. So I cd to
>> this directory,
>> and ls, and find that all the data seems to be lost,  but 'df' reports 
>> that
>> the most of
>> raid has been used, I try to repair it with xfs_repair, and everything is
>> OK.
>>      But now I don't want to fix this problem by xfs_repair, if the 
>> problem
>> happens again,
>
> and what did xfs_repair find?  Do you have a record of it?

I'm sorry that I didn't  capture the outputs, today I try to replay the 
issue again,
and use "xfs_repair" to repair filesytem, but this time it seems that the
filesystem is not repaired successfully, but it still can be used for a 
while.
Here is the output of xfs_repair :

~ # /mnt/xfs_repair -n /dev/md0
        - creating 2 worker thread(s)
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Killed

>> I have to reparit it again, it's too trouble, so if there is any way to
>> solve this prolbem?
>> I want to find out what causes this error happend,
>>    Anybody has experience in this problem?
>>    The following is my system parameter:
>>   linux version: 2.6.12.6
>
> any other patches applied?  Can you try again with a more recent kernel?
>
 I haven't found any patch of this issue.
 Athough  I find some patches related to this problem from the web,
it has already been applied in my linux kernel.   I have no way to try the 
recent
kernel, because our embeded system is based on Marvell development board,
and if I use the recent kernel,  the Marvell's patch of this kernel is 
required.

Robert
