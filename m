Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3HF0Gm1068658 for <xfs@oss.sgi.com>; Sat, 17 Apr 2010 10:00:16 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D645412B8823
	for <xfs@oss.sgi.com>; Sat, 17 Apr 2010 08:02:12 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id KMNnAQpgprt1dMeU for
	<xfs@oss.sgi.com>; Sat, 17 Apr 2010 08:02:12 -0700 (PDT)
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by rcsinet10.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id
	o3HF2AMr028412
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sat, 17 Apr 2010 15:02:11 GMT
Received: from acsmt354.oracle.com (acsmt354.oracle.com [141.146.40.154])
	by acsinet15.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id
	o3HC7nd4028647 for <xfs@oss.sgi.com>; Sat, 17 Apr 2010 15:02:09 GMT
Date: Sat, 17 Apr 2010 22:59:47 +0800
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: different log info for mkfs.xfs and xfs_growfs
Message-ID: <20100417145947.GA2573@laptop.oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
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

Hi experts,

I just noticed that the log info is different for mkfs.xfs and
xfs_growfs.

[root@desk test-xfsprogs]# mkfs.xfs -llogdev=/dev/sda11,size=32768b
/dev/sda10 -f
meta-data=/dev/sda10             isize=256    agcount=4, agsize=1250558
blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=5002231, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =/dev/sda11             bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@desk test-xfsprogs]# mount -ologdev=/dev/sda11 /dev/sda10 /xfs
[root@desk test-xfsprogs]# xfs_growfs -n /xfs 
meta-data=/dev/sda10             isize=256    agcount=4, agsize=1250558
blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=5002231, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =external               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

So xfs_growfs is simply reporting external.

Why there is such a difference? And how get to know the log device name after it
is mounted?

It's 3.0.0 of xfsprogs. I failed to test with upstream because of the
comlilation error:
[wwg@desk xfsprogs.git]$ make
Building include
Building libxfs
    [DEP]
/usr/bin/makedepend: warning:  ignoring option -Wall
/usr/bin/makedepend: error:  cannot open "no-strict-aliasing"
    [LD]     libxfs.la
libtool: link: only absolute run-paths are allowed
gmake[2]: *** [libxfs.la] Error 1
gmake[1]: *** [libxfs] Error 2
make: *** [default] Error 2

regards,
wengang.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
