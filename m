Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n917X3RC077287 for <xfs@oss.sgi.com>; Thu, 1 Oct 2009 02:33:03 -0500
Received: from knox.decisionsoft.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 124F61D74E55
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2009 00:34:24 -0700 (PDT)
Received: from knox.decisionsoft.com (knox-be.decisionsoft.com
	[87.194.172.100]) by cuda.sgi.com with ESMTP id
	7QHzSHPPhGS0k83F for <xfs@oss.sgi.com>;
	Thu, 01 Oct 2009 00:34:24 -0700 (PDT)
Received: from [82.152.70.89] (helo=[192.168.1.74])
	by knox.decisionsoft.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69) (envelope-from <strr-debian@decisionsoft.co.uk>)
	id 1MtGB8-0000rl-77
	for xfs@oss.sgi.com; Thu, 01 Oct 2009 08:34:23 +0100
Message-ID: <4AC45B72.9060500@decisionsoft.co.uk>
Date: Thu, 01 Oct 2009 08:34:10 +0100
From: Stuart Rowan <strr-debian@decisionsoft.co.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000605070204050902000506"
Subject: Two XFS involving stack traces from Debian's 2.6.26-2-amd64
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------000605070204050902000506
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I suspect the list will not be overly interested in these due to it 
being triggered on a non-cutting edge, vendor kernel but I'll post them 
anyway -- just in case there's an obvious "Debian should take patch-X" 
to fix this issue in the next Lenny errata kernel.

At the time of oops, an lvm snapshot of the XFS home directory is 
mounted for use by the backup scripts:

mkdir -p /tmp/$from; /sbin/lvcreate -s -L 20G -n snap-shot $from && 
mount -o nouuid,ro /dev/$vgroup/snap-shot /tmp/$from

(previously this called xfs_freeze -f / -u too but now lvcreate -s does 
this itself)

When the rsync has finished the following commands are run:

umount /tmp/$from ; /sbin/lvremove -f /dev/$vgroup/snap-shot ; rmdir 
/tmp/$from

The umount failed and now we have a stuck mount of the snapshot. I know 
a reboot will fix the issue but it's both an annoying and infrequent 
problem.

Cheers,
Stu.


--------------000605070204050902000506
Content-Type: text/plain;
 name="gpf.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gpf.txt"

[5634735.319443] general protection fault: 0000 [1] SMP
[5634735.319483] CPU 5
[5634735.319508] Modules linked in: tcp_diag inet_diag xt_multiport iptable_filter ip_tables x_tables cpufreq_stats cpufreq_ondemand cpufreq_powersave cpufreq_conservative cpufreq_userspace freq_table microc
[5634735.319879] Pid: 6394, comm: umount Not tainted 2.6.26-2-amd64 #1
[5634735.319913] RIP: 0010:[<ffffffff802ae02a>]  [<ffffffff802ae02a>] is_bad_inode+0x2/0x11
[5634735.319972] RSP: 0018:ffff810100465d40  EFLAGS: 00010246
[5634735.320004] RAX: 0000000000000000 RBX: ffff81022e69ad80 RCX: ffff810080a92000
[5634735.320056] RDX: ffff81000106e140 RSI: 0000000000000001 RDI: 65726f6e67692067
[5634735.320107] RBP: ffff810210f8c480 R08: 0000000000000296 R09: ffff810001102180
[5634735.320159] R10: ffff810210f8c6c0 R11: ffffffffa024c1a2 R12: 0000000000076029
[5634735.320210] R13: 65726f6e67692067 R14: ffff8100a5b134a0 R15: 0000000000000001
[5634735.320263] FS:  00007f0209d7d730(0000) GS:ffff81023f12b6c0(0000) knlGS:0000000000000000
[5634735.320317] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[5634735.320349] CR2: 00007f7841144000 CR3: 00000002385c7000 CR4: 00000000000006e0
[5634735.320401] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[5634735.320452] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[5634735.320505] Process umount (pid: 6394, threadinfo ffff810100464000, task ffff8100b6b714f0)
[5634735.320558] Stack:  ffffffffa024337d ffff8101728dd000 ffffffffa023f902 0000000100000296
[5634735.320620]  ffff81018519b100 ffff810210f8c6c0 ffff81022e69ad80 ffff810210f8c480
[5634735.320678]  0000000000076029 ffff810100465df8 ffffffffa024be60 ffff810210f8c480
[5634735.320718] Call Trace:
[5634735.320789]  [<ffffffffa024337d>] ? :xfs:xfs_inactive+0x27/0x412
[5634735.322089]  [<ffffffffa023f902>] ? :xfs:xfs_finish_reclaim+0x14c/0x15a
[5634735.322089]  [<ffffffffa024be60>] ? :xfs:xfs_fs_clear_inode+0xa4/0xe8
[5634735.322089]  [<ffffffff802accc6>] ? clear_inode+0xad/0x104
[5634735.322089]  [<ffffffff802ad2d6>] ? dispose_list+0x56/0xee
[5634735.322089]  [<ffffffff802ad620>] ? invalidate_inodes+0xb2/0xe7
[5634735.322089]  [<ffffffff802ad637>] ? invalidate_inodes+0xc9/0xe7
[5634735.322089]  [<ffffffff8029c98e>] ? generic_shutdown_super+0x39/0xee
[5634735.322089]  [<ffffffff8029ca50>] ? kill_block_super+0xd/0x1e
[5634735.322089]  [<ffffffff8029cb0c>] ? deactivate_super+0x5f/0x78
[5634735.322089]  [<ffffffff802afe06>] ? sys_umount+0x2f9/0x353
[5634735.322089]  [<ffffffff80221fac>] ? do_page_fault+0x5d8/0x9c8
[5634735.322089]  [<ffffffff8029e0e4>] ? sys_newstat+0x19/0x31
[5634735.322089]  [<ffffffff8031dd0f>] ? __up_write+0x21/0x10e
[5634735.322089]  [<ffffffff8020beca>] ? system_call_after_swapgs+0x8a/0x8f
[5634735.322089]
[5634735.322089]
[5634735.322089] Code: c3 b8 fb ff ff ff c3 b8 fb ff ff ff c3 b8 fb ff ff ff c3 48 c7 c0 fb ff ff ff c3 48 c7 c0 fb ff ff ff c3 b8 fb ff ff ff c3 31 c0 <48> 81 bf e8 00 00 00 c0 8e 44 80 0f 94 c0 c3 53 48 89
[5634735.322089] RIP  [<ffffffff802ae02a>] is_bad_inode+0x2/0x11
[5634735.322089]  RSP <ffff810100465d40>
[5634735.322089] ---[ end trace 6dd2658b5e6d5b7f ]---


