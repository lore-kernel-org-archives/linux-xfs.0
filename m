Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5E5199FC9;
	Tue, 25 Feb 2025 17:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740504447; cv=none; b=EOsx75Itf3N++xG4YHt938ec8FLnCb81BLRic1Q1w2dz6p7fsCf6eU+BGyq73fNggYZTG+2wVoYxvbU8KoS6QnIjmWJ8WkzfdWzZZr167xknrhD94lt68WvCdIA8qHxrHYA6xI9N2H/qLr+VB3tdY2RjqKf2J/bxENgeHHAOLWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740504447; c=relaxed/simple;
	bh=knHl1Uycl3abThDtjAZHscR5obNSJh0b7lJdDLhcLwQ=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=GCvw3MpmBJ2Ew+qG+FKd+c40fp17jomAFAPaR/c8HN85h2kVMwJDeGU3EvQ0AAePoIc9i0hzVKOy4v+XEaDi+JClHw2omwKKPSL/Kft9EzJNb8Pm4obESSwaLHBP84XC3PSYnT2rrtaMptcJupjHAFNsVl3TN0BRVSAoMyT2VZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZWu6gEao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZWu6gEao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC01C4CEDD;
	Tue, 25 Feb 2025 17:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740504446;
	bh=knHl1Uycl3abThDtjAZHscR5obNSJh0b7lJdDLhcLwQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZWu6gEaom6KlN/OVyKQpWXZgX2dj6kfkr0JhOb1MLAyYJDyJOAsZr1ybwc/RU01o5
	 kPgoad3dpQvrig3Oa12v75EUzW9Wi176QC6gJt4MYERtiBNkb0pyIWeukA+h07JXit
	 Sgj1ctlJGc1ZIFnSj2eBl1NVyTofN7S+7YwrqWb+dPi7c6N968Pf8zsz2q6vAmNDza
	 fi2cq5Z9OIbjdB+p4WkRj/KIJfyREO7ohWMiHVPnQkL9uJo/aVKUunbWkjEyCLKa4T
	 M8lkRxgHRgfv/a6IAFUjRaESVj7/oP7s1LmNU4IvTp7XE2NEHG1hbvfcdTlkSNC2LQ
	 sgJ21JauM0EgA==
Date: Tue, 25 Feb 2025 09:27:26 -0800
Subject: [GIT PULL 4/7] xfsprogs: realtime reverse-mapping support
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, chandanbabu@kernel.org, cmaiolino@redhat.com, dchinner@redhat.com, hch@lst.de, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, mtodorovac69@gmail.com
Message-ID: <174050432930.404908.1425459884688248861.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250225172123.GB6242@frogsfrogsfrogs>
References: <20250225172123.GB6242@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.14-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit c89b1f70b43dc7d1dd7147d5147170db651131a4:

