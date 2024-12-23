Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9EF188596
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992891; cv=none; b=LGmQeEMR2mbeeB0fDjRf7J5TyEvEvuUgcye+2C6cWE8WvQU4THjt3iQnJfUK/LwhrwqxbTkCx0xsvD7DdNqSVsGwTgZXx7j4XtVPyVJI4Ulh6k1xzgwpA+eXtz2UcoDMy0414je+gAIdIn3ePUyT5s+I6QtIZS2pkawOLf3sCv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992891; c=relaxed/simple;
	bh=yoMm8c9zbZIilpjii4moUKjP8t2sRbTl5gxlbo1w0sk=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=SZpb8t7GiCiNTmaUPP+p1/6H6oxG6saaQQa1I0EJOql1W3xWSVqWqSrV5A0BeV7DUPQyDEGj0fmLZalM+F2GKeffCNuKptOo213m8fDezWf16a+ARFn/d2eaGIZOnxvNYm4L0WfsNDllPycZV9fqsOzXk94eaiI+Ycdca9qDJC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XIkzeZJG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XIkzeZJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D31C4CED3;
	Mon, 23 Dec 2024 22:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992891;
	bh=yoMm8c9zbZIilpjii4moUKjP8t2sRbTl5gxlbo1w0sk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XIkzeZJG/dO1LMqbAFL2tuKbTLUqtQFItZLe/40KAA7Leab6lXKcDEi1qd3gYuTVI
	 T6R4m/40OoGIQpPg7I89nY+B4LeCp16Z9DJWY8cdGyu5zuB9zgRzRvcP6kwitDH8jR
	 d9agN7KlB3muxBaydsqIYgY+97vmhv+nETHIYUhp8jiHnFpArtnhJ2II9+OXChCSFt
	 XgrojzCarzY3nox9ME1r8SjfIeSHKDUoKyHamiK7WiyxNVm3B7rQ1Te0hyhXXCDEld
	 XIs3qUN0Ot6uUWXmlaX64ze2xDAe+9Pf5HX8ymTOtS4IHbYVVLSsOWWnbmRMBAy9LU
	 aBFYqXhecTAyA==
Date: Mon, 23 Dec 2024 14:28:11 -0800
Subject: [GIT PULL 3/8] xfsprogs: metadata inode directory trees
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498954278.2301496.5347307190713994206.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 1d6b5c7e0476de97a15123768513cb3bb10803c7:

