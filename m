Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA63DB65D
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="djUCkLf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD910C433C7;
	Sun, 31 Dec 2023 19:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051300;
	bh=CaPw5w8zhtoUaSY8TvPWKalQ3GFn6bl9kp+lyhRZt5M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=djUCkLf7oGG7jONk5NWYPHeJsh+06i4RrmaX5kzkcPquFVEa7Vb86rsbu/Zv9jBrq
	 +EUbYv8LlLjbf4ztI5aYao/vgEcJEuPWrtmZuWfX1+do4juoXg8V5jwXsAO2HEoRWv
	 EKioNj0DPiTz/Tywfh9hZAldNdLg6EIP57FFW8QSoch7XAVONFyBauGiIDxw/FND7U
	 PFLAvNHUHHjwM9pmLRbk4xUoIp/mf2/KZZQturqrPV5dEJ+DZhIcU40DO1uYSYfJYB
	 Lq3LyRpHE4TP6xfStFzi1bwDsJMzX7CNySHwutVKLSg6uFO5o5tRBDNQVpyuYv+n3Z
	 B05IhikEaIuNQ==
Date: Sun, 31 Dec 2023 11:35:00 -0800
Subject: [PATCHSET v2.0 02/15] xfs: metadata inode directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
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

This series delivers a new feature -- metadata inode directories.  This
is a separate directory tree (rooted in the superblock) that contains
only inodes that contain filesystem metadata.  Different metadata
objects can be looked up with regular paths.

We start by creating xfs_imeta_* functions to mediate access to metadata
inode pointers.  This enables the imeta code to abstract inode pointers,
whether they're the classic five in the superblock, or the much more
complex directory tree.  All current users of metadata inodes (rt+quota)
are converted to use the boilerplate code.

Next, we define the metadir on-disk format, which consists of marking
inodes with a new iflag that says they're metadata.  This we use to
prevent bulkstat and friends from ever getting their hands on fs
metadata.

Finally, we implement metadir operations so that clients can create,
delete, zap, and look up metadata inodes by path.  Beware that much of
this code is only lightly used, because the five current users of
metadata inodes don't tend to change them very often.  This is likely to
change if and when the subvolume and multiple-rt-volume features get
written/merged/etc.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadir

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadir

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=metadir
---
 fs/xfs/Makefile                |    3 
 fs/xfs/libxfs/xfs_attr.c       |    5 
 fs/xfs/libxfs/xfs_bmap.c       |    5 
 fs/xfs/libxfs/xfs_format.h     |   72 ++-
 fs/xfs/libxfs/xfs_fs.h         |   29 +
 fs/xfs/libxfs/xfs_health.h     |    6 
 fs/xfs/libxfs/xfs_ialloc.c     |   56 +-
 fs/xfs/libxfs/xfs_ialloc.h     |    2 
 fs/xfs/libxfs/xfs_imeta.c      | 1077 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_imeta.h      |  110 ++++
 fs/xfs/libxfs/xfs_inode_buf.c  |   73 +++
 fs/xfs/libxfs/xfs_inode_buf.h  |    3 
 fs/xfs/libxfs/xfs_inode_util.c |    5 
 fs/xfs/libxfs/xfs_ondisk.h     |    1 
 fs/xfs/libxfs/xfs_sb.c         |   35 +
 fs/xfs/libxfs/xfs_trans_resv.c |  106 ++++
 fs/xfs/libxfs/xfs_trans_resv.h |    3 
 fs/xfs/libxfs/xfs_types.c      |    7 
 fs/xfs/scrub/agheader.c        |   29 +
 fs/xfs/scrub/common.c          |   23 +
 fs/xfs/scrub/common.h          |    1 
 fs/xfs/scrub/dir.c             |    8 
 fs/xfs/scrub/dir_repair.c      |    8 
 fs/xfs/scrub/dirtree.c         |   22 +
 fs/xfs/scrub/dirtree.h         |    2 
 fs/xfs/scrub/findparent.c      |   37 +
 fs/xfs/scrub/health.c          |    1 
 fs/xfs/scrub/inode.c           |   25 +
 fs/xfs/scrub/inode_repair.c    |   18 +
 fs/xfs/scrub/metapath.c        |  617 +++++++++++++++++++++++
 fs/xfs/scrub/nlinks.c          |   12 
 fs/xfs/scrub/nlinks_repair.c   |    2 
 fs/xfs/scrub/orphanage.c       |    2 
 fs/xfs/scrub/parent.c          |   30 +
 fs/xfs/scrub/parent_repair.c   |    2 
 fs/xfs/scrub/quotacheck.c      |    7 
 fs/xfs/scrub/repair.c          |    8 
 fs/xfs/scrub/repair.h          |    3 
 fs/xfs/scrub/scrub.c           |    9 
 fs/xfs/scrub/scrub.h           |    2 
 fs/xfs/scrub/stats.c           |    1 
 fs/xfs/scrub/tempfile.c        |  107 ++++
 fs/xfs/scrub/tempfile.h        |    3 
 fs/xfs/scrub/trace.c           |    1 
 fs/xfs/scrub/trace.h           |   51 ++
 fs/xfs/xfs_dquot.c             |    1 
 fs/xfs/xfs_health.c            |    2 
 fs/xfs/xfs_icache.c            |   43 ++
 fs/xfs/xfs_imeta_utils.c       |  341 +++++++++++++
 fs/xfs/xfs_imeta_utils.h       |   27 +
 fs/xfs/xfs_inode.c             |   28 +
 fs/xfs/xfs_inode.h             |   16 +
 fs/xfs/xfs_ioctl.c             |    7 
 fs/xfs/xfs_iops.c              |   34 +
 fs/xfs/xfs_itable.c            |   34 +
 fs/xfs/xfs_itable.h            |    3 
 fs/xfs/xfs_mount.c             |   48 ++
 fs/xfs/xfs_mount.h             |    3 
 fs/xfs/xfs_qm.c                |  245 ++++++---
 fs/xfs/xfs_qm_syscalls.c       |    9 
 fs/xfs/xfs_quota.h             |    5 
 fs/xfs/xfs_rtalloc.c           |   46 +-
 fs/xfs/xfs_super.c             |    4 
 fs/xfs/xfs_symlink.c           |    2 
 fs/xfs/xfs_trace.c             |    1 
 fs/xfs/xfs_trace.h             |  139 +++++
 fs/xfs/xfs_trans_dquot.c       |    6 
 67 files changed, 3466 insertions(+), 207 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_imeta.c
 create mode 100644 fs/xfs/libxfs/xfs_imeta.h
 create mode 100644 fs/xfs/scrub/metapath.c
 create mode 100644 fs/xfs/xfs_imeta_utils.c
 create mode 100644 fs/xfs/xfs_imeta_utils.h

