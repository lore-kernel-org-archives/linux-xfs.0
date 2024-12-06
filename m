Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90AE22C6DC
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733527631; cv=none; b=mvrXUGZQP8rnBqBsu1hG+BSYCp+hUBhrl7OgnssahKhoJnxcqR30h1ell5DtUzx2QNyTJ7BQx7SvPV+LmKxc+wnApcmoMu7YB93C1WMJyGk3B5NuFazPi6XD95oPxXm9w2uwp73axJjMSAxCSytwyYnsQeTqG1/BKKtccICcr0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733527631; c=relaxed/simple;
	bh=kC9dKJek9FU/WQuZJddDGqmQ5EdVWl3KaCQ0WiVYCrM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B1GXvK680p9rS8ZWPvr+d8iQVxZh6syl6ZEY+2Px0HeW+NT4HFQyT8OpflAYOaeffZTUa9JmF05v+oKqB2XkPSSAXReF9UFvxzAWijtRBFAZkT436seQ0i3mPpsjft9Te2umnUaunVw8NFp/ucj2qxodRtzYHvOfrdj0FgeWkY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bJy/HzSS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bJy/HzSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2D5C4CED1;
	Fri,  6 Dec 2024 23:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733527631;
	bh=kC9dKJek9FU/WQuZJddDGqmQ5EdVWl3KaCQ0WiVYCrM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bJy/HzSShcSjMda0UyEdF/lJN2yn5gXcZt2VMLbL7vBpKio/sQxfeD9OJaFeL/hlC
	 ryfAmW0wuDUiyR9PDD0ifXuqoxUBzO1iJbS2bwqNRGviiq16/DnW9MEIn5Csxt0Q5L
	 st48+dM/xbrM2R2JYYsw5t1v3RfUiq2fsEFET27T2+wKTI0wQ9jGiw9ntIxbFFkXbC
	 Mn6XJ/YFpGIW9aNd2kwCtO2m2UORh3TKJFqZUCFq7oINdghx2WQ22ckwrzRSjcVEyx
	 CVCoLvinjJm41rn/vyCqH3tHjvZAgNHLiadXE5yj3N6J5qSRbFNsX11sdpL5+KMAeR
	 7d2V8Nc/Tq7aA==
Date: Fri, 06 Dec 2024 15:27:10 -0800
Subject: [PATCHSET v5.8 2/9] libxfs: metadata inode directory trees
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: dchinner@redhat.com, leo.lilong@huawei.com, hch@lst.de, cem@kernel.org,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
In-Reply-To: <20241206232259.GO7837@frogsfrogsfrogs>
References: <20241206232259.GO7837@frogsfrogsfrogs>
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
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadata-directory-tree-sync
---
Commits in this patchset:
 * xfs: remove the redundant xfs_alloc_log_agf
 * xfs: sb_spino_align is not verified
 * xfs: remove the unused pagb_count field in struct xfs_perag
 * xfs: remove the unused pag_active_wq field in struct xfs_perag
 * xfs: pass a pag to xfs_difree_inode_chunk
 * xfs: remove the agno argument to xfs_free_ag_extent
 * xfs: add xfs_agbno_to_fsb and xfs_agbno_to_daddr helpers
 * xfs: add a xfs_agino_to_ino helper
 * xfs: pass a pag to xfs_extent_busy_{search,reuse}
 * xfs: pass a perag structure to the xfs_ag_resv_init_error trace point
 * xfs: pass objects to the xfs_irec_merge_{pre,post} trace points
 * xfs: convert remaining trace points to pass pag structures
 * xfs: split xfs_initialize_perag
 * xfs: insert the pag structures into the xarray later
 * xfs: factor out a generic xfs_group structure
 * xfs: add a xfs_group_next_range helper
 * xfs: switch perag iteration from the for_each macros to a while based iterator
 * xfs: move metadata health tracking to the generic group structure
 * xfs: move draining of deferred operations to the generic group structure
 * xfs: move the online repair rmap hooks to the generic group structure
 * xfs: convert busy extent tracking to the generic group structure
 * xfs: add a generic group pointer to the btree cursor
 * xfs: add group based bno conversion helpers
 * xfs: store a generic group structure in the intents
 * xfs: constify the xfs_sb predicates
 * xfs: rename metadata inode predicates
 * xfs: define the on-disk format for the metadir feature
 * xfs: iget for metadata inodes
 * xfs: enforce metadata inode flag
 * xfs: read and write metadata inode directory tree
 * xfs: disable the agi rotor for metadata inodes
 * xfs: advertise metadata directory feature
 * xfs: allow bulkstat to return metadata directories
 * xfs: adjust xfs_bmap_add_attrfork for metadir
 * xfs: record health problems with the metadata directory
 * xfs: check metadata directory file path connectivity
