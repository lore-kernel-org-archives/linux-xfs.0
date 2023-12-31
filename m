Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8604DB65D
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GHT6LT9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E1CC433C8;
	Sun, 31 Dec 2023 19:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704050862;
	bh=eLSuwE+wNL+fCA1Oa3n39NyQBrZJjzDlST7UacFRZLc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GHT6LT9kBr8bSjsByLrKh5nxF96/su2rDZVubqV/HY6kaxfyXZvMgBMeZaAXtyTin
	 GMPz2N+7biDbEJW6gfRANUJbnIzgeYNCWHe81+eEeqq2ea6oextieQbLgnZ4Iao8NS
	 TR/OKfQLvJDw4raGENALXbRasvKPLxmfjX+NDeTtEMbxOjpnGRWW0NH4e7L6GhOjJr
	 lYLhmFJHLjnux1Uz9SSVIlKeULhBrgAlFpB7CsdBeWon0LANAO+JR7pnYiP7JriTSf
	 e40VbS2/3xtbv8mtFOWCpKxUYKuGWPWOiI0+i7UKRx3dNJHNLMfBrCiLA+ubb4/voq
	 XpNYdbapr5tAQ==
Date: Sun, 31 Dec 2023 11:27:41 -0800
Subject: [PATCHSET v29.0 09/28] xfs: online repair of rmap btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404830071.1749125.16096260756312609957.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_ag.c         |    1 
 fs/xfs/libxfs/xfs_ag.h         |    3 
 fs/xfs/libxfs/xfs_bmap.c       |   49 +
 fs/xfs/libxfs/xfs_bmap.h       |    8 
 fs/xfs/libxfs/xfs_inode_fork.c |    9 
 fs/xfs/libxfs/xfs_inode_fork.h |    1 
 fs/xfs/libxfs/xfs_rmap.c       |  190 +++-
 fs/xfs/libxfs/xfs_rmap.h       |   30 +
 fs/xfs/libxfs/xfs_rmap_btree.c |  136 +++
 fs/xfs/libxfs/xfs_rmap_btree.h |    9 
 fs/xfs/scrub/agb_bitmap.h      |    5 
 fs/xfs/scrub/bitmap.c          |   14 
 fs/xfs/scrub/bitmap.h          |    2 
 fs/xfs/scrub/bmap.c            |    2 
 fs/xfs/scrub/common.c          |    7 
 fs/xfs/scrub/common.h          |    1 
 fs/xfs/scrub/newbt.c           |   12 
 fs/xfs/scrub/newbt.h           |    7 
 fs/xfs/scrub/reap.c            |    2 
 fs/xfs/scrub/repair.c          |   59 +
 fs/xfs/scrub/repair.h          |   12 
 fs/xfs/scrub/rmap.c            |   11 
 fs/xfs/scrub/rmap_repair.c     | 1726 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c           |    6 
 fs/xfs/scrub/scrub.h           |    4 
 fs/xfs/scrub/trace.c           |    1 
 fs/xfs/scrub/trace.h           |   80 ++
 28 files changed, 2319 insertions(+), 69 deletions(-)
 create mode 100644 fs/xfs/scrub/rmap_repair.c

