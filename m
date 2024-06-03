Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6A64411
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717444594; cv=none; b=aSPHvr+HjmCSTLGk9Xi6CSgrykdtucl170/kIVZc29mh8ETq9QLyq834PxjoonlJ3Yg6hixsRImJCsWBhpvFFKx3ZJXdV+xY0NhcnAh1/vKkVU7X7hzRvHU/Iy5hQp1pFB8aCHqTLhtgjAOHyu0qCE7wJ0/OGLsuKUhTWiZ4Qvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717444594; c=relaxed/simple;
	bh=XzWef1aVlPGgUqU4kgnnrPwZQPSfbc4TOSaVYDUO3oI=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=cAt/7qQJz8owHVA/yD8X/66rKJTseLNbGO2fNizPpofclMqjo/LbKiBfNUjOWX/0UWZ65N8UGVorKlCPahoV6LVd136FPOXzaTfKsXxXTfjsh396WoR8aYDj9DGN6bWnvkSoVS7OcJMRFEZ8X3Q/iPioP1bg16fNH1dce4skrbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s1RrsZ1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s1RrsZ1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45D3C2BD10;
	Mon,  3 Jun 2024 19:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717444593;
	bh=XzWef1aVlPGgUqU4kgnnrPwZQPSfbc4TOSaVYDUO3oI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=s1RrsZ1hGPZBOqhiGrdqb9/7P5kZ80z0MB21Wu59g2t1UqZNFCie1+Fgw4yjRGkwR
	 4eLmkWY1v2wCSa3G9tOpgP7Mzdp1Cm0i4EX0axRnuwZYgTBDMsWf+BNArtf0HYu/Ii
	 JPtB++fcR4nqID1ThDwjlyOWaVhEOSHntwKtYO7pGQwklxQ4kQV8C3+R9laiJq5iJN
	 CWLTtLQvVqb7ZUa8TzErDzZDo2RIErW4MiJa2VkfrEoWyn+ZaTbPNMbIQK9BaXiDvk
	 BIynTLLlW6sq8b8NQWdtHk/bNjwmDkvHUDScGusrSMiB0s0s9ig7Ok3JcXAco1EEut
	 c1B6KqdR82T5A==
Date: Mon, 03 Jun 2024 12:56:33 -0700
Subject: [GIT PULL 08/10] xfs_repair: use in-memory rmap btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171744444077.1510943.14031140831445039.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240603195305.GE52987@frogsfrogsfrogs>
References: <20240603195305.GE52987@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 842676ed999f0baae79c3de3ad6e2d3b90733f49:

xfs_repair: check num before bplist[num] (2024-06-03 11:37:42 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/repair-use-in-memory-btrees-6.9_2024-06-03

for you to fetch changes up to 47307ecef44599b2caf0546c7e518b544e14d9c8:

xfs_repair: remove the old rmap collection slabs (2024-06-03 11:37:42 -0700)

----------------------------------------------------------------
xfs_repair: use in-memory rmap btrees [v30.5 08/35]

Now that we've ported support for in-memory btrees to userspace, port
xfs_repair to use them instead of the clunky slab interface that we
currently use.  This has the effect of moving memory consumption for
tracking reverse mappings into a memfd file, which means that we could
(theoretically) reduce the memory requirements by pointing it at an
on-disk file or something.  It also enables us to remove the sorting
step and to avoid having to coalesce adjacent contiguous bmap records
into a single rmap record.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (1):
libxfs: provide a kernel-compatible kasprintf

Darrick J. Wong (5):
xfs_repair: convert regular rmap repair to use in-memory btrees
xfs_repair: verify on-disk rmap btrees with in-memory btree data
xfs_repair: compute refcount data from in-memory rmap btrees
xfs_repair: reduce rmap bag memory usage when creating refcounts
xfs_repair: remove the old rmap collection slabs

include/kmem.h           |   3 +
include/libxfs.h         |   3 +
libxfs/buf_mem.h         |   5 +
libxfs/kmem.c            |  13 +
libxfs/libxfs_api_defs.h |  13 +
repair/agbtree.c         |  18 +-
repair/agbtree.h         |   1 +
repair/dinode.c          |   9 +-
repair/phase4.c          |  25 +-
repair/phase5.c          |   2 +-
repair/rmap.c            | 762 ++++++++++++++++++++++++++++++-----------------
repair/rmap.h            |  25 +-
repair/scan.c            |   7 +-
repair/slab.c            |  49 +--
repair/slab.h            |   2 +-
repair/xfs_repair.c      |   6 +
16 files changed, 602 insertions(+), 341 deletions(-)

