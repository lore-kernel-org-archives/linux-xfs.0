Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD68519E985;
	Thu, 19 Dec 2024 19:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734635985; cv=none; b=FuHapTjODfaVUPfXV22gi+RQZKFlJdhjaEk6VJ4eLNUV+lm6arS9zRF+GYFOddyj07ezbLDouseSrQOUvkpG463hzfkKXiUn9yyUjSr72rxkDHqj1rlCx6IqqP2v+/5HR9C4kZqXRjq3pCnFM25Eduf7NXt3E0MoGPl99aRLxEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734635985; c=relaxed/simple;
	bh=DW4FCNsuu2MCfz/d4beeD+vZsbw48BowTsVezamCjBI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lmGsdZk2mFIPT7dA+6+wlWcZfNjooedcIZcuP0JobNhJlK/oui2tQKUwemrRza0o7+fwwlLE3o6YWE7OseIhHgUdezPWzNYeyG5MCeB1MTYyP85xvIqT8n22ocsxZ7kJ7w7v9DY8xdYzj2YrRetet/Q4EHvkO1ThQiaRxxcdMSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=COrKSqTC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="COrKSqTC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534C2C4CECE;
	Thu, 19 Dec 2024 19:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734635985;
	bh=DW4FCNsuu2MCfz/d4beeD+vZsbw48BowTsVezamCjBI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=COrKSqTCkXVWwVFDtpS8IhREpNb+Ns4MI3qUzL2KsDPL/Cl9Tu+8iWPis77BvNP3N
	 hw/U3LLv0jAXekgnNXxPjBO/tWVdAnrOOYnAwXO5Uiq17RkHQuXzrJrYKbpinO5fQ9
	 jFr/UGOgRNBypjY4DE9aF3TK74R8JYGT4GL/yxTf/ddB0s/1ZEACTaS9nUjAzs2bmH
	 GFUEFqX7+3gZU3H3kTxinNCPnujHhzl7AqTZJC9L/09YuMShwRZwNWANiGhUyV+ao3
	 wIFM3fichDrN+h9f/i1t6iyHwwnlFqwh9P9pacg+MIrWEHbaUlL1kuF4piqVoDatle
	 7ExIZZO1CC/ng==
Date: Thu, 19 Dec 2024 11:19:44 -0800
Subject: [PATCHSET v6.1 4/5] xfs: realtime reverse-mapping support
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
In-Reply-To: <20241219191553.GI6160@frogsfrogsfrogs>
References: <20241219191553.GI6160@frogsfrogsfrogs>
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

The next few patches enhance the reverse mapping routines to handle
the parts that are specific to rtgroups -- adding the new btree type,
adding a new log intent item type, and wiring up the metadata directory
tree entries.

Finally, implement GETFSMAP with the rtrmapbt and scrub functionality
for the rtrmapbt and rtbitmap and online fsck functionality.

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
Commits in this patchset:
 * xfs: add some rtgroup inode helpers
 * xfs: prepare rmap btree cursor tracepoints for realtime
 * xfs: simplify the xfs_rmap_{alloc,free}_extent calling conventions
 * xfs: introduce realtime rmap btree ondisk definitions
 * xfs: realtime rmap btree transaction reservations
 * xfs: add realtime rmap btree operations
 * xfs: prepare rmap functions to deal with rtrmapbt
 * xfs: add a realtime flag to the rmap update log redo items
 * xfs: support recovering rmap intent items targetting realtime extents
 * xfs: pretty print metadata file types in error messages
 * xfs: support file data forks containing metadata btrees
 * xfs: add realtime reverse map inode to metadata directory
 * xfs: add metadata reservations for realtime rmap btrees
 * xfs: wire up a new metafile type for the realtime rmap
 * xfs: wire up rmap map and unmap to the realtime rmapbt
 * xfs: create routine to allocate and initialize a realtime rmap btree inode
 * xfs: wire up getfsmap to the realtime reverse mapping btree
 * xfs: check that the rtrmapbt maxlevels doesn't increase when growing fs
 * xfs: report realtime rmap btree corruption errors to the health system
 * xfs: allow queued realtime intents to drain before scrubbing
 * xfs: scrub the realtime rmapbt
 * xfs: cross-reference realtime bitmap to realtime rmapbt scrubber
 * xfs: cross-reference the realtime rmapbt
 * xfs: scan rt rmap when we're doing an intense rmap check of bmbt mappings
 * xfs: scrub the metadir path of rt rmap btree files
 * xfs: walk the rt reverse mapping tree when rebuilding rmap
 * xfs: online repair of realtime file bmaps
 * xfs: repair inodes that have realtime extents
 * xfs: repair rmap btree inodes
 * xfs: online repair of realtime bitmaps for a realtime group
 * xfs: support repairing metadata btrees rooted in metadir inodes
 * xfs: online repair of the realtime rmap btree
 * xfs: create a shadow rmap btree during realtime rmap repair
 * xfs: hook live realtime rmap operations during a repair operation
 * xfs: don't shut down the filesystem for media failures beyond end of log
 * xfs: react to fsdax failure notifications on the rt device
 * xfs: enable realtime rmap btree
