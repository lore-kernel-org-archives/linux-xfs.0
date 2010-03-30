Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2UMQqoj212264 for <xfs@oss.sgi.com>; Tue, 30 Mar 2010 17:26:54 -0500
Received: from mail.andcycle.idv.tw (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4D9128ECF9
	for <xfs@oss.sgi.com>; Tue, 30 Mar 2010 15:28:36 -0700 (PDT)
Received: from mail.andcycle.idv.tw (andcycle.idv.tw [122.116.40.15]) by
	cuda.sgi.com with ESMTP id VBTxzCLKEQd9GGWk for
	<xfs@oss.sgi.com>; Tue, 30 Mar 2010 15:28:36 -0700 (PDT)
Message-ID: <4BB27AFE.2030205@andcycle.idv.tw>
Date: Wed, 31 Mar 2010 06:28:14 +0800
From: AndCycle <andcycle@andcycle.idv.tw>
MIME-Version: 1.0
Subject: xfs_fsr defrag top 10% that have the largest number of extents??
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
To: xfs@oss.sgi.com

my xfs_fsr version is xfsdump_2.2.48-1,

there is a description in xfs_fsr man said
"
When invoked with no arguments xfs_fsr reorganizes all regular files in 
all mounted filesystems.
(...)
Each pass goes through and selects files that have the largest number of 
extents.  It attempts to defragment the top 10% of these files on each pass.
"
but xfs_fsr -d telling me it defrags in inode ascending order,

http://pastebin.com/h0RyZkwA

is this a normal behavior?



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
