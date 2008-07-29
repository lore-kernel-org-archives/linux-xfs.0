Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Jul 2008 19:45:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6T2jqGj008954
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2008 19:45:52 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D72933ADC0
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2008 19:47:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id xHPOt3YZ6CFsRedq for <xfs@oss.sgi.com>; Mon, 28 Jul 2008 19:47:02 -0700 (PDT)
Message-ID: <488E84A5.6040409@sandeen.net>
Date: Mon, 28 Jul 2008 21:47:01 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: linux xfs filesystem corruption
References: <010901c8f11f$9a9a68f0$3400a8c0@xgw>
In-Reply-To: <010901c8f11f$9a9a68f0$3400a8c0@xgw>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Robert <xiaguowu2004@sina.com>
Cc: xfs@oss.sgi.com

Robert wrote:
> Dear all,
>       I have encoutered linux xfs filesystem corruption, I search this topic 
> on the
> web, but I can't find any useful information to fix my problem.
>       I build a raid5 with 'mdadm' on my own embeded system which is based 
> on
> arm, and format it with 'mkfs.xfs',  mount it to a directory to be set for 
> nfs
> share. On the host side, I mount the raid, and start writing data to this 
> raid,  for
> about 20hours later, I start to delete the data , but the following message 
> shows:
> 
> XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1610 of file
> fs/xfs/xfs_alloc.c, xfs_force_shutdown(md0,0x8) called from line 4073 of 
> file fs/xfs/xfs_bmap.c
> Filesystem "md0" corruption of in-memory data detected. Shutting down
> filesystem.Please umount the filesystem and rectify the problem.

arm has been problematic on several fronts.  The first was with the v2
directory code...

http://oss.sgi.com/archives/xfs/2008-06/msg00064.html

but that doesn't appear to be what you are hitting.  There have been
other problems with cache flushing that I don't remember all the details
of now ...


>      Although the filesystem crashed, the system did not hang. So I cd to 
> this directory,
> and ls, and find that all the data seems to be lost,  but 'df' reports that 
> the most of
> raid has been used, I try to repair it with xfs_repair, and everything is 
> OK.
>      But now I don't want to fix this problem by xfs_repair, if the problem 
> happens again,

and what did xfs_repair find?  Do you have a record of it?

> I have to reparit it again, it's too trouble, so if there is any way to 
> solve this prolbem?
> I want to find out what causes this error happend,
>    Anybody has experience in this problem?
>    The following is my system parameter:
>   linux version: 2.6.12.6

any other patches applied?  Can you try again with a more recent kernel?

-Eric

>   CPU: arm926ej
>   memory: 128M
>   If you answer this question ,Could you please cc to me? I didn't subscribe 
> this mailing list.
>  Thanks in advance!
> 
>  Robert 
> 
> 
> 
