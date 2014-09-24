Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1360B7F3F
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 21:07:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A1F67AC006
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 19:07:33 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id hB9ThZMKbyeZjNF6 for <xfs@oss.sgi.com>;
	Tue, 23 Sep 2014 19:07:32 -0700 (PDT)
Message-ID: <54222763.40107@sandeen.net>
Date: Tue, 23 Sep 2014 21:07:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: How to format RAID1 correctly
References: <5422146A.90206@evermeet.cx>
In-Reply-To: <5422146A.90206@evermeet.cx>
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
To: Helmut Tessarek <tessarek@evermeet.cx>, xfs@oss.sgi.com

On 9/23/14 7:46 PM, Helmut Tessarek wrote:
> The information provided in the FAQ and on several web sites is not really
> useful regarding RAID1.
> 
> According to the FAQ (entry 35):
> The correct options to format a RAID1 (2 disks) with 64k chunk size is:
> mkfs.xfs -d su=64k -d sw=1 /dev/mapper/data

I don't see that text in the faq... where is it?  I see:

> So if your RAID controller has a stripe size of 64KB, and you have a RAID-6 with 8 disks, use
> 
>  su = 64k
>  sw = 6 (RAID-6 of 8 disks has 6 data disks)

but!  your raid doesn't have a 64k stripe, so that doesn't apply.

> But it also states that it would be automatically detected and used correctly,
> yet
> mkfs.xfs /dev/mapper/data
> yields a different result:
> 
> [root@atvie01s ~]# mkfs.xfs -f /dev/mapper/data
> 
> meta-data=/dev/mapper/data       isize=256    agcount=4,
> agsize=244173876 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=0        finobt=0
> data     =                       bsize=4096   blocks=976695504, imaxpct=5
>          =                       sunit=0      swidth=0 blks

no geometry because md0 raid1 doesn't export any stripe geometry.

> Formel 1:
> 
> [root@atvie01s ~]# mkfs.xfs -f -d su=64k -d sw=1 /dev/mapper/data
> 
> meta-data=/dev/mapper/data       isize=256    agcount=32,
> agsize=30521728 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=0        finobt=0
> data     =                       bsize=4096   blocks=976695296, imaxpct=5
>          =                       sunit=16     swidth=16 blks

You specified it, so mkfs obeyed.

> naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
> log      =internal log           bsize=4096   blocks=476902, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> 
> Another inconsistency is that RAID1 doesn't use striping, so the chunk size
> should be irrelevant in the first place.

agreed - but I don't see anything in the faq about raid1 stripes.
Am I missing something?

> So what is ultimately the correct way to format a RAID1?

for software md raid over individual disks, bare mkfs should do the right
thing.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
