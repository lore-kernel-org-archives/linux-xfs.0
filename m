Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAK7dThT121079 for <xfs@oss.sgi.com>; Tue, 20 Nov 2012 01:39:29 -0600
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 1mwE1hhf9QBiDVOF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 19 Nov 2012 23:41:38 -0800 (PST)
Subject: [PATCH v1 0/9] fs: fix up AIO+DIO+O_SYNC to actually do the sync part
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 19 Nov 2012 23:41:16 -0800
Message-ID: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: axboe@kernel.dk, tytso@mit.edu, david@fromorbit.com, jmoyer@redhat.com, bpm@sgi.com, viro@zeniv.linux.org.uk, jack@suse.cz
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi everybody,

On March 29th, Jeff Moyer posted to lkml a patchset with this note:

> Currently, AIO+DIO+O_SYNC writes are not actually sync'd (for xfs), or they
> are sync'd before the I/O is actually issued (everybody else).  The following
> patch series fixes this in two parts.  First, for the file systems that use
> the generic routines, Jan has provided some generic infrastructure to perform
> the syncs after the I/O is completed.  Second, for those file systems which
> require some endio processing of their own for O_DIRECT writes (xfs and
> ext4), [Jeff] implemented file system specific syncing.  This passes the
> updated xfs-tests 113 test [Jeff] posted earlier, as well as all of the tests
> in the aio group.  [Jeff] tested ext3, ext4, xfs, and btrfs only.

Since the original post a few months ago, this patchset doesn't seem to have
made any progress.  An internal testing team here discovered that the issue
also affects O_SYNC+AIO+DIO writes to block devices.  Worse yet, since the
flushes were being issued (and waited upon) directly in the io_submit call
graph, the io_submit calls themselves would take a very long time to complete.
Therefore, I added another patch to move the flush to the io_end processing.

The blockdev patch was written by me.  The ext4 patch had to be updated to
accomodate a rework of the ext4 endio code that landed since March.  Everything
else has been passed through from Jeff's March 30th resend, with few changes.

This patchset has been tested (albeit lightly) against 3.7-rc6 on x64, with
ext4, xfs, btrfs, vfat, jfs, hfsplus, ext2, ext3, and raw block devices.

Comments and questions are, as always, welcome.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
