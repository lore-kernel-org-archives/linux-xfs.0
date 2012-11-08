Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8MEcaQ026719 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 16:14:38 -0600
Subject: [GIT PULL] XFS update for 3.2-rc2
Message-Id: <20121108221633.BD8F24266DC@whiskey.americas.sgi.com>
Date: Thu,  8 Nov 2012 16:16:33 -0600 (CST)
From: bpm@sgi.com (Ben Myers)
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

Hi Linus,

   Please pull these 10 bug fixes for XFS.  They include a fix for deadlock on
   allocation group freelist buffers, a fix for corruption on log replay, a fix
   for growfs, and a few more to boot.

Thanks,
      Ben	

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs tags/for-linus-v3.7-rc5

for you to fetch changes up to 6ce377afd1755eae5c93410ca9a1121dfead7b87:

  xfs: fix reading of wrapped log data (2012-11-08 11:10:51 -0600)

----------------------------------------------------------------
xfs: bugfixes for 3.7-rc5

- fix for large transactions spanning multiple iclog buffers
- zero the allocation_args structure on the stack before using it
  to determine whether to use a worker for allocation
- move allocation stack switch to xfs_bmapi_allocate in order
  to prevent deadlock on AGF buffers
- growfs no longer reads in garbage for new secondary superblocks
- silence a build warning
- ensure that invalid buffers never get written to disk while on
  free list
- don't vmap inode cluster buffers during free
- fix buffer shutdown reference count mismatch
- fix reading of wrapped log data

----------------------------------------------------------------
Dave Chinner (9):
      xfs: only update the last_sync_lsn when a transaction completes
      xfs: introduce XFS_BMAPI_STACK_SWITCH
      xfs: move allocation stack switch up to xfs_bmapi_allocate
      xfs: growfs: don't read garbage for new secondary superblocks
      xfs: silence uninitialised f.file warning.
      xfs: invalidate allocbt blocks moved to the free list
      xfs: don't vmap inode cluster buffers during free
      xfs: fix buffer shudown reference count mismatch
      xfs: fix reading of wrapped log data

Mark Tinguely (1):
      xfs: zero allocation_args on the kernel stack

 fs/xfs/xfs_alloc.c       | 43 ++-------------------------------
 fs/xfs/xfs_alloc.h       |  3 ---
 fs/xfs/xfs_alloc_btree.c |  2 ++
 fs/xfs/xfs_bmap.c        | 63 +++++++++++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_bmap.h        |  9 ++++++-
 fs/xfs/xfs_buf_item.c    | 18 ++++++++++++++
 fs/xfs/xfs_fsops.c       | 21 ++++++++++++++--
 fs/xfs/xfs_ialloc.c      |  1 +
 fs/xfs/xfs_inode.c       |  3 ++-
 fs/xfs/xfs_ioctl.c       |  2 +-
 fs/xfs/xfs_iomap.c       |  4 ++-
 fs/xfs/xfs_log.c         | 19 ++++++++++++---
 fs/xfs/xfs_log_recover.c |  2 +-
 13 files changed, 127 insertions(+), 63 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
