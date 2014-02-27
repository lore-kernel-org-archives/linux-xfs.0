Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A0EA87F50
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 03:51:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 23C95AC005
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 01:51:32 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	a2vM2mxIV21YVObk for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 01:51:30 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WIxcb-0007bh-6l
	for xfs@oss.sgi.com; Thu, 27 Feb 2014 20:51:17 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WIxcb-0007rp-5T
	for xfs@oss.sgi.com; Thu, 27 Feb 2014 20:51:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/10, v3] xfsprogs: reapir scalability and fixes
Date: Thu, 27 Feb 2014 20:51:05 +1100
Message-Id: <1393494675-30194-1-git-send-email-david@fromorbit.com>
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

Another update to the repair scalability fixes patchset. I've
addressed all the review comments from the v2 patch set, and only
patches 8-10 still need review.

The only major change in this posting is that I reordered the patch
set to put all the reviewed patches first - most patches have no
dependencies on each other, so none of the patches changed as a
result of the reordering. If no-one objects, I'll comit the review
patches (1-7) tomorrow to get the fixes and improvements into the
tree for wider testing as soon as possible...

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
