Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF16A51
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YAmKb5g4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882D0C433C8;
	Thu,  7 Dec 2023 02:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701917555;
	bh=tDznKGQjNcW4t8YDEmLox1vJE9vnOu51pz+W9B56a6g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YAmKb5g4vTvdd0GTv59/i7bJv2jVonI1ysRuuStxp904bhQfrUlnIFQjFxUbUNrJa
	 n5xKtIuv6lzrj1opdw5dgwV+sxPzDYg2lGP8CZ5mK9sfxEe704ZYebBlH/eZdUT1zA
	 cpwy8ZFsdUs9JKTyJr4wpjRjEsp2GAvqqiAEYH+nPVaJu3DjfF+K+KlqeC/xTTKxdx
	 3qcNZ8nFF3g/3yMyKtfzwwjU0loQrEwql/27b46yROzfoNdvjkpQERSM3kr6SHppWM
	 t7fbu2FEOHEj4ZOceylEHYJUHuUUL61g+c5L++br2AyEbmDcxwdfUkyXgErQNfYs31
	 SIAOcvVWt7dIQ==
Date: Wed, 6 Dec 2023 18:52:35 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org
Cc: dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL 3/3] xfs: reserve disk space for online repairs
Message-ID: <20231207025235.GQ361584@frogsfrogsfrogs>
References: <170191728637.1193846.13594475500319328405.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191728637.1193846.13594475500319328405.stg-ugh@frogsfrogsfrogs>

Scratch all these PRs too, I'll reissue them since I decided that I
could go ahead and tack on the first couple of series from online repair
and that must've tweaked all the git commit hashes.

--D

On Wed, Dec 06, 2023 at 06:49:07PM -0800, Darrick J. Wong wrote:
> Hi Chandan,
> 
> Please pull this branch with changes for xfs for 6.8-rc1.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> --D
> 
> The following changes since commit 3f113c2739b1b068854c7ffed635c2bd790d1492:
> 
> xfs: make xchk_iget safer in the presence of corrupt inode btrees (2023-12-06 18:45:17 -0800)
> 
> are available in the Git repository at:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-auto-reap-space-reservations-6.8_2023-12-06
> 
> for you to fetch changes up to 3f3cec031099c37513727efc978a12b6346e326d:
> 
> xfs: force small EFIs for reaping btree extents (2023-12-06 18:45:19 -0800)
> 
> ----------------------------------------------------------------
> xfs: reserve disk space for online repairs [v28.1]
> 
> Online repair fixes metadata structures by writing a new copy out to
> disk and atomically committing the new structure into the filesystem.
> For this to work, we need to reserve all the space we're going to need
> ahead of time so that the atomic commit transaction is as small as
> possible.  We also require the reserved space to be freed if the system
> goes down, or if we decide not to commit the repair, or if we reserve
> too much space.
> 
> To keep the atomic commit transaction as small as possible, we would
> like to allocate some space and simultaneously schedule automatic
> reaping of the reserved space, even on log recovery.  EFIs are the
> mechanism to get us there, but we need to use them in a novel manner.
> Once we allocate the space, we want to hold on to the EFI (relogging as
> necessary) until we can commit or cancel the repair.  EFIs for written
> committed blocks need to go away, but unwritten or uncommitted blocks
> can be freed like normal.
> 
> Earlier versions of this patchset directly manipulated the log items,
> but Dave thought that to be a layering violation.  For v27, I've
> modified the defer ops handling code to be capable of pausing a deferred
> work item.  Log intent items are created as they always have been, but
> paused items are pushed onto a side list when finishing deferred work
> items, and pushed back onto the transaction after that.  Log intent done
> item are not created for paused work.
> 
> The second part adds a "stale" flag to the EFI so that the repair
> reservation code can dispose of an EFI the normal way, but without the
> space actually being freed.
> 
> This has been lightly tested with fstests.  Enjoy!
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> ----------------------------------------------------------------
> Darrick J. Wong (8):
> xfs: don't append work items to logged xfs_defer_pending objects
> xfs: allow pausing of pending deferred work items
> xfs: remove __xfs_free_extent_later
> xfs: automatic freeing of freshly allocated unwritten space
> xfs: remove unused fields from struct xbtree_ifakeroot
> xfs: implement block reservation accounting for btrees we're staging
> xfs: log EFIs for all btree blocks being used to stage a btree
> xfs: force small EFIs for reaping btree extents
> 
> fs/xfs/Makefile                    |   1 +
> fs/xfs/libxfs/xfs_ag.c             |   2 +-
> fs/xfs/libxfs/xfs_alloc.c          | 104 +++++++-
> fs/xfs/libxfs/xfs_alloc.h          |  22 +-
> fs/xfs/libxfs/xfs_bmap.c           |   4 +-
> fs/xfs/libxfs/xfs_bmap_btree.c     |   2 +-
> fs/xfs/libxfs/xfs_btree_staging.h  |   6 -
> fs/xfs/libxfs/xfs_defer.c          | 261 ++++++++++++++++---
> fs/xfs/libxfs/xfs_defer.h          |  20 +-
> fs/xfs/libxfs/xfs_ialloc.c         |   5 +-
> fs/xfs/libxfs/xfs_ialloc_btree.c   |   2 +-
> fs/xfs/libxfs/xfs_refcount.c       |   6 +-
> fs/xfs/libxfs/xfs_refcount_btree.c |   2 +-
> fs/xfs/scrub/newbt.c               | 513 +++++++++++++++++++++++++++++++++++++
> fs/xfs/scrub/newbt.h               |  65 +++++
> fs/xfs/scrub/reap.c                |   7 +-
> fs/xfs/scrub/trace.h               |  37 +++
> fs/xfs/xfs_extfree_item.c          |   9 +-
> fs/xfs/xfs_reflink.c               |   2 +-
> fs/xfs/xfs_trace.h                 |  13 +-
> 20 files changed, 1007 insertions(+), 76 deletions(-)
> create mode 100644 fs/xfs/scrub/newbt.c
> create mode 100644 fs/xfs/scrub/newbt.h
> 
> 
