Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1D9hx9c125545 for <xfs@oss.sgi.com>; Fri, 13 Feb 2009 03:44:00 -0600
Received: from knox.decisionsoft.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 658221083376
	for <xfs@oss.sgi.com>; Fri, 13 Feb 2009 01:43:23 -0800 (PST)
Received: from knox.decisionsoft.com (knox-be.decisionsoft.com
	[87.194.172.100]) by cuda.sgi.com with ESMTP id
	HpLA9oNzWWa0b25H for <xfs@oss.sgi.com>;
	Fri, 13 Feb 2009 01:43:23 -0800 (PST)
Received: from [82.152.70.89] (helo=[192.168.1.74])
	by knox.decisionsoft.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.63) (envelope-from <strr-debian@decisionsoft.co.uk>)
	id 1LXuZr-0002EH-SU
	for xfs@oss.sgi.com; Fri, 13 Feb 2009 09:43:23 +0000
Message-ID: <499540B1.2080100@decisionsoft.co.uk>
Date: Fri, 13 Feb 2009 09:43:13 +0000
From: Stuart Rowan <strr-debian@decisionsoft.co.uk>
MIME-Version: 1.0
Subject: Oops during umount of r/o file system
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

I fetched and installed the linux-image-2.6.26-bpo.1-amd64 package from 
backports.org.

This is the Debian lenny kernel, but backported to etch. It looks to be 
2.6.26.8 and a few patches. I realise the "and a few patches" sounds bad 
but usually with Debian they are minor things like adding device ids.

uname -a:
Linux tigris 2.6.26-bpo.1-amd64 #1 SMP Wed Dec 17 12:18:36 UTC 2008 
x86_64 GNU/Linux

We do the following as part of our backup script:

mkdir -p /tmp/dev/data/home-xfs; /usr/sbin/xfs_freeze -f /home ; 
/sbin/lvcreate -s -L 20G -n snap-shot /dev/data/home-xfs ; 
/usr/sbin/xfs_freeze -u /home && mount -o nouuid,ro /dev/data/snap-shot 
/tmp/dev/data/home-xfs

(rsync the snapshot offsite)

umount /tmp/dev/data/home-xfs ; /sbin/lvremove -f /dev/data/snap-shot

The umount, intermittently, of this ro filesystem hangs until a reboot 
as below.

I'm tempted to move to 2.6.28 as Christoph's comment in 
http://oss.sgi.com/bugzilla/show_bug.cgi?id=807 suggests that things 
should be fixed. However, the intermittent nature of the below occurring 
is what's bugging me.

