Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q46916SC165858 for <xfs@oss.sgi.com>; Sun, 6 May 2012 04:01:06 -0500
Received: from mail.profihost.ag (mail.profihost.ag [85.158.179.208]) by
	cuda.sgi.com with ESMTP id 3v7j7ZnDaAgiSrOF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 06 May 2012 02:01:04 -0700 (PDT)
Message-ID: <4FA63DDA.9070707@profihost.ag>
Date: Sun, 06 May 2012 11:01:14 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: suddenly slow writes on XFS Filesystem
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi,

since a few days i've experienced a really slow fs on one of our backup 
systems.

I'm not sure whether this is XFS related or related to the Controller / 
Disks.

It is a raid 10 of 20 SATA Disks and i can only write to them with about 
700kb/s while doing random i/o. I tried vanilla Kernel 3.0.30 and 3.3.4 
- no difference. Writing to another partition on another xfs array works 
fine.

Details:
#~ df -h
/dev/sdb1             4,6T  4,4T  207G  96% /mnt

#~ df -i
/dev/sdb1            4875737052 4659318044 216419008  96% /mnt

#~ xfs_db -c frag -r /dev/sdb1
actual 83160469, ideal 82145389, fragmentation factor 1,22%

#~ xfs_info /dev/sdb1
meta-data=/dev/sdb1              isize=256    agcount=5, 
agsize=268435392 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1218967031, imaxpct=5
          =                       sunit=64     swidth=1280 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=32768, version=2
          =                       sectsz=512   sunit=64 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

#~ cat /proc/mounts
/dev/sdb1 /mnt xfs 
rw,noatime,nodiratime,attr2,nobarrier,logbufs=8,logbsize=256k,sunit=512,swidth=10240,prjquota 
0 0

Any ideas?

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
