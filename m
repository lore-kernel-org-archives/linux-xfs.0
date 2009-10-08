Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n98DOaja007341 for <xfs@oss.sgi.com>; Thu, 8 Oct 2009 08:24:37 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 309D6175CDA6
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2009 06:26:02 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id JV3W8pJhfZx4lexj for
	<xfs@oss.sgi.com>; Thu, 08 Oct 2009 06:26:02 -0700 (PDT)
Message-ID: <4ACDE866.6030004@sandeen.net>
Date: Thu, 08 Oct 2009 08:25:58 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 2.6.32-rc3 kernel BUG when unmounting quota offed xfs
References: <4ACD8C9B.5090701@wm.jp.nec.com>
In-Reply-To: <4ACD8C9B.5090701@wm.jp.nec.com>
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
To: Utako Kusaka <u-kusaka@wm.jp.nec.com>
Cc: xfs <xfs@oss.sgi.com>

Utako Kusaka wrote:
> Hi,
> 
> XFS file system segfaults in 2.6.32-rc3 and 2.6.31.2.
> This problem does not occur with 2.6.30-rc5.
> xfsprogs version is 3.0.3.
> 
> Testcase is:
> # mount -t xfs -o uquota /dev/sda7 mpnt2
> # xfs_quota -x -c off
> # umount /dev/sda7
> Segmentation fault
> 

