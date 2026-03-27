Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB16C262BD
	for <linux-xfs@vger.kernel.org>; Fri, 27 Mar 2026 19:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774639251; cv=none; b=i0cG5tnpZYB2mNhywN+nkqYuOelONJvxnUjiEC+oiWnjarLp992lcV/rI1vpEtZGAh5ShTuk68PqlMaFGB36M/uX5J7caVHKSLaoi+bk7JcsbHoqp5BcvUJyeomSsbD8vO/vYl7Z1XhSGIGHeZiaZga8OB53lxPtA7dbFUSd37s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774639251; c=relaxed/simple;
	bh=8QaB7RRlvYiQ5IDFBe2/pua19Q7C4pNA4XWMJZctSCg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=P7Bn8r4hUh/+D57KQcSis6cofNBO9fq1bcAoqU/v/Ymn0be3eqBBWALBE7zppIy9ANen3fJ8A8we0h9vW8xfTHhMsE+HO5pR29G3b21/OflcAjMhKDLVYAIGouu6aIsXGAXhtkeMy0t/v7J2tbvW5wzmbUjjEY2m+7luF+IrDEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XY6S2wj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XY6S2wj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A055BC19423;
	Fri, 27 Mar 2026 19:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774639251;
	bh=8QaB7RRlvYiQ5IDFBe2/pua19Q7C4pNA4XWMJZctSCg=;
	h=Date:From:To:Cc:Subject:From;
	b=XY6S2wj8hec9ih+JwfWCaQJrBPD2fsfYAIdlCXKj0l9MO8PRnk2V7k54a5EzG+Bf4
	 uoSE5V8qNkRE8oqMd7cB7GJZbrBCPcpVgakQuDJ/HhTDoTKBQqOikP1c1ascPsBpBq
	 rzktz2BpRCTla3uO3064y0j2UC0fT2AzAvyOv48Nyr5wa5WNmTVG7TiKV+SNgobTm4
	 pV1VZj2N1rATMFhepVlsGkusziLq06FBXAPoBBiCfkhntEsBxePueNOF5ym1e54Jhj
	 oocfkqKVwzB9GulveU1s6k+9KEPBh0RYHvZOWirokkVLBulDLWBW1rNFNMeMur7Hn2
	 4IwILj4tqh9fg==
Date: Fri, 27 Mar 2026 20:20:47 +0100
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: Fixes for v7.0-rc6
Message-ID: <acZYhpOcsyA3ZhsZ@nidhogg.toxiclabs.cc>
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

As usual, an attempt merge against your current TOT has been successful.

This pull request includes a few important bug fixes, and some code
refactoring that was necessary for one of the fixes.
With the exception of the top two patches which are fixes worth sending
asap, everything else is in linux-next.

Thanks,
Carlos

"The following changes since commit 362c490980867930a098b99f421268fbd7ca05fd:

  xfs: fix integer overflow in bmap intent sort comparator (2026-03-11 13:21:42 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.0-rc6

for you to fetch changes up to e31c53a8060e134111ed095783fee0aa0c43b080:

  xfs: remove file_path tracepoint data (2026-03-26 14:25:23 +0100)

----------------------------------------------------------------
xfs: fixes for 7.0-rc6

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Bill Wendling (1):
      xfs: annotate struct xfs_attr_list_context with __counted_by_ptr

Christoph Hellwig (1):
      xfs: cleanup buftarg handling in XFS_IOC_VERIFY_MEDIA

Darrick J. Wong (2):
      xfs: don't irele after failing to iget in xfs_attri_recover_work
      xfs: remove file_path tracepoint data

Long Li (6):
      xfs: only assert new size for datafork during truncate extents
      xfs: factor out xfs_attr3_node_entry_remove
      xfs: factor out xfs_attr3_leaf_init
      xfs: close crash window in attr dabtree inactivation
      xfs: fix ri_total validation in xlog_recover_attri_commit_pass2
      xfs: remove redundant validation in xlog_recover_attri_commit_pass2

Yuto Ohnuki (4):
      xfs: stop reclaim before pushing AIL during unmount
      xfs: avoid dereferencing log items after push callbacks
      xfs: save ailp before dropping the AIL lock in push callbacks
      xfs: refactor xfsaild_push loop into helper

hongao (1):
      xfs: scrub: unlock dquot before early return in quota scrub

 fs/xfs/libxfs/xfs_attr.h      |   3 +-
 fs/xfs/libxfs/xfs_attr_leaf.c |  22 ++++++++
 fs/xfs/libxfs/xfs_attr_leaf.h |   3 +
 fs/xfs/libxfs/xfs_da_btree.c  |  53 ++++++++++++++----
 fs/xfs/libxfs/xfs_da_btree.h  |   2 +
 fs/xfs/scrub/quota.c          |   4 +-
 fs/xfs/scrub/trace.h          |  12 +---
 fs/xfs/xfs_attr_inactive.c    |  95 ++++++++++++++++++-------------
 fs/xfs/xfs_attr_item.c        |  51 +----------------
 fs/xfs/xfs_dquot_item.c       |   9 ++-
 fs/xfs/xfs_handle.c           |   2 +-
 fs/xfs/xfs_inode.c            |   3 +-
 fs/xfs/xfs_inode_item.c       |   9 ++-
 fs/xfs/xfs_mount.c            |   7 ++-
 fs/xfs/xfs_trace.h            |  47 +++++++++++-----
 fs/xfs/xfs_trans_ail.c        | 127 +++++++++++++++++++++++++-----------------
 fs/xfs/xfs_verify_media.c     |  18 +++---
 fs/xfs/xfs_xattr.c            |   2 +-
 18 files changed, 274 insertions(+), 195 deletions(-)"
