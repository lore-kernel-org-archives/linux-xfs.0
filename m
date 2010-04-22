Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MEn0R4207237 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 09:49:00 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CAF141547EA3
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 07:51:00 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id AcHDl0iyHymk5zAP for
	<xfs@oss.sgi.com>; Thu, 22 Apr 2010 07:51:00 -0700 (PDT)
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by rcsinet10.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id
	o3MEovnE017466
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 14:50:59 GMT
Received: from acsmt354.oracle.com (acsmt354.oracle.com [141.146.40.154])
	by acsinet15.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id
	o3MEhMAh027334 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 14:50:56 GMT
Date: Thu, 22 Apr 2010 22:49:39 +0800
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: is realtime device supported?
Message-ID: <20100422144939.GA3822@laptop.oracle.com>
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
Cc: greg.marsden@oracle.com, joe.jin@oracle.com

Hi experts,

Do we support realtime device?

I got the following error:

[root@desk test-xfsprogs]# mkfs.xfs -rrtdev=/dev/sda12,extsize=4096
/dev/sda10 -f
meta-data=/dev/sda10             isize=256    agcount=4, agsize=1250558
blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=5002231, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =/dev/sda12             extsz=4096   blocks=2502115,
rtextents=2502115
[root@desk test-xfsprogs]# mount /dev/sda10 /xfs
mount: Function not implemented
[root@desk test-xfsprogs]# mount -ortdev=/dev/sda12 /dev/sda10 /xfs
mount: Function not implemented

regards,
wengang.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
