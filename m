Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA399ED1
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m4hsZvAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936D6C433C8;
	Thu,  7 Dec 2023 02:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916703;
	bh=wr2B0nd6lz7CIMhaRKkjrGdBO3vMpz9igJogtA4f4Ow=;
	h=Date:Subject:From:To:Cc:From;
	b=m4hsZvAFGajWbmxGZKXeFSAizN9eNZOe/ms9FnO6PHlNug2l41W761edPJa9qzX+L
	 yH5TD4ZdNiygld7mOJ4p7UaJggGA+VfgMpmYbb9R4h9YzABER9147Wsj4dKRBfPsId
	 eiLWYfvDDdt3qLjt6ZlAHCvgSaiLTuqg0OHvyAttc97cbiMXjLqV3e4E+x2qJXYJSQ
	 0rtiy+fc/sCEWZdexky/ZAwFWtWwHsYLh+iLSpRXhzoyvMfqglxs0gsPSvEZQnnyRB
	 6BZcZZ+dIiPz/mSGJSu+lTlTryHtn+BuOIg9Km0UhwVOejOOLJeBOP+7tcKL+U4cim
	 eIQIJ7C5DFoYQ==
Date: Wed, 06 Dec 2023 18:38:23 -0800
Subject: [PATCHSET v28.1 0/7] xfs: online repair of AG btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <170191665599.1181880.961660208270950504.stgit@frogsfrogsfrogs>
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

Now that we've spent a lot of time reworking common code in online fsck,
we're ready to start rebuilding the AG space btrees.  This series
implements repair functions for the free space, inode, and refcount
btrees.  Rebuilding the reverse mapping btree is much more intense and
is left for a subsequent patchset.  The fstests counterpart of this
patchset implements stress testing of repair.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-ag-btrees

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-ag-btrees

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-ag-btrees
---
 fs/xfs/Makefile                    |    4 
 fs/xfs/libxfs/xfs_ag.h             |   10 
 fs/xfs/libxfs/xfs_ag_resv.c        |    2 
 fs/xfs/libxfs/xfs_alloc.c          |   10 
 fs/xfs/libxfs/xfs_alloc.h          |    2 
 fs/xfs/libxfs/xfs_alloc_btree.c    |   13 -
 fs/xfs/libxfs/xfs_btree.c          |   26 +
 fs/xfs/libxfs/xfs_btree.h          |    2 
 fs/xfs/libxfs/xfs_ialloc.c         |   31 +
 fs/xfs/libxfs/xfs_ialloc.h         |    3 
 fs/xfs/libxfs/xfs_refcount.c       |    8 
 fs/xfs/libxfs/xfs_refcount.h       |    2 
 fs/xfs/libxfs/xfs_refcount_btree.c |   13 -
 fs/xfs/libxfs/xfs_types.h          |    7 
 fs/xfs/scrub/agb_bitmap.c          |  103 ++++
 fs/xfs/scrub/agb_bitmap.h          |   68 +++
 fs/xfs/scrub/agheader_repair.c     |   19 -
 fs/xfs/scrub/alloc.c               |   52 +-
 fs/xfs/scrub/alloc_repair.c        |  934 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/bitmap.c              |  509 +++++++++++++-------
 fs/xfs/scrub/bitmap.h              |  111 +---
 fs/xfs/scrub/common.c              |    1 
 fs/xfs/scrub/common.h              |   19 +
 fs/xfs/scrub/ialloc.c              |   39 +-
 fs/xfs/scrub/ialloc_repair.c       |  884 ++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/newbt.c               |   48 ++
 fs/xfs/scrub/newbt.h               |    3 
 fs/xfs/scrub/reap.c                |    6 
 fs/xfs/scrub/refcount.c            |    2 
 fs/xfs/scrub/refcount_repair.c     |  794 +++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.c              |  131 +++++
 fs/xfs/scrub/repair.h              |   43 ++
 fs/xfs/scrub/rmap.c                |    1 
 fs/xfs/scrub/scrub.c               |   30 +
 fs/xfs/scrub/scrub.h               |   15 -
 fs/xfs/scrub/trace.h               |  112 +++-
 fs/xfs/scrub/xfarray.h             |   22 +
 fs/xfs/xfs_extent_busy.c           |   13 +
 fs/xfs/xfs_extent_busy.h           |    2 
 39 files changed, 3709 insertions(+), 385 deletions(-)
 create mode 100644 fs/xfs/scrub/agb_bitmap.c
 create mode 100644 fs/xfs/scrub/agb_bitmap.h
 create mode 100644 fs/xfs/scrub/alloc_repair.c
 create mode 100644 fs/xfs/scrub/ialloc_repair.c
 create mode 100644 fs/xfs/scrub/refcount_repair.c

