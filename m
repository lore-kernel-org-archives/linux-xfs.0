Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n67Igx5c161359
	for <linux-xfs@oss.sgi.com>; Tue, 7 Jul 2009 13:42:59 -0500
Received: from netezza.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3FF8A129B2C5
	for <linux-xfs@oss.sgi.com>; Tue,  7 Jul 2009 11:50:26 -0700 (PDT)
Received: from netezza.com (mta.netezza.com [12.148.248.132]) by cuda.sgi.com
	with ESMTP id Ta3eQYM7pqDMCJ7W for <linux-xfs@oss.sgi.com>;
	Tue, 07 Jul 2009 11:50:26 -0700 (PDT)
Subject: [2.6.27.25] assfail in xfs_attr_quiesce() during umount
From: Paul Smith <paul@mad-scientist.net>
References: 20080307104918.GA20000@infradead.org
In-Reply-To: 20080307104918.GA20000@infradead.org
Message-ID: <MAIL10OSN4RHlLx5ERz0002f238@mail1.netezza.com>
Date: 7 Jul 2009 14:42:16 -0400
Reply-To: paul@mad-scientist.net
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux XFS <linux-xfs@oss.sgi.com>, christoph hellwig <hch@ifradead.org>, david chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org

> fs/xfs/xfs_vfsops.c, line: 708
> kernel BUG at fs/xfs/support/debug.c: 82!
> infalid opcode: 0000 [#1]
> Modules lined in: nvidia(P) xt_multiport iptable_filter ip_tables
 x_tables 
> Pid: 25313, comm: mount Tainted: P   (2.6.24.3-686-initrd-crk1 #1)
> EIP: 0060:[>f8a67a3f>] EFLAGS: 00010292 CPU: 0
> EAX: 00000061 EBX: f7faa400 ECX: ffffffff EDX: c034bda0
> ESI: dfc97000 EDI: f7faa400 EBP: db175e14 ESP: db175dcc
>  DS: 007b ES: 007b FS: 0000 GS: 033 SS: 0068
> Process mount (pid: 25313, ti=db174000 task=f7c32560 task.ti=db174000)
> Stack: f8a6cc60 f8a6c6b0 f8a6a135 000002c4 f8a57e38 f7faa400 f8a57ee7
 00000000
> Call Trace: 
> Code: d7 6b c7 83 c3 08 81 fb c8 02 a8 f8 75 ee 5b c3 83 ec 10 89 4c 24
 0c 89
> EIP: [<f8a67a3f>] assfail+0x1b/0x1f [xfs] SS:ESP 0068:db175dcc
> WARNING: at kernel/exit.c:917 do_exit()
> Pid: 25313, comm: mount Tainted: P         D 2.6.24.3-686-initrd-crk1 #1
> /etc/rc6.d/S60umountroot: line17: 25313 Segmentation fault mount 
Content-Type: text/plain
Organization: GNU's Not Unix!
Date: Tue, 07 Jul 2009 14:42:15 -0400
Message-Id: <1246992135.9022.7291.camel@psmith-ubeta.netezza.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit

Hi all.  I've seen this failure (only once so far, but even one kernel
panic is not good!) in my 2.6.27.25 kernel.  Output below.

This was seen before, in earlier kernels; see (2.6.23):
http://marc.info/?l=linux-kernel&m=120106649923499&w=2

And also (2.6.24):
http://archives.free.net.ph/message/20080307.104918.4ea41ede.en.html

According to the thread for the former, it was intended to be resolved
by "proper per-vfsmount write count in 2.6.25 as part of the per-mount
r/o patches" (C.Hellwig)

Did those fixes indeed go into 2.6.25 (or 2.6.27 or below)?  Was there
something else that needed to be done for XFS to be able take advantage
of that enhancement?

And, is the patch posted by DavidC here:
http://marc.info/?l=linux-kernel&m=120106649923499&w=2

still appropriate to work around this issue for 2.5.27.25?

Thanks!


===================================
umount: cannot remount /dev/md110 read-only 
Assertion failed: atomic_read(&mp->m_active_trans) == 0, file: /home/psmith/build/linux/fs/xfs/xfs_vfsops.c, line: 105 
------------[ cut here ]------------ 
Kernel BUG at ffffffffa02340ca [verbose debug info unavailable] 
invalid opcode: 0000 [1] PREEMPT SMP 
CPU 7 
Modules linked in: rng_core dock scsi_mod libata ata_piix zlib_inflate bnx2 libphy tg3 ipmi_msghandler ipmi_si ipmi_devintf bonding sd_mod sg scsi_transport_sas mptbase mptscsih mptsas mptctl md_mod raid1 raid10 raid0 linear dm_mod dm_multipath dm_round_robin jbd ext3 dm_ioband xfs disklog xxds(P) 
Pid: 8546, comm: umount Tainted: P 2.6.27.25 #1 
RIP: 0010:[<ffffffffa02340ca>] [<ffffffffa02340ca>] assfail+0x1a/0x20 [xfs] 
RSP: 0000:ffff8801a357fd38 EFLAGS: 00010292 
RAX: 00000000000000a5 RBX: ffff880462188000 RCX: ffff88046bcebef0 
RDX: ffffffff8054dfc8 RSI: 0000000000000096 RDI: 0000000000000001 
RBP: ffff8801a357fd60 R08: ffff88046f84db38 R09: 001c90dd7a1c63bb 
R10: 0000000000000000 R11: 0000000000000001 R12: ffff8801a357fd68 
R13: ffff8801a357fdcc R14: 0000000000000000 R15: 0000000000000040 
FS: 0000000000000000(0000) GS:ffff88046f819280(0063) knlGS:00000000f7f9c6c0 
CS: 0010 DS: 002b ES: 002b CR0: 000000008005003b 
CR2: 000000004d8800e1 CR3: 0000000322097000 CR4: 00000000000006e0 
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
Process umount (pid: 8546, threadinfo ffff8801a357e000, task ffff880390a7f1c0) 
Stack: ffff8801a357fd60 ffffffffa022178e ffff880462188000 ffffffffa023332c 
 ffff88046cbb7000 0000000000000000 0000000000000000 0000000000000001 
 0000000000000000 7fffffffffffffff 0000000000000000 0000000000000000 
Call Trace: 
 [<ffffffffa022178e>] ? xfs_attr_quiesce+0x4e/0x90 [xfs] 
 [<ffffffffa023332c>] ? xfs_fs_remount+0x10c/0x130 [xfs] 
 [<ffffffff802b23d1>] ? do_remount_sb+0x131/0x1d0 
 [<ffffffff802cac25>] ? do_remount+0x195/0x1b0 
 [<ffffffff802cd3da>] ? do_mount+0x1ba/0x230 
 [<ffffffff8028706e>] ? __get_free_pages+0x1e/0x50 
 [<ffffffff802e8e4f>] ? compat_sys_mount+0x11f/0x260 
 [<ffffffff8022ade8>] ? ia32_syscall_done+0x0/0x21 


Code: c7 96 69 23 a0 e8 57 66 13 e0 48 83 c4 18 c3 66 90 89 d1 48 83 ec 08 48 89 f2 31 c0 48 89 fe 48 c7 c7 a0 9e 23 a0 e8 a5 6e 25 e0 <0f> 0b eb fe 66 90 41 55 41 54 49 89 f4 55 89 fd 53 48 c7 c7 a0 
RIP [<ffffffffa02340ca>] assfail+0x1a/0x20 [xfs] 
 RSP <ffff8801a357fd38> 
Kernel panic - not syncing: Fatal exception

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
