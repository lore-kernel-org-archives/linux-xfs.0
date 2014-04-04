Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9AFEF7FFA
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2014 17:06:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 600A38F8039
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2014 15:06:01 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	lAH1kITAfZEKHLRU for <xfs@oss.sgi.com>;
	Fri, 04 Apr 2014 15:05:58 -0700 (PDT)
Date: Sat, 5 Apr 2014 09:05:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] XFS updates for 3.15-rc1
Message-ID: <20140404220545.GQ16336@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

Please pull the following XFS updates for 3.15-rc1. There are a
couple of new fallocate features in this request - it was decided
that it was easiest to push them through the XFS tree using topic
branches and have the ext4 support be based on those branches. Hence
you may see some overlap with the ext4 tree merge depending on how
they including those topic branches into their tree. Other than
that, there is O_TMPFILE support, some cleanups and bug fixes.

I've used a signed tag for this pull like you wanted me to do. I
think a few people signed my new gpg key last week at LSFMM so it
shouldn't be completely bare.

Hopefully I haven't screwed anything up - let me know if there's
anything you'd like me to do differently in future.

Cheers,

Dave.

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/xfs-for-linus-3.15-rc1

for you to fetch changes up to a6cf33bc566c5fe888bfa9cf6448037c90661f67:

  Merge branch 'xfs-bug-fixes-for-3.15-3' into for-next (2014-04-04 08:07:35 +1100)

----------------------------------------------------------------

xfs: update for 3.15-rc1

The main changes in the XFS tree for 3.15-rc1 are:

        - O_TMPFILE support
        - allowing AIO+DIO writes beyond EOF
        - FALLOC_FL_COLLAPSE_RANGE support for fallocate syscall and XFS
          implementation
        - FALLOC_FL_ZERO_RANGE support for fallocate syscall and XFS
          implementation
        - IO verifier cleanup and rework
        - stack usage reduction changes
        - vm_map_ram NOIO context fixes to remove lockdep warings
        - various bug fixes and cleanups

----------------------------------------------------------------
Ben Myers (1):
      MAINTAINERS: SGI no longer maintaining XFS

Brian Foster (3):
      xfs: use tr_growrtalloc for growing rt files
      xfs: use tr_qm_dqalloc log reservation for dquot alloc
      xfs: avoid AGI/AGF deadlock scenario for inode chunk allocation

Christoph Hellwig (4):
      direct-io: add flag to allow aio writes beyond i_size
      xfs: always use unwritten extents for direct I/O writes
      xfs: allow appending aio writes
      xfs: ensure correct timestamp updates from truncate

Dan Carpenter (1):
      xfs: extra semi-colon breaks a condition

Dave Chinner (16):
      xfs: ensure correct log item buffer alignment
      Merge branch 'xfs-fixes-for-3.15' into for-next
      Merge remote-tracking branch 'xfs-async-aio-extend' into for-next
      xfs: always do log forces via the workqueue
      xfs: allocate xfs_da_args to reduce stack footprint
      xfs: fix directory inode iolock lockdep false positive
      xfs: don't leak EFSBADCRC to userspace
      xfs: use NOIO contexts for vm_map_ram
      xfs: xfs_check_page_type buffer checks need help
      xfs: inode log reservations are still too small
      Merge branch 'xfs-collapse-range' into for-next
      Merge branch 'xfs-stack-fixes' into for-next
      Merge branch 'xfs-verifier-cleanup' into for-next
      Merge branch 'xfs-bug-fixes-for-3.15-2' into for-next
      Merge branch 'xfs-O_TMPFILE-support' into for-next
      Merge branch 'xfs-bug-fixes-for-3.15-3' into for-next

Eric Sandeen (12):
      xfs: remove unused tr_swrite
      xfs: sanitize sb_inopblock in xfs_mount_validate_sb
      xfs: xfs_sb_read_verify() doesn't flag bad crcs on primary sb
      xfs: skip verification on initial "guess" superblock read
      xfs: limit superblock corruption errors to actual corruption
      xfs: skip pointless CRC updates after verifier failures
      xfs: Use defines for CRC offsets in all cases
      xfs: add helper for verifying checksums on xfs_bufs
      xfs: add helper for updating checksums on xfs_bufs
      xfs: add xfs_verifier_error()
      xfs: print useful caller information in xfs_error_report
      xfs: modify verifiers to differentiate CRC from other errors

