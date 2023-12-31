Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75CAB65D
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E3Gfgj00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890FEC433C7;
	Sun, 31 Dec 2023 19:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051441;
	bh=pjUTsHdKb/4kgxoYjHyiJ3L+ZY2NPQckCEf+kxD7vdk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E3Gfgj00s8rsva2JPyajMFEQXw//YYhXuzmcNaHeeldu1tTD19r/BTLm8ZSv5iJ1G
	 yCJwcZ9NVjAm1VQA5g/52Tc+B6NhWiwfCViHzIaHJhmOMbAM/MbjgES8ndsA7CiqZ4
	 RNR1MUyWQ8TRu60XL+JGfRvWrn8oqkjrzGDm9g/fpoHnp0jNyVTeigBPV1mCU7V7vP
	 meHePivGu2vAlyvpvkLz4H22+Z3v2jdZzahyN0LL4SbwR0O+rP3hC6JX+qccpE4Ubq
	 Fl69CGcPiHdFY3Pjy6ZGkg+93lO/cFBMMjJHBjnfMLDoKExr8VQyB7Ttdh6y4TRrCE
	 kh4jdOKvJmWUA==
Date: Sun, 31 Dec 2023 11:37:21 -0800
Subject: [PATCHSET v2.0 11/15] xfs: realtime reverse-mapping support
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182323.GU361584@frogsfrogsfrogs>
References: <20231231182323.GU361584@frogsfrogsfrogs>
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

This is the latest revision of a patchset that adds to XFS kernel
support for reverse mapping for the realtime device.  This time around
I've fixed some of the bitrot that I've noticed over the past few
months, and most notably have converted rtrmapbt to use the metadata
inode directory feature instead of burning more space in the superblock.

At the beginning of the set are patches to implement storing B+tree
leaves in an inode root, since the realtime rmapbt is rooted in an
inode, unlike the regular rmapbt which is rooted in an AG block.
Prior to this, the only btree that could be rooted in the inode fork
was the block mapping btree; if all the extent records fit in the
inode, format would be switched from 'btree' to 'extents'.

The next few patches widen the reverse mapping routines to fit the
64-bit numbers required to store information about the realtime
device and establish a new b+tree type (rtrmapbt) for the realtime
variant of the rmapbt.  After that are a few patches to handle rooting
the rtrmapbt in a specific inode that's referenced by the superblock.

