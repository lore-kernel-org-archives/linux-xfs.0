Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EE5C87F47
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 15:14:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CD6938F8050
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 13:14:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GnqtHUwaZGI2sSRj for <xfs@oss.sgi.com>;
	Fri, 24 Oct 2014 13:14:53 -0700 (PDT)
Message-ID: <544AB338.2050905@sandeen.net>
Date: Fri, 24 Oct 2014 15:14:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: makefs alignment issue
References: <544AB289.8010005@hardwarefreak.com>
In-Reply-To: <544AB289.8010005@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On 10/24/14 3:11 PM, Stan Hoeppner wrote:
> Just remade a couple of filesystems and received an alignment msg I
> don't recall receiving previously:
> 
> # mkfs.xfs -f -d su=64k,sw=12 /dev/s2d_a1l003
> mkfs.xfs: Specified data stripe width 1536 is not the same as the volume
> stripe width 2048

so specified geometry that differs from the underlying device...

> meta-data=/dev/s2d_a1l003        isize=256    agcount=44,
> agsize=268435440 blks
>          =                       sectsz=512   attr=2, projid32bit=0
> data     =                       bsize=4096   blocks=11709285376, imaxpct=5
>          =                       sunit=16     swidth=192 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=16 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> 
> /dev/s2d_a1l003 is an alias to dm-0 which is a dm-multipath device to a
> LUN on hardware RAID.  The hardware geometry is 64kx 12, 768k.  AFAIK no
> geometry information has been specified for these device mapper devices
> (someone else's responsibility).  Though I assume dm geometry data is
> the reason for mkfs.xfs throwing this alert.  I don't find anything in
> /sys/devices/virtual/block/dm-0/ indicating geometry.
> 
> Any ideas how to verify what's going on here and fix it?

# blockdev --getiomin --getioopt /dev/s2d_a1l003

The first number, minimum io size, is what is used for sunit
The 2nd number, optimal io size, is what is used for swidth

Where dm got the geometry, I'm not sure - you'd have to look into
how you set up the dm device, and what its defaults are I think.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
