Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 97F0E7F3F
	for <xfs@oss.sgi.com>; Sun, 25 May 2014 12:32:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 73B4E304039
	for <xfs@oss.sgi.com>; Sun, 25 May 2014 10:32:21 -0700 (PDT)
Received: from mail.vlasiu.net (mail.vlasiu.net [91.223.50.125]) by
	cuda.sgi.com with ESMTP id 0r79bOe4Ac7FYQEl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 25 May 2014 10:32:17 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.vlasiu.net (Postfix) with ESMTP id 82BFCA0065
	for <xfs@oss.sgi.com>; Sun, 25 May 2014 20:32:14 +0300 (EEST)
Received: from mail.vlasiu.net ([127.0.0.1])
	by localhost (mail.vlasiu.net [127.0.0.1]) (amavisd-new, port 10026)
	with LMTP id GG8fkp0dRCET for <xfs@oss.sgi.com>;
	Sun, 25 May 2014 20:32:11 +0300 (EEST)
Received: from localhost (localhost [127.0.0.1])
	by mail.vlasiu.net (Postfix) with ESMTP id B3734A0065
	for <xfs@oss.sgi.com>; Sun, 25 May 2014 20:32:10 +0300 (EEST)
Date: Sun, 25 May 2014 20:32:04 +0300 (EEST)
From: Gabriel VLASIU <gabriel@vlasiu.net>
Subject: xfs fs shutdown when no more space available
Message-ID: <alpine.LRH.2.03.1405252005430.25037@mail.vlasiu.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hi!

Usually, when the xfs partition has no more space nothing happend except I 
cannot write new data. This was true for a long time. But it's seems that 
in 3.14.4 something has changed (3.14.x?):

# dd if=/dev/urandom of=noise.dat count=4194304
cp noise.dat 11.dat
cp noise.dat 22.dat
....

At some point the partition become full and I get this in logs:

May 25 19:48:25 imhotep kernel: [26271.780894] XFS (loop0): xlog_write: reservation summary:
May 25 19:48:25 imhotep kernel: [26271.780894]   trans type  = FSYNC_TS (36)
May 25 19:48:25 imhotep kernel: [26271.780894]   unit res    = 9640 bytes
May 25 19:48:25 imhotep kernel: [26271.780894]   current res = -4 bytes
May 25 19:48:25 imhotep kernel: [26271.780894]   total reg   = 0 bytes (o/flow = 0 bytes)
May 25 19:48:25 imhotep kernel: [26271.780894]   ophdrs      = 0 (ophdr space = 0 bytes)
May 25 19:48:25 imhotep kernel: [26271.780894]   ophdr + reg = 0 bytes
May 25 19:48:25 imhotep kernel: [26271.780894]   num regions = 0
May 25 19:48:25 imhotep kernel: [26271.780894]
May 25 19:48:25 imhotep kernel: [26271.780910] XFS (loop0): xlog_write: reservation ran out. Need to up reservation
May 25 19:48:25 imhotep kernel: [26271.780917] XFS (loop0): xfs_do_force_shutdown(0x2) called from line 1999 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa009a6e8
May 25 19:48:25 imhotep kernel: [26271.781084] XFS (loop0): Log I/O Error Detected.  Shutting down filesystem
May 25 19:48:25 imhotep kernel: [26271.781088] XFS (loop0): Please umount the filesystem and rectify the problem(s)
May 25 19:48:25 imhotep kernel: [26271.781197] XFS (loop0): xfs_log_force: error 5 returned.
May 25 19:48:25 imhotep kernel: [26271.781550] Buffer I/O error on device loop0, logical block 115955756
May 25 19:48:25 imhotep kernel: [26271.781556] lost page write due to I/O error on loop0
May 25 19:48:25 imhotep kernel: [26271.781566] Buffer I/O error on device loop0, logical block 115955757
May 25 19:48:25 imhotep kernel: [26271.781570] lost page write due to I/O error on loop0
May 25 19:48:25 imhotep kernel: [26271.781576] Buffer I/O error on device loop0, logical block 115955758
May 25 19:48:25 imhotep kernel: [26271.781581] lost page write due to I/O error on loop0
May 25 19:48:25 imhotep kernel: [26271.781586] Buffer I/O error on device loop0, logical block 115955759
May 25 19:48:25 imhotep kernel: [26271.781590] lost page write due to I/O error on loop0
May 25 19:48:25 imhotep kernel: [26271.781597] Buffer I/O error on device loop0, logical block 115955760
May 25 19:48:25 imhotep kernel: [26271.781601] lost page write due to I/O error on loop0
May 25 19:48:25 imhotep kernel: [26271.781607] Buffer I/O error on device loop0, logical block 115955761
May 25 19:48:25 imhotep kernel: [26271.781611] lost page write due to I/O error on loop0
May 25 19:48:25 imhotep kernel: [26271.781616] Buffer I/O error on device loop0, logical block 115955762
May 25 19:48:25 imhotep kernel: [26271.781620] lost page write due to I/O error on loop0
May 25 19:48:25 imhotep kernel: [26271.781626] Buffer I/O error on device loop0, logical block 115955763
May 25 19:48:25 imhotep kernel: [26271.781630] lost page write due to I/O error on loop0
May 25 19:48:25 imhotep kernel: [26271.781636] Buffer I/O error on device loop0, logical block 115955764
May 25 19:48:25 imhotep kernel: [26271.781640] lost page write due to I/O error on loop0
May 25 19:48:25 imhotep kernel: [26271.781646] Buffer I/O error on device loop0, logical block 115955765
May 25 19:48:25 imhotep kernel: [26271.781650] lost page write due to I/O error on loop0
May 25 19:48:25 imhotep kernel: [26271.831068] XFS (loop0): xfs_log_force: error 5 returned.
May 25 19:48:54 imhotep kernel: [26300.896096] XFS (loop0): xfs_log_force: error 5 returned.
May 25 19:49:24 imhotep kernel: [26330.976040] XFS (loop0): xfs_log_force: error 5 returned.
May 25 19:49:54 imhotep kernel: [26361.056082] XFS (loop0): xfs_log_force: error 5 returned.

