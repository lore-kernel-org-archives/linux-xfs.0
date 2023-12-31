Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659A8B64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FfwXV0uJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B29C433C8;
	Sun, 31 Dec 2023 19:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051285;
	bh=WX63kzQFi+PQfPu03VUS87+tLmae1jnviygjpWzzupY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FfwXV0uJEeILynmccqpiXx+wph3FU06ixmAhX/r4R8kfdchVktFccjIvrTC886f8V
	 a0a/N0KdtRWSiXW6W6Mf/ocFpPvOvMmwR+3Vg/vbCZ+OEQXb4Y3Hu1yfN5ACwYOnx1
	 14lcuEiph+XmIbJfmw12HmBopex44+n2xWiaMeTUZ/OudE5FYK56aZFcC8llYHXggv
	 GtT6hWvRM3/sX35VpicHtRGIJQehMhCW/Q6/O1yqRS7pELBSDTgUuOTTzbUJiOzc3i
	 X6esJqkubYi8evCpKsTmBC+Cw5BqrFp3yme+xP+Z/RkVclc4QLoWEkXMYJZuhROMaI
	 FLyY5pWnVDxdw==
Date: Sun, 31 Dec 2023 11:34:44 -0800
Subject: [PATCHSET v2.0 01/15] xfs: hoist inode operations to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182323.GU361584@frogsfrogsfrogs>
References: <20231231182323.GU361584@frogsfrogsfrogs>
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
 fs/xfs/Makefile                 |    1 
 fs/xfs/libxfs/xfs_bmap.c        |   42 +
 fs/xfs/libxfs/xfs_bmap.h        |    3 
 fs/xfs/libxfs/xfs_dir2.c        |  636 +++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h        |   48 +
 fs/xfs/libxfs/xfs_ialloc.c      |   15 
 fs/xfs/libxfs/xfs_inode_util.c  |  723 +++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h  |   71 ++
 fs/xfs/libxfs/xfs_shared.h      |    7 
 fs/xfs/libxfs/xfs_trans_inode.c |    2 
 fs/xfs/scrub/common.c           |    1 
 fs/xfs/scrub/tempfile.c         |   20 -
 fs/xfs/xfs_inode.c              | 1486 +++++----------------------------------
 fs/xfs/xfs_inode.h              |   75 +-
 fs/xfs/xfs_ioctl.c              |   60 --
 fs/xfs/xfs_iops.c               |   47 +
 fs/xfs/xfs_linux.h              |    2 
 fs/xfs/xfs_qm.c                 |    9 
 fs/xfs/xfs_reflink.h            |   10 
 fs/xfs/xfs_symlink.c            |   63 +-
 fs/xfs/xfs_trans.h              |    1 
 21 files changed, 1830 insertions(+), 1492 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_inode_util.c
 create mode 100644 fs/xfs/libxfs/xfs_inode_util.h

