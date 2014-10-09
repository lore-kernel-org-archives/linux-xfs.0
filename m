Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 637587F3F
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 08:15:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 41EBD304067
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 06:15:14 -0700 (PDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22]) by cuda.sgi.com
	with ESMTP id RIBIghv6iyG2bGB5 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Oct 2014 06:15:08 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <trinity-c6202f4d-95cc-42f9-a8f2-86e3b9b231a9-1412860507253@3capp-gmx-bs31>
From: Dragon <Sunghost@gmx.de>
Subject: XFS Filesystem is broken and cant repair and mount!
Date: Thu, 9 Oct 2014 15:15:07 +0200
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,
while i copy some files to my software raid device the xfs filesystem reports an uncorrectable error unmount and stops. Reboot didnt work, same failure. Answers to the FAQS:

1.Linux 3.2.0-4-amd64 #1 SMP Debian 3.2.60-1+deb7u3 x86_64 GNU/Linux
2.xfsprogs 3.1.7+b1 amd64
3. 1xCPU
4.cat /proc/meminfo 
MemTotal:       12057908 kB
MemFree:        11797924 kB
Buffers:            8988 kB
Cached:           126440 kB
SwapCached:            0 kB
Active:            90800 kB
Inactive:          67104 kB
Active(anon):      25344 kB
Inactive(anon):      352 kB
Active(file):      65456 kB
Inactive(file):    66752 kB
Unevictable:        4400 kB
Mlocked:            4400 kB
SwapTotal:       3902456 kB
SwapFree:        3902456 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:         26776 kB
Mapped:            11332 kB
Shmem:               512 kB
Slab:              23120 kB
SReclaimable:       7128 kB
SUnreclaim:        15992 kB
KernelStack:        1240 kB
PageTables:         2088 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     9931408 kB
Committed_AS:      82268 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      310772 kB
VmallocChunk:   34359423548 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       56960 kB
DirectMap2M:     2807808 kB
DirectMap1G:     9437184 k

5. cat /proc/mounts 
rootfs / rootfs rw 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
udev /dev devtmpfs rw,relatime,size=10240k,nr_inodes=1505634,mode=755 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /run tmpfs rw,nosuid,noexec,relatime,size=1205792k,mode=755 0 0
/dev/disk/by-uuid/a32246ab-4987-499c-9564-16c7d90631a6 / ext4 rw,noatime,errors=remount-ro,user_xattr,barrier=1,data=ordered 0 0
tmpfs /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=5120k 0 0
tmpfs /run/shm tmpfs rw,nosuid,nodev,noexec,relatime,size=3192060k 0 0
rpc_pipefs /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0

6.cat /proc/partitions 
major minor  #blocks  name

   8        0 2930266584 sda
   8        1      96256 sda1
   8        2    9765888 sda2
   8        3    1952768 sda3
   8        4 2918450176 sda4
   8       16 2930266584 sdb
   8       17      96256 sdb1
   8       18    9765888 sdb2
   8       19    1952768 sdb3
   8       20 2918450176 sdb4
   8       32 2930266584 sdc
   8       33      96256 sdc1
   8       34    9765888 sdc2
   8       35    1952768 sdc3
   8       36 2918450176 sdc4
   8       48 2930266584 sdd
   8       49      96256 sdd1
   8       50    9765888 sdd2
   8       51    1952768 sdd3
   8       52 2918450176 sdd4
   8       64 2930266584 sde
   8       65      96256 sde1
   8       66    9765888 sde2
   8       67    1952768 sde3
   8       68 2918450176 sde4
   8       80 2930266584 sdf
   8       81      96256 sdf1
   8       82    9765888 sdf2
   8       83    1952768 sdf3
   8       84 2918450176 sdf4
   8       96 2930266584 sdg
   8       97      96256 sdg1
   8       98    9765888 sdg2
   8       99    1952768 sdg3
   8      100 2918450176 sdg4
   8      112 2930266584 sdh
   8      113      96256 sdh1
   8      114    9765888 sdh2
   8      115    1952768 sdh3
   8      116 2918450176 sdh4
   9        0    9757568 md0
   9        1   13658624 md1
   9        2 20428230144 md2

