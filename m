Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660172701A3
	for <linux-xfs@vger.kernel.org>; Fri,  9 May 2025 07:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746777393; cv=none; b=oTiliu2FSjMzMqLcY20F/1V6k1cRyTni6GBgt8s3sRU5n1krWYKsj0yxOl/adkKcHCiFgnVhmOi00+WgWJIfpp87wKTHxjKqUf2J5i+6exNmpfDHQ2WJ5V52YtAhElETF4zsCf5Fu/SlDf9rqUmjKYjsw92dGeY2rPQgnB7m41U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746777393; c=relaxed/simple;
	bh=Py8n/2AXV3d3OIasLw2Sfg0k0+HEUn40qrQII2doD3w=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YZvAtXEjwVsi37XkzsuyALyXvkQVOOVRj+Svx8wb6hQh2RrMIGGtr8krtXBR052Zp6lRsfXZ/+4PR+GA46hbcJ6cQ9lftPX5U7MJPnCPDSibxaEzE84dyG6BlYrIX+9DQgmMPMfaZVeuJImBFSZsV23/1u1q8+PDTpB+mBi7JTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oRKG8AR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oRKG8AR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4DDC4CEE4
	for <linux-xfs@vger.kernel.org>; Fri,  9 May 2025 07:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746777392;
	bh=Py8n/2AXV3d3OIasLw2Sfg0k0+HEUn40qrQII2doD3w=;
	h=Date:From:To:Subject:From;
	b=oRKG8AR9dXtmCNSjrQfrTe/stG+qI2wx9qPHynZUmTp+kWN6dDeuujLY3lHbDcOnp
	 ZYZ6yP3l+suFGHDyv5U2gIxWS0G2fQmvDukYmHxKz/ZJsDgjguN+wskIBHcPD/asfP
	 95Hd5KdJQERV/SOH+h2Fq//8zk6yAbvDZJGEYz8J7SvJpS5QorTmlZu6/gwXM45jgI
	 HfOxYkTdf8koYNL/omBYraqjwIddzgyS0F6Y8AflOdSVdXfZBrOP93hqdsfSuxdAGk
	 DU02lX7592DH8VsMtSgcOoJ4WWd2UDGKF2SmdfHQwCXd+G/PNyLi0VwN6MwNsBwfV9
	 +J6+GFT4vny5A==
Date: Fri, 9 May 2025 09:56:28 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to c1f3d281226a
Message-ID: <im4i2csbzyuuzjp5heuge4mraqa67oastjg4yt5r3aut4i72tu@a4gal4c3ja7x>
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

has just been updated.

This merges the atomic_writes feature into for-next and a feature deprecation
so we can get early testing before the next merge window.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

c1f3d281226a Merge branch 'deprecated_bufd-6.16' into for-next

22 new commits:

Carlos Maiolino (3):
      [4abb9052a72b] Merge tag 'atomic-writes-6.16_2025-05-07' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into atomic_writes
      [c6fad0beebe7] Merge branch 'atomic_writes-6.16' into for-next
      [c1f3d281226a] Merge branch 'deprecated_bufd-6.16' into for-next

Darrick J. Wong (6):
      [84270a1a30c9] xfs: only call xfs_setsize_buftarg once per buffer target
      [13c7c54bd0fa] xfs: separate out setting buftarg atomic writes limits
      [6d1bdc739140] xfs: add helpers to compute log item overhead
      [805f89881252] xfs: add helpers to compute transaction reservation for finishing intent items
      [85bf2dfa3f12] xfs: ignore HW which cannot atomic write a single block
      [4528b9052731] xfs: allow sysadmins to specify a maximum atomic write limit at mount time

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

Wengang Wang (1):
      [3af35b41400c] xfs: free up mp->m_free[0].count in error case

Zizhi Wo (1):
      [92926c447c60] xfs: Remove deprecated xfs_bufd sysctl parameters

Code Diffstat:

 Documentation/admin-guide/xfs.rst |  11 ++
 fs/xfs/libxfs/xfs_bmap.c          |   5 +
 fs/xfs/libxfs/xfs_bmap.h          |   6 +-
 fs/xfs/libxfs/xfs_log_rlimit.c    |   4 +
 fs/xfs/libxfs/xfs_trans_resv.c    | 343 ++++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_trans_resv.h    |  25 +++
 fs/xfs/xfs_bmap_item.c            |  10 ++
 fs/xfs/xfs_bmap_item.h            |   3 +
 fs/xfs/xfs_buf.c                  |  70 ++++++--
 fs/xfs/xfs_buf.h                  |   4 +-
 fs/xfs/xfs_buf_item.c             |  19 +++
 fs/xfs/xfs_buf_item.h             |   3 +
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
 fs/xfs/xfs_mount.c                | 161 ++++++++++++++++++
 fs/xfs/xfs_mount.h                |  17 ++
 fs/xfs/xfs_refcount_item.c        |  10 ++
 fs/xfs/xfs_refcount_item.h        |   3 +
 fs/xfs/xfs_reflink.c              | 146 ++++++++++++----
 fs/xfs/xfs_reflink.h              |   6 +
 fs/xfs/xfs_rmap_item.c            |  10 ++
 fs/xfs/xfs_rmap_item.h            |   3 +
 fs/xfs/xfs_super.c                |  82 ++++++++-
 fs/xfs/xfs_sysctl.h               |   2 -
 fs/xfs/xfs_trace.h                | 115 +++++++++++++
 34 files changed, 1335 insertions(+), 126 deletions(-)

