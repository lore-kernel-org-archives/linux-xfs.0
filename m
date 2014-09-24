Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 170C77F3F
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 19:46:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 05113304048
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 17:46:39 -0700 (PDT)
Received: from atvie01s.evermeet.cx (evermeet.cx [77.244.245.66]) by
	cuda.sgi.com with ESMTP id pAAVrkwyonDJ2QtJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Sep 2014 17:46:37 -0700 (PDT)
Received: from [10.0.0.40] (135-23-85-229.cpe.pppoe.ca [135.23.85.229])
	(authenticated bits=0)
	by atvie01s.evermeet.cx (8.14.9/8.14.9) with ESMTP id s8O0kXKW008177
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 02:46:34 +0200
Message-ID: <5422146A.90206@evermeet.cx>
Date: Tue, 23 Sep 2014 20:46:34 -0400
From: Helmut Tessarek <tessarek@evermeet.cx>
MIME-Version: 1.0
Subject: How to format RAID1 correctly
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
To: xfs@oss.sgi.com

The information provided in the FAQ and on several web sites is not really
useful regarding RAID1.

According to the FAQ (entry 35):
The correct options to format a RAID1 (2 disks) with 64k chunk size is:
mkfs.xfs -d su=64k -d sw=1 /dev/mapper/data
But it also states that it would be automatically detected and used correctly,
yet
mkfs.xfs /dev/mapper/data
yields a different result:

[root@atvie01s ~]# mkfs.xfs -f /dev/mapper/data

meta-data=/dev/mapper/data       isize=256    agcount=4,
agsize=244173876 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=976695504, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal log           bsize=4096   blocks=476902, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Formel 1:

[root@atvie01s ~]# mkfs.xfs -f -d su=64k -d sw=1 /dev/mapper/data

meta-data=/dev/mapper/data       isize=256    agcount=32,
agsize=30521728 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=976695296, imaxpct=5
         =                       sunit=16     swidth=16 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal log           bsize=4096   blocks=476902, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


Another inconsistency is that RAID1 doesn't use striping, so the chunk size
should be irrelevant in the first place.

So what is ultimately the correct way to format a RAID1?

Cheers,
  K. C.

-- 
regards Helmut K. C. Tessarek
lookup http://sks.pkqs.net for KeyID 0xC11F128D

/*
   Thou shalt not follow the NULL pointer for chaos and madness
   await thee at its end.
*/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
