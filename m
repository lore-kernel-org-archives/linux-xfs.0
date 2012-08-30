Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7UBxUad192300 for <xfs@oss.sgi.com>; Thu, 30 Aug 2012 06:59:30 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	I6o1aZsNmpGUNzi5 for <xfs@oss.sgi.com>;
	Thu, 30 Aug 2012 05:00:22 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T73Q4-0003qD-1Q
	for xfs@oss.sgi.com; Thu, 30 Aug 2012 22:00:20 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T73Q3-0000k8-RK
	for xfs@oss.sgi.com; Thu, 30 Aug 2012 22:00:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH V2 00/13] xfs: remove the xfssyncd mess
Date: Thu, 30 Aug 2012 22:00:04 +1000
Message-Id: <1346328017-2795-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Version 2 of the patchset I described here:

http://oss.sgi.com/archives/xfs/2012-06/msg00064.html

This version has run through xfstests completely once, so it's
less likely to let smoke out....

Version 2:
- fix writeback_inodes_sb_if_idle call in xfs_create()
- refreshed patch 13 before sending.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