>>>> umount /home here:
May 25 19:50:04 imhotep kernel: [26370.798657] XFS (loop0): xfs_log_force: error 5 returned.
May 25 19:50:05 imhotep kernel: [26372.117698] XFS (loop0): xfs_log_force: error 5 returned.
May 25 19:50:05 imhotep kernel: [26372.121153] XFS (loop0): xfs_log_force: error 5 returned.

>>>> mount /home here:
May 25 19:50:54 imhotep kernel: [26420.912686] XFS (loop0): Mounting Filesystem
May 25 19:50:55 imhotep kernel: [26421.551754] XFS (loop0): Starting recovery (logdev: internal)
May 25 19:50:55 imhotep kernel: [26421.903891] XFS (loop0): Ending recovery (logdev: internal)

Seems like an log error. Can this be fixed?
Thank you.


# uname -a
Linux imhotep.vlasiu.net 3.14.4-100.AES.f19g.x86_64 #1 SMP Tue May 13 21:36:02 EEST 2014 x86_64 x86_64 x86_64 GNU/Linux

# xfs_repair -V
xfs_repair version 3.1.10

# cat /proc/cpuinfo | grep ^process | wc -l
2

# cat /proc/meminfo 
MemTotal:        3982872 kB
MemFree:         2352536 kB
MemAvailable:    2803296 kB
Buffers:             432 kB
Cached:           997232 kB
SwapCached:           36 kB
Active:          1029964 kB
Inactive:         417876 kB
Active(anon):     761920 kB
Inactive(anon):    83260 kB
Active(file):     268044 kB
Inactive(file):   334616 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       4194296 kB
SwapFree:        4193708 kB
Dirty:                 4 kB
Writeback:             0 kB
AnonPages:        450140 kB
Mapped:            91904 kB
Shmem:            395004 kB
Slab:              75724 kB
SReclaimable:      34068 kB
SUnreclaim:        41656 kB
KernelStack:        1576 kB
PageTables:        10812 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     6185732 kB
Committed_AS:    1386592 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      131492 kB
VmallocChunk:   34359561724 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:      163520 kB
DirectMap2M:     3964928 kB

# cat /proc/mounts | grep -v cgroup | grep -w xfs
/dev/sda3 / xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
/dev/loop6 /tmp xfs rw,seclabel,nosuid,nodev,noexec,relatime,attr2,inode64,noquota 0 0
/dev/loop6 /var/tmp xfs rw,seclabel,nosuid,nodev,noexec,relatime,attr2,inode64,noquota 0 0
/dev/loop0 /home xfs rw,seclabel,nosuid,nodev,relatime,attr2,inode64,logbufs=8,logbsize=256k,noquota 0 0

# xfs_info /dev/loop0
meta-data=/dev/loop0             isize=256    agcount=4, agsize=40108032 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=160432126, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=78335, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


Sincerely,
Gabriel

- -- 

// Gabriel VLASIU
//
// OpenGPG-KeyID      : 44952F15
// OpenGPG-Fingerprint: 4AC5 7C26 2FE9 02DA 4906  24B2 D32B 7ED7 4495 2F15
// OpenGPG-URL        : http://www.vlasiu.net/public.key

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJTgikUAAoJENMrftdElS8VLHkP/3hCMyYmgEZSFYs4alYZRqYp
SMhTiq41h4Q3GaSSqMvrC9U3+j2MlyaaC/tCOxlCszGNf077X3XsrqDBdyrXXpqW
+qKMroXegwkwg0VQVR6LAJFqIMYweK8WIDFUSE+giSPYL4eG5mWlDr9vC6eMrATH
MwcGH9MwI46Bwq9BjxHdlAfp7F5S913sdGpIEN/wQGMVNCewOo2+dJ2vsIqv8QxM
dSrjGXn8QijAJfbgYcrv43wRWONignHgtLmk5bUuyhg7qz0SYOBnziQSuxnDwX8B
sUXDD2RQujy4wfbMPmO+qpZvfmb8lB7mOATDGNX9Sw4JrSMNrl6yLYTNz20PRMq/
IW9q6JAsis3ona9ojJqQDRKOmmoa6+17A3CHkKjSZO3Xuw8kD4XDg8dCQ1xp3qA3
IRfqMKdqQ2mtAI7NZgk4iq5GLdRyZnnGiHMCtP2YV7lqgbjm3M5akSxdoSFrmmdE
gWZu5GC1XVjpbL52eDMoScnFzFfKMXwiMSw++766Z/xzGqr90f+GNcrVk6sk7Dt4
gkSzmuVqkAzkHl5DicZRsjiHqxVxBisLaCaJXqUCC1ZrRf5A4/ga8HpE+1TZHnwt
eDV7obPK6zyg4KkcJzl6RFoes/0XLsN+gay8n4q8AkkqPZso6jJ++3lqpl9ZNOCC
5Cdl0Gyiq5avibzMEsus
=geAz
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
