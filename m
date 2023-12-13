Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588318184F
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ks4nh5na"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85D1C433C7;
	Wed, 13 Dec 2023 22:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702507906;
	bh=3dkcEDaZ8PDQ1DkcMpFHsRkzqhrhC3eBzdB2qBKKySM=;
	h=Date:Subject:From:To:Cc:From;
	b=ks4nh5naei5ERHTUuSTGqQc5H5Ny1OV3zP/guPVE58oJMqWg75SXppE0xXglcwM12
	 O6j2cc3OSGcZkwsjkpR80BmUy8gcS1rEVUKUTeDf8+qPjijlOvV4fl8ZvPSrqFa8Jq
	 kwnDkf9xtGwlyigr+n3C8rxkBGmfTuLZBBsn6jtwdcSXDheqFCRyXy34i2neLbSgDv
	 s9h0EAjGu7YCZCRLcuhqjab2EwGe49c1cAMrdAAdLx/w1cDIaXtXbg0aBNpRhGPtWW
	 XvFTdr7r46C6noIqjvMWTny+Co8BuczG7mjnn0JsdNrzb/LPxxbg3NIeHCAInguayw
	 mzKVAepVwYCfQ==
Date: Wed, 13 Dec 2023 14:51:46 -0800
Subject: [PATCHSET v28.2 0/5] xfs: online repair of file fork mappings
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170250783929.1399452.16224631770180304352.stgit@frogsfrogsfrogs>
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

In this series, online repair gains the ability to rebuild data and attr
fork mappings from the reverse mapping information.  It is at this point
where we reintroduce the ability to reap file extents.

Repair of CoW forks is a little different -- on disk, CoW staging
extents are owned by the refcount btree and cannot be mapped back to
individual files.  Hence we can only detect staging extents that don't
quite look right (missing reverse mappings, shared staging extents) and
replace them with fresh allocations.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-file-mappings-6.8
---
 fs/xfs/Makefile                   |    2 
 fs/xfs/libxfs/xfs_bmap_btree.c    |  121 ++++-
 fs/xfs/libxfs/xfs_bmap_btree.h    |    5 
 fs/xfs/libxfs/xfs_btree_staging.c |   11 
 fs/xfs/libxfs/xfs_btree_staging.h |    2 
 fs/xfs/libxfs/xfs_iext_tree.c     |   23 +
 fs/xfs/libxfs/xfs_inode_fork.c    |    1 
 fs/xfs/libxfs/xfs_inode_fork.h    |    3 
 fs/xfs/libxfs/xfs_refcount.c      |   41 ++
 fs/xfs/libxfs/xfs_refcount.h      |   10 
 fs/xfs/scrub/bmap.c               |   18 +
 fs/xfs/scrub/bmap_repair.c        |  858 +++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h             |    6 
 fs/xfs/scrub/cow_repair.c         |  614 ++++++++++++++++++++++++++
 fs/xfs/scrub/fsb_bitmap.h         |   37 ++
 fs/xfs/scrub/off_bitmap.h         |   37 ++
 fs/xfs/scrub/reap.c               |  153 ++++++-
 fs/xfs/scrub/reap.h               |    5 
 fs/xfs/scrub/repair.c             |   50 ++
 fs/xfs/scrub/repair.h             |   11 
 fs/xfs/scrub/scrub.c              |   20 -
 fs/xfs/scrub/trace.h              |  118 +++++
 fs/xfs/xfs_trans.c                |   62 +++
 fs/xfs/xfs_trans.h                |    4 
 24 files changed, 2160 insertions(+), 52 deletions(-)
 create mode 100644 fs/xfs/scrub/bmap_repair.c
 create mode 100644 fs/xfs/scrub/cow_repair.c
 create mode 100644 fs/xfs/scrub/fsb_bitmap.h
 create mode 100644 fs/xfs/scrub/off_bitmap.h

