Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1FJhSE8223790 for <xfs@oss.sgi.com>; Tue, 15 Feb 2011 13:43:29 -0600
Received: from e5.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6198C9B5495
	for <xfs@oss.sgi.com>; Tue, 15 Feb 2011 11:46:06 -0800 (PST)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145]) by
	cuda.sgi.com with ESMTP id 5xb8qPmNvcDCubNP for
	<xfs@oss.sgi.com>; Tue, 15 Feb 2011 11:46:06 -0800 (PST)
Received: from d01dlp01.pok.ibm.com (d01dlp01.pok.ibm.com [9.56.224.56])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p1FJIAHS023527
	for <xfs@oss.sgi.com>; Tue, 15 Feb 2011 14:21:51 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 4B02472838A
	for <xfs@oss.sgi.com>; Tue, 15 Feb 2011 14:38:39 -0500 (EST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p1FJccJb470248 for <xfs@oss.sgi.com>; Tue, 15 Feb 2011 14:38:38 -0500
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p1FJccdB011756
	for <xfs@oss.sgi.com>; Tue, 15 Feb 2011 12:38:38 -0700
Received: from [9.47.24.164] (chandra-lucid.beaverton.ibm.com [9.47.24.164])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	p1FJcbQ3011709 for <xfs@oss.sgi.com>; Tue, 15 Feb 2011 12:38:37 -0700
Subject: xfs_force_shutdown() called when running xfstests on 2.6.38-rc4
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Tue, 15 Feb 2011 11:41:03 -0800
Message-ID: <1297798863.32230.222.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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

Hello,

I am running xfstests on a POWER system with 2.6.38-rc4.

I see the following in some of the tests. 
-------------------------
Feb 15 07:16:23 test2 kernel: Filesystem sdb1: xfs_log_force: error 5 returned.
Feb 15 07:16:23 test2 kernel: Filesystem sdb1: xfs_log_force: error 5 returned.
Feb 15 07:16:23 test2 kernel: xfs_force_shutdown(sdb1,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd000000001505c00
Feb 15 07:16:23 test2 kernel: Filesystem sdb1: xfs_log_force: error 5 returned.
Feb 15 07:16:23 test2 kernel: Filesystem sdb1: xfs_log_force: error 5 returned.
Feb 15 07:16:23 test2 kernel: XFS mounting filesystem sdb1
Feb 15 07:16:23 test2 kernel: Starting XFS recovery on filesystem: sdb1 (logdev: internal)
Feb 15 07:16:23 test2 kernel: Ending XFS recovery on filesystem: sdb1 (logdev: internal)
-----------------------

Is it ok ?
needs to be debugged ?
configuration issues ?

chandra

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
