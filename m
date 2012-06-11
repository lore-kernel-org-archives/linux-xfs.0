Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5BKgX84134129 for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 15:42:33 -0500
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id xDE1XatSAEOgPM0k (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 11 Jun 2012 13:42:32 -0700 (PDT)
Received: from telerig.nabble.com ([192.168.236.162])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1SeBRX-0002V7-NX
	for xfs@oss.sgi.com; Mon, 11 Jun 2012 13:42:31 -0700
Message-ID: <33996217.post@talk.nabble.com>
Date: Mon, 11 Jun 2012 13:42:31 -0700 (PDT)
From: Chris J Arges <chris.j.arges@canonical.com>
Subject: Re: Still seeing hangs in xlog_grant_log_space
In-Reply-To: <4FCF9655.3070300@sgi.com>
MIME-Version: 1.0
References: <CADLDEKsP4DsXf_G07ub+a-ODbrJbsiprRJUX1fJdaQ41TB7+Xg@mail.gmail.com>
	<CAH4wwdGWHSZoveLJMxu5pjr22NEEeW7oG8TS+snoM8RY=ZeRmg@mail.gmail.com>
	<CADLDEKsGtsw-rrSOE7gY4T81u+p41b34ixv0B7Dh07afJ73n2w@mail.gmail.com>
	<CAH4wwdFu7DEkHFZ5Bf7_PtLPsG0hUyUDoov03q=82R6t+QkERg@mail.gmail.com>
	<20120605235447.GF22848@dastard> <4FCF5DB9.2000808@redhat.com>
	<4FCF9655.3070300@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com




Mark Tinguely-3 wrote:
> 
> The perl script to recreate this problem is very similar to xfstest 273.
> I use that because it avoids all the filesystem mount/unmount that
> happen between the test 273 loops. You can build the log size that you
> want to test, create the directories and let it run until it hangs.
> 

I tested xfstest 273, and it looks like it exhibits a different issue than
the OP in this thread.
For example, if I run this test in a while [1] loop, I get the following
backtrace:

[16413.073946] XFS (sda5): Invalid block length (0xfffff48b) for buffer
[16413.073963] BUG: unable to handle kernel NULL pointer dereference at
0000000000000130
[16413.074274] IP: [<ffffffffa02bb870>] uuid_is_nil+0x10/0x50 [xfs]
[16413.074602] PGD 156f3b067 PUD 10bebb067 PMD 0 
[16413.074942] Oops: 0000 [#1] SMP 
[16413.075379] CPU 0 
[16413.075385] Modules linked in: xfs ppdev serio_raw snd_hda_codec_realtek
nouveau ttm drm_kms_helper drm i2c_algo_bit mxm_wmi wmi snd_hda_intel video
snd_hda_codec parport_pc snd_hwdep snd_pcm snd_timer snd soundcore
snd_page_alloc mac_hid lp parport usbhid floppy hid r8169 pata_jmicron
[16413.076830] 
[16413.077334] Pid: 22295, comm: mount Not tainted 3.2.0-23-generic
#36-Ubuntu Gigabyte Technology Co., Ltd. EP45-DS3L/EP45-DS3L
[16413.077881] RIP: 0010:[<ffffffffa02bb870>]  [<ffffffffa02bb870>]
uuid_is_nil+0x10/0x50 [xfs]
[16413.077924] RSP: 0018:ffff88010c96bab8  EFLAGS: 00010206
[16413.077924] RAX: 0000000000000000 RBX: ffff88010e734800 RCX:
0000000000000000
[16413.077924] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
0000000000000130
[16413.077924] RBP: ffff88010c96bab8 R08: 0000000000000000 R09:
00000000000422a2
[16413.077924] R10: 0000000000000002 R11: 0000000000000000 R12:
0000000000000130
[16413.077924] R13: 0000000000000000 R14: ffff880113f23900 R15:
ffff88010e758200
[16413.077924] FS:  00007f698c270800(0000) GS:ffff88015fc00000(0000)
knlGS:0000000000000000
[16413.077924] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[16413.077924] CR2: 0000000000000130 CR3: 0000000156ee9000 CR4:
00000000000006f0
[16413.077924] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[16413.077924] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[16413.077924] Process mount (pid: 22295, threadinfo ffff88010c96a000, task
ffff88015686dbc0)
[16413.077924] Stack:
[16413.077924]  ffff88010c96bad8 ffffffffa02ee027 fffffffffffff48a
0000000000000001
[16413.077924]  ffff88010c96bb48 ffffffffa02eec7f ffff88010e758200
0000000000000000
[16413.077924]  000000000c96bb70 ffff88010c96bb80 ffff88010c96bb48
0000000000000000
[16413.077924] Call Trace:
[16413.077924]  [<ffffffffa02ee027>] xlog_header_check_mount+0x27/0xb0 [xfs]
[16413.077924]  [<ffffffffa02eec7f>] xlog_find_verify_log_record+0x10f/0x200
[xfs]
[16413.077924]  [<ffffffffa02f0d44>] xlog_find_head+0x2f4/0x360 [xfs]
[16413.077924]  [<ffffffffa02f0de8>] xlog_find_tail+0x38/0x400 [xfs]
[16413.077924]  [<ffffffffa02f2a5e>] xlog_recover+0x1e/0x90 [xfs]
[16413.077924]  [<ffffffffa02fad79>] xfs_log_mount+0xa9/0x180 [xfs]
[16413.077924]  [<ffffffffa02f56d2>] xfs_mountfs+0x362/0x690 [xfs]
[16413.077924]  [<ffffffffa02b32d2>] ? xfs_mru_cache_create+0x162/0x190
[xfs]
[16413.077924]  [<ffffffffa02a96e0>] ? _xfs_filestream_pick_ag+0x1e0/0x1e0
[xfs]
[16413.077924]  [<ffffffffa02b54ee>] xfs_fs_fill_super+0x1de/0x290 [xfs]
[16413.077924]  [<ffffffff8117aa46>] mount_bdev+0x1c6/0x210
[16413.077924]  [<ffffffffa02b5310>] ? xfs_parseargs+0xbc0/0xbc0 [xfs]
[16413.077924]  [<ffffffffa02b3615>] xfs_fs_mount+0x15/0x20 [xfs]
[16413.077924]  [<ffffffff8117b5d3>] mount_fs+0x43/0x1b0
[16413.077924]  [<ffffffff81195e1a>] vfs_kern_mount+0x6a/0xc0
[16413.077924]  [<ffffffff81197324>] do_kern_mount+0x54/0x110
[16413.077924]  [<ffffffff81198e74>] do_mount+0x1a4/0x260
[16413.077924]  [<ffffffff81199350>] sys_mount+0x90/0xe0
[16413.077924]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
[16413.077924] Code: 08 66 c1 c2 08 c1 e0 10 0f b7 d2 09 d0 89 06 8b 07 0f
c8 89 46 04 c3 0f 1f 40 00 55 48 89 e5 66 66 66 66 90 31 c0 48 85 ff 74 25
<80> 3f 00 75 20 48 8d 47 01 48 83 c7 10 0f 1f 00 0f b6 10 48 83 
[16413.077924] RIP  [<ffffffffa02bb870>] uuid_is_nil+0x10/0x50 [xfs]
[16413.077924]  RSP <ffff88010c96bab8>
[16413.077924] CR2: 0000000000000130
[16413.103203] ---[ end trace 6914a6803053df67 ]---

Did you get similar backtraces when looking at this test?
Thanks,
--chris j arges
-- 
View this message in context: http://old.nabble.com/Still-seeing-hangs-in-xlog_grant_log_space-tp33732886p33996217.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
