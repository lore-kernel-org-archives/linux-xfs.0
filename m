Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD90D2EA498
	for <linux-xfs@vger.kernel.org>; Mon,  1 Dec 2025 11:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764589800; cv=none; b=S4Re8qp/yBqW0cRr8tuq6FNvyQv3l6RrtDxHhrHxbrIj077X7G76tiyWqikQEDGbVlXIsYXckUzJnq1nci6Na8hMnOJZUI6xr3wxP6jLSqVjDxPKelNwA5LF6CgYe6RZhBpl5HyDIp/h5ekjeDIC13eCdP3Jx7N3LMstEnmByFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764589800; c=relaxed/simple;
	bh=2yElMjbej8QtTmYAIgw+gOpTHLGeBrUOygcKAPGU0VY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fnF3DoPowEnP590iiwW9+CmqXbOyoW6OtLpDXshn6uZ93c+OicGhpzazX91GGyvllmP358wt0XnIm56BJFUQOcN1LJ0rkrP+i33xsAtjLPVpI7JGjxKAx+Po+voqVdUnBeocxrsPctm1Q2+Ob3t/3kOlJDGwVrkECWYHRPUr91A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oSe7SSmV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oSe7SSmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA67C4CEF1;
	Mon,  1 Dec 2025 11:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764589800;
	bh=2yElMjbej8QtTmYAIgw+gOpTHLGeBrUOygcKAPGU0VY=;
	h=Date:From:To:Cc:Subject:From;
	b=oSe7SSmVvJH3VGXzr+ukEB6cSuXWFG6UYiP0bzKh8rTkGqVob4z7kD9DEXHeR4bLW
	 YqRyMitvNHS7ntrhAlCymGU8p24eDPniHqx68j2jz2fBpVkRGYaG/vXczIJbya5gBr
	 9pw9eqOtGCJRXmZzJcZ9at+BsDV/MuC7qMCJJR9dEjZL85ZnE41m2pwfhMkFqAJLnM
	 RWnJSHBvf+c0ehpu/vM8sNL+AIm5YPFG/PEI418gBa1MwKAME7A/YiLkUZ+sK/rB3j
	 hn0GmrVOlGyItWirqH+WtHbwGMtftYScxBsFmLvFo9FdEeNmUT/8GYo9pqMapvZITH
	 rh42jds07J6/w==
Date: Mon, 1 Dec 2025 12:49:56 +0100
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: New code for v6.19
Message-ID: <2lje5mt266gixlqrnqfnkrmcxwjdnu72emnz2gywn2hs5r4z7r@zuyoxysv2uxq>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Could you please pull patches included in the tag below?

For 6.19, there are no major changes in xfs. This pull-request contains
mostly some code cleanups, a few bug fixes and documentatino update.
Highlights are:
	- Quota locking cleanup
	- Getting rid of old xlog_in_core_2_t type


An attempt merge against your current TOT has been successful.

Thanks,
Carlos

