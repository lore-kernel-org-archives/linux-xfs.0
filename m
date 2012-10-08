Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q98AspDO055521 for <xfs@oss.sgi.com>; Mon, 8 Oct 2012 05:54:51 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	hqJ7ef7BMH6vVXYg for <xfs@oss.sgi.com>;
	Mon, 08 Oct 2012 03:56:19 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TLB0R-0000VB-UN
	for xfs@oss.sgi.com; Mon, 08 Oct 2012 21:56:15 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TLB0R-000279-PK
	for xfs@oss.sgi.com; Mon, 08 Oct 2012 21:56:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/14 V5]: xfs: remove the xfssyncd mess
Date: Mon,  8 Oct 2012 21:55:58 +1100
Message-Id: <1349693772-8064-1-git-send-email-david@fromorbit.com>
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

Hopefully the final version.

Version 5:
- move initial queuing of log work so it isn't started on log mount
  error
- move xfs_flush_inodes() to xfs_super.c
- pass xfs_mount to xfs_flush_inodes()
- rewrite commit message for xfs_flush_inodes() changes
- added last_sync_lsn fix to series as the problem it fixes is
  reliably exposed by the changes in this series

Version 4:
- updated 'xfs: xfs_sync_data is redundant' with cleanups to the
  xfs_flush_inodes interface as per Christoph's request,
- updated 'xfs: xfs_sync_data is redundant', folding in changes from
  http://oss.sgi.com/archives/xfs/2012-10/msg00036.html
- fixed a minor typo in xfs: 'syncd workqueue is no more', renaming the
  log worker from 'xfs-reclaim' to 'xfs-log'.

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

Initial version:
- http://oss.sgi.com/archives/xfs/2012-06/msg00064.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
