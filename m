Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FA714A8B
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728606811; cv=none; b=KLtg6WEUCztFhRsHiiiFayvUL9ebNOIDh9wb175kipXjqUcSgmU7Kg0OEVYHdvYxvPWn6vEMlSBAXR0LxosAIkQ9Zzcb5IJL7wVBQaWXO0I0dgCCHucL89xG5rhXEOc8UvJsDGLJNbNhTqTqtYlRx8TUl32peZ1JfPC45vkrsjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728606811; c=relaxed/simple;
	bh=enVJnLiDUZDYLlkhengQB0zIHfaxzxgj4MPhIf9DNbc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gh8FgNWXX91DEJw1pRltJ3sOEWW2mwl9236Y57kYbjDlphpo5zv2scS+7MAk8X93UL7jCIZtEQEM5mJYzGT/TgoVU97+E4+Pc8GYaAznxKABgcv8h+m30LhtJ84FF904QybpWGvzLwS7HK2JL86+czH5ajVHwlNRXbe9+69b3q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RrlqQFL3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RrlqQFL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E60C4CECC;
	Fri, 11 Oct 2024 00:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728606811;
	bh=enVJnLiDUZDYLlkhengQB0zIHfaxzxgj4MPhIf9DNbc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RrlqQFL3xdkCaENEsoj+3AySovmJvlkqLDFUM0fx+LqgiX2dQ2gct1JedO2Xukcwk
	 wOkzrBOF9O1KIBmwczN9KWd8yH4y7fksAyoA6MWdvwpBcwJV19A2O78cOeKj5h5/HI
	 +r/6RL4T+7EGWUMA2ceKR5QF2chgzl8o2bELYnxQ34h6BcJCSiiEZID58hx2oOwCBb
	 q77PV6W0YIWOlCjUSy3U0cf06BfL/1/8dVrIWIbSKkWVfjalQM5uL5RcX7L4MvggW+
	 3QknJ6I/KnSYw7MdRv2zbZ0U9NF5CHSLw43w4E9xUVpHKAdFOOzpRLXDpg3AfW2mg0
	 4/4bwbtQI/pXA==
Date: Thu, 10 Oct 2024 17:33:30 -0700
Subject: [PATCHSET v5.0 1/9] xfs: convert perag to use xarrays
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
In-Reply-To: <20241011002402.GB21877@frogsfrogsfrogs>
References: <20241011002402.GB21877@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Convert the xfs_mount perag tree to use an xarray instead of a radix
tree.  There should be no functional changes here.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=perag-xarray

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=perag-xarray
---
Commits in this patchset:
 * xfs: pass the exact range to initialize to xfs_initialize_perag
 * xfs: merge the perag freeing helpers
 * xfs: don't use __GFP_RETRY_MAYFAIL in xfs_initialize_perag
 * xfs: fix superfluous clearing of info->low in __xfs_getfsmap_datadev
 * xfs: remove the unused pagb_count field in struct xfs_perag
 * xfs: remove the unused pag_active_wq field in struct xfs_perag
 * xfs: pass a pag to xfs_difree_inode_chunk
 * xfs: remove the agno argument to xfs_free_ag_extent
 * xfs: add xfs_agbno_to_fsb and xfs_agbno_to_daddr helpers
 * xfs: add a xfs_agino_to_ino helper
 * xfs: pass a pag to xfs_extent_busy_{search,reuse}
 * xfs: keep a reference to the pag for busy extents
 * xfs: remove the mount field from struct xfs_busy_extents
 * xfs: remove the unused trace_xfs_iwalk_ag trace point
 * xfs: remove the unused xrep_bmap_walk_rmap trace point
 * xfs: constify pag arguments to trace points
 * xfs: pass a perag structure to the xfs_ag_resv_init_error trace point
 * xfs: pass objects to the xfs_irec_merge_{pre,post} trace points
 * xfs: pass the iunlink item to the xfs_iunlink_update_dinode trace point
 * xfs: pass objects to the xrep_ibt_walk_rmap tracepoint
 * xfs: pass the pag to the trace_xrep_calc_ag_resblks{,_btsize} trace points
 * xfs: pass the pag to the xrep_newbt_extent_class tracepoints
 * xfs: convert remaining trace points to pass pag structures
 * xfs: split xfs_initialize_perag
 * xfs: insert the pag structures into the xarray later
---
 fs/xfs/libxfs/xfs_ag.c             |  173 ++++++++++++++-------------------
 fs/xfs/libxfs/xfs_ag.h             |   36 +++++--
 fs/xfs/libxfs/xfs_ag_resv.c        |    3 -
 fs/xfs/libxfs/xfs_alloc.c          |   32 +++---
 fs/xfs/libxfs/xfs_alloc.h          |    5 -
 fs/xfs/libxfs/xfs_alloc_btree.c    |    2 
 fs/xfs/libxfs/xfs_btree.c          |    7 +
 fs/xfs/libxfs/xfs_ialloc.c         |   67 ++++++-------
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 
 fs/xfs/libxfs/xfs_inode_util.c     |    4 -
 fs/xfs/libxfs/xfs_refcount.c       |   11 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |    3 -
 fs/xfs/libxfs/xfs_rmap_btree.c     |    2 
 fs/xfs/scrub/agheader_repair.c     |   16 +--
 fs/xfs/scrub/alloc_repair.c        |   10 +-
 fs/xfs/scrub/bmap.c                |    5 -
 fs/xfs/scrub/bmap_repair.c         |    4 -
 fs/xfs/scrub/common.c              |    2 
 fs/xfs/scrub/cow_repair.c          |   18 +--
 fs/xfs/scrub/ialloc.c              |    8 +-
 fs/xfs/scrub/ialloc_repair.c       |   25 ++---
 fs/xfs/scrub/newbt.c               |   46 ++++-----
 fs/xfs/scrub/reap.c                |    8 +-
 fs/xfs/scrub/refcount_repair.c     |    5 -
 fs/xfs/scrub/repair.c              |   13 +-
 fs/xfs/scrub/rmap_repair.c         |    9 +-
 fs/xfs/scrub/trace.h               |  161 ++++++++++++++----------------
 fs/xfs/xfs_discard.c               |   20 ++--
 fs/xfs/xfs_extent_busy.c           |   31 ++----
 fs/xfs/xfs_extent_busy.h           |   14 +--
 fs/xfs/xfs_extfree_item.c          |    4 -
 fs/xfs/xfs_filestream.c            |    5 -
 fs/xfs/xfs_fsmap.c                 |   25 ++---
 fs/xfs/xfs_fsops.c                 |   20 ++--
 fs/xfs/xfs_health.c                |    8 +-
 fs/xfs/xfs_inode.c                 |    5 -
 fs/xfs/xfs_iunlink_item.c          |   13 +-
 fs/xfs/xfs_iwalk.c                 |   17 ++-
 fs/xfs/xfs_log_cil.c               |    3 -
 fs/xfs/xfs_log_recover.c           |   10 +-
 fs/xfs/xfs_mount.c                 |    9 +-
 fs/xfs/xfs_trace.c                 |    1 
 fs/xfs/xfs_trace.h                 |  191 +++++++++++++++---------------------
 fs/xfs/xfs_trans.c                 |    2 
 44 files changed, 469 insertions(+), 586 deletions(-)