--------------000605070204050902000506
Content-Type: text/plain;
 name="umount-oops.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="umount-oops.txt"

[5634735.322089] ------------[ cut here ]------------
[5634735.322089] WARNING: at kernel/exit.c:972 do_exit+0x3c/0x6a6()
[5634735.322132] Modules linked in: tcp_diag inet_diag xt_multiport iptable_filter ip_tables x_tables cpufreq_stats cpufreq_ondemand cpufreq_powersave cpufreq_conservative cpufreq_userspace freq_table microc
[5634735.326126] Pid: 6394, comm: umount Tainted: G      D   2.6.26-2-amd64 #1
[5634735.326126]
[5634735.326126] Call Trace:
[5634735.326126]  [<ffffffff80234a20>] warn_on_slowpath+0x51/0x7a
[5634735.326126]  [<ffffffff8022898e>] enqueue_task+0x56/0x61
[5634735.326126]  [<ffffffff80235475>] printk+0x4e/0x56
[5634735.326126]  [<ffffffff8023777d>] do_exit+0x3c/0x6a6
[5634735.326126]  [<ffffffff8022ae1e>] __wake_up+0x38/0x4f
[5634735.326126]  [<ffffffff8020d380>] oops_begin+0x0/0x96
[5634735.326126]  [<ffffffff804299d9>] error_exit+0x0/0x60
[5634735.326126]  [<ffffffffa024c1a2>] :xfs:xfs_fs_destroy_inode+0x0/0x12
[5634735.326126]  [<ffffffff802ae02a>] is_bad_inode+0x2/0x11
[5634735.326126]  [<ffffffffa024337d>] :xfs:xfs_inactive+0x27/0x412
[5634735.330707]  [<ffffffffa023f902>] :xfs:xfs_finish_reclaim+0x14c/0x15a
[5634735.330793]  [<ffffffffa024be60>] :xfs:xfs_fs_clear_inode+0xa4/0xe8
[5634735.330862]  [<ffffffff802accc6>] clear_inode+0xad/0x104
[5634735.330929]  [<ffffffff802ad2d6>] dispose_list+0x56/0xee
[5634735.330999]  [<ffffffff802ad620>] invalidate_inodes+0xb2/0xe7
[5634735.331071]  [<ffffffff802ad637>] invalidate_inodes+0xc9/0xe7
[5634735.331154]  [<ffffffff8029c98e>] generic_shutdown_super+0x39/0xee
[5634735.332240]  [<ffffffff8029ca50>] kill_block_super+0xd/0x1e
[5634735.332306]  [<ffffffff8029cb0c>] deactivate_super+0x5f/0x78
[5634735.333339]  [<ffffffff802afe06>] sys_umount+0x2f9/0x353
[5634735.334357]  [<ffffffff80221fac>] do_page_fault+0x5d8/0x9c8
[5634735.334652]  [<ffffffff8029e0e4>] sys_newstat+0x19/0x31
[5634735.334652]  [<ffffffff8031dd0f>] __up_write+0x21/0x10e
[5634735.334652]  [<ffffffff8020beca>] system_call_after_swapgs+0x8a/0x8f
[5634735.334652]
[5634735.334652] ---[ end trace 6dd2658b5e6d5b7f ]---


--------------000605070204050902000506
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------000605070204050902000506--
