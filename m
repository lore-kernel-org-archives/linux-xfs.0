Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0D0EC7CB3
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 18:38:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CC30D30404E
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 16:38:36 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Nn8O5mvLrFpnXke7 for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2016 16:38:28 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aoJVK-0008WU-9R
	for xfs@oss.sgi.com; Fri, 08 Apr 2016 09:38:26 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aoJUo-0006Fq-5J
	for xfs@oss.sgi.com; Fri, 08 Apr 2016 09:37:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6 v2] xfs: xfs_iflush_cluster vs xfs_reclaim_inode
Date: Fri,  8 Apr 2016 09:37:45 +1000
Message-Id: <1460072271-23923-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

This is the second version of this patch set, first posted and
described here:

http://oss.sgi.com/archives/xfs/2016-04/msg00069.html

The only change from the first version is splitting up the first
patch into two as Christoph requested - one for the bug fix, the
other for the variable renaming.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
