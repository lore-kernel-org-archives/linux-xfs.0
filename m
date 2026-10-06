Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50340217723
	for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2026 13:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791292611; cv=none; b=JVavzEq3e0RjLBOaQKCiSYGlViXyjzUeyGAHwNJNC/e4QBPk3DlJQW4slXyNpnMfgDLxmomchFrPZrr+fOrHIAaEoXnSmoZxCQV6bqSruLHB0VABp+yXEC4ica16+EF/Tc9ljejQWwJ63hFzfRp/M/WTlxTB2AT10+HH0nYdMYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791292611; c=relaxed/simple;
	bh=sffSBePy9qj2Ms5qX4sfEkBvq91TtPhM5AV2Xiqimws=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=R0vlNQYM3+eONzBkWMj9rpdra1J33E0jWunXuUYVkYbH+t74ghYnDyit+XzYeFgWK3tDNGc3wjh2NPUqhjfr6dUw8kAVcKHAjdE0bDQD+CZsOKbiT3EPaUVrslN2zl9L5OO9GLQuTiyt2+NbJTFUs7VshJShsomyolloXVtoUmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TtlRSQ0m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TtlRSQ0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E951F000FF
	for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2026 13:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791292609;
	bh=Qb5WMa/rpyOlqcCd9NvNwPSBwxn/YBzbfOH3Iftdef4=;
	h=Date:From:To:Subject;
	b=TtlRSQ0mqOF1fTbzGfVLFl6RKN1INohmTziv3yyrsDFLiL4viXTZIjjQBdhuqgO61
	 nPPxPvE5j+/QFoYzO7ArXQPHNp7zEKdqmeZaz/kTmm+4jKgi7Add/qSj+767rmyzcQ
	 73871bJCwF1Yckl0+XV9aDhfsMl8nApnyIUCUgOIY/ccssRG8wdFrbwYl0AeUkjVp5
	 jzmsE3FZl0ExptviCSGDfF+S9YGGZ2tHhmoB8tOEVQwF/zmxmVkJqzJk6ptVVnKNtO
	 2UCRV6GGLh2erwlycwWwN9ATTsBuJO/HUMX/PbkwSBxQ+1aSg9MtsOY6WEsZbAEa/N
	 e4yYIaT6bfaeA==
Date: Tue, 6 Oct 2026 15:16:44 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 197f678cccba
Message-ID: <asT0o_5zxX24V1-b@cronus.toxiclabs.cc>
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

197f678cccba xfs: don't let racing writers consume the free zones reserved for GC

27 new commits:

Brian Foster (4):
      [a9a984a1e6ea] xfs: set minleft correctly for sparse chunk errortag allocation
      [ad4c2c4630b7] xfs: support additional levels in the agfl minimum calculation
      [831f4c28b5dc] xfs: calculate AGFL max to support multiple-alloc transactions
      [a644af916cf1] xfs: incorporate increased AGFL min requirement for minleft allocs

Darrick J. Wong (21):
      [4c6668ecebc6] xfs: adjust checks for cross-AG reaping issues
      [436ae68743a6] xfs: actually check XFS_DIFLAG2_METADATA for metadata btree data forks
      [6b8d60784b61] xfs: fix xchk_stats_estimate_bufsize to allow for the trailing null
      [0c61016006ab] xfs: cross-reference the primary superblock
      [33dfad5a7bbf] xfs: write the rt super immediately during repair
      [cd16b947cac1] xfs: read rt superblock from disk during scrub
      [02722664508c] xfs: write the primary super immediately during repair
      [612d2e7506c3] xfs: read primary superblock from disk during scrub
      [49d300a51442] xfs: jump out of xchk_bmap_check_rmap if fatal signals
      [f61c91a2e599] xfs: mark overfull dabtree node blocks as corrupt
      [43030b72a11a] xfs: check fork type against dabtree block magic number
      [07732dea4f5d] xfs: abort dirtree repair if the live update hook dies
      [d83ca4e7cc65] xfs: bail out of directory tree repairs on error
      [6c64d650460b] xfs: fix revalidation of xchk_dquot_iter cached mappings
      [22a8a7501c01] xfs: don't repair fs summary counters with garbage
      [342c2e00b3a9] xfs: allow softlimit with no hardlimit in quota scrub
      [fe67a493c7a7] xfs: assign an owner to scrub_stats_fops
      [8c4f172c2467] xfs: fix lost errno returned from xfarray_foliosort
      [63341d4af16f] xfs: fix skipped inode mask handling in iscan
      [833f98b3be45] xfs: don't proceed with xattr repair if the live update fails
      [c8226f3d1a7e] xfs: don't fix the directory tree if live update fails

Eric Sandeen (1):
      [f04361fb8694] xfs: validate rc_domain in xchk_rtrefcount_mergeable

Hans Holmberg (1):
      [197f678cccba] xfs: don't let racing writers consume the free zones reserved for GC

Code Diffstat:

 fs/xfs/libxfs/xfs_alloc.c      | 106 ++++++++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_alloc.h      |   7 +--
 fs/xfs/libxfs/xfs_bmap.c       |   7 ++-
 fs/xfs/libxfs/xfs_ialloc.c     |  14 +++---
 fs/xfs/libxfs/xfs_zones.h      |   6 +++
 fs/xfs/scrub/agheader.c        |  50 +++++++++++++++----
 fs/xfs/scrub/agheader_repair.c |  31 ++++++++++--
 fs/xfs/scrub/attr_repair.c     |   3 ++
 fs/xfs/scrub/bmap.c            |   7 +++
 fs/xfs/scrub/dabtree.c         |  16 +++++++
 fs/xfs/scrub/dirtree_repair.c  |  67 ++++++++++++++++++--------
 fs/xfs/scrub/dqiterate.c       |   1 +
 fs/xfs/scrub/fscounters.c      |   4 +-
 fs/xfs/scrub/inode_repair.c    |   5 ++
 fs/xfs/scrub/iscan.c           |   2 +-
 fs/xfs/scrub/quota.c           |   8 ++--
 fs/xfs/scrub/quota_repair.c    |   6 +--
 fs/xfs/scrub/reap.c            |   2 +-
 fs/xfs/scrub/rgsuper.c         |  33 +++++++++++--
 fs/xfs/scrub/rtrefcount.c      |   2 +
 fs/xfs/scrub/stats.c           |   5 +-
 fs/xfs/scrub/xfarray.c         |   4 +-
 fs/xfs/xfs_zone_alloc.c        |  36 ++++++++++++--
 23 files changed, 326 insertions(+), 96 deletions(-)
