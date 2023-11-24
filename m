Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A33A3DB80
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JpzT9r4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EEA9C433C8;
	Fri, 24 Nov 2023 23:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700869567;
	bh=SkPLfFSiTRC6ctIiSSsiUry48q2JLHj1QqQQRJcNEaY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JpzT9r4rEkuF7iKyX07BAaMRhUs9Ggc3dtXlFw55+iuTyQfyzxrlx0OV6nQJmNHYI
	 Q/+p68xFWu6mz0YH/wmOZ1/mFxXrx357ZItxLdX1ecCZ3L/l1Ul3PgBg2qGK0npucU
	 45Mhaq4yJUngi2xmJzdzWkbsQiaAq/NjszT/Xb9orHtJGRC2Q0EH3B90bx5oUa4QaV
	 gwVRx0UcG7uoLecnA+/I4lRFEndE93ANQzGa81Db1jDJhzdmE3PawRaqWltiXWdxr1
	 NzvZTo4lfIddgfMJM3HLlNLN2fOtuo9Z2fTVrXCOPHVX0zNsuo3QvRnAu8XEeuqxmy
	 4B6zOsXuDybGw==
Date: Fri, 24 Nov 2023 15:46:07 -0800
Subject: [PATCHSET v28.0 0/5] xfs: online repair of file fork mappings
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086927899.2771366.12096620230080096884.stgit@frogsfrogsfrogs>
In-Reply-To: <20231124233940.GK36190@frogsfrogsfrogs>
References: <20231124233940.GK36190@frogsfrogsfrogs>
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
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-file-mappings

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-file-mappings

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-file-mappings
---
 fs/xfs/Makefile                   |    2 
 fs/xfs/libxfs/xfs_bmap_btree.c    |  119 ++++-
 fs/xfs/libxfs/xfs_bmap_btree.h    |    5 
 fs/xfs/libxfs/xfs_btree_staging.c |   11 
 fs/xfs/libxfs/xfs_btree_staging.h |    2 
 fs/xfs/libxfs/xfs_iext_tree.c     |   23 +
 fs/xfs/libxfs/xfs_inode_fork.c    |    1 
 fs/xfs/libxfs/xfs_inode_fork.h    |    3 
 fs/xfs/libxfs/xfs_refcount.c      |   41 ++
 fs/xfs/libxfs/xfs_refcount.h      |   10 
 fs/xfs/scrub/bitmap.h             |   56 ++
 fs/xfs/scrub/bmap.c               |   18 +
 fs/xfs/scrub/bmap_repair.c        |  846 +++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h             |    6 
 fs/xfs/scrub/cow_repair.c         |  612 +++++++++++++++++++++++++++
 fs/xfs/scrub/reap.c               |  152 ++++++-
 fs/xfs/scrub/reap.h               |    2 
 fs/xfs/scrub/repair.c             |   50 ++
 fs/xfs/scrub/repair.h             |   11 
 fs/xfs/scrub/scrub.c              |   20 -
 fs/xfs/scrub/trace.h              |  118 +++++
 fs/xfs/xfs_trans.c                |   95 ++++
 fs/xfs/xfs_trans.h                |    4 
 23 files changed, 2155 insertions(+), 52 deletions(-)
 create mode 100644 fs/xfs/scrub/bmap_repair.c
 create mode 100644 fs/xfs/scrub/cow_repair.c

