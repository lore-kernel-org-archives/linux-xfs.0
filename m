Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8G3GV8n255324 for <xfs@oss.sgi.com>; Tue, 15 Sep 2009 22:16:31 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9E46C8F80BA
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2009 20:17:42 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: [GIT PULL] XFS update for 2.6.32-rc1
Date: Tue, 15 Sep 2009 22:15:44 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AC93@cf--amer001e--3.americas.sgi.com>
From: "Alex Elder" <aelder@sgi.com>
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

The following changes since commit 0cb583fd2862f19ea88b02eb307d11c09e51e2f8:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/ide-next-2.6

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git for-linus

Alex Elder (4):
      xfs: xfs_showargs() reports group *and* project quotas enabled
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6
      xfs: Record new maintainer information
      Merge branch 'master' of git://oss.sgi.com/xfs/xfs into for-linus

Alexey Dobriyan (1):
      xfs: switch to seq_file

Christoph Hellwig (21):
      xfs: avoid memory allocation under m_peraglock in growfs code
      xfs: switch to NOFS allocation under i_lock in xfs_getbmap
      xfs: switch to NOFS allocation under i_lock in xfs_da_state_alloc
      xfs: switch to NOFS allocation under i_lock in xfs_da_buf_make
      xfs: switch to NOFS allocation under i_lock in xfs_dir_cilookup_result
      xfs: switch to NOFS allocation under i_lock in xfs_buf_associate_memory
      xfs: switch to NOFS allocation under i_lock in xfs_attr_rmtval_set
      xfs: switch to NOFS allocation under i_lock in xfs_readlink_bmap
      xfs: switch to NOFS allocation under i_lock in xfs_attr_rmtval_get
      xfs: check for dinode realtime flag corruption
      xfs: fix spin_is_locked assert on uni-processor builds
      xfs: fix locking in xfs_iget_cache_hit
      xfs: improve xfs_inobt_get_rec prototype
      xfs: improve xfs_inobt_update prototype
      xfs: untangle xfs_dialloc
      xfs: rationalize xfs_inobt_lookup*
      xfs: merge fsync and O_SYNC handling
      xfs: simplify xfs_trans_iget
      xfs: actually enable the swapext compat handler
      xfs: un-static xfs_inobt_lookup
      xfs: use correct log reservation when handling ENOSPC in xfs_create

Dave Chinner (3):
      xfs: factor out inode initialisation
      xfs: factor out debug checks from xfs_dialloc and xfs_difree
      xfs: speed up free inode search

Eric Sandeen (9):
      xfs: add more statics & drop some unused functions
      un-static xfs_read_agf
      xfs: remove XFS_INO64_OFFSET
      xfs: reduce bmv_count in xfs_vn_fiemap
      xfs: bump up nr_to_write in xfs_vm_writepage
      use XFS_CORRUPTION_ERROR in xfs_btree_check_sblock
      xfs: add more statics & drop some unused functions
      un-static xfs_read_agf
      xfs: remove XFS_INO64_OFFSET

Felix Blyakher (1):
      Merge branch 'master' of ssh+git://oss.sgi.com/oss/git/xfs/xfs

Jaswinder Singh Rajput (1):
      xfs: includecheck fix for fs/xfs/xfs_iops.c

Julia Lawall (2):
      fs/xfs: Correct redundant test
      fs/xfs: Correct redundant test

 MAINTAINERS                  |    2 +-
 fs/xfs/linux-2.6/xfs_aops.c  |    1 -
 fs/xfs/linux-2.6/xfs_file.c  |   19 +-
 fs/xfs/linux-2.6/xfs_iops.c  |    1 -
 fs/xfs/linux-2.6/xfs_lrw.c   |    8 +-
 fs/xfs/linux-2.6/xfs_stats.c |   51 ++--
 fs/xfs/linux-2.6/xfs_super.c |   24 +-
 fs/xfs/linux-2.6/xfs_sync.c  |   15 -
 fs/xfs/linux-2.6/xfs_sync.h  |    1 -
 fs/xfs/quota/xfs_qm_stats.c  |   78 ++---
 fs/xfs/xfs_ag.h              |    9 +
 fs/xfs/xfs_bmap.c            |    2 +-
 fs/xfs/xfs_bmap.h            |   11 -
 fs/xfs/xfs_bmap_btree.c      |   20 +-
 fs/xfs/xfs_bmap_btree.h      |    1 -
 fs/xfs/xfs_btree.c           |   42 +---
 fs/xfs/xfs_btree.h           |   15 -
 fs/xfs/xfs_ialloc.c          |  805 +++++++++++++++++++++---------------------
 fs/xfs/xfs_ialloc.h          |   18 +-
 fs/xfs/xfs_iget.c            |   27 --
 fs/xfs/xfs_inode.c           |    8 +-
 fs/xfs/xfs_inode.h           |    8 -
 fs/xfs/xfs_inode_item.c      |   10 -
 fs/xfs/xfs_inode_item.h      |    2 -
 fs/xfs/xfs_inum.h            |    1 -
 fs/xfs/xfs_itable.c          |   98 +++---
 fs/xfs/xfs_itable.h          |    5 -
 fs/xfs/xfs_log_priv.h        |    2 -
 fs/xfs/xfs_log_recover.c     |    2 +-
 fs/xfs/xfs_mount.c           |    2 +-
 fs/xfs/xfs_mount.h           |    3 -
 fs/xfs/xfs_mru_cache.c       |   29 --
 fs/xfs/xfs_mru_cache.h       |    1 -
 fs/xfs/xfs_rw.c              |   84 -----
 fs/xfs/xfs_rw.h              |    7 -
 fs/xfs/xfs_trans.h           |    2 +-
 fs/xfs/xfs_trans_buf.c       |    4 +-
 fs/xfs/xfs_trans_inode.c     |   86 +-----
 fs/xfs/xfs_vnodeops.c        |   17 +-
 39 files changed, 593 insertions(+), 928 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
