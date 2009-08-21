Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7L7AomK156172 for <xfs@oss.sgi.com>; Fri, 21 Aug 2009 02:11:00 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0204815061BF
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2009 00:11:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id oWUktDtD07cD1aEg for
	<xfs@oss.sgi.com>; Fri, 21 Aug 2009 00:11:17 -0700 (PDT)
Date: Fri, 21 Aug 2009 03:11:15 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <193616431.76011250838675275.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1194138654.75921250838215929.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Subject: Re: XFS corruption with failover
MIME-Version: 1.0
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
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
To: John Quigley <jquigley@jquigley.com>
Cc: XFS Development <xfs@oss.sgi.com>

----- "John Quigley" <jquigley@jquigley.com> wrote:

> Lachlan McIlroy wrote:
> > xfs_logprint doesn't find any problems with this log but that
> doesn't mean
> > the kernel doesn't - they use different implementations to read the
> log.  I
> > noticed that the active part of the log wraps around the physical
> end/start
> > of the log which reminds of this fix:
Hang on, I made a mistake there.  The xfs_logprint transactional view
of the log didn't find any errors but dumping the contents of the log
shows a different story.

$ xfs_logprint -f xfs-failover-logprint 
xfs_logprint:
    data device: 0xffffffffffffffff
    log device: 0xffffffffffffffff daddr: 0 length: 262144

Header 0xb wanted 0xfeedbabe
**********************************************************************
* ERROR: header cycle=11          block=6168                         *
**********************************************************************
Bad log record header

$ xfs_logprint -d -f xfs-failover-logprint 

xfs_logprint:
    data device: 0xffffffffffffffff
    log device: 0xffffffffffffffff daddr: 0 length: 262144

[00000 - 00000] Cycle 0xffffffff New Cycle 0x0000000c
    32 HEADER Cycle 12 tail 11:257848 len  32256 ops 707
    96 HEADER Cycle 12 tail 11:257848 len  24064 ops 456
   144 HEADER Cycle 12 tail 11:257848 len   3584 ops 25
   152 HEADER Cycle 12 tail 11:257848 len  32256 ops 708
   216 HEADER Cycle 12 tail 11:257848 len  32256 ops 706
   280 HEADER Cycle 12 tail 11:257848 len  32256 ops 709
   344 HEADER Cycle 12 tail 11:257848 len   3584 ops 18
   352 HEADER Cycle 12 tail 11:257848 len  32256 ops 708
   416 HEADER Cycle 12 tail 11:257848 len  32256 ops 706
   480 HEADER Cycle 12 tail 11:257848 len  32256 ops 709
   544 HEADER Cycle 12 tail 11:257848 len  32256 ops 707
   608 HEADER Cycle 12 tail 11:257848 len  32256 ops 710
   672 HEADER Cycle 12 tail 11:257848 len  32256 ops 707
   736 HEADER Cycle 12 tail 11:257848 len  32256 ops 709
   800 HEADER Cycle 12 tail 11:257848 len  32256 ops 707
   864 HEADER Cycle 12 tail 11:257848 len  32256 ops 706
   928 HEADER Cycle 12 tail 11:257848 len  32256 ops 709
   992 HEADER Cycle 12 tail 11:257848 len  32256 ops 707
  1056 HEADER Cycle 12 tail 11:257848 len  32256 ops 710
  1120 HEADER Cycle 12 tail 11:257848 len  32256 ops 707
  1184 HEADER Cycle 12 tail 11:257848 len  32256 ops 709
  1248 HEADER Cycle 12 tail 11:257848 len  32256 ops 707
  1312 HEADER Cycle 12 tail 11:257848 len  32256 ops 706
  1376 HEADER Cycle 12 tail 11:257848 len  32256 ops 709
  1440 HEADER Cycle 12 tail 11:257848 len  32256 ops 707
  1504 HEADER Cycle 12 tail 11:257848 len  32256 ops 710
  1568 HEADER Cycle 12 tail 11:257848 len  24064 ops 437
  1616 HEADER Cycle 12 tail 11:257848 len   3584 ops 25
  1624 HEADER Cycle 12 tail 11:257848 len  32256 ops 708
  1688 HEADER Cycle 12 tail 11:257848 len  32256 ops 706
  1752 HEADER Cycle 12 tail 11:257848 len  32256 ops 709
  1816 HEADER Cycle 12 tail 11:257848 len  32256 ops 707
  1880 HEADER Cycle 12 tail 11:257848 len  32256 ops 710
  1944 HEADER Cycle 12 tail 11:257848 len  32256 ops 707
  2008 HEADER Cycle 12 tail 11:257848 len  32256 ops 709
  2072 HEADER Cycle 11 tail 11:257848 len      0 ops 0
