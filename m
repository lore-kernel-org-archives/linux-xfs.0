Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Apr 2008 20:20:52 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3F3KUrC026108
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2008 20:20:31 -0700
Received: from outhouse.melbourne.sgi.com (outhouse.melbourne.sgi.com [134.14.52.145])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D27B28F8057
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2008 20:21:04 -0700 (PDT)
Received: from itchy (xaiki@itchy.melbourne.sgi.com [134.14.55.96])
	by outhouse.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id m3F3L1jm443889
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2008 13:21:02 +1000 (AEST)
From: Niv Sardi <xaiki@debian.org>
Subject: [Jens Reinsberger] Bug#476181: linux-image-2.6.22-3-vserver-k7: Oops (NULL pointer dereference), XFS fs related
Date: Tue, 15 Apr 2008 10:58:58 +1000
Received: (from majordom@localhost)
        by kraftwerk.corp.sgi.com (8.12.9/8.11.4/ils-2.0) id m3F0x78T25970032;
        Mon, 14 Apr 2008 17:59:07 -0700 (PDT)
	mail_from (owner-xfs-dev@kraftwerk.corp.sgi.com)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
        by kraftwerk.corp.sgi.com (8.12.9/8.11.4/ils-2.0) with ESMTP id m3F0x71U25967573
        for <xfs-dev@ils.sgi.com>; Mon, 14 Apr 2008 17:59:07 -0700 (PDT)
	mail_from (xaiki@cxhome.ath.cx)
Received: from outhouse.melbourne.sgi.com (outhouse.melbourne.sgi.com [134.14.52.145])
	by netops-testserver-3.corp.sgi.com (Postfix) with ESMTP id 0B82E9088F
	for <xfs-dev@sgi.com>; Mon, 14 Apr 2008 17:59:03 -0700 (PDT)
Received: from itchy (xaiki@itchy.melbourne.sgi.com [134.14.55.96])
	by outhouse.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id m3F0wxjm441742
	for <xfs-dev@sgi.com>; Tue, 15 Apr 2008 10:59:00 +1000 (AEST)
Message-ID: <nccy77fkdlu.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--=-=-=


This was reported to the Debian BTS[0], Does anybody of you remember an
issue like this that we might have fixed allready (this is 2.6.22) ? if
not, it looks like a bug.

Cheers.

[0] http://bugs.debian.org/47618


--=-=-=
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: <bounce-debian-kernel=xaiki+deb=cxhome.ath.cx@lists.debian.org>
X-Original-To: xaiki+deb@sceen.net
Delivered-To: xaiki+deb@sceen.net
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.sceen.net (Postfix) with ESMTP id A56591E362
	for <xaiki+deb@sceen.net>; Tue, 15 Apr 2008 01:13:54 +0200 (CEST)
