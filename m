Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0F2Fh56023061 for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 20:15:43 -0600
Date: Thu, 15 Jan 2009 13:15:36 +1100
Subject: [GIT PULL] XFS update for 2.6.29-rc2
MIME-Version: 1.0
Message-Id: <20090115021536.BE17759391EC@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

The following changes since commit a6525042bfdfcab128bd91fad264de10fd24a55e:
  Linus Torvalds (1):
        Merge branch 'x86-pat-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (4):
      [XFS] pass XFS_IGET_BULKSTAT to xfs_iget for handle operations
      [XFS] fix compile of xfs_btree_readahead_lblock on m68k
      [XFS] truncate readdir offsets to signed 32 bit values
      [XFS] make xfs_ino_t an unsigned long long

Eric Sandeen (3):
      [XFS] Remove several unused typedefs.
      [XFS] Remove macro-to-function indirections in attr code
      [XFS] Remove macro-to-function indirections in the mask code

Lachlan McIlroy (2):
      [XFS] Update maintainers
      Merge git://git.kernel.org/.../torvalds/linux-2.6 into for-linus

Nick Piggin (2):
      [XFS] remove old vmap cache
      [XFS] use scalable vmap API

 MAINTAINERS                   |    4 +-
 fs/xfs/linux-2.6/xfs_aops.h   |    2 -
 fs/xfs/linux-2.6/xfs_buf.c    |   79 +-------------------------------------
 fs/xfs/linux-2.6/xfs_export.c |   23 +++++++++--
 fs/xfs/xfs_acl.h              |    1 -
 fs/xfs/xfs_ag.h               |    2 +-
 fs/xfs/xfs_attr_leaf.c        |   72 +++++++++++++++++-----------------
 fs/xfs/xfs_attr_leaf.h        |   12 ------
 fs/xfs/xfs_bit.h              |   10 +----
 fs/xfs/xfs_bmap_btree.c       |   84 ++++++++++++++++++++--------------------
 fs/xfs/xfs_btree.c            |    4 +-
 fs/xfs/xfs_dir2_block.c       |    7 ++-
 fs/xfs/xfs_dir2_leaf.c        |    6 +-
 fs/xfs/xfs_dir2_sf.c          |   15 ++++---
 fs/xfs/xfs_types.h            |    4 +-
 15 files changed, 122 insertions(+), 203 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
