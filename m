Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Nov 2008 08:57:55 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA9GvmsQ011653
	for <xfs@oss.sgi.com>; Sun, 9 Nov 2008 08:57:48 -0800
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B6606152754F
	for <xfs@oss.sgi.com>; Sun,  9 Nov 2008 08:57:48 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id Ish3dqH7bVgmigCv for <xfs@oss.sgi.com>; Sun, 09 Nov 2008 08:57:48 -0800 (PST)
Date: Sun, 9 Nov 2008 11:57:48 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: xfs_repair hanging
In-Reply-To: <alpine.DEB.1.10.0811091149390.5181@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0811091157220.5478@p34.internal.lan>
References: <alpine.DEB.1.10.0811091026030.6319@p34.internal.lan> <alpine.DEB.1.10.0811091149390.5181@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com



On Sun, 9 Nov 2008, Justin Piszcz wrote:

>
>
> On Sun, 9 Nov 2008, Justin Piszcz wrote:
>
>> p34:~# xfs_repair -V
>> xfs_repair version 2.9.8
>> 
>> Hangs with xfs_repair as shown below or with -L option.
>> 
>> p34:~# xfs_repair /dev/md3
>> Phase 1 - find and verify superblock...
>> Phase 2 - using internal log
>>        - zero log...
>>        - scan filesystem freespace and inode maps...
>> bad magic # 0x58443242 in btbno block 0/1022
>> expected level 1 got 2672 in btbno block 0/1022
>> bad magic # 0x3f052a50 in btbno block 0/12392
>> bad magic # 0 in btbno block 0/36892
>> bad magic # 0 in btbno block 0/1241755
>> bad magic # 0x2f2a0a20 in btbno block 0/2800
>> bad magic # 0x44726976 in btbno block 0/2672
>> bad magic # 0x30302d49 in btbno block 0/46
>> <hang>
>> 
>> strace of event:
>> write(2, "bad magic # 0 in btbno block 0/36"..., 37bad magic # 0 in btbno 
>> block 0/36892
>> ) = 37
>> pread(4, 
>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
>> 4096, 5086228480) = 4096
>> write(2, "bad magic # 0 in btbno block 0/12"..., 39bad magic # 0 in btbno 
>> block 0/1241755
>> ) = 39
>> pread(4, "/*\n * arch/arm/mach-loki/include/"..., 4096, 11468800) = 4096
>> write(2, "bad magic # 0x2f2a0a20 in btbno b"..., 45bad magic # 0x2f2a0a20 
>> in btbno block 0/2800
>> ) = 45
>> pread(4, "Driver\n------\n\nInformations about"..., 4096, 10944512) = 4096
>> write(2, "bad magic # 0x44726976 in btbno b"..., 45bad magic # 0x44726976 
>> in btbno block 0/2672
>> ) = 45
>> pread(4, "00-INDEX\n\t- this file (info on so"..., 4096, 188416) = 4096
>> write(2, "bad magic # 0x30302d49 in btbno b"..., 43bad magic # 0x30302d49 
>> in btbno block 0/46
>> ) = 43
>> futex(0x185d098, FUTEX_WAIT_PRIVATE, 2, NULL
>> 
>> I can mount the filesystem but its a bit mangled:
>> 
>> p34:~# cd /r1
>> p34:/r1# ls
>> ls: cannot access x3: Structure needs cleaning
>> ls: cannot access x4: Structure needs cleaning
>> ls: cannot access x5: Structure needs cleaning
>> 
>> Should I re-format or is there any possibility to fix the FS?  This was due 
>> to some disks going in/out of a RAID5, not XFS' fault but xfs_repair 
>> failing to repair seems strange.
>> 
>> Justin.
>> 
>> 
>
> [  215.558117] Filesystem "md3": Disabling barriers, trial barrier write 
> failed
> [  215.558231] XFS mounting filesystem md3
> [  215.645960] Ending clean XFS mount for filesystem: md3
> [  218.449389] 00000000: ac b3 63 97 3c 65 20 d1 8a 7c dd a7 93 9c f1 9e 
> ..c.<e
> ..|......
> [  218.449399] Filesystem "md3": XFS internal error xfs_da_do_buf(2) at line 
> 210
> 7 of file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff80397924
> [  218.449404] Pid: 5107, comm: find Not tainted 2.6.27.5 #1
> [  218.449406] [  218.449407] Call Trace:
> [  218.449414]  [<ffffffff80397924>] xfs_da_read_buf+0x24/0x30
> [  218.449417]  [<ffffffff80397879>] xfs_da_do_buf+0x6f9/0x730
> [  218.449421]  [<ffffffff80397924>] xfs_da_read_buf+0x24/0x30
> [  218.449425]  [<ffffffff803edfa0>] _atomic_dec_and_lock+0x20/0x90
> [  218.449429]  [<ffffffff80397924>] xfs_da_read_buf+0x24/0x30
> [  218.449433]  [<ffffffff8039c083>] xfs_dir2_block_getdents+0xa3/0x210
> [  218.449436]  [<ffffffff8039c083>] xfs_dir2_block_getdents+0xa3/0x210
> [  218.449441]  [<ffffffff80299ee2>] __dentry_open+0xc2/0x280
> [  218.449444]  [<ffffffff803d1fe0>] xfs_hack_filldir+0x0/0x60
> [  218.449448]  [<ffffffff803d1fe0>] xfs_hack_filldir+0x0/0x60
> [  218.449451]  [<ffffffff8039aa18>] xfs_readdir+0x98/0xf0
> [  218.449454]  [<ffffffff803d1f12>] xfs_file_readdir+0xe2/0x1b0
> [  218.449457]  [<ffffffff802a99e0>] filldir+0x0/0xe0
> [  218.449460]  [<ffffffff802a99e0>] filldir+0x0/0xe0
> [  218.449462]  [<ffffffff802a9c60>] vfs_readdir+0xc0/0xe0
> [  218.449465]  [<ffffffff802a9de4>] sys_getdents+0x84/0xe0
> [  218.449468]  [<ffffffff8029a97a>] sys_fchdir+0x4a/0x90
> [  218.449472]  [<ffffffff80226d2b>] system_call_fastpath+0x16/0x1b
> [  218.449474] [  239.765314] Filesystem "md3": Disabling barriers, trial 
> barrier write failed
> [  239.765538] XFS mounting filesystem md3
> [  239.957389] Ending clean XFS mount for filesystem: md3
>
> Looks like its stuck on a few bad files?  Is there anyway to use xfs_* to
> delete the files its having problems on or should I just wipe it?
>
> Justin.
>
>

Nevermind, I am re-formatting now, need to get the array back online.

Justin.
