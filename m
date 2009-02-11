Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1BNYC8m163166 for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 17:34:13 -0600
Received: from web30208.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 0801510EA3B
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 15:33:36 -0800 (PST)
Received: from web30208.mail.mud.yahoo.com (web30208.mail.mud.yahoo.com
	[209.191.69.55]) by cuda.sgi.com with SMTP id OWcBirFHiuVMymug
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 15:33:36 -0800 (PST)
Message-ID: <586998.47540.qm@web30208.mail.mud.yahoo.com>
Date: Wed, 11 Feb 2009 15:33:35 -0800 (PST)
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


Hi Justin,

Thank you for the pointer. Well as suggested I did and
now the xfsqa goes upto test 011 

#! /bin/sh
# FS QA Test No. 011
#
# dirstress

but dies with a oops. Any suggestions?

Here is the oops trace -

BUG: unable to handle kernel NULL pointer dereference
at virtual address 00000000
 printing eip:
f8bd02c2
*pde = e7167067
Oops: 0000 [#1]
PREEMPT SMP 
last sysfs file:
/devices/pci0000:00/0000:00:1f.3/i2c-0/0-002e/temp1_input
Modules linked in: xfs sg sunrpc m24c02 pca9554
pca9555 mcp23016 lm85 hwmon_vid i2c_i801 i2c_core
midplane uhci_hcd sk98lin tg3 e1000 mv_sata sd_mod
ahci libata
CPU:    1
EIP:    0060:[<f8bd02c2>]    Not tainted VLI
EFLAGS: 00010286   (2.6.18.rhel5 #2) 
EIP is at xfs_iget_core+0x4d6/0x5e9 [xfs]
eax: 00000000   ebx: e8ae7850   ecx: e79b2000   edx:
00000000
esi: e8ae7920   edi: ea44d2d0   ebp: ea44d298   esp:
e79b3ce4
ds: 007b   es: 007b   ss: 0068
Process dirstress (pid: 9927, ti=e79b2000
task=e790faa0 task.ti=e79b2000)
Stack: ea7b0034 e9072c00 ea2a6380 0003b84a e8ae7850
ea2a6380 02c9f600 00000004 
       e9072c00 f8bd0478 1003b84a 00000000 00000001
00000004 e79b3d5c 00000000 
       00000000 ea7b0034 e9072c00 ea7b0034 1003b84a
00000000 f8bebbf1 1003b84a 
Call Trace:
 [<f8bd0478>] xfs_iget+0xa3/0x12f [xfs]
 [<f8bebbf1>] xfs_trans_iget+0x1bd/0x249 [xfs]
 [<f8bd4ebe>] xfs_ialloc+0xb9/0x5a9 [xfs]
 [<f8bdc777>] xlog_grant_push_ail+0x105/0x12c [xfs]
 [<f8bec673>] xfs_dir_ialloc+0x7e/0x26b [xfs]
 [<f8be8c81>] xfs_trans_reserve+0x15c/0x240 [xfs]
 [<f8bf12c8>] xfs_symlink+0x34a/0x862 [xfs]
 [<401a62dd>] avc_has_perm_noaudit+0x38f/0x42d
 [<401a6e9d>] avc_has_perm+0x3b/0x46
 [<f8bf9d8e>] xfs_vn_symlink+0x6a/0xad [xfs]
 [<4016a06d>] vfs_symlink+0xb2/0x11a
 [<4016a149>] sys_symlinkat+0x74/0xab
 [<402a14c2>] _spin_lock+0xd/0x5a
 [<402a1593>] _spin_unlock+0xd/0x21
 [<4016f416>] dput+0x83/0x11c
 [<4015c89d>] __fput+0x152/0x175
 [<4016a18f>] sys_symlink+0xf/0x13
 [<40102b73>] syscall_call+0x7/0xb
 =======================
Code: 8b 40 08 a8 08 74 05 e8 6d ff 6c 47 8b 44 24 04
05 38 01 00 00 e8 24 02 6d 47 8b 44 24 04 8b 98 2c 01
00 00 85 db 74 3d 8b 43 04 <39> 18 74 14 b9 14 01 00
00 ba 20 8a c0 f8 b8 d8 8c c0 f8 e8 32 
EIP: [<f8bd02c2>] xfs_iget_core+0x4d6/0x5e9 [xfs]
SS:ESP 0068:e79b3ce4
 <0>Kernel panic - not syncing: Fatal exception

Thanks,
Rakesh

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
