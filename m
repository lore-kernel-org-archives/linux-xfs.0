Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3TLiWNe103379 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 16:44:33 -0500
Received: from borg.medozas.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F8A11491B77
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 14:46:35 -0700 (PDT)
Received: from borg.medozas.de (borg.medozas.de [188.40.89.202]) by
	cuda.sgi.com with ESMTP id G4umutTQQ3BkpgFc for
	<xfs@oss.sgi.com>; Thu, 29 Apr 2010 14:46:35 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by borg.medozas.de (Postfix) with ESMTP id 8AC1BE8F7
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 23:46:33 +0200 (CEST)
Date: Thu, 29 Apr 2010 23:46:33 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
Subject: XFS write speed down
Message-ID: <alpine.LSU.2.01.1004292322530.23248@obet.zrqbmnf.qr>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,



Running 2.6.33.2, I am observing this 

used-xfs$ time ( tar -xf /dev/shm/linux-2.6.33.3.tar ; sync )
real    12m29.272s
user    0m0.196s
sys     0m3.028s
meta-data=/dev/md3               isize=256    agcount=32, agsize=11429117 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=365731739, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
/dev/md3 / xfs rw,relatime,attr2,nobarrier,noquota 0 0

# xfs_db -c frag -r /dev/md3
actual 917392, ideal 838246, fragmentation factor 8.63%
# df -i
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/md3             292585344  945559 291639785    1% /
# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/md3             1462795884 701393616 761402268  48% /


What would cause XFS to go down in performance so much here? Did md3
collect too much dust already?
("sync" is not the problem; tar itself runs for over 7 minutes)
Here are some comparisons to other filesystems or use levels:


tmpfs$ time ( tar -xf /dev/shm/linux-2.6.33.3.tar ; sync )
real    0m1.453s
user    0m0.096s
sys     0m0.692s


fresh-ext4$ time ( tar -xf /dev/shm/linux-2.6.33.3.tar ; sync )
real    0m7.657s
user    0m0.096s
sys     0m1.208s
/dev/loop9 /mnt ext4 rw,relatime,barrier=1,data=ordered 0 0
(loopfile stored on md3)


fresh-xfs$ time ( tar -xf /dev/shm/linux-2.6.33.3.tar ; sync )
real    0m10.212s
user    0m0.172s
sys     0m1.616s
Loopfile also residing on md3.


used-btrfs$ time ( tar -xf /dev/shm/linux-2.6.33.3.tar ; sync )
real    0m25.077s
user    0m0.128s
sys     0m2.404s
This btrfs also runs on loop, and is stored on md3.

The machine is a

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 26
model name      : Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz
stepping        : 4
cpu MHz         : 1600.000
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr
pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm
pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est
tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow
vnmi flexpriority ept vpid
bogomips        : 5345.48
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:


This 12 minute extraction is worse than a metadata intensive
copy on an even older box[1].

[1] http://lkml.org/lkml/2006/5/22/278
CPU for [1]:
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 8
model name      : AMD Athlon(tm) XP 2000+
stepping        : 0
cpu MHz         : 1666.774
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr
pge mca cmov pat pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow up
bogomips        : 3333.54
clflush size    : 32
cache_alignment : 32
address sizes   : 34 bits physical, 32 bits virtual
power management: ts

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
