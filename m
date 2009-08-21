Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7LN6bF3204953 for <xfs@oss.sgi.com>; Fri, 21 Aug 2009 18:06:47 -0500
Received: from radon.netxsys.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 590E1150D01D
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2009 16:07:00 -0700 (PDT)
Received: from radon.netxsys.com (radon.netxsys.com [204.16.202.162]) by
	cuda.sgi.com with ESMTP id VxLM3d757C6i5cdh for
	<xfs@oss.sgi.com>; Fri, 21 Aug 2009 16:07:00 -0700 (PDT)
Received: from [205.233.151.7] (Oxygen.NetXSys.Com [205.233.151.7])
	by radon.netxsys.com (Postfix) with ESMTP id A827DC000093
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2009 19:06:57 -0400 (EDT)
Subject: XFS disk half full, yet it is reporting out of disk (linux)
From: Krzysztof Adamski <k@adamski.org>
Date: Fri, 21 Aug 2009 19:06:56 -0400
Message-Id: <1250896016.8535.19.camel@oxygen.netxsys.com>
Mime-Version: 1.0
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

I'm running a 64bit kernel Linux (Debian Lenny) self compiled kernel
2.6.30.4. I have created a 5T xfs filesystem, it is about half full but
I get "No space left on device"

Here is the output of df:
gen:/fstore-1# df .
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/mega--raid--1-fstore--1
                     5265707008 2711698716 2554008292  52% /fstore-1
gen:/fstore-1# df -i .
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/mapper/mega--raid--1-fstore--1
                     1053167616  736704 1052430912    1% /fstore-1
gen:/fstore-1# >abc
-bash: abc: No space left on device

What limit did I hit?

K

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
