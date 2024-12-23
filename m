Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC94188596
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992938; cv=none; b=GRV4AnFWkRc3WKWkRnVXozAsWg3ekMcb4OWnomxxnC1PQuleTSdoHNKpzbr7711Htq/IVrI2Hlji78pP5AEuVFLwqM39T0quqyPzmrIbCPhwGVfFz+hUvCcZGOD4eBv4GCgiddVsxas5yQ6NrD69e55WwIwTw/LKUqaVNN061XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992938; c=relaxed/simple;
	bh=lsXk95TMJNW8dcssx0aPttlh0FedxiTHKbqu2UP6LMw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=Im2eZ/TRd9h6+k5avQC2izI1evIsVRyksH/2SGD+nbu5hVsOi2EX51U2rWI9mBBl/e0tyFtIobLPHD6QkBqG2yMPQU5+SLPcGxlfbOqiGj4xdKHtRrX5EuCkPwrOgsKkui2MKuRsmUXV7zD+BW7h/VLL2h0T2W9gTwoc8zNtitA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eTHrr660; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eTHrr660"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935A0C4CED3;
	Mon, 23 Dec 2024 22:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992938;
	bh=lsXk95TMJNW8dcssx0aPttlh0FedxiTHKbqu2UP6LMw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eTHrr660rxIrdYL0D7fAokqXuQ5ZwA88PmZPjidTDkt0gykNQUmM2ki5h6GrPYJhg
	 xe+6HgLPo1nO6a6zB0AfJMkK03PSYDMa64KJ3R7pP4QT0v+Uh8r9XLCWuGxAjpL+aP
	 Ge3jijzZ4thALx4G77u72OoSLFoRnpWdYGt4t+o68HAjTirgURjSkeclzmzLHHuqAb
	 3rlwQaVUU9VflfoHgBWXS0HR6n/IM2tYp4rcuxs2UE4TInkFbTAAI/Zzlipn0s4243
	 tedo8IyF70NrOG9llSR4wfzw/QEHCuhEFsQpTaRclXeBrrDfX4mYAEXQlmTLtsY6tQ
	 j8bTWasGU/xug==
Date: Mon, 23 Dec 2024 14:28:58 -0800
Subject: [GIT PULL 6/8] xfsprogs: shard the realtime section
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498954557.2301496.5119943743542526225.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241223212904.GQ6174@frogsfrogsfrogs>
References: <20241223212904.GQ6174@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.11-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 80b81c84f015ee01fed80c32184cc763ee1a655e:

