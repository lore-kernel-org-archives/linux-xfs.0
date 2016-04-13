Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1EE017CA0
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 00:32:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D670F30405F
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 22:32:16 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Ngguo8SAf4rR23h4 for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2016 22:32:14 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aqDPP-0003p0-Q5
	for xfs@oss.sgi.com; Wed, 13 Apr 2016 15:32:11 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aqDOq-0000bZ-A4
	for xfs@oss.sgi.com; Wed, 13 Apr 2016 15:31:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/11 v3] xfs: inode reclaim vs the world
Date: Wed, 13 Apr 2016 15:31:21 +1000
Message-Id: <1460525492-1170-1-git-send-email-david@fromorbit.com>
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

The inode reclaim patchset has grown somewhat larger with all the
fixes I've accrued over the past couple of days for issues that have
been reported. I've just re-ordered the patchset to have all the bug
fixes that need to go into 4.6-rc up front, followed by other bug
fixes, followed by all the cleanups I wrote as I went along fixing
things. I want to get this out before LSFMM, so I'm posting this
before I've done a full verification that I've got the patches
correct, and they are still running through xfstests right now.

Patch 1 is new - it fixes a regression introduced in 4.6-rc1 and is
caused by clearing the vfs inode i_mode in ->evict_inode, when there
is code in evict() that requires the mode to be intact until
->destroy_inode.

Patch 2 is new - if fixes the inode log item leak that left a dirty
log item on the AIL after the inode had been reclaimed, resulting in
unmountable filesystems and a couple of use-after-free vectors.

Patch 3 is the original fix for the xfs_iflush_cluster lookup
validity checks that were incorect

Patch 4 is the original fix for avoiding flushing stale inodes.

Patch 5 is new, and comes from Alex @ Zadara to avoid having to
reallocate memory when tearing down the inode extent lists. This is
a necessary pre-requisite for patch 6.

Patch 6 is the original patch that pushed all the inode memory
freeing into the RCU callback, so that xfs_iflush_cluster didn't
reference freed memory when racing with reclaim.

Patch 7 is the original patch that made reclaim races eaasier to
detect.

Patch 8 is the original patch that drops out of xfs-iflush_cluster
on the first inode beyond the end of the current cluster.

Patch 9 is the original patch that renames the variables in
xfs_iflush_cluster().

Patch 10 and 11 are new patches that simplify the inode reclaim
tagging interfaces to remove dependencies on the struct xfs_inode
and the inode number where they are not actually required.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
