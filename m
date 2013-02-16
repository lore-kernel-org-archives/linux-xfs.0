Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 47E798035
	for <xfs@oss.sgi.com>; Sat, 16 Feb 2013 00:20:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0F08F30405F
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 22:20:50 -0800 (PST)
Received: from mail-pb0-f51.google.com (mail-pb0-f51.google.com
	[209.85.160.51]) by cuda.sgi.com with ESMTP id rhv2inExdQJoddxQ
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Feb 2013 22:20:49 -0800 (PST)
Received: by mail-pb0-f51.google.com with SMTP id un15so903471pbc.10
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 22:20:49 -0800 (PST)
From: Daniel Browning <db@kavod.com>
Subject: xfsdump segfault
Date: Fri, 15 Feb 2013 22:20:46 -0800
MIME-Version: 1.0
Message-Id: <201302152220.46756.db@kavod.com>
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

Hello folks, 

I ran into a segfault while running xfsdump, what should I do
to find the cause?

Cheers,
--
DB

[root@betelgeuse ~]# mkfs.xfs -f /dev/mapper/W1F01HB6_encrypted
meta-data=/dev/mapper/W1F01HB6_encrypted isize=256    agcount=32, agsize=22888168 blks
         =                       sectsz=4096  attr=2, projid32bit=0
data     =                       bsize=4096   blocks=732421363, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=357627, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

[root@betelgeuse ~]# mount -o inode64,logbsize=256k /dev/mapper/W1F01HB6_encrypted /mnt/backup3_W1F01HB6

[root@betelgeuse ~]# xfsdump -J -l 0 - /mnt/backup3 | xfsrestore - /mnt/backup3_W1F01HB6
xfsdump: using file dump (drive_simple) strategy
xfsrestore: using file dump (drive_simple) strategy
xfsdump: xfsrestore: version 3.1.2 (dump format 3.0)version 3.1.2 (dump format 3.0)

xfsdump: level 0 dump of betelgeuse.orion:/mnt/backup3
xfsdump: dump date: Fri Feb 15 21:19:08 2013
xfsdump: session id: 9bca5442-1b56-4dc6-91b8-bfa68d80c1f1
xfsdump: session label: ""
xfsrestore: searching media for dump
xfsdump: ino map phase 1: constructing initial dump list
xfsdump: ino map phase 2: skipping (no pruning necessary)
xfsdump: ino map phase 3: skipping (only one dump stream)
xfsdump: ino map construction complete
xfsdump: estimated dump size: 2443232512512 bytes
xfsdump: creating dump session media file 0 (media 0, file 0)
xfsdump: dumping ino map
xfsrestore: examining media file 0
xfsrestore: dump description: 
xfsrestore: hostname: betelgeuse.orion
xfsrestore: mount point: /mnt/backup3
xfsrestore: volume: /dev/mapper/backup3_encrypted
xfsrestore: session time: Fri Feb 15 21:19:08 2013
xfsrestore: level: 0
xfsrestore: session label: ""
xfsrestore: media label: ""
xfsrestore: file system id: 8c338a01-730e-4bfd-b3fe-a7a60492f81e
xfsrestore: session id: 9bca5442-1b56-4dc6-91b8-bfa68d80c1f1
xfsrestore: media id: 440538bf-4f05-436c-8eb7-4f9091f62c4b
xfsrestore: searching media for directory dump
xfsrestore: reading directories
xfsdump: dumping directories
xfsdump: dumping non-directory files
xfsrestore: 483705 directories and 8830791 entries processed
xfsrestore: directory post-processing
xfsrestore: restoring non-directory files
xfsdump: ending media file
xfsdump: media file size 33603518464 bytes
xfsdump: dump size (non-dir files) : 32684068672 bytes
xfsdump: NOTE: dump interrupted: 833 seconds elapsed
xfsdump: Dump Status: INTERRUPT
Segmentation fault (core dumped)

[root@betelgeuse ~]# tail /var/log/messages -n 6
Feb 15 21:33:01 betelgeuse kernel: xfsrestore[12176]: segfault at 10 ip 00000033fd8478de sp 00007ffff3177dd0 error 4 in libc-2.12.so[33fd800000+189000]
Feb 15 21:33:01 betelgeuse abrt[12237]: Saved core dump of pid 12176 (/sbin/xfsrestore) to /var/spool/abrt/ccpp-2013-02-15-21:33:01-12176 (880640 bytes)
Feb 15 21:33:01 betelgeuse abrtd: Directory 'ccpp-2013-02-15-21:33:01-12176' creation detected
Feb 15 21:33:02 betelgeuse abrtd: Executable '/sbin/xfsrestore' doesn't belong to any package
Feb 15 21:33:02 betelgeuse abrtd: 'post-create' on '/var/spool/abrt/ccpp-2013-02-15-21:33:01-12176' exited with 1
Feb 15 21:33:02 betelgeuse abrtd: Corrupted or bad directory /var/spool/abrt/ccpp-2013-02-15-21:33:01-12176, deleting

[root@betelgeuse ~]# mount | grep backup3
/dev/mapper/backup3_encrypted on /mnt/backup3 type xfs (ro,inode64,logbsize=256k,inode64,logbsize=256k)
/dev/mapper/W1F01HB6_encrypted on /mnt/backup3_W1F01HB6 type xfs (rw,inode64,logbsize=256k)

[root@betelgeuse ~]# head -n 1 /etc/issue
CentOS release 6.3 (Final)

[root@betelgeuse ~]# uname -a
Linux betelgeuse.orion 3.7.6-1.el6xen.x86_64 #1 SMP Mon Feb 4 17:12:13 EST 2013 x86_64 x86_64 x86_64 GNU/Linux
 
[root@betelgeuse ~]# xfs_repair -V
xfs_repair version 3.1.10
 
[root@betelgeuse ~]# grep 'model name' /proc/cpuinfo
model name      : Intel(R) Xeon(R) CPU E5-1620 0 @ 3.60GHz
model name      : Intel(R) Xeon(R) CPU E5-1620 0 @ 3.60GHz
model name      : Intel(R) Xeon(R) CPU E5-1620 0 @ 3.60GHz
model name      : Intel(R) Xeon(R) CPU E5-1620 0 @ 3.60GHz
model name      : Intel(R) Xeon(R) CPU E5-1620 0 @ 3.60GHz
model name      : Intel(R) Xeon(R) CPU E5-1620 0 @ 3.60GHz
model name      : Intel(R) Xeon(R) CPU E5-1620 0 @ 3.60GHz
model name      : Intel(R) Xeon(R) CPU E5-1620 0 @ 3.60GHz
 
[root@betelgeuse ~]# cat /proc/meminfo
MemTotal:       65951000 kB
MemFree:         1801436 kB
Buffers:           17708 kB
Cached:         54001724 kB
SwapCached:            0 kB
Active:          3880776 kB
Inactive:       50162584 kB
Active(anon):      24196 kB
Inactive(anon):      144 kB
Active(file):    3856580 kB
Inactive(file): 50162440 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:              7048 kB
Writeback:             0 kB
AnonPages:         23960 kB
Mapped:            14216 kB
Shmem:               408 kB
Slab:            6442920 kB
SReclaimable:    5776336 kB
SUnreclaim:       666584 kB
KernelStack:        1880 kB
PageTables:         5392 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    32975500 kB
Committed_AS:     103260 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      387912 kB
VmallocChunk:   34359323900 kB
HardwareCorrupted:     0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       10168 kB
DirectMap2M:     2054144 kB
DirectMap1G:    65011712 kB

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
