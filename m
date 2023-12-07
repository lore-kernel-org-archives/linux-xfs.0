Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28551FBA
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FgjtNnsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BE7C433C8;
	Thu,  7 Dec 2023 02:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701917638;
	bh=4e+vNxVQollZ8OYvQna8kIe/qhcuCjG6BTSHvQ5MsLo=;
	h=Date:Subject:From:To:Cc:From;
	b=FgjtNnsJ/nx9BkKA7dE4ZkGf6/D2FKKiwv8bjOnZdPQ7gPSapKa/Slsn5P2R4IupP
	 xGxVjAHBdM8imdhxAikDotEdNG2n//q6SUBmMVW0zXfh4PYXsgdMxgIe8ZGC0vS247
	 SbsrnCWl+jWnR6RQu9nB/iUa+fAxlci35Ut6V1Hn2BMxt7DqdW3ERaVvMZm0pLvctN
	 FL1BsiR3BebC4vYD1PzqYswXqw3cMbAblMNPRQxoLjkb/l3R29eln9KTo3I+Dugydx
	 TGb+TDM4Qp56NDsRWLUAqqq3j2qJvLHmwMsK9sR8Pi5JLWKCpj+BbNzPlSxz8U8Q+g
	 LFk1tK+RS+nrw==
Date: Wed, 06 Dec 2023 18:53:57 -0800
Subject: [GIT PULL 2/6] xfs: continue removing defer item boilerplate
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191741420.1195961.10369652981029381404.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit db7ccc0bac2add5a41b66578e376b49328fc99d0:

xfs: move ->iop_recover to xfs_defer_op_type (2023-12-06 18:45:15 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/reconstruct-defer-cleanups-6.8_2023-12-06

for you to fetch changes up to a49c708f9a445457f6a5905732081871234f61c6:

xfs: move ->iop_relog to struct xfs_defer_op_type (2023-12-06 18:45:17 -0800)

----------------------------------------------------------------
xfs: continue removing defer item boilerplate [v2]

Now that we've restructured log intent item recovery to reconstruct the
incore deferred work state, apply further cleanups to that code to
remove boilerplate that is duplicated across all the _item.c files.
Having done that, collapse a bunch of trivial helpers to reduce the
overall call chain.  That enables us to refactor the relog code so that
the ->relog_item implementations only have to know how to format the
implementation-specific data encoded in an intent item and don't
themselves have to handle the log item juggling.

v2: pick up rvb tags

This has been lightly tested with fstests.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (9):
xfs: don't set XFS_TRANS_HAS_INTENT_DONE when there's no ATTRD log item
xfs: hoist intent done flag setting to ->finish_item callsite
xfs: collapse the ->finish_item helpers
xfs: hoist ->create_intent boilerplate to its callsite
xfs: use xfs_defer_create_done for the relogging operation
xfs: clean out XFS_LI_DIRTY setting boilerplate from ->iop_relog
xfs: hoist xfs_trans_add_item calls to defer ops functions
xfs: collapse the ->create_done functions
xfs: move ->iop_relog to struct xfs_defer_op_type

fs/xfs/libxfs/xfs_defer.c  |  55 ++++++++++-
fs/xfs/libxfs/xfs_defer.h  |   3 +
fs/xfs/xfs_attr_item.c     | 137 +++++++------------------
fs/xfs/xfs_bmap_item.c     | 115 +++++++--------------
fs/xfs/xfs_extfree_item.c  | 242 +++++++++++++++++----------------------------
fs/xfs/xfs_refcount_item.c | 113 +++++++--------------
fs/xfs/xfs_rmap_item.c     | 113 +++++++--------------
fs/xfs/xfs_trans.h         |  10 --
8 files changed, 284 insertions(+), 504 deletions(-)

