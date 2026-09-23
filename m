Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0021F47206C
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 08:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153498; cv=none; b=UNYWfh16wm0aFMGiqp05KB6Wh+KhvvgFZ7vpNsRitydTf+fRQKbr2cgNMin89XEowJVZSc8SBDsEpdyUXu2RJ2V6jsbOr0iFwoOg7GC5WRuSg7RRYh+vMP7TzQ8WyURmLy9WkSlR/sUoERxY78ZKuwLCsOvTy9j0Rl9WPf1+jn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153498; c=relaxed/simple;
	bh=k9I0+3y4JLTjHUqrOkoYC5Gtyww8dR4kJyjdv8Dtd5E=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=gTg51Wb1a5xdsU4SiLVMfIqFaFswu4WCYqELr2uPlDqzguhTuEJGj29DPyCZYBMpXqbictl5rLuUOqFh6MUku5wGKz5ePuTQW1bHOAuvEaePFBD3mB2kjXjOnLy8DGA5PdcfqR3HxlzHwuCARLj9Rk1FZcDjmpBz/RXhAYDbIF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HZcehuDI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HZcehuDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AEB61F000FF
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 08:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790153496;
	bh=tnZn6fUDD/WOsqZn9r4IwCGZLqKQCBc4VtlEg5W3nyk=;
	h=Date:From:To:Subject;
	b=HZcehuDIkSDz8fRUXi8Q+7wEQ/8pEjA1cCD/CVo9HJxQPgSfY1h4bnSYkAUDk7d9k
	 z008MSjSdtNejlA47iTEU56aPGfb0eus7JWTv02S6py9kTK2Q0xvTL988S1bmwEsp3
	 9pSoRfH+8xKEVZomInc5xRiOaUch/7rNaYoycyOmy4OlH0PA8HcDM6gLDcg9BDJTgD
	 EaU9RcOcROhMVbYOO8WlpWnvyOtgAaAa2BCTnawRppDhXMs0LyCpo8k9rB8evlF6DS
	 NDlMW140NPwAe9Jv+rVQjKo6s/MUHPXrnjxs8AYX5ijFpjPjmsQnH6oFzPuTXfEhtB
	 7C8DHeXvPf1bA==
Date: Wed, 23 Sep 2026 10:51:33 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to b4787e7b9730
Message-ID: <arOS8cHovRg8nSWF@nidhogg.toxiclabs.cc>
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

	gitolite.kernel.org:/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

b4787e7b9730 Merge remote-tracking branch 'xfs-linux/xfs-7.3-fixes' into for-next

18 new commits:

Carlos Maiolino (1):
      [b4787e7b9730] Merge remote-tracking branch 'xfs-linux/xfs-7.3-fixes' into for-next

Darrick J. Wong (13):
      [6620025ff272] xfs: fix missing xfs_qm_adjust_dqlimits call in quotacheck repair
      [2d72322bb2b7] xfs: online quotacheck must dirty dquot if enforcement adjustments needed
      [9d13120c3446] xfs: fix buffer overruns in xfs_ioc_attr_list
      [37340d63ac1c] xfs: clean up after failed metafile relinking
      [25ba4acda6be] xfs: pass xfs_trans_resv object to reservation calculation helpers
      [a4d5e116f039] xfs: fix xfs_rename_space_res for non-pptr filesystems
      [469b4879f752] xfs: fix ondisk symlink target validation in xrep_dinode_check_dfork
      [713053a89e13] xfs: add missing healthmon trace strings
      [fdadc158cfbd] xfarray: don't crash when sorting if array element crosses a folio
      [c49f46a0cbcc] xfarray: don't allow users to unset in the middle of an array
      [c7a7aa2c2bcf] xfs: don't allow sorting sparse arrays
      [afbe48d6f8e8] xfs: simply the free space btree repair code
      [e22e1ac1f07e] xfarray: warn against sorting arrays with identical elements

Eric Sandeen (2):
      [21ff42031ece] xfs: share the AG rmap btree with the rt rmap btree
      [e103e2c35726] xfs: share the AG refcount btree with the rt refcount btree

Kefeng Wang (1):
      [26f42375404e] xfs: fix NOFS state corruption in btree split worker

Yun Zhou (1):
      [4a5c7d1c38b2] xfs: move xfs_sync_sb_buf() out of libxfs into xfs_ioctl.c

Code Diffstat:

 .../filesystems/xfs/xfs-online-fsck-design.rst     |  13 +-
 fs/xfs/libxfs/xfs_btree.c                          |  10 +-
 fs/xfs/libxfs/xfs_dquot_buf.c                      |  13 +-
 fs/xfs/libxfs/xfs_inode_fork.c                     |   4 +-
 fs/xfs/libxfs/xfs_metadir.c                        |  30 ++-
 fs/xfs/libxfs/xfs_metadir.h                        |   5 +-
 fs/xfs/libxfs/xfs_refcount_btree.c                 |  16 +-
 fs/xfs/libxfs/xfs_refcount_btree.h                 |  26 +++
 fs/xfs/libxfs/xfs_rmap_btree.c                     |  16 +-
 fs/xfs/libxfs/xfs_rmap_btree.h                     |  26 +++
 fs/xfs/libxfs/xfs_rtrefcount_btree.c               | 113 +---------
 fs/xfs/libxfs/xfs_rtrmap_btree.c                   | 230 ++-------------------
 fs/xfs/libxfs/xfs_sb.c                             |  40 ----
 fs/xfs/libxfs/xfs_sb.h                             |   1 -
 fs/xfs/libxfs/xfs_symlink_remote.c                 |   8 +-
 fs/xfs/libxfs/xfs_symlink_remote.h                 |   2 +-
 fs/xfs/libxfs/xfs_trans_resv.c                     |  38 ++--
 fs/xfs/libxfs/xfs_trans_space.c                    |   6 +-
 fs/xfs/scrub/alloc_repair.c                        |  15 +-
 fs/xfs/scrub/inode_repair.c                        |  26 ++-
 fs/xfs/scrub/quota_repair.c                        |   5 +-
 fs/xfs/scrub/quotacheck_repair.c                   |  54 ++++-
 fs/xfs/scrub/xfarray.c                             | 201 ++++++++----------
 fs/xfs/scrub/xfarray.h                             |   9 +-
 fs/xfs/xfs_dquot.c                                 |  20 +-
 fs/xfs/xfs_dquot.h                                 |   2 +-
 fs/xfs/xfs_handle.c                                |   2 +-
 fs/xfs/xfs_ioctl.c                                 |  40 ++++
 fs/xfs/xfs_qm.c                                    |   6 +-
 fs/xfs/xfs_trace.h                                 |  28 ++-
 fs/xfs/xfs_trans_dquot.c                           |   6 +-
 31 files changed, 419 insertions(+), 592 deletions(-)