Jie Liu (3):
      xfs: convert xfs_log_commit_cil() to void
      xfs: return -E2BIG if hit the maximum size limits of ACLs
      xfs: remove XFS_TRANS_DEBUG dead code

Lukas Czerner (2):
      fs: Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
      xfs: Add support for FALLOC_FL_ZERO_RANGE

Mark Tinguely (1):
      xfs: fix directory hash ordering bug

Namjae Jeon (2):
      fs: Add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
      xfs: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate

Zhi Yong Wu (3):
      xfs: factor prid related codes into xfs_get_initial_prid()
      xfs: add O_TMPFILE support
      xfs: allow linkat() on O_TMPFILE files

 MAINTAINERS                 |    1 -
 fs/direct-io.c              |   18 ++-
 fs/open.c                   |   29 +++-
 fs/xfs/kmem.c               |   21 ++-
 fs/xfs/xfs_acl.c            |    2 +-
 fs/xfs/xfs_ag.h             |    6 +
 fs/xfs/xfs_alloc.c          |   45 +++---
 fs/xfs/xfs_alloc_btree.c    |   16 +-
 fs/xfs/xfs_aops.c           |   84 +++++++----
 fs/xfs/xfs_attr_leaf.c      |   17 ++-
 fs/xfs/xfs_attr_remote.c    |   15 +-
 fs/xfs/xfs_bmap.c           |  193 ++++++++++++++++++++++++
 fs/xfs/xfs_bmap.h           |   15 ++
 fs/xfs/xfs_bmap_btree.c     |   16 +-
 fs/xfs/xfs_bmap_util.c      |   97 +++++++++++-
 fs/xfs/xfs_bmap_util.h      |    2 +
 fs/xfs/xfs_btree.c          |   14 +-
 fs/xfs/xfs_buf.c            |   11 ++
 fs/xfs/xfs_buf.h            |   14 ++
 fs/xfs/xfs_buf_item.c       |   19 ---
 fs/xfs/xfs_da_btree.c       |   19 +--
 fs/xfs/xfs_dinode.h         |    2 +
 fs/xfs/xfs_dir2.c           |  342 +++++++++++++++++++++++++++----------------
 fs/xfs/xfs_dir2_block.c     |   17 ++-
 fs/xfs/xfs_dir2_data.c      |   20 +--
 fs/xfs/xfs_dir2_leaf.c      |   17 ++-
 fs/xfs/xfs_dir2_node.c      |   17 ++-
 fs/xfs/xfs_dquot.c          |    2 +-
 fs/xfs/xfs_dquot_buf.c      |   11 +-
 fs/xfs/xfs_error.c          |   27 +++-
 fs/xfs/xfs_error.h          |    1 +
 fs/xfs/xfs_file.c           |   26 +++-
 fs/xfs/xfs_format.h         |    2 +
 fs/xfs/xfs_ialloc.c         |   36 +++--
 fs/xfs/xfs_ialloc_btree.c   |   16 +-
 fs/xfs/xfs_inode.c          |  123 +++++++++++++++-
 fs/xfs/xfs_inode.h          |   12 ++
 fs/xfs/xfs_inode_buf.c      |    7 +-
 fs/xfs/xfs_iomap.c          |   10 +-
 fs/xfs/xfs_iops.c           |   46 +++++-
 fs/xfs/xfs_linux.h          |    2 +
 fs/xfs/xfs_log.h            |    2 +-
 fs/xfs/xfs_log_cil.c        |   74 +++++++---
 fs/xfs/xfs_mount.c          |   27 +++-
 fs/xfs/xfs_rtalloc.c        |    2 +-
 fs/xfs/xfs_sb.c             |   23 ++-
 fs/xfs/xfs_sb.h             |    2 +
 fs/xfs/xfs_shared.h         |    4 +-
 fs/xfs/xfs_symlink.c        |    9 +-
 fs/xfs/xfs_symlink_remote.c |   16 +-
 fs/xfs/xfs_trace.h          |    1 +
 fs/xfs/xfs_trans.c          |   12 +-
 fs/xfs/xfs_trans_buf.c      |   11 ++
 fs/xfs/xfs_trans_resv.c     |   82 +++++++++--
 fs/xfs/xfs_trans_resv.h     |    3 +-
 include/linux/fs.h          |    3 +
 include/uapi/linux/falloc.h |   35 +++++
 57 files changed, 1256 insertions(+), 440 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
