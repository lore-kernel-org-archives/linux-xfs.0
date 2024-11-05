Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7EE149C53;
	Tue,  5 Nov 2024 23:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730850618; cv=none; b=GSpqT+dUHZ4uw6b6KaetmKm2+HtmKtPBQheGNHZtJ4benIDWyqQvv+izRuAEB3iPBldXKYA6nN7Fb5TjpbUkZwfLG+QMGIe53WJqod4HB3vNgTATFMoEjzcdTMgdXQ/ocCpcEfexw+/qKI8cUcMXjDG9Pa/5XrsJP2+ncpQQ/vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730850618; c=relaxed/simple;
	bh=11QYskxSrOKpO01eCvEYDEOAEFwLKvxx51MElH/CaX8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=GXmOmSGIGkgLfwVEgpUfV7rUVhSWhr0nw2ZOU4O8MAlEJ0a2ZDkpCyh4VZ2se5YcZUiBGFotUijYfBsXGep15vW9oaR508E/+OwfaTkvXi3IvsDiP+GaHV/VS0DghXfxXZ+04+izB6wzLJcS30B3bkzu7+bZXNTsou9vcPsFpOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JktmTDu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JktmTDu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAD4C4CECF;
	Tue,  5 Nov 2024 23:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730850617;
	bh=11QYskxSrOKpO01eCvEYDEOAEFwLKvxx51MElH/CaX8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JktmTDu8nTA6HU8XCHbNpcG0QZzdaJvXeZEYBayiOJwscHXvPNmmUchRYpq3ufOFD
	 g7CASd88fQZRm1Q9E/6wm7h5dyOiipRemrOwOX9q0qg0OyPn/H1WcgTAD711+ENnIC
	 jiqyfh4J4UisF3aMLbT1tWgBq9KlJ2Hp1Rcu5r+34/QRFAv35oKK9FOfwdyAC2h4LL
	 qiM81I7hXH2j9qi8ECKJR09oKTKfGleTDRs5Wy0Vqdv5vyHKi8wXPIGV2xMYuabUZE
	 N+yOqeJhKJwUzyoHindH6f7w29KYsZfsUFZS0uHNWElxrcOg6BgjZBc5bDEQAZ2XLO
	 HReqN8PlRC0QQ==
Date: Tue, 05 Nov 2024 15:50:17 -0800
Subject: [GIT PULL 01/10] xfs: convert perag to use xarrays
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, stable@vger.kernel.org
Message-ID: <173085053887.1980968.4568095337033968708.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241105234839.GL2386201@frogsfrogsfrogs>
References: <20241105234839.GL2386201@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 6.13-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 59b723cd2adbac2a34fc8e12c74ae26ae45bf230:

Linux 6.12-rc6 (2024-11-03 14:05:52 -1000)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/perag-xarray-6.13_2024-11-05

for you to fetch changes up to d66496578b2a099ea453f56782f1cd2bf63a8029:

xfs: insert the pag structures into the xarray later (2024-11-05 13:38:27 -0800)

----------------------------------------------------------------
xfs: convert perag to use xarrays [v5.5 01/10]

Convert the xfs_mount perag tree to use an xarray instead of a radix
tree.  There should be no functional changes here.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (22):
xfs: fix superfluous clearing of info->low in __xfs_getfsmap_datadev
xfs: remove the unused pagb_count field in struct xfs_perag
xfs: remove the unused pag_active_wq field in struct xfs_perag
xfs: pass a pag to xfs_difree_inode_chunk
xfs: remove the agno argument to xfs_free_ag_extent
xfs: add xfs_agbno_to_fsb and xfs_agbno_to_daddr helpers
xfs: add a xfs_agino_to_ino helper
xfs: pass a pag to xfs_extent_busy_{search,reuse}
xfs: keep a reference to the pag for busy extents
xfs: remove the mount field from struct xfs_busy_extents
xfs: remove the unused trace_xfs_iwalk_ag trace point
xfs: remove the unused xrep_bmap_walk_rmap trace point
xfs: constify pag arguments to trace points
xfs: pass a perag structure to the xfs_ag_resv_init_error trace point
xfs: pass objects to the xfs_irec_merge_{pre,post} trace points
xfs: pass the iunlink item to the xfs_iunlink_update_dinode trace point
xfs: pass objects to the xrep_ibt_walk_rmap tracepoint
xfs: pass the pag to the trace_xrep_calc_ag_resblks{,_btsize} trace points
xfs: pass the pag to the xrep_newbt_extent_class tracepoints
xfs: convert remaining trace points to pass pag structures
xfs: split xfs_initialize_perag
xfs: insert the pag structures into the xarray later