xfs: return from xfs_symlink_verify early on V4 filesystems (2024-12-23 13:05:13 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/realtime-groups_2024-12-23

for you to fetch changes up to be4f8d6c422045b7934b8763f013996d49627b00:

mkfs: format realtime groups (2024-12-23 13:05:16 -0800)

----------------------------------------------------------------
xfsprogs: shard the realtime section [v6.2 06/23]

Right now, the realtime section uses a single pair of metadata inodes to
store the free space information.  This presents a scalability problem
since every thread trying to allocate or free rt extents have to lock
these files.  Solve this problem by sharding the realtime section into
separate realtime allocation groups.

While we're at it, define a superblock to be stamped into the start of
the rt section.  This enables utilities such as blkid to identify block
devices containing realtime sections, and avoids the situation where
anything written into block 0 of the realtime extent can be
misinterpreted as file data.

The best advantage for rtgroups will become evident later when we get to
adding rmap and reflink to the realtime volume, since the geometry
constraints are the same for rt groups and AGs.  Hence we can reuse all
that code directly.

This is a very large patchset, but it catches us up with 20 years of
technical debt that have accumulated.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (6):
man: document rgextents geom field
xfs_repair: refactor phase4
xfs_repair: simplify rt_lock handling
xfs_repair: add a real per-AG bitmap abstraction
xfs_db: metadump metadir rt bitmap and summary files
xfs_scrub: cleanup fsmap keys initialization

Darrick J. Wong (45):
libxfs: remove XFS_ILOCK_RT*
libxfs: adjust xfs_fsb_to_db to handle segmented rtblocks
xfs_repair,mkfs: port to libxfs_rt{bitmap,summary}_create
libxfs: use correct rtx count to block count conversion
libfrog: scrub the realtime group superblock
man: document the rt group geometry ioctl
libxfs: port userspace deferred log item to handle rtgroups
libxfs: implement some sanity checking for enormous rgcount
libfrog: support scrubbing rtgroup metadata paths
libfrog: report rt groups in output
libfrog: add bitmap_clear
xfs_logprint: report realtime EFIs
xfs_repair: adjust rtbitmap/rtsummary word updates to handle big endian values
xfs_repair: refactor offsetof+sizeof to offsetofend
xfs_repair: improve rtbitmap discrepancy reporting
xfs_repair: support realtime groups
xfs_repair: find and clobber rtgroup bitmap and summary files
xfs_repair: support realtime superblocks
xfs_repair: repair rtbitmap and rtsummary block headers
xfs_db: enable the rtblock and rtextent commands for segmented rt block numbers
xfs_db: enable rtconvert to handle segmented rtblocks
xfs_db: listify the definition of enum typnm
xfs_db: support dumping realtime group data and superblocks
xfs_db: support changing the label and uuid of rt superblocks
xfs_db: enable conversion of rt space units
xfs_db: metadump realtime devices
xfs_db: dump rt bitmap blocks
xfs_db: dump rt summary blocks
xfs_db: report rt group and block number in the bmap command
xfs_io: support scrubbing rtgroup metadata
xfs_io: support scrubbing rtgroup metadata paths
xfs_io: add a command to display allocation group information
xfs_io: add a command to display realtime group information
xfs_io: display rt group in verbose bmap output
xfs_io: display rt group in verbose fsmap output
xfs_mdrestore: refactor open-coded fd/is_file into a structure
xfs_mdrestore: restore rt group superblocks to realtime device
xfs_spaceman: report on realtime group health
xfs_scrub: scrub realtime allocation group metadata
xfs_scrub: check rtgroup metadata directory connections
xfs_scrub: call GETFSMAP for each rt group in parallel
xfs_scrub: trim realtime volumes too
xfs_scrub: use histograms to speed up phase 8 on the realtime volume
mkfs: add headers to realtime bitmap blocks
mkfs: format realtime groups

db/Makefile                           |   1 +
db/block.c                            |  34 ++-
db/bmap.c                             |  56 +++-
db/command.c                          |   2 +
db/convert.c                          | 118 +++++++-
db/field.c                            |  20 ++
db/field.h                            |  10 +
db/inode.c                            |  36 ++-
db/metadump.c                         |  59 +++-
db/rtgroup.c                          | 154 +++++++++++
db/rtgroup.h                          |  21 ++
db/sb.c                               | 117 +++++++-
db/type.c                             |  16 ++
db/type.h                             |  32 ++-
db/xfs_metadump.sh                    |   5 +-
include/xfs.h                         |  15 +
include/xfs_metadump.h                |   8 +
io/Makefile                           |   1 +
io/aginfo.c                           | 215 +++++++++++++++
io/bmap.c                             |  27 +-
io/fsmap.c                            |  22 +-
io/init.c                             |   1 +
io/io.h                               |   1 +
io/scrub.c                            |  81 +++++-
libfrog/bitmap.c                      |  25 +-
libfrog/bitmap.h                      |   1 +
libfrog/div64.h                       |   6 +
libfrog/fsgeom.c                      |  24 +-
libfrog/fsgeom.h                      |  16 ++
libfrog/scrub.c                       |  24 +-
libfrog/scrub.h                       |   1 +
libfrog/util.c                        |  12 +
libfrog/util.h                        |   1 +
libxfs/defer_item.c                   |  73 +++--
libxfs/init.c                         |  46 ++++
libxfs/libxfs_api_defs.h              |   5 +
libxfs/libxfs_priv.h                  |   8 -
libxfs/topology.c                     |  42 +++
libxfs/topology.h                     |   3 +
libxfs/trans.c                        |   2 +-
libxfs/util.c                         |   2 +-
logprint/log_misc.c                   |   2 +
logprint/log_print_all.c              |   8 +
logprint/log_redo.c                   |  57 +++-
man/man2/ioctl_xfs_fsgeometry.2       |   6 +-
man/man2/ioctl_xfs_rtgroup_geometry.2 |  99 +++++++
man/man2/ioctl_xfs_scrub_metadata.2   |   9 +
man/man8/mkfs.xfs.8.in                |  31 +++
man/man8/xfs_db.8                     |  34 ++-
man/man8/xfs_io.8                     |  29 +-
man/man8/xfs_mdrestore.8              |  10 +
man/man8/xfs_metadump.8               |  11 +
man/man8/xfs_spaceman.8               |   5 +-
mdrestore/xfs_mdrestore.c             | 163 ++++++-----
mkfs/proto.c                          | 139 +++++++---
mkfs/xfs_mkfs.c                       | 281 ++++++++++++++++++-
repair/agheader.c                     |  27 +-
repair/agheader.h                     |  10 +
repair/dino_chunks.c                  |  58 ++--
repair/dinode.c                       | 162 +++++++----
repair/dir2.c                         |  13 +-
repair/globals.c                      |   3 -
repair/globals.h                      |   6 +-
repair/incore.c                       | 235 +++++++++++-----
repair/incore.h                       |  36 ++-
repair/incore_ext.c                   |   3 +-
repair/phase2.c                       |  51 ++--
repair/phase3.c                       |   4 +
repair/phase4.c                       | 221 ++++++++-------
repair/phase5.c                       |   2 +-
repair/phase6.c                       | 180 +++++++++++-
repair/rmap.c                         |   4 +-
repair/rt.c                           | 506 +++++++++++++++++++++++++++++-----
repair/rt.h                           |  23 ++
repair/sb.c                           |  41 +++
repair/scan.c                         |  36 +--
repair/xfs_repair.c                   |  19 +-
scrub/phase2.c                        | 124 ++++++---
scrub/phase5.c                        |  24 +-
scrub/phase6.c                        |  17 +-
scrub/phase7.c                        |   7 +
scrub/phase8.c                        |  36 ++-
scrub/repair.c                        |   1 +
scrub/scrub.c                         |   7 +
scrub/scrub.h                         |  13 +-
scrub/spacemap.c                      | 102 +++++--
scrub/xfs_scrub.c                     |   2 +
scrub/xfs_scrub.h                     |   1 +
spaceman/health.c                     |  63 ++++-
89 files changed, 3545 insertions(+), 719 deletions(-)
create mode 100644 db/rtgroup.c
create mode 100644 db/rtgroup.h
create mode 100644 io/aginfo.c
create mode 100644 man/man2/ioctl_xfs_rtgroup_geometry.2

