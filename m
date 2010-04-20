Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3KEa1f9042717 for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 09:36:01 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 95353103A80F
	for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 07:37:59 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id cqHBvEiM6HyK4Ugr for
	<xfs@oss.sgi.com>; Tue, 20 Apr 2010 07:37:59 -0700 (PDT)
Received: from rcsinet13.oracle.com (rcsinet13.oracle.com [148.87.113.125])
	by rcsinet10.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id
	o3KEbtLw019072
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 14:37:57 GMT
Received: from acsmt355.oracle.com (acsmt355.oracle.com [141.146.40.155])
	by rcsinet13.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id
	o3KE0GgY013767 for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 14:37:54 GMT
Date: Tue, 20 Apr 2010 22:36:56 +0800
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: do we support using a file as logdev?
Message-ID: <20100420143656.GA3634@laptop.oracle.com>
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
Cc: greg.marsden@oracle.com, joe.jin@oracle.com, wen.gang.wang@oracle.com

Hi experts,

Do we support using a file as log device?
If no, it's strange that we support running xfs on a file but don't support log
file.
If yes, it fails at mount.

[root@desk test-xfsprogs]# mkfs.xfs
-llogdev=/root/test-xfsprogs/test-xfsprogs-tmp/imagefile,size=32768b
/dev/sda10 -f
meta-data=/dev/sda10             isize=256    agcount=4, agsize=1250558
blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=5002231, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =/root/test-xfsprogs/test-xfsprogs-tmp/imagefile bsize=4096
blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@desk test-xfsprogs]# mount
-ologdev=/root/test-xfsprogs/test-xfsprogs-tmp/imagefile /dev/sda10 /xfs
mount: the kernel does not recognize /dev/sda10 as a block device
       (maybe `insmod driver'?)

regards,
wengang.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