Finally, there are patches to implement GETFSMAP with the rtrmapbt and
scrub functionality for the rtrmapbt and rtbitmap; and then wire up the
online scrub functionality.  We also enhance EFIs to support tracking
freeing of realtime extents so that when rmap is turned on we can
maintain the same order of operations as the regular rmap code.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-rmap

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-rmap

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-rmap

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-rmap
---
 fs/xfs/Makefile                  |    3 
 fs/xfs/libxfs/xfs_bmap.c         |   23 +
 fs/xfs/libxfs/xfs_btree.c        |   78 +++
 fs/xfs/libxfs/xfs_btree.h        |    7 
 fs/xfs/libxfs/xfs_defer.h        |    1 
 fs/xfs/libxfs/xfs_format.h       |   24 +
 fs/xfs/libxfs/xfs_fs.h           |    6 
 fs/xfs/libxfs/xfs_fs_staging.h   |    1 
 fs/xfs/libxfs/xfs_health.h       |    4 
 fs/xfs/libxfs/xfs_inode_buf.c    |   26 +
 fs/xfs/libxfs/xfs_inode_fork.c   |   13 
 fs/xfs/libxfs/xfs_log_format.h   |    6 
 fs/xfs/libxfs/xfs_log_recover.h  |    2 
 fs/xfs/libxfs/xfs_ondisk.h       |    2 
 fs/xfs/libxfs/xfs_refcount.c     |    6 
 fs/xfs/libxfs/xfs_rmap.c         |  198 +++++++
 fs/xfs/libxfs/xfs_rmap.h         |   25 +
 fs/xfs/libxfs/xfs_rtgroup.c      |   12 
 fs/xfs/libxfs/xfs_rtgroup.h      |   20 +
 fs/xfs/libxfs/xfs_rtrmap_btree.c | 1030 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h |  217 ++++++++
 fs/xfs/libxfs/xfs_sb.c           |    6 
 fs/xfs/libxfs/xfs_shared.h       |    2 
 fs/xfs/libxfs/xfs_swapext.c      |    4 
 fs/xfs/libxfs/xfs_trans_resv.c   |   12 
 fs/xfs/libxfs/xfs_trans_space.h  |   13 
 fs/xfs/libxfs/xfs_types.h        |    5 
 fs/xfs/scrub/alloc_repair.c      |   10 
 fs/xfs/scrub/bmap.c              |  133 ++++-
 fs/xfs/scrub/bmap_repair.c       |  128 +++++
 fs/xfs/scrub/common.c            |  165 ++++++
 fs/xfs/scrub/common.h            |   18 +
 fs/xfs/scrub/health.c            |    1 
 fs/xfs/scrub/inode.c             |   10 
 fs/xfs/scrub/inode_repair.c      |  116 ++++
 fs/xfs/scrub/metapath.c          |   27 +
 fs/xfs/scrub/newbt.c             |   43 ++
 fs/xfs/scrub/newbt.h             |    1 
 fs/xfs/scrub/reap.c              |   41 ++
 fs/xfs/scrub/reap.h              |    2 
 fs/xfs/scrub/repair.c            |  229 ++++++++
 fs/xfs/scrub/repair.h            |   28 +
 fs/xfs/scrub/rmap_repair.c       |   36 +
 fs/xfs/scrub/rtbitmap.c          |   80 +++
 fs/xfs/scrub/rtbitmap.h          |   59 ++
 fs/xfs/scrub/rtbitmap_repair.c   |  676 +++++++++++++++++++++++++
 fs/xfs/scrub/rtrmap.c            |  283 ++++++++++
 fs/xfs/scrub/rtrmap_repair.c     |  946 +++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rtsummary_repair.c  |    3 
 fs/xfs/scrub/scrub.c             |   13 
 fs/xfs/scrub/scrub.h             |   14 +
 fs/xfs/scrub/stats.c             |    1 
 fs/xfs/scrub/tempfile.c          |   15 -
 fs/xfs/scrub/tempswap.h          |    2 
 fs/xfs/scrub/trace.c             |    1 
 fs/xfs/scrub/trace.h             |  249 +++++++++
 fs/xfs/scrub/xfbtree.c           |    3 
 fs/xfs/xfs_bmap_item.c           |   11 
 fs/xfs/xfs_buf_item_recover.c    |    4 
 fs/xfs/xfs_drain.c               |   93 +++
 fs/xfs/xfs_drain.h               |   28 +
 fs/xfs/xfs_extfree_item.c        |   14 -
 fs/xfs/xfs_fsmap.c               |  464 ++++++++++++-----
 fs/xfs/xfs_fsops.c               |   12 
 fs/xfs/xfs_health.c              |    4 
 fs/xfs/xfs_inode.c               |   19 +
 fs/xfs/xfs_inode_item.c          |    2 
 fs/xfs/xfs_inode_item_recover.c  |   33 +
 fs/xfs/xfs_log_recover.c         |    2 
 fs/xfs/xfs_mount.c               |    5 
 fs/xfs/xfs_mount.h               |   10 
 fs/xfs/xfs_rmap_item.c           |  254 +++++++++
 fs/xfs/xfs_rtalloc.c             |  246 +++++++++
 fs/xfs/xfs_rtalloc.h             |    5 
 fs/xfs/xfs_super.c               |    6 
 fs/xfs/xfs_trace.c               |   18 +
 fs/xfs/xfs_trace.h               |  136 ++++-
 77 files changed, 6111 insertions(+), 334 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtrmap_btree.c
 create mode 100644 fs/xfs/libxfs/xfs_rtrmap_btree.h
 create mode 100644 fs/xfs/scrub/rtrmap.c
 create mode 100644 fs/xfs/scrub/rtrmap_repair.c

