Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783D41C2336
	for <linux-xfs@vger.kernel.org>; Thu, 10 Oct 2024 11:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728558766; cv=none; b=sHhNaTOKfvHTmGTSh+syjszwoKvBJLXhcnXOLc67ULsa4mJXldjy/R2hItZOa4Ox/NWcw+svu19Xm37Fr8TSFH2Yn8MV43J27I/c1YYRXD18xqJyvvutDrcgCBunqlfxAHaOVJr36s+zRLMU5NamgWjecx9KOsPHsHzHNl3Dw1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728558766; c=relaxed/simple;
	bh=tYVuvCmSPPkNurzhLMBkx576UfEBuvULU7zURDzx5io=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ekurm4HN+y/j2vEuU65/zCNqV4inSbgIBJJSDZSBXNQzTj0xOu4DWT/TFJWpvp6SEbJ01zERYwRsvZ0wXaDNyka4WPo3iDPnClL6X63hG7sO9Si1n4MaoglkXSMXHesIvHbKDRY7t7V7aV+zc5wkvPZLYQ+nY7SHk3k+PGybprg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nYjCy24Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nYjCy24Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C54AC4CEC5
	for <linux-xfs@vger.kernel.org>; Thu, 10 Oct 2024 11:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728558766;
	bh=tYVuvCmSPPkNurzhLMBkx576UfEBuvULU7zURDzx5io=;
	h=Date:From:To:Subject:From;
	b=nYjCy24YEoQTP6yjtJcWffcoinwDrtw3/VHPO6OCvZ3CSNsTy5wcoln4xJAqAopnp
	 z8+Is8w0lPLMstVDlh6mnNIHREHaO+Z8Dfsy0cd/ETqW0xtoPYw59LXrguRoYa+Ej9
	 j2dKv8bsa1Wx1MaUekJu13YvMDFMGjv1x/6QsWI3fVlcaNRP17+XCnIMndOfRPojDU
	 OTDEG/2FXuC8AdKjz4HdmRFuc0WJr8FWsFmFBJ2SH95nO/aBnQME68yn0Io2jxfphq
	 KcuXupKfV2mbYO4TVlKa3sFy4x7VCV61w4cDwi6mvEowCKJocXfUQNFrKdBcCP20ru
	 8rx4Ka3EwBULg==
Date: Thu, 10 Oct 2024 13:12:42 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next **REBASED** to 77bfe1b11ea0
Message-ID: <hwgxagdixozds3karl5rlpyoquar7aiwcvhork527xnnyng27a@eunr3xdspko4>
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

	git@gitolite.kernel.org:/pub/scm/fs/xfs/xfs-linux.git

has just been **REBASED**.


My apologies for rebasing it again for the second time and I hope it doesn't
disrupt anybody's work. The reason for the rebase was a simple issue on one
of the patches descriptions pointed by Stephen Rothwell during the time the
patches were on linux-next. The patches are still exactly the same, nothing
has changed other than a 'Fixes:' tag in one of the patches, I'm just rebasing
it so I don't sent my first pull to Linus with some obvious mistake..



Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

77bfe1b11ea0 xfs: fix a typo

15 new commits:

Andrew Kreimer (1):
      [77bfe1b11ea0] xfs: fix a typo

Brian Foster (2):
      [90a71daaf73f] xfs: skip background cowblock trims on inodes open for write
      [4390f019ad78] xfs: don't free cowblocks from under dirty pagecache on unshare

Chandan Babu R (1):
      [ae6f70c66748] MAINTAINERS: add Carlos Maiolino as XFS release manager

Christoph Hellwig (8):
      [b1c649da15c2] xfs: merge xfs_attr_leaf_try_add into xfs_attr_leaf_addname
      [346c1d46d4c6] xfs: return bool from xfs_attr3_leaf_add
      [a5f73342abe1] xfs: distinguish extra split from real ENOSPC from xfs_attr3_leaf_split
      [b3f4e84e2f43] xfs: distinguish extra split from real ENOSPC from xfs_attr_node_try_addname
      [865469cd41bc] xfs: fold xfs_bmap_alloc_userdata into xfs_bmapi_allocate
      [b611fddc0435] xfs: don't ifdef around the exact minlen allocations
      [405ee87c6938] xfs: call xfs_bmap_exact_minlen_extent_alloc from xfs_bmap_btalloc
      [6aac77059881] xfs: support lowmode allocations in xfs_bmap_exact_minlen_extent_alloc

Uros Bizjak (1):
      [20195d011c84] xfs: Use try_cmpxchg() in xlog_cil_insert_pcp_aggregate()

Yan Zhen (1):
      [6148b77960cc] xfs: scrub: convert comma to semicolon

Zhang Zekun (1):
      [f6225eebd76f] xfs: Remove empty declartion in header file

Code Diffstat:

 MAINTAINERS                   |   2 +-
 fs/xfs/libxfs/xfs_alloc.c     |   7 +-
 fs/xfs/libxfs/xfs_alloc.h     |   4 +-
 fs/xfs/libxfs/xfs_attr.c      | 190 ++++++++++++++++++------------------------
 fs/xfs/libxfs/xfs_attr_leaf.c |  40 +++++----
 fs/xfs/libxfs/xfs_attr_leaf.h |   2 +-
 fs/xfs/libxfs/xfs_bmap.c      | 140 ++++++++++---------------------
 fs/xfs/libxfs/xfs_da_btree.c  |   5 +-
 fs/xfs/scrub/ialloc_repair.c  |   4 +-
 fs/xfs/xfs_icache.c           |  37 ++++----
 fs/xfs/xfs_log.h              |   2 -
 fs/xfs/xfs_log_cil.c          |  11 +--
 fs/xfs/xfs_log_recover.c      |   2 +-
 fs/xfs/xfs_reflink.c          |   3 +
 fs/xfs/xfs_reflink.h          |  19 +++++
 15 files changed, 207 insertions(+), 261 deletions(-)
