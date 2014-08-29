Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 899457FAA
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 08:29:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 78043304032
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 06:29:24 -0700 (PDT)
Received: from smtp.inserm.fr (smtp.inserm.fr [195.98.252.37]) by cuda.sgi.com
	with ESMTP id Cb3XDCkndKGCaTS7 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Aug 2014 06:29:18 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp.inserm.fr (SrvInserm) with ESMTP id B143016825F
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 15:29:17 +0200 (CEST)
Received: from smtp.inserm.fr ([195.98.252.37])
	by localhost (potentille.inserm.fr [127.0.0.1]) (amavisd-new,
	port 10026) with ESMTP id NYm4gkavOM0y for <xfs@oss.sgi.com>;
	Fri, 29 Aug 2014 15:29:17 +0200 (CEST)
Received: from cognac-lmde.crcm.mrs (236-ne1068.marseille.inserm.fr
	[195.220.68.236])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by smtp.inserm.fr (SrvInserm) with ESMTP id 8C911168356
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 15:29:16 +0200 (CEST)
Message-ID: <5400802C.5050005@inserm.fr>
Date: Fri, 29 Aug 2014 15:29:16 +0200
From: Samuel Granjeaud <samuel.granjeaud@inserm.fr>
MIME-Version: 1.0
Subject: Re: Run out of inodes?
References: <54005108.1020203@inserm.fr>
	<20140829114806.GA17610@bfoster.bfoster>
In-Reply-To: <20140829114806.GA17610@bfoster.bfoster>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Taking into account the two answers, here is some more information.

The system is a openfiler installation, v2.3, up-to-date.
https://www.openfiler.com/community/download

The problematic system is a backup but the production system uses the 
same openfiler NAS system. The difference is that there are currently 
more files on the backup system than the production system; so I guess 
the problem will appear sooner on the prod sys.

# xfs_info /dev/vg1_backup/backup
meta-data=/mnt/vg1_backup/backup isize=256    agcount=80, 
agsize=58981376 blks
          =                       sectsz=512
data     =                       bsize=4096   blocks=4718510080, imaxpct=25
          =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
          =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0

# uname -a
Linux 2.6.26.8-1.0.11.smp.gcc3.4.x86_64 #1 SMP Sun Jan 11 02:42:55 GMT 
2009 x86_64 x86_64 x86_64 GNU/Linux

# xfs_info -V /dev/vg1_backup/backup
xfs_info version 2.6.25

# cat /etc/fstab
...
/dev/vg1/pcurrent /mnt/vg1/pcurrent xfs defaults,usrquota,grpquota 0 0

# cat /etc/mtab
...
/dev/mapper/vg1-pcurrent /mnt/vg1/pcurrent xfs rw,usrquota,grpquota 0 0

# lvm version
   LVM version:     2.02.34 (2008-04-10)
   Library version: 1.02.24 (2007-12-20)
   Driver version:  4.13.0

]# more /proc/meminfo /proc/mounts /proc/partitions
::::::::::::::
/proc/meminfo
::::::::::::::
MemTotal:      2057876 kB
MemFree:         18808 kB
Buffers:          3868 kB
Cached:        1906736 kB
SwapCached:        160 kB
Active:         581108 kB
Inactive:      1367680 kB
SwapTotal:     1028152 kB
SwapFree:      1027848 kB
Dirty:             156 kB
Writeback:           0 kB
AnonPages:       38168 kB
Mapped:          34376 kB
Slab:            67104 kB
SReclaimable:    55772 kB
SUnreclaim:      11332 kB
PageTables:       4112 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
WritebackTmp:        0 kB
CommitLimit:   2057088 kB
Committed_AS:   105580 kB
VmallocTotal: 34359738367 kB
VmallocUsed:    272688 kB
VmallocChunk: 34359465359 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:     2048 kB
::::::::::::::
/proc/mounts
::::::::::::::
rootfs / rootfs rw 0 0
/dev /dev tmpfs rw,mode=755 0 0
/dev/root / ext3 rw,errors=continue,data=ordered 0 0
/proc /proc proc rw 0 0
/proc/bus/usb /proc/bus/usb usbfs rw 0 0
/sys /sys sysfs rw 0 0
devpts /dev/pts devpts rw,gid=5,mode=620 0 0
/dev/sda1 /boot ext3 rw,errors=continue,data=ordered 0 0
tmpfs /dev/shm tmpfs rw 0 0
/dev/vg1/pcurrent /mnt/vg1/pcurrent xfs 
rw,attr2,nobarrier,usrquota,prjquota,grpquota 0 0
none /proc/sys/fs/binfmt_misc binfmt_misc rw 0 0
sunrpc /var/lib/nfs/rpc_pipefs rpc_pipefs rw 0 0
::::::::::::::
/proc/partitions
::::::::::::::
major minor  #blocks  name

    8     0    3145728 sda
    8     1     104391 sda1
    8     2    2008125 sda2
    8     3    1028160 sda3
    8    16 1887436800 sdb
    8    17 1887436656 sdb1
    8    32 1887436800 sdc
    8    33 1887436656 sdc1
    8    48 1887436800 sdd
    8    49 1887436656 sdd1
    8    64 1887436800 sde
    8    65 1887436656 sde1
    8    80 1887436800 sdf
    8    81 1887436656 sdf1
    8    96 1887436800 sdg
    8    97 1887436656 sdg1
    8   112 1887436800 sdh
    8   113 1887436656 sdh1
    8   128 1887436800 sdi
    8   129 1887436656 sdi1
    8   144 1887436800 sdj
    8   145 1887436656 sdj1
    8   160 1887436800 sdk
    8   161 1887436656 sdk1
    8   176  655360000 sdl
    8   177  655355578 sdl1
  253     0 18874040320 dm-0


The system is a ESXi virtual machine. RAID is hardware, managed at the 
BIOS level. Disks are DELL SATA.

I have no idea concerning the inode64 option. Just tell me how to find 
it out. I don't think this option was changed: as previously told, 
removing a few files allows files to be created without error.

I could add some more information if needed.

Thanks for your help,
Samuel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
