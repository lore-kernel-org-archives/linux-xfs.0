Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1324C62E
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 22:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713391703; cv=none; b=eXG6UimJ2ryirWQeU6mrGZcmFSb4/ou3e+SUGWqXxlbrWcmH2AcjmXP2KfsO/94EdkuuqVkClK3insglQ/+IT5cMkwZ2oghmWlNsIRbzslYZn1dj997UCXi9Ks8j9IJbJVlMFxdHmBfKMVcUare50+HNtF4kIQuNwD4PooOJS5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713391703; c=relaxed/simple;
	bh=ckwpJnqOjiia10C1cgxa2kBG4yjgoZrRUwU9DbBygnc=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=CEPCYTHwI6j+3QMEnawKQ+s/zaPJHQ8MLqJ65oDLnqu+7qifl/EM8xv7DqKAKNRayAm3KIrtWte4xvr3+5WqUPpZOzYfmicBuV1gKBZ1AeRsGuzbgL6iFh2oODFgKgzPokMIuv3OvJdue3ulye3lcv+cUQvcVCQguL2Ny9kUmHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qSCUcQze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qSCUcQze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF301C072AA;
	Wed, 17 Apr 2024 22:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713391702;
	bh=ckwpJnqOjiia10C1cgxa2kBG4yjgoZrRUwU9DbBygnc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qSCUcQzeBoPV/l5v+lJJ4uA+2zzxFXTaZr19ng1oZGkSKr6bBcv9fHeYF5FCZ1HjU
	 JFnwY7x5y0n4kXtYXUxFp3Go9qpu33WzQSEit4Bfh5YcmdzAOY9bbfxmk/o8QQPtUu
	 CQzNUzz9mi4kNDBym48/gvzvXuJXlbDfzvIMuw0Y8kz7HZ/ao4+bKfW4/xZKL/ux1T
	 /Fi77+sMfo3Ss8DHagNbulutcOWp4jAB4LeSMBBOVd+VpwqCsEryQKSsp0L30czgyR
	 dPbWW7IsmlRt7/EIOtcRBVn9+d0jzGcJ/GC87tYPas9bGlR+l4u4kgQUhp556AagrQ
	 w8k9pCWlkHHqQ==
Date: Wed, 17 Apr 2024 15:08:22 -0700
Subject: [GIT PULL 04/11] libxfs: sync with 6.8
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: aalbersh@redhat.com, bodonnel@redhat.com, chandanbabu@kernel.org, cmaiolino@redhat.com, david@fromorbit.com, dchinner@redhat.com, hch@lst.de, leo.lilong@huawei.com, linux-xfs@vger.kernel.org, oliver.sang@intel.com, zhangjiachen.jaycee@bytedance.com, zhangtianci.1997@bytedance.com
Message-ID: <171339159500.1911630.17668662614426876034.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240417220440.GB11948@frogsfrogsfrogs>
References: <20240417220440.GB11948@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 9c69d1c725391f9a65fa8d6d2be337466918e248:

