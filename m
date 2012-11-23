Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAN3MW2u018870 for <xfs@oss.sgi.com>; Thu, 22 Nov 2012 21:22:32 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	rKuBiNFjakZQmXTr for <xfs@oss.sgi.com>;
	Thu, 22 Nov 2012 19:24:43 -0800 (PST)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Tbjsc-0000Ch-3S
	for xfs@oss.sgi.com; Fri, 23 Nov 2012 14:24:38 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TbjsS-0003uO-0l
	for xfs@oss.sgi.com; Fri, 23 Nov 2012 14:24:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3, V2] xfs: regression fixes for the 3.8 cycle
Date: Fri, 23 Nov 2012 14:24:22 +1100
Message-Id: <1353641065-14983-1-git-send-email-david@fromorbit.com>
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

Version 2:
- ensure append dio is added to datad workqueue
- rework endio logic back to the if/else if style of logic.
- fixed bogus assert in sub-block zeroing in xfs_file_zero_range

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
