Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD001946A5
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 21:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720042821; cv=none; b=MWhkPfH7h6ALkeLvpW71f0ePD3Y1uyFob/MJ1aH1DBSwRjBB5WSWitH9Xq31YVnKzg3svzmCUbIyY8W/jGt2mu103a4YgF0FWIjB5BBbl4X/bMYHv+HU8xxhIeiWBnuRz9rfV9TkVYYCdOJHUVwPtWNHbSiXuCZuUD8YnRxQ+ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720042821; c=relaxed/simple;
	bh=ar+YNwH49yWKGL0Rh1KunNVZA+5HOoGG42unElUfIHQ=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=b+tBVGxAEIFWxA358+TerupVlE3Fme3M0WJFvNivLnlcgCgimzBiNHVc4cWkgbxYwT3LRohEGbgrRuw6HnVogPhyppY3DwKfbPXUPDEn/Mdup2lMZ7hOCUvdjkIZDVrKur4DtK6mxTY+ZpQjpvvJ9oUXs8BBXN/a30eLiuwxp2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E+gKJp7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E+gKJp7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421BDC4AF0A;
	Wed,  3 Jul 2024 21:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720042821;
	bh=ar+YNwH49yWKGL0Rh1KunNVZA+5HOoGG42unElUfIHQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E+gKJp7kXufIhPPE8XX3CHf+ZZpnfwsPxvQlAV8q+bYEptX2AdNuVU6KjExPZ+eT7
	 cWeBYBE/vE199DbL0Z//XoDwCfewNCLk4EZdG6yOyK6+t7Q0MYmhCQ2c07lfgLA4Xn
	 OW4ZBJIn9A1Xq9cptwUh4k1Kr5WmNjJSFBqT2TT38H4N5VPXLE0fy13MzlnWin9BA2
	 Qi3TXqVUGoMSDzEDD2EbA6lxgM7FqnXTcRD3n65LWA8/87ngdswZGaxOBGQo5Zikn2
	 V1AvS4VwbVH68gVjMtFXMzw3O1PePN9Y28iHGx4lciYNMCkhWohTkk+tQBK591Jrg/
	 u4W9u4Yqr4sCg==
Date: Wed, 03 Jul 2024 14:40:20 -0700
Subject: [GIT PULL 1/4] xfs: hoist inode operations to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172004279239.3366224.8652494599159311399.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240703211310.GJ612460@frogsfrogsfrogs>
References: <20240703211310.GJ612460@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.11-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 3ba3ab1f6719287674cf77a1208944cf38ef71c7:

xfs: enable FITRIM on the realtime device (2024-07-01 09:32:29 +0530)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/inode-refactor-6.11_2024-07-02

for you to fetch changes up to ac3a0275165b4f80d9b7b516d6a8f8b308644fff:

xfs: don't use the incore struct xfs_sb for offsets into struct xfs_dsb (2024-07-02 11:37:00 -0700)

----------------------------------------------------------------
xfs: hoist inode operations to libxfs [v3.0 1/4]

This series hoists inode creation, renaming, and deletion operations to
libxfs in anticipation of the metadata inode directory feature, which
maintains a directory tree of metadata inodes.  This will be necessary
for further enhancements to the realtime feature, subvolume support.

There aren't supposed to be any functional changes in this intense
refactoring -- we just split the functions into pieces that are generic
and pieces that are specific to libxfs clients.  As a bonus, we can
remove various open-coded pieces of mkfs.xfs and xfs_repair when this
series gets to xfsprogs.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (25):
xfs: verify buffer, inode, and dquot items every tx commit
xfs: use consistent uid/gid when grabbing dquots for inodes
xfs: move inode copy-on-write predicates to xfs_inode.[ch]
xfs: hoist extent size helpers to libxfs
xfs: hoist inode flag conversion functions to libxfs
xfs: hoist project id get/set functions to libxfs
xfs: pack icreate initialization parameters into a separate structure
xfs: implement atime updates in xfs_trans_ichgtime
xfs: use xfs_trans_ichgtime to set times when allocating inode
xfs: split new inode creation into two pieces
xfs: hoist new inode initialization functions to libxfs
xfs: push xfs_icreate_args creation out of xfs_create*
xfs: wrap inode creation dqalloc calls
xfs: hoist xfs_iunlink to libxfs
xfs: hoist xfs_{bump,drop}link to libxfs
xfs: separate the icreate logic around INIT_XATTRS
xfs: create libxfs helper to link a new inode into a directory
xfs: create libxfs helper to link an existing inode into a directory
xfs: hoist inode free function to libxfs
xfs: create libxfs helper to remove an existing inode/name from a directory
xfs: create libxfs helper to exchange two directory entries
xfs: create libxfs helper to rename two directory entries
xfs: move dirent update hooks to xfs_dir2.c
xfs: get rid of trivial rename helpers
xfs: don't use the incore struct xfs_sb for offsets into struct xfs_dsb

fs/xfs/Kconfig                  |   12 +
fs/xfs/Makefile                 |    1 +
fs/xfs/libxfs/xfs_bmap.c        |   43 ++
fs/xfs/libxfs/xfs_bmap.h        |    3 +
fs/xfs/libxfs/xfs_dir2.c        |  661 ++++++++++++++++-
fs/xfs/libxfs/xfs_dir2.h        |   49 +-
fs/xfs/libxfs/xfs_format.h      |    9 +-
fs/xfs/libxfs/xfs_ialloc.c      |   15 +
fs/xfs/libxfs/xfs_inode_util.c  |  749 ++++++++++++++++++++
fs/xfs/libxfs/xfs_inode_util.h  |   62 ++
fs/xfs/libxfs/xfs_ondisk.h      |    1 +
fs/xfs/libxfs/xfs_shared.h      |    7 -
fs/xfs/libxfs/xfs_trans_inode.c |    2 +
fs/xfs/scrub/common.c           |    1 +
fs/xfs/scrub/tempfile.c         |   21 +-
fs/xfs/xfs.h                    |    4 +
fs/xfs/xfs_buf_item.c           |   32 +
fs/xfs/xfs_dquot_item.c         |   31 +
fs/xfs/xfs_inode.c              | 1487 +++++----------------------------------
fs/xfs/xfs_inode.h              |   70 +-
fs/xfs/xfs_inode_item.c         |   32 +
fs/xfs/xfs_ioctl.c              |   60 --
fs/xfs/xfs_iops.c               |   51 +-
fs/xfs/xfs_linux.h              |    2 -
fs/xfs/xfs_qm.c                 |    7 +-
fs/xfs/xfs_reflink.h            |   10 -
fs/xfs/xfs_symlink.c            |   70 +-
fs/xfs/xfs_trans.h              |    1 -
28 files changed, 1948 insertions(+), 1545 deletions(-)
create mode 100644 fs/xfs/libxfs/xfs_inode_util.c
create mode 100644 fs/xfs/libxfs/xfs_inode_util.h