xfs_{db,repair}: use m_blockwsize instead of sb_blocksize for rt blocks (2024-04-17 14:06:23 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/libxfs-sync-6.8_2024-04-17

for you to fetch changes up to a6e7d369929423b10df05d11dddd1dd9550e4f20:

xfs: remove conditional building of rt geometry validator functions (2024-04-17 14:06:27 -0700)

----------------------------------------------------------------
libxfs: sync with 6.8 [04/20]

Synchronize libxfs with the kernel.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Andrey Albershteyn (1):
xfs: reset XFS_ATTR_INCOMPLETE filter on node removal

Christoph Hellwig (24):
xfs: move xfs_ondisk.h to libxfs/
xfs: consolidate the xfs_attr_defer_* helpers
xfs: store an ops pointer in struct xfs_defer_pending
xfs: pass the defer ops instead of type to xfs_defer_start_recovery
xfs: pass the defer ops directly to xfs_defer_add
xfs: remove the xfs_alloc_arg argument to xfs_bmap_btalloc_accounting
xfs: also use xfs_bmap_btalloc_accounting for RT allocations
xfs: return -ENOSPC from xfs_rtallocate_*
xfs: indicate if xfs_bmap_adjacent changed ap->blkno
xfs: move xfs_rtget_summary to xfs_rtbitmap.c
xfs: split xfs_rtmodify_summary_int
xfs: remove rt-wrappers from xfs_format.h
xfs: remove XFS_RTMIN/XFS_RTMAX
xfs: make if_data a void pointer
xfs: return if_data from xfs_idata_realloc
xfs: move the xfs_attr_sf_lookup tracepoint
xfs: simplify xfs_attr_sf_findname
xfs: remove xfs_attr_shortform_lookup
xfs: use xfs_attr_sf_findname in xfs_attr_shortform_getvalue
xfs: remove struct xfs_attr_shortform
xfs: remove xfs_attr_sf_hdr_t
xfs: turn the XFS_DA_OP_REPLACE checks in xfs_attr_shortform_addname into asserts
xfs: fix a use after free in xfs_defer_finish_recovery
xfs: use the op name in trace_xlog_intent_recovery_failed

Darrick J. Wong (37):
xfs: use xfs_defer_pending objects to recover intent items
xfs: recreate work items when recovering intent items
xfs: use xfs_defer_finish_one to finish recovered work items
xfs: move ->iop_recover to xfs_defer_op_type
xfs: hoist intent done flag setting to ->finish_item callsite
xfs: hoist ->create_intent boilerplate to its callsite
xfs: use xfs_defer_create_done for the relogging operation
xfs: clean out XFS_LI_DIRTY setting boilerplate from ->iop_relog
xfs: hoist xfs_trans_add_item calls to defer ops functions
xfs: move ->iop_relog to struct xfs_defer_op_type
xfs: make rextslog computation consistent with mkfs
xfs: fix 32-bit truncation in xfs_compute_rextslog
xfs: don't allow overly small or large realtime volumes
xfs: elide ->create_done calls for unlogged deferred work
xfs: don't append work items to logged xfs_defer_pending objects
xfs: allow pausing of pending deferred work items
xfs: remove __xfs_free_extent_later
xfs: automatic freeing of freshly allocated unwritten space
xfs: remove unused fields from struct xbtree_ifakeroot
xfs: force small EFIs for reaping btree extents
xfs: force all buffers to be written during btree bulk load
xfs: set XBF_DONE on newly formatted btree block that are ready for writing
xfs: read leaf blocks when computing keys for bulkloading into node blocks
xfs: move btree bulkload record initialization to ->get_record implementations
xfs: constrain dirty buffers while formatting a staged btree
xfs: repair free space btrees
xfs: repair inode btrees
xfs: repair refcount btrees
xfs: dont cast to char * for XFS_DFORK_*PTR macros
xfs: set inode sick state flags when we zap either ondisk fork
xfs: zap broken inode forks
xfs: repair inode fork block mapping data structures
xfs: create a ranged query function for refcount btrees
xfs: create a new inode fork block unmap helper
xfs: improve dquot iteration for scrub
xfs: fix backwards logic in xfs_bmap_alloc_account
xfs: remove conditional building of rt geometry validator functions

Jiachen Zhang (1):
xfs: ensure logflagsp is initialized in xfs_bmap_del_extent_real

Long Li (2):
xfs: add lock protection when remove perag from radix tree
xfs: fix perag leak when growfs fails

Zhang Tianci (2):
xfs: update dir3 leaf block metadata after swap
xfs: extract xfs_da_buf_copy() helper function

db/attrshort.c              |  35 ++--
db/check.c                  |  12 +-
db/inode.c                  |   6 +-
db/metadump.c               |  16 +-
db/namei.c                  |   4 +-
include/list.h              |  14 ++
include/xfs_trace.h         |   5 +
include/xfs_trans.h         |   1 -
libxfs/defer_item.c         |  16 +-
libxfs/init.c               |   6 +
libxfs/libxfs_api_defs.h    |   4 +
libxfs/libxfs_io.h          |  11 ++
libxfs/libxfs_priv.h        |   7 +-
libxfs/util.c               |   2 +-
libxfs/xfs_ag.c             |  38 +++-
libxfs/xfs_ag.h             |  12 ++
libxfs/xfs_ag_resv.c        |   2 +
libxfs/xfs_alloc.c          | 116 ++++++++++--
libxfs/xfs_alloc.h          |  24 +--
libxfs/xfs_alloc_btree.c    |  13 +-
libxfs/xfs_attr.c           | 131 ++++---------
libxfs/xfs_attr_leaf.c      | 244 ++++++++----------------
libxfs/xfs_attr_leaf.h      |   8 +-
libxfs/xfs_attr_sf.h        |  24 ++-
libxfs/xfs_bmap.c           | 201 ++++++++++++--------
libxfs/xfs_bmap.h           |   9 +-
libxfs/xfs_bmap_btree.c     | 124 ++++++++++--
libxfs/xfs_bmap_btree.h     |   5 +
libxfs/xfs_btree.c          |  28 ++-
libxfs/xfs_btree.h          |   5 +
libxfs/xfs_btree_staging.c  |  89 ++++++---
libxfs/xfs_btree_staging.h  |  33 ++--
libxfs/xfs_da_btree.c       |  69 +++----
libxfs/xfs_da_btree.h       |   2 +
libxfs/xfs_da_format.h      |  31 +--
libxfs/xfs_defer.c          | 452 ++++++++++++++++++++++++++++++++++++--------
libxfs/xfs_defer.h          |  59 ++++--
libxfs/xfs_dir2.c           |   2 +-
libxfs/xfs_dir2_block.c     |   6 +-
libxfs/xfs_dir2_priv.h      |   3 +-
libxfs/xfs_dir2_sf.c        |  91 ++++-----
libxfs/xfs_format.h         |  19 +-
libxfs/xfs_health.h         |  10 +
libxfs/xfs_ialloc.c         |  36 ++--
libxfs/xfs_ialloc.h         |   3 +-
libxfs/xfs_ialloc_btree.c   |   2 +-
libxfs/xfs_iext_tree.c      |  59 +++---
libxfs/xfs_inode_fork.c     |  78 ++++----
libxfs/xfs_inode_fork.h     |  13 +-
libxfs/xfs_ondisk.h         | 199 +++++++++++++++++++
libxfs/xfs_refcount.c       |  57 +++++-
libxfs/xfs_refcount.h       |  12 +-
libxfs/xfs_refcount_btree.c |  15 +-
libxfs/xfs_rmap.c           |   2 +-
libxfs/xfs_rtbitmap.c       | 134 ++++++-------
libxfs/xfs_rtbitmap.h       |   4 +-
libxfs/xfs_sb.c             |  20 +-
libxfs/xfs_sb.h             |   2 +
libxfs/xfs_shared.h         |   2 +-
libxfs/xfs_symlink_remote.c |  12 +-
libxfs/xfs_types.h          |  20 +-
mkfs/proto.c                |   4 +-
mkfs/xfs_mkfs.c             |   8 +-
repair/agbtree.c            |  57 ++++--
repair/attr_repair.c        |  48 +++--
repair/dinode.c             |  23 +--
repair/phase6.c             |   9 +-
repair/rt.c                 |   6 +-
repair/sb.c                 |   6 +-
69 files changed, 1861 insertions(+), 959 deletions(-)
create mode 100644 libxfs/xfs_ondisk.h

