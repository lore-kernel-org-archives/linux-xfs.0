Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D61467F50
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2015 08:25:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5FB20AC002
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2015 06:25:32 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 7Wu1bI82zzgUCQKH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Mar 2015 06:25:30 -0700 (PDT)
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id t2QDPTKa008626
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2015 13:25:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t2QDPTm1031171
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2015 13:25:29 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t2QDPSDC016554
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2015 13:25:29 GMT
Message-ID: <55140956.1050108@oracle.com>
Date: Thu, 26 Mar 2015 16:27:50 +0300
From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
MIME-Version: 1.0
Subject: mkfs error: "existing superblock read failed: Inappropriate ioctl
	for device"
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

I have the following error message: "existing superblock read failed: 
Inappropriate ioctl for device"
after attempt to make xfs image with "mkfs.xfs -f -m crc=1 -d 
file=1,name=xfs.fs,size=32m":

"meta-data=xfs.fs                 isize=256    agcount=2, agsize=4096 blks
          =                       sectsz=512   attr=2, projid32bit=1
          =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=8192, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal log           bsize=4096   blocks=853, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
existing superblock read failed: Inappropriate ioctl for device"

Filesystem is created and mounted as usually, xfs_repair passes, no 
messages in the system log.
Configuration: Fedora 20 x86_64 on vbox, kernel 4.0.0-rc5, xfsprogs 
version 3.2.2.

Thanks,
Alexander Tsvetkov


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
