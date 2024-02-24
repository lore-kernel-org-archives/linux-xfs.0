Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6704688
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738247; cv=none; b=ZRciSawSo9FXhn/bZnWqsO+xAAZKwC9xmXxkTGq/qKVRnNp2pnVmMPnpijp0+N+zr6Pcbna4rIc+9AjiRWV8d06o1rDqKrFoa14ufugCOGqe4bpyL0HYL+6OmJ9YYlQYVTn9aWOu+WkjNNdx/RuZwcHAbmd0AEdyG5v3+z031Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738247; c=relaxed/simple;
	bh=KO+GKY+7UqFG9w/cP94mtZtMiUjHLxVG9EAmyRlMdJc=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=dLMZTS28Uq2xxrlcNUTprAuNLMjQmjEW5zXHdVa6vYPX2KxmBMJo3MX39e1kauWjmu+SoI2cnK/zP2lZ3HJ5L/KiumlZ5jjNAQGkT09IpS0/mUwzBlPXHNGfScdf7swsDklkl0nFHQXSEK2r2tD+bJ+hVrp/wvyoI/XzgzdV8AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k4ayKDRl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k4ayKDRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A517C433F1;
	Sat, 24 Feb 2024 01:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738247;
	bh=KO+GKY+7UqFG9w/cP94mtZtMiUjHLxVG9EAmyRlMdJc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k4ayKDRl12iAdCQ9g3BKOudF7JuxgphpapvYc7j9HP8w8612MOzcbzlfNKPZYay2V
	 32dfx7uGI2qRdjLgu3cud4LLOkGnCL/Oe51wuP8mnnLRMgdBwBdOGCkahWx3GCSF8A
	 2gIytu7ZuPwJoZ9em7/vvZIcQ+6q5Le9z/eE+e5RDlWHcAkRsQmCdbNjep5Q4He9Na
	 LMyuJ3+BrLkrDF9rku594pcSf/2ryEHWKg9i8C9mPtkh//mMoircC+pRn8uvgOy7Dh
	 zD/+I6AhWnG8W/KJKupXXf2ubDhzDo33VWoBGJI0EkYqRCuzRzXe6IV7R/5ERcBpBq
	 PIU9fAQXrICuw==
Date: Fri, 23 Feb 2024 17:30:46 -0800
Subject: [GIT PULL 7/18] xfs: move btree geometry to ops struct
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170873802963.1891722.16861837496958424107.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240224010220.GN6226@frogsfrogsfrogs>
References: <20240224010220.GN6226@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.9-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 4ed080cd7cb077bbb4b64f0712be1618c9d55a0d:

xfs: repair summary counters (2024-02-22 12:33:05 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/btree-geometry-in-ops-6.9_2024-02-23

for you to fetch changes up to f73def90a7cd24a32a42f689efba6a7a35edeb7b:

xfs: create predicate to determine if cursor is at inode root level (2024-02-22 12:37:24 -0800)

----------------------------------------------------------------
xfs: move btree geometry to ops struct [v29.3 07/18]

This patchset prepares the generic btree code to allow for the creation
of new btree types outside of libxfs.  The end goal here is for online
fsck to be able to create its own in-memory btrees that will be used to
improve the performance (and reduce the memory requirements of) the
refcount btree.

To enable this, I decided that the btree ops structure is the ideal
place to encode all of the geometry information about a btree. The btree
ops struture already contains the buffer ops (and hence the btree block
magic numbers) as well as the key and record sizes, so it doesn't seem
all that farfetched to encode the XFS_BTREE_ flags that determine the
geometry (ROOT_IN_INODE, LONG_PTRS, etc).

The rest of the patchset cleans up the btree functions that initialize
btree blocks and btree buffers.  The bulk of this work is to replace
btree geometry related function call arguments with a single pointer to
the ops structure, and then clean up everything else around that.  As a
side effect, we rename the functions.

Later, Christoph Hellwig and I merged together a bunch more cleanups
that he wanted to do for a while.  All the btree geometry information is
now in the btree ops structure, we've created an explicit btree type
(ag, inode, mem) and moved the per-btree type information to a separate
union.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (6):
xfs: remove bc_ino.flags
xfs: consolidate the xfs_alloc_lookup_* helpers
xfs: turn the allocbt cursor active field into a btree flag
xfs: move the btree stats offset into struct btree_ops
xfs: split out a btree type from the btree ops geometry flags
xfs: split the per-btree union in struct xfs_btree_cur

Darrick J. Wong (17):
xfs: consolidate btree block freeing tracepoints
xfs: consolidate btree block allocation tracepoints
xfs: set the btree cursor bc_ops in xfs_btree_alloc_cursor
xfs: drop XFS_BTREE_CRC_BLOCKS
xfs: fix imprecise logic in xchk_btree_check_block_owner
xfs: encode the btree geometry flags in the btree ops structure
xfs: extern some btree ops structures
xfs: initialize btree blocks using btree_ops structure
xfs: rename btree block/buffer init functions
xfs: btree convert xfs_btree_init_block to xfs_btree_init_buf calls
xfs: remove the unnecessary daddr paramter to _init_block
xfs: set btree block buffer ops in _init_buf
xfs: move lru refs to the btree ops structure
xfs: factor out a xfs_btree_owner helper
xfs: factor out a btree block owner check
xfs: store the btree pointer length in struct xfs_btree_ops
xfs: create predicate to determine if cursor is at inode root level

fs/xfs/libxfs/xfs_ag.c             |  33 ++--
fs/xfs/libxfs/xfs_ag.h             |   2 +-
fs/xfs/libxfs/xfs_alloc.c          |  54 +++---
fs/xfs/libxfs/xfs_alloc_btree.c    |  39 ++--
fs/xfs/libxfs/xfs_bmap.c           |  58 +++---
fs/xfs/libxfs/xfs_bmap_btree.c     |  59 +++---
fs/xfs/libxfs/xfs_bmap_btree.h     |   3 +
fs/xfs/libxfs/xfs_btree.c          | 365 +++++++++++++++++++------------------
fs/xfs/libxfs/xfs_btree.h          | 165 +++++++++--------
fs/xfs/libxfs/xfs_btree_staging.c  |  20 +-
fs/xfs/libxfs/xfs_btree_staging.h  |   3 +-
fs/xfs/libxfs/xfs_ialloc_btree.c   |  35 ++--
fs/xfs/libxfs/xfs_refcount.c       |  24 +--
fs/xfs/libxfs/xfs_refcount_btree.c |  24 ++-
fs/xfs/libxfs/xfs_rmap_btree.c     |  19 +-
fs/xfs/libxfs/xfs_shared.h         |   9 +
fs/xfs/scrub/btree.c               |  29 +--
fs/xfs/scrub/newbt.c               |   2 +-
fs/xfs/scrub/trace.c               |   2 +-
fs/xfs/xfs_trace.h                 |  83 ++++++++-
20 files changed, 566 insertions(+), 462 deletions(-)

