Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47811D8DE0
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881008; cv=none; b=eCwptBygDS4Nve95LjTFP1nqAz9GefGEEibT+fJpHlLeAilnoQRIjl5Kbxym/z88tg8scI3l5tCd70KjVcfyFwb89SuRNdS02+sJLYYqffbtWltzRR4rce+ZaipjrshMm5p38xR1PAn6gg+RNjrlbNR7Zsb0XiYb1BBTCSZILRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881008; c=relaxed/simple;
	bh=JHWOe0iDv5tZvFJtdve0iepEjBB1s3lRayiw3M6JjKs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MkYm8BQ2UbQ7desviRERn2W2VxG5TcsgAeW0Dgze41UXnBt5uHr79muH3EbsqucRAr3W1pYQ64d4S/GWLJHFvKmnL9j4muMNey+H8FzkyJr3ngJ4kL8VSZsY4Yb+Uh+7XwQ8mce/E+Cdda0ot7UQKtt+2c29MG09l44NkDpxnW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OfLkLgWU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OfLkLgWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FCCC4CEDD;
	Thu,  6 Feb 2025 22:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881008;
	bh=JHWOe0iDv5tZvFJtdve0iepEjBB1s3lRayiw3M6JjKs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OfLkLgWUBlQb46mrOPA2UXgJ+1DxptLl70RThzn5RPsz/nAxKtyICa4UCcs3xSNQd
	 Naua1y/yDGF7KkXSfn0QN85cixRvvNNEKEuuxNKJ19bPgC9EI+LGeiuKGoZCZ0diXn
	 pbM+L8nC49/4hjXXZJP4PvJrJB1rzeO+f2XWk3z+HrSRIXRtNOn/cL6ZqdO67f9N0C
	 m58kytFEQ2wcPJG9KdXynOb9hXgLefHGMTc0cteuE/0ZtaFfXnGHR6ss17+iWdZFGv
	 u6cLqDWH1cgV9PBLF1EbI0ULsjsBf2Nhx0QnAr4XgBXo/1B68iYvV7y6WntTSTXACX
	 cgfx2dG6uuZag==
Date: Thu, 06 Feb 2025 14:30:07 -0800
Subject: [PATCHSET v6.3 3/5] xfsprogs: realtime reverse-mapping support
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
In-Reply-To: <20250206222122.GA21808@frogsfrogsfrogs>
References: <20250206222122.GA21808@frogsfrogsfrogs>
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
 * libxfs: compute the rt rmap btree maxlevels during initialization
 * libxfs: add a realtime flag to the rmap update log redo items
 * libfrog: enable scrubbing of the realtime rmap
 * man: document userspace API changes due to rt rmap
 * xfs_db: compute average btree height
 * xfs_db: don't abort when bmapping on a non-extents/bmbt fork
 * xfs_db: display the realtime rmap btree contents
 * xfs_db: support the realtime rmapbt
 * xfs_db: copy the realtime rmap btree
 * xfs_db: make fsmap query the realtime reverse mapping tree
 * xfs_db: add an rgresv command
 * xfs_spaceman: report health status of the realtime rmap btree
 * xfs_repair: tidy up rmap_diffkeys
 * xfs_repair: flag suspect long-format btree blocks
 * xfs_repair: use realtime rmap btree data to check block types
 * xfs_repair: create a new set of incore rmap information for rt groups
 * xfs_repair: refactor realtime inode check
 * xfs_repair: find and mark the rtrmapbt inodes
 * xfs_repair: check existing realtime rmapbt entries against observed rmaps
 * xfs_repair: always check realtime file mappings against incore info
 * xfs_repair: rebuild the realtime rmap btree
 * xfs_repair: check for global free space concerns with default btree slack levels
 * xfs_repair: rebuild the bmap btree for realtime files
 * xfs_repair: reserve per-AG space while rebuilding rt metadata
 * xfs_logprint: report realtime RUIs
 * mkfs: add some rtgroup inode helpers
 * mkfs: create the realtime rmap inode
---
 db/bmap.c                             |   17 +
 db/bmroot.c                           |  149 +++++++++++
 db/bmroot.h                           |    2 
 db/btblock.c                          |  103 ++++++++
 db/btblock.h                          |    5 
 db/btdump.c                           |   63 +++++
 db/btheight.c                         |   36 +++
 db/field.c                            |   11 +
 db/field.h                            |    5 
 db/fsmap.c                            |  149 +++++++++++
 db/info.c                             |  119 +++++++++
 db/inode.c                            |   24 ++
 db/metadump.c                         |  120 +++++++++
 db/type.c                             |    5 
 db/type.h                             |    1 
 include/libxfs.h                      |    1 
 libfrog/scrub.c                       |   10 +
 libxfs/defer_item.c                   |   35 ++-
 libxfs/init.c                         |   19 +
 libxfs/libxfs_api_defs.h              |   24 ++
 logprint/log_misc.c                   |    2 
 logprint/log_print_all.c              |    8 +
 logprint/log_redo.c                   |   24 +-
 man/man2/ioctl_xfs_rtgroup_geometry.2 |    3 
 man/man2/ioctl_xfs_scrub_metadata.2   |   12 +
 man/man8/xfs_db.8                     |   74 +++++-
 mkfs/proto.c                          |   31 ++
 mkfs/xfs_mkfs.c                       |   87 ++++++-
 repair/Makefile                       |    1 
 repair/agbtree.c                      |    5 
 repair/bmap_repair.c                  |  109 ++++++++
 repair/bulkload.c                     |   41 +++
 repair/bulkload.h                     |    2 
 repair/dino_chunks.c                  |   13 +
 repair/dinode.c                       |  441 ++++++++++++++++++++++++++++-----
 repair/dir2.c                         |    7 +
 repair/globals.c                      |    6 
 repair/globals.h                      |    2 
 repair/incore.h                       |    1 
 repair/phase4.c                       |   14 +
 repair/phase5.c                       |  114 ++++++++-
 repair/phase6.c                       |   72 +++++
 repair/rmap.c                         |  403 ++++++++++++++++++++++++------
 repair/rmap.h                         |   15 +
 repair/rt.h                           |    4 
 repair/rtrmap_repair.c                |  265 ++++++++++++++++++++
 repair/scan.c                         |  411 ++++++++++++++++++++++++++++++-
 repair/scan.h                         |   37 +++
 repair/xfs_repair.c                   |    8 -
 scrub/repair.c                        |    1 
 spaceman/health.c                     |   10 +
 51 files changed, 2905 insertions(+), 216 deletions(-)
 create mode 100644 repair/rtrmap_repair.c

