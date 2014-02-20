Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 61F327FAA
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 23:55:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EAA8BAC004
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 21:55:49 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	hyEb28JCYtMtznvJ for <xfs@oss.sgi.com>;
	Wed, 19 Feb 2014 21:55:46 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1WGMbV-00057F-Ol
	for xfs@oss.sgi.com; Thu, 20 Feb 2014 16:55:25 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WGMbV-0001CA-NW
	for xfs@oss.sgi.com; Thu, 20 Feb 2014 16:55:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs_repair: fix xfs/033 issues.
Date: Thu, 20 Feb 2014 16:55:20 +1100
Message-Id: <1392875722-4390-1-git-send-email-david@fromorbit.com>
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

Eric reported that there was a regression in v3.2.0-alpha2 where
xfs/033 was failing to repair the corrupted root inode. He also
discovered that the discontiguous buffer support in xfs_repair
fixed it. Turns out that was a regression in xfs_repair covering up
another regression in xfs_repair.

Two bugs don't make broken code better.

The first patch fixes the regression that discontiguous buffer
support introduced, re-exposing the original regression so it can be
debugged. The second patch fixes the original regression.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
