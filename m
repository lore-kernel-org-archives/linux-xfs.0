Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3ON1QGJ113981 for <xfs@oss.sgi.com>; Fri, 24 Apr 2009 18:01:27 -0500
Received: from mail.strands.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A5B001CE65DB
	for <xfs@oss.sgi.com>; Fri, 24 Apr 2009 16:01:23 -0700 (PDT)
Received: from mail.strands.com (mail.strands.com [217.116.18.226]) by
	cuda.sgi.com with ESMTP id l1Qbe8kqnWv7Dqck for
	<xfs@oss.sgi.com>; Fri, 24 Apr 2009 16:01:23 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.strands.com (Postfix) with ESMTP id 43E603051E1
	for <xfs@oss.sgi.com>; Sat, 25 Apr 2009 01:01:23 +0200 (CEST)
Received: from mail.strands.com ([127.0.0.1])
	by localhost (mail.strands.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7wmpc3VGM+Dc for <xfs@oss.sgi.com>;
	Sat, 25 Apr 2009 01:01:22 +0200 (CEST)
Received: from dhcp-client-1-54.cor.mystrands.in (cor-fw [206.192.226.50])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(Client did not present a certificate)
	(Authenticated sender: petersen)
	by mail.strands.com (Postfix) with ESMTPSA id 111BA305453
	for <xfs@oss.sgi.com>; Sat, 25 Apr 2009 01:01:21 +0200 (CEST)
Message-Id: <73EE3FB2-381F-43F1-82C1-FA4C020E7C02@strands.com>
From: Poul Petersen <petersen@strands.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Slab memory usage
Date: Fri, 24 Apr 2009 16:01:18 -0700
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

	I'm running Debian Lenny with kernel 2.6.26-1-amd64 and  
xfsprogs-2.9.8-1. I've been having a problem with the amount of slab  
memory that XFS seems to be consuming when running a rsync backup job,  
a du, or other file-system intensive programs. Below is an example of  
the output of slabtop and /proc/meminfo. I'm running a tool that  
monitors free memory space, and it starts generating alerts, though I  
don't blame it when the SLAB is running at 50% of memory!

	When the process finishes, the memory usually frees up over a period  
of several hours. However, on a similar system, even 24 hours after  
the rsync job finished, the slab never freed up. On that machine, if I  
run:

echo 2 > /proc/sys/vm/drop_caches

	Then the slab goes down to something more like 1% or 2% of system  
RAM. Any ideas what is causing this behaviour? And how I might  
alleviate it?

Thanks,

-poul

slabtop
=======

  Active / Total Objects (% used)    : 7684622 / 7875871 (97.6%)
  Active / Total Slabs (% used)      : 720661 / 720662 (100.0%)
  Active / Total Caches (% used)     : 105 / 176 (59.7%)
  Active / Total Size (% used)       : 2683658.81K / 2702989.38K (99.3%)
  Minimum / Average / Maximum Object : 0.02K / 0.34K / 4096.00K

   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
1933952 1933787  99%    0.44K 241744        8    966976K xfs_inode
1933918 1933787  99%    0.56K 276274        7   1105096K xfs_vnode
1361008 1359980  99%    0.20K  71632       19    286528K dentry
1311360 1309586  99%    0.12K  43712       30    174848K size-128
1030770 1030548  99%    0.25K  68718       15    274872K size-256

/proc/meminfo
=============
MemTotal:      8265368 kB
MemFree:         54160 kB
Buffers:          4252 kB
Cached:         416880 kB
SwapCached:     166676 kB
Active:        4999204 kB
Inactive:       278028 kB
SwapTotal:     1951856 kB
SwapFree:      1761736 kB
Dirty:             324 kB
Writeback:           0 kB
AnonPages:     4855084 kB
Mapped:          12632 kB
Slab:          2883536 kB
SReclaimable:  2411420 kB
SUnreclaim:     472116 kB
PageTables:     870112 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
WritebackTmp:        0 kB
CommitLimit:   6084540 kB
Committed_AS:  5172208 kB
VmallocTotal: 34359738367 kB
VmallocUsed:     90988 kB
VmallocChunk: 34359647323 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:     2048 kB

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