"The following changes since commit d8a823c6f04ef03e3bd7249d2e796da903e7238d:

  xfs: free xfs_busy_extents structure when no RT extents are queued (2025-11-06 08:59:19 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-6.19

for you to fetch changes up to 69ceb8a2d6665625d816fcf8ccd01965cddb233e:

  docs: remove obsolete links in the xfs online repair documentation (2025-11-27 16:09:14 +0100)

----------------------------------------------------------------
xfs: new code for v6.19

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (31):
      xfs: add a xfs_groups_to_rfsbs helper
      xfs: don't leak a locked dquot when xfs_dquot_attach_buf fails
      xfs: make qi_dquots a 64-bit value
      xfs: don't treat all radix_tree_insert errors as -EEXIST
      xfs: remove xfs_dqunlock and friends
      xfs: use a lockref for the xfs_dquot reference count
      xfs: remove xfs_qm_dqput and optimize dropping dquot references
      xfs: consolidate q_qlock locking in xfs_qm_dqget and xfs_qm_dqget_inode
      xfs: xfs_qm_dqattach_one is never called with a non-NULL *IO_idqpp
      xfs: fold xfs_qm_dqattach_one into xfs_qm_dqget_inode
      xfs: return the dquot unlocked from xfs_qm_dqget
      xfs: remove q_qlock locking in xfs_qm_scall_setqlim
      xfs: push q_qlock acquisition from xchk_dquot_iter to the callers.
      xfs: move q_qlock locking into xchk_quota_item
      xfs: move q_qlock locking into xqcheck_compare_dquot
      xfs: move quota locking into xqcheck_commit_dquot
      xfs: move quota locking into xrep_quota_item
      xfs: move xfs_dquot_tree calls into xfs_qm_dqget_cache_{lookup,insert}
      xfs: reduce ilock roundtrips in xfs_qm_vop_dqalloc
      xfs: add a XLOG_CYCLE_DATA_SIZE constant
      xfs: add a on-disk log header cycle array accessor
      xfs: don't use xlog_in_core_2_t in struct xlog_in_core
      xfs: cleanup xlog_alloc_log a bit
      xfs: remove a very outdated comment from xlog_alloc_log
      xfs: remove xlog_in_core_2_t
      xfs: remove the xlog_rec_header_t typedef
      xfs: remove l_iclog_heads
      xfs: remove the xlog_in_core_t typedef
      xfs: remove the unused bv field in struct xfs_gc_bio
      xfs: use zi more in xfs_zone_gc_mount
      xfs: move some code out of xfs_iget_recycle

Darrick J. Wong (1):
      docs: remove obsolete links in the xfs online repair documentation

Hans Holmberg (1):
      xfs: remove xarray mark for reclaimable zones

 .../filesystems/xfs/xfs-online-fsck-design.rst     | 236 +--------------------
 fs/xfs/libxfs/xfs_group.h                          |   9 +
 fs/xfs/libxfs/xfs_log_format.h                     |  38 ++--
 fs/xfs/libxfs/xfs_ondisk.h                         |   6 +-
 fs/xfs/libxfs/xfs_quota_defs.h                     |   4 +-
 fs/xfs/libxfs/xfs_rtgroup.h                        |  14 +-
 fs/xfs/scrub/quota.c                               |   8 +-
 fs/xfs/scrub/quota_repair.c                        |  18 +-
 fs/xfs/scrub/quotacheck.c                          |  11 +-
 fs/xfs/scrub/quotacheck_repair.c                   |  21 +-
 fs/xfs/xfs_dquot.c                                 | 143 ++++++-------
 fs/xfs/xfs_dquot.h                                 |  22 +-
 fs/xfs/xfs_dquot_item.c                            |   6 +-
 fs/xfs/xfs_icache.c                                |  31 ++-
 fs/xfs/xfs_log.c                                   | 206 +++++++-----------
 fs/xfs/xfs_log_cil.c                               |   6 +-
 fs/xfs/xfs_log_priv.h                              |  33 ++-
 fs/xfs/xfs_log_recover.c                           |  45 ++--
 fs/xfs/xfs_qm.c                                    | 154 ++++----------
 fs/xfs/xfs_qm.h                                    |   2 +-
 fs/xfs/xfs_qm_bhv.c                                |   4 +-
 fs/xfs/xfs_qm_syscalls.c                           |  10 +-
 fs/xfs/xfs_quotaops.c                              |   2 +-
 fs/xfs/xfs_trace.h                                 |   8 +-
 fs/xfs/xfs_trans_dquot.c                           |  18 +-
 fs/xfs/xfs_zone_alloc.c                            |  26 ++-
 fs/xfs/xfs_zone_gc.c                               |  14 +-
 fs/xfs/xfs_zone_priv.h                             |   1 +
 fs/xfs/xfs_zone_space_resv.c                       |  10 +-
 29 files changed, 363 insertions(+), 743 deletions(-)"
