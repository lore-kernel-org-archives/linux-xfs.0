Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TM5Jbg198835 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 17:05:19 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Yyy2d5BE2StwsFIn for
	<xfs@oss.sgi.com>; Thu, 29 Mar 2012 15:05:17 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 0/7, v3] fs: fix up AIO+DIO+O_SYNC to actually do the sync part
Date: Thu, 29 Mar 2012 18:04:58 -0400
Message-Id: <1333058705-31512-1-git-send-email-jmoyer@redhat.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, linux-ext4@vger.kernel.org, jack@suse.cz, xfs@oss.sgi.com

Hi,

Currently, AIO+DIO+O_SYNC writes are not actually sync'd (for xfs), or
they are sync'd before the I/O is actually issued (everybody else).
The following patch series fixes this in two parts.  First, for the
file systems that use the generic routines, Jan has provided some
generic infrastructure to perform the syncs after the I/O is completed.
Second, for those file systems which require some endio processing of
their own for O_DIRECT writes (xfs and ext4), I've implemented file
system specific syncing.  This passes the updated xfs-tests 113 test
I posted earlier, as well as all of the tests in the aio group.  I
tested ext3, ext4, xfs, and btrfs only.

This is a data integrity path, and the current code does not honor
O_SYNC, so any review would be greatly appreciated.

Cheers,
Jeff

Changes since v2: updated the xfs patch to resolve conflicts with new
code (the flush workqueue is now one per mount point).

[PATCH 1/7] vfs: Handle O_SYNC AIO DIO in generic code properly
[PATCH 2/7] ocfs2: Use generic handlers of O_SYNC AIO DIO
[PATCH 3/7] gfs2: Use generic handlers of O_SYNC AIO DIO
[PATCH 4/7] btrfs: Use generic handlers of O_SYNC AIO DIO
[PATCH 5/7] xfs: honor the O_SYNC flag for aysnchronous direct I/O requests
[PATCH 6/7] ext4: honor the O_SYNC flag for aysnchronous direct I/O requests
[PATCH 7/7] filemap: don't call generic_write_sync for -EIOCBQUEUED

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
