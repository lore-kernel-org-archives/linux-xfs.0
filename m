Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513BE1870
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738263; cv=none; b=LqiWK3huPi3ESYtunTYw+/aq3QdGUgn8LEEgNGcUEKHOIn8jFlvwURhQGAthfuOJPb6QOe0s6ywqxQt+TnSkrsGsR9a3cZefalhbXEt4b1uTWciQLbJDZVIqegLDI3va2h5ziQJeT9VZiSosy7TnAEMAIT4DSIH6BM9lgeQM1s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738263; c=relaxed/simple;
	bh=zjLMWac6yhFyPvccjPrQAm/1HWYu8rlm5WU6739KsFU=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=Qj2SHTQC4jp+MvVbNst5gAx9g6sXTPxoS4MYvnsNejk3yc3upUZtsHAZwVLzKPZMie3HawCvsPUsoL0f0gktFAQmlm0xce7pMLFyZuz1vzM9HqaVbv8+cylKxk5kksqHPeKb9hiTiQGx9fig/MYRUnaPyvlQowQ2Q/TzPdB1Xc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V3THODWb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V3THODWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C19C433C7;
	Sat, 24 Feb 2024 01:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738263;
	bh=zjLMWac6yhFyPvccjPrQAm/1HWYu8rlm5WU6739KsFU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V3THODWbkGSJGqBPqn5npa/Amdk44vpwjiMR3HK4UE3n1QjV6gTizPy3I9ynchLFY
	 oMmG+n6Gt5xiHnRfub1OM6FVVJEqDGVKmawy6VKo3ZRjk/i/srxror16j8/83cWsmd
	 jkV2sX7MBnyhMO+bWvXgtF+RBNMPBOH4TVMoTkSVtSJvNPpO5+/3f+F3GIaNPvunYJ
	 PvSA+00jMz30Sp8Z4idHReBOtpAZ0ujCnwfjl1TC0j8Gtl3+CCFa8U2QA2ZCTmeqA3
	 5/LVnRpVV83tUjoYw24r3URC9+pye9TOixPyjs6GEX503/uxFmIQGX4NCUj0QgZjLf
	 cD7k0CJdmn5/Q==
Date: Fri, 23 Feb 2024 17:31:02 -0800
Subject: [GIT PULL 8/18] xfs: remove bc_btnum from btree cursors
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170873803411.1891722.4886429032847981179.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240224010220.GN6226@frogsfrogsfrogs>
References: <20240224010220.GN6226@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.9-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit f73def90a7cd24a32a42f689efba6a7a35edeb7b:

xfs: create predicate to determine if cursor is at inode root level (2024-02-22 12:37:24 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/btree-remove-btnum-6.9_2024-02-23

for you to fetch changes up to ec793e690f801d97a7ae2a0d429fea1fee4d44aa:

xfs: remove xfs_btnum_t (2024-02-22 12:40:51 -0800)

----------------------------------------------------------------
xfs: remove bc_btnum from btree cursors [v29.3 08/18]

From Christoph Hellwig,

This series continues the migration of btree geometry information out of
the cursor structure and into the ops structure.  This time around, we
replace the btree type enumeration (btnum) with an explicit name string
in the btree ops structure.  This enables easy creation of /any/ new
btree type without having to mess with libxfs.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (26):
xfs: move comment about two 2 keys per pointer in the rmap btree
xfs: add a xfs_btree_init_ptr_from_cur
xfs: don't override bc_ops for staging btrees
xfs: fold xfs_allocbt_init_common into xfs_allocbt_init_cursor
xfs: remove xfs_allocbt_stage_cursor
xfs: fold xfs_inobt_init_common into xfs_inobt_init_cursor
xfs: remove xfs_inobt_stage_cursor
xfs: fold xfs_refcountbt_init_common into xfs_refcountbt_init_cursor
xfs: remove xfs_refcountbt_stage_cursor
xfs: fold xfs_rmapbt_init_common into xfs_rmapbt_init_cursor
xfs: remove xfs_rmapbt_stage_cursor
xfs: make full use of xfs_btree_stage_ifakeroot in xfs_bmbt_stage_cursor
xfs: fold xfs_bmbt_init_common into xfs_bmbt_init_cursor
xfs: remove xfs_bmbt_stage_cursor
xfs: split the agf_roots and agf_levels arrays
xfs: add a name field to struct xfs_btree_ops
xfs: add a sick_mask to struct xfs_btree_ops
xfs: refactor the btree cursor allocation logic in xchk_ag_btcur_init
xfs: split xfs_allocbt_init_cursor
xfs: remove xfs_inobt_cur
xfs: remove the btnum argument to xfs_inobt_count_blocks
xfs: remove the which variable in xchk_iallocbt
xfs: split xfs_inobt_insert_sprec
xfs: split xfs_inobt_init_cursor
xfs: pass a 'bool is_finobt' to xfs_inobt_insert
xfs: remove xfs_btnum_t

Darrick J. Wong (1):
xfs: make staging file forks explicit

fs/xfs/libxfs/xfs_ag.c             |  13 ++-
fs/xfs/libxfs/xfs_ag.h             |   8 +-
fs/xfs/libxfs/xfs_alloc.c          |  99 +++++++++-----------
fs/xfs/libxfs/xfs_alloc_btree.c    | 156 ++++++++++++++++++--------------
fs/xfs/libxfs/xfs_alloc_btree.h    |  10 +-
fs/xfs/libxfs/xfs_bmap_btree.c     |  89 ++++++------------
fs/xfs/libxfs/xfs_bmap_btree.h     |   2 -
fs/xfs/libxfs/xfs_btree.c          | 114 +++++++++++++++++------
fs/xfs/libxfs/xfs_btree.h          |  18 ++--
fs/xfs/libxfs/xfs_btree_staging.c  | 111 +----------------------
fs/xfs/libxfs/xfs_btree_staging.h  |   7 +-
fs/xfs/libxfs/xfs_format.h         |  21 ++---
fs/xfs/libxfs/xfs_ialloc.c         | 181 +++++++++++++++++++++++--------------
fs/xfs/libxfs/xfs_ialloc_btree.c   | 144 +++++++++++++----------------
fs/xfs/libxfs/xfs_ialloc_btree.h   |  11 +--
fs/xfs/libxfs/xfs_refcount_btree.c |  52 ++++-------
fs/xfs/libxfs/xfs_refcount_btree.h |   2 -
fs/xfs/libxfs/xfs_rmap_btree.c     |  65 +++++--------
fs/xfs/libxfs/xfs_rmap_btree.h     |   2 -
fs/xfs/libxfs/xfs_shared.h         |  35 +++++++
fs/xfs/libxfs/xfs_types.h          |  26 +-----
fs/xfs/scrub/agheader.c            |  12 +--
fs/xfs/scrub/agheader_repair.c     |  47 ++++------
fs/xfs/scrub/alloc_repair.c        |  27 +++---
fs/xfs/scrub/bmap_repair.c         |   8 +-
fs/xfs/scrub/btree.c               |  12 +--
fs/xfs/scrub/common.c              |  72 ++++++++-------
fs/xfs/scrub/health.c              |  54 ++---------
fs/xfs/scrub/health.h              |   4 +-
fs/xfs/scrub/ialloc.c              |  20 ++--
fs/xfs/scrub/ialloc_repair.c       |   8 +-
fs/xfs/scrub/iscan.c               |   2 +-
fs/xfs/scrub/refcount_repair.c     |   4 +-
fs/xfs/scrub/repair.c              |  14 +--
fs/xfs/scrub/rmap.c                |  15 ++-
fs/xfs/scrub/trace.h               |  48 ++++------
fs/xfs/xfs_discard.c               |   2 +-
fs/xfs/xfs_fsmap.c                 |   4 +-
fs/xfs/xfs_health.c                |  36 +++-----
fs/xfs/xfs_iwalk.c                 |   8 +-
fs/xfs/xfs_trace.h                 |  89 ++++++++----------
41 files changed, 748 insertions(+), 904 deletions(-)