---
 db/check.c                  |    2 
 db/fsmap.c                  |   10 -
 db/info.c                   |    7 -
 db/inode.c                  |    4 
 db/iunlink.c                |    6 -
 include/libxfs.h            |    2 
 include/xfs_inode.h         |   11 +
 include/xfs_mount.h         |   45 +++-
 include/xfs_trace.h         |   31 ++-
 include/xfs_trans.h         |    3 
 libfrog/radix-tree.h        |    9 +
 libxfs/Makefile             |    6 +
 libxfs/defer_item.c         |   35 ++-
 libxfs/init.c               |    8 -
 libxfs/inode.c              |   55 +++++
 libxfs/iunlink.c            |   11 +
 libxfs/libxfs_api_defs.h    |   15 +
 libxfs/libxfs_priv.h        |   10 +
 libxfs/trans.c              |   39 +++
 libxfs/util.c               |    4 
 libxfs/xfs_ag.c             |  246 ++++++++--------------
 libxfs/xfs_ag.h             |  189 ++++++++++-------
 libxfs/xfs_ag_resv.c        |   22 +-
 libxfs/xfs_alloc.c          |  104 +++++----
 libxfs/xfs_alloc.h          |    7 -
 libxfs/xfs_alloc_btree.c    |   30 +--
 libxfs/xfs_attr.c           |    5 
 libxfs/xfs_bmap.c           |    7 -
 libxfs/xfs_bmap.h           |    2 
 libxfs/xfs_btree.c          |   38 +--
 libxfs/xfs_btree.h          |    3 
 libxfs/xfs_btree_mem.c      |    6 -
 libxfs/xfs_format.h         |  121 +++++++++--
 libxfs/xfs_fs.h             |   25 ++
 libxfs/xfs_group.c          |  223 ++++++++++++++++++++
 libxfs/xfs_group.h          |  131 ++++++++++++
 libxfs/xfs_health.h         |   51 ++---
 libxfs/xfs_ialloc.c         |  175 +++++++++-------
 libxfs/xfs_ialloc_btree.c   |   29 +--
 libxfs/xfs_inode_buf.c      |   90 ++++++++
 libxfs/xfs_inode_buf.h      |    3 
 libxfs/xfs_inode_util.c     |    6 -
 libxfs/xfs_log_format.h     |    2 
 libxfs/xfs_metadir.c        |  480 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_metadir.h        |   47 ++++
 libxfs/xfs_metafile.c       |   52 +++++
 libxfs/xfs_metafile.h       |   31 +++
 libxfs/xfs_ondisk.h         |    2 
 libxfs/xfs_refcount.c       |   33 +--
 libxfs/xfs_refcount.h       |    2 
 libxfs/xfs_refcount_btree.c |   17 +-
 libxfs/xfs_rmap.c           |   42 ++--
 libxfs/xfs_rmap.h           |    6 -
 libxfs/xfs_rmap_btree.c     |   28 +--
 libxfs/xfs_sb.c             |   54 ++++-
 libxfs/xfs_types.c          |    9 -
 libxfs/xfs_types.h          |   10 +
 repair/agbtree.c            |   27 +-
 repair/bmap_repair.c        |   11 -
 repair/bulkload.c           |    9 -
 repair/dino_chunks.c        |    2 
 repair/dinode.c             |   12 +
 repair/phase2.c             |   17 +-
 repair/phase5.c             |    6 -
 repair/rmap.c               |   12 +
 65 files changed, 2032 insertions(+), 705 deletions(-)
 create mode 100644 libxfs/xfs_group.c
 create mode 100644 libxfs/xfs_group.h
 create mode 100644 libxfs/xfs_metadir.c
 create mode 100644 libxfs/xfs_metadir.h
 create mode 100644 libxfs/xfs_metafile.c
 create mode 100644 libxfs/xfs_metafile.h

