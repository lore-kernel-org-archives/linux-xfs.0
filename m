Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D9227587A
	for <linux-xfs@vger.kernel.org>; Wed, 14 May 2025 12:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747224365; cv=none; b=M8/UXsh1YU1GqB1ZbLynsuUeedBq+XUDa5Dw7OCZ8C5wUsBjozzp5SR7l/yo5tO5sZOOnuIJ/T8qaAfuaKuY0Ingel82/RQVuUgc+C1iYRZIFEHVfDpSO51vKMIYmIKNDBYYM7p0yWFn0qxUkBzIbaZxuelv5fahv7PLGLcg45U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747224365; c=relaxed/simple;
	bh=vMNUIh/rq4UXTYxBnRKQU/iEGiXIAa62L9u4oEtzCm0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=sGoG5kv2NN9OdMOgPEty7jfrrYbaZ/nRhuuPKAUPzWEQyNPPjTgYeMH+saI0PXuW98fcIgLdAxVgNpdJwv4bv1Z/qzTQqtAicNZhO4NM7aVKzP/P30mohf7/YH9B7s58EdvKa6CfO+XS05Ob0U6OpbyGgiew4OMCQ7ER2akcxQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YiLhO/mO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YiLhO/mO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CE9C4CEE9
	for <linux-xfs@vger.kernel.org>; Wed, 14 May 2025 12:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747224364;
	bh=vMNUIh/rq4UXTYxBnRKQU/iEGiXIAa62L9u4oEtzCm0=;
	h=Date:From:To:Subject:From;
	b=YiLhO/mOt9fC4/gdps7h465gyLjxzSoJIZjDbnfuxtuz0vDGYX5E4AbHX6golZqGg
	 XH1DgRcA+Lf4T592+WEygfzOxYGZFqWnD4U3N+rwPEglZucpW+g7W/3YXpdBe9MO4h
	 0BvcfVH31xQP5JUoY62RgbN90axK8WmxjFOJKkX58bIhhb9GHD7n+j9ytkT6qjuCID
	 AcjyqKtU7oMmJQ7NwcmtD568L3CHwsmlL2kGOZxUm2P/TXjuiBh20Ep9Xl0BAs87gR
	 1UwuK2tKxiPIT2bOCyqHfcF8Un7pM8GEqtHpqx++sVMOc8z0SOLaJ4Hd/YjQdNB3kg
	 NpGmsLUG9IlLQ==
Date: Wed, 14 May 2025 14:06:00 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next *REBASED* to 3803e95ac5c8
Message-ID: <3qizgl66ybanz5kbgm6cut5v42mqrps3zzqvgn5e2vxhbv2mdm@tymuktmayxy7>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been *REBASED*.

As the merge-window approaches, I needed to tidy up a bit the base branches for
both -rc and -merge, and I wanted to rebase for-next so that hashes match when
sending them to Linus.
With the exception of about 4 new patches, those are the same patches as before
with some extra merges removed.

Below is the list of everything queued up for rc-7 and the merge window. I don't
think there is anything waiting to be pulled from the list, but let me know if
anything is missing. If they have not been in this update, please let me know.

The new head of the for-next branch is commit:

3803e95ac5c8 Merge branch 'xfs-6.15-fixes' into for-next



109 new commits:

Carlos Maiolino (5):
      [4abb9052a72b] Merge tag 'atomic-writes-6.16_2025-05-07' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into atomic_writes
      [6e7d71b3a0f9] Merge branch 'atomic_writes-6.16' into xfs-6.16-merge
      [f65adb4b6c11] xfs: Fix a comment on xfs_ail_delete
      [cc75545fbd13] xfs: Fix comment on xfs_trans_ail_update_bulk()
      [3803e95ac5c8] Merge branch 'xfs-6.15-fixes' into for-next

Christoph Hellwig (2):
      [1c7161ef0164] xfs: remove the EXPERIMENTAL warning for pNFS
      [6074f25ed988] xfs: fix zoned GC data corruption due to wrong bv_offset

Darrick J. Wong (9):
      [5088aad3d32c] xfs: stop using set_blocksize
      [84270a1a30c9] xfs: only call xfs_setsize_buftarg once per buffer target
      [13c7c54bd0fa] xfs: separate out setting buftarg atomic writes limits
      [6d1bdc739140] xfs: add helpers to compute log item overhead
      [805f89881252] xfs: add helpers to compute transaction reservation for finishing intent items
      [85bf2dfa3f12] xfs: ignore HW which cannot atomic write a single block
      [4528b9052731] xfs: allow sysadmins to specify a maximum atomic write limit at mount time
      [ea31bdece29a] xfs: stop using set_blocksize
      [ca43b74ac304] xfs: remove some EXPERIMENTAL warnings

