Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C236D84FCF
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816385; cv=none; b=l9iKp5z/zDCc08YzwrHPplIaq0GMvHJmHN6UzfyCds7uIC3LWBfjjmfE8zMBMDHEOBPgzgKVegTF114ZfLU4xnBfx0bflTODarhFcBWlK+ezSiFlN7iviscG3SkJ23gmTKcN5eFqX/nhhCVTwuchXElicsG5KlXCHal2IK5ypqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816385; c=relaxed/simple;
	bh=nvBDv/M7YU+BA0SAhAk0amE3r0KFHMNISy0uEl7kBWk=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=ZU1c/jJIQ/kmhXQCGd7xL66a1aaP2E4PrVDsXnoYmWgNUeehIU0eds55+hgPQPAPAO0wY7kC+8/F0cCP+UyIP4CHFMZogTvRhDWL4dJg2yZboU2EfuoLicu9hinJnTIhQwsny2s1C8KJl+p7BVC+UT+T8Jnvh8WzD6yPE+XKL1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a60CoT0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a60CoT0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD34C433F1;
	Thu,  1 Feb 2024 19:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816385;
	bh=nvBDv/M7YU+BA0SAhAk0amE3r0KFHMNISy0uEl7kBWk=;
	h=Date:Subject:From:To:Cc:From;
	b=a60CoT0ULVpyCq44H1wn1ZBH+OOJ+lobQ08aRT/YHCy+jK5Y2angyCDpcGpTQJ7od
	 BJBrI9xaBui2+KA3wTdihieXaiirzml2JA57g/OYVkrLrPaQueqgBoY+NWmyPfpbtp
	 u3j0N3kLe+gLjkxU2qDsPSFUOYv2MzfCbiofheC68iZNf2Q+FaR+wztHtkSTYoK33q
	 LAhDbaJPj6eVO1EQGaM7P6BB+o4unDFGxUuLiDVh7TlM1R/r9iQsEZHK162XMQeURJ
	 0EifleGe7KsE/Ekckllwrca2U9/zRy83Tg5jWDJvuHmiM09VMAeI7gffmLJFiH8aFb
	 Jgr7gjDbljLgA==
Date: Thu, 01 Feb 2024 11:39:44 -0800
Subject: [PATCHSET v29.2 7/8] xfs: online repair of rmap btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681337409.1608576.2345800520406509462.stgit@frogsfrogsfrogs>
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

We have now constructed the four tools that we need to scan the
filesystem looking for reverse mappings: an inode scanner, hooks to
receive live updates from other writer threads, the ability to construct
btrees in memory, and a btree bulk loader.

This series glues those three together, enabling us to scan the
filesystem for mappings and keep it up to date while other writers run,
and then commit the new btree to disk atomically.

To reduce the size of each patch, the functionality is left disabled
until the end of the series and broken up into three patches: one to
create the mechanics of scanning the filesystem, a second to transition
to in-memory btrees, and a third to set up the live hooks.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-rmap-btree

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-rmap-btree

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-rmap-btree
---
Commits in this patchset:
 * xfs: create a helper to decide if a file mapping targets the rt volume
 * xfs: create agblock bitmap helper to count the number of set regions
 * xfs: repair the rmapbt
 * xfs: create a shadow rmap btree during rmap repair
 * xfs: hook live rmap operations during a repair operation
---
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_ag.c         |    1 
 fs/xfs/libxfs/xfs_ag.h         |    4 
 fs/xfs/libxfs/xfs_bmap.c       |   49 +
 fs/xfs/libxfs/xfs_bmap.h       |    8 
 fs/xfs/libxfs/xfs_inode_fork.c |    9 
 fs/xfs/libxfs/xfs_inode_fork.h |    1 
 fs/xfs/libxfs/xfs_rmap.c       |  190 +++-
 fs/xfs/libxfs/xfs_rmap.h       |   30 +
 fs/xfs/libxfs/xfs_rmap_btree.c |  163 ++++
 fs/xfs/libxfs/xfs_rmap_btree.h |    6 
 fs/xfs/libxfs/xfs_shared.h     |   10 
 fs/xfs/scrub/agb_bitmap.h      |    5 
 fs/xfs/scrub/bitmap.c          |   14 
 fs/xfs/scrub/bitmap.h          |    2 
 fs/xfs/scrub/bmap.c            |    2 
 fs/xfs/scrub/common.c          |    5 
 fs/xfs/scrub/common.h          |    1 
 fs/xfs/scrub/newbt.c           |   12 
 fs/xfs/scrub/newbt.h           |    7 
 fs/xfs/scrub/reap.c            |    2 
 fs/xfs/scrub/repair.c          |   59 +
 fs/xfs/scrub/repair.h          |   12 
 fs/xfs/scrub/rmap.c            |   11 
 fs/xfs/scrub/rmap_repair.c     | 1697 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c           |    6 
 fs/xfs/scrub/scrub.h           |    4 
 fs/xfs/scrub/trace.c           |    1 
 fs/xfs/scrub/trace.h           |   80 ++
 fs/xfs/xfs_stats.c             |    3 
 fs/xfs/xfs_stats.h             |    1 
 31 files changed, 2326 insertions(+), 70 deletions(-)
 create mode 100644 fs/xfs/scrub/rmap_repair.c

