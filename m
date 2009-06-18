Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5IJUhr3026182 for <xfs@oss.sgi.com>; Thu, 18 Jun 2009 14:30:44 -0500
Received: from mail-fx0-f207.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B60130742A
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2009 12:31:07 -0700 (PDT)
Received: from mail-fx0-f207.google.com (mail-fx0-f207.google.com
	[209.85.220.207]) by cuda.sgi.com with ESMTP id
	KCDf8E8MxrG1raGz for <xfs@oss.sgi.com>;
	Thu, 18 Jun 2009 12:31:07 -0700 (PDT)
Received: by fxm3 with SMTP id 3so1243278fxm.20
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2009 12:31:07 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 18 Jun 2009 23:31:06 +0400
Message-ID: <a4423d670906181231r7388df5am394bc55508272b3@mail.gmail.com>
Subject: 2.6.30-06725: xfs_fsr: Assertion failed: ip->i_delayed_blks == 0,
	file: fs/xfs/xfs_bmap.c, line: 5991
From: Alexander Beregalov <a.beregalov@gmail.com>
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

Hi


Assertion failed: ip->i_delayed_blks == 0, file: fs/xfs/xfs_bmap.c, line: 5991
------------[ cut here ]------------
kernel BUG at fs/xfs/support/debug.c:109!
invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed
Modules linked in: w83627hf hwmon_vid i2c_nforce2

Pid: 3164, comm: xfs_fsr Not tainted (2.6.30-06725-g1d89b30 #2)
EIP: 0060:[<c11a063e>] EFLAGS: 00010292 CPU: 0
EIP is at assfail+0x1e/0x30
EAX: 00000061 EBX: 0000007f ECX: c13501b7 EDX: ef693d80
ESI: 00000000 EDI: f67c3de4 EBP: f67c3d38 ESP: f67c3d28
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process xfs_fsr (pid: 3164, ti=f67c2000 task=ef693d80 task.ti=f67c2000)
Stack:
 c142ab88 c140c8c5 c140c42d 00001767 f67c3dd0 c114d53f ffffffff ffffffff
<0> 00000000 00000000 00000001 efdb91e4 ef693d80 f67c3d88 00000246 c109abea
<0> f6df4768 00000246 00000000 00000000 c1198ca0 f3d732e0 e8ae8000 00000002
Call Trace:
 [<c114d53f>] ? xfs_getbmap+0x19f/0x7b0
 [<c109abea>] ? __d_lookup+0xca/0x170
 [<c1198ca0>] ? xfs_getbmap_format+0x0/0x30
 [<c1073da6>] ? might_fault+0x46/0xa0
 [<c11ca7e5>] ? copy_from_user+0x35/0x140
 [<c1198e48>] ? xfs_ioc_getbmap+0x68/0xf0
 [<c119a830>] ? xfs_file_ioctl+0x420/0x860
 [<c104d3dd>] ? print_lock_contention_bug+0x1d/0x110
 [<c106a3f6>] ? put_page+0x56/0x110
 [<c1083ffc>] ? slab_pad_check+0x3c/0x120
 [<c10852fd>] ? check_object+0x13d/0x200
 [<c119a410>] ? xfs_file_ioctl+0x0/0x860
 [<c1096950>] ? vfs_ioctl+0x20/0x70
 [<c1096b4a>] ? do_vfs_ioctl+0x6a/0x5c0
 [<c104ea5b>] ? trace_hardirqs_on+0xb/0x10
 [<c1078f96>] ? remove_vma+0x56/0x70
 [<c1078f96>] ? remove_vma+0x56/0x70
 [<c1078f96>] ? remove_vma+0x56/0x70
 [<c1079e4b>] ? do_munmap+0x23b/0x280
 [<c10970d9>] ? sys_ioctl+0x39/0x70
 [<c1002d58>] ? sysenter_do_call+0x12/0x36

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
