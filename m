Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7RJo3dv237189 for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 14:50:03 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uQRF56q19Hfgwd1Y for
	<xfs@oss.sgi.com>; Mon, 27 Aug 2012 12:50:52 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7RJopWB027451
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 15:50:51 -0400
Received: from bfoster.bfoster ([10.16.225.83])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q7RJopjn023823
	for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 15:50:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 0/4] xfs: add support for tracking inodes with post-EOF
	speculative preallocation
Date: Mon, 27 Aug 2012 15:51:47 -0400
Message-Id: <1346097111-4476-1-git-send-email-bfoster@redhat.com>
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

Hi all,

The following patchset adds support for tracking and clearing inodes with
post-EOF space due to speculative preallocation. The purpose of this work is to
add some flexibility and management control over inodes in this state. The
specific impetus for this work is to support improved quota management in the
glusterfs cluster filesystem. For example, this provides the ability to
potentially free up a significant amount of unwritten space when at or near
EDQUOT (FWIW, I'm also working on a patch to support prealloc throttling near
EDQUOT, but I'm considering that separate). Despite the motivation, this work is
intended to be generic and hopefully useful for other XFS users.

We track inodes with post-EOF space via a new tag in the per-ag inode radix
tree. The tag management, introduced in patch 1, is generally lazy in an
attempt to keep things simple. Patch 2 implements scanning functionality to
locate and potentially trim inodes with post-EOF space. Patch 3 adds a new
ioctl() to extend support to userspace. Patch 4 adds background scanning based
on the existing syncd workqueue. 

This patchset is marked RFC because aside from general review, I have some
questions on the best approach for several bits (marked with 'TODO' comments),
most notably whether we should include new tunables for the background scanning.
Some further testing is warranted, but I suspect that using the syncd default of
30s might be a bit too aggressive for large files.

These patches have been lightly unit tested and run through xfstests. Thoughts
appreciated.

Brian

P.S., Credit to Dave Chinner for early review and guidance on design.

Brian Foster (4):
  xfs: add EOFBLOCKS inode tagging/untagging
  xfs: create function to scan and clear EOFBLOCKS inodes
  xfs: add FREE_EOFBLOCKS ioctl
  xfs: add background scanning to clear EOFBLOCKS inodes

 fs/xfs/xfs_ag.h       |    1 +
 fs/xfs/xfs_fs.h       |   10 ++
 fs/xfs/xfs_inode.h    |    8 ++-
 fs/xfs/xfs_ioctl.c    |   25 +++++
 fs/xfs/xfs_iomap.c    |    7 ++
 fs/xfs/xfs_iops.c     |    3 +
 fs/xfs/xfs_mount.h    |    2 +
 fs/xfs/xfs_quota.h    |    1 +
 fs/xfs/xfs_quotaops.c |    2 +-
 fs/xfs/xfs_sync.c     |  277 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_sync.h     |    9 ++
 fs/xfs/xfs_trace.h    |    5 +
 fs/xfs/xfs_vnodeops.c |   16 ++-
 fs/xfs/xfs_vnodeops.h |    2 +
 14 files changed, 362 insertions(+), 6 deletions(-)

-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
