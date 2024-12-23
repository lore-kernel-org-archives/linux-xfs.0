Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9566738F82
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734989687; cv=none; b=GvjkbxkOrqATdEyfm/hMVujzkA8GVVJ7rOB7YM3RdJVF/gDhRhzf/eCwpQMDwdCHvcBPveLUiuRQpwqMw7BrRXerz4tZ7Z9c4V8dZKAiMatg+WKXTML+R0aXHXEWEFFMBzBpFgyfgH3GAQo1vCy8pdGsqj3LG2Z65RBdrI28uIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734989687; c=relaxed/simple;
	bh=kC9dKJek9FU/WQuZJddDGqmQ5EdVWl3KaCQ0WiVYCrM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=euFMi/ocTP3SiPSS3tn/oImzqBLwJoOsfg8ZTaiHN8BFVbjMHBAV39Hf1/4UjfEHnI3TPUqdIubvTSnu4n8tq+cU50sYYjZLNCGphPrGwmVDZFgxEswneSuP/H+AkZTCS4aRiasGdYknFUz01pK7w17kuEJMJJawnIrq3Prv3WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MsBV72V1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MsBV72V1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F44C4CED6;
	Mon, 23 Dec 2024 21:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734989687;
	bh=kC9dKJek9FU/WQuZJddDGqmQ5EdVWl3KaCQ0WiVYCrM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MsBV72V1JkwqgFdiyD8MUbLU0ek08yCQHmK97+ZFXXSUp0loNpkiRHv1auLU8wzBE
	 iEuXc9RjQtdNPF00gYQDHZl1Mp9G9eeBjUmdgYcQuEImWwMQkK40Itg5cYszhkUOZ5
	 hE0B1QpCsHD3pCZgMtjRgFiIp9p88nmjfkN86FgKAyq8xjOpMfLyF6fb8cy5wRWZVB
	 jbgNHKoq3RVkTfKE8MpXHcF2YfVvXeWNo1GMyk+pBMpxyQzOqazZCBOfXva75QWkyn
	 F1nf6Wh6AuWZxIim3j7imsZ7Z42Mjowk1DIZPeg/pThgU7vEaFInolbn3goZ1Bhomx
	 Omv1wpGSrOreQ==
Date: Mon, 23 Dec 2024 13:34:46 -0800
Subject: [PATCHSET v6.2 2/8] libxfs: metadata inode directory trees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, dchinner@redhat.com, leo.lilong@huawei.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
In-Reply-To: <20241223212904.GQ6174@frogsfrogsfrogs>
References: <20241223212904.GQ6174@frogsfrogsfrogs>
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

