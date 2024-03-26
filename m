Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8A45788E
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 02:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711421716; cv=none; b=B2dNi9ZE0WrKDbOMLvPobPGs7i6XnC7dOZYk5n48PMVSQUtwPmItfyNnfyxbHfDnZE0ZJkHRh6SFTxCyb1JsNwh4k6eSnnq6g5IF9P/FJ5OgI7qbIHI5d9xSqbw5snhGjcRASJnGQI0peFul1waSLzPIefzieiD+92aSlwp4yRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711421716; c=relaxed/simple;
	bh=/ewQraSQKqTVmG+9ItidMMP0as1oIUM/l0di/2wqoq8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ALNAzAIiKuKgV5m4bkP489DocCcE0F6CKA/3AFEs50ofb15aXerZxMcZ7b53TAyx5ZzBE2lv+BSGzc7tdzSok1s7YeK07TK9Pz7vjOLC4ZTp67T8OcrzcozcbPkuv85iXxto83okgWUx1H99J43vqeg5GuAhyTibMT0Kw253S38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m7osdHrC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m7osdHrC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9139CC433C7;
	Tue, 26 Mar 2024 02:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711421715;
	bh=/ewQraSQKqTVmG+9ItidMMP0as1oIUM/l0di/2wqoq8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=m7osdHrCA4wfgFqleqtwcbGGcW71GMKDo9yRvXX4oj6qlnmqCArXIItdHI0KFLfXx
	 SJxKENa22uHtZWz7kqnsA9jIYhRXLR2LlD3LnD8K7/S90aDQQ4Duvaae2i1XX/OJ/S
	 8GqoWOn0ArTkpDE61qLZt9LrSK90tZj3qTHONxjdoBSlJnxYcdU7OX5MNPgagYjlZH
	 zY9dXA1MHtFpkPKckgYrGyS8R8qvV0c4Kqf0ofQJdH4lv9b0XtNvg0vS+tqWBY9JJf
	 IDFpoIZLFyF0mZVi+9pbAfI2ClCcGQoYJaV2MjdugRU+6GLcKHf03DTS2gVUrGZSxr
	 DvTG6VKp8fxog==
Date: Mon, 25 Mar 2024 19:55:15 -0700
Subject: [PATCHSET 02/18] libxfs: sync with 6.8
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Chandan Babu R <chandanbabu@kernel.org>,
 kernel test robot <oliver.sang@intel.com>,
 Andrey Albershteyn <aalbersh@redhat.com>,
 Bill O'Donnell <bodonnel@redhat.com>,
 Zhang Tianci <zhangtianci.1997@bytedance.com>,
 Dave Chinner <dchinner@redhat.com>, Dave Chinner <david@fromorbit.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
 Long Li <leo.lilong@huawei.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
In-Reply-To: <20240326024549.GE6390@frogsfrogsfrogs>
References: <20240326024549.GE6390@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Synchronize libxfs with the kernel.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-6.8-sync
---
Commits in this patchset:
 * xfs: use xfs_defer_pending objects to recover intent items
 * xfs: recreate work items when recovering intent items
 * xfs: use xfs_defer_finish_one to finish recovered work items
 * xfs: move ->iop_recover to xfs_defer_op_type
 * xfs: hoist intent done flag setting to ->finish_item callsite
 * xfs: hoist ->create_intent boilerplate to its callsite
 * xfs: use xfs_defer_create_done for the relogging operation
 * xfs: clean out XFS_LI_DIRTY setting boilerplate from ->iop_relog
 * xfs: hoist xfs_trans_add_item calls to defer ops functions
 * xfs: move ->iop_relog to struct xfs_defer_op_type
 * xfs: make rextslog computation consistent with mkfs
 * xfs: fix 32-bit truncation in xfs_compute_rextslog
 * xfs: don't allow overly small or large realtime volumes
 * xfs: elide ->create_done calls for unlogged deferred work
 * xfs: don't append work items to logged xfs_defer_pending objects
 * xfs: allow pausing of pending deferred work items
 * xfs: remove __xfs_free_extent_later
 * xfs: automatic freeing of freshly allocated unwritten space
 * xfs: remove unused fields from struct xbtree_ifakeroot
 * xfs: force small EFIs for reaping btree extents
 * xfs: ensure logflagsp is initialized in xfs_bmap_del_extent_real
 * xfs: update dir3 leaf block metadata after swap
 * xfs: extract xfs_da_buf_copy() helper function
 * xfs: move xfs_ondisk.h to libxfs/
 * xfs: consolidate the xfs_attr_defer_* helpers
 * xfs: store an ops pointer in struct xfs_defer_pending
 * xfs: pass the defer ops instead of type to xfs_defer_start_recovery
 * xfs: pass the defer ops directly to xfs_defer_add
 * xfs: force all buffers to be written during btree bulk load
 * xfs: set XBF_DONE on newly formatted btree block that are ready for writing
 * xfs: read leaf blocks when computing keys for bulkloading into node blocks
 * xfs: move btree bulkload record initialization to ->get_record implementations
 * xfs: constrain dirty buffers while formatting a staged btree
 * xfs: repair free space btrees
 * xfs: repair inode btrees
 * xfs: repair refcount btrees
 * xfs: dont cast to char * for XFS_DFORK_*PTR macros
 * xfs: set inode sick state flags when we zap either ondisk fork
 * xfs: zap broken inode forks
 * xfs: repair inode fork block mapping data structures
 * xfs: create a ranged query function for refcount btrees
 * xfs: create a new inode fork block unmap helper
 * xfs: improve dquot iteration for scrub
 * xfs: add lock protection when remove perag from radix tree
 * xfs: fix perag leak when growfs fails
 * xfs: remove the xfs_alloc_arg argument to xfs_bmap_btalloc_accounting
 * xfs: also use xfs_bmap_btalloc_accounting for RT allocations
 * xfs: return -ENOSPC from xfs_rtallocate_*
 * xfs: indicate if xfs_bmap_adjacent changed ap->blkno
 * xfs: move xfs_rtget_summary to xfs_rtbitmap.c
 * xfs: split xfs_rtmodify_summary_int
 * xfs: remove rt-wrappers from xfs_format.h
 * xfs: remove XFS_RTMIN/XFS_RTMAX
 * xfs: make if_data a void pointer
 * xfs: return if_data from xfs_idata_realloc
 * xfs: move the xfs_attr_sf_lookup tracepoint
 * xfs: simplify xfs_attr_sf_findname
 * xfs: remove xfs_attr_shortform_lookup
 * xfs: use xfs_attr_sf_findname in xfs_attr_shortform_getvalue
 * xfs: remove struct xfs_attr_shortform
 * xfs: remove xfs_attr_sf_hdr_t
 * xfs: turn the XFS_DA_OP_REPLACE checks in xfs_attr_shortform_addname into asserts
 * xfs: fix a use after free in xfs_defer_finish_recovery
 * xfs: use the op name in trace_xlog_intent_recovery_failed
 * xfs: fix backwards logic in xfs_bmap_alloc_account
 * xfs: reset XFS_ATTR_INCOMPLETE filter on node removal
 * xfs: remove conditional building of rt geometry validator functions
