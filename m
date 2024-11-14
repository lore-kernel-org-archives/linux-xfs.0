Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCB32905
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 06:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731565588; cv=none; b=a6czdEzBgalpqHvRlI4HXFa59xFvNDLuELv+70rVbvzqIfwbdnQNmmDx0hzxIPsyy6mm+z5mXTZOhi2K6lrKbYwwZkcDJQ5rmcTGbqhNqDDC0cHCadt5UD0Jm1aCiK9XWcKHdJJGaWvVdNTrClmmTrxWeu542wXlqpYNf6yuTQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731565588; c=relaxed/simple;
	bh=XXl0eyKgIBMOdP1XlFVk8pwSjQ3V0YVcQBKF2/7bLds=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=kj5je0lvGZ3uOHol7GPHpQ43oRpB56K0odEO1OYBhKCYYJDYwzAN/V9klxIbVFjnjqpOhE8jvuTWogS7eVv8AMkyYO/YMvlCKMdmHaNjuINQB/1k1NSSjSlMRDto12kC5ArwAQLJt4piilWrOKkh2abPrmNfUCEwU/XbzVJ2vpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GcQmBmb/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GcQmBmb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747CAC4CECF;
	Thu, 14 Nov 2024 06:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731565586;
	bh=XXl0eyKgIBMOdP1XlFVk8pwSjQ3V0YVcQBKF2/7bLds=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GcQmBmb/S/Yuuwmob6VZsB9Y9avcrpP700MgUKYYQmcgWiPTTH+rMRr5XDY0b6Nf5
	 Fus6Oe16mccf58CF0NeC7ILUiYTM1VieZlJzBt2dTGmVI8Am5U3WQzCOGzrmHmYCNz
	 37uPFPhsL++RqlJ+0rrvlUIvNVCkECv+Z7h99l8UgXY6LGa0Rl23WOWt20ZFsq7y36
	 tkx6w7L7ki5xuHkiJzBsQuvEUReo+3illT7xvPPTu7FCP5VrFCZtpgdWaZGCmirhlq
	 01cAzQM0lZ5/brtmefLoG9Q7PGMu0gDlF3S5M/pEUz9QGNu3iBK7QuueGp1SSP1T3j
	 Yq4+PLanazOgQ==
Date: Wed, 13 Nov 2024 22:26:26 -0800
Subject: [GIT PULL 02/10] xfs: create a generic allocation group structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173156551169.1445256.15124217838321935115.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241114062447.GO9438@frogsfrogsfrogs>
References: <20241114062447.GO9438@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 6.13-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 612dab1887b16838b524876555ac16fccb750e77:

xfs: insert the pag structures into the xarray later (2024-11-13 22:16:54 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/generic-groups-6.13_2024-11-13

for you to fetch changes up to fd293760168c36f210b699f73727535e90a4e14d:

xfs: store a generic group structure in the intents (2024-11-13 22:16:57 -0800)

----------------------------------------------------------------
xfs: create a generic allocation group structure [v5.7 02/10]

Soon we'll be sharding the realtime volume into separate allocation
groups.  These rt groups will /mostly/ behave the same as the ones on
the data device, but since rt groups don't have quite the same set of
struct fields as perags, let's hoist the parts that will be shared by
both into a common xfs_group object.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (16):
xfs: factor out a xfs_iwalk_args helper
xfs: factor out a generic xfs_group structure
xfs: add a xfs_group_next_range helper
xfs: switch perag iteration from the for_each macros to a while based iterator
xfs: move metadata health tracking to the generic group structure
xfs: mark xfs_perag_intent_{hold,rele} static
xfs: move draining of deferred operations to the generic group structure
xfs: move the online repair rmap hooks to the generic group structure
xfs: return the busy generation from xfs_extent_busy_list_empty
xfs: convert extent busy tracepoints to the generic group structure
xfs: convert busy extent tracking to the generic group structure
xfs: add a generic group pointer to the btree cursor
xfs: store a generic xfs_group pointer in xfs_getfsmap_info
xfs: add group based bno conversion helpers
xfs: remove xfs_group_intent_hold and xfs_group_intent_rele
xfs: store a generic group structure in the intents

fs/xfs/Makefile                    |   1 +
fs/xfs/libxfs/xfs_ag.c             | 149 +++++------------------
fs/xfs/libxfs/xfs_ag.h             | 165 +++++++++++++------------
fs/xfs/libxfs/xfs_ag_resv.c        |  19 +--
fs/xfs/libxfs/xfs_alloc.c          |  74 ++++++------
fs/xfs/libxfs/xfs_alloc.h          |   2 +-
fs/xfs/libxfs/xfs_alloc_btree.c    |  30 ++---
fs/xfs/libxfs/xfs_bmap.c           |   2 +-
fs/xfs/libxfs/xfs_bmap.h           |   2 +-
fs/xfs/libxfs/xfs_btree.c          |  37 ++----
fs/xfs/libxfs/xfs_btree.h          |   3 +-
fs/xfs/libxfs/xfs_btree_mem.c      |   6 +-
fs/xfs/libxfs/xfs_group.c          | 225 +++++++++++++++++++++++++++++++++++
fs/xfs/libxfs/xfs_group.h          | 131 ++++++++++++++++++++
fs/xfs/libxfs/xfs_health.h         |  45 +++----
fs/xfs/libxfs/xfs_ialloc.c         |  50 ++++----
fs/xfs/libxfs/xfs_ialloc_btree.c   |  27 +++--
fs/xfs/libxfs/xfs_refcount.c       |  26 ++--
fs/xfs/libxfs/xfs_refcount.h       |   2 +-
fs/xfs/libxfs/xfs_refcount_btree.c |  14 +--
fs/xfs/libxfs/xfs_rmap.c           |  42 +++----
fs/xfs/libxfs/xfs_rmap.h           |   6 +-
fs/xfs/libxfs/xfs_rmap_btree.c     |  28 ++---
fs/xfs/libxfs/xfs_sb.c             |  28 +++--
fs/xfs/libxfs/xfs_types.c          |   5 +-
fs/xfs/libxfs/xfs_types.h          |   8 ++
fs/xfs/scrub/agheader_repair.c     |  22 ++--
fs/xfs/scrub/alloc.c               |   2 +-
fs/xfs/scrub/alloc_repair.c        |  12 +-
fs/xfs/scrub/bmap.c                |   8 +-
fs/xfs/scrub/bmap_repair.c         |   9 +-
fs/xfs/scrub/common.c              |   4 +-
fs/xfs/scrub/common.h              |   3 +-
fs/xfs/scrub/cow_repair.c          |   9 +-
fs/xfs/scrub/fscounters.c          |  10 +-
fs/xfs/scrub/health.c              |  21 ++--
fs/xfs/scrub/ialloc.c              |  14 +--
fs/xfs/scrub/ialloc_repair.c       |   2 +-
fs/xfs/scrub/inode_repair.c        |   5 +-
fs/xfs/scrub/iscan.c               |   4 +-
fs/xfs/scrub/newbt.c               |   8 +-
fs/xfs/scrub/reap.c                |   2 +-
fs/xfs/scrub/refcount.c            |   3 +-
fs/xfs/scrub/repair.c              |   4 +-
fs/xfs/scrub/rmap.c                |   4 +-
fs/xfs/scrub/rmap_repair.c         |  16 +--
fs/xfs/scrub/trace.h               |  82 ++++++-------
fs/xfs/xfs_bmap_item.c             |   5 +-
fs/xfs/xfs_discard.c               |  20 ++--
fs/xfs/xfs_drain.c                 |  78 +++++-------
fs/xfs/xfs_drain.h                 |  22 ++--
fs/xfs/xfs_extent_busy.c           | 201 +++++++++++++++++++------------
fs/xfs/xfs_extent_busy.h           |  59 ++++-----
fs/xfs/xfs_extfree_item.c          |  14 ++-
fs/xfs/xfs_filestream.c            |   8 +-
fs/xfs/xfs_fsmap.c                 |  49 ++++----
fs/xfs/xfs_fsops.c                 |  10 +-
fs/xfs/xfs_health.c                |  99 +++++++--------
fs/xfs/xfs_icache.c                |  60 ++++------
fs/xfs/xfs_inode.c                 |   6 +-
fs/xfs/xfs_iwalk.c                 |  99 +++++++--------
fs/xfs/xfs_iwalk.h                 |   7 +-
fs/xfs/xfs_log_recover.c           |  11 +-
fs/xfs/xfs_mount.h                 |  36 +++++-
fs/xfs/xfs_refcount_item.c         |   9 +-
fs/xfs/xfs_reflink.c               |   7 +-
fs/xfs/xfs_rmap_item.c             |   9 +-
fs/xfs/xfs_super.c                 |  11 +-
fs/xfs/xfs_trace.c                 |   1 +
fs/xfs/xfs_trace.h                 | 238 ++++++++++++++++++++++---------------
70 files changed, 1380 insertions(+), 1050 deletions(-)
create mode 100644 fs/xfs/libxfs/xfs_group.c
create mode 100644 fs/xfs/libxfs/xfs_group.h