Dave Chinner (2):
      [23be716b1c4f] xfs: don't assume perags are initialised when trimming AGs
      [0f511a198974] xfs: don't assume perags are initialised when trimming AGs

Hans Holmberg (2):
      [bfecc4091e07] xfs: allow ro mounts if rtdev or logdev are read-only
      [ce9473e73824] xfs: allow ro mounts if rtdev or logdev are read-only

John Garry (11):
      [5d894321c49e] fs: add atomic write unit max opt to statx
      [5af9f5508477] xfs: rename xfs_inode_can_atomicwrite() -> xfs_inode_can_hw_atomic_write()
      [6baf4cc47a74] xfs: allow block allocator to take an alignment hint
      [514df14fae97] xfs: refactor xfs_reflink_end_cow_extent()
      [0ea88ed47bb1] xfs: refine atomic write size check in xfs_file_write_iter()
      [bd1d2c21d5d2] xfs: add xfs_atomic_write_cow_iomap_begin()
      [11ab31909d7c] xfs: add large atomic writes checks in xfs_direct_write_iomap_begin()
      [b1e09178b73a] xfs: commit CoW-based atomic writes atomically
      [9baeac3ab1f8] xfs: add xfs_file_dio_write_atomic()
      [0c438dcc3150] xfs: add xfs_calc_atomic_write_unit_max()
      [9dffc58f2384] xfs: update atomic write limits

Nirjhar Roy (IBM) (1):
      [dcc6c6d39527] xfs: Fail remount with noattr2 on a v5 with v4 enabled

Wengang Wang (1):
      [3748581214af] xfs: free up mp->m_free[0].count in error case

Zizhi Wo (1):
      [c0a5c4084709] xfs: Remove deprecated xfs_bufd sysctl parameters

Code Diffstat:

 Documentation/admin-guide/xfs.rst |  11 ++
 fs/xfs/libxfs/xfs_bmap.c          |   5 +
 fs/xfs/libxfs/xfs_bmap.h          |   6 +-
 fs/xfs/libxfs/xfs_log_rlimit.c    |   4 +
 fs/xfs/libxfs/xfs_trans_resv.c    | 343 ++++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_trans_resv.h    |  25 +++
 fs/xfs/scrub/scrub.c              |   2 -
 fs/xfs/xfs_bmap_item.c            |  10 ++
 fs/xfs/xfs_bmap_item.h            |   3 +
 fs/xfs/xfs_buf.c                  |  79 +++++++--
 fs/xfs/xfs_buf.h                  |   4 +-
 fs/xfs/xfs_buf_item.c             |  19 +++
 fs/xfs/xfs_buf_item.h             |   3 +
 fs/xfs/xfs_discard.c              |  17 +-
 fs/xfs/xfs_extfree_item.c         |  10 ++
 fs/xfs/xfs_extfree_item.h         |   3 +
 fs/xfs/xfs_file.c                 |  87 +++++++++-
 fs/xfs/xfs_globals.c              |   2 -
 fs/xfs/xfs_inode.h                |  14 +-
 fs/xfs/xfs_iomap.c                | 190 ++++++++++++++++++++-
 fs/xfs/xfs_iomap.h                |   1 +
 fs/xfs/xfs_iops.c                 |  76 ++++++++-
 fs/xfs/xfs_iops.h                 |   3 +
 fs/xfs/xfs_log_cil.c              |   4 +-
 fs/xfs/xfs_log_priv.h             |  13 ++
 fs/xfs/xfs_message.c              |  16 --
 fs/xfs/xfs_message.h              |   4 -
 fs/xfs/xfs_mount.c                | 161 ++++++++++++++++++
 fs/xfs/xfs_mount.h                |  26 ++-
 fs/xfs/xfs_pnfs.c                 |   2 -
 fs/xfs/xfs_refcount_item.c        |  10 ++
 fs/xfs/xfs_refcount_item.h        |   3 +
 fs/xfs/xfs_reflink.c              | 146 ++++++++++++----
 fs/xfs/xfs_reflink.h              |   6 +
 fs/xfs/xfs_rmap_item.c            |  10 ++
 fs/xfs/xfs_rmap_item.h            |   3 +
 fs/xfs/xfs_super.c                | 136 ++++++++++++---
 fs/xfs/xfs_sysctl.h               |   2 -
 fs/xfs/xfs_trace.h                | 115 +++++++++++++
 fs/xfs/xfs_trans_ail.c            |  34 ++--
 fs/xfs/xfs_zone_gc.c              |   5 +-
 41 files changed, 1426 insertions(+), 187 deletions(-)
