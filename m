Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n98JAO1J025620 for <xfs@oss.sgi.com>; Thu, 8 Oct 2009 14:10:24 -0500
Date: Thu, 8 Oct 2009 14:11:48 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <200910081911.n98JBm1T019194@stout.americas.sgi.com>
Subject: [GIT PULL] XFS update for 2.6.32
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
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com


The following changes since commit 0eca52a92735f43462165efe00a7e394345fb38e:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/ide-2.6

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      Merge branch 'master' into for-linus

Christoph Hellwig (3):
      xfs: implement ->dirty_inode to fix timestamp handling
      xfs: cleanup ->sync_fs
      xfs: stop calling filemap_fdatawait inside ->fsync

Dave Chinner (3):
      xfs: fix xfs_quiesce_data
      xfs: mark inodes dirty before issuing I/O
      xfs: make sure xfs_sync_fsdata covers the log

Eric Sandeen (1):
      fix readahead calculations in xfs_dir2_leaf_getdents()

 fs/xfs/linux-2.6/xfs_aops.c  |   38 ++++++++++++++++++++-------
 fs/xfs/linux-2.6/xfs_file.c  |    9 +-----
 fs/xfs/linux-2.6/xfs_iops.c  |   41 ++++++++++------------------
 fs/xfs/linux-2.6/xfs_lrw.c   |    2 +-
 fs/xfs/linux-2.6/xfs_super.c |   59 +++++++++++++++++++++++++++++-------------
 fs/xfs/linux-2.6/xfs_sync.c  |   36 ++++++++++++++++++-------
 fs/xfs/xfs_dfrag.c           |    8 +++---
 fs/xfs/xfs_dir2_leaf.c       |    4 ++-
 fs/xfs/xfs_inode.c           |    4 +-
 fs/xfs/xfs_inode.h           |    2 +-
 fs/xfs/xfs_inode_item.c      |   18 ++++++++-----
 fs/xfs/xfs_itable.c          |   21 +++++++++-----
 fs/xfs/xfs_vnodeops.c        |    6 ----
 13 files changed, 146 insertions(+), 102 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