xfs: check metadata directory file path connectivity (2024-12-23 13:05:08 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/metadata-directory-tree_2024-12-23

for you to fetch changes up to cbb4fe589532389c8ae6a4e3018707d493b8c5f3:

mkfs.xfs: enable metadata directories (2024-12-23 13:05:10 -0800)

----------------------------------------------------------------
xfsprogs: metadata inode directory trees [v6.2 03/23]

This series delivers a new feature -- metadata inode directories.  This
is a separate directory tree (rooted in the superblock) that contains
only inodes that contain filesystem metadata.  Different metadata
objects can be looked up with regular paths.

We start by creating xfs_imeta_* functions to mediate access to metadata
inode pointers.  This enables the imeta code to abstract inode pointers,
whether they're the classic five in the superblock, or the much more
complex directory tree.  All current users of metadata inodes (rt+quota)
are converted to use the boilerplate code.

Next, we define the metadir on-disk format, which consists of marking
inodes with a new iflag that says they're metadata.  This we use to
prevent bulkstat and friends from ever getting their hands on fs
metadata.

Finally, we implement metadir operations so that clients can create,
delete, zap, and look up metadata inodes by path.  Beware that much of
this code is only lightly used, because the five current users of
metadata inodes don't tend to change them very often.  This is likely to
change if and when the subvolume and multiple-rt-volume features get
written/merged/etc.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (1):
xfs_repair: refactor generate_rtinfo

Darrick J. Wong (40):
libxfs: constify the xfs_inode predicates
libxfs: load metadata directory root at mount time
libxfs: enforce metadata inode flag
man2: document metadata directory flag in fsgeom ioctl
man: update scrub ioctl documentation for metadir
libfrog: report metadata directories in the geometry report
libfrog: allow METADIR in xfrog_bulkstat_single5
xfs_io: support scrubbing metadata directory paths
xfs_db: disable xfs_check when metadir is enabled
xfs_db: report metadir support for version command
xfs_db: don't obfuscate metadata directories and attributes
xfs_db: support metadata directories in the path command
xfs_db: show the metadata root directory when dumping superblocks
xfs_db: display di_metatype
xfs_db: drop the metadata checking code from blockget
xfs_io: support flag for limited bulkstat of the metadata directory
xfs_io: support scrubbing metadata directory paths
xfs_spaceman: report health of metadir inodes too
xfs_scrub: tread zero-length read verify as an IO error
xfs_scrub: scan metadata directories during phase 3
xfs_scrub: re-run metafile scrubbers during phase 5
xfs_repair: handle sb_metadirino correctly when zeroing supers
xfs_repair: dont check metadata directory dirent inumbers
xfs_repair: refactor fixing dotdot
xfs_repair: refactor marking of metadata inodes
xfs_repair: refactor root directory initialization
xfs_repair: refactor grabbing realtime metadata inodes
xfs_repair: check metadata inode flag
xfs_repair: use libxfs_metafile_iget for quota/rt inodes
xfs_repair: rebuild the metadata directory
xfs_repair: don't let metadata and regular files mix
xfs_repair: update incore metadata state whenever we create new files
xfs_repair: pass private data pointer to scan_lbtree
xfs_repair: mark space used by metadata files
xfs_repair: adjust keep_fsinos to handle metadata directories
xfs_repair: metadata dirs are never plausible root dirs
xfs_repair: drop all the metadata directory files during pass 4
xfs_repair: truncate and unmark orphaned metadata inodes
xfs_repair: do not count metadata directory files when doing quotacheck
mkfs.xfs: enable metadata directories

db/check.c                          | 290 +------------------
db/field.c                          |   2 +
db/field.h                          |   1 +
db/inode.c                          |  86 +++++-
db/inode.h                          |   2 +
db/metadump.c                       | 385 ++++++++++++-------------
db/namei.c                          |  71 ++++-
db/sb.c                             |  16 ++
include/xfs_inode.h                 |  12 +-
include/xfs_mount.h                 |   1 +
io/bulkstat.c                       |  16 +-
io/scrub.c                          |  62 ++++-
libfrog/bulkstat.c                  |   3 +-
libfrog/fsgeom.c                    |   6 +-
libfrog/scrub.c                     |  14 +-
libfrog/scrub.h                     |   2 +
libxfs/init.c                       |  26 ++
libxfs/inode.c                      |   9 +-
libxfs/libxfs_api_defs.h            |   4 +
man/man2/ioctl_xfs_fsgeometry.2     |   3 +
man/man2/ioctl_xfs_scrub_metadata.2 |  44 +++
man/man8/mkfs.xfs.8.in              |  11 +
man/man8/xfs_db.8                   |  35 ++-
man/man8/xfs_io.8                   |  13 +-
mkfs/lts_4.19.conf                  |   1 +
mkfs/lts_5.10.conf                  |   1 +
mkfs/lts_5.15.conf                  |   1 +
mkfs/lts_5.4.conf                   |   1 +
mkfs/lts_6.1.conf                   |   1 +
mkfs/lts_6.12.conf                  |   1 +
mkfs/lts_6.6.conf                   |   1 +
mkfs/proto.c                        |  68 ++++-
mkfs/xfs_mkfs.c                     |  33 ++-
repair/agheader.c                   |  11 +-
repair/dino_chunks.c                |  43 +++
repair/dinode.c                     | 196 +++++++++++--
repair/dinode.h                     |   6 +-
repair/dir2.c                       |  51 +++-
repair/globals.c                    |   8 +-
repair/globals.h                    |   8 +-
repair/incore.h                     |  63 ++++-
repair/incore_ino.c                 |   1 +
repair/phase1.c                     |   2 +
repair/phase2.c                     |  58 +++-
repair/phase4.c                     |  18 ++
repair/phase5.c                     |  12 +-
repair/phase6.c                     | 541 ++++++++++++++++++++++++------------
repair/pptr.c                       |  94 +++++++
repair/pptr.h                       |   2 +
repair/quotacheck.c                 |  22 +-
repair/rt.c                         | 189 ++++++++-----
repair/rt.h                         |  12 +-
repair/sb.c                         |   3 +
repair/scan.c                       |  43 ++-
repair/scan.h                       |   7 +-
repair/xfs_repair.c                 |  56 ++++
scrub/inodes.c                      |  11 +-
scrub/inodes.h                      |   5 +-
scrub/phase3.c                      |   7 +-
scrub/phase5.c                      | 102 ++++++-
scrub/phase6.c                      |  24 +-
scrub/read_verify.c                 |   8 +
scrub/scrub.c                       |  18 ++
scrub/scrub.h                       |   7 +
spaceman/health.c                   |   2 +
65 files changed, 1949 insertions(+), 903 deletions(-)

