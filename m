Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q274oixH020626 for <xfs@oss.sgi.com>; Tue, 6 Mar 2012 22:50:45 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	b6RvagNNPTygPlAC for <xfs@oss.sgi.com>;
	Tue, 06 Mar 2012 20:50:43 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1S58pc-0001no-03
	for xfs@oss.sgi.com; Wed, 07 Mar 2012 15:50:32 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1S58pb-0007Uh-O6
	for xfs@oss.sgi.com; Wed, 07 Mar 2012 15:50:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/10] xfs: various fixes v2
Date: Wed,  7 Mar 2012 15:50:18 +1100
Message-Id: <1331095828-28742-1-git-send-email-david@fromorbit.com>
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

Updates after review:
	- used a local fmode variable in patch 2
	- open coded vmall checks in patch 3 and 4, renamed them
	- rewrote quotacheck memory allocation fixup, now three patches
		- first patch starts xfssyncd earlier
		- second patch enables reclaim work during mount and
		  avoids problems reclaim during unmount.
		- third patch implements inode LRU bypass for inodes
		  read in via bulkstat.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
