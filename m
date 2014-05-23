Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0ABFB7F53
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 19:08:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E22F78F8037
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 17:07:57 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Lgg53lqoEcAPC2th for <xfs@oss.sgi.com>;
	Thu, 22 May 2014 17:07:55 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Wncxn-00071k-4d
	for xfs@oss.sgi.com; Fri, 23 May 2014 10:03:55 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1Wncxn-0005T8-3b
	for xfs@oss.sgi.com; Fri, 23 May 2014 10:03:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/16 V2] xfs: introduce struct xfs_da_geometry
Date: Fri, 23 May 2014 10:03:36 +1000
Message-Id: <1400803432-20048-1-git-send-email-david@fromorbit.com>
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

This is the second version of the patchset I posted here:

http://oss.sgi.com/pipermail/xfs/2014-May/036125.html

This patchset moves all the directory and attribute structure
geometry information into it's own abstract structure. This is done
to remove a dependency of the directory code on the struct xfs_mount
and hence xfs_mount.h. It also clears up a dependency between
xfs_da_format.h and xfs_mount.h by moving all the index type
conversion functions to xfs_da_btree.h (as they are not on-disk
format definitions).

This version compiles cleanly at each patch, and runs correctly so
should be fully bisectable (unlike the RFC patch set that was
originally posted that oopsed instantly).

Note that this version is based on the current for-next branch, not
the master branch of the xfs git repo.

Comments and testing welcome!

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
