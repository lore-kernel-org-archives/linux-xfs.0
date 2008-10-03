Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 03 Oct 2008 02:33:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m939XNoT026777
	for <xfs@oss.sgi.com>; Fri, 3 Oct 2008 02:33:24 -0700
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A0F19CB54D
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2008 02:35:00 -0700 (PDT)
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.174]) by cuda.sgi.com with ESMTP id 5vNemmtyhS6fAKam for <xfs@oss.sgi.com>; Fri, 03 Oct 2008 02:35:00 -0700 (PDT)
Received: by wf-out-1314.google.com with SMTP id 26so1539382wfd.32
        for <xfs@oss.sgi.com>; Fri, 03 Oct 2008 02:34:59 -0700 (PDT)
Message-ID: <50ed5c760810030234p3c1c5f4at152bad9062188230@mail.gmail.com>
Date: Fri, 3 Oct 2008 11:34:59 +0200
From: "=?ISO-8859-2?Q?S=B3awomir_Nowakowski?=" <nailman23@gmail.com>
Subject: Re: XFS on 2.6.25.17 kernel issue
In-Reply-To: <20081003083414.GM30001@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Disposition: inline
References: <50ed5c760810022334j69befdb9pa0bf5ec29aad9126@mail.gmail.com>
	 <20081003083414.GM30001@disturbed>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

2008/10/3 Dave Chinner <david@fromorbit.com>:
> On Fri, Oct 03, 2008 at 08:34:52AM +0200, S©©awomir Nowakowski wrote:
>> Dear All,
>>
>> We use kernel 2.6.25.17, Promise STEX 8650 RAID controller, LVM2 and
>> snapshots. After about 3 hours of working (using SAMBA, RSYNC etc)
>> dmesg showed following errors:
>>
>> XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1546 of file
>> fs/xfs/xfs_alloc.c.  Caller 0xc024f387
>> Pid: 16557, comm: smbd Not tainted 2.6.25.17-oe32-00000-g553425c #18
>>  [<c024e15e>] xfs_free_ag_extent+0x2fe/0x670
>>  [<c024f387>] xfs_free_extent+0xc7/0xf0
>>  [<c024f387>] xfs_free_extent+0xc7/0xf0
>
> Freespace btree corruption. Run xfs_repair on tªØe filesystem
> to fix the corruption, upgrade to 2.6.27 when it is released to
> get all the fixes for known corruptions.
>
> FWIW, I see iSCSI and DRBD are in use on your machine. In the past,
> XFS on top of either of these two transports would randomly suffer
> from freespace btree corruptions which were not reproducable on
> normal local block devices. So the cause of your problem may not be
> XFS at all....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

Dear Dave,

We do not use iSCSI and DRBD, only modules are loaded. In our test
scenario it looks like the following:
-RAID unit -> LVM2 -> LV with XFS file system.

On this LV we made writting action using SAMBA and RSYNC.

Can you please help me with another case?

We made a different type of test using 2.6.25.17 kernel.
We created one Logical Volume and 3 snapshots that are connected with
this LV. The 3 snapshots were started and stopped around and we have
run fsstress utility from SGI. After about 10 hours we get the
following errors:

Pid: 15004, comm: fsstress Not tainted (2.6.25.17-oe32-00000-g553425c #18)
EIP: 0060:[<c029e0a7>] EFLAGS: 00010286 CPU: 0
EIP is at xfs_readlink+0x7/0x90
EAX: 00000000 EBX: 00000000 ECX: c0534000 EDX: c7bd7000
ESI: d60bbedc EDI: f689ea94 EBP: fffffff4 ESP: d60bbeb0
DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process fsstress (pid: 15004, ti=d60ba000 task=e5feeb50 task.ti=d60ba000)
Stack: d60bbedc c7bd7000 d60bbedc f689ea94 fffffff4 c02a9a92 c0534000 f689ea94
00001000 bfc02e90 c017def6 f61da8c0 c0188313 00000000 d60bbf40 c017b5f8
f61da8c0 c8e9ba94 00000000 ffffff9c 00000000 c017b8aa f3e8a000 f3e8a000
Call Trace:
[<c02a9a92>] xfs_vn_follow_link+0x32/0x60
[<c017def6>] generic_readlink+0x26/0x70
[<c0188313>] mntput_no_expire+0x13/0x60
[<c017b5f8>] path_walk+0x58/0xc0
[<c017b8aa>] do_path_lookup+0xea/0x1a0
[<c017bd13>] __user_walk_fd+0x33/0x40
[<c0176825>] sys_readlinkat+0x85/0x90
[<c02d2cab>] _atomic_dec_and_lock+0x2b/0x50
[<c0183a4d>] dput+0x1d/0xc0
[<c0174645>] __fput+0xf5/0x170
[<c0188313>] mntput_no_expire+0x13/0x60
[<c0176846>] sys_readlink+0x16/0x20
[<c0103a42>] syscall_call+0x7/0xb
=======================
Code: 8b 82 0c 01 00 00 c6 04 08 00 83 c4 68 89 f0 5b 5e 5f 5d c3 89
d8 e8 e9 7a 00 00 eb c8 8d b4 26 00 00 00 00 55 57 56 53 56 89 c3 <8b>
40 08 c7 04 24 00 00 00 00 89 d5 8b 80 04 02 00 00 31 d2 83
EIP: [<c029e0a7>] xfs_readlink+0x7/0x90 SS:ESP 0068:d60bbeb0

Do you know what can be the reason of this issue?
If you need any other information, please do not hesitate to ask.

Thank you very much for your help

Best Regards
Roland
