Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B248221FAA
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 21:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746653533; cv=none; b=USeqxP/G2ecOWayJFfeMhLLSozOmXc10+iWbcz+4Tfs67HYarvkhkcLRlNtvukMguAkbMSJ3RkkaeNuJKYSVso7jvX9Dg5rtY0gOUoklqBrY+W0aMpNjUzJFgG+D0SzAgBhafNBh2sUGuUFsrrO/KPCjQXlbVtm2qdzikOGPG8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746653533; c=relaxed/simple;
	bh=dhDqlPggbtcbwoEn8FocIyZf55G/RT3NKKVqaHCNaD4=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=Vw4Eo2HvFxHHsfYjaGd6Vc0N9rfHHgT8WWmQ+QFcnYFEm0aBhYB0f4AmlbdMfxnxvbkuVd1ndDO6hVGrOC24R9OBKn+D8OpgBgduouKoa0vvNC0fK7jHmZlpwSZKXamLDvvOyNfvC4rpbNAQw64274Lx+v4kEk6BlFObfrV6anY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SNTf3Oqq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SNTf3Oqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFF7C4CEE2;
	Wed,  7 May 2025 21:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746653533;
	bh=dhDqlPggbtcbwoEn8FocIyZf55G/RT3NKKVqaHCNaD4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SNTf3Oqqs/c32aW8HXjZyuDphpowJrZTIQcuiiwxj+Z8GMi47x0owtUGUetI3KSNV
	 aCgJPoLiiu1MyhfJxuyCa0FiXUXesx/q44qDk7DIeLHw3wD8roEPpgS+KOGSfSBx4H
	 ZgmWzN5Rn3kNeJPTpnYU3dIE9G1qW3T9sGN5cDPJBI/PU0KNSPV36iEePcM6iMf8BF
	 T3vHhI8Xj7TrpQUE3KgZ4ZdynZdA9QIjW7PhFrIDqOuyxUEUl/hvdGcIxz+CRTMbw3
	 3Y+OMjszylhOKb55A5gixlhbfAb4O36yTBqzujgyDLFiqow4IfmoA5SGPL+3xKke7k
	 1ggbTr3mcGj0A==
Date: Wed, 07 May 2025 14:32:12 -0700
Subject: [GIT PULL] large atomic writes for xfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <174665351406.2683464.14829425904827876762.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <3c385c09-ef36-4ad0-8bb2-c9beeced9cd7@oracle.com>
References: <3c385c09-ef36-4ad0-8bb2-c9beeced9cd7@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 6.16-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit bfecc4091e07a47696ac922783216d9e9ea46c97:

xfs: allow ro mounts if rtdev or logdev are read-only (2025-04-30 20:53:52 +0200)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/atomic-writes-6.16_2025-05-07

for you to fetch changes up to 4528b9052731f14c1a9be16b98e33c9401e6d1bc:

xfs: allow sysadmins to specify a maximum atomic write limit at mount time (2025-05-07 14:25:33 -0700)

----------------------------------------------------------------
large atomic writes for xfs [v12.1]

Currently atomic write support for xfs is limited to writing a single
block as we have no way to guarantee alignment and that the write covers
a single extent.

This series introduces a method to issue atomic writes via a
software-based method.

The software-based method is used as a fallback for when attempting to
issue an atomic write over misaligned or multiple extents.

For xfs, this support is based on reflink CoW support.

The basic idea of this CoW method is to alloc a range in the CoW fork,
write the data, and atomically update the mapping.

Initial mysql performance testing has shown this method to perform ok.
However, there we are only using 16K atomic writes (and 4K block size),
so typically - and thankfully - this software fallback method won't be
used often.

For other FSes which want large atomics writes and don't support CoW, I
think that they can follow the example in [0].

Catherine is currently working on further xfstests for this feature,
which we hope to share soon.

About 17/17, maybe it can be omitted as there is no strong demand to have
it included.

Based on bfecc4091e07 (xfs/next-rc, xfs/for-next) xfs: allow ro mounts
if rtdev or logdev are read-only

[0] https://lore.kernel.org/linux-xfs/20250102140411.14617-1-john.g.garry@oracle.com/

