Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8660563A3
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 21:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JEisZa5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0A8C433C8;
	Fri, 15 Dec 2023 21:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702677328;
	bh=yMjtb7YIbCAYZ2tGwsWpmxTromdtine8+QLvwreOlL0=;
	h=Date:Subject:From:To:Cc:From;
	b=JEisZa5/BKKuZM18kNQ23ZApvpu2G+UGV3gZonAwITuEDNlU5COULy3Qx2TuyxEuf
	 uASFbXFxFlu9ieugu/lGSD79X8Dc3tYhJnjFf64TOjMYKEO+Vau1ToQqMLQ197GuaT
	 Zh8U/IB1jm+dM6iLpHvw7NKjF81LoQA58BY63LIMKcOheTsy/+b9SMBYq+KtV0m1s5
	 aaeIl/jUKKMgX9JgpEs9weuRPznC7v7uWc53k+cWxz3xPu7HFUBOrdpEELtMNL8qto
	 8gAk7GhgZkSvrSrUWyV/+7935RE3RIFpjTpmuibmNdywY0A+XNTf7z9W1NtMJD0bbv
	 u11VoZHMLIurQ==
Date: Fri, 15 Dec 2023 13:55:27 -0800
Subject: [GIT PULL 2/6] xfs: online repair of AG btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org, hch@lst.de
Cc: dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <170267713343.2577253.11790987121430782895.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.8-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit e069d549705e49841247acf9b3176744e27d5425:

xfs: constrain dirty buffers while formatting a staged btree (2023-12-15 10:03:29 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-ag-btrees-6.8_2023-12-15

for you to fetch changes up to 9099cd38002f8029c9a1da08e6832d1cd18e8451:

xfs: repair refcount btrees (2023-12-15 10:03:33 -0800)

----------------------------------------------------------------
xfs: online repair of AG btrees [v28.3]

Now that we've spent a lot of time reworking common code in online fsck,
we're ready to start rebuilding the AG space btrees.  This series
implements repair functions for the free space, inode, and refcount
btrees.  Rebuilding the reverse mapping btree is much more intense and
is left for a subsequent patchset.  The fstests counterpart of this
patchset implements stress testing of repair.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (7):
xfs: create separate structures and code for u32 bitmaps
xfs: move the per-AG datatype bitmaps to separate files
xfs: roll the scrub transaction after completing a repair
xfs: remove trivial bnobt/inobt scrub helpers
xfs: repair free space btrees
xfs: repair inode btrees
xfs: repair refcount btrees

fs/xfs/Makefile                    |   4 +
fs/xfs/libxfs/xfs_ag.h             |  10 +
fs/xfs/libxfs/xfs_ag_resv.c        |   2 +
fs/xfs/libxfs/xfs_alloc.c          |  10 +-
fs/xfs/libxfs/xfs_alloc.h          |   2 +-
fs/xfs/libxfs/xfs_alloc_btree.c    |  13 +-
fs/xfs/libxfs/xfs_btree.c          |  26 ++
fs/xfs/libxfs/xfs_btree.h          |   2 +
fs/xfs/libxfs/xfs_ialloc.c         |  31 +-
fs/xfs/libxfs/xfs_ialloc.h         |   3 +-
fs/xfs/libxfs/xfs_refcount.c       |   8 +-
fs/xfs/libxfs/xfs_refcount.h       |   2 +-
fs/xfs/libxfs/xfs_refcount_btree.c |  13 +-
fs/xfs/libxfs/xfs_types.h          |   7 +
fs/xfs/scrub/agb_bitmap.c          | 103 ++++
fs/xfs/scrub/agb_bitmap.h          |  68 +++
fs/xfs/scrub/agheader_repair.c     |  19 +-
fs/xfs/scrub/alloc.c               |  52 ++-
fs/xfs/scrub/alloc_repair.c        | 934 +++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/bitmap.c              | 509 +++++++++++++-------
fs/xfs/scrub/bitmap.h              | 111 ++---
fs/xfs/scrub/common.c              |   1 +
fs/xfs/scrub/common.h              |  19 +
fs/xfs/scrub/ialloc.c              |  39 +-
fs/xfs/scrub/ialloc_repair.c       | 884 +++++++++++++++++++++++++++++++++++
fs/xfs/scrub/newbt.c               |  48 +-
fs/xfs/scrub/newbt.h               |   3 +
fs/xfs/scrub/reap.c                |   6 +-
fs/xfs/scrub/refcount.c            |   2 +-
fs/xfs/scrub/refcount_repair.c     | 794 +++++++++++++++++++++++++++++++
fs/xfs/scrub/repair.c              | 131 ++++++
fs/xfs/scrub/repair.h              |  43 ++
fs/xfs/scrub/rmap.c                |   1 +
fs/xfs/scrub/scrub.c               |  30 +-
fs/xfs/scrub/scrub.h               |  15 +-
fs/xfs/scrub/trace.h               | 112 +++--
fs/xfs/scrub/xfarray.h             |  22 +
fs/xfs/xfs_extent_busy.c           |  13 +
fs/xfs/xfs_extent_busy.h           |   2 +
39 files changed, 3709 insertions(+), 385 deletions(-)
create mode 100644 fs/xfs/scrub/agb_bitmap.c
create mode 100644 fs/xfs/scrub/agb_bitmap.h
create mode 100644 fs/xfs/scrub/alloc_repair.c
create mode 100644 fs/xfs/scrub/ialloc_repair.c
create mode 100644 fs/xfs/scrub/refcount_repair.c