[00000 - 02072] Cycle 0x0000000c New Cycle 0x0000000b
  2073 HEADER Cycle 11 tail 11:257848 len      0 ops 0
  2074 HEADER Cycle 11 tail 11:257848 len      0 ops 0
  2075 HEADER Cycle 11 tail 11:257848 len      0 ops 0
.........
  6165 HEADER Cycle 11 tail 11:257848 len      0 ops 0
  6166 HEADER Cycle 11 tail 11:257848 len      0 ops 0
  6167 HEADER Cycle 11 tail 11:257848 len      0 ops 0
  6184 HEADER Cycle 11 tail 10:260744 len  32256 ops 707
  6248 HEADER Cycle 11 tail 10:260744 len  32256 ops 710
  6312 HEADER Cycle 11 tail 10:260744 len  32256 ops 707
..........

So we get to block 6168 and there's an unexpected state change - instead
of a magic number we have the cycle number.

BLKNO: 6167
 0 bebaedfe  b000000  2000000        0  b000000 17180000  b000000 38ef0300 
 8        0        0        0        0        0        0        0        0 
10        0        0        0        0        0        0        0        0 
18        0        0        0        0        0        0        0        0 
20        0        0        0        0        0        0        0        0 
28        0        0        0        0        0        0        0        0 
30        0        0        0        0        0        0        0        0 
38        0        0        0        0        0        0        0        0 
40        0        0        0        0        0        0        0        0 
48        0        0        0  1000000 af447af9 4a44d930 5a9b0fa0 20d7ba86 
50        0        0        0        0        0        0        0        0 
58        0        0        0        0        0        0        0        0 
60        0        0        0        0        0        0        0        0 
68        0        0        0        0        0        0        0        0 
70        0        0        0        0        0        0        0        0 
78        0        0        0        0        0        0        0        0 

BLKNO: 6168
 0  b000000       69 81a4494e    10201       63       63        1        0 
 8        0    20000 4a857400 207b4682 4a859784 21b73460 4a859784 21b73460 
10  5f60000        0        0        0        0        0  2000000        0 
18        0        0 b00428a0        0      269 780528a0        0      169 
20 780528a0 10000000       69 5452414e        3        0        1 780528a0 
28 38000000       69    2123b        1        0        0   12c126        0 
30        0        0        0        0    96090        0       10      600 
38 780528a0 60000000       69 81a4494e    10201       63       63        1 
40        0        0    20000 4a857400 207b4682 4a859784 21b73460 4a859784 
48 21b73460  5f60000        0        0        0        0        0  2000000 
50        0        0        0 780528a0        0      269 400628a0        0 
58      169 400628a0 10000000       69 5452414e        3        0        1 
60 400628a0 38000000       69    2123b        1        0        0   12c126 
68        0        0        0        0        0    96090        0       10 
70      600 400628a0 60000000       69 81a4494e    10201       63       63 
78        1        0        0    20000 4a857400 207b4682 4a859784 21c676a0 

I don't know what's happened here.  It may not even be related to the log
recovery failure.

> 
> Very interesting indeed, thank you /very/ much for looking at this.
> 
> > I think the fix made it into 2.6.24.
> 
> We're currently using the very latest 2.6.30, unfortunately.  We've
> distilled this into a reproducible environment with a stack of NFS +
> XFS to a local disk + automated sysrq 'b' reboots.  We're working on
> getting this bundled up into a nice little package as a VirtualBox vm
> for your consumption.  Please tell me if this is not desirable.
> 
> Thanks very much again.
> 
> John Quigley
> jquigley.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
