Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DCB367FD3
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 16:05:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7A7E6AC001
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 14:05:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 681CBNxsEZkjgP9b for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 14:05:54 -0700 (PDT)
Message-ID: <542483B3.3070104@sandeen.net>
Date: Thu, 25 Sep 2014 16:05:55 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: irregular mkfs.xfs results on identical HW
References: <54247484.2030808@physik.uni-freiburg.de>
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
To: "Gamel Anton J." <anton.gamel@physik.uni-freiburg.de>, xfs@oss.sgi.com

On 9/25/14 3:01 PM, Gamel Anton J. wrote:
> Dear all,
> 
> servers with identical disk setup (HW RAID0 H310a):

and identical xfsprogs versions?  Are these linux boxes?

> Disk /dev/sda: 598.9 GB, 598879502336 bytes
> /dev/sda1               1       49152   394813439+  82  Linux swap / Solaris
> /dev/sda2           49153       50176     8225280   83  Linux
> /dev/sda3            6399       72809   533446357+  44  Unknown
> 
> mkfs.xfs creates on 28 of them:
> meta-data=/dev/sda3              isize=256    agcount=16, agsize=8335099 blks

agcount was higher on older mkfs's...

>          =                       sectsz=512   attr=1, projid32bit=0

attr=1?  that looks ancient.  The only way to override the default (2) is with
a commandline argument, unless your mkfs is so old that it has different defaults.

check your xfsprogs versions on both hosts.

-Eric

> data     =                       bsize=4096   blocks=133361584, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=32768, version=1
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> but on four out of them:
> meta-data=/dev/sda3              isize=256    agcount=4, agsize=33340398 blks
>          =                       sectsz=512   attr=2, projid32bit=0
> data     =                       bsize=4096   blocks=133361589, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=65117, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> I did not find a way to add mkfs.xfs options to get the identical
> filesystem setup on all nodes, e.g.
> # mkfs.xfs -d agcount=16 -b size=4096 /dev/sda3 -f
> meta-data=/dev/sda3              isize=256    agcount=16, agsize=8335100 blks
>          =                       sectsz=512   attr=2, projid32bit=0
> data     =                       bsize=4096   blocks=133361589, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=4096   blocks=65117, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> The only way it worked was to dump nodeA:/dev/sda3 to nodeB:/dev/sda3
> Is there an explanation? May be I missed something ... hints?
> 
> Cheers and thanks in advance
> 
> Anton
> 
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
