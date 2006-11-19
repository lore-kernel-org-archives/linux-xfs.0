Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Nov 2006 14:05:23 -0800 (PST)
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.188])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAJM5EaG012669
	for <xfs@oss.sgi.com>; Sun, 19 Nov 2006 14:05:16 -0800
Received: by nf-out-0910.google.com with SMTP id x30so1993838nfb
        for <xfs@oss.sgi.com>; Sun, 19 Nov 2006 14:04:23 -0800 (PST)
Message-ID: <1bc1cb170611191338l44425f5k37320aebcb79688e@mail.gmail.com>
Date: Sun, 19 Nov 2006 23:38:09 +0200
From: "=?ISO-8859-1?Q?Rami_V=E4stil=E4?=" <bulpper@gmail.com>
Subject: xfs_growfs failed when crossing 1TB boundary
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I'm trying to grow my filesystem over 1TB on top of LVM, but
unfortunatelly the whole filesystem just shuts down and comes
unusable.

xfs_growfs causes these error messages dumped into console when
running it for bigger filesystem than 1TB (actually lvextend and
'xfs_growfs' commands was used to do the things...)

>xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Input/output error

>attempt to access beyond end of device
>fe:00: rw=1, want=2137593089, limit=1086410752
>xfs_force_shutdown(device-mapper(254,0),0x1) called from line 353 of
file xfs_rw.c Return address = 0xf8a679eb
>Filesystem "device-mapper(254,0)": I/O Error detected. Shutting down
filesystem: device-mapper(254,0)
>Pelase unmout the filesystem, and rectify the proplem(s)
>xfs_force_shutdown(device-mapper(254,0),0x1) called from line 353 of
file xfs_rw.c Return address = 0xf8a679eb
>XFS mounting filesystems device-mapper(254,0)

...after climbing between walls and jumping on my head, I was able to
shrink it back under 1 TB barrier - 1023 GB in fact - and everything
work just fine....;-)

---

Here's some system info:

# uname -a
Linux sweetums 2.4.27-3-686-smp #1 SMP Thu Sep 14 07:44:00 UTC 2006
i686 GNU/Linux

~# pvdisplay
  --- Physical volume ---
  PV Name               /dev/hdc1
  VG Name               lvmdisk
  PV Size               298.09 GB / not usable 0
  Allocatable           yes (but full)
  PE Size (KByte)       4096
  Total PE              76310
  Free PE               0
  Allocated PE          76310
  PV UUID               pxjwHG-Z2Ct-SSAh-Sm2v-z3gL-YHVX-eO3uXL

  --- Physical volume ---
  PV Name               /dev/hdi1
  VG Name               lvmdisk
  PV Size               279.39 GB / not usable 0
  Allocatable           yes (but full)
  PE Size (KByte)       4096
  Total PE              71525
  Free PE               0
  Allocated PE          71525
  PV UUID               KPYMTo-6tXk-ini3-xBzl-wnCS-VJji-Lq6CMV

  --- Physical volume ---
  PV Name               /dev/hdj1
  VG Name               lvmdisk
  PV Size               279.39 GB / not usable 0
  Allocatable           yes (but full)
  PE Size (KByte)       4096
  Total PE              71525
  Free PE               0
  Allocated PE          71525
  PV UUID               AFqf2U-1o7u-DjNG-Q3Bk-MmdD-wZzt-oBQWGc

  --- Physical volume ---
  PV Name               /dev/hdk1
  VG Name               lvmdisk
  PV Size               279.39 GB / not usable 0
  Allocatable           yes
  PE Size (KByte)       4096
  Total PE              71525
  Free PE               28986
  Allocated PE          42539
  PV UUID               LQZBHZ-QtRb-pKmJ-1Tc2-z2Hz-SU7S-UnWC8I

# vgdisplay
  --- Volume group ---
  VG Name               lvmdisk
  System ID
  Format                lvm2
  Metadata Areas        4
  Metadata Sequence No  22
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                4
  Act PV                4
  VG Size               1.11 TB
  PE Size               4.00 MB
  Total PE              290885
  Alloc PE / Size       261899 / 1023.04 GB
  Free  PE / Size       28986 / 113.23 GB
  VG UUID               8B6OW6-YOBj-Weit-LOUL-Rhzb-prO1-OQtEA0

# xfs_info /mnt/storage/
meta-data=/mnt/storage           isize=256    agcount=55, agsize=4883776 blks
         =                       sectsz=512
data     =                       bsize=4096   blocks=268184576, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0

#df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/hde1             74224508   1589896  68864160   3% /
tmpfs                   512572         0    512572   0% /dev/shm
/dev/mapper/lvmdisk-storage
                     1072607232 805661384 266945848  76% /mnt/storage

...and the version of XFS is 2.6.20

I appreciate any helps and tips to get ridden of this problem - thanks
in advance...

-R
