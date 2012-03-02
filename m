Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q224DQJt241585 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 22:13:26 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	6ojhtrBpeodo95Om for <xfs@oss.sgi.com>;
	Thu, 01 Mar 2012 20:13:25 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1S3Jrj-0006Ft-1q
	for xfs@oss.sgi.com; Fri, 02 Mar 2012 15:13:11 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1S3JqT-0000Iq-DZ
	for xfs@oss.sgi.com; Fri, 02 Mar 2012 15:11:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/8] xfs: bug fixes for 3.4
Date: Fri,  2 Mar 2012 15:11:39 +1100
Message-Id: <1330661507-1121-1-git-send-email-david@fromorbit.com>
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

This series contains various fixes for random bugs that are still sitting in my
local queue. The only new one is the last which (once again) fixes inode
reclaim during quota check.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