Anyway, I thought it worth a post to the list, in case you guys know 
about the problem already and/or are confident a later kernel (which 
I'll just compile myself from kernel.org) will fix the issue.

Cheers,
Stu.


Linux tigris 2.6.26-bpo.1-amd64 #1 SMP Wed Dec 17 12:18:36 UTC 2008 
x86_64 GNU/Linux


[793534.693304] general protection fault: 0000 [1] SMP
[793534.693343] CPU 7
[793534.693369] Modules linked in: cpufreq_stats freq_table tcp_diag 
inet_diag xt_multiport iptable_filter ip_tables x_tables ac battery ipv6 
xfs w83793 lm85 hwmon_vid loop snd_pcm snd_timer snd soundcore sn
[793534.693702] Pid: 20965, comm: umount Not tainted 2.6.26-bpo.1-amd64 #1
[793534.693736] RIP: 0010:[<ffffffff802ae8da>]  [<ffffffff802ae8da>] 
is_bad_inode+0x2/0x11
[793534.693795] RSP: 0018:ffff8101ef503d40  EFLAGS: 00010246
[793534.693826] RAX: 0000000000000000 RBX: ffff81010f413d80 RCX: 
ffff810080aa4000
[793534.693878] RDX: ffff810001082140 RSI: 0000000000000001 RDI: 
65726f6e67692067
[793534.695214] RBP: ffff81010f412480 R08: 0000000000000296 R09: 
ffff810001101b80
[793534.695266] R10: ffff81010f4126c0 R11: ffffffffa0252631 R12: 
000000000002081e
[793534.695317] R13: 65726f6e67692067 R14: ffff81015b456b60 R15: 
0000000000000001
[793534.695369] FS:  00007fc0723c66d0(0000) GS:ffff81023f1ad5c0(0000) 
knlGS:0000000000000000
[793534.695422] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[793534.695454] CR2: 00007f7db79f6000 CR3: 000000019ca96000 CR4: 
00000000000006e0
[793534.695506] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[793534.695557] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[793534.695609] Process umount (pid: 20965, threadinfo ffff8101ef502000, 
task ffff81023cf898b0)
[793534.700903] Stack:  ffffffffa0249740 ffff81016c891000 
ffffffffa0245ccc 0000000100000296
[793534.700903]  ffff81010f40f100 ffff81010f4126c0 ffff81010f413d80 
ffff81010f412480
[793534.700903]  000000000002081e ffff8101ef503df8 ffffffffa02522ec 
ffff81010f412480
[793534.700903] Call Trace:
[793534.700903]  [<ffffffffa0249740>] ? :xfs:xfs_inactive+0x27/0x412
[793534.700903]  [<ffffffffa0245ccc>] ? :xfs:xfs_finish_reclaim+0x14c/0x15a
[793534.700903]  [<ffffffffa02522ec>] ? :xfs:xfs_fs_clear_inode+0xa4/0xe8
[793534.700903]  [<ffffffff802ad573>] ? clear_inode+0xad/0x104
[793534.700903]  [<ffffffff802adb83>] ? dispose_list+0x56/0xee
[793534.700903]  [<ffffffff802adecd>] ? invalidate_inodes+0xb2/0xe7
[793534.700903]  [<ffffffff802adee4>] ? invalidate_inodes+0xc9/0xe7
[793534.700903]  [<ffffffff8029d138>] ? generic_shutdown_super+0x39/0xee
[793534.700903]  [<ffffffff8029d1fa>] ? kill_block_super+0xd/0x1e
[793534.700903]  [<ffffffff8029d2b6>] ? deactivate_super+0x5f/0x78
[793534.700903]  [<ffffffff802b06ee>] ? sys_umount+0x2f9/0x353
[793534.700903]  [<ffffffff80222009>] ? do_page_fault+0x5e1/0x9d4
[793534.700903]  [<ffffffff8031eb1f>] ? __up_write+0x21/0x10e
[793534.700903]  [<ffffffff8020beca>] ? system_call_after_swapgs+0x8a/0x8f
[793534.700903]
[793534.700903]
[793534.700903] Code: c3 b8 fb ff ff ff c3 b8 fb ff ff ff c3 b8 fb ff ff 
ff c3 48 c7 c0 fb ff ff ff c3 48 c7 c0 fb ff ff ff c3 b8 fb ff ff ff c3 
31 c0 <48> 81 bf e8 00 00 00 c0 ae 44 80 0f 94 c0 c3 53 48 89
[793534.700903] RIP  [<ffffffff802ae8da>] is_bad_inode+0x2/0x11
[793534.700903]  RSP <ffff8101ef503d40>
[793534.700981] ---[ end trace 52e914781e278a96 ]---
[793534.702106] ------------[ cut here ]------------
[793534.703247] WARNING: at kernel/exit.c:973 do_exit+0x3c/0x6bb()
[793534.703311] Modules linked in: cpufreq_stats freq_table tcp_diag 
inet_diag xt_multiport iptable_filter ip_tables x_tables ac battery ipv6 
xfs w83793 lm85 hwmon_vid loop snd_pcm snd_timer snd soundcore sn
[793534.708965] Pid: 20965, comm: umount Tainted: G      D 
2.6.26-bpo.1-amd64 #1
[793534.708965]
[793534.708965] Call Trace:
[793534.708965]  [<ffffffff80234ae5>] warn_on_slowpath+0x51/0x79
[793534.708965]  [<ffffffff8022945b>] enqueue_task+0x56/0x61
[793534.708965]  [<ffffffff8023554c>] printk+0x4e/0x56
[793534.708965]  [<ffffffff802378ff>] do_exit+0x3c/0x6bb
[793534.708965]  [<ffffffff8020d380>] oops_begin+0x0/0x9c
[793534.708965]  [<ffffffff8042bd19>] error_exit+0x0/0x60
[793534.708965]  [<ffffffffa0252631>] :xfs:xfs_fs_destroy_inode+0x0/0x12
[793534.708965]  [<ffffffff802ae8da>] is_bad_inode+0x2/0x11
[793534.708965]  [<ffffffffa0249740>] :xfs:xfs_inactive+0x27/0x412
[793534.708965]  [<ffffffffa0245ccc>] :xfs:xfs_finish_reclaim+0x14c/0x15a
[793534.708965]  [<ffffffffa02522ec>] :xfs:xfs_fs_clear_inode+0xa4/0xe8
[793534.708965]  [<ffffffff802ad573>] clear_inode+0xad/0x104
[793534.708965]  [<ffffffff802adb83>] dispose_list+0x56/0xee
[793534.708965]  [<ffffffff802adecd>] invalidate_inodes+0xb2/0xe7
[793534.708965]  [<ffffffff802adee4>] invalidate_inodes+0xc9/0xe7
[793534.708965]  [<ffffffff8029d138>] generic_shutdown_super+0x39/0xee
[793534.708965]  [<ffffffff8029d1fa>] kill_block_super+0xd/0x1e
[793534.708965]  [<ffffffff8029d2b6>] deactivate_super+0x5f/0x78
[793534.708965]  [<ffffffff802b06ee>] sys_umount+0x2f9/0x353
[793534.708965]  [<ffffffff80222009>] do_page_fault+0x5e1/0x9d4
[793534.708965]  [<ffffffff8031eb1f>] __up_write+0x21/0x10e
[793534.708965]  [<ffffffff8020beca>] system_call_after_swapgs+0x8a/0x8f
[793534.708965]
[793534.708965] ---[ end trace 52e914781e278a96 ]---


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
