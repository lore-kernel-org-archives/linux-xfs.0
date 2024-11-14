Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C13A954;
	Thu, 14 Nov 2024 00:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731543470; cv=none; b=tFCgI1RESQZrrlx4ivR8LydLw8sEczgmZ/cB8ugO/Yncq9XMkzoZfhQi1FJCCJHWxF6E3aQqcT4EJGsFs2Qg4Ob1hiyCyjLbh2WqTpOWzmQ54V7dHFv0KlFxDqO5mLANAibVfBAeSXNGfUet9zkO01PqGNsNtmfTMb6LW1TDL/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731543470; c=relaxed/simple;
	bh=iqUC+n3p293+BnFyEtc64ehpG3kOk0AV51k+pH0YVwc=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=rfiDTUXZH9XForTPI6amsNySSmS58Tw/0uZdSPvYaZ+edZyopptFjUJOmDH1GkmyBiYK2yepvK1qrsjCvZiJhxGaBfy2KzgKyeYMVnL8r8o61igOxVDJ7P40lGBzZ34OTProFZnE/3RHzJqLPLHQMBKT6DHQcHVRQ6zudyKt/KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M9Dq0PQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M9Dq0PQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B19C4CEC3;
	Thu, 14 Nov 2024 00:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731543469;
	bh=iqUC+n3p293+BnFyEtc64ehpG3kOk0AV51k+pH0YVwc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M9Dq0PQ8fNdaEdTTy5ouvfv7WPAYwSfQQ3y0ODCS6XZzIZX3YRK6WJfSk/ZVqD9xm
	 KgpmZHHueem0SCXerRf0wKm6TfnOhSqONap/ONpksDdUVZurDv6ZCHJzkYIRmqgYaC
	 dhXfKbo4ObdhYV/omj+Hwf6NgR8k7uTjFCVi8cSr//3AwOtXVzjCRBmhpW6fUdYvB0
	 N6+3KrJwWBB+ItCpMr6phjzJcPVA1WL9lUAGZkOC7xTqw4x00+0Rj1DozrH3DJgTjj
	 7rCCBmqWcajZo2rakkWF9H6XpWsUBeinZ7wv4yss855ZT//EYPGU9ppq9YVl5r2UtX
	 Zzn82HUtHiLRQ==
Date: Wed, 13 Nov 2024 16:17:48 -0800
Subject: [GIT PULL 01/10] xfs: convert perag to use xarrays
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, stable@vger.kernel.org
Message-ID: <173154341879.1140548.17168724047038023840.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241114001637.GL9438@frogsfrogsfrogs>
References: <20241114001637.GL9438@frogsfrogsfrogs>
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

for you to fetch changes up to ab2d77da259c91c00940f7638a33af57f82af0f6:

xfs: insert the pag structures into the xarray later (2024-11-13 16:05:20 -0800)

----------------------------------------------------------------
xfs: convert perag to use xarrays [v5.6 01/10]

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

