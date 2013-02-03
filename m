Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DB7D77F50
	for <xfs@oss.sgi.com>; Sat,  2 Feb 2013 21:50:00 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BC38130405F
	for <xfs@oss.sgi.com>; Sat,  2 Feb 2013 19:49:57 -0800 (PST)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id HDreQPVeMlSnEoXw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 02 Feb 2013 19:49:56 -0800 (PST)
Received: from [192.168.4.12] (Athenae [192.168.4.12])
	by Ishtar.sc.tlinx.org (8.14.5/8.14.4/SuSE Linux 0.8) with ESMTP id
	r133nqFx005998 for <xfs@oss.sgi.com>; Sat, 2 Feb 2013 19:49:54 -0800
Message-ID: <510DDE61.6060005@tlinx.org>
Date: Sat, 02 Feb 2013 19:49:53 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: xfsdump showing system problems -- ?  ideas?
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
To: xfs-oss <xfs@oss.sgi.com>



I was looking through my backup logs and noticed a few of the
*logs* of the backups having abnormally high size.

In looking at them, I saw a bunch of messages (last night 3211 occurrences),
of messages like:

xfsdump: WARNING: could not get list of root attributes for nondir ino 
3415547687: Cannot allocate memory (12)
xfsdump: WARNING: could not get list of secure attributes for nondir ino 
3415547687: Cannot allocate memory (12)
xfsdump: WARNING: could not get list of non-root attributes for nondir ino 
3415547688: Cannot allocate memory (12)
xfsdump: WARNIN: could not get list of non-root attributes for nondir ino 
4225270812: Cannot allocate memory (12)
xfsdump: WARNING: could not get list of root attributes for nondir ino 
4225270812: Cannot allocate memory (12)
xfsdump: WARNING: could not get list of secure attributes for nondir ino 
4225270812: Cannot allocate memory (12)

---

looking at my memory usage I see it's close to full -- with *buffer* space.
> free -l
             total       used       free     shared    buffers     cached
Mem:      49422312   49186412     235900          0       1860   43430572
Low:      49422312   49186412     235900
High:            0          0          0
-/+ buffers/cache:    5753980   43668332
Swap:      8393924      35748    8358176


Wondering if anyone has seen something like this before?

/proc/meminfo  has:
Cached:         45541568 kB
Inactive:       45019412 kB
Inactive(file): 44963988 kB

(whole thing is:)
MemTotal:       49422312 kB
MemFree:         1551428 kB
Buffers:            1860 kB
Cached:         45541568 kB
SwapCached:         3228 kB
Active:           881488 kB
Inactive:       45019412 kB
Active(anon):     306736 kB
Inactive(anon):    55424 kB
Active(file):     574752 kB
Inactive(file): 44963988 kB
Unevictable:       16476 kB
Mlocked:           16476 kB
SwapTotal:       8393924 kB
SwapFree:        8358224 kB
Dirty:             50404 kB
Writeback:             0 kB
AnonPages:        371124 kB
Mapped:            61184 kB
Shmem:               996 kB
Slab:            1351896 kB
SReclaimable:    1167144 kB
SUnreclaim:       184752 kB
KernelStack:        4000 kB
PageTables:        13948 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    28136632 kB
Committed_AS:     636552 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      422548 kB
VmallocChunk:   34334065788 kB
HardwareCorrupted:     0 kB
AnonHugePages:    215040 kB
HugePages_Total:      32
HugePages_Free:       32
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        7652 kB
DirectMap2M:     2076672 kB
DirectMap1G:    48234496 kB
--------------------


It doesn't *seem* like I'm even close to out of memory -- (not "'really'")....

So why xfsdump complaining?


If this was reproducible on some system besides my own, would it
be a way of preventing file-security attributes from being read...

looks like it affects root, non-root and secure attribs...

hmmm...

I'm still investigating, but thought I'd shoot off an email to see
if anyone has seen anything like this and if the impact might be
security "dehancing"...;-/  (not that this is a usually a big
problem w/my system, but some sites are more touchy about such
things...


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