7. software raid1 for root and system, software raid6 md1 for swap and raid6 md2 for filedata
8. no lvm
9. 3tb seagate st3000dm
10. write cache for all enabled
11. bbwc ?!
12. xfs_info - cant run while not mountable
13. dmesg:
[    7.541885] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[    7.542692] SGI XFS Quota Management subsystem
[    7.569679] XFS (md2): Mounting Filesystem
[    7.799071] XFS (md2): Starting recovery (logdev: internal)
[    8.992087] XFS (md2): xlog_recover_inode_pass2: Bad inode magic number, dip = 0xffff88031c344400, dino bp = 0xffff88032050d0c0, ino = 3469995060
[    8.992354] XFS (md2): Internal error xlog_recover_inode_pass2(1) at line 2248 of file /build/linux-eKuxrT/linux-3.2.60/fs/xfs/xfs_log_recover.c.  Caller 0xffffffffa03fe677
[    8.992360] 
[    8.992681] Pid: 1677, comm: mount Not tainted 3.2.0-4-amd64 #1 Debian 3.2.60-1+deb7u3
[    8.992687] Call Trace:
[    8.992742]  [<ffffffffa03fd630>] ? xlog_recover_inode_pass2+0x202/0x6ac [xfs]
[    8.992773]  [<ffffffffa03c345b>] ? xfs_buf_rele+0x68/0xc4 [xfs]
[    8.992817]  [<ffffffffa03fe677>] ? xlog_recover_commit_trans+0x7d/0xa6 [xfs]
[    8.992861]  [<ffffffffa03fe7ff>] ? xlog_recover_process_data+0x15f/0x1fa [xfs]
[    8.992904]  [<ffffffffa03feaa7>] ? xlog_do_recovery_pass+0x20d/0x508 [xfs]
[    8.992941]  [<ffffffffa03d4c19>] ? kmem_alloc+0x26/0x6f [xfs]
[    8.992977]  [<ffffffffa03d011e>] ? xfs_parseargs+0xa0f/0xa0f [xfs]
[    8.993020]  [<ffffffffa03fee0c>] ? xlog_do_log_recovery+0x6a/0x8c [xfs]
[    8.993063]  [<ffffffffa03fee3c>] ? xlog_do_recover+0xe/0xc7 [xfs]
[    8.993106]  [<ffffffffa03ff027>] ? xlog_recover+0x6e/0x78 [xfs]
[    8.993149]  [<ffffffffa040503b>] ? xfs_log_mount+0xc4/0x12c [xfs]
[    8.993193]  [<ffffffffa0401236>] ? xfs_mountfs+0x2d8/0x55e [xfs]
[    8.993227]  [<ffffffffa03d0295>] ? xfs_fs_fill_super+0x177/0x255 [xfs]
[    8.993239]  [<ffffffff810fcf91>] ? mount_bdev+0x14a/0x1ac
[    8.993248]  [<ffffffff810ecc7d>] ? __kmalloc_track_caller+0xfe/0x110
[    8.993257]  [<ffffffff810fd7f7>] ? mount_fs+0x61/0x146
[    8.993266]  [<ffffffff81110886>] ? vfs_kern_mount+0x5f/0x99
[    8.993273]  [<ffffffff81110c70>] ? do_kern_mount+0x49/0xd8
[    8.993281]  [<ffffffff811122eb>] ? do_mount+0x660/0x6c6
[    8.993290]  [<ffffffff810c9e4c>] ? memdup_user+0x36/0x5b
[    8.993297]  [<ffffffff811125f9>] ? sys_mount+0x88/0xc3
[    8.993306]  [<ffffffff81355452>] ? system_call_fastpath+0x16/0x1b
[    8.993330] XFS (md2): log mount/recovery failed: error 117
[    8.993513] XFS (md2): log mount failed
[   10.765305] RPC: Registered named UNIX socket transport module.
[   10.765313] RPC: Registered udp transport module.
[   10.765318] RPC: Registered tcp transport module.
[   10.765322] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   10.812582] FS-Cache: Loaded
[   10.849349] FS-Cache: Netfs 'nfs' registered for caching
[   10.863441] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   11.180540] e1000e 0000:04:00.0: irq 44 for MSI/MSI-X
[   11.284215] e1000e 0000:04:00.0: irq 44 for MSI/MSI-X
[   11.290260] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   14.096970] e1000e: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   14.102885] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   24.544070] eth1: no IPv6 routers present
[  184.894882] ata1: exception Emask 0x10 SAct 0x0 SErr 0x90202 action 0xe frozen
[  184.895036] ata1: irq_stat 0x00400000, PHY RDY changed
[  184.895142] ata1: SError: { RecovComm Persist PHYRdyChg 10B8B }
[  184.895266] ata1: hard resetting link
[  191.412128] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  191.416411] ata1.00: configured for UDMA/133
[  191.416425] ata1: EH complete
[  193.180043] ata1.00: exception Emask 0x10 SAct 0x40000 SErr 0x90202 action 0xe frozen
[  193.180218] ata1.00: irq_stat 0x00400000, PHY RDY changed
[  193.180329] ata1: SError: { RecovComm Persist PHYRdyChg 10B8B }
[  193.180455] ata1.00: failed command: READ FPDMA QUEUED
[  193.180567] ata1.00: cmd 60/60:90:00:00:b9/00:00:03:00:00/40 tag 18 ncq 49152 in
[  193.180570]          res 40/00:90:00:00:b9/00:00:03:00:00/40 Emask 0x10 (ATA bus error)
[  193.180862] ata1.00: status: { DRDY }
[  193.180942] ata1: hard resetting link
[  199.716173] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  199.717582] ata1.00: configured for UDMA/133
[  199.717610] ata1: EH complete
[ 1641.107727] XFS (md2): Mounting Filesystem
[ 1641.560291] XFS (md2): Starting recovery (logdev: internal)
[ 1642.682850] XFS (md2): xlog_recover_inode_pass2: Bad inode magic number, dip = 0xffff8803206ce400, dino bp = 0xffff8803206d9580, ino = 3469995060
[ 1642.683117] XFS (md2): Internal error xlog_recover_inode_pass2(1) at line 2248 of file /build/linux-eKuxrT/linux-3.2.60/fs/xfs/xfs_log_recover.c.  Caller 0xffffffffa03fe677
[ 1642.683122] 
[ 1642.683444] Pid: 4780, comm: mount Not tainted 3.2.0-4-amd64 #1 Debian 3.2.60-1+deb7u3
[ 1642.683450] Call Trace:
[ 1642.683508]  [<ffffffffa03fd630>] ? xlog_recover_inode_pass2+0x202/0x6ac [xfs]
[ 1642.683540]  [<ffffffffa03c345b>] ? xfs_buf_rele+0x68/0xc4 [xfs]
[ 1642.683584]  [<ffffffffa03fe677>] ? xlog_recover_commit_trans+0x7d/0xa6 [xfs]
[ 1642.683628]  [<ffffffffa03fe7ff>] ? xlog_recover_process_data+0x15f/0x1fa [xfs]
[ 1642.683671]  [<ffffffffa03feaa7>] ? xlog_do_recovery_pass+0x20d/0x508 [xfs]
[ 1642.683709]  [<ffffffffa03d4c19>] ? kmem_alloc+0x26/0x6f [xfs]
[ 1642.683745]  [<ffffffffa03d4c19>] ? kmem_alloc+0x26/0x6f [xfs]
[ 1642.683781]  [<ffffffffa03d011e>] ? xfs_parseargs+0xa0f/0xa0f [xfs]
[ 1642.683824]  [<ffffffffa03fee0c>] ? xlog_do_log_recovery+0x6a/0x8c [xfs]
[ 1642.683868]  [<ffffffffa03fee3c>] ? xlog_do_recover+0xe/0xc7 [xfs]
[ 1642.683912]  [<ffffffffa03ff027>] ? xlog_recover+0x6e/0x78 [xfs]
[ 1642.683956]  [<ffffffffa040503b>] ? xfs_log_mount+0xc4/0x12c [xfs]
[ 1642.683999]  [<ffffffffa0401236>] ? xfs_mountfs+0x2d8/0x55e [xfs]
[ 1642.684073]  [<ffffffffa03d0295>] ? xfs_fs_fill_super+0x177/0x255 [xfs]
[ 1642.684085]  [<ffffffff810fcf91>] ? mount_bdev+0x14a/0x1ac
[ 1642.684094]  [<ffffffff810ecc7d>] ? __kmalloc_track_caller+0xfe/0x110
[ 1642.684107]  [<ffffffff810fd7f7>] ? mount_fs+0x61/0x146
[ 1642.684120]  [<ffffffff81110886>] ? vfs_kern_mount+0x5f/0x99
[ 1642.684134]  [<ffffffff81110c70>] ? do_kern_mount+0x49/0xd8
[ 1642.684147]  [<ffffffff811122eb>] ? do_mount+0x660/0x6c6
[ 1642.684161]  [<ffffffff810c9e4c>] ? memdup_user+0x36/0x5b
[ 1642.684174]  [<ffffffff811125f9>] ? sys_mount+0x88/0xc3
[ 1642.684189]  [<ffffffff81355452>] ? system_call_fastpath+0x16/0x1b
[ 1642.684216] XFS (md2): log mount/recovery failed: error 117
[ 1642.684395] XFS (md2): log mount failed

Hope i have all and it helps to solve my problem

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