Received: from mail.sceen.net ([127.0.0.1])
	by localhost (mail.sceen.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 23710-07 for <xaiki+deb@sceen.net>;
	Tue, 15 Apr 2008 01:13:47 +0200 (CEST)
Received: from liszt.debian.org (liszt.debian.org [82.195.75.100])
	by mail.sceen.net (Postfix) with ESMTP id 5D3631E2CE
	for <xaiki+deb@cxhome.ath.cx>; Tue, 15 Apr 2008 01:13:47 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by liszt.debian.org (Postfix) with QMQP
	id 9ECB913A4F3E; Mon, 14 Apr 2008 22:42:17 +0000 (UTC)
Old-Return-Path: <debbugs@rietz.debian.org>
X-Original-To: debian-kernel@lists.debian.org
Delivered-To: lists-debian-kernel@liszt.debian.org
Received: from rietz.debian.org (rietz.debian.org [140.211.166.43])
	by liszt.debian.org (Postfix) with ESMTP id F13E013A5300;
	Mon, 14 Apr 2008 22:26:03 +0000 (UTC)
Received: from debbugs by rietz.debian.org with local (Exim 4.63)
	(envelope-from <debbugs@rietz.debian.org>)
	id 1JlWy7-0004sX-3C; Mon, 14 Apr 2008 22:16:07 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#476181: linux-image-2.6.22-3-vserver-k7: Oops (NULL pointer dereference), XFS fs related
Reply-To: Jens Reinsberger <jennes@gmx.de>, 476181@bugs.debian.org
Resent-From: Jens Reinsberger <jennes@gmx.de>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Cc: Debian Kernel Team <debian-kernel@lists.debian.org>
Resent-Date: Mon, 14 Apr 2008 22:16:03 +0000
Resent-Message-ID: <handler.476181.B.120821113220162@bugs.debian.org>
X-Debian-PR-Message: report 476181
X-Debian-PR-Package: linux-image-2.6.22-3-vserver-k7
X-Debian-PR-Keywords: 
X-Debian-PR-Source: linux-2.6
Received: via spool by submit@bugs.debian.org id=B.120821113220162
          (code B ref -1); Mon, 14 Apr 2008 22:16:03 +0000
Received: (at submit) by bugs.debian.org; 14 Apr 2008 22:12:12 +0000
X-Amavis-Spam-Status: No, score=-5.9 required=4.0 tests=BAYES_00,FORGED_RCVD_HELO,
	FOURLA,FVGT_m_MULTI_ODD,HAS_PACKAGE,IMPRONONCABLE_1,IMPRONONCABLE_2,
	MURPHY_WRONG_WORD1,MURPHY_WRONG_WORD2,PHONENUMBER autolearn=no
	version=3.1.4-bugs.debian.org_2005_01_02
Received: from crusoe.purzelgasse.de ([85.25.96.52] helo=crusoe.porzellan)
	by rietz.debian.org with esmtp (Exim 4.63)
	(envelope-from <jennes@gmx.de>)
	id 1JlWUS-0003Ks-Cx
	for submit@bugs.debian.org; Mon, 14 Apr 2008 21:45:41 +0000
Received: from jennes by crusoe.porzellan with local (Exim 4.69)
	(envelope-from <jennes@gmx.de>)
	id 1JlWUM-0004Uk-63; Mon, 14 Apr 2008 23:45:22 +0200
From: Jens Reinsberger <jennes@gmx.de>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Message-ID: <20080414214522.16862.41939.reportbug@crusoe.porzellan>
X-Mailer: reportbug 3.39
Date: Mon, 14 Apr 2008 23:45:22 +0200
Delivered-To: submit@bugs.debian.org
Resent-Date: Mon, 14 Apr 2008 22:16:07 +0000
X-Rc-Spam: 2007-10-04_01
X-Rc-Virus: 2007-09-13_01
X-Rc-Spam: 2007-10-04_01
X-Mailing-List: <debian-kernel@lists.debian.org> archive/latest/36784
X-Loop: debian-kernel@lists.debian.org
List-Id: <debian-kernel.lists.debian.org>
List-URL: <http://lists.debian.org/debian-kernel/>
List-Post: <mailto:debian-kernel@lists.debian.org>
List-Help: <mailto:debian-kernel-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-kernel-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-kernel-request@lists.debian.org?subject=unsubscribe>
Precedence: list
Resent-Sender: debian-kernel-request@lists.debian.org
X-Virus-Scanned: by amavisd-new-20030616-p10 (Debian) at sceen.net
MIME-Version: 1.0

Package: linux-image-2.6.22-3-vserver-k7
Version: 2.6.22-6
Severity: important

This error occured while bacula run its normal backup. It's the first
time this happened. For that reason I conclude it will be
difficult/impossible to reproduce this error, as bacula normally went
through the backup process without any error with the very same
configuration.

All file systems are XFS on LVM devices.

Regards,
Jens

-- Package-specific info:
** Version:
Linux version 2.6.22-3-vserver-k7 (Debian 2.6.22-6) (maks@debian.org) (gcc version 4.1.3 20071019 (prerelease) (Debian 4.1.2-17)) #1 SMP Mon Nov 12 11:47:04 UTC 2007

** Not tainted

** Kernel log:
BUG: unable to handle kernel NULL pointer dereference at virtual address 0000004d
 printing eip:
f8ca357d
*pde = 00000000
Oops: 0000 [#1]
SMP 
Modules linked in: nfs nfsd exportfs lockd nfs_acl sunrpc ipt_REJECT ipt_recent xt_state ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nfnetlink iptable_filter ppdev lp button ac battery tun xt_TCPMSS xt_tcpmss xt_tcpudp iptable_mangle ip_tables x_tables ppp_deflate zlib_deflate bsd_comp ppp_async ppp_generic ipv6 xfs ext2 fuse it87 hwmon_vid i2c_isa i2c_dev hisax_fcpcipnp hisax_isac hisax crc_ccitt isdn snd_intel8x0 rtc snd_ac97_codec slhc ac97_bus snd_pcm_oss snd_mixer_oss pcspkr parport_pc parport snd_pcm snd_timer snd soundcore snd_page_alloc shpchp pci_hotplug nvidia_agp i2c_nforce2 agpgart i2c_core usblp evdev ext3 jbd mbcache dm_mirror dm_snapshot dm_mod sg sr_mod cdrom ide_disk 8139cp usbhid hid generic amd74xx 8139too sym53c8xx scsi_transport_spi pdc202xx_new ide_core e100 mii sata_nv ata_generic libata scsi_mod ehci_hcd ohci_hcd usbcore thermal processor fan
CPU:    0
EIP:    0060:[<f8ca357d>]    Not tainted VLI
EFLAGS: 00010206   (2.6.22-3-vserver-k7 #1)
EIP is at xfs_iget_core+0x3f/0x5eb [xfs]
eax: 00000000   ebx: 00000011   ecx: f6b80800   edx: 000001cc
esi: f5c61590   edi: 00000000   ebp: f5c61594   esp: ede07cc0
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process bacula-fd (pid: 16343[#0], ti=ede06000 task=efe88050 task.ti=ede06000)
Stack: dfcd6600 c18a66bc f8ccd59b c0184878 dcceae3c e2a35e40 00000000 f6b80800 
       dcceae20 00000011 dcceae3c dcceae20 00000000 f6b80800 f8ca3bc0 010001cc 
       00000000 00000000 00000000 ede07d78 00000000 00000000 00000000 ede07d70 
Call Trace:
 [<f8ccd59b>] xfs_fs_alloc_inode+0xf/0x1c [xfs]
 [<c0184878>] alloc_inode+0xe5/0x16d
 [<f8ca3bc0>] xfs_iget+0x97/0x11f [xfs]
 [<f8cbb21e>] xfs_dir_lookup_int+0x7d/0xd4 [xfs]
 [<f8cbe45a>] xfs_lookup+0x52/0x78 [xfs]
 [<f8ccac80>] xfs_vn_lookup+0x3b/0x70 [xfs]
 [<c0179c8e>] do_lookup+0x1f8/0x295
 [<f8cca73f>] xfs_vn_permission+0xf/0x13 [xfs]
 [<f8cca730>] xfs_vn_permission+0x0/0x13 [xfs]
 [<c0179f3d>] permission+0x212/0x24b
 [<c018316f>] __d_lookup+0x96/0xf4
 [<c017bad5>] __link_path_walk+0x7fd/0xc72
 [<c0179f3d>] permission+0x212/0x24b
 [<c0186b70>] mntput_no_expire+0x11/0x68
 [<c017bff3>] link_path_walk+0xa9/0xb3
 [<c017bf8e>] link_path_walk+0x44/0xb3
 [<c017c26e>] do_path_lookup+0x15a/0x175
 [<c017b017>] getname+0x59/0x8f
 [<c017ca68>] __user_walk_fd+0x2f/0x45
 [<c0176473>] vfs_lstat_fd+0x16/0x3d
 [<c01764df>] sys_lstat64+0xf/0x23
 [<c017e58c>] filldir64+0x0/0xc5
 [<c0103d12>] sysenter_past_esp+0x6b/0xa1
 =======================
Code: 1c 8b 44 24 3c 31 d2 f7 b1 1c 01 00 00 6b f2 0c 03 b1 20 01 00 00 8d 6e 04 89 e8 e8 71 2e 61 c7 8b 06 e9 c6 01 00 00 8b 44 24 40 <39> 43 3c 0f 85 b6 01 00 00 8b 54 24 3c 39 53 38 0f 85 a9 01 00 
EIP: [<f8ca357d>] xfs_iget_core+0x3f/0x5eb [xfs] SS:ESP 0068:ede07cc0

** Loaded modules:
Module                  Size  Used by
nfs                   226476  0 
nfsd                  205360  17 
exportfs                5952  1 nfsd
lockd                  61192  3 nfs,nfsd
nfs_acl                 3840  2 nfs,nfsd
sunrpc                159164  13 nfs,nfsd,lockd,nfs_acl
ipt_REJECT              4736  3 
ipt_recent              9176  2 
xt_state                2752  5 
ipt_MASQUERADE          3904  2 
iptable_nat             7556  1 
nf_nat                 18348  2 ipt_MASQUERADE,iptable_nat
nf_conntrack_ipv4      18124  7 iptable_nat
nf_conntrack           61000  5 xt_state,ipt_MASQUERADE,iptable_nat,nf_nat,nf_conntrack_ipv4
nfnetlink               6168  3 nf_nat,nf_conntrack_ipv4,nf_conntrack
iptable_filter          3264  1 
ppdev                   9028  0 
lp                     11300  0 
button                  8208  0 
ac                      5508  0 
battery                10308  0 
tun                    11008  1 
xt_TCPMSS               4992  2 
xt_tcpmss               2496  2 
xt_tcpudp               3392  13 
iptable_mangle          3136  1 
ip_tables              12708  3 iptable_nat,iptable_filter,iptable_mangle
x_tables               14660  9 ipt_REJECT,ipt_recent,xt_state,ipt_MASQUERADE,iptable_nat,xt_TCPMSS,xt_tcpmss,xt_tcpudp,ip_tables
ppp_deflate             6080  0 
zlib_deflate           18264  1 ppp_deflate
bsd_comp                5824  0 
ppp_async              11456  2 
ppp_generic            26580  11 ppp_deflate,bsd_comp,ppp_async
ipv6                  239652  54 
xfs                   508184  5 
ext2                   63880  1 
fuse                   42452  1 
it87                   18000  0 
hwmon_vid               3264  1 it87
i2c_isa                 4480  1 it87
i2c_dev                 7492  0 
hisax_fcpcipnp         11968  1 
hisax_isac              8724  1 hisax_fcpcipnp
hisax                 440128  2 hisax_fcpcipnp,hisax_isac
crc_ccitt               2432  2 ppp_async,hisax
isdn                  124512  5 hisax
snd_intel8x0           32412  0 
rtc                    13144  0 
snd_ac97_codec         93220  1 snd_intel8x0
slhc                    6464  2 ppp_generic,isdn
ac97_bus                2560  1 snd_ac97_codec
snd_pcm_oss            39968  0 
snd_mixer_oss          15872  1 snd_pcm_oss
pcspkr                  3392  0 
parport_pc             34212  1 
parport                34312  3 ppdev,lp,parport_pc
snd_pcm                72836  3 snd_intel8x0,snd_ac97_codec,snd_pcm_oss
snd_timer              21380  1 snd_pcm
snd                    48868  6 snd_intel8x0,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer
soundcore               7840  1 snd
snd_page_alloc         10376  2 snd_intel8x0,snd_pcm
shpchp                 31380  0 
pci_hotplug            29568  1 shpchp
nvidia_agp              8732  1 
i2c_nforce2             6144  0 
agpgart                32264  1 nvidia_agp
i2c_core               24000  4 it87,i2c_isa,i2c_dev,i2c_nforce2
usblp                  13632  0 
evdev                   9664  3 
ext3                  125512  3 
jbd                    55848  1 ext3
mbcache                 8580  2 ext2,ext3
dm_mirror              21376  0 
dm_snapshot            17252  0 
dm_mod                 53120  16 dm_mirror,dm_snapshot
sg                     33116  0 
sr_mod                 16868  0 
cdrom                  33184  1 sr_mod
ide_disk               16832  12 
8139cp                 22528  0 
usbhid                 26144  0 
hid                    25792  1 usbhid
generic                 5124  0 [permanent]
amd74xx                13788  0 [permanent]
8139too                25984  0 
sym53c8xx              68756  0 
scsi_transport_spi     23424  1 sym53c8xx
pdc202xx_new            7488  0 [permanent]
ide_core              114436  4 ide_disk,generic,amd74xx,pdc202xx_new
e100                   34444  0 
mii                     5696  3 8139cp,8139too,e100
sata_nv                18948  0 
ata_generic             7876  0 
libata                117232  2 sata_nv,ata_generic
scsi_mod              137356  5 sg,sr_mod,sym53c8xx,scsi_transport_spi,libata
ehci_hcd               31116  0 
ohci_hcd               20036  0 
usbcore               126088  5 usblp,usbhid,ehci_hcd,ohci_hcd
thermal                13768  0 
processor              31560  1 thermal
fan                     5124  0 

** PCI devices:
00:00.0 Host bridge [0600]: nVidia Corporation nForce2 IGP2 [10de:01e0] (rev c1)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at d8000000 (32-bit, prefetchable) [size=64M]
	Capabilities: <access denied>
	Kernel driver in use: agpgart-nvidia
	Kernel modules: nvidia-agp

00:00.1 RAM memory [0500]: nVidia Corporation nForce2 Memory Controller 1 [10de:01eb] (rev c1)
	Subsystem: nVidia Corporation Unknown device [10de:0c17]
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.2 RAM memory [0500]: nVidia Corporation nForce2 Memory Controller 4 [10de:01ee] (rev c1)
	Subsystem: nVidia Corporation Unknown device [10de:0c17]
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.3 RAM memory [0500]: nVidia Corporation nForce2 Memory Controller 3 [10de:01ed] (rev c1)
	Subsystem: nVidia Corporation Unknown device [10de:0c17]
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.4 RAM memory [0500]: nVidia Corporation nForce2 Memory Controller 2 [10de:01ec] (rev c1)
	Subsystem: nVidia Corporation Unknown device [10de:0c17]
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.5 RAM memory [0500]: nVidia Corporation nForce2 Memory Controller 5 [10de:01ef] (rev c1)
	Subsystem: nVidia Corporation Unknown device [10de:0c17]
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:01.0 ISA bridge [0601]: nVidia Corporation MCP2A ISA bridge [10de:0080] (rev a3)
	Subsystem: Giga-byte Technology Unknown device [1458:0c11]
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>

00:01.1 SMBus [0c05]: nVidia Corporation MCP2A SMBus [10de:0084] (rev a1)
	Subsystem: Giga-byte Technology Unknown device [1458:0c11]
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 9
	Region 0: I/O ports at d000 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: nForce2_smbus
	Kernel modules: i2c-nforce2

00:02.0 USB Controller [0c03]: nVidia Corporation MCP2A USB Controller [10de:0087] (rev a1) (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology Unknown device [1458:5004]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at e0003000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:02.1 USB Controller [0c03]: nVidia Corporation MCP2A USB Controller [10de:0087] (rev a1) (prog-if 10 [OHCI])
	Subsystem: Giga-byte Technology Unknown device [1458:5004]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at e0004000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:02.2 USB Controller [0c03]: nVidia Corporation MCP2A USB Controller [10de:0088] (rev a2) (prog-if 20 [EHCI])
	Subsystem: Giga-byte Technology Unknown device [1458:5004]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin C routed to IRQ 16
	Region 0: Memory at e0005000 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:06.0 Multimedia audio controller [0401]: nVidia Corporation MCP2S AC'97 Audio Controller [10de:008a] (rev a1)
	Subsystem: Giga-byte Technology Unknown device [1458:a002]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (500ns min, 1250ns max)
	Interrupt: pin A routed to IRQ 17
	Region 0: I/O ports at b000 [size=256]
	Region 1: I/O ports at b400 [size=128]
	Region 2: Memory at e0001000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: Intel ICH
	Kernel modules: snd-intel8x0

00:08.0 PCI bridge [0604]: nVidia Corporation MCP2A PCI Bridge [10de:008b] (rev a3) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 00007000-00009fff
	Memory behind bridge: de000000-dfffffff
	Prefetchable memory behind bridge: 50000000-501fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR+
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Kernel modules: shpchp

00:09.0 IDE interface [0101]: nVidia Corporation MCP2A IDE [10de:0085] (rev a3) (prog-if 8a [Master SecP PriP])
	Subsystem: Giga-byte Technology Unknown device [1458:5002]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	Region 4: I/O ports at f000 [size=16]
	Capabilities: <access denied>
	Kernel driver in use: AMD_IDE
	Kernel modules: amd74xx

00:0b.0 IDE interface [0101]: nVidia Corporation nForce2 Serial ATA Controller [10de:008e] (rev a3) (prog-if 85 [Master SecO PriO])
	Subsystem: Giga-byte Technology Unknown device [1458:b002]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at 09f0 [size=8]
	Region 1: I/O ports at 0bf0 [size=4]
	Region 2: I/O ports at 0970 [size=8]
	Region 3: I/O ports at 0b70 [size=4]
	Region 4: I/O ports at e400 [size=16]
	Region 5: I/O ports at e800 [size=128]
	Capabilities: <access denied>
	Kernel driver in use: sata_nv
	Kernel modules: sata_nv

00:1e.0 PCI bridge [0604]: nVidia Corporation nForce2 AGP [10de:01e8] (rev c1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: dc000000-ddffffff
	Prefetchable memory behind bridge: d0000000-d7ffffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Kernel modules: shpchp

01:06.0 Ethernet controller [0200]: Intel Corporation 82557/8/9/0/1 Ethernet Pro 100 [8086:1229] (rev 08)
	Subsystem: Intel Corporation EtherExpress PRO/100+ Management Adapter [8086:000c]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at df104000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at 7000 [size=64]
	Region 2: Memory at df000000 (32-bit, non-prefetchable) [size=1M]
	[virtual] Expansion ROM at 50000000 [disabled] [size=1M]
	Capabilities: <access denied>
	Kernel driver in use: e100
	Kernel modules: e100, eepro100

01:07.0 Mass storage controller [0180]: Promise Technology, Inc. PDC20268 (Ultra100 TX2) [105a:4d68] (rev 02) (prog-if 85)
	Subsystem: Promise Technology, Inc. Ultra100TX2 [105a:4d68]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (1000ns min, 4500ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: I/O ports at 7400 [size=8]
	Region 1: I/O ports at 7800 [size=4]
	Region 2: I/O ports at 7c00 [size=8]
	Region 3: I/O ports at 8000 [size=4]
	Region 4: I/O ports at 8400 [size=16]
	Region 5: Memory at df100000 (32-bit, non-prefetchable) [size=16K]
	Expansion ROM at 50100000 [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: Promise_IDE
	Kernel modules: pdc202xx_new

01:08.0 SCSI storage controller [0100]: LSI Logic / Symbios Logic 53c810 [1000:0001] (rev 11)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (2000ns min, 16000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 21
	Region 0: I/O ports at 8800 [size=256]
	Region 1: Memory at df105000 (32-bit, non-prefetchable) [size=256]
	Kernel driver in use: sym53c8xx
	Kernel modules: sym53c8xx

01:09.0 Network controller [0280]: Cologne Chip Designs GmbH ISDN network controller [HFC-PCI] [1397:2bd0] (rev 02)
	Subsystem: Cologne Chip Designs GmbH ISDN Board [1397:2bd0]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 16 (4000ns max)
	Interrupt: pin A routed to IRQ 9
	Region 0: I/O ports at 8c00 [size=8]
	Region 1: Memory at df106000 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>
	Kernel modules: hisax

01:0a.0 Network controller [0280]: AVM Audiovisuelles MKTG & Computer System GmbH A1 ISDN [Fritz] [1244:0a00] (rev 02)
	Subsystem: AVM Audiovisuelles MKTG & Computer System GmbH FRITZ!Card ISDN Controller [1244:0a00]
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at df107000 (32-bit, non-prefetchable) [size=32]
	Region 1: I/O ports at 9000 [size=32]
	Kernel driver in use: fcpci
	Kernel modules: hisax, hisax_fcpcipnp

01:0b.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ [10ec:8139] (rev 10)
	Subsystem: Giga-byte Technology GA-7VM400M/7VT600 Motherboard [1458:e000]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (8000ns min, 16000ns max)
	Interrupt: pin A routed to IRQ 21
	Region 0: I/O ports at 9400 [size=256]
	Region 1: Memory at df108000 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>
	Kernel driver in use: 8139too
	Kernel modules: 8139too, 8139cp

02:00.0 VGA compatible controller [0300]: ATI Technologies Inc Radeon RV100 QY [Radeon 7000/VE] [1002:5159] (prog-if 00 [VGA controller])
	Subsystem: Hightech Information System Ltd. Unknown device [1787:2202]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (2000ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 12
	Region 0: Memory at d0000000 (32-bit, prefetchable) [size=128M]
	Region 1: I/O ports at a000 [size=256]
	Region 2: Memory at dd000000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at dc000000 [disabled] [size=128K]
	Capabilities: <access denied>
	Kernel modules: radeonfb



-- System Information:
Debian Release: lenny/sid
  APT prefers testing
  APT policy: (990, 'testing'), (500, 'stable'), (1, 'unstable')
Architecture: i386 (i686)

Kernel: Linux 2.6.22-3-vserver-k7 (SMP w/1 CPU core)
Locale: LANG=de_DE.UTF-8, LC_CTYPE=de_DE.UTF-8 (charmap=UTF-8)
Shell: /bin/sh linked to /bin/bash

Versions of packages linux-image-2.6.22-3-vserver-k7 depends on:
ii  initramfs-tools [linux-initr 0.91e       tools for generating an initramfs
ii  module-init-tools            3.3-pre11-4 tools for managing Linux kernel mo

Versions of packages linux-image-2.6.22-3-vserver-k7 recommends:
ii  libc6-i686                    2.7-6      GNU C Library: Shared libraries [i
ii  util-vserver                  0.30.214-6 user-space tools for Linux-VServer

-- debconf information:
  linux-image-2.6.22-3-vserver-k7/prerm/removing-running-kernel-2.6.22-3-vserver-k7: true
  linux-image-2.6.22-3-vserver-k7/preinst/abort-install-2.6.22-3-vserver-k7:
  linux-image-2.6.22-3-vserver-k7/preinst/overwriting-modules-2.6.22-3-vserver-k7: true
  linux-image-2.6.22-3-vserver-k7/preinst/lilo-initrd-2.6.22-3-vserver-k7: true
  linux-image-2.6.22-3-vserver-k7/preinst/abort-overwrite-2.6.22-3-vserver-k7:
  linux-image-2.6.22-3-vserver-k7/prerm/would-invalidate-boot-loader-2.6.22-3-vserver-k7: true
  linux-image-2.6.22-3-vserver-k7/postinst/depmod-error-initrd-2.6.22-3-vserver-k7: false
  linux-image-2.6.22-3-vserver-k7/postinst/depmod-error-2.6.22-3-vserver-k7: false
  linux-image-2.6.22-3-vserver-k7/postinst/old-dir-initrd-link-2.6.22-3-vserver-k7: true
  linux-image-2.6.22-3-vserver-k7/preinst/failed-to-move-modules-2.6.22-3-vserver-k7:
  linux-image-2.6.22-3-vserver-k7/preinst/elilo-initrd-2.6.22-3-vserver-k7: true
  linux-image-2.6.22-3-vserver-k7/preinst/already-running-this-2.6.22-3-vserver-k7:
  linux-image-2.6.22-3-vserver-k7/postinst/create-kimage-link-2.6.22-3-vserver-k7: true
  linux-image-2.6.22-3-vserver-k7/preinst/initrd-2.6.22-3-vserver-k7:
  shared/kernel-image/really-run-bootloader: true
  linux-image-2.6.22-3-vserver-k7/postinst/old-system-map-link-2.6.22-3-vserver-k7: true
* linux-image-2.6.22-3-vserver-k7/preinst/bootloader-initrd-2.6.22-3-vserver-k7: false
  linux-image-2.6.22-3-vserver-k7/postinst/old-initrd-link-2.6.22-3-vserver-k7: true
  linux-image-2.6.22-3-vserver-k7/postinst/bootloader-error-2.6.22-3-vserver-k7:
  linux-image-2.6.22-3-vserver-k7/postinst/bootloader-test-error-2.6.22-3-vserver-k7:
  linux-image-2.6.22-3-vserver-k7/postinst/kimage-is-a-directory:
  linux-image-2.6.22-3-vserver-k7/preinst/lilo-has-ramdisk:



-- 
To UNSUBSCRIBE, email to debian-kernel-REQUEST@lists.debian.org
with a subject of "unsubscribe". Trouble? Contact listmaster@lists.debian.org


--=-=-=



-- 
Niv Sardi

--=-=-=--
