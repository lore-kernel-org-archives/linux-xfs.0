Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FE87097F
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kgl0u6KW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78327C433C7;
	Thu,  7 Dec 2023 02:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701917316;
	bh=IZFN1NhSm9D+eDoXK3lh+5R2AGFwWVIzKiZmX+spmFs=;
	h=Date:Subject:From:To:Cc:From;
	b=Kgl0u6KWvP5NxOXTeEa5HP9ir7HyxNVnAKf5MPW9lZ7RZdG4LYhICZD11bCPJ2SQJ
	 0TmkJ7mMBbcEhYgcfzGurwEt78cRYrjwXOCU8SNmCMbGSiHN3McIZWCiKP9Dk+a2U/
	 dCrzJOgemXnsS9WhfzN8R4Fcn8Wpkm51BXNyNcFn6QZzmN40EHchBfHTlw6jqubJCm
	 Nes98Ve+rF45nuQDB1nwUcsMfaqUid9swQW5h7uVpGe1yz0d9Wvoa1yaPkFU5swFMm
	 v64EDhejaIyrhUTUY+yrGP56PYK4OKnWdjtV5If7lKZb6CBPq4kOumiel6j55vrZCS
	 l45zvtqcxyMEg==
Date: Wed, 06 Dec 2023 18:48:36 -0800
Subject: [GIT PULL 1/3] xfs: elide defer work ->create_done if no intent
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191727770.1193846.6148843866019229192.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 33cc938e65a98f1d29d0a18403dbbee050dcad9a:

Linux 6.7-rc4 (2023-12-03 18:52:56 +0900)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/defer-elide-create-done-6.8_2023-12-06

for you to fetch changes up to 9c07bca793b4ff9f0b7871e2a928a1b28b8fa4e3:

xfs: elide ->create_done calls for unlogged deferred work (2023-12-06 18:45:17 -0800)

----------------------------------------------------------------
xfs: elide defer work ->create_done if no intent [v2]

Christoph pointed out that the defer ops machinery doesn't need to call
->create_done if the deferred work item didn't generate a log intent
item in the first place.  Let's clean that up and save an indirect call
in the non-logged xattr update call path.

v2: pick up rvb tags

This has been lightly tested with fstests.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (22):
xfs: don't leak recovered attri intent items
xfs: use xfs_defer_pending objects to recover intent items
xfs: pass the xfs_defer_pending object to iop_recover
xfs: transfer recovered intent item ownership in ->iop_recover
xfs: recreate work items when recovering intent items
xfs: dump the recovered xattri log item if corruption happens
xfs: use xfs_defer_finish_one to finish recovered work items
xfs: move ->iop_recover to xfs_defer_op_type
xfs: don't set XFS_TRANS_HAS_INTENT_DONE when there's no ATTRD log item
xfs: hoist intent done flag setting to ->finish_item callsite
xfs: collapse the ->finish_item helpers
xfs: hoist ->create_intent boilerplate to its callsite
xfs: use xfs_defer_create_done for the relogging operation
xfs: clean out XFS_LI_DIRTY setting boilerplate from ->iop_relog
xfs: hoist xfs_trans_add_item calls to defer ops functions
xfs: collapse the ->create_done functions
xfs: move ->iop_relog to struct xfs_defer_op_type
xfs: make rextslog computation consistent with mkfs
xfs: fix 32-bit truncation in xfs_compute_rextslog
xfs: don't allow overly small or large realtime volumes
xfs: document what LARP means
xfs: elide ->create_done calls for unlogged deferred work

fs/xfs/libxfs/xfs_defer.c       | 184 ++++++++++++++++++----
fs/xfs/libxfs/xfs_defer.h       |  22 +++
fs/xfs/libxfs/xfs_log_recover.h |   7 +
fs/xfs/libxfs/xfs_rtbitmap.c    |  14 ++
fs/xfs/libxfs/xfs_rtbitmap.h    |  16 ++
fs/xfs/libxfs/xfs_sb.c          |   6 +-
fs/xfs/xfs_attr_item.c          | 252 ++++++++++++-------------------
fs/xfs/xfs_bmap_item.c          | 199 ++++++++++--------------
fs/xfs/xfs_extfree_item.c       | 327 +++++++++++++++-------------------------
fs/xfs/xfs_log.c                |   1 +
fs/xfs/xfs_log_priv.h           |   1 +
fs/xfs/xfs_log_recover.c        | 129 ++++++++--------
fs/xfs/xfs_refcount_item.c      | 233 +++++++++-------------------
fs/xfs/xfs_rmap_item.c          | 256 +++++++++++++------------------
fs/xfs/xfs_rtalloc.c            |   6 +-
fs/xfs/xfs_sysfs.c              |   9 ++
fs/xfs/xfs_trans.h              |  12 --
17 files changed, 768 insertions(+), 906 deletions(-)

