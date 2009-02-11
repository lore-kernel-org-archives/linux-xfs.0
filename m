Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1BNYkab163214 for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 17:34:47 -0600
Received: from web30201.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id CF8291B3D41E
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 15:34:10 -0800 (PST)
Received: from web30201.mail.mud.yahoo.com (web30201.mail.mud.yahoo.com
	[209.191.69.48]) by cuda.sgi.com with SMTP id 8GhbAikxRNr4LgQb
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 15:34:10 -0800 (PST)
Message-ID: <849745.82892.qm@web30201.mail.mud.yahoo.com>
Date: Wed, 11 Feb 2009 15:34:09 -0800 (PST)
From: <raksac@yahoo.com>
Subject: Re: BUG: soft lockup detected on CPU#1!
In-Reply-To: <alpine.DEB.1.10.0902110420520.13264@p34.internal.lan>
MIME-Version: 1.0
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com


With debug enabled it fails with this -

BUG: unable to handle kernel NULL pointer dereference
at virtual address 00000000
 printing eip:
f8bd02c2
*pde = d658e067
Assertion failed: atomic_read(&ip->i_pincount) > 0,
file: fs/xfs/xfs_inode.c, line: 2703
------------[ cut here ]------------
Kernel BUG at [verbose debug info unavailable]
invalid opcode: 0000 [#1]
PREEMPT SMP 
last sysfs file:
/devices/pci0000:00/0000:00:1f.3/i2c-0/0-002e/temp2_input
Modules linked in: sg xfs sunrpc m24c02 pca9554
pca9555 mcp23016 lm85 hwmon_vid i2c_i801 i2c_core
midplane uhci_hcd sk98lin tg3 e1000 mv_sata sd_mod
ahci libata
CPU:    0
EIP:    0060:[<f8bfde19>]    Not tainted VLI
EFLAGS: 00010296   (2.6.18.rhel5 #2) 
EIP is at assfail+0xd/0x13 [xfs]
eax: 0000005c   ebx: e1fb4980   ecx: e4f46000   edx:
00000000
esi: 00000007   edi: e1fb0a58   ebp: 00000007   esp:
e4f47eb8
ds: 007b   es: 007b   ss: 0068
Process xfslogd/0 (pid: 4370, ti=e4f46000
task=75118aa0 task.ti=e4f46000)
Stack: f8c10ccb f8c090ae f8c08d97 00000a8f f8bd0dca
00000526 f8be8e28 00000526 
       00000007 e9db1d80 e861c008 e9db1da0 e861c000
00000003 e9db1d80 e9db1ca4 
       e9db1ca0 00000000 f8be8f56 00000000 00000000
e9db1ca4 ea449880 ea449800 
Call Trace:
 [<f8bd0dca>] xfs_iunpin+0x21/0x49 [xfs]
 [<f8be8e28>] xfs_trans_chunk_committed+0xc3/0xe6
[xfs]
 [<f8be8f56>] xfs_trans_committed+0x38/0xd1 [xfs]
 [<f8bdba5c>] xlog_state_do_callback+0x1b7/0x329 [xfs]
 [<f8bf66b7>] xfs_buf_iodone_work+0x41/0x63 [xfs]
 [<401294c5>] run_workqueue+0x71/0xae
 [<f8bf6676>] xfs_buf_iodone_work+0x0/0x63 [xfs]
 [<40129666>] worker_thread+0xd9/0x10a
 [<40116ca2>] default_wake_function+0x0/0xc
 [<4012958d>] worker_thread+0x0/0x10a
 [<4012be6d>] kthread+0xc1/0xec
 [<4012bdac>] kthread+0x0/0xec
 [<401038b3>] kernel_thread_helper+0x7/0x10
 =======================
Code: d2 df 51 47 89 ea b8 94 59 c2 f8 e8 a9 37 6a 47
83 c4 0c 85 ff 75 02 0f 0b 5b 5e 5f 5d c3 51 52 50 68
cb 0c c1 f8 e8 ab df 51 47 <0f> 0b 83 c4 10 c3 55 57
56 53 83 ec 14 89 44 24 04 89 d7 89 cd 
EIP: [<f8bfde19>] assfail+0xd/0x13 [xfs] SS:ESP
0068:e4f47eb8
 <0>Kernel panic - not syncing: Fatal exception

--- Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> 
> On Tue, 10 Feb 2009, raksac@yahoo.com wrote:
> 
> >
> > Hello,
> >
> > I am running the 2.6.28 based xfs kernel driver on
> a
> > custom kernel with following kernel config
> enabled.
> >
> > CONFIG_PREEMPT
> > CONFIG_DETECT_SOFTLOCKUP
> >
> > Running the following xfsqa causes a soft lockup.
> The
> > configuration is a x86 with Hyperthreading, 4GB
> RAM
> > and a AHCI connected JBOD. Its 100% reproducible.
> >
> > Any suggestions/inputs on where to start debugging
> the
> > problem would be much appreciated.
> >
> > #! /bin/sh
> > # FS QA Test No. 008
> > #
> > # randholes test
> > #
> >
> > BUG: soft lockup detected on CPU#1!
> > [<4013d525>] softlockup_tick+0x9c/0xaf
> > [<40123246>] update_process_times+0x3d/0x60
> > [<401100ab>] smp_apic_timer_interrupt+0x52/0x58
> > [<40103633>] apic_timer_interrupt+0x1f/0x24
> > [<402a1557>] _spin_lock_irqsave+0x48/0x61
> > [<f8b8fe30>] xfs_iflush_cluster+0x16d/0x31c [xfs]
> > [<f8b9018b>] xfs_iflush+0x1ac/0x271 [xfs]
> > [<f8ba49a1>] xfs_inode_flush+0xd6/0xfa [xfs]
> > [<f8bb13c8>] xfs_fs_write_inode+0x27/0x40 [xfs]
> > [<401789d9>] __writeback_single_inode+0x1b0/0x2ff
> > [<40101ad5>] __switch_to+0x23/0x1f9
> > [<40178f87>] sync_sb_inodes+0x196/0x261
> > [<4017920a>] writeback_inodes+0x67/0xb1
> > [<401465df>] wb_kupdate+0x7b/0xe0
> > [<40146bc3>] pdflush+0x0/0x1b5
> > [<40146ce1>] pdflush+0x11e/0x1b5
> > [<40146564>] wb_kupdate+0x0/0xe0
> > [<4012be6d>] kthread+0xc1/0xec
> > [<4012bdac>] kthread+0x0/0xec
> > [<401038b3>] kernel_thread_helper+0x7/0x10
> > =======================
> >
> > Thanks,
> > Rakesh
> >
> >
> >
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> >
> 
> There were some pretty nasty bugs in 2.6.28 for XFS,
> can you reproduce it on 
> 2.6.28.4?
> 



      

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
