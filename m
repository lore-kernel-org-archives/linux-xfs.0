Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E005F84E
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 21:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nrXSJVMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33B5C433C7;
	Fri, 15 Dec 2023 21:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702677360;
	bh=F/srrVY6oISwzdBfqABZN6x10zD0huKhsT/U4Uu6Pxk=;
	h=Date:Subject:From:To:Cc:From;
	b=nrXSJVMG3PEP5nTF64SSwT5MR2U+83JvBb03X8GeOHzWKi4HKu1AfrQoXhcwx+sSv
	 jxTmvbawwc0TE3OXF286xije4qQkYEIMJxtBDa8R6BVwnsfUOvaQ72WHlg5zfa5dXx
	 yKKt8nKfIq3N/otrM+5zy2gI3uNmgQqKKXF/B1Z9GFiN/jEW53pGDZVIygMH5vvdI2
	 HJeq+/ohmXJjEZs6ELeOyAsvD6/QT9I5upB+e1VS+/tOqLFhuScG2loaSoJS2kUqrs
	 tcC//9jxxTI9nYOecMg6K1J92lndPKUMaoPV3sxFo4ntC7TaQXMtTA9KRg8CvdGl//
	 GL3ht3MBXQmAw==
Date: Fri, 15 Dec 2023 13:55:59 -0800
Subject: [GIT PULL 4/6] xfs: online repair of file fork mappings
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <170267713559.2577253.17958854624353416929.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit c3a22c2e4b45fcf3184e7dd1c755e6b45dc9f499:

xfs: skip the rmapbt search on an empty attr fork unless we know it was zapped (2023-12-15 10:03:38 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-file-mappings-6.8_2023-12-15

for you to fetch changes up to dbbdbd0086320a026903ca34efedb6abf55230ed:

xfs: repair problems in CoW forks (2023-12-15 10:03:40 -0800)

----------------------------------------------------------------
xfs: online repair of file fork mappings [v28.3]

In this series, online repair gains the ability to rebuild data and attr
fork mappings from the reverse mapping information.  It is at this point
where we reintroduce the ability to reap file extents.

Repair of CoW forks is a little different -- on disk, CoW staging
extents are owned by the refcount btree and cannot be mapped back to
individual files.  Hence we can only detect staging extents that don't
quite look right (missing reverse mappings, shared staging extents) and
replace them with fresh allocations.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (5):
xfs: reintroduce reaping of file metadata blocks to xrep_reap_extents
xfs: repair inode fork block mapping data structures
xfs: refactor repair forcing tests into a repair.c helper
xfs: create a ranged query function for refcount btrees
xfs: repair problems in CoW forks

fs/xfs/Makefile                   |   2 +
fs/xfs/libxfs/xfs_bmap_btree.c    | 121 +++++-
fs/xfs/libxfs/xfs_bmap_btree.h    |   5 +
fs/xfs/libxfs/xfs_btree_staging.c |  11 +-
fs/xfs/libxfs/xfs_btree_staging.h |   2 +-
fs/xfs/libxfs/xfs_iext_tree.c     |  23 +-
fs/xfs/libxfs/xfs_inode_fork.c    |   1 +
fs/xfs/libxfs/xfs_inode_fork.h    |   3 +
fs/xfs/libxfs/xfs_refcount.c      |  41 ++
fs/xfs/libxfs/xfs_refcount.h      |  10 +
fs/xfs/scrub/bmap.c               |  18 +
fs/xfs/scrub/bmap_repair.c        | 858 ++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/common.h             |   6 +-
fs/xfs/scrub/cow_repair.c         | 614 +++++++++++++++++++++++++++
fs/xfs/scrub/fsb_bitmap.h         |  37 ++
fs/xfs/scrub/off_bitmap.h         |  37 ++
fs/xfs/scrub/reap.c               | 153 ++++++-
fs/xfs/scrub/reap.h               |   5 +
fs/xfs/scrub/repair.c             |  50 +++
fs/xfs/scrub/repair.h             |  11 +
fs/xfs/scrub/scrub.c              |  20 +-
fs/xfs/scrub/trace.h              | 118 +++++-
fs/xfs/xfs_trans.c                |  62 +++
fs/xfs/xfs_trans.h                |   4 +
24 files changed, 2160 insertions(+), 52 deletions(-)
create mode 100644 fs/xfs/scrub/bmap_repair.c
create mode 100644 fs/xfs/scrub/cow_repair.c
create mode 100644 fs/xfs/scrub/fsb_bitmap.h
create mode 100644 fs/xfs/scrub/off_bitmap.h

