Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DFAEE7FD3
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2014 02:26:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C918F304062
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2014 00:26:30 -0700 (PDT)
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id 6oe6FqbNfm2LWwOm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 04 Apr 2014 00:26:26 -0700 (PDT)
Received: from tom.nabble.com ([192.168.236.105])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <dx-wl@163.com>) id 1WVyWA-0001ci-86
	for xfs@oss.sgi.com; Fri, 04 Apr 2014 00:26:26 -0700
Date: Fri, 4 Apr 2014 00:26:26 -0700 (PDT)
From: daiguochao <dx-wl@163.com>
Message-ID: <1396596386220-35015.post@n7.nabble.com>
Subject: 10GB memorys occupied by XFS
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

Hello folks,

I used xfs file system in kernel-2.6.32-220.13.1.el6.x86_64 for store
pictures. About 100 days system memorys is lost and some nginx process is
killed by oom-killer.So,I looked /proc/meminfo and find memorys is
lost.Finally, I try to umount xfs system and 10GB memorys is coming back. l
look xfs bugzilla no such BUG.I have no idea for it.

Cheers,

Guochao.

some memorys info:

0> free -m
             total       used       free     shared    buffers     cached
Mem:         11887      11668        219          0          0          2
-/+ buffers/cache:      11665        222
Swap:            0          0          0

130> cat /proc/meminfo 
MemTotal:       12173268 kB
MemFree:          223044 kB
Buffers:             244 kB
Cached:             4540 kB
SwapCached:            0 kB
Active:             1700 kB
Inactive:           5312 kB
Active(anon):       1616 kB
Inactive(anon):     1128 kB
Active(file):         84 kB
Inactive(file):     4184 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:          2556 kB
Mapped:             1088 kB
Shmem:               196 kB
Slab:             509708 kB
SReclaimable:       7596 kB
SUnreclaim:       502112 kB
KernelStack:        1096 kB
PageTables:          748 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     6086632 kB
Committed_AS:       9440 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      303488 kB
VmallocChunk:   34359426132 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        6152 kB
DirectMap2M:     2070528 kB
DirectMap1G:    10485760 kB



--
View this message in context: http://xfs.9218.n7.nabble.com/10GB-memorys-occupied-by-XFS-tp35015.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
