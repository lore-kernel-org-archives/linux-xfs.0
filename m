Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCD82144AE
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729190795; cv=none; b=XWVOO2QUDuaj74jd58aI0HjRoQS1mVsObB7hCXSLJRhy3Ild48OG3jId4fWyaBbsLlLXH6ZrHUkCSwuMQ1B5ZezRJSMdaXMXRKpnj+JW/U8yOPFFTTqeth65JSJ+s2Z9ti0E4o8OXPadMv0/hrRzipa3yuSfQ0sUU10RXNf5RMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729190795; c=relaxed/simple;
	bh=/nGvZPtRKFmlfUJYqvWuPDEL1jqyG4vd57dvwHf4BiA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dzY5sLmDzNU3pULatL6HkSmyWec8Tz7Tk+ordyAaQYdlZs+71JbPWXa6nlfbX6vYVCWi0R2paW8WnC9fug77uoFxu9xhPsa5k813gXfJ7ARWXYILNBZxA3mf4yuzMb8gqs2eDDho7bqt818GTiGcZLAB97Ny2DbuUVw63OqCxy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LCVnkeBY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LCVnkeBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18BEC4CEC3;
	Thu, 17 Oct 2024 18:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729190794;
	bh=/nGvZPtRKFmlfUJYqvWuPDEL1jqyG4vd57dvwHf4BiA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LCVnkeBYd5uY7byxOD2nTbfp21bCaoQI7YO0DRU/85v2nXWc0p6SoJgCcA+c3k+ij
	 0XHGca2/5sw5pnIa2eFKXydpmIKbSNBit9RpyL93jC0EajOqxGm51lcrdJxJ2usfpN
	 dwhVoxov0lsvnsA33qYCPUnXp5lGbNFk6yGOznYXXvDqt4v1y6YKiCfM0RQwWxMjXH
	 QNxdqyKzyPq3yfMVld21bevmXJwyOYKPBcVhCPSu0ysL4wYkC7qxPqvlolR1LifqQ9
	 QHxOySDPPZZrUKp3kFvoCSIjF8pU9e5SzkdDY0V9jzb6uxHHokmxwy/aD5XbZUEsTS
	 deE54HJ2EjS8A==
