Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1HCYPiH222811 for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 06:34:25 -0600
Received: from theco.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EDEC41953C4E
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 04:33:48 -0800 (PST)
Received: from theco.de (scout.theco.de.mind.de [212.42.230.55]) by
	cuda.sgi.com with ESMTP id nqENQlB14NpnfrkR for
	<xfs@oss.sgi.com>; Tue, 17 Feb 2009 04:33:48 -0800 (PST)
Date: Tue, 17 Feb 2009 13:33:46 +0100
From: Ralf Liebenow <ralf@theco.de>
Subject: Re: XFS Kernel 2.6.27.7 oopses
Message-ID: <20090217123346.GA22138@theco.de>
References: <20090130222359.GB32142@theco.de>
	<20090201003744.GB24173@disturbed>
	<20090205053847.GA24841@theco.de> <20090210095045.GL8830@disturbed>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090210095045.GL8830@disturbed>
Reply-To: ralf@theco.de
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello !

More testing reveals the same problem with a different oops ..
I did the remove again, and that worked without oops, but the oops
happens shortly after, when the machine needed to swap/reorganice memory,
and kswapd tried to cleanup/reclaim inode space.

It looks like the there are invalid (nulled) inodes in an (freed ?) inode
list, which generates oopses whenever a process tries to cleanup/reclaim th=
em.

Is there a debugging/compile time option I can use to checkup that an
inode pointer is valid and usable ??

  Thanks !!

     Ralf

