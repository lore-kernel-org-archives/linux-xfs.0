Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056A12DE709
	for <linux-xfs@vger.kernel.org>; Thu,  3 Jul 2025 07:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751527676; cv=none; b=oxMwRVOG8fHuBZfFGED8BeEkVh0Hs8tKPzbHIq/UADLfBzyWxVhH+SgizyqJ9PGQDJr6cX4PRJiW+A3lgRRSM5S8tIYI37pXrRTDBNYeErzEx+fj7xbc3YPXjgCPI93r/ObhSDHWUtwSvi3viR1frleI4XZaBUuaSYf9IlXbors=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751527676; c=relaxed/simple;
	bh=3iYpuibZPwJ2EES6uorSoNNmNtcKCTXQQj93CUxKqr0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HTCHcL0/b5V7lIWRsmOam9ahZU/5FCmvuQHxD67JlP03GRINnLlSK2MOPf4qd2OOv2P13HP5ZUsvHL+kwTR1gKZ/Hxgx+4AxOlgjdOx+UU6GKchfISiBDcD5P/+EFa4ivRYgVKYYDCY7+gI+23jf0SzFOpVyuUf03D94ANxva60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hHR8EFC6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hHR8EFC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C588C4CEE3;
	Thu,  3 Jul 2025 07:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751527675;
	bh=3iYpuibZPwJ2EES6uorSoNNmNtcKCTXQQj93CUxKqr0=;
	h=Date:From:To:Cc:Subject:From;
	b=hHR8EFC6XRaNXLbpAxS6TlnvLwHfY9xi93TsfFy0sjhCZ1pXpUS3ghsLH4GY+m0kL
	 DCLcNfF1MwUehKfo/eqnTeOJgVhnj4apG/PnYSFhq6hvIDnHx4eUbNN0zsoxwWAYF0
	 VS6mm3V8LnhsAq1lR1j7Xc5ktmdIbPvvdBDIwW3BiS6mHwY8FUO3ICssH0mz6S7Bsl
	 xQx2LNYaKihnLAX6isSVOs+AusWGBL2qaBoS7WFP1BWnTp426LMyXoDJT8DuyDt5fx
	 az32KuKsWfVh/rv+hwkBkr8C88XAO31tfTJS9wFyPbw6W5QaUdeC1vj5Mgx2qGEX+h
	 DHABNOOn2tTPg==
Date: Thu, 3 Jul 2025 09:27:51 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS fixes for v6.16-rc5
Message-ID: <fy5upmtfgiuzh55xaghv3w3vqqsbgszlraw6hv23a4qycirsg3@qzbwz5m2q7f6>
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

An attempt merge against your current TOT has been successful, and the
merge stat is at the bottom.

The patches have been cooking on linux-next for a while, with exception
of the last one which is there for a couple days only, it includes the
FALLOC_FL_ALLOCATE_RANGE as a supported flag to the flags mask, but in
practice it adds no functional changes.

This pull contains the addition of a new tracepoint which has been used
for debugging of one of the bugs fixed in this same series, I don't
consider it as a new feature and it seems to me ok to add it into an
-rc, please let me know if you have any objections.

Cheers,
Carlos

The following changes since commit e04c78d86a9699d136910cfc0bdcf01087e3267e:

  Linux 6.16-rc2 (2025-06-15 13:49:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.16-rc5

for you to fetch changes up to 9e9b46672b1daac814b384286c21fb8332a87392:

  xfs: add FALLOC_FL_ALLOCATE_RANGE to supported flags mask (2025-06-30 14:16:13 +0200)

----------------------------------------------------------------
xfs: Fixes for 6.16-rc5

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (4):
      xfs: check for shutdown before going to sleep in xfs_select_zone
      xfs: remove NULL pointer checks in xfs_mru_cache_insert
      xfs: use xfs_readonly_buftarg in xfs_remount_rw
      xfs: move xfs_submit_zoned_bio a bit

Darrick J. Wong (1):
      xfs: actually use the xfs_growfs_check_rtgeom tracepoint

Dave Chinner (7):
      xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
      xfs: catch stale AGF/AGF metadata
      xfs: avoid dquot buffer pin deadlock
      xfs: add tracepoints for stale pinned inode state debug
      xfs: rearrange code in xfs_buf_item.c
      xfs: factor out stale buffer item completion
      xfs: fix unmount hang with unflushable inodes stuck in the AIL

Markus Elfring (1):
      xfs: Improve error handling in xfs_mru_cache_create()

Youling Tang (1):
      xfs: add FALLOC_FL_ALLOCATE_RANGE to supported flags mask


----------------------------------------------------------------
merge stat on top of b4911fb0b060:

Merge made by the 'ort' strategy.
 fs/xfs/libxfs/xfs_alloc.c  |  41 +++++--
 fs/xfs/libxfs/xfs_ialloc.c |  31 ++++-
 fs/xfs/xfs_buf.c           |  38 ------
 fs/xfs/xfs_buf.h           |   1 -
 fs/xfs/xfs_buf_item.c      | 295 +++++++++++++++++++++++++++------------------
 fs/xfs/xfs_buf_item.h      |   3 +-
 fs/xfs/xfs_dquot.c         |   4 +-
 fs/xfs/xfs_file.c          |   7 +-
 fs/xfs/xfs_icache.c        |   8 ++
 fs/xfs/xfs_inode.c         |   2 +-
 fs/xfs/xfs_inode_item.c    |   5 +-
 fs/xfs/xfs_log_cil.c       |   4 +-
 fs/xfs/xfs_mru_cache.c     |  19 +--
 fs/xfs/xfs_qm.c            |  86 +++----------
 fs/xfs/xfs_rtalloc.c       |   2 +
 fs/xfs/xfs_super.c         |   5 +-
 fs/xfs/xfs_trace.h         |  10 +-
 fs/xfs/xfs_trans.c         |   4 +-
 fs/xfs/xfs_zone_alloc.c    |  42 +++----
 19 files changed, 320 insertions(+), 287 deletions(-)
