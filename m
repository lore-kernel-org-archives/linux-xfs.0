Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5TB7oKm123526 for <xfs@oss.sgi.com>; Fri, 29 Jun 2012 06:07:50 -0500
Received: from uni-bonn.de (mail.uni-bonn.de [131.220.15.113]) by cuda.sgi.com
	with ESMTP id 9dODMJkqJ12wcvRt for <xfs@oss.sgi.com>;
	Fri, 29 Jun 2012 04:07:47 -0700 (PDT)
Received: from [131.220.147.85] (account mmertes@uni-bonn.de HELO
	[131.220.61.120]) by fe2.uni-bonn.de (CommuniGate Pro SMTP 5.4.4)
	with ESMTPSA id 20167477 for xfs@oss.sgi.com;
	Fri, 29 Jun 2012 13:07:46 +0200
Message-ID: <4FED8C81.70703@uni-bonn.de>
Date: Fri, 29 Jun 2012 13:07:45 +0200
From: Marc Mertes <mertes@uni-bonn.de>
MIME-Version: 1.0
Subject: xfs user quota differs from filesystem data
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi everybody,
I run into a problem and I don=B4t know how to solve that.

First my system infos:

xfs_repair version 2.9.8
Kernel: 2.6.26-2-amd64 on debian lenny (5.0.9)
CPU: 2x Quad-Core AMD Opteron(tm) Processor 2378
RAM: 16GB
Hardisk:
Volume /dev/drbd0 /data xfs rw,noatime,attr2,nobarrier,usrquota 0 0
DRBD Version 8.3.7 (api:88/proto:86-91)
Hardware RAID 5 with 6 SAS2 Seagate Cheetah (450GB) disks (5+1xHS) on =

LSI 9260-8i SAS Controller

xfs_info /dev/drbd0
meta-data=3D/dev/drbd0             isize=3D256    agcount=3D4, =

agsize=3D109744873 blks
          =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D438979490, imaxp=
ct=3D5
          =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096
log      =3Dinternal               bsize=3D4096   blocks=3D32768, version=
=3D2
          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-cou=
nt=3D0
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0


Now my problem:
I defined a userquota (for each, it=B4s our login server) with a =

soft-/hardlimit of 10/12GB
Now I have a few users where the listet used quota is different from the =

real amount of data in ther folders.

Example1: xfs_quota -x -c "quota -uh bthoma" /data
Disk quotas for User bthoma (343)
Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
/dev/drbd0    10,1G    12G    15G  00 [------] /data

but:
du -csh /data/user/bthoma
8,7G    /data/user/bthoma
8,7G    insgesamt

Example2:
xfs_quota -x -c "quota -uh lindau" /data
Disk quotas for User lindau (320)
Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
/dev/drbd0    13,5G    20G    22G  00 [------] /data

but:
du -csh /data/user/lindau
17G     /data/user/lindau
17G     insgesamt

I have no clue how to "refresh" the quota database,
the quick n dirty solution was to set a higher quota for the affected =

users, that they are able to continue with working.
Some reached their quota limit (like in Example one)

at least:
xfs_db frag -v:
actual 3996075, ideal 3118453, fragmentation factor 21.96%

Any Ideas?
Best regards

Marc

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
