Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0BEj4ld154387 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 08:45:04 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201001111445.o0BEjt7M024641@stout.americas.sgi.com>
Date: Mon, 11 Jan 2010 08:45:55 -0600
Subject: [GIT PULL] XFS update 2 for 2.6.33-rc3
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
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

3 bug fixes and a tracing change that reduces text footprint
by about 40% for XFS.

					-Alex

The following changes since commit 3c8ad49b015eb115fbd6982f56d530f53cf57f84:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../roland/infiniband

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (2):
      xfs: use DECLARE_EVENT_CLASS
      xfs: fix timestamp handling in xfs_setattr

Dave Chinner (2):
      xfs: Don't flush stale inodes
      xfs: Ensure we force all busy extents in range to disk

 fs/xfs/linux-2.6/xfs_acl.c   |    3 +-
 fs/xfs/linux-2.6/xfs_trace.h | 1141 ++++++++++++++++++++++--------------------
 fs/xfs/xfs_alloc.c           |   44 +-
 fs/xfs/xfs_inode.c           |   10 +-
 fs/xfs/xfs_vnodeops.c        |   93 ++--
 5 files changed, 666 insertions(+), 625 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
