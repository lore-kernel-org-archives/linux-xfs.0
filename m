Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974076FE16
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 22:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924242; cv=none; b=Zr9RbrbX6CB96gyNAhSrMYPwJDOASbxoDnwdC4TCcvlMFMBChf0CtlYnynAHVIcCNaZAPocZ9B936GNorM6z6eWjIdasgDvcvO4lyIKI4Fs4+hr2OpMzbqGVEHZiIEQZpzWWpPuS2sqPiEy0J6OrCOA+UznW759MwRs7sNnM314=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924242; c=relaxed/simple;
	bh=OK4EWf0CLUPGywIlxiDgvXhNqcLUAP/EsRiaBJek9gg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UWu0euTn1HkFkR+jF0HHJav4up9IDXYM3Fugcz7sEUSBtn7InKFxvkrxAKX2RtLItnxZQhixA2De2oOR9a2p5N34f3tPPAX1IfV6GT/TTDn9ocENZfKQ049dG4D9/pa7Aqd4NlI6+8VVsqbq0wUDPIQ7Ohhr2JaN722dwdcpgkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QfIaETDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QfIaETDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B09FC2BD10;
	Thu, 20 Jun 2024 22:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924242;
	bh=OK4EWf0CLUPGywIlxiDgvXhNqcLUAP/EsRiaBJek9gg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QfIaETDxM7F2CJeH3qTOtG86rMFNwxMIULNb47LBsF6JUnk4lbHGsDOk8kxL3uSlQ
	 owf/ym6QpF/ib72NQuwDoajMJC/xFzAYsMjZbXCjR4sgANFm7Wt7NMPnEo393GRV9u
	 3Gan+NJZSLGDPpMoT5vUmuY7EuHUfilJDiNpCq2J2q8C1ujQxqPC//E1L+dLX4Zy/M
	 QdyVn58eRpwR2djcQUWCtmC8jNNsa//tTOTNnqKUY69+5bCpLuItCxV13I5Del7lm1
	 MwvocMinxZxPiFbctJTysPQdjyTx2lQId8kfQX7DJCrRxLLTsOFE3Ik1cRD6LxdvLH
	 fg6lCPId0cVOg==
Date: Thu, 20 Jun 2024 15:57:21 -0700
Subject: [PATCHSET v3.0 1/5] xfs: hoist inode operations to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
In-Reply-To: <20240620225033.GD103020@frogsfrogsfrogs>
References: <20240620225033.GD103020@frogsfrogsfrogs>
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

This series hoists inode creation, renaming, and deletion operations to
libxfs in anticipation of the metadata inode directory feature, which
maintains a directory tree of metadata inodes.  This will be necessary
for further enhancements to the realtime feature, subvolume support.

There aren't supposed to be any functional changes in this intense
refactoring -- we just split the functions into pieces that are generic
and pieces that are specific to libxfs clients.  As a bonus, we can
remove various open-coded pieces of mkfs.xfs and xfs_repair when this
series gets to xfsprogs.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inode-refactor

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=inode-refactor
---
Commits in this patchset:
 * xfs: use consistent uid/gid when grabbing dquots for inodes
 * xfs: move inode copy-on-write predicates to xfs_inode.[ch]
 * xfs: hoist extent size helpers to libxfs
 * xfs: hoist inode flag conversion functions to libxfs
 * xfs: hoist project id get/set functions to libxfs
 * xfs: pack icreate initialization parameters into a separate structure
 * xfs: implement atime updates in xfs_trans_ichgtime
 * xfs: use xfs_trans_ichgtime to set times when allocating inode
 * xfs: split new inode creation into two pieces
 * xfs: hoist new inode initialization functions to libxfs
 * xfs: push xfs_icreate_args creation out of xfs_create*
 * xfs: wrap inode creation dqalloc calls
 * xfs: hoist xfs_iunlink to libxfs
 * xfs: hoist xfs_{bump,drop}link to libxfs
 * xfs: separate the icreate logic around INIT_XATTRS
 * xfs: create libxfs helper to link a new inode into a directory
 * xfs: create libxfs helper to link an existing inode into a directory
 * xfs: hoist inode free function to libxfs
 * xfs: create libxfs helper to remove an existing inode/name from a directory
 * xfs: create libxfs helper to exchange two directory entries
 * xfs: create libxfs helper to rename two directory entries
 * xfs: move dirent update hooks to xfs_dir2.c
 * xfs: get rid of trivial rename helpers
 * xfs: don't use the incore struct xfs_sb for offsets into struct xfs_dsb
---
 fs/xfs/Makefile                 |    1 
 fs/xfs/libxfs/xfs_bmap.c        |   43 +
 fs/xfs/libxfs/xfs_bmap.h        |    3 
 fs/xfs/libxfs/xfs_dir2.c        |  661 +++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h        |   49 +
 fs/xfs/libxfs/xfs_format.h      |    9 
 fs/xfs/libxfs/xfs_ialloc.c      |   15 
 fs/xfs/libxfs/xfs_inode_util.c  |  749 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h  |   62 ++
 fs/xfs/libxfs/xfs_ondisk.h      |    1 
 fs/xfs/libxfs/xfs_shared.h      |    7 
 fs/xfs/libxfs/xfs_trans_inode.c |    2 
 fs/xfs/scrub/common.c           |    1 
 fs/xfs/scrub/tempfile.c         |   21 -
 fs/xfs/xfs_inode.c              | 1487 ++++-----------------------------------
 fs/xfs/xfs_inode.h              |   70 --
 fs/xfs/xfs_ioctl.c              |   60 --
 fs/xfs/xfs_iops.c               |   51 +
 fs/xfs/xfs_linux.h              |    2 
 fs/xfs/xfs_qm.c                 |    7 
 fs/xfs/xfs_reflink.h            |   10 
 fs/xfs/xfs_symlink.c            |   70 +-
 fs/xfs/xfs_trans.h              |    1 
 23 files changed, 1837 insertions(+), 1545 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_inode_util.c
 create mode 100644 fs/xfs/libxfs/xfs_inode_util.h

