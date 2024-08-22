Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099BF17E006
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 23:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371033; cv=none; b=h0pxIhkygscSqwFtH0hKFSvG0e39hL/f27DzH/Zj0pn166AJvd0ZunQLlNbPkaYZ159Cxsx9OfIvYfckZ4JLriu7QtIQ+UmaknyNuDnMIxOOzSYB0fH0VYNxA6saT7WQJw8rlK53cXB+8YGrekAYM3WBMdINi+8Ku0wPO1DimAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371033; c=relaxed/simple;
	bh=iuRnIyjWNmQw6jGqLIlvEaxp6CZ34Auy71vVm3eZfGM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IBeO4MJClsJHcGgllIsp+CjF7ZTD5OM2y7xuVLiLkXUNjGw3FV0Y/y9fgFZjIKW6rdTJatwv6fkqzAHw4d2HLwdDf1s2756AIyUXuf8XLUzvxUHADjME5GKLKgDwEOjDBQGzSsMM8CkrGnIrhWF0lfHUMPeT1yvoDuJZLIolcZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iubqQPab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iubqQPab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C08C32782;
	Thu, 22 Aug 2024 23:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371032;
	bh=iuRnIyjWNmQw6jGqLIlvEaxp6CZ34Auy71vVm3eZfGM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iubqQPabtyJN74PmWECAkk4xaURhvEFSu49RQ9rL03l3BVKkBHa9Zl60B1AzDuWDQ
	 drhsDG+LoQM+h+36MSrzQtenoEcoQ05gKsFGVSLLk4ngx4C7ZU+2KA7RP8LjxCaTc6
	 b6aGJK3LkZDIjQinGxEtzWqqHgl7hXtnVdzqWEsFNbXtkcpSkhTPOA8i+q2DgIpbN3
	 +DuTrRlVcp58Fl06EPgsxm6FgEOTHlza2FU+68mBstNJA3TCnovRxjPMEQZVfrDhPJ
	 bVeZ5FVm+FN2G4ORRRREPllsV8NvQY+EX9jp8SVZmytQxpKCvrEeIu2NW8rgd1aj9m
	 vmoRlef3EUS7g==
Date: Thu, 22 Aug 2024 16:57:12 -0700
Subject: [PATCHSET v4.0 04/10] xfs: metadata inode directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
In-Reply-To: <20240822235230.GJ6043@frogsfrogsfrogs>
References: <20240822235230.GJ6043@frogsfrogsfrogs>
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
Commits in this patchset:
 * xfs: define the on-disk format for the metadir feature
 * xfs: refactor loading quota inodes in the regular case
 * xfs: iget for metadata inodes
 * xfs: load metadata directory root at mount time
 * xfs: enforce metadata inode flag
 * xfs: read and write metadata inode directory tree
 * xfs: disable the agi rotor for metadata inodes
 * xfs: hide metadata inodes from everyone because they are special
 * xfs: advertise metadata directory feature
 * xfs: allow bulkstat to return metadata directories
 * xfs: don't count metadata directory files to quota
 * xfs: mark quota inodes as metadata files
 * xfs: adjust xfs_bmap_add_attrfork for metadir
 * xfs: record health problems with the metadata directory
 * xfs: refactor directory tree root predicates
 * xfs: do not count metadata directory files when doing online quotacheck
 * xfs: don't fail repairs on metadata files with no attr fork
 * xfs: metadata files can have xattrs if metadir is enabled
 * xfs: adjust parent pointer scrubber for sb-rooted metadata files
 * xfs: fix di_metatype field of inodes that won't load
 * xfs: scrub metadata directories
 * xfs: check the metadata directory inumber in superblocks
 * xfs: move repair temporary files to the metadata directory tree
 * xfs: check metadata directory file path connectivity
 * xfs: confirm dotdot target before replacing it during a repair
 * xfs: repair metadata directory file path connectivity
