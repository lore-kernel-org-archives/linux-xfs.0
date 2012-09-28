Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8S4i2T2174844 for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 23:44:02 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	wZlbdV7KHXMlpFKx for <xfs@oss.sgi.com>;
	Thu, 27 Sep 2012 21:45:21 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1THSRV-0007LU-Dh
	for xfs@oss.sgi.com; Fri, 28 Sep 2012 14:44:49 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1THSRU-0005G8-Ub
	for xfs@oss.sgi.com; Fri, 28 Sep 2012 14:44:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH V3 00/13] xfs: remove the xfssyncd mess
Date: Fri, 28 Sep 2012 14:44:32 +1000
Message-Id: <1348807485-20165-1-git-send-email-david@fromorbit.com>
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

Version 3 of the patchset I described here:

http://oss.sgi.com/archives/xfs/2012-06/msg00064.html

This patchset reliably exposed the log->l_last_sync_lsn problem I
just posted a fix for.

Version 3:
- per-mount log and reclaim workqueues instead of a generic mount
  workqueue.
- reordering of some of the patches as Christoph requested.
- fixed the writeback_inodes_sb_if_idle deadlock by moving it all
  the way back up the write stack to xfs_file_aio_buffered_write
  where we were just flushing the current file to avoid deadlocking
  on it anyway.
- reintroduced xfs_flush_inodes() as a wrapper for
  writeback_inodes_sb_if_idle().
- rebased on a current TOT.

Version 2:
- fix writeback_inodes_sb_if_idle call in xfs_create()
- refreshed patch 13 before sending.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