---
 db/attrshort.c              |   35 ++-
 db/check.c                  |   12 +
 db/inode.c                  |    6 -
 db/metadump.c               |   16 +-
 db/namei.c                  |    4 
 include/list.h              |   14 +
 include/xfs_trace.h         |    5 
 include/xfs_trans.h         |    1 
 libxfs/defer_item.c         |   16 +-
 libxfs/init.c               |    6 +
 libxfs/libxfs_api_defs.h    |    4 
 libxfs/libxfs_io.h          |   11 +
 libxfs/libxfs_priv.h        |    7 -
 libxfs/util.c               |    2 
 libxfs/xfs_ag.c             |   38 +++-
 libxfs/xfs_ag.h             |   12 +
 libxfs/xfs_ag_resv.c        |    2 
 libxfs/xfs_alloc.c          |  116 ++++++++++-
 libxfs/xfs_alloc.h          |   24 +-
 libxfs/xfs_alloc_btree.c    |   13 +
 libxfs/xfs_attr.c           |  131 ++++--------
 libxfs/xfs_attr_leaf.c      |  244 ++++++++---------------
 libxfs/xfs_attr_leaf.h      |    8 -
 libxfs/xfs_attr_sf.h        |   24 +-
 libxfs/xfs_bmap.c           |  201 ++++++++++++-------
 libxfs/xfs_bmap.h           |    9 +
 libxfs/xfs_bmap_btree.c     |  124 ++++++++++--
 libxfs/xfs_bmap_btree.h     |    5 
 libxfs/xfs_btree.c          |   28 +++
 libxfs/xfs_btree.h          |    5 
 libxfs/xfs_btree_staging.c  |   89 ++++++--
 libxfs/xfs_btree_staging.h  |   33 ++-
 libxfs/xfs_da_btree.c       |   69 +++----
 libxfs/xfs_da_btree.h       |    2 
 libxfs/xfs_da_format.h      |   31 ++-
 libxfs/xfs_defer.c          |  452 +++++++++++++++++++++++++++++++++++--------
 libxfs/xfs_defer.h          |   59 ++++--
 libxfs/xfs_dir2.c           |    2 
 libxfs/xfs_dir2_block.c     |    6 -
 libxfs/xfs_dir2_priv.h      |    3 
 libxfs/xfs_dir2_sf.c        |   91 +++------
 libxfs/xfs_format.h         |   19 --
 libxfs/xfs_health.h         |   10 +
 libxfs/xfs_ialloc.c         |   36 ++-
 libxfs/xfs_ialloc.h         |    3 
 libxfs/xfs_ialloc_btree.c   |    2 
 libxfs/xfs_iext_tree.c      |   59 +++---
 libxfs/xfs_inode_fork.c     |   78 ++++---
 libxfs/xfs_inode_fork.h     |   13 +
 libxfs/xfs_ondisk.h         |  199 +++++++++++++++++++
 libxfs/xfs_refcount.c       |   57 +++++
 libxfs/xfs_refcount.h       |   12 +
 libxfs/xfs_refcount_btree.c |   15 +
 libxfs/xfs_rmap.c           |    2 
 libxfs/xfs_rtbitmap.c       |  134 ++++++-------
 libxfs/xfs_rtbitmap.h       |    4 
 libxfs/xfs_sb.c             |   20 ++
 libxfs/xfs_sb.h             |    2 
 libxfs/xfs_shared.h         |    2 
 libxfs/xfs_symlink_remote.c |   12 -
 libxfs/xfs_types.h          |   20 ++
 mkfs/proto.c                |    4 
 mkfs/xfs_mkfs.c             |    8 +
 repair/agbtree.c            |   57 ++++-
 repair/attr_repair.c        |   48 ++---
 repair/dinode.c             |   23 +-
 repair/phase6.c             |    9 -
 repair/rt.c                 |    6 -
 repair/sb.c                 |    6 -
 69 files changed, 1861 insertions(+), 959 deletions(-)
 create mode 100644 libxfs/xfs_ondisk.h

