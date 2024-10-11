Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CF12F26
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728606827; cv=none; b=YC+Z1gwRc1mdx1Q6LIINM9d4m9dS3sTwKahiT0q81OMgoJwFsiWBzLO4On11oHuPRTQ1iD5++PjjBLSEclxxlA7zGh/FQsK/HYeT9NVTVFQf7E2mSolYTihiDJk9IJRSFh5e5/HqIbrAdTNG+BE/9aRUgZ1Y86GAoLRFPoRkxh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728606827; c=relaxed/simple;
	bh=3htsL2SKCIbXAuL1PuuEo82BnTPPq2cAHAns1F3yf4U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dIZ2Fq48GH4WfpRUTUpEAcgfHJiPKiPKRzCGrELclZEgyhnP8zyPjtt18CL+s09a/t26LiFjabVjx6nqx864iUSBzl4zlZolZ3WTXBNd3aDL1Hs0oeRWblbnChZfEalaW6/tZRxhFVvYPWba8z75c4BkXajIcBFvC0TbaJgjyWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sk2Cz6zA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sk2Cz6zA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F4EC4CEC5;
	Fri, 11 Oct 2024 00:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728606827;
	bh=3htsL2SKCIbXAuL1PuuEo82BnTPPq2cAHAns1F3yf4U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sk2Cz6zAQYWuiqcVZ72G79nqhcg5G+gWxo387pYPxC1p55UeQoMQxAW5ek2qFpBiT
	 pQoDBO1pq+quw68GT3cK6C5m/1JPvYDxBpb/+aRbthycuMX9n78nmP4vib6ZKQZl+l
	 3K57/MhTREq6vlYkHxujPs8IPIVHXZsHugNtDjUWZisEcAdNkh8AwhPZhaS8bw4bNx
	 Euh0lRJoKJFQj1y9fRfP7KbXrKra8b/fU5YTlkLzgiGn2FCRXSmKCKL2hwA20+Uf7K
	 LLnRuujwwAavMCFNkKXqKjkNUngWT2el0ylrM/fiPd1rn7F7904vjWTm/L1MHdtCvX
	 Hdb1IjZ8Dwb3Q==
Date: Thu, 10 Oct 2024 17:33:46 -0700
Subject: [PATCHSET v5.0 2/9] xfs: create a generic allocation group structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
In-Reply-To: <20241011002402.GB21877@frogsfrogsfrogs>
References: <20241011002402.GB21877@frogsfrogsfrogs>
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
 * xfs: convert extent busy tracking to the generic group structure
 * xfs: convert busy extent tracking to the generic group structure
 * xfs: add a generic group pointer to the btree cursor
 * xfs: store a generic xfs_group pointer in xfs_getfsmap_info
 * xfs: add group based bno conversion helpers
 * xfs: remove xfs_group_intent_hold and xfs_group_intent_rele
 * xfs: store a generic group structure in the intents
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_ag.c             |  149 ++++-----------------
 fs/xfs/libxfs/xfs_ag.h             |  160 ++++++++++++-----------
 fs/xfs/libxfs/xfs_ag_resv.c        |   19 +--
 fs/xfs/libxfs/xfs_alloc.c          |   74 ++++++-----
 fs/xfs/libxfs/xfs_alloc.h          |    2 
 fs/xfs/libxfs/xfs_alloc_btree.c    |   30 ++--
 fs/xfs/libxfs/xfs_bmap.c           |    2 
 fs/xfs/libxfs/xfs_bmap.h           |    2 
 fs/xfs/libxfs/xfs_btree.c          |   37 ++---
 fs/xfs/libxfs/xfs_btree.h          |    3 
 fs/xfs/libxfs/xfs_btree_mem.c      |    6 -
 fs/xfs/libxfs/xfs_group.c          |  251 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_group.h          |   82 ++++++++++++
 fs/xfs/libxfs/xfs_health.h         |   45 ++----
 fs/xfs/libxfs/xfs_ialloc.c         |   50 ++++---
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   27 ++--
 fs/xfs/libxfs/xfs_refcount.c       |   26 ++--
 fs/xfs/libxfs/xfs_refcount.h       |    2 
 fs/xfs/libxfs/xfs_refcount_btree.c |   14 +-
 fs/xfs/libxfs/xfs_rmap.c           |   42 +++---
 fs/xfs/libxfs/xfs_rmap.h           |    6 -
 fs/xfs/libxfs/xfs_rmap_btree.c     |   28 ++--
 fs/xfs/libxfs/xfs_sb.c             |   21 +--
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
 fs/xfs/scrub/fscounters.c          |   10 +
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
 fs/xfs/xfs_drain.c                 |   78 +++++------
 fs/xfs/xfs_drain.h                 |   22 +--
 fs/xfs/xfs_extent_busy.c           |  201 +++++++++++++++++------------
 fs/xfs/xfs_extent_busy.h           |   59 +++-----
 fs/xfs/xfs_extfree_item.c          |   14 +-
 fs/xfs/xfs_filestream.c            |    8 +
 fs/xfs/xfs_fsmap.c                 |   49 ++++---
 fs/xfs/xfs_fsops.c                 |   10 +
 fs/xfs/xfs_health.c                |   99 +++++++-------
 fs/xfs/xfs_icache.c                |   60 +++------
 fs/xfs/xfs_inode.c                 |    6 -
 fs/xfs/xfs_iwalk.c                 |   99 ++++++--------
 fs/xfs/xfs_iwalk.h                 |    7 -
 fs/xfs/xfs_log_recover.c           |   11 +-
 fs/xfs/xfs_mount.h                 |    6 +
 fs/xfs/xfs_refcount_item.c         |    9 +
 fs/xfs/xfs_reflink.c               |    7 -
 fs/xfs/xfs_rmap_item.c             |    9 +
 fs/xfs/xfs_super.c                 |   11 +-
 fs/xfs/xfs_trace.c                 |    1 
 fs/xfs/xfs_trace.h                 |  238 +++++++++++++++++++++-------------
 70 files changed, 1315 insertions(+), 1050 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_group.c
 create mode 100644 fs/xfs/libxfs/xfs_group.h

