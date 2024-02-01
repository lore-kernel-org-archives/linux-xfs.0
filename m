Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D9D8527B
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816352; cv=none; b=kRtyR+zLLFRWjHuSnK0VpCcn0lck6fTq3+FWJAnKG32mwNZ3WM/DX/O+FuSW21XtM6XpJIXSlKzl4prXssXUpnnZzJLXqaQi47AlXcCyhaLUhgXVc5OX9jdNT7xFU9qULy366kJuGt0a6diFAJjoVJ8OGvZy0cljjHM062Qej/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816352; c=relaxed/simple;
	bh=wiS/Q9kSMwWlBPSg06qZ2u/IwO7t1jGRPRgPPScEgVs=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=Rg5C6AKagEITBmahxPoWlft5bv4DvaN8fVHTuwnGkan7tskq1PffkxxcNqPYuV33bzQpHlnIjoVpEwwBFgBW+SKySRLS375yJj+oOcJsM0A/cITRvRJOgmA7heIlQXfBpQPhakHdb2Qx9tg8fBKyUHjteMHshAGn0yRy3/iWKkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UmfLcr3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UmfLcr3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E42DC433C7;
	Thu,  1 Feb 2024 19:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816351;
	bh=wiS/Q9kSMwWlBPSg06qZ2u/IwO7t1jGRPRgPPScEgVs=;
	h=Date:Subject:From:To:Cc:From;
	b=UmfLcr3lEKa8ulO5gL8AXDY1Bftcy3SfQYx09jJTYMC4knsAT1eS2fCVTfnJg4ufY
	 isY8FOiKIvcaEkFKrIXamcP2A0STxnvGPAzyWPMmoMMRRQfNbiOFXi5iFvXnEp+7DP
	 MMLjxqaBUT03FqidPOGP5quw5ANWEUG8lYhmswh0dOfWRKQiKUZ9ylHJtqEsGyvI3s
	 PRzCB1xBRPW3nm/zrbqxWBklngAfRodVps2VZZv5GyiLcU1MqBHzIUI40k/D+/xIKp
	 xU2ZpKlO99cJsydN0ETcPHh+Wbu82s4p2/H9t9QW5a8up5fk1Flu+FwHgDGS3b9Cj+
	 GYMR9MibKEawA==
Date: Thu, 01 Feb 2024 11:39:10 -0800
Subject: [PATCHSET v29.2 1/8] xfs: move btree geometry to ops struct
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
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

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-geometry-in-ops

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=btree-geometry-in-ops
---
Commits in this patchset:
 * xfs: consolidate btree block freeing tracepoints
 * xfs: consolidate btree block allocation tracepoints
 * xfs: set the btree cursor bc_ops in xfs_btree_alloc_cursor
 * xfs: drop XFS_BTREE_CRC_BLOCKS
 * xfs: fix imprecise logic in xchk_btree_check_block_owner
 * xfs: encode the btree geometry flags in the btree ops structure
 * xfs: remove bc_ino.flags
 * xfs: consolidate the xfs_alloc_lookup_* helpers
 * xfs: turn the allocbt cursor active field into a btree flag
 * xfs: extern some btree ops structures
 * xfs: initialize btree blocks using btree_ops structure
 * xfs: rename btree block/buffer init functions
 * xfs: btree convert xfs_btree_init_block to xfs_btree_init_buf calls
 * xfs: remove the unnecessary daddr paramter to _init_block
 * xfs: set btree block buffer ops in _init_buf
 * xfs: move lru refs to the btree ops structure
 * xfs: move the btree stats offset into struct btree_ops
 * xfs: factor out a xfs_btree_owner helper
 * xfs: factor out a btree block owner check
 * xfs: store the btree pointer length in struct xfs_btree_ops
 * xfs: split out a btree type from the btree ops geometry flags
 * xfs: split the per-btree union in struct xfs_btree_cur
 * xfs: create predicate to determine if cursor is at inode root level
---
 fs/xfs/libxfs/xfs_ag.c             |   33 +--
 fs/xfs/libxfs/xfs_ag.h             |    2 
 fs/xfs/libxfs/xfs_alloc.c          |   54 +++--
 fs/xfs/libxfs/xfs_alloc_btree.c    |   39 ++--
 fs/xfs/libxfs/xfs_bmap.c           |   58 ++----
 fs/xfs/libxfs/xfs_bmap_btree.c     |   59 +++---
 fs/xfs/libxfs/xfs_bmap_btree.h     |    3 
 fs/xfs/libxfs/xfs_btree.c          |  365 ++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_btree.h          |  165 +++++++++-------
 fs/xfs/libxfs/xfs_btree_staging.c  |   20 +-
 fs/xfs/libxfs/xfs_btree_staging.h  |    3 
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   35 ++-
 fs/xfs/libxfs/xfs_refcount.c       |   24 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |   24 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |   19 +-
 fs/xfs/libxfs/xfs_shared.h         |    9 +
 fs/xfs/scrub/btree.c               |   29 ++-
 fs/xfs/scrub/newbt.c               |    2 
 fs/xfs/scrub/trace.c               |    2 
 fs/xfs/xfs_trace.h                 |   83 ++++++++
 20 files changed, 566 insertions(+), 462 deletions(-)

