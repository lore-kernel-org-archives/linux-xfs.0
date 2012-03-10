Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2A2DTrA087049 for <xfs@oss.sgi.com>; Fri, 9 Mar 2012 20:13:30 -0600
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id 6dCtdqBsKGm3jF7A
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 09 Mar 2012 18:13:28 -0800 (PST)
Received: by yhjj72 with SMTP id j72so1905680yhj.26
	for <xfs@oss.sgi.com>; Fri, 09 Mar 2012 18:13:28 -0800 (PST)
Received: by ggni4 with SMTP id i4so1908909ggn.26
	for <xfs@oss.sgi.com>; Fri, 09 Mar 2012 18:13:27 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 9 Mar 2012 18:13:27 -0800
Message-ID: <CAEm1Pvny7Q2rrsCLURvo5kQM3vt+yMg17WxoSYGKVWm7Lgp8MA@mail.gmail.com>
Subject: 1B files, slow file creation, only AG0 used
From: Michael Spiegle <mike@nauticaltech.com>
Reply-To: mike@nauticaltech.com
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

We're seeing some very strange behavior with XFS on the default kernel
for CentOS 5.6 (note, I have also 3.2.9 and witnessed the same issue).
 The dataset on this server is about 1B small files (anywhere from 1KB
to 50KB).  We first noticed it when creating files in a directory.  A
simple 'touch' would take over 300ms on a completely idle system.  If
I simply create a different directory, touching files is 1ms or
faster.  Example:

# time touch 0
real    0m0.323s
user    0m0.000s
sys     0m0.323s

# mkdir tmp2
# time touch tmp2/0
real    0m0.001s
user    0m0.000s
sys     0m0.000s

We've done quite a bit of testing and debugging, and while we don't
have an answer yet, we've noticed that our filesystem was created with
the default of 32 AGs.  When using xfs_db, we notice that all
allocations appear to be in AG0 only.  We've also noticed during
testing that if we create 512 AGs, the distribution appears to be
better.  It seems that the AG is actually encoded into the inode, and
the XFS_INO_TO_AGNO(mp,i) macro is used to determine the AG by
performing a bitshift.  In our case, the bitshift appears to be
32bits, and since the inode is 32bits, we always end up with AG0.
Does anyone know if our slow file creation issue is related to our use
of AG0, and if so, what's the best way to utilize additional AGs?

Per-AG counts:
# for x in {0..31}; do echo -n "${x}: "; xfs_db -c "agi ${x}" -c
"print" -r /dev/sda1 | grep "^count"; done
0: count = 1098927744
1: count = 0
2: count = 0
3: count = 0
4: count = 0
5: count = 0
6: count = 0
7: count = 0
8: count = 0
9: count = 0
10: count = 0
11: count = 0
12: count = 0
13: count = 0
14: count = 0
15: count = 0
16: count = 0
17: count = 0
18: count = 0
19: count = 0
20: count = 0
21: count = 0
22: count = 0
23: count = 0
24: count = 0
25: count = 0
26: count = 0
27: count = 0
28: count = 0
29: count = 0
30: count = 0
31: count = 0

Some general stats on the server:
24x Xeon
24GB RAM
CentOS 5.6
20TB of storage
1B files
RAID6, 14 drives, SATA

Output of "xfs_info /dev/sda1":
meta-data=/dev/sda1              isize=256    agcount=32, agsize=152575999 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=4882431968, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
