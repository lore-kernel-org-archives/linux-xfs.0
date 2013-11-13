Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 012FB7F8B
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 00:41:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 78BE9AC003
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 22:41:22 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Fm3i5Gam87hLQVwh for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 22:41:21 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VgU8N-0005bC-RB
	for xfs@oss.sgi.com; Wed, 13 Nov 2013 17:41:03 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VgU8N-0006hM-Py
	for xfs@oss.sgi.com; Wed, 13 Nov 2013 17:41:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/36 V5] xfsprogs: CRC write support for xfs_db +
Date: Wed, 13 Nov 2013 17:40:24 +1100
Message-Id: <1384324860-25677-1-git-send-email-david@fromorbit.com>
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

This is the latest version of the xfs_db write support patch set.

Changes since V4:

- Added reviewed-by tags to allt eh reviewd patches
- Fixed the wrong subject line for patch 28
- fixed libxfs root inode handling (patch 15)
- folded db buffer unwinding on exit patch into the original IO
  rewrite patch (patch 20)

There are still a couple of unreviewed patches in the list - 20, 24,
31 and 37, so those are the the blockers at this point. Patches 1-16
shoul dbe fine to commit as presented - they should be the same as
last posting except for the addition of the reviewed by tags.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
