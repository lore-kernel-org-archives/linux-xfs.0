Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 589D37F37
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 01:09:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 414D3304048
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 23:09:22 -0700 (PDT)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id nfcopfckyRhYbm71
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 28 Aug 2013 23:09:17 -0700 (PDT)
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:54659
	helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1) (envelope-from <lists@colorremedies.com>)
	id 1VEvPw-004AzM-Co
	for xfs@oss.sgi.com; Thu, 29 Aug 2013 00:09:16 -0600
From: Chris Murphy <lists@colorremedies.com>
Subject: higher agcount on LVM2 thinp volumes
Message-Id: <321D1F95-5603-4571-A445-A267DA5F670F@colorremedies.com>
Date: Thu, 29 Aug 2013 00:09:13 -0600
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
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


Is it expected when formatting, using defaults, that a thinp volume compared to either a conventional LV or partition of the same size, should have a higher agcount?


HDD, GPT partitioned, 100GB partition size:

[root@f19s ~]# mkfs.xfs /dev/sda7
meta-data=/dev/sda7              isize=256    agcount=4, agsize=6553600 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=26214400, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=12800, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


A 400GB partition, made into PV, PV added to VG, and all extents put into a thinpool volume, a 100GB virtual sized LV:

[root@f19s ~]# mkfs.xfs /dev/mapper/vg1-data
meta-data=/dev/mapper/vg1-data   isize=256    agcount=16, agsize=1638400 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=26214400, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=12800, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0



I get agcount=4 on a conventional LV as well. Why agcount=16 on thinp?


Chris Murphy
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
