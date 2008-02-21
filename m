Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Feb 2008 23:34:49 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1L7YhPg016076
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2008 23:34:44 -0800
Received: from m12-16.163.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 4CAC9E8012A
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2008 23:34:41 -0800 (PST)
Received: from m12-16.163.com (m12-16.163.com [220.181.12.16]) by cuda.sgi.com with SMTP id TkDfEHoiBfDieQGW for <xfs@oss.sgi.com>; Wed, 20 Feb 2008 23:34:41 -0800 (PST)
Date: Thu, 21 Feb 2008 15:34:31 +0800
From: "lxh" <lxhzju@163.com>
Reply-To: lxhzju@163.com
References: <200801251516352343935@163.com>,
 <20080125080134.GJ155407@sgi.com>
Subject: Re: Re: kernel oops on debian, 2.6.18-5, large xfs volume
Message-ID: <200802211534310625204@163.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs <xfs@oss.sgi.com>

Hello,
   Yesterday, this failure happened again in a file server with a 1.5TB large xfs file system volume running on a RAID6 SATA array. Here is the kernel oops:

     Filesystem "cciss/c0d2": XFS internal error xfs_trans_cancel at line 1138  of file fs/xfs/xfs_trans.c.  Caller 0xffffffff881df006
      Call Trace:
     [<ffffffff881fed18>] :xfs:xfs_trans_cancel+0x5b/0xfe
     [<ffffffff88207006>] :xfs:xfs_create+0x58b/0x5dd
     [<ffffffff8820f496>] :xfs:xfs_vn_mknod+0x1bd/0x3c8

     Then we  umounted it and ran xfs_check. xfs_check suggested that we should replay log first. Namely, it ask us to mount the volume and then umount it. But we found that this volume could not be mounted again. Therefore, we restarted the server, here was the replay: 


	Feb 20 20:31:44 fs-10 kernel: Filesystem "cciss/c0d2": Disabling barriers, not supported by the underlying device
	Feb 20 20:31:44 fs-10 kernel: XFS mounting filesystem cciss/c0d2
	Feb 20 20:31:44 fs-10 kernel: Starting XFS recovery on filesystem: cciss/c0d2 (logdev: internal)
	Feb 20 20:31:44 fs-10 kernel: Ending XFS recovery on filesystem: cciss/c0d2 (logdev: internal)

    Then we mounted this volume successfully.  xfs_check found nothing. The result of xfs_db command was :
	    magicnum = 0x58465342
		blocksize = 4096
		dblocks = 406961280
		rblocks = 0
		rextents = 0
		uuid = 435ae4a0-0143-447a-aadb-7c25f8cace17
		logstart = 268435460
		rootino = 128
		rbmino = 129
		rsumino = 130
		rextsize = 16
		agblocks = 12717540
		agcount = 32
		rbmblocks = 0
		logblocks = 32768
		versionnum = 0x3084
		sectsize = 512
		inodesize = 256
		inopblock = 16
		fname = "fs2\000\000\000\000\000\000\000\000\000"
		blocklog = 12
		sectlog = 9
		inodelog = 8
		inopblog = 4
		agblklog = 24
		rextslog = 0
		inprogress = 0
		imax_pct = 25
		icount = 14902784
		ifree = 531
		fdblocks = 4886264
		frextents = 0
		uquotino = 0
		gquotino = 0
		qflags = 0
		flags = 0
		shared_vn = 0
		inoalignmt = 2
		unit = 0
		width = 0
		dirblklog = 0
		logsectlog = 0
		logsectsize = 0
		logsunit = 0
		features2 = 0


======= 2008-01-25 16:01:54  =======

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
>
>The only vectors I've seen that can cause this are I/O errors
>or ENOSPC during file create after we've already checked that
>this cannot happen. Are there any I/O errors in the log?
>
>This commit:
>
>http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=45c34141126a89da07197d5b89c04c6847f1171a
>
>which is in 2.6.23 fixed the last known cause of the ENOSPC
>issue, so upgrading the kernel or patching this fix back
>to the 2.6.18 kernel may fix the problem if it is related to
>ENOSPC.
>
>>  Every time the error occurs, the volume can not be accessed. So we have to
>>  umount this volume, run xfs_repair, and then remount it. This problem
>>  causes seriously impact of our service.
>
>Anyway, next time it happens, can you please run xfs_check on the
>filesystem first and post the output? If there is no output, then
>the filesystem is fine and you don't need to run repair.
>
>If it is not fine, can also post the output of xfs_repair?
>
>Once the filesystem has been fixed up, can you then post the
>output of this command to tell us the space usage in the filesystems?
>
># xfs_db -r -c 'sb 0' -c p <dev>
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
 
				 
　　　　　　　　Luo xiaohua
　　　　　　　　lxhzju@163.com
　　　　　　　　　　2008-02-21
