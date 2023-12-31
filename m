Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852C8B64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qcdPUwaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06CE1C433C7;
	Sun, 31 Dec 2023 19:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052411;
	bh=CQnF0mUQXkwRGtaCfBQ4amVMBHWDAi4VQRgbpbpGV2Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qcdPUwaTCSq7Qpz/jEALWWEVN93X6THvpqWy/zYpOYos3p3I+h2pdHzkTKFf2p0Yr
	 fLAsatDY91v2CSVqXbfZTO3aI8ESLEqv2zzODU7uJE/HOIYPkGaM9kGDDPRDV4FD46
	 s5NrSI6xPI3XceDm7BqokBJG58aGQJyqV3T7NB/kYtv34PsQK+LULSTfjJdUayw08j
	 rDdu42l3OEmoIGCKYi/g5kZz3J/3FoA/C8ieXjwTN9ZaceRfYWbXpxMnrvguMAGeoC
	 i3wOmbXb+kKH2fbTkW+IhovUq9wIiR9BUBeDl7h68lxZsrenQuqcPWBbdn0MpKmZnp
	 z3yGBmpKMzxuw==
Date: Sun, 31 Dec 2023 11:53:30 -0800
Subject: [PATCHSET v2.0 07/17] xfsprogs: refactor btrees to support records in
 inode root
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405013189.1812545.1581948480545654103.stgit@frogsfrogsfrogs>
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

This series prepares the btree code to support realtime reverse mapping
btrees by refactoring xfs_ifork_realloc to be fed a per-btree ops
structure so that it can handle multiple types of inode-rooted btrees.
It moves on to refactoring the btree code to use the new realloc
routines and to support storing btree rcords in the inode root, because
the current bmbt code does not support this.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-ifork-records

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=btree-ifork-records
---
 db/bmap.c                   |   10 +
 db/bmap_inflate.c           |    2 
 db/bmroot.c                 |    8 -
 db/btheight.c               |   18 --
 db/check.c                  |    8 -
 db/frag.c                   |    8 -
 db/metadump.c               |   16 +-
 libxfs/xfs_alloc_btree.c    |    6 -
 libxfs/xfs_alloc_btree.h    |    3 
 libxfs/xfs_attr_leaf.c      |    8 -
 libxfs/xfs_bmap.c           |   59 +++----
 libxfs/xfs_bmap_btree.c     |   93 +++++++++-
 libxfs/xfs_bmap_btree.h     |  219 +++++++++++++++++--------
 libxfs/xfs_btree.c          |  382 +++++++++++++++++++++++++++++++++----------
 libxfs/xfs_btree.h          |    4 
 libxfs/xfs_btree_staging.c  |    4 
 libxfs/xfs_ialloc.c         |    4 
 libxfs/xfs_ialloc_btree.c   |    6 -
 libxfs/xfs_ialloc_btree.h   |    3 
 libxfs/xfs_inode_fork.c     |  163 ++++++++----------
 libxfs/xfs_inode_fork.h     |   27 +++
 libxfs/xfs_refcount_btree.c |    5 -
 libxfs/xfs_refcount_btree.h |    3 
 libxfs/xfs_rmap_btree.c     |    9 +
 libxfs/xfs_rmap_btree.h     |    3 
 libxfs/xfs_sb.c             |   16 +-
 libxfs/xfs_trans_resv.c     |    2 
 repair/bmap_repair.c        |    2 
 repair/dinode.c             |   10 +
 repair/phase5.c             |   16 +-
 repair/prefetch.c           |    8 -
 repair/scan.c               |    6 -
 32 files changed, 749 insertions(+), 382 deletions(-)

