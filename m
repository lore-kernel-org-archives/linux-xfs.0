Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D27B625
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738341; cv=none; b=GhH8qPY6YbFuPx+nNM5/lx0bc+L9idbhZquI55BXKZNom0CvGQ98xT1WcCkv/w2YocW6TbAPHtvC4ZVrJn7AZHab1y/cbA+zUrRDYuLotrK85yeRh9h7fIXFAeGxAiWZI2kxlEFfv8ymOztHucjgltTI6jfS4QRV5ygqdsm38Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738341; c=relaxed/simple;
	bh=zdli9LFL/uqffAQ7xj8g7uM+DK5FlT30fWtkV4A4jN4=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=O10wKHIVqyL9dP0qCmCVxRy1NbnBV3oYpVcqiztjtWYXlxTBetms5ruDgCEKpDDnzfgaDpc4Z4MfMC+p9sVdfhBi8YvBgacouLmNgv13BqEFqJaimQBW+rXF/VrWwlVjlpd1eEa7GYW0LvEgYQ1EdpEYHAGYVZDXmYOw2IEM21o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NtWI7TnJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NtWI7TnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B52FC433C7;
	Sat, 24 Feb 2024 01:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738341;
	bh=zdli9LFL/uqffAQ7xj8g7uM+DK5FlT30fWtkV4A4jN4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NtWI7TnJNiJpBpWYKkBvad56HUGUa8ee6/jXZGRZdI4lP1IfHEeorvCHmG7H59J4K
	 7Z3tGizCxY45TzAqBL0ByLozlkN3IEnhaZv71uhdxrMVje7pc37+5RFJrud7uIUz/j
	 v9u1EFkYeTEe+mYUkw0W7EBkMEcCrAblIX9FTTpSzlyYjcArgQlP1owiogFdYWMcGp
	 Tv7l76KS4QBklromTIeQyzkzbmLAcRe1IQT91BOFbBoCRgjVxdg4xsykdFUlvAXkE4
	 uMJIzbCavPGVwRP4SHhNLjUzbD4PlqZo8uNQGrEBemJCqfR4nfdLfnvyXsVeq3ndsB
	 cIM6/AR/R8iBQ==
Date: Fri, 23 Feb 2024 17:32:20 -0800
Subject: [GIT PULL 13/18] xfs: online repair of rmap btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170873805592.1891722.8112765815277030914.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240224010220.GN6226@frogsfrogsfrogs>
References: <20240224010220.GN6226@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.9-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 0dc63c8a1ce39c1ac7da536ee9174cdc714afae2:

xfs: launder in-memory btree buffers before transaction commit (2024-02-22 12:43:36 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-rmap-btree-6.9_2024-02-23

for you to fetch changes up to 7e1b84b24d257700e417bc9cd724c1efdff653d7:

xfs: hook live rmap operations during a repair operation (2024-02-22 12:43:40 -0800)

----------------------------------------------------------------
xfs: online repair of rmap btrees [v29.3 13/18]

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

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (5):
xfs: create a helper to decide if a file mapping targets the rt volume
xfs: create agblock bitmap helper to count the number of set regions
xfs: repair the rmapbt
xfs: create a shadow rmap btree during rmap repair
xfs: hook live rmap operations during a repair operation

fs/xfs/Makefile                |    1 +
fs/xfs/libxfs/xfs_ag.c         |    1 +
fs/xfs/libxfs/xfs_ag.h         |    4 +
fs/xfs/libxfs/xfs_bmap.c       |   49 +-
fs/xfs/libxfs/xfs_bmap.h       |    8 +
fs/xfs/libxfs/xfs_inode_fork.c |    9 +
fs/xfs/libxfs/xfs_inode_fork.h |    1 +
fs/xfs/libxfs/xfs_rmap.c       |  199 +++--
fs/xfs/libxfs/xfs_rmap.h       |   31 +-
fs/xfs/libxfs/xfs_rmap_btree.c |  163 +++-
fs/xfs/libxfs/xfs_rmap_btree.h |    6 +
fs/xfs/libxfs/xfs_shared.h     |   10 +
fs/xfs/scrub/agb_bitmap.h      |    5 +
fs/xfs/scrub/bitmap.c          |   14 +
fs/xfs/scrub/bitmap.h          |    2 +
fs/xfs/scrub/bmap.c            |    2 +-
fs/xfs/scrub/common.c          |    5 +-
fs/xfs/scrub/common.h          |    1 +
fs/xfs/scrub/newbt.c           |   12 +-
fs/xfs/scrub/newbt.h           |    7 +
fs/xfs/scrub/reap.c            |    2 +-
fs/xfs/scrub/repair.c          |   59 +-
fs/xfs/scrub/repair.h          |   12 +-
fs/xfs/scrub/rmap.c            |   11 +-
fs/xfs/scrub/rmap_repair.c     | 1697 ++++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/scrub.c           |    6 +-
fs/xfs/scrub/scrub.h           |    4 +-
fs/xfs/scrub/trace.c           |    1 +
fs/xfs/scrub/trace.h           |   80 +-
fs/xfs/xfs_stats.c             |    3 +-
fs/xfs/xfs_stats.h             |    1 +
31 files changed, 2336 insertions(+), 70 deletions(-)
create mode 100644 fs/xfs/scrub/rmap_repair.c

