Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2CE198E60
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995928; cv=none; b=bTA3PHh0VkP6cL4tsdiXlO9SEfzPo7ZGljKo8gWod/0HPTStrRxrXw24gZtR7zbzE2iimG6SY5gXt3dfWRS/QiWoJrigUWy11VkDT4lUOyT/PKoGyZZCLW7FHtfDuz4I2F8DZV22p4HCuT0Hwx6dG1+zfxuRV6dicKTaBVGFkT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995928; c=relaxed/simple;
	bh=AJMLK0sYMard/kzxos44iQgxJhVTACmQkaSHvphdZZs=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=DUXhDV7+V+Sr+f09m/0+Ig78ssNCuoMJwIx0LdfJqofrYXUOaG2FuOspdjGXkBsIfOXcMOeF4jGVuNfrQ3UeWRVUI5aP00q/PAx0K74/H4OCYAREPqqi83CXIYpAPKQKGSisH0+Y3bTpmUNchLFoC9Hb9w7StTscITRKErUZmgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SMtQBcJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SMtQBcJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C6DC4CED3;
	Mon, 23 Dec 2024 23:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995927;
	bh=AJMLK0sYMard/kzxos44iQgxJhVTACmQkaSHvphdZZs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SMtQBcJArEeF510slx1vk55oQb68/EW8eg8dx+9dWhm8Yyf7iJuXUSc3Xbu+07R5j
	 23KK/obGWASXLQL7OjWJbsJf6Sv7AmLNm53oHZJprfr3OXkFNfViFnE7BWdPXPys5I
	 aZsTEy3mEJLjWGsl7zNtJOvuPCiekv6wqKoSERYlfhagDQNpHaCSbcUsDMH0wrwWrp
	 7qNapRD0mDatILYPLfOVLhq+1jND8EKi0fN0zo8YlF2MmstecIamrrkZIpHsy9NWuo
	 4lEA5x6N/d/MFMC3S5GBEeLToIpDf7JI5cF3iQRrGs77r5b5cs7Bgfo6TvngGCrkzT
	 Vh5rtNurL6ygA==
Date: Mon, 23 Dec 2024 15:18:47 -0800
Subject: [GIT PULL 5/5] xfs: reflink on the realtime device
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499429082.2382820.13008491658242175877.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241223224906.GS6174@frogsfrogsfrogs>
References: <20241223224906.GS6174@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit c2358439af374cad47f771797875d0beb8256738:

