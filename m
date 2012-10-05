Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q95HIMr1071613 for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 12:18:22 -0500
Message-Id: <20121005171853.985930109@sgi.com>
Date: Fri, 05 Oct 2012 12:18:53 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [patch v4 00/13] xfs: remove the xfssyncd mess
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

Here I am reposting your xfssyncd series.  I want to make sure that
we're all on the same page.  In particular, are we all happy with patch
6, 'xfs: xfs_sync_data is redundant'?

Version 4:
- updated 'xfs: xfs_sync_data is redundant' with cleanups to the 
  xfs_flush_inodes interface as per Christoph's request,
- updated 'xfs: xfs_sync_data is redundant', folding in changes from 
  http://oss.sgi.com/archives/xfs/2012-10/msg00036.html 
- fixed a minor typo in xfs: 'syncd workqueue is no more', renaming the 
  log worker from 'xfs-reclaim' to 'xfs-log'.

I was going to rush this in for the 3.7 merge window.  However in the
light of the issues with patch 6 and Linus's comment here:
http://lkml.org/lkml/2012/9/30/152 and Stephen's comment here:
https://lkml.org/lkml/2012/9/23/144, I think it wiser to behave.  3.7
is stable without this series, so I will merge it for 3.8.

Once we have an agreement that patch 6 is ready I will pull this in to the
master branch first thing after the 3.7-rc1 merge from upstream.

Regards,
Ben


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
