Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CF32C86B
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JUNXs6b1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A679C433C7;
	Fri, 24 Nov 2023 23:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700869505;
	bh=LeJRiLCHEReUe5Pi1VPc8u5cb/JCAHzJcXBGIko2XHc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JUNXs6b1qN/4goEUyi4wn08hCYCmnpiMe4nC/xNjFwpL4RHKa5sZAYKN7fLYft8gk
	 VsRm3Ry8Uv9DVUyOIV9/fwyvb2LLscrWSzIEfh9h5MQNglKbKZGlJh3w/6EiHeFJ6l
	 FRf9iLfYmz9xvxS1IiN3kTf3MUoqJMfcrdqiAYsMhlzMLgiVQ+d76dKVPMblX8p2B0
	 Lcp5/AMa9o+VIDZnB1ikyy4hZzBJnrnRcm8XBG1cCPz/8EIGukdCF59QvNFUm7wo/j
	 +OAuKg9tvYRpx5j/A/9LIry/Mvf69ubH7VHPGpnuwEziNrxJypQkp0Wn4q2Sh6K6RE
	 A+dy9E5M47w/g==
Date: Fri, 24 Nov 2023 15:45:04 -0800
Subject: [PATCHSET v28.0 0/7] xfs: reserve disk space for online repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
In-Reply-To: <20231124233940.GK36190@frogsfrogsfrogs>
References: <20231124233940.GK36190@frogsfrogsfrogs>
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

Online repair fixes metadata structures by writing a new copy out to
disk and atomically committing the new structure into the filesystem.
For this to work, we need to reserve all the space we're going to need
ahead of time so that the atomic commit transaction is as small as
possible.  We also require the reserved space to be freed if the system
goes down, or if we decide not to commit the repair, or if we reserve
too much space.

To keep the atomic commit transaction as small as possible, we would
like to allocate some space and simultaneously schedule automatic
reaping of the reserved space, even on log recovery.  EFIs are the
mechanism to get us there, but we need to use them in a novel manner.
Once we allocate the space, we want to hold on to the EFI (relogging as
necessary) until we can commit or cancel the repair.  EFIs for written
committed blocks need to go away, but unwritten or uncommitted blocks
can be freed like normal.

Earlier versions of this patchset directly manipulated the log items,
but Dave thought that to be a layering violation.  For v27, I've
modified the defer ops handling code to be capable of pausing a deferred
work item.  Log intent items are created as they always have been, but
paused items are pushed onto a side list when finishing deferred work
items, and pushed back onto the transaction after that.  Log intent done
item are not created for paused work.

The second part adds a "stale" flag to the EFI so that the repair
reservation code can dispose of an EFI the normal way, but without the
space actually being freed.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-auto-reap-space-reservations

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-auto-reap-space-reservations
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_ag.c             |    2 
 fs/xfs/libxfs/xfs_alloc.c          |  104 +++++++
 fs/xfs/libxfs/xfs_alloc.h          |   22 +-
 fs/xfs/libxfs/xfs_bmap.c           |    4 
 fs/xfs/libxfs/xfs_bmap_btree.c     |    2 
 fs/xfs/libxfs/xfs_btree_staging.h  |    7 
 fs/xfs/libxfs/xfs_defer.c          |  229 ++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h          |   20 +
 fs/xfs/libxfs/xfs_ialloc.c         |    5 
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 
 fs/xfs/libxfs/xfs_refcount.c       |    6 
 fs/xfs/libxfs/xfs_refcount_btree.c |    2 
 fs/xfs/scrub/agheader_repair.c     |    1 
 fs/xfs/scrub/common.c              |    1 
 fs/xfs/scrub/newbt.c               |  510 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/newbt.h               |   65 +++++
 fs/xfs/scrub/reap.c                |    7 
 fs/xfs/scrub/scrub.c               |    2 
 fs/xfs/scrub/trace.h               |   37 +++
 fs/xfs/xfs_extfree_item.c          |   12 -
 fs/xfs/xfs_reflink.c               |    2 
 fs/xfs/xfs_trace.h                 |   13 +
 23 files changed, 990 insertions(+), 66 deletions(-)
 create mode 100644 fs/xfs/scrub/newbt.c
 create mode 100644 fs/xfs/scrub/newbt.h

