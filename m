Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381061AF0DC;
	Thu, 14 Nov 2024 06:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731565571; cv=none; b=RB/vqWnodLcdV9Vs0mog1HHc5cmgAQKgUBLyLuaf6zAH77t40Sc8UI76hEjLRzKd9kNM+O0NbTs9FJIrahQn3hzupo7Z09HZB1WOXOZnuQyu2xX6cRyQDaV3xXCeIWzpR+PYFUgmjBtlfCAAoTI2YCT8GMccUOlLtdDhymkA2+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731565571; c=relaxed/simple;
	bh=LEL3vfhFjFruTbZaqw50YGgDPZtz6jOEqNAoRSgqgNY=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=rKETORc28ApivhfYXoQaqOXkCeGh2B2CjL4sAgebXKsTwxdfBEWvzdDJGIHSzOaAkzupc/KZgr1gP5YWt/p8FV6hJ9kjB1K7yYWtPIyenr4gHa7cn4c/yW2gzJW9WON/0vkTbXoeNOxw6c6lHQrVXrKTAGpuXd7AWLf7iYctv0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jp0tRDRg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jp0tRDRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A82C4CECF;
	Thu, 14 Nov 2024 06:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731565570;
	bh=LEL3vfhFjFruTbZaqw50YGgDPZtz6jOEqNAoRSgqgNY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Jp0tRDRgMAzqkKe7FBjeS+/MmD7hR/rV9QNAlDaB/yZvFfS+oTHz8Vov/q8Xgzd6w
	 VDQMb95A+1X+//N98ucu0NFHYI7jsZOeTKaKgZ8Xlf+PE+h8SZA1WicbNBII3TBsoM
	 KLs8BEM0tSD/Cbt/vnPXJcvtHXHkZYuM6OLiwfyFvVO1YkmymccO+4AjzBsg8x+lhZ
	 EtRefylfD0qgqQrKcrN4K/5XIzhzBZ3RhtEpKrKn6TKOigiBlJHMpOh9EcO/mX6bNI
	 XlmczGVhjBxyXvE5sqSpLGadRBYkEclazLoEMdpaWn8ohsgfBUhSNBJwKcXIsH6DqJ
	 iX07/EIHDg7Ow==
Date: Wed, 13 Nov 2024 22:26:10 -0800
Subject: [GIT PULL 01/10] xfs: convert perag to use xarrays
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, stable@vger.kernel.org
Message-ID: <173156551067.1445256.3538147587347330676.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241114062447.GO9438@frogsfrogsfrogs>
References: <20241114062447.GO9438@frogsfrogsfrogs>
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

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/perag-xarray-6.13_2024-11-13

for you to fetch changes up to 612dab1887b16838b524876555ac16fccb750e77:

xfs: insert the pag structures into the xarray later (2024-11-13 22:16:54 -0800)

----------------------------------------------------------------
xfs: convert perag to use xarrays [v5.7 01/10]

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