Differences to v12:
- add more review tags

Differences to v11:
- split "xfs: ignore ..." patch
- inline sync_blockdev() in xfs_alloc_buftarg() (Christoph)
- fix xfs_calc_rtgroup_awu_max() for 0 block count (Darrick)
- Add RB tag from Christoph (thanks!)

Differences to v10:
- add "xfs: only call xfs_setsize_buftarg once ..." by Darrick
- symbol renames in "xfs: ignore HW which cannot..." by Darrick

Differences to v9:
- rework "ignore HW which cannot .." patch by Darrick
- Ensure power-of-2 max always for unit min/max when no HW support

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (6):
xfs: only call xfs_setsize_buftarg once per buffer target
xfs: separate out setting buftarg atomic writes limits
xfs: add helpers to compute log item overhead
xfs: add helpers to compute transaction reservation for finishing intent items
xfs: ignore HW which cannot atomic write a single block
xfs: allow sysadmins to specify a maximum atomic write limit at mount time

John Garry (11):
fs: add atomic write unit max opt to statx
xfs: rename xfs_inode_can_atomicwrite() -> xfs_inode_can_hw_atomic_write()
xfs: allow block allocator to take an alignment hint
xfs: refactor xfs_reflink_end_cow_extent()
xfs: refine atomic write size check in xfs_file_write_iter()
xfs: add xfs_atomic_write_cow_iomap_begin()
xfs: add large atomic writes checks in xfs_direct_write_iomap_begin()
xfs: commit CoW-based atomic writes atomically
xfs: add xfs_file_dio_write_atomic()
xfs: add xfs_calc_atomic_write_unit_max()
xfs: update atomic write limits

fs/xfs/libxfs/xfs_bmap.h          |   6 +-
fs/xfs/libxfs/xfs_trans_resv.h    |  25 +++
fs/xfs/xfs_bmap_item.h            |   3 +
fs/xfs/xfs_buf.h                  |   4 +-
fs/xfs/xfs_buf_item.h             |   3 +
fs/xfs/xfs_extfree_item.h         |   3 +
fs/xfs/xfs_inode.h                |  14 +-
fs/xfs/xfs_iomap.h                |   1 +
fs/xfs/xfs_iops.h                 |   3 +
fs/xfs/xfs_log_priv.h             |  13 ++
fs/xfs/xfs_mount.h                |  17 ++
fs/xfs/xfs_refcount_item.h        |   3 +
fs/xfs/xfs_reflink.h              |   6 +
fs/xfs/xfs_rmap_item.h            |   3 +
fs/xfs/xfs_trace.h                | 115 +++++++++++++
include/linux/fs.h                |   3 +-
include/linux/stat.h              |   1 +
include/uapi/linux/stat.h         |   8 +-
Documentation/admin-guide/xfs.rst |  11 ++
block/bdev.c                      |   3 +-
fs/ext4/inode.c                   |   2 +-
fs/stat.c                         |   6 +-
fs/xfs/libxfs/xfs_bmap.c          |   5 +
fs/xfs/libxfs/xfs_log_rlimit.c    |   4 +
fs/xfs/libxfs/xfs_trans_resv.c    | 343 ++++++++++++++++++++++++++++++++++----
fs/xfs/xfs_bmap_item.c            |  10 ++
fs/xfs/xfs_buf.c                  |  70 ++++++--
fs/xfs/xfs_buf_item.c             |  19 +++
fs/xfs/xfs_extfree_item.c         |  10 ++
fs/xfs/xfs_file.c                 |  87 +++++++++-
fs/xfs/xfs_iomap.c                | 190 ++++++++++++++++++++-
fs/xfs/xfs_iops.c                 |  76 ++++++++-
fs/xfs/xfs_log_cil.c              |   4 +-
fs/xfs/xfs_mount.c                | 161 ++++++++++++++++++
fs/xfs/xfs_refcount_item.c        |  10 ++
fs/xfs/xfs_reflink.c              | 146 ++++++++++++----
fs/xfs/xfs_rmap_item.c            |  10 ++
fs/xfs/xfs_super.c                |  80 ++++++++-
38 files changed, 1351 insertions(+), 127 deletions(-)

