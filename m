Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8F0149C53
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 23:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730850633; cv=none; b=qHSm/W/WbFDqqQ/P363yT4vm8PASPxeyvT9rb2O2oZg2V0rQLglnQL0zlZdInYBbd8y27qXUe90+Hy4ra/asE68FGcpIkEpDJVLEDJ1XPJXUg3xkBGJye//PoM7+Lbz9h9L/eZmETxM9kp37J6EBGJFM07wHRwb5GGYYu0y7SiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730850633; c=relaxed/simple;
	bh=JUxYLAJx0lVV8OwCUBEmjOgly9d363m8FLS6UnCXPkg=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=DSRHzzre4qEVXa/NBEoYv5lxY9mPMbIiV4NZuv84WeIdy6twQYVk7djHl5EH1fDj3cfqCuYleTpcX3JDwMimva6aIzaRn0jWMbbonYnzmjF4sCd/GQY239HnaZp3QtlMAuC/TsnMgG19XiFXzprhEFovWKGIEY2/ZwK3GBhgRtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UHhrZesJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UHhrZesJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA45C4CECF;
	Tue,  5 Nov 2024 23:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730850633;
	bh=JUxYLAJx0lVV8OwCUBEmjOgly9d363m8FLS6UnCXPkg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UHhrZesJFRMSl6FbW2VKcIZBmcoUCqRboy4z56BT6b2trRxDkoyJ0Bc4cvOYLxSOU
	 NBG5DSbljSO05iEv/6tm2S2zJhERHF7de2igifxe5P1OABW2ha44tlKJK2VqbNwj1F
	 akBskbV5J6XBmrpY5g6O+QHv4k4fVEqVY8iQh4B60OkQGPRErM4u88K3hjK0ZtHyMb
	 /k8qQiEnfbadu0nYVFNYedIb/857NwtTkbF2zZQuOVUKT0VZVu/fxVrACd4Xe/Y+08
	 NTGJdZN98moSJL6QxkqR6NuQmR7udz7uAJU70x+99rrQPysapjruqxxbowcZZhIbeR
	 JapkvLZn1AHAQ==
Date: Tue, 05 Nov 2024 15:50:33 -0800
Subject: [GIT PULL 02/10] xfs: create a generic allocation group structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173085053989.1980968.5150082829166393141.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241105234839.GL2386201@frogsfrogsfrogs>
References: <20241105234839.GL2386201@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 6.13-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit d66496578b2a099ea453f56782f1cd2bf63a8029:

xfs: insert the pag structures into the xarray later (2024-11-05 13:38:27 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/generic-groups-6.13_2024-11-05

for you to fetch changes up to e5e5cae05b71aa5b5e291c0e74b4e4d98a0b05d4:

xfs: store a generic group structure in the intents (2024-11-05 13:38:30 -0800)

----------------------------------------------------------------
xfs: create a generic allocation group structure [v5.5 02/10]

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