Date: Thu, 17 Oct 2024 11:46:34 -0700
Subject: [PATCHSET v5.1 2/9] xfs: create a generic allocation group structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919068618.3450737.15265130869882039127.stgit@frogsfrogsfrogs>
In-Reply-To: <20241017184009.GV21853@frogsfrogsfrogs>
References: <20241017184009.GV21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Soon we'll be sharding the realtime volume into separate allocation
groups.  These rt groups will /mostly/ behave the same as the ones on
the data device, but since rt groups don't have quite the same set of
struct fields as perags, let's hoist the parts that will be shared by
both into a common xfs_group object.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=generic-groups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=generic-groups
---
Commits in this patchset:
 * xfs: factor out a xfs_iwalk_args helper
 * xfs: factor out a generic xfs_group structure
 * xfs: add a xfs_group_next_range helper
 * xfs: switch perag iteration from the for_each macros to a while based iterator
 * xfs: move metadata health tracking to the generic group structure
 * xfs: mark xfs_perag_intent_{hold,rele} static
 * xfs: move draining of deferred operations to the generic group structure
 * xfs: move the online repair rmap hooks to the generic group structure
 * xfs: return the busy generation from xfs_extent_busy_list_empty
 * xfs: convert extent busy tracepoints to the generic group structure
 * xfs: convert busy extent tracking to the generic group structure
 * xfs: add a generic group pointer to the btree cursor
 * xfs: store a generic xfs_group pointer in xfs_getfsmap_info
 * xfs: add group based bno conversion helpers
 * xfs: remove xfs_group_intent_hold and xfs_group_intent_rele
 * xfs: store a generic group structure in the intents
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_ag.c             |  149 ++++-------------------
 fs/xfs/libxfs/xfs_ag.h             |  165 ++++++++++++++-----------
 fs/xfs/libxfs/xfs_ag_resv.c        |   19 ++-
 fs/xfs/libxfs/xfs_alloc.c          |   74 ++++++-----
 fs/xfs/libxfs/xfs_alloc.h          |    2 
 fs/xfs/libxfs/xfs_alloc_btree.c    |   30 ++---
 fs/xfs/libxfs/xfs_bmap.c           |    2 
 fs/xfs/libxfs/xfs_bmap.h           |    2 
 fs/xfs/libxfs/xfs_btree.c          |   37 ++----
 fs/xfs/libxfs/xfs_btree.h          |    3 
 fs/xfs/libxfs/xfs_btree_mem.c      |    6 -
 fs/xfs/libxfs/xfs_group.c          |  225 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_group.h          |  131 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_health.h         |   45 +++----
 fs/xfs/libxfs/xfs_ialloc.c         |   50 ++++----
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   27 ++--
 fs/xfs/libxfs/xfs_refcount.c       |   26 ++--
 fs/xfs/libxfs/xfs_refcount.h       |    2 
 fs/xfs/libxfs/xfs_refcount_btree.c |   14 +-
 fs/xfs/libxfs/xfs_rmap.c           |   42 +++---
 fs/xfs/libxfs/xfs_rmap.h           |    6 -
 fs/xfs/libxfs/xfs_rmap_btree.c     |   28 ++--
 fs/xfs/libxfs/xfs_sb.c             |   28 ++--
 fs/xfs/libxfs/xfs_types.c          |    5 -
 fs/xfs/libxfs/xfs_types.h          |    8 +
 fs/xfs/scrub/agheader_repair.c     |   22 ++-
 fs/xfs/scrub/alloc.c               |    2 
 fs/xfs/scrub/alloc_repair.c        |   12 +-
 fs/xfs/scrub/bmap.c                |    8 +
 fs/xfs/scrub/bmap_repair.c         |    9 +
 fs/xfs/scrub/common.c              |    4 -
 fs/xfs/scrub/common.h              |    3 
 fs/xfs/scrub/cow_repair.c          |    9 +
 fs/xfs/scrub/fscounters.c          |   10 +-
 fs/xfs/scrub/health.c              |   21 +--
 fs/xfs/scrub/ialloc.c              |   14 +-
 fs/xfs/scrub/ialloc_repair.c       |    2 
 fs/xfs/scrub/inode_repair.c        |    5 -
 fs/xfs/scrub/iscan.c               |    4 -
 fs/xfs/scrub/newbt.c               |    8 +
 fs/xfs/scrub/reap.c                |    2 
 fs/xfs/scrub/refcount.c            |    3 
 fs/xfs/scrub/repair.c              |    4 -
 fs/xfs/scrub/rmap.c                |    4 -
 fs/xfs/scrub/rmap_repair.c         |   16 +-
 fs/xfs/scrub/trace.h               |   82 ++++++------
 fs/xfs/xfs_bmap_item.c             |    5 -
 fs/xfs/xfs_discard.c               |   20 ++-
 fs/xfs/xfs_drain.c                 |   78 +++++-------
 fs/xfs/xfs_drain.h                 |   22 +--
 fs/xfs/xfs_extent_busy.c           |  201 ++++++++++++++++++------------
 fs/xfs/xfs_extent_busy.h           |   59 +++------
 fs/xfs/xfs_extfree_item.c          |   14 +-
 fs/xfs/xfs_filestream.c            |    8 +
 fs/xfs/xfs_fsmap.c                 |   49 ++++---
 fs/xfs/xfs_fsops.c                 |   10 +-
 fs/xfs/xfs_health.c                |   99 +++++++--------
 fs/xfs/xfs_icache.c                |   60 +++------
 fs/xfs/xfs_inode.c                 |    6 -
 fs/xfs/xfs_iwalk.c                 |   99 ++++++---------
 fs/xfs/xfs_iwalk.h                 |    7 -
 fs/xfs/xfs_log_recover.c           |   11 +-
 fs/xfs/xfs_mount.h                 |   36 +++++
 fs/xfs/xfs_refcount_item.c         |    9 +
 fs/xfs/xfs_reflink.c               |    7 -
 fs/xfs/xfs_rmap_item.c             |    9 +
 fs/xfs/xfs_super.c                 |   11 +-
 fs/xfs/xfs_trace.c                 |    1 
 fs/xfs/xfs_trace.h                 |  238 ++++++++++++++++++++++--------------
 70 files changed, 1380 insertions(+), 1050 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_group.c
 create mode 100644 fs/xfs/libxfs/xfs_group.h

