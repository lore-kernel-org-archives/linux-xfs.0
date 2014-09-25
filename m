Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B4C607FD5
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 16:19:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A1A45304039
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 14:19:06 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	8mx9p7RODCMEtGJ7 for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 14:19:04 -0700 (PDT)
Date: Fri, 26 Sep 2014 07:19:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: irregular mkfs.xfs results on identical HW
Message-ID: <20140925211901.GH4945@dastard>
References: <54247484.2030808@physik.uni-freiburg.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54247484.2030808@physik.uni-freiburg.de>
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
To: "Gamel Anton J." <anton.gamel@physik.uni-freiburg.de>
Cc: xfs@oss.sgi.com

On Thu, Sep 25, 2014 at 10:01:08PM +0200, Gamel Anton J. wrote:
> Dear all,
> 
> servers with identical disk setup (HW RAID0 H310a):
> 
> Disk /dev/sda: 598.9 GB, 598879502336 bytes
> /dev/sda1               1       49152   394813439+  82  Linux swap / Solaris
> /dev/sda2           49153       50176     8225280   83  Linux
> /dev/sda3            6399       72809   533446357+  44  Unknown
> 
> mkfs.xfs creates on 28 of them:
> meta-data=/dev/sda3              isize=256    agcount=16, agsize=8335099 blks
>          =                       sectsz=512   attr=1, projid32bit=0
> data     =                       bsize=4096   blocks=133361584, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=32768, version=1
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

THat's clearly an old version of mkfs - it's selected version 1 logs
and attr1 by default and a log size of only 128MB. mkfs.xfs has
defaulted to v2 logs since 3.0.0 (2007).

> but on four out of them:
> meta-data=/dev/sda3              isize=256    agcount=4, agsize=33340398 blks
>          =                       sectsz=512   attr=2, projid32bit=0
> data     =                       bsize=4096   blocks=133361589, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=65117, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

Clearly much newer - attr2, log v2, log larger than 128MB...

mkfs.xfs -V on each of the nodes will tell you that they are running
different versions of mkfs, I think.

> The only way it worked was to dump nodeA:/dev/sda3 to nodeB:/dev/sda3
> Is there an explanation? May be I missed something ... hints?

If you are building a new storage system, then I'd highly recommend
all the nodes run the same software and that software is the newest
possible release you can get....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
