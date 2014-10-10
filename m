Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 72D377F3F
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 03:47:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 00187AC008
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 01:47:40 -0700 (PDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15]) by cuda.sgi.com
	with ESMTP id kbixuK1vhtOEpjqx (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 01:47:39 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <trinity-439c7424-8997-4a12-ad12-2c1aa0e49227-1412930857944@3capp-gmx-bs24>
From: Dragon <Sunghost@gmx.de>
Subject: Re: XFS Filesystem is broken and cant repair and mount!
Date: Fri, 10 Oct 2014 10:47:38 +0200
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6888876633827038933=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6888876633827038933==
Content-Type: text/html; charset=UTF-8

<html><head></head><body><div style="font-family: Verdana;font-size: 12.0px;"><div>Hello,</div>

<div>i checked the syslog again, right before the next crash of xfs-filesystem occures, the raiddevice was successfull mounted and XFS says: Mounting Filesystem - Ending clean mount. Than i start to copy, in the log some snmpd events are logged, but i think these doesnt influence the system, than bang - kernel: ffff88031f3b2000: ..... - xfs internal error xfs_btree_check_sblock at line 119 file /build/linux-eKuxrT/linux-3.2.60/fs/xfs/xfs_btree.c caller 0xfffffffa03f08ca&nbsp; - than trace of xfs_corruption - xfs corruption detected. unmount and run xfs_repair - xfs_do_force shutdown 0x8 called from line 3729 .. corruption of memory data detected. shutting filesystem. buffer i/o error on device md2 ... xfs xfs_log_force: error 5 returned - than some ata1.00 errors PHY RDY changed - serror: recovComm Persist PHYRdyChg 10B8b - failed command read fpdma queued, ata1.00 status. drdy eh complete .... how can i find out which drive is ata1.0?</div>

<div>&nbsp;</div>

<div>Sorry have to manualy write this. Hope you can help...</div></div></body></html>


--===============6888876633827038933==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6888876633827038933==--