Darrick J. Wong (1):
xfs: fix simplify extent lookup in xfs_can_free_eofblocks

fs/xfs/libxfs/xfs_ag.c             | 135 ++++++++++++++------------
fs/xfs/libxfs/xfs_ag.h             |  30 +++++-
fs/xfs/libxfs/xfs_ag_resv.c        |   3 +-
fs/xfs/libxfs/xfs_alloc.c          |  32 +++----
fs/xfs/libxfs/xfs_alloc.h          |   5 +-
fs/xfs/libxfs/xfs_alloc_btree.c    |   2 +-
fs/xfs/libxfs/xfs_btree.c          |   7 +-
fs/xfs/libxfs/xfs_ialloc.c         |  67 ++++++-------
fs/xfs/libxfs/xfs_ialloc_btree.c   |   2 +-
fs/xfs/libxfs/xfs_inode_util.c     |   4 +-
fs/xfs/libxfs/xfs_refcount.c       |  11 +--
fs/xfs/libxfs/xfs_refcount_btree.c |   3 +-
fs/xfs/libxfs/xfs_rmap_btree.c     |   2 +-
fs/xfs/scrub/agheader_repair.c     |  16 +---
fs/xfs/scrub/alloc_repair.c        |  10 +-
fs/xfs/scrub/bmap.c                |   5 +-
fs/xfs/scrub/bmap_repair.c         |   4 +-
fs/xfs/scrub/common.c              |   2 +-
fs/xfs/scrub/cow_repair.c          |  18 ++--
fs/xfs/scrub/ialloc.c              |   8 +-
fs/xfs/scrub/ialloc_repair.c       |  25 ++---
fs/xfs/scrub/newbt.c               |  46 ++++-----
fs/xfs/scrub/reap.c                |   8 +-
fs/xfs/scrub/refcount_repair.c     |   5 +-
fs/xfs/scrub/repair.c              |  13 ++-
fs/xfs/scrub/rmap_repair.c         |   9 +-
fs/xfs/scrub/trace.h               | 161 +++++++++++++++----------------
fs/xfs/xfs_bmap_util.c             |   8 +-
fs/xfs/xfs_buf_item_recover.c      |   5 +-
fs/xfs/xfs_discard.c               |  20 ++--
fs/xfs/xfs_extent_busy.c           |  31 +++---
fs/xfs/xfs_extent_busy.h           |  14 ++-
fs/xfs/xfs_extfree_item.c          |   4 +-
fs/xfs/xfs_filestream.c            |   5 +-
fs/xfs/xfs_fsmap.c                 |  25 ++---
fs/xfs/xfs_health.c                |   8 +-
fs/xfs/xfs_inode.c                 |   5 +-
fs/xfs/xfs_iunlink_item.c          |  13 ++-
fs/xfs/xfs_iwalk.c                 |  17 ++--
fs/xfs/xfs_log_cil.c               |   3 +-
fs/xfs/xfs_log_recover.c           |   5 +-
fs/xfs/xfs_trace.c                 |   1 +
fs/xfs/xfs_trace.h                 | 191 ++++++++++++++++---------------------
fs/xfs/xfs_trans.c                 |   2 +-
44 files changed, 459 insertions(+), 531 deletions(-)

