Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3DLGXrl132487 for <xfs@oss.sgi.com>; Mon, 13 Apr 2009 16:16:44 -0500
Received: from attica.americas.sgi.com (attica.americas.sgi.com
	[128.162.236.44])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E4C9FAC01A
	for <xfs@oss.sgi.com>; Mon, 13 Apr 2009 14:16:16 -0700 (PDT)
Date: Mon, 13 Apr 2009 16:09:39 -0500
Subject: [GIT PULL] XFS update for 2.6.30-rc2
MIME-Version: 1.0
Message-Id: <20090413210939.A986BA24F540@attica.americas.sgi.com>
From: felixb@sgi.com (Felix Blyakher)
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

The following changes since commit 62b8e680e61d3f48f2a12ee248ca03ea8f376926:
  David Howells (1):
        MN10300: Kill MN10300's own profiling Kconfig

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (9):
      xfs: validate log feature fields correctly
      xfs: fix double free of inode
      xfs: prevent unwritten extent conversion from blocking I/O completion
      xfs: inform the xfsaild of the push target before sleeping
      xfs: use xfs_sync_inodes() for device flushing
      xfs: make inode flush at ENOSPC synchronous
      xfs: block callers of xfs_flush_inodes() correctly
      xfs: flush delayed allcoation blocks on ENOSPC in create
      xfs: remove xfs_flush_space

Felix Blyakher (1):
      Merge branch 'master' into for-linus

 fs/xfs/linux-2.6/xfs_aops.c    |   38 +++++++++++---------
 fs/xfs/linux-2.6/xfs_aops.h    |    1 +
 fs/xfs/linux-2.6/xfs_buf.c     |    9 +++++
 fs/xfs/linux-2.6/xfs_fs_subr.c |   14 ++++----
 fs/xfs/linux-2.6/xfs_lrw.c     |   18 +++++++++-
 fs/xfs/linux-2.6/xfs_sync.c    |   78 +++++++++++++++++-----------------------
 fs/xfs/linux-2.6/xfs_sync.h    |    9 +++--
 fs/xfs/xfs_iget.c              |   23 +++++++-----
 fs/xfs/xfs_iomap.c             |   61 ++++++++-----------------------
 fs/xfs/xfs_iomap.h             |    3 +-
 fs/xfs/xfs_log.c               |   78 +++++++++++++++++++++++++---------------
 fs/xfs/xfs_mount.h             |    2 +-
 fs/xfs/xfs_vnodeops.c          |    7 ++++
 13 files changed, 180 insertions(+), 161 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
