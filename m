Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B948B65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fXoX1NqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59221C433C8;
	Sun, 31 Dec 2023 19:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051566;
	bh=UQHN/GK96zWnIvTvZsu3yIs1Txshl8QDn/5QEu9wu5w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fXoX1NqEvBDsT6h+jFOFNmKiHxLxVS1zVLz5Cx1d1KitMBsFaC5KodadXldfNFTdl
	 oh0X8mP0rw0YQv29FHSHLAuXSKZm/OxE37o1OcRqJZXV0/0itqLHvmFuJ9AH/cvKDc
	 GGdwcT74+j6HRbyQCBH18U8LeMTCGkF9i1arSLla0shl9uCsB6BO4dFH2q/07NzjA1
	 zV0ATJJJxf/iZbOQTZ6BBNhrbE10Hb4DsLOLZRDorN6GtNpfYzPqnkNsfm2Hl+LuTK
	 BA6j0J+1n0YBNqJIsGpwt48aMtpfi3ZIW966gZA36kRJmVMkT6icCDWK+f09HlMcwa
	 7cg4XjS0S7uQg==
Date: Sun, 31 Dec 2023 11:39:25 -0800
Subject: [PATCHSET 4/5] xfs: defragment free space
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404855508.1769925.12296060252141719128.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182553.GV361584@frogsfrogsfrogs>
References: <20231231182553.GV361584@frogsfrogsfrogs>
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

These patches contain experimental code to enable userspace to defragment
the free space in a filesystem.  Two purposes are imagined for this
functionality: clearing space at the end of a filesystem before
shrinking it, and clearing free space in anticipation of making a large
allocation.

The first patch adds a new fallocate mode that allows userspace to
allocate free space from the filesystem into a file.  The goal here is
to allow the filesystem shrink process to prevent allocation from a
certain part of the filesystem while a free space defragmenter evacuates
all the files from the doomed part of the filesystem.

The second patch amends the online repair system to allow the sysadmin
to forcibly rebuild metadata structures, even if they're not corrupt.
Without adding an ioctl to move metadata btree blocks, this is the only
way to dislodge metadata.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=defrag-freespace

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=defrag-freespace

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=defrag-freespace
---
 fs/xfs/libxfs/xfs_alloc.c      |   88 +++++++++++
 fs/xfs/libxfs/xfs_alloc.h      |    3 
 fs/xfs/libxfs/xfs_bmap.c       |  150 +++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h       |    3 
 fs/xfs/libxfs/xfs_fs.h         |    1 
 fs/xfs/libxfs/xfs_fs_staging.h |   15 ++
 fs/xfs/xfs_bmap_util.c         |  319 +++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_bmap_util.h         |    3 
 fs/xfs/xfs_file.c              |   79 ++++++++++
 fs/xfs/xfs_file.h              |    2 
 fs/xfs/xfs_ioctl.c             |   68 +++++++++
 fs/xfs/xfs_rtalloc.c           |   52 +++++++
 fs/xfs/xfs_rtalloc.h           |   12 +-
 fs/xfs/xfs_trace.h             |   72 ++++++++-
 14 files changed, 856 insertions(+), 11 deletions(-)

