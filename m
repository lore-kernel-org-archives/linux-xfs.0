Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2SLkZ7I187202 for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 16:46:35 -0500
Date: Mon, 28 Mar 2011 16:49:40 -0500
From: Alex Elder <aelder@americas.sgi.com>
Message-Id: <201103282149.p2SLneQ1020631@alcatraz.americas.sgi.com>
Subject: [GIT PULL] XFS 2nd update for 2.6.39-rc1
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

Linus, please pull the following XFS updates for 2.6.39.  I have two
branches for you to choose from:

    git://oss.sgi.com/xfs/xfs for-linus-merged  (recommended)
	This version includes one additional commit--a manual merge
	I completed to fix a merge conflict.  The conflict was
	between Jens Axboe's queue plugging work that you pulled in
	over the weekend, and a change by Dave Chinner to manage XFS
	internal buffers without involvement of the page cache.

    git://oss.sgi.com/xfs/xfs for-linus
	This version contains the XFS changes only, in case you want
	to do the merge yourself.

Thank you.

					-Alex

The following changes since commit 1788c208aab15f9d9d1d24cff0d0c64b5c73bbee:

  Merge branch 'bugfixes' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6 (2011-03-28 07:52:58 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus-merged

Alex Elder (1):
      Merge branch 'master' of git://oss.sgi.com/xfs/xfs into for-linus-merged

Dave Chinner (6):
      xfs: preallocation transactions do not need to be synchronous
      vmap: flush vmap aliases when mapping fails
      xfs: introduce inode cluster buffer trylocks for xfs_iflush
      xfs: xfs_trans_read_buf() should return an error on failure
      xfs: register the inode cache shrinker before quotachecks
      xfs: stop using the page cache to back the buffer cache

 fs/xfs/linux-2.6/xfs_buf.c   |  344 +++++++++++-------------------------------
 fs/xfs/linux-2.6/xfs_buf.h   |   40 +-----
 fs/xfs/linux-2.6/xfs_file.c  |    6 +-
 fs/xfs/linux-2.6/xfs_ioctl.c |    4 +
 fs/xfs/linux-2.6/xfs_super.c |   36 +++--
 fs/xfs/linux-2.6/xfs_sync.c  |   30 ++++-
 fs/xfs/xfs_inode.c           |    2 +-
 fs/xfs/xfs_inode_item.c      |    6 +-
 fs/xfs/xfs_trans_buf.c       |    3 +-
 fs/xfs/xfs_vnodeops.c        |    3 +-
 fs/xfs/xfs_vnodeops.h        |    1 +
 11 files changed, 160 insertions(+), 315 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
