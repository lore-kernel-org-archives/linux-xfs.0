Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7C6MD8h182047 for <xfs@oss.sgi.com>; Wed, 12 Aug 2009 01:22:23 -0500
Received: from attica.americas.sgi.com (attica.americas.sgi.com
	[128.162.236.44])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 196688F80E0
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2009 23:22:57 -0700 (PDT)
Date: Wed, 12 Aug 2009 01:13:31 -0500
Subject: [GIT PULL] XFS update for 2.6.31-rc6
MIME-Version: 1.0
Message-Id: <20090812061331.F29EAA1FAFA7@attica.americas.sgi.com>
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

The following changes since commit 7cb7beb31aa3d941833b6a6e553687422c31e4b6:
  Linus Torvalds (1):
        Merge branch 'release' of git://git.kernel.org/.../fyu/linux-2.6

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (11):
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

Eric Sandeen (1):
      use XFS_CORRUPTION_ERROR in xfs_btree_check_sblock

 fs/xfs/linux-2.6/xfs_buf.c |    2 +-
 fs/xfs/xfs_attr.c          |    8 +++++---
 fs/xfs/xfs_bmap.c          |    2 +-
 fs/xfs/xfs_btree.c         |    4 ++--
 fs/xfs/xfs_da_btree.c      |    6 +++---
 fs/xfs/xfs_dir2.c          |    2 +-
 fs/xfs/xfs_fsops.c         |   20 ++++++++++++++------
 fs/xfs/xfs_inode.c         |   10 ++++++++++
 fs/xfs/xfs_log.c           |    2 +-
 fs/xfs/xfs_vnodeops.c      |    4 +++-
 10 files changed, 41 insertions(+), 19 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
