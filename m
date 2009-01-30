Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0UMOjwi055904 for <xfs@oss.sgi.com>; Fri, 30 Jan 2009 16:24:46 -0600
Received: from theco.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48E2318958DC
	for <xfs@oss.sgi.com>; Fri, 30 Jan 2009 14:24:02 -0800 (PST)
Received: from theco.de (scout.theco.de.mind.de [212.42.230.55]) by
	cuda.sgi.com with ESMTP id 4qLTvMtX98wLaC2F for
	<xfs@oss.sgi.com>; Fri, 30 Jan 2009 14:24:02 -0800 (PST)
Date: Fri, 30 Jan 2009 23:23:59 +0100
From: Ralf Liebenow <ralf@theco.de>
Subject: XFS Kernel 2.6.27.7 oopses 
Message-ID: <20090130222359.GB32142@theco.de>
Mime-Version: 1.0
Content-Disposition: inline
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

I heavily use XFS for an incremental backup server (by using rsync --link-d=
est option
to create hardlinks to unchanged files), and therefore have about 10 millio=
n files
on my TB Harddisk. To remove old versions nightly an "rm -rf" will remove a=
 million
hardlinks/files every night.

After a while I had regular oopses and so I updated the system to make sure=
 its
on a current version.

It is now a SuSE 11.1 64Bit with SuSE's Kernel 2.6.27.7-9-default

The Server is a Quad-Core Intel 64Bit with 8 GB RAM running a 64Bit Linux.
(I have vmware server 2 installed, so those modules can be seen in the kmes=
g,
but the OOPs happens also without them).

Now sometimes the "rm -rf" Job OOPses the kernel and get stuck (there is no
other measurable IO traffic on that system). The /proc/kmesg gives:

cat /proc/kmsg =

<0>general protection fault: 0000 [1] SMP =

<0>last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
<4>CPU 3 =

<4>Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device binf=
mt_mi =

sc vmnet(N) vsock(N) vmci(N) vmmon(N) nfsd lockd nfs_acl auth_rpcgss sunrpc=
 expo =

rtfs microcode fuse loop dm_mod snd_hda_intel st r8169 snd_pcm snd_timer os=
st sn =

d_page_alloc ppdev iTCO_wdt mii shpchp button rtc_cmos snd_hwdep pci_hotplu=
g par =

port_pc rtc_core sky2 ohci1394 intel_agp rtc_lib snd i2c_i801 iTCO_vendor_s=
uppor =

t ieee1394 parport pcspkr i2c_core sg soundcore raid456 async_xor async_mem=
cpy a =

sync_tx xor raid0 sd_mod crc_t10dif ehci_hcd uhci_hcd usbcore edd raid1 xfs=
 fan  =

ahci libata dock aic79xx scsi_transport_spi scsi_mod thermal processor ther=
mal_s =

ys hwmon
<4>Supported: No
<4>Pid: 5176, comm: xfssyncd Tainted: G          2.6.27.7-9-default #1
<4>RIP: 0010:[<ffffffff80230865>]  [<ffffffff80230865>] __wake_up_common+0x=
29/0x =

76
<4>RSP: 0018:ffff880114df9d30  EFLAGS: 00010086
<4>RAX: 7fff8800255b8a70 RBX: ffff8800255b8a60 RCX: 0000000000000000
<4>RDX: 0000000000000001 RSI: 0000000000000003 RDI: ffff8800255b8a68
<4>RBP: ffff880114df9d60 R08: 7fff8800255b8a58 R09: 0000000000000282
<4>R10: 0000000000000002 R11: ffff8800255b87c0 R12: 0000000000000001
<4>R13: 0000000000000282 R14: ffff8800255b8a70 R15: 0000000000000000
<4>FS:  0000000000000000(0000) GS:ffff88012fba0ec0(0000) knlGS:000000000000=
0000
<4>CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
<4>CR2: 00007f28d42a2000 CR3: 0000000124e34000 CR4: 00000000000006e0
<4>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<4>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>Process xfssyncd (pid: 5176, threadinfo ffff880114df8000, task ffff88012=
bc1e0 =

c0)
<4>Stack:  0000000300000000 ffff8800255b8a60 ffff8800255b8a68 0000000000000=
282
<4> ffff88012d802000 0000000000000001 ffff880114df9d90 ffffffff8023219a
<4> 0000000000000286 0000000000000000 ffff88006ef1d240 ffff88012aca3800
<4>Call Trace:
<4> [<ffffffff8023219a>] complete+0x38/0x4b
<4> [<ffffffffa00f5316>] xfs_iflush+0x73/0x2ab [xfs]
<4> [<ffffffffa010a7a2>] xfs_finish_reclaim+0x12a/0x168 [xfs]
<4> [<ffffffffa010a871>] xfs_finish_reclaim_all+0x91/0xcb [xfs]
<4> [<ffffffffa010925c>] xfs_syncsub+0x50/0x22b [xfs]
<4> [<ffffffffa0118a3a>] xfs_sync_worker+0x17/0x36 [xfs]
<4> [<ffffffffa01189d4>] xfssyncd+0x15d/0x1ac [xfs]
<4> [<ffffffff8025434d>] kthread+0x47/0x73
<4> [<ffffffff8020d7b9>] child_rip+0xa/0x11
<4>
<4>
<0>Code: c9 c3 55 48 89 e5 41 57 4d 89 c7 41 56 4c 8d 77 08 41 55 41 54 41 =
89 d4 =

 53 48 83 ec 08 89 75 d4 89 4d d0 48 8b 47 08 4c 8d 40 e8 <49> 8b 40 18 48 =
8d 58 =

 e8 eb 2d 45 8b 28 4c 89 f9 8b 55 d0 8b 75 =

<1>RIP  [<ffffffff80230865>] __wake_up_common+0x29/0x76
<4> RSP <ffff880114df9d30>
<4>---[ end trace a069bd11f2b4e6ab ]---

It _always_ gets stuck at the same place in "complete" of xfssyncd, so i do=
nt
think its hardware related.

I also always did a xfs_repair after very OOPS->Reboot, so the filesystem i=
tself
should be consistent.

I initilly used default settings for mkfs.xfs and mount. Now I use different
settings, but get the same OOPs again, it seems to be unrelated.

What do you recommend ? Has this bug already been addressed within the
hundrets of fixes I've seen on the mailing list ? Shall I try a stock 2.6.28
kernel ?

   Thanks in advance !

      Ralf
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