xfs: fix the entry condition of exact EOF block allocation optimization (2025-02-25 09:16:00 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/realtime-rmap-6.14_2025-02-25

for you to fetch changes up to d3fc26fa2ac96c39836884525065f5d47dda8b05:

mkfs: create the realtime rmap inode (2025-02-25 09:16:01 -0800)

----------------------------------------------------------------
xfsprogs: realtime reverse-mapping support [v6.6 4/7]

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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (3):
xfs: mark xfs_dir_isempty static
xfs: remove XFS_ILOG_NONCORE
xfs: constify feature checks

Darrick J. Wong (26):
libxfs: compute the rt rmap btree maxlevels during initialization
libxfs: add a realtime flag to the rmap update log redo items
libfrog: enable scrubbing of the realtime rmap
man: document userspace API changes due to rt rmap
xfs_db: compute average btree height
xfs_db: don't abort when bmapping on a non-extents/bmbt fork
xfs_db: display the realtime rmap btree contents
xfs_db: support the realtime rmapbt
xfs_db: copy the realtime rmap btree
xfs_db: make fsmap query the realtime reverse mapping tree
xfs_db: add an rgresv command
xfs_spaceman: report health status of the realtime rmap btree
xfs_repair: tidy up rmap_diffkeys
xfs_repair: flag suspect long-format btree blocks
xfs_repair: use realtime rmap btree data to check block types
xfs_repair: create a new set of incore rmap information for rt groups
xfs_repair: refactor realtime inode check
xfs_repair: find and mark the rtrmapbt inodes
xfs_repair: check existing realtime rmapbt entries against observed rmaps
xfs_repair: always check realtime file mappings against incore info
xfs_repair: rebuild the realtime rmap btree
xfs_repair: check for global free space concerns with default btree slack levels
xfs_repair: rebuild the bmap btree for realtime files
xfs_repair: reserve per-AG space while rebuilding rt metadata
xfs_logprint: report realtime RUIs
mkfs: create the realtime rmap inode

Mirsad Todorovac (1):
xfs/libxfs: replace kmalloc() and memcpy() with kmemdup()

db/bmroot.h                           |   2 +
db/btblock.h                          |   5 +
db/field.h                            |   5 +
db/type.h                             |   1 +
include/kmem.h                        |   9 +
include/libxfs.h                      |   1 +
include/xfs_mount.h                   |  12 +-
libxfs/libxfs_api_defs.h              |  24 ++
libxfs/xfs_dir2.h                     |   1 -
libxfs/xfs_log_format.h               |   6 -
repair/bulkload.h                     |   2 +
repair/globals.h                      |   2 +
repair/incore.h                       |   1 +
repair/rmap.h                         |  15 +-
repair/rt.h                           |   4 +
repair/scan.h                         |  37 +++
db/bmap.c                             |  17 +-
db/bmroot.c                           | 135 +++++++++++
db/btblock.c                          | 103 ++++++++
db/btdump.c                           |  63 +++++
db/btheight.c                         |  36 +++
db/field.c                            |  11 +
db/fsmap.c                            | 149 +++++++++++-
db/info.c                             | 119 +++++++++
db/inode.c                            |  24 +-
db/metadump.c                         | 120 +++++++++
db/type.c                             |   5 +
libfrog/scrub.c                       |  10 +
libxfs/defer_item.c                   |  35 ++-
libxfs/init.c                         |  19 +-
libxfs/xfs_dir2.c                     |   9 +-
libxfs/xfs_rtgroup.c                  |   2 +-
logprint/log_misc.c                   |   2 +
logprint/log_print_all.c              |   8 +
logprint/log_redo.c                   |  24 +-
man/man2/ioctl_xfs_rtgroup_geometry.2 |   3 +
man/man2/ioctl_xfs_scrub_metadata.2   |  12 +-
man/man8/xfs_db.8                     |  74 +++++-
mkfs/proto.c                          |  29 +++
mkfs/xfs_mkfs.c                       |  87 ++++++-
repair/Makefile                       |   1 +
repair/agbtree.c                      |   5 +-
repair/bmap_repair.c                  | 109 ++++++++-
repair/bulkload.c                     |  41 ++++
repair/dino_chunks.c                  |  13 +
repair/dinode.c                       | 441 +++++++++++++++++++++++++++++-----
repair/dir2.c                         |   7 +
repair/globals.c                      |   6 +
repair/phase4.c                       |  14 ++
repair/phase5.c                       | 114 ++++++++-
repair/phase6.c                       |  72 ++++++
repair/rmap.c                         | 403 ++++++++++++++++++++++++-------
repair/rtrmap_repair.c                | 265 ++++++++++++++++++++
repair/scan.c                         | 411 ++++++++++++++++++++++++++++++-
repair/xfs_repair.c                   |   8 +-
scrub/repair.c                        |   1 +
spaceman/health.c                     |  10 +
57 files changed, 2910 insertions(+), 234 deletions(-)
create mode 100644 repair/rtrmap_repair.c