---
 fs/xfs/Makefile                 |    5 
 fs/xfs/libxfs/xfs_attr.c        |    5 
 fs/xfs/libxfs/xfs_bmap.c        |    5 
 fs/xfs/libxfs/xfs_format.h      |   81 +++++-
 fs/xfs/libxfs/xfs_fs.h          |   26 ++
 fs/xfs/libxfs/xfs_health.h      |    6 
 fs/xfs/libxfs/xfs_ialloc.c      |   58 +++-
 fs/xfs/libxfs/xfs_inode_buf.c   |   83 ++++++
 fs/xfs/libxfs/xfs_inode_buf.h   |    3 
 fs/xfs/libxfs/xfs_inode_util.c  |    2 
 fs/xfs/libxfs/xfs_log_format.h  |    2 
 fs/xfs/libxfs/xfs_metadir.c     |  481 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_metadir.h     |   47 ++++
 fs/xfs/libxfs/xfs_metafile.c    |   52 ++++
 fs/xfs/libxfs/xfs_metafile.h    |   31 ++
 fs/xfs/libxfs/xfs_ondisk.h      |    2 
 fs/xfs/libxfs/xfs_sb.c          |   12 +
 fs/xfs/scrub/agheader.c         |    5 
 fs/xfs/scrub/common.c           |   65 ++++-
 fs/xfs/scrub/common.h           |    5 
 fs/xfs/scrub/dir.c              |   10 +
 fs/xfs/scrub/dir_repair.c       |   20 +
 fs/xfs/scrub/dirtree.c          |   32 ++
 fs/xfs/scrub/dirtree.h          |   12 -
 fs/xfs/scrub/findparent.c       |   28 ++
 fs/xfs/scrub/health.c           |    1 
 fs/xfs/scrub/inode.c            |   35 ++-
 fs/xfs/scrub/inode_repair.c     |   34 ++-
 fs/xfs/scrub/metapath.c         |  521 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/nlinks.c           |    4 
 fs/xfs/scrub/nlinks_repair.c    |    4 
 fs/xfs/scrub/orphanage.c        |    4 
 fs/xfs/scrub/parent.c           |   39 ++-
 fs/xfs/scrub/parent_repair.c    |   37 ++-
 fs/xfs/scrub/quotacheck.c       |    7 -
 fs/xfs/scrub/repair.c           |   22 +-
 fs/xfs/scrub/repair.h           |    3 
 fs/xfs/scrub/scrub.c            |    9 +
 fs/xfs/scrub/scrub.h            |    2 
 fs/xfs/scrub/stats.c            |    1 
 fs/xfs/scrub/tempfile.c         |  105 ++++++++
 fs/xfs/scrub/tempfile.h         |    3 
 fs/xfs/scrub/trace.c            |    1 
 fs/xfs/scrub/trace.h            |   42 +++
 fs/xfs/xfs_dquot.c              |    1 
 fs/xfs/xfs_health.c             |    2 
 fs/xfs/xfs_icache.c             |   73 +++++
 fs/xfs/xfs_inode.c              |   13 +
 fs/xfs/xfs_inode.h              |   14 +
 fs/xfs/xfs_inode_item.c         |    7 -
 fs/xfs/xfs_inode_item_recover.c |    5 
 fs/xfs/xfs_ioctl.c              |    7 +
 fs/xfs/xfs_iops.c               |   15 +
 fs/xfs/xfs_itable.c             |   33 ++
 fs/xfs/xfs_itable.h             |    3 
 fs/xfs/xfs_mount.c              |   31 ++
 fs/xfs/xfs_mount.h              |    3 
 fs/xfs/xfs_qm.c                 |   80 +++++-
 fs/xfs/xfs_qm.h                 |    3 
 fs/xfs/xfs_qm_syscalls.c        |   13 -
 fs/xfs/xfs_quota.h              |    5 
 fs/xfs/xfs_quotaops.c           |   53 ++--
 fs/xfs/xfs_rtalloc.c            |   38 ++-
 fs/xfs/xfs_super.c              |    4 
 fs/xfs/xfs_trace.c              |    2 
 fs/xfs/xfs_trace.h              |  102 ++++++++
 fs/xfs/xfs_trans_dquot.c        |    6 
 67 files changed, 2288 insertions(+), 177 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_metadir.c
 create mode 100644 fs/xfs/libxfs/xfs_metadir.h
 create mode 100644 fs/xfs/libxfs/xfs_metafile.c
 create mode 100644 fs/xfs/libxfs/xfs_metafile.h
 create mode 100644 fs/xfs/scrub/metapath.c

