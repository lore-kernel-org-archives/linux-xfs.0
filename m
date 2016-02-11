Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F2AF37CA6
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 00:45:55 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D10E48F8050
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 22:45:52 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	gv9ILGOuS045ese3 for <xfs@oss.sgi.com>;
	Wed, 10 Feb 2016 22:45:50 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aTl0e-0007o6-RF
	for xfs@oss.sgi.com; Thu, 11 Feb 2016 17:45:48 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aTl0e-00057G-QO
	for xfs@oss.sgi.com; Thu, 11 Feb 2016 17:45:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6 v5] xfs: get rid of xfs_cluster_write()
Date: Thu, 11 Feb 2016 17:45:40 +1100
Message-Id: <1455173146-19535-1-git-send-email-david@fromorbit.com>
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

Version 5 of the patchset, hopefully addressing all the remaining
review comments. I dropped the two RFC patches from this posting -
they are not necessary at this point.

Cheers,

Dave.

Version 5:
- return errors currectly when transaction allocation fails (patch
  2, patch 3, patch 6)
- Added XFS_IO_INVALID to the iotype enum, and initialised the
  writepage context with it. (patch 3)
- s/fail/status/ in xfs_submit_ioend (patch 6)
- pass submit_list into xfs_add_to_ioend() rather than returning the
  ioend to add to the submit list (patch 6)
- fixed bug where dirty pages that are not added to an ioend would
  remain dirty rather than being marked clean and transitioning
  through the writeback state before returning (patch 6)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
