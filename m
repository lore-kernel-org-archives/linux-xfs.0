Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22JudVt138279 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 13:56:39 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Fhg2RXygEd7U0cE8 for
	<xfs@oss.sgi.com>; Fri, 02 Mar 2012 11:56:38 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 0/7, v2] fs: fix up AIO+DIO+O_SYNC to actually do the sync part
Date: Fri,  2 Mar 2012 14:56:08 -0500
Message-Id: <1330718175-21540-1-git-send-email-jmoyer@redhat.com>
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
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
Cc: hch@infradead.org, jack@suse.cz

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

Comments, as always, are appreciated.

Cheers,
Jeff

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
