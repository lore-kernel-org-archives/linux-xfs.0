Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9AC8527B
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816357; cv=none; b=MouC6pDdtq2LteTcLpk1DJCD5gmAflfESjmA/9C/8AZgXDhLKZYOxDeDe4LB8TykxKi3eW8tyTeC9UaBkjiv/XH8dqorRLtw7I1G69XWVIPV4D8F8EBRs1LLIlNHvR66AffrVB/gBLZWcazSHccvMMLnd1f9DFRE9VMqYeRcbh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816357; c=relaxed/simple;
	bh=Roap/URPxZoeXF9vn36ZAtQSbHkHKgL8LMPC1Wvlox8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=cYAWAlxVnCoAqFuB0gwY+roOZFgmvcGw/o0/fUjF6YA+psOKEIkpaURlj7tqGypRmTsnY/qSpKncTWvWkcDotpNs/h73aeFIAAPcU/tteqkN4Ca9zO5dfPyn4BPNEZ78pb8CavGWONgygRgav2MToMInOV9JqUISS7xXb1/mKXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uksyZRi3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uksyZRi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC70FC433C7;
	Thu,  1 Feb 2024 19:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816356;
	bh=Roap/URPxZoeXF9vn36ZAtQSbHkHKgL8LMPC1Wvlox8=;
	h=Date:Subject:From:To:Cc:From;
	b=uksyZRi3EPyaJsMlSV5ehhyHkTL6vFY2LCVdseq0Dq2JP2e00xSX7wBZd1U7aV2Xf
	 /iWEFbTgE4pPi5e9BA9Tsl76UIFvsLvKmlYrAhY4rZd6V+kDNjAGHjSSY2d8lXBjGr
	 IlJJtc1OoJUqOlg4qSb7g9PIXYbHlafzP17xhyeNP3Sj6S5XIooINzW6uCYDHhK8Mi
	 iyNSdPvYlGV4tmiAukUOuGRLgUB5HxTEQzpYvAQd6Yg3idixOeC+lCkpGIDVb5nPHL
	 cIsjcVmv9j7VC09icEChf5B6GOuqrmf/OaJMFjBVhEiCX0q6a/BaI6kzMHwd05O6G+
	 LJTuIj6SoJciQ==
Date: Thu, 01 Feb 2024 11:39:16 -0800
Subject: [PATCHSET v29.2 2/8] xfs: remove bc_btnum from btree cursors
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
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

From Christoph Hellwig,

This series continues the migration of btree geometry information out of
the cursor structure and into the ops structure.  This time around, we
replace the btree type enumeration (btnum) with an explicit name string
in the btree ops structure.  This enables easy creation of /any/ new
btree type without having to mess with libxfs.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-remove-btnum

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=btree-remove-btnum
---
Commits in this patchset:
 * xfs: move comment about two 2 keys per pointer in the rmap btree
 * xfs: add a xfs_btree_init_ptr_from_cur
 * xfs: don't override bc_ops for staging btrees
 * xfs: fold xfs_allocbt_init_common into xfs_allocbt_init_cursor
 * xfs: remove xfs_allocbt_stage_cursor
 * xfs: fold xfs_inobt_init_common into xfs_inobt_init_cursor
 * xfs: remove xfs_inobt_stage_cursor
 * xfs: fold xfs_refcountbt_init_common into xfs_refcountbt_init_cursor
 * xfs: remove xfs_refcountbt_stage_cursor
 * xfs: fold xfs_rmapbt_init_common into xfs_rmapbt_init_cursor
 * xfs: remove xfs_rmapbt_stage_cursor
 * xfs: make full use of xfs_btree_stage_ifakeroot in xfs_bmbt_stage_cursor
 * xfs: make fake file forks explicit
 * xfs: fold xfs_bmbt_init_common into xfs_bmbt_init_cursor
 * xfs: remove xfs_bmbt_stage_cursor
 * xfs: split the agf_roots and agf_levels arrays
 * xfs: add a name field to struct xfs_btree_ops
 * xfs: add a sick_mask to struct xfs_btree_ops
 * xfs: refactor the btree cursor allocation logic in xchk_ag_btcur_init
 * xfs: split xfs_allocbt_init_cursor
 * xfs: remove xfs_inobt_cur
 * xfs: remove the btnum argument to xfs_inobt_count_blocks
 * xfs: remove the which variable in xchk_iallocbt
 * xfs: split xfs_inobt_insert_sprec
 * xfs: split xfs_inobt_init_cursor
 * xfs: pass a 'bool is_finobt' to xfs_inobt_insert
 * xfs: remove xfs_btnum_t
---
 fs/xfs/libxfs/xfs_ag.c             |   13 +--
 fs/xfs/libxfs/xfs_ag.h             |    8 +-
 fs/xfs/libxfs/xfs_alloc.c          |   99 +++++++++-----------
 fs/xfs/libxfs/xfs_alloc_btree.c    |  156 +++++++++++++++++--------------
 fs/xfs/libxfs/xfs_alloc_btree.h    |   10 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |   89 ++++++------------
 fs/xfs/libxfs/xfs_bmap_btree.h     |    2 
 fs/xfs/libxfs/xfs_btree.c          |  114 ++++++++++++++++++-----
 fs/xfs/libxfs/xfs_btree.h          |   18 +---
 fs/xfs/libxfs/xfs_btree_staging.c  |  111 +---------------------
 fs/xfs/libxfs/xfs_btree_staging.h  |    7 +
 fs/xfs/libxfs/xfs_format.h         |   21 ++--
 fs/xfs/libxfs/xfs_ialloc.c         |  181 ++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  144 +++++++++++++----------------
 fs/xfs/libxfs/xfs_ialloc_btree.h   |   11 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |   52 +++-------
 fs/xfs/libxfs/xfs_refcount_btree.h |    2 
 fs/xfs/libxfs/xfs_rmap_btree.c     |   65 +++++--------
 fs/xfs/libxfs/xfs_rmap_btree.h     |    2 
 fs/xfs/libxfs/xfs_shared.h         |   35 +++++++
 fs/xfs/libxfs/xfs_types.h          |   26 +----
 fs/xfs/scrub/agheader.c            |   12 +-
 fs/xfs/scrub/agheader_repair.c     |   47 +++------
 fs/xfs/scrub/alloc_repair.c        |   27 +++--
 fs/xfs/scrub/bmap_repair.c         |    8 +-
 fs/xfs/scrub/btree.c               |   12 +-
 fs/xfs/scrub/common.c              |   72 ++++++++------
 fs/xfs/scrub/health.c              |   54 ++---------
 fs/xfs/scrub/health.h              |    4 -
 fs/xfs/scrub/ialloc.c              |   20 +---
 fs/xfs/scrub/ialloc_repair.c       |    8 +-
 fs/xfs/scrub/iscan.c               |    2 
 fs/xfs/scrub/refcount_repair.c     |    4 -
 fs/xfs/scrub/repair.c              |   14 +--
 fs/xfs/scrub/rmap.c                |   15 +--
 fs/xfs/scrub/trace.h               |   48 ++++------
 fs/xfs/xfs_discard.c               |    2 
 fs/xfs/xfs_fsmap.c                 |    4 -
 fs/xfs/xfs_health.c                |   36 ++-----
 fs/xfs/xfs_iwalk.c                 |    8 +-
 fs/xfs/xfs_trace.h                 |   89 ++++++++----------
 41 files changed, 748 insertions(+), 904 deletions(-)