---
 fs/xfs/Makefile                   |    3 
 fs/xfs/libxfs/xfs_btree.c         |   73 +++
 fs/xfs/libxfs/xfs_btree.h         |    8 
 fs/xfs/libxfs/xfs_btree_mem.c     |    1 
 fs/xfs/libxfs/xfs_btree_staging.c |    1 
 fs/xfs/libxfs/xfs_defer.h         |    1 
 fs/xfs/libxfs/xfs_exchmaps.c      |    4 
 fs/xfs/libxfs/xfs_format.h        |   28 +
 fs/xfs/libxfs/xfs_fs.h            |    7 
 fs/xfs/libxfs/xfs_health.h        |    4 
 fs/xfs/libxfs/xfs_inode_buf.c     |   32 +
 fs/xfs/libxfs/xfs_inode_fork.c    |   25 +
 fs/xfs/libxfs/xfs_log_format.h    |    6 
 fs/xfs/libxfs/xfs_log_recover.h   |    2 
 fs/xfs/libxfs/xfs_metafile.c      |   18 +
 fs/xfs/libxfs/xfs_metafile.h      |    2 
 fs/xfs/libxfs/xfs_ondisk.h        |    2 
 fs/xfs/libxfs/xfs_refcount.c      |    6 
 fs/xfs/libxfs/xfs_rmap.c          |  171 +++++-
 fs/xfs/libxfs/xfs_rmap.h          |   12 
 fs/xfs/libxfs/xfs_rtbitmap.c      |    2 
 fs/xfs/libxfs/xfs_rtbitmap.h      |    9 
 fs/xfs/libxfs/xfs_rtgroup.c       |   53 +-
 fs/xfs/libxfs/xfs_rtgroup.h       |   49 ++
 fs/xfs/libxfs/xfs_rtrmap_btree.c  | 1011 +++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h  |  210 ++++++++
 fs/xfs/libxfs/xfs_sb.c            |    6 
 fs/xfs/libxfs/xfs_shared.h        |   14 +
 fs/xfs/libxfs/xfs_trans_resv.c    |   12 
 fs/xfs/libxfs/xfs_trans_space.h   |   13 
 fs/xfs/scrub/alloc_repair.c       |    5 
 fs/xfs/scrub/bmap.c               |  108 +++-
 fs/xfs/scrub/bmap_repair.c        |  129 +++++
 fs/xfs/scrub/common.c             |  160 ++++++
 fs/xfs/scrub/common.h             |   23 +
 fs/xfs/scrub/health.c             |    1 
 fs/xfs/scrub/inode.c              |   10 
 fs/xfs/scrub/inode_repair.c       |  136 +++++
 fs/xfs/scrub/metapath.c           |    3 
 fs/xfs/scrub/newbt.c              |   42 ++
 fs/xfs/scrub/newbt.h              |    1 
 fs/xfs/scrub/reap.c               |   41 ++
 fs/xfs/scrub/reap.h               |    2 
 fs/xfs/scrub/repair.c             |  191 +++++++
 fs/xfs/scrub/repair.h             |   17 +
 fs/xfs/scrub/rgsuper.c            |    6 
 fs/xfs/scrub/rmap_repair.c        |   84 +++
 fs/xfs/scrub/rtbitmap.c           |   75 ++-
 fs/xfs/scrub/rtbitmap.h           |   55 ++
 fs/xfs/scrub/rtbitmap_repair.c    |  429 +++++++++++++++-
 fs/xfs/scrub/rtrmap.c             |  271 ++++++++++
 fs/xfs/scrub/rtrmap_repair.c      |  903 +++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rtsummary.c          |   17 -
 fs/xfs/scrub/rtsummary_repair.c   |    3 
 fs/xfs/scrub/scrub.c              |   11 
 fs/xfs/scrub/scrub.h              |   14 +
 fs/xfs/scrub/stats.c              |    1 
 fs/xfs/scrub/tempexch.h           |    2 
 fs/xfs/scrub/tempfile.c           |   20 -
 fs/xfs/scrub/trace.c              |    1 
 fs/xfs/scrub/trace.h              |  228 ++++++++
 fs/xfs/xfs_buf.c                  |    1 
 fs/xfs/xfs_buf_item_recover.c     |    4 
 fs/xfs/xfs_drain.c                |   20 -
 fs/xfs/xfs_drain.h                |    7 
 fs/xfs/xfs_fsmap.c                |  174 ++++++
 fs/xfs/xfs_fsops.c                |   11 
 fs/xfs/xfs_health.c               |    1 
 fs/xfs/xfs_inode.c                |   19 +
 fs/xfs/xfs_inode_item.c           |    2 
 fs/xfs/xfs_inode_item_recover.c   |   44 +-
 fs/xfs/xfs_log_recover.c          |    2 
 fs/xfs/xfs_mount.c                |    5 
 fs/xfs/xfs_mount.h                |    9 
 fs/xfs/xfs_notify_failure.c       |  230 +++++---
 fs/xfs/xfs_notify_failure.h       |   11 
 fs/xfs/xfs_qm.c                   |    8 
 fs/xfs/xfs_rmap_item.c            |  216 +++++++-
 fs/xfs/xfs_rtalloc.c              |   82 ++-
 fs/xfs/xfs_rtalloc.h              |   10 
 fs/xfs/xfs_stats.c                |    4 
 fs/xfs/xfs_stats.h                |    2 
 fs/xfs/xfs_super.c                |    6 
 fs/xfs/xfs_super.h                |    1 
 fs/xfs/xfs_trace.h                |  104 ++--
 85 files changed, 5381 insertions(+), 366 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtrmap_btree.c
 create mode 100644 fs/xfs/libxfs/xfs_rtrmap_btree.h
 create mode 100644 fs/xfs/scrub/rtrmap.c
 create mode 100644 fs/xfs/scrub/rtrmap_repair.c
 create mode 100644 fs/xfs/xfs_notify_failure.h

