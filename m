Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n69NNhQ4059397 for <xfs@oss.sgi.com>; Thu, 9 Jul 2009 18:23:44 -0500
Received: from an-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D338A24B57
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2009 16:31:25 -0700 (PDT)
Received: from an-out-0708.google.com (an-out-0708.google.com
	[209.85.132.241]) by cuda.sgi.com with ESMTP id
	k2NMzE3lXituxodH for <xfs@oss.sgi.com>;
	Thu, 09 Jul 2009 16:31:25 -0700 (PDT)
Received: by an-out-0708.google.com with SMTP id b2so301276ana.32
	for <xfs@oss.sgi.com>; Thu, 09 Jul 2009 16:24:18 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 9 Jul 2009 19:24:18 -0400
Message-ID: <554e24be0907091624s2dd439b2vfd7062f6b866c7f@mail.gmail.com>
Subject: kernel BUG with xfs_quota
From: Chris Walker <christopher.walker@gmail.com>
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

Hello,

I ran an xfs_quota command earlier (xfs_quota -x -c 'limit -g
bsoft=2048g bhard=2148g hepl' /seltzer_lab), which triggered a kernel
BUG:

Assertion failed: dst->d_btimer != 0, file:
fs/xfs/quota/xfs_qm_syscalls.c, line: 927
------------[ cut here ]------------
kernel BUG at fs/xfs/support/debug.c:108!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
CPU 3
Modules linked in: hidp rfcomm l2cap bluetooth bonding ipv6 xfs nfsd
lockd nfs_acl auth_rpcgss exportfs sunrpc dm_mirror dm_region_hash
dm_log dm_multipath dm_mod sbs sbshc battery acpi_memhotplug ac
parport_pc lp parport sr_mod cdrom sg joydev usb_storage e1000 button
serio_raw rtc_cmos rtc_core rtc_lib amd_rng i2c_amd756 k8temp
pata_acpi i2c_amd8111 hwmon shpchp i2c_core pcspkr raid456 async_xor
async_memcpy async_tx xor sata_mv libata sd_mod scsi_mod raid1 ext3
jbd ehci_hcd ohci_hcd uhci_hcd
Pid: 7826, comm: xfs_quota Not tainted 2.6.29.4 #1 Sun Fire X4500
RIP: 0010:[<ffffffffa032cbfc>]  [<ffffffffa032cbfc>] assfail+0x1a/0x1e [xfs]
RSP: 0018:ffff8803ed811e48  EFLAGS: 00010292
RAX: 0000000000000059 RBX: ffff8803ed811ec8 RCX: 000000000001b4e7
RDX: ffff8802869c8000 RSI: 0000000000000046 RDI: ffffffff80893f74
RBP: ffff8803f4cbcbd8 R08: 0000000000000000 R09: ffff880028083080
R10: ffff880028083080 R11: 0000010000000296 R12: ffff8803fdc96000
R13: 0000000000000000 R14: ffff8803fdc93c00 R15: 0000000000004e39
FS:  00007fb60e5596f0(0000) GS:ffff8803fe8220c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000008c58d0 CR3: 00000001f98a8000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process xfs_quota (pid: 7826, threadinfo ffff8803ed810000, task
ffff8803fd23a7c0)
Stack:
 ffff8803ed811ec8 ffffffffa02c2fde 0000000000000000 ffff8803fdc96000
 ffff8803ed811ec8 ffffffffa02c30bf 0000000000005803 ffff8803f4cbcb60
 0000000000000000 ffff8803ed811ec8 0000000000005803 ffffffffa0329d25
Call Trace:
 [<ffffffffa02c2fde>] ? xfs_qm_export_dquot+0x1af/0x1e4 [xfs]
 [<ffffffffa02c30bf>] ? xfs_qm_scall_getquota+0xac/0xc0 [xfs]
 [<ffffffffa0329d25>] ? xfs_fs_getxquota+0x37/0x3b [xfs]
 [<ffffffff802da15a>] ? sys_quotactl+0x574/0x604
 [<ffffffff8020bddb>] ? system_call_fastpath+0x16/0x1b
Code: 44 24 08 01 00 00 00 e8 4e c7 00 e0 48 83 c4 18 c3 89 d1 48 83
ec 08 48 89 f2 31 c0 48 89 fe 48 c7 c7 2b 03 34 a0 e8 2c bd f0 df <0f>
0b eb fe 41 56 83 e7 07 83 ff 07 41 55 49 89 d5 41 54 49 89
RIP  [<ffffffffa032cbfc>] assfail+0x1a/0x1e [xfs]
 RSP <ffff8803ed811e48>
---[ end trace 1c72dd68c3f985d1 ]---

This rendered the filesystem increasingly unstable until a hard reboot
was necessary.  Now any xfs_quota command, even just reporting, throws
the same assertion.   Any idea how I can repair this?

Thanks,
Chris
Thanks,
Chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
