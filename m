Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D87A212D1C
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729190784; cv=none; b=li0hNlkV8++6zGV5glWJdmdI8F828cmS4IVa0PEbJOF1hwHU1uq/TAQzZ+jehl24371DQSc5Ypxm+7IZAfzZXq7m8DdtRnje8I9gmGnanx+JJUlFh0wLCh9O7S88UIyT4FbO29BpNPtfPxjMsRmeODbHIszJrw9RSVCAgGcL3gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729190784; c=relaxed/simple;
	bh=0lArJz7cfJF9ddUup0oG9ruvYkKG8zWMGEYhikGf3IY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jo6ltnP0qSo2IbfBTleqlHFoH8HqbXToJ+aJkX28vSngWh42s74UbffEW8RiZTMgUTYS99dUBOtemLpsUspP+aGVJqP4zHiDT5p4mgLS0Rw2csVglEqnHb31vbnzaNha29wXQ4jA8eJzRGtnKc3UXM/WGq4tdnrF4KDiGqkErOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a60wNR06; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a60wNR06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29808C4CEC3;
	Thu, 17 Oct 2024 18:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729190784;
	bh=0lArJz7cfJF9ddUup0oG9ruvYkKG8zWMGEYhikGf3IY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a60wNR06WTVkrGCczK+7rxMtTK9djAwu9/4PjgHIdTeCBl7d9IUeonO6pS/rLUcbG
	 eRCDSH1eiyCnV4zsazMJ8IR62y0JcuELWCFM+SRU2D42ZMIYK79CjI+6+iLz/sgsXK
	 xdU6XEtusi9mmRsqBare8wY2TWGhXN/7mc0oh8CDmj74lc7zuqYdsF+SKvIb/QV6nS
	 iWWYppn1d5rkeMnb/+J+UzZ4tICsJ948H3qREkV3Ft7Hlu7quPn4T37K2J9v8UlLUo
	 BOUX0M9kAdu7pXORfXr4xSq09/e81AeCimDj4QAphahyhakzAWPUXQPTGuAh612+Ea
	 o2/+u01abtQeQ==
Date: Thu, 17 Oct 2024 11:46:23 -0700
Subject: [PATCHSET v5.1 1/9] xfs: convert perag to use xarrays
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
In-Reply-To: <20241017184009.GV21853@frogsfrogsfrogs>
References: <20241017184009.GV21853@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_ag.c             |  125 +++++++++++++-----------
 fs/xfs/libxfs/xfs_ag.h             |   26 +++++
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
 fs/xfs/xfs_health.c                |    8 +-
 fs/xfs/xfs_inode.c                 |    5 -
 fs/xfs/xfs_iunlink_item.c          |   13 +-
 fs/xfs/xfs_iwalk.c                 |   17 ++-
 fs/xfs/xfs_log_cil.c               |    3 -
 fs/xfs/xfs_log_recover.c           |    5 -
 fs/xfs/xfs_trace.c                 |    1 
 fs/xfs/xfs_trace.h                 |  191 +++++++++++++++---------------------
 fs/xfs/xfs_trans.c                 |    2 
 42 files changed, 442 insertions(+), 521 deletions(-)