xfs: enable realtime rmap btree (2024-12-23 13:06:09 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/realtime-reflink_2024-12-23

for you to fetch changes up to 155debbe7e627baf6439e75f15856d40ec115c5d:

xfs: enable realtime reflink (2024-12-23 13:06:17 -0800)

----------------------------------------------------------------
xfs: reflink on the realtime device [v6.2 05/14]

This patchset enables use of the file data block sharing feature (i.e.
reflink) on the realtime device.  It follows the same basic sequence as
the realtime rmap series -- first a few cleanups; then  introduction of
the new btree format and inode fork format.  Next comes enabling CoW and
remapping for the rt device; new scrub, repair, and health reporting
code; and at the end we implement some code to lengthen write requests
so that rt extents are always CoWed fully.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (1):
xfs: refactor xfs_reflink_find_shared

Darrick J. Wong (42):
xfs: prepare refcount btree cursor tracepoints for realtime
xfs: namespace the maximum length/refcount symbols
xfs: introduce realtime refcount btree ondisk definitions
xfs: realtime refcount btree transaction reservations
xfs: add realtime refcount btree operations
xfs: prepare refcount functions to deal with rtrefcountbt
xfs: add a realtime flag to the refcount update log redo items
xfs: support recovering refcount intent items targetting realtime extents
xfs: add realtime refcount btree block detection to log recovery
xfs: add realtime refcount btree inode to metadata directory
xfs: add metadata reservations for realtime refcount btree
xfs: wire up a new metafile type for the realtime refcount
xfs: wire up realtime refcount btree cursors
xfs: create routine to allocate and initialize a realtime refcount btree inode
xfs: update rmap to allow cow staging extents in the rt rmap
xfs: compute rtrmap btree max levels when reflink enabled
xfs: refactor reflink quota updates
xfs: enable CoW for realtime data
xfs: enable sharing of realtime file blocks
xfs: allow inodes to have the realtime and reflink flags
xfs: recover CoW leftovers in the realtime volume
xfs: fix xfs_get_extsz_hint behavior with realtime alwayscow files
xfs: apply rt extent alignment constraints to CoW extsize hint
xfs: enable extent size hints for CoW operations
xfs: check that the rtrefcount maxlevels doesn't increase when growing fs
xfs: report realtime refcount btree corruption errors to the health system
xfs: scrub the realtime refcount btree
xfs: cross-reference checks with the rt refcount btree
xfs: allow overlapping rtrmapbt records for shared data extents
xfs: check reference counts of gaps between rt refcount records
xfs: allow dquot rt block count to exceed rt blocks on reflink fs
xfs: detect and repair misaligned rtinherit directory cowextsize hints
xfs: scrub the metadir path of rt refcount btree files
xfs: don't flag quota rt block usage on rtreflink filesystems
xfs: check new rtbitmap records against rt refcount btree
xfs: walk the rt reference count tree when rebuilding rmap
xfs: capture realtime CoW staging extents when rebuilding rt rmapbt
xfs: online repair of the realtime refcount btree
xfs: repair inodes that have a refcount btree in the data fork
xfs: check for shared rt extents when rebuilding rt file's data fork
xfs: fix CoW forks for realtime files
xfs: enable realtime reflink

fs/xfs/Makefile                      |   3 +
fs/xfs/libxfs/xfs_bmap.c             |  23 +-
fs/xfs/libxfs/xfs_btree.c            |   5 +
fs/xfs/libxfs/xfs_btree.h            |   2 +-
fs/xfs/libxfs/xfs_defer.h            |   1 +
fs/xfs/libxfs/xfs_format.h           |  25 +-
fs/xfs/libxfs/xfs_fs.h               |   7 +-
fs/xfs/libxfs/xfs_health.h           |   4 +-
fs/xfs/libxfs/xfs_inode_buf.c        |  33 +-
fs/xfs/libxfs/xfs_inode_fork.c       |   6 +
fs/xfs/libxfs/xfs_log_format.h       |   6 +-
fs/xfs/libxfs/xfs_log_recover.h      |   2 +
fs/xfs/libxfs/xfs_ondisk.h           |   2 +
fs/xfs/libxfs/xfs_refcount.c         | 276 +++++++++---
fs/xfs/libxfs/xfs_refcount.h         |  23 +-
fs/xfs/libxfs/xfs_rmap.c             |   7 +
fs/xfs/libxfs/xfs_rtgroup.c          |  19 +
fs/xfs/libxfs/xfs_rtgroup.h          |  11 +-
fs/xfs/libxfs/xfs_rtrefcount_btree.c | 757 +++++++++++++++++++++++++++++++++
fs/xfs/libxfs/xfs_rtrefcount_btree.h | 189 +++++++++
fs/xfs/libxfs/xfs_rtrmap_btree.c     |  28 +-
fs/xfs/libxfs/xfs_sb.c               |   8 +
fs/xfs/libxfs/xfs_shared.h           |   7 +
fs/xfs/libxfs/xfs_trans_resv.c       |  25 +-
fs/xfs/scrub/agheader_repair.c       |   2 +-
fs/xfs/scrub/bmap.c                  |  30 +-
fs/xfs/scrub/bmap_repair.c           |  21 +-
fs/xfs/scrub/common.c                |  10 +
fs/xfs/scrub/common.h                |   5 +-
fs/xfs/scrub/cow_repair.c            | 180 +++++++-
fs/xfs/scrub/health.c                |   1 +
fs/xfs/scrub/inode.c                 |  31 +-
fs/xfs/scrub/inode_repair.c          |  57 ++-
fs/xfs/scrub/metapath.c              |   3 +
fs/xfs/scrub/quota.c                 |   8 +-
fs/xfs/scrub/quota_repair.c          |   2 +-
fs/xfs/scrub/reap.c                  | 247 ++++++++++-
fs/xfs/scrub/reap.h                  |   7 +
fs/xfs/scrub/refcount.c              |   2 +-
fs/xfs/scrub/refcount_repair.c       |   6 +-
fs/xfs/scrub/repair.c                |   6 +
fs/xfs/scrub/repair.h                |   7 +
fs/xfs/scrub/rgb_bitmap.h            |  37 ++
fs/xfs/scrub/rmap_repair.c           |   7 +
fs/xfs/scrub/rtb_bitmap.h            |  37 ++
fs/xfs/scrub/rtbitmap.c              |   2 +
fs/xfs/scrub/rtbitmap_repair.c       |  24 +-
fs/xfs/scrub/rtrefcount.c            | 661 +++++++++++++++++++++++++++++
fs/xfs/scrub/rtrefcount_repair.c     | 783 +++++++++++++++++++++++++++++++++++
fs/xfs/scrub/rtrmap.c                |  54 ++-
fs/xfs/scrub/rtrmap_repair.c         | 103 +++++
fs/xfs/scrub/scrub.c                 |   7 +
fs/xfs/scrub/scrub.h                 |  12 +
fs/xfs/scrub/stats.c                 |   1 +
fs/xfs/scrub/trace.h                 |  54 ++-
fs/xfs/xfs_buf_item_recover.c        |   4 +
fs/xfs/xfs_fsmap.c                   |  25 +-
fs/xfs/xfs_fsops.c                   |   2 +
fs/xfs/xfs_health.c                  |   1 +
fs/xfs/xfs_inode_item.c              |  14 +
fs/xfs/xfs_inode_item_recover.c      |   4 +
fs/xfs/xfs_ioctl.c                   |  21 +-
fs/xfs/xfs_log_recover.c             |   2 +
fs/xfs/xfs_mount.c                   |   5 +-
fs/xfs/xfs_mount.h                   |   9 +
fs/xfs/xfs_refcount_item.c           | 240 ++++++++++-
fs/xfs/xfs_reflink.c                 | 325 +++++++++++----
fs/xfs/xfs_reflink.h                 |   4 +-
fs/xfs/xfs_rtalloc.c                 |  24 +-
fs/xfs/xfs_rtalloc.h                 |   5 +
fs/xfs/xfs_stats.c                   |   3 +-
fs/xfs/xfs_stats.h                   |   1 +
fs/xfs/xfs_super.c                   |   6 +-
fs/xfs/xfs_trace.h                   | 111 +++--
74 files changed, 4330 insertions(+), 352 deletions(-)
create mode 100644 fs/xfs/libxfs/xfs_rtrefcount_btree.c
create mode 100644 fs/xfs/libxfs/xfs_rtrefcount_btree.h
create mode 100644 fs/xfs/scrub/rgb_bitmap.h
create mode 100644 fs/xfs/scrub/rtb_bitmap.h
create mode 100644 fs/xfs/scrub/rtrefcount.c
create mode 100644 fs/xfs/scrub/rtrefcount_repair.c

