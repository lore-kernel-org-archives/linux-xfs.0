Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1SMu0RX162581 for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 16:56:00 -0600
Received: from mail.mnsu.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A78B7305113
	for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 14:58:48 -0800 (PST)
Received: from mail.mnsu.edu (Mail.MNSU.EDU [134.29.1.12]) by cuda.sgi.com
	with ESMTP id dOtw6lbChMwTSbU2 for <xfs@oss.sgi.com>;
	Mon, 28 Feb 2011 14:58:48 -0800 (PST)
Received: from [134.29.32.1] (j3gum-3.ITS.MNSU.EDU [134.29.32.1])
	by mail.mnsu.edu (8.13.7/8.13.7) with ESMTP id p1SMwkKH004810
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 28 Feb 2011 16:58:47 -0600
Message-ID: <4D6C28A5.60905@mnsu.edu>
Date: Mon, 28 Feb 2011 16:58:45 -0600
From: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
MIME-Version: 1.0
Subject: kernel panic - stack-protector: kernel stack is corrupted in: f87aca93
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

I'm compiling the main Linux branch commit 
493f3358cb289ccf716c5a14fa5bb52ab75943e5 with no other patches.  It 
boots and seems to operate fine.  When I do an xfs_fsr it Kernel 
panics.  I can easily reproduce it

Kernel Panic: (hand copied, photo available)

Kernel panic - not syncing: stack-protector: Kernel stack is corrupted 
in: f87aca93

Pid: 262, comm: xfs_fsr Not tainted 2.6.38-rc6-493f3358cb2+ #1
Call Trace:

[<c12991ac>] ? panic+0x50/0x150
[<c102ed71>] ? __stack_chk_fail+0x10/0x18
[<f87aca93>] ? xfs_ioc_fsgeometry_v1+0x56/0x5d [xfs]
[<f87aca93>] ? xfs_ioc_fsgeometry_v1+0x56/0x5d [xfs]
[<f87ae062>] ? xfs_file_ioctl+0x33c/0x6fe [xfs]
[<c1047f1a>] ? sched_clock_cpu+0x130/0x140
[<c1050f41>] ? trace_hardirqs_off+0xb/0xd
[<c1047f57>] ? local_clock+0x2d/0x4e
[<c1050f6e>] ? lock_release_holdtime+0x2b/0xcd
[<c10a925a>] ? check_valid_pointer+0x1c/0x48
[<c10a99c8>] ? check_object+0x122/0x156
[<f87add26>] ? xfs_file_ioctl+0x0/0x6fe [xfs]
[<c10bf5c9>] ? do_vfs_ioctl+0x483/0x4c8
[<c10aab72>] ? kmeme_chache_free+0x8f/0x9b
[<c10b41b4>] ? fcheck_files+0xa1/0xd0
[<c10bf64f>] ? sys_ioctl+0x41/0x61
[<c1002893>] ? sysenter_do_call+0x12/0x32



You can find the config, initrd.img, vmlinuz and crash screen at:
http://krypton.mnsu.edu/~j3gum/linux-error-20110228/

- gcc (Debian 4.4.5-13) 4.4.5
- xfs_fsr version 3.1.4


Please let know if you'd like more info.

-- 
Jeffrey Hundstad

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
