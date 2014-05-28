Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D50417F51
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 01:04:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 725E8AC002
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 23:04:50 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	iRiiSuXOoufpxR4C for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 23:04:47 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WpWyj-0005oa-VZ
	for xfs@oss.sgi.com; Wed, 28 May 2014 16:04:46 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WpWyj-0003l1-UQ
	for xfs@oss.sgi.com; Wed, 28 May 2014 16:04:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/16 V3] xfs: introduce struct xfs_da_geometry
Date: Wed, 28 May 2014 16:04:27 +1000
Message-Id: <1401257083-13433-1-git-send-email-david@fromorbit.com>
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

Version three of the patchset first posted here:

http://oss.sgi.com/pipermail/xfs/2014-May/036125.html

This version addresses the review comments so far.

Changelog:

Version 3:
- added xfs_da_unmount
- moved dir2 conversion functions to xfs_dir2_priv.h
- converted xfs_dir2_readdir.c to use local geo variables
- added a patch to remove newly redundant geometry fields
  from the struct xfs_da_state

Version 2:
- patch removing checks from xfs_da_read_buf() sent separately
- dropped patch adding xfs_da_geometry to the inode forks as it's
  not currently needed
- cleared up all the "XXX" notations added in the RFC series
- fixed several bugs in different patches as a result of incorrect
  conversions
- ensured each patch compiled and passes xfstests individually

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
