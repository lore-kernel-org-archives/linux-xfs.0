Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9278F7F56
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 22:04:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 81D65304048
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 20:04:16 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id y5K9hI3xAsAChxGS for <xfs@oss.sgi.com>;
	Thu, 29 Aug 2013 20:04:15 -0700 (PDT)
Message-ID: <52200BAE.1060501@sandeen.net>
Date: Thu, 29 Aug 2013 22:04:14 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: higher agcount on LVM2 thinp volumes
References: <321D1F95-5603-4571-A445-A267DA5F670F@colorremedies.com>
In-Reply-To: <321D1F95-5603-4571-A445-A267DA5F670F@colorremedies.com>
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
To: Chris Murphy <lists@colorremedies.com>
Cc: xfs@oss.sgi.com

On 8/29/13 1:09 AM, Chris Murphy wrote:
> 
> Is it expected when formatting, using defaults, that a thinp volume
> compared to either a conventional LV or partition of the same size,
> should have a higher agcount?

woohoo, thinp testing! :)

> 
> HDD, GPT partitioned, 100GB partition size:
> 
> [root@f19s ~]# mkfs.xfs /dev/sda7
> meta-data=/dev/sda7              isize=256    agcount=4, agsize=6553600 blks
>          =                       sectsz=512   attr=2, projid32bit=0
> data     =                       bsize=4096   blocks=26214400, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=4096   blocks=12800, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> 
> A 400GB partition, made into PV, PV added to VG, and all extents put into a thinpool volume, a 100GB virtual sized LV:
> 
> [root@f19s ~]# mkfs.xfs /dev/mapper/vg1-data
> meta-data=/dev/mapper/vg1-data   isize=256    agcount=16, agsize=1638400 blks
>          =                       sectsz=512   attr=2, projid32bit=0
> data     =                       bsize=4096   blocks=26214400, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=4096   blocks=12800, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> 
> 
> I get agcount=4 on a conventional LV as well. Why agcount=16 on thinp?

Hm.

calc_default_ag_geometry() in mkfs does this stuff.  There is a "multidisk" mode
which creates more AGs, but you don't have any stripe geometry set, which is what
is supposed to trigger it.

What does

# blockdev --getiomin --getioopt mkfs.xfs /dev/mapper/vg1-data

say?  I'm guessing we picked multidisk mode due to what looks like stripe
geometry, but then maybe it was out of bounds, and we turned it back off.

Or something... that does seem likely though, because on the same sized
fs created on a file:

w/o stripe geometry we get 4 ags:

$ mkfs.xfs -dfile,name=testfile,size=107374182400
meta-data=testfile               isize=256    agcount=4, agsize=6553600 blks
...

w/ stripe geometry we get 16 ags:

$ mkfs.xfs -dfile,name=testfile,size=107374182400,su=64k,sw=4
meta-data=testfile               isize=256    agcount=16, agsize=1638384 blks
...

so at the time we calculated AGs, we thought we had stripe geometry, and then
eventually discarded it.

-Eric





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
