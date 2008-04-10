Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Apr 2008 00:51:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A7pbEY028697
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 00:51:41 -0700
Date: Thu, 10 Apr 2008 17:52:08 +1000
Subject: [GIT PULL] XFS update for 2.6.25-rc9
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080410075208.C88B958C4C15@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

 fs/xfs/linux-2.6/xfs_ioctl.c   |    2 +-
 fs/xfs/quota/xfs_qm.c          |    6 +-
 fs/xfs/quota/xfs_qm_bhv.c      |    2 +-
 fs/xfs/quota/xfs_qm_syscalls.c |    4 +-
 fs/xfs/xfs_attr_leaf.c         |    6 +-
 fs/xfs/xfs_bmap.c              |   18 +++---
 fs/xfs/xfs_bmap_btree.h        |    2 +-
 fs/xfs/xfs_dir2.c              |    2 +-
 fs/xfs/xfs_fsops.c             |   24 +++++-----
 fs/xfs/xfs_ialloc.c            |    6 +-
 fs/xfs/xfs_inode.c             |    6 +-
 fs/xfs/xfs_inode_item.c        |    4 +-
 fs/xfs/xfs_itable.c            |    2 +-
 fs/xfs/xfs_log.c               |   14 +++---
 fs/xfs/xfs_log_priv.h          |    4 +-
 fs/xfs/xfs_log_recover.c       |   16 +++---
 fs/xfs/xfs_mount.c             |   59 +++++++++++++++++-----
 fs/xfs/xfs_sb.h                |  107 ++++++++++++++-------------------------
 fs/xfs/xfs_utils.c             |    6 +-
 fs/xfs/xfs_vfsops.c            |    9 ++--
 fs/xfs/xfs_vnodeops.c          |    2 +-
 21 files changed, 153 insertions(+), 148 deletions(-)

through these commits:

commit e6957ea48429aeda4f5d51af4238231d44b0dc4a
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Apr 10 12:19:34 2008 +1000

    [XFS] Ensure "both" features2 slots are consistent
    
    Since older kernels may look in the sb_bad_features2 slot for flags,
    rather than zeroing it out on fixup, we should make it equal to the
    sb_features2 value.
    
    Also, if the ATTR2 flag was not found prior to features2 fixup, it was not
    set in the mount flags, so re-check after the fixup so that the current
    session will use the feature.
    
    Also fix up the comments to reflect these changes.
    
    SGI-PV: 980085
    SGI-Modid: xfs-linux-melb:xfs-kern:30778a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit ee1c090825bf2f1cb9712489c234eabf69a9a78f
Author: David Chinner <dgc@sgi.com>
Date:   Thu Mar 6 13:45:50 2008 +1100

    [XFS] Fix superblock features2 field alignment problem
    
    Due to the xfs_dsb_t structure not being 64 bit aligned, the last field of
    the on-disk superblock can vary in location This causes problems when the
    filesystem gets moved to a different platform, or there is a 32 bit
    userspace and 64 bit kernel.
    
    This patch detects the defect at mount time, logs a warning such as:
    
    XFS: correcting sb_features alignment problem
    
    in dmesg and corrects the problem so that everything is OK. it also
    blacklists the bad field in the superblock so it does not get used for
    something else later on.
    
    SGI-PV: 977636
    SGI-Modid: xfs-linux-melb:xfs-kern:30539a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 6211870992502efdccf9cd6bae155c83277835fa
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Mar 6 13:44:28 2008 +1100

    [XFS] remove shouting-indirection macros from xfs_sb.h
    
    Remove macro-to-small-function indirection from xfs_sb.h, and remove some
    which are completely unused.
    
    SGI-PV: 976035
    SGI-Modid: xfs-linux-melb:xfs-kern:30528a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
