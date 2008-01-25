Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 25 Jan 2008 01:41:15 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0P9f5AZ018512
	for <xfs@oss.sgi.com>; Fri, 25 Jan 2008 01:41:10 -0800
Received: from m12-13.163.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 49058361BEC
	for <xfs@oss.sgi.com>; Fri, 25 Jan 2008 01:41:23 -0800 (PST)
Received: from m12-13.163.com (m12-13.163.com [220.181.12.13]) by cuda.sgi.com with SMTP id bRhKA6H8QcP5jxPP for <xfs@oss.sgi.com>; Fri, 25 Jan 2008 01:41:23 -0800 (PST)
Date: Fri, 25 Jan 2008 17:41:05 +0800
From: "lxh" <lxhzju@163.com>
Reply-To: lxhzju@163.com
Subject: Re: Re: kernel oops on debian, 2.6.18-5, large xfs volume
Message-ID: <200801251741035934497@163.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs <xfs@oss.sgi.com>

Hi,
 	
======= 2008-01-25 16:01:54 =======

>On Fri, Jan 25, 2008 at 03:16:36PM +0800, lxh wrote:
>> Hello, 
>>    we have dozens of file servers with a 1.5TB/2.5 TB large xfs file system
>>    volume running on a RAID6 SATA array.  Each volume contains about
>>    10,000,000 files. The Operating system is debian GNU/Linux 2.6.18-5-amd64
>>    #1 SMP. we got a kernel oops frequently last year.
>> 
>> here is the oops :
>>  Filesystem "cciss/c0d1": XFS internal error xfs_trans_cancel at line 1138
>>  of file fs/xfs/xfs_trans.c.  Caller 0xffffffff881df006
>>  Call Trace:
>>  [<ffffffff881fed18>] :xfs:xfs_trans_cancel+0x5b/0xfe
>>  [<ffffffff88207006>] :xfs:xfs_create+0x58b/0x5dd
>>  [<ffffffff8820f496>] :xfs:xfs_vn_mknod+0x1bd/0x3c8
>
>Are you running out of space in the filesystem?
    we did not run out of space. there is enough space for writing.
>
>The only vectors I've seen that can cause this are I/O errors
>or ENOSPC during file create after we've already checked that
>this cannot happen. Are there any I/O errors in the log?
>
After we run xfs_repair, it outputs nothing special. 
I guess this problem be related with big volume and a mass of small files. Some servers are equipped with same hardware and software, but they are configured with 1TB volume and stored big files. This problem never happen on them.

>This commit:
>
>http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=45c34141126a89da07197d5b89c04c6847f1171a
>
>which is in 2.6.23 fixed the last known cause of the ENOSPC
>issue, so upgrading the kernel or patching this fix back
>to the 2.6.18 kernel may fix the problem if it is related to
>ENOSPC.
Thank you very much for your help! I will try this patch on some machines.

>
>>  Every time the error occurs, the volume can not be accessed. So we have to
>>  umount this volume, run xfs_repair, and then remount it. This problem
>>  causes seriously impact of our service.
>
>Anyway, next time it happens, can you please run xfs_check on the
>filesystem first and post the output? If there is no output, then
>the filesystem is fine and you don't need to run repair.

The volume is unusable when it happens. So we run xfs_repair. The xfs_repair operation output nothing special. But after xfs_repair, we can access the volume again. I don't konw why.
>
>If it is not fine, can also post the output of xfs_repair?
>
>Once the filesystem has been fixed up, can you then post the
>output of this command to tell us the space usage in the filesystems?
>
># xfs_db -r -c 'sb 0' -c p <dev>
I will comply with the your suggestions when it happens again, and then contact you.

>
>Cheers,
>
>Dave.
>-- 
>Dave Chinner
>Principal Engineer
>SGI Australian Software Group

= = = = = = = = = = = = = = = = = = = =
Cheers,			
Luoxiaohua
NetEase.com Inc				 
　　　　　　　　
　　　　　　　　lxhzju@163.com
　　　　　　　　　　2008-01-25
