Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n155dUdr193171 for <xfs@oss.sgi.com>; Wed, 4 Feb 2009 23:39:30 -0600
Received: from theco.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6ABBF18CA437
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 21:38:49 -0800 (PST)
Received: from theco.de (scout.theco.de.mind.de [212.42.230.55]) by
	cuda.sgi.com with ESMTP id Q6tXg0dFPjQsXaPz for
	<xfs@oss.sgi.com>; Wed, 04 Feb 2009 21:38:49 -0800 (PST)
Date: Thu, 5 Feb 2009 06:38:47 +0100
From: Ralf Liebenow <ralf@theco.de>
Subject: Re: XFS Kernel 2.6.27.7 oopses
Message-ID: <20090205053847.GA24841@theco.de>
References: <20090130222359.GB32142@theco.de>
	<20090201003744.GB24173@disturbed>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090201003744.GB24173@disturbed>
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

Finally I found the time to compile and test the latest stable 2.6.28.3 ker=
nel
but I can reproduce it:

Feb  5 03:00:19 up kernel: general protection fault: 0000 [#1] SMP
Feb  5 03:00:19 up kernel: last sysfs file: /sys/devices/system/cpu/cpu3/ca=
che/index2/shared_cpu_map
Feb  5 03:00:19 up kernel: CPU 2
Feb  5 03:00:19 up kernel: Modules linked in: vmnet parport_pc vsock vmci v=
mmon nfsd lockd nfs_acl auth_rpcgss snd_pcm_oss sunrpc snd_mi
xer_oss exportfs snd_seq snd_seq_device binfmt_misc microcode fuse loop dm_=
mod snd_hda_intel osst st snd_pcm snd_timer snd_page_alloc pp
dev shpchp rtc_cmos i2c_i801 rtc_core button snd_hwdep r8169 rtc_lib pcspkr=
 ohci1394 intel_agp mii i2c_core parport sky2 pci_hotplug iTC
O_wdt ieee1394 iTCO_vendor_support snd sg soundcore raid456 async_xor async=
_memcpy async_tx xor raid0 sd_mod crc_t10dif ehci_hcd uhci_hc
d usbcore edd raid1 xfs fan ahci libata aic79xx scsi_transport_spi scsi_mod=
 thermal processor thermal_sys hwmon [last unloaded: vmnet]
Feb  5 03:00:19 up kernel: Pid: 1462, comm: xfssyncd Not tainted 2.6.28.3-9=
-default #1
Feb  5 03:00:19 up kernel: RIP: 0010:[<ffffffff802327a1>]  [<ffffffff802327=
a1>] __wake_up_common+0x29/0x76
Feb  5 03:00:19 up kernel: RSP: 0018:ffff88012e56fcf0  EFLAGS: 00010086
Feb  5 03:00:19 up kernel: RAX: 7fff8800255b8a70 RBX: ffff8800255b8a60 RCX:=
 0000000000000000
Feb  5 03:00:19 up kernel: RDX: 0000000000000001 RSI: 0000000000000003 RDI:=
 ffff8800255b8a68
Feb  5 03:00:19 up kernel: RBP: ffff88012e56fd20 R08: 7fff8800255b8a58 R09:=
 ffff880129d02e18
Feb  5 03:00:19 up kernel: R10: 0000000000000002 R11: 0000000300000000 R12:=
 0000000000000001
Feb  5 03:00:19 up kernel: R13: 0000000000000286 R14: ffff8800255b8a70 R15:=
 0000000000000000
Feb  5 03:00:19 up kernel: FS:  0000000000000000(0000) GS:ffff88012fb2e8c0(=
0000) knlGS:0000000000000000
Feb  5 03:00:19 up kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Feb  5 03:00:19 up kernel: CR2: 00007f075ee9ab00 CR3: 0000000000201000 CR4:=
 00000000000006e0
Feb  5 03:00:19 up kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2:=
 0000000000000000
Feb  5 03:00:19 up kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:=
 0000000000000400
Feb  5 03:00:19 up kernel: Process xfssyncd (pid: 1462, threadinfo ffff8801=
2e56e000, task ffff88012c842640)
Feb  5 03:00:19 up kernel: Stack:
Feb  5 03:00:19 up kernel:  0000000300000000 ffff8800255b8a60 ffff8800255b8=
a68 0000000000000286
Feb  5 03:00:19 up kernel:  ffff88012b922000 ffff88012a1eb000 ffff88012e56f=
d50 ffffffff8023410a
Feb  5 03:00:19 up kernel:  ffff8800255b87c0 0000000000000000 ffff8800255b8=
980 ffff88004dc64140
Feb  5 03:00:19 up kernel: Call Trace:
Feb  5 03:00:20 up kernel:  [<ffffffff8023410a>] complete+0x38/0x4c
Feb  5 03:00:20 up kernel:  [<ffffffffa01a2424>] xfs_iflush+0x7a/0x2b2 [xfs]
Feb  5 03:00:20 up kernel:  [<ffffffff802241cc>] ? default_spin_lock_flags+=
0x17/0x1b
Feb  5 03:00:20 up kernel:  [<ffffffffa01b7cf9>] xfs_finish_reclaim+0x136/0=
x175 [xfs]
Feb  5 03:00:20 up kernel:  [<ffffffffa01b7dd0>] xfs_finish_reclaim_all+0x9=
8/0xd4 [xfs]
Feb  5 03:00:20 up kernel:  [<ffffffffa01b694c>] xfs_syncsub+0x55/0x22f [xf=
s]
Feb  5 03:00:20 up kernel:  [<ffffffffa01b6b68>] xfs_sync+0x42/0x47 [xfs]
Feb  5 03:00:20 up kernel:  [<ffffffffa01c55fd>] xfs_sync_worker+0x1f/0x41 =
[xfs]
Feb  5 03:00:20 up kernel:  [<ffffffffa01c558f>] xfssyncd+0x15d/0x1ac [xfs]
Feb  5 03:00:20 up kernel:  [<ffffffffa01c5432>] ? xfssyncd+0x0/0x1ac [xfs]
Feb  5 03:00:20 up kernel:  [<ffffffff802563e5>] kthread+0x49/0x76
Feb  5 03:00:20 up kernel:  [<ffffffff8020d659>] child_rip+0xa/0x11
Feb  5 03:00:20 up kernel:  [<ffffffff8025639c>] ? kthread+0x0/0x76
Feb  5 03:00:20 up kernel:  [<ffffffff8020d64f>] ? child_rip+0x0/0x11
Feb  5 03:00:20 up kernel: Code: c9 c3 55 48 89 e5 41 57 4d 89 c7 41 56 4c =
8d 77 08 41 55 41 54 41 89 d4 53 48 83 ec 08 89 75 d4 89 4d d
0 48 8b 47 08 4c 8d 40 e8 <49> 8b 40 18 48 8d 58 e8 eb 2d 45 8b 28 4c 89 f9=
 8b 55 d0 8b 75
Feb  5 03:00:20 up kernel: RIP  [<ffffffff802327a1>] __wake_up_common+0x29/=
0x76
Feb  5 03:00:20 up kernel:  RSP <ffff88012e56fcf0>
Feb  5 03:00:20 up kernel: ---[ end trace a0fbe14899a3ce1c ]---

So its not SuSEs fault, and its the latest stable kernel from kernel.org ..=
..

Hmmm ... can I do something to help you find the problem ? I can
reproduce it by creating some millon of hardlinks to files and then remove =
some
million hardlinks with one "rm -rf"

The Filesystem is 1 TB big.

Settings:
meta-data=3D/dev/sdd1              isize=3D256    agcount=3D32, agsize=3D76=
30937 blks
         =3D                       sectsz=3D512   attr=3D0
data     =3D                       bsize=3D4096   blocks=3D244189984, imaxp=
ct=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D32768, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D0
realtime =3Dnone                   extsz=3D65536  blocks=3D0, rtextents=3D0

[I originally had log version=3D1 but with the same problem. The problem oc=
curs
 with barriers=3Don and with barriers=3Doff ]

I have not tried to run the system with one CPU core yet, that maybe a thing
I can check tomorrow ...

   Thanks for your help
      Ralf


> On Fri, Jan 30, 2009 at 11:23:59PM +0100, Ralf Liebenow wrote:
> > Hello !
> > =

> > I heavily use XFS for an incremental backup server (by using rsync --li=
nk-dest option
> > to create hardlinks to unchanged files), and therefore have about 10 mi=
llion files
> > on my TB Harddisk. To remove old versions nightly an "rm -rf" will remo=
ve a million
> > hardlinks/files every night.
> > =

> > After a while I had regular oopses and so I updated the system to make =
sure its
> > on a current version.
> > =

> > It is now a SuSE 11.1 64Bit with SuSE's Kernel 2.6.27.7-9-default
> =

> What kernel did you originally see this problem on?
> =

> > <4>Call Trace:
> > <4> [<ffffffff8023219a>] complete+0x38/0x4b
> > <4> [<ffffffffa00f5316>] xfs_iflush+0x73/0x2ab [xfs]
> > <4> [<ffffffffa010a7a2>] xfs_finish_reclaim+0x12a/0x168 [xfs]
> > <4> [<ffffffffa010a871>] xfs_finish_reclaim_all+0x91/0xcb [xfs]
> > <4> [<ffffffffa010925c>] xfs_syncsub+0x50/0x22b [xfs]
> > <4> [<ffffffffa0118a3a>] xfs_sync_worker+0x17/0x36 [xfs]
> > <4> [<ffffffffa01189d4>] xfssyncd+0x15d/0x1ac [xfs]
> > <4> [<ffffffff8025434d>] kthread+0x47/0x73
> > <4> [<ffffffff8020d7b9>] child_rip+0xa/0x11
> =

> That may be a use after free. I know lachlan fixed a few in this
> area, but I'm not sure what release those fixe?? ended up in....
> =

> > What do you recommend ? Has this bug already been addressed within the
> > hundrets of fixes I've seen on the mailing list ? Shall I try a stock 2=
.6.28
> > kernel ?
> =

> Try the lastest 2.6.28.x stable kernel (*not* the straight 2.6.28 release
> as there's a directory traversal bug that is fixed in 2.6.28.1) and
> see if the problem persists.
> =

> Cheers,
> =

> Dave.
> -- =

> Dave Chinner
> david@fromorbit.com
> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

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