Feb 17 12:13:53 up kernel: general protection fault: 0000 [#1] SMP
Feb 17 12:13:53 up kernel: last sysfs file: /sys/devices/system/cpu/cpu3/ca=
che/index2/shared_cpu_map
Feb 17 12:13:53 up kernel: CPU 1
Feb 17 12:13:53 up kernel: Modules linked in: vmnet vsock vmci vmmon snd_pc=
m_oss snd_mixer_oss snd_seq snd_seq_device binfmt_misc nfsd lockd n
fs_acl auth_rpcgss sunrpc exportfs microcode fuse loop dm_mod snd_hda_intel=
 osst snd_pcm st snd_timer rtc_cmos ppdev snd_page_alloc shpchp r81
69 snd_hwdep parport_pc rtc_core i2c_i801 ohci1394 iTCO_wdt snd parport mii=
 intel_agp button rtc_lib ieee1394 pcspkr pci_hotplug iTCO_vendor_s
upport i2c_core sky2 sg soundcore raid456 async_xor async_memcpy async_tx x=
or raid0 sd_mod crc_t10dif ehci_hcd uhci_hcd usbcore edd raid1 xfs
fan ahci libata aic79xx scsi_transport_spi scsi_mod thermal processor therm=
al_sys hwmon
Feb 17 12:13:53 up kernel: Pid: 38, comm: kswapd0 Not tainted 2.6.28.3-9-de=
fault #1
Feb 17 12:13:53 up kernel: RIP: 0010:[<ffffffffa01a1cf3>]  [<ffffffffa01a1c=
f3>] xfs_idestroy_fork+0x1f/0xca [xfs]
Feb 17 12:13:53 up kernel: RSP: 0018:ffff88012bb05bd0  EFLAGS: 00010202
Feb 17 12:13:53 up kernel: RAX: ffff8800813dcb80 RBX: 1000000000000000 RCX:=
 ffff8800813dcb00
Feb 17 12:13:53 up kernel: RDX: ffff8800813dcb80 RSI: 0000000000000001 RDI:=
 ffff8800813dcb00
Feb 17 12:13:53 up kernel: RBP: ffff88012bb05bf0 R08: ffff88012bb05d1b R09:=
 a55a5a5a5a5a5a5a
Feb 17 12:13:53 up kernel: R10: ffa5a5a5a5a5a5a5 R11: 0000000300000000 R12:=
 ffff8800813dcb00
Feb 17 12:13:53 up kernel: R13: 0000000000000001 R14: ffff88012bb05d1b R15:=
 ffff88012dc81000
Feb 17 12:13:53 up kernel: FS:  0000000000000000(0000) GS:ffff88012fac22c0(=
0000) knlGS:0000000000000000
Feb 17 12:13:53 up kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Feb 17 12:13:53 up kernel: CR2: 00007f9e560ef000 CR3: 00000000993b2000 CR4:=
 00000000000006e0
Feb 17 12:13:53 up kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2:=
 0000000000000000
Feb 17 12:13:53 up kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:=
 0000000000000400
Feb 17 12:13:53 up kernel: Process kswapd0 (pid: 38, threadinfo ffff88012bb=
04000, task ffff88012bb02180)
Feb 17 12:13:53 up kernel: Stack:
Feb 17 12:13:53 up kernel:  ffff8800813dcb00 ffff8800813dcb00 ffff8800813dc=
b00 ffff88009fa38240
Feb 17 12:13:53 up kernel:  ffff88012bb05c20 ffffffffa01a1dec ffff8800813dc=
b00 ffff8800813dcb00
Feb 17 12:13:53 up kernel:  ffff88009fa38240 ffff88012bb05d1b ffff88012bb05=
c40 ffffffffa019f4c6
Feb 17 12:13:53 up kernel: Call Trace:
Feb 17 12:13:53 up kernel:  [<ffffffffa01a1dec>] xfs_idestroy+0x4e/0xbc [xf=
s]
Feb 17 12:13:53 up kernel:  [<ffffffffa019f4c6>] xfs_ireclaim+0x83/0x87 [xf=
s]
Feb 17 12:13:53 up kernel:  [<ffffffffa01b7d5e>] xfs_finish_reclaim+0x167/0=
x175 [xfs]
Feb 17 12:13:53 up kernel:  [<ffffffffa01b7eb6>] xfs_reclaim+0x76/0x10e [xf=
s]
Feb 17 12:13:53 up kernel:  [<ffffffffa01c41db>] xfs_fs_clear_inode+0xf1/0x=
115 [xfs]
Feb 17 12:13:53 up kernel:  [<ffffffff802d225f>] clear_inode+0x79/0xd2
Feb 17 12:13:53 up kernel:  [<ffffffff802d236f>] dispose_list+0x68/0x138
Feb 17 12:13:53 up kernel:  [<ffffffff802d264a>] shrink_icache_memory+0x20b=
/0x241
Feb 17 12:13:53 up kernel:  [<ffffffff802961eb>] shrink_slab+0xe3/0x158
Feb 17 12:13:53 up kernel:  [<ffffffff802969b2>] kswapd+0x4b2/0x63d
Feb 17 12:13:53 up kernel:  [<ffffffff80294011>] ? isolate_pages_global+0x0=
/0x22d
Feb 17 12:13:53 up kernel:  [<ffffffff80256758>] ? autoremove_wake_function=
+0x0/0x38
Feb 17 12:13:53 up kernel:  [<ffffffff80296500>] ? kswapd+0x0/0x63d
Feb 17 12:13:53 up kernel:  [<ffffffff802563e5>] kthread+0x49/0x76
Feb 17 12:13:53 up kernel:  [<ffffffff8020d659>] child_rip+0xa/0x11
Feb 17 12:13:53 up kernel:  [<ffffffff8025639c>] ? kthread+0x0/0x76
Feb 17 12:13:53 up kernel:  [<ffffffff8020d64f>] ? child_rip+0x0/0x11
Feb 17 12:13:53 up kernel: Code: be 03 00 00 00 e8 9a 24 09 e0 c9 c3 55 48 =
89 e5 41 55 41 89 f5 41 54 49 89 fc 53 48 8d 5f 60 48 83 ec 08 85 f
6 74 04 48 8b 5f 58 <48> 8b 7b 08 48 85 ff 74 0d e8 81 9e 01 00 48 c7 43 08=
 00 00 00
Feb 17 12:13:53 up kernel: RIP  [<ffffffffa01a1cf3>] xfs_idestroy_fork+0x1f=
/0xca [xfs]
Feb 17 12:13:53 up kernel:  RSP <ffff88012bb05bd0>
Feb 17 12:13:53 up kernel: ---[ end trace 564bbbd2e5103836 ]---

> On Thu, Feb 05, 2009 at 06:38:47AM +0100, Ralf Liebenow wrote:
> > Hello !
> > =

> > Finally I found the time to compile and test the latest stable 2.6.28.3=
 kernel
> > but I can reproduce it:
> =

> OK.
> =

> .....
> =

> > Hmmm ... can I do something to help you find the problem ? I can
> > reproduce it by creating some millon of hardlinks to files and then rem=
ove some
> > million hardlinks with one "rm -rf"
> =

> Interesting. Sounds like a race between writing back the inode and
> it being freed. How long does it take to reproduce the problem?
> Do you have a script that you could share?
> =

> Next question - what is the setting of ikeep/noikeep in your mount
> options? If you dump /proc/self/mounts on 2.6.28 it will tell us
> if inode clusters are being deleted or not....
> =

> Cheers,
> =

> Dave.
> -- =

> Dave Chinner
> david@fromorbit.com
> =


-- =

theCode AG =

HRB 78053, Amtsgericht Charlottenbg
USt-IdNr.: DE204114808
Vorstand: Ralf Liebenow, Michael Oesterreich, Peter Witzel
Aufsichtsratsvorsitzender: Wolf von Jaduczynski
Oranienstr. 10-11, 10997 Berlin [=D7]
fon +49 30 617 897-0  fax -10
ralf@theCo.de http://www.theCo.de

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
