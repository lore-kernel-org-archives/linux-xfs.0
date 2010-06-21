Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5L4Wj6U100789 for <xfs@oss.sgi.com>; Sun, 20 Jun 2010 23:32:45 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 27FE73EE4D1
	for <xfs@oss.sgi.com>; Sun, 20 Jun 2010 21:35:20 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id EvNOnm0D8GBRzwbx for
	<xfs@oss.sgi.com>; Sun, 20 Jun 2010 21:35:20 -0700 (PDT)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
	by Ishtar.sc.tlinx.org (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5L4ZDir026571 for <xfs@oss.sgi.com>; Sun, 20 Jun 2010 21:35:15 -0700
Message-ID: <4C1EEC01.9090509@tlinx.org>
Date: Sun, 20 Jun 2010 21:35:13 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: xfs partition layout  and using xfs_growfs
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
To: xfs-oss <xfs@oss.sgi.com>


Is there any difference in a file systems layout and efficiency between
to xfs fs's of the same size, but where one was created at size '100%', 
where the other was created at size 50%, but then grown iteratively 
to 60, 70, 80, 90 and then 100% over time as it filled?

Would the final file systems look pretty much the same and have roughly the
same performance characteristics?  Assume, for sake of argument, that the
file system was grown before space got tight enough to cause any severe 
large file fragmentation.  

I've been under the impression that one gained some performance benefits if one
laid out the whole file system at once  is that a mis-impression?

That asked/said...is there any work underway to create an xfs_shrinkfs, so
that one could go the other way?

Thanks,
Linda

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