so this is BUG_ON((inode->i_state == I_CLEAR)

Are you using or at least building with CONFIG_XFS_RT (the realtime 
subvolume)?  Seems so from the stacktrace below (xfs_rtunmount_inodes)?

If you're not actually using realtime, turning off that option may 
resolve it for you for now.

I'll double-check the handling of the special realtime inodes.

-Eric

> Oct  8 09:56:58 g9517 kernel: ------------[ cut here ]------------
> Oct  8 09:56:58 g9517 kernel: kernel BUG at fs/inode.c:1343!
> Oct  8 09:56:58 g9517 kernel: invalid opcode: 0000 [#1]
> Oct  8 09:56:58 g9517 kernel: last sysfs file:
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed
> Oct  8 09:56:58 g9517 kernel: Modules linked in: snd_pcm_oss snd_pcm snd_timer
> snd_page_alloc snd_mixer_oss snd soundcore usbserial parport_pc lp parport edd
> nvram evdev joydev sg st sr_mod ide_cd_mod cdrom intel_agp agpgart ehci_hcd
> cpufreq_userspace acpi_cpufreq uhci_hcd i2c_i801 i2c_core speedstep_lib thermal
> processor fan thermal_sys button battery ac ipv6 e100 mii usbcore xfs exportfs
> dm_mod ext3 jbd ata_piix libata sd_mod scsi_mod
> Oct  8 09:56:58 g9517 kernel:
> Oct  8 09:56:58 g9517 kernel: Pid: 8437, comm: umount Not tainted (2.6.32-rc3
> #1) Endeavor AT955
> Oct  8 09:56:58 g9517 kernel: EIP: 0060:[<c10bd6c5>] EFLAGS: 00210246 CPU: 0
> Oct  8 09:56:58 g9517 kernel: EIP is at iput+0x45/0x60
> Oct  8 09:56:58 g9517 kernel: EAX: dce43410 EBX: dce43410 ECX: 00000000 EDX:
> 00000000
> Oct  8 09:56:58 g9517 kernel: ESI: db664800 EDI: dce43080 EBP: de361ee8 ESP:
> de361ee4
> Oct  8 09:56:58 g9517 kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Oct  8 09:56:58 g9517 kernel: Process umount (pid: 8437, ti=de360000
> task=db54f4b0 task.ti=de360000)
> Oct  8 09:56:58 g9517 kernel: Stack:
> Oct  8 09:56:58 g9517 kernel:  db664800 de361ef4 e0752d2a db664800 de361f10
> e0795d25 de361efc de361efc
> Oct  8 09:56:58 g9517 kernel: <0> d980cc00 db664800 d980cc00 de361f30 e07ab629
> de361f30 c10bc7da de361f20
> Oct  8 09:56:58 g9517 kernel: <0> d980cc00 db54f4b0 e07ae7c0 de361f4c c10ac2ec
> de361f48 c10bfb86 deeae900
> Oct  8 09:56:58 g9517 kernel: Call Trace:
> Oct  8 09:56:58 g9517 kernel:  [<e0752d2a>] ? xfs_rtunmount_inodes+0x2a/0x50 [xfs]
> Oct  8 09:56:58 g9517 kernel:  [<e0795d25>] ? xfs_unmountfs+0x15/0x150 [xfs]
> Oct  8 09:56:58 g9517 kernel:  [<e07ab629>] ? xfs_fs_put_super+0x59/0xd0 [xfs]
> Oct  8 09:56:58 g9517 kernel:  [<c10bc7da>] ? invalidate_inodes+0x4a/0x60
> Oct  8 09:56:58 g9517 kernel:  [<c10ac2ec>] ? generic_shutdown_super+0xac/0xd0
> Oct  8 09:56:58 g9517 kernel:  [<c10bfb86>] ? mntput_no_expire+0x16/0x80
> Oct  8 09:56:58 g9517 kernel:  [<c10acd75>] ? kill_block_super+0x25/0x40
> Oct  8 09:56:58 g9517 kernel:  [<c10ac0c9>] ? deactivate_super+0x49/0x80
> Oct  8 09:56:58 g9517 kernel:  [<c10bfbb5>] ? mntput_no_expire+0x45/0x80
> Oct  8 09:56:58 g9517 kernel:  [<c10c0660>] ? sys_umount+0x80/0x90
> Oct  8 09:56:58 g9517 kernel:  [<c10c0687>] ? sys_oldumount+0x17/0x20
> Oct  8 09:56:58 g9517 kernel:  [<c1002e48>] ? sysenter_do_call+0x12/0x26
> Oct  8 09:56:58 g9517 kernel: Code: c1 e8 10 a5 0b 00 85 c0 74 1e 8b 83 90 00 00
> 00 ba 60 d6 0b c1 8b 40 20 85 c0 74 08 8b 40 10 85 c0 0f 45 d0 89 d8 ff d2 5b 5d
> c3 <0f> 0b 89 f6 8d bc 27 00 00 00 00 eb fe 8d b4 26 00 00 00 00 8d
> Oct  8 09:56:58 g9517 kernel: EIP: [<c10bd6c5>] iput+0x45/0x60 SS:ESP 0068:de361ee4
> Oct  8 09:56:58 g9517 kernel: ---[ end trace 8a9a86591e230b04 ]---
> Oct  8 09:56:58 g9517 kernel: ------------[ cut here ]------------
> Oct  8 09:56:58 g9517 kernel: WARNING: at kernel/exit.c:897 do_exit+0x204/0x2c0()
> Oct  8 09:56:58 g9517 kernel: Hardware name: Endeavor AT955
> Oct  8 09:56:58 g9517 kernel: Modules linked in: snd_pcm_oss snd_pcm snd_timer
> snd_page_alloc snd_mixer_oss snd soundcore usbserial parport_pc lp parport edd
> nvram evdev joydev sg st sr_mod ide_cd_mod cdrom intel_agp agpgart ehci_hcd
> cpufreq_userspace acpi_cpufreq uhci_hcd i2c_i801 i2c_core speedstep_lib thermal
> processor fan thermal_sys button battery ac ipv6 e100 mii usbcore xfs exportfs
> dm_mod ext3 jbd ata_piix libata sd_mod scsi_mod
> Oct  8 09:56:58 g9517 kernel: Pid: 8437, comm: umount Tainted: G      D
> 2.6.32-rc3 #1
> Oct  8 09:56:58 g9517 kernel: Call Trace:
> Oct  8 09:56:58 g9517 kernel:  [<c1031b00>] ? have_callable_console+0x0/0x30
> Oct  8 09:56:58 g9517 kernel:  [<c1033804>] ? do_exit+0x204/0x2c0
> Oct  8 09:56:58 g9517 kernel:  [<c10313cc>] warn_slowpath_common+0x7c/0xa0
> Oct  8 09:56:58 g9517 kernel:  [<c1033804>] ? do_exit+0x204/0x2c0
> Oct  8 09:56:58 g9517 kernel:  [<c1031435>] warn_slowpath_null+0x15/0x30
> Oct  8 09:56:58 g9517 kernel:  [<c1033804>] do_exit+0x204/0x2c0
> Oct  8 09:56:58 g9517 kernel:  [<c103133a>] ? print_oops_end_marker+0x2a/0x30
> Oct  8 09:56:58 g9517 kernel:  [<c100605d>] oops_end+0x7d/0x80
> Oct  8 09:56:58 g9517 kernel:  [<c100619b>] die+0x5b/0x80
> Oct  8 09:56:58 g9517 kernel:  [<c1003781>] do_trap+0x91/0xd0
> Oct  8 09:56:58 g9517 kernel:  [<c1003930>] ? do_invalid_op+0x0/0xa0
> Oct  8 09:56:58 g9517 kernel:  [<c10039b8>] do_invalid_op+0x88/0xa0
> Oct  8 09:56:58 g9517 kernel:  [<c10bd6c5>] ? iput+0x45/0x60
> Oct  8 09:56:58 g9517 kernel:  [<c106439d>] ? call_rcu_sched+0xd/0x10
> Oct  8 09:56:58 g9517 kernel:  [<c117bd7a>] ? radix_tree_delete+0xfa/0x1b0
> Oct  8 09:56:58 g9517 kernel:  [<c12ee4a6>] ? schedule_timeout+0x166/0x1a0
> Oct  8 09:56:58 g9517 kernel:  [<e07ac157>] ? xfs_inode_ag_lookup+0xe7/0x110 [xfs]
> Oct  8 09:56:58 g9517 kernel:  [<c12ef3de>] error_code+0x5e/0x64
> Oct  8 09:56:58 g9517 kernel:  [<e07a007b>] ? xfs_free_file_space+0x25b/0x640 [xfs]
> Oct  8 09:56:58 g9517 kernel:  [<c1003930>] ? do_invalid_op+0x0/0xa0
> Oct  8 09:56:58 g9517 kernel:  [<c10bd6c5>] ? iput+0x45/0x60
> Oct  8 09:56:58 g9517 kernel:  [<e0752d2a>] xfs_rtunmount_inodes+0x2a/0x50 [xfs]
> Oct  8 09:56:58 g9517 kernel:  [<e0795d25>] xfs_unmountfs+0x15/0x150 [xfs]
> Oct  8 09:56:58 g9517 kernel:  [<e07ab629>] xfs_fs_put_super+0x59/0xd0 [xfs]
> Oct  8 09:56:58 g9517 kernel:  [<c10bc7da>] ? invalidate_inodes+0x4a/0x60
> Oct  8 09:56:58 g9517 kernel:  [<c10ac2ec>] generic_shutdown_super+0xac/0xd0
> Oct  8 09:56:58 g9517 kernel:  [<c10bfb86>] ? mntput_no_expire+0x16/0x80
> Oct  8 09:56:58 g9517 kernel:  [<c10acd75>] kill_block_super+0x25/0x40
> Oct  8 09:56:58 g9517 kernel:  [<c10ac0c9>] deactivate_super+0x49/0x80
> Oct  8 09:56:58 g9517 kernel:  [<c10bfbb5>] mntput_no_expire+0x45/0x80
> Oct  8 09:56:58 g9517 kernel:  [<c10c0660>] sys_umount+0x80/0x90
> Oct  8 09:56:58 g9517 kernel:  [<c10c0687>] sys_oldumount+0x17/0x20
> Oct  8 09:56:58 g9517 kernel:  [<c1002e48>] sysenter_do_call+0x12/0x26
> Oct  8 09:56:58 g9517 kernel: ---[ end trace 8a9a86591e230b05 ]---
> 
> 
> Regards,
> Utako
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
