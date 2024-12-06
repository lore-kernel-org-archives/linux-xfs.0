Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7638E22C6DC
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733527648; cv=none; b=TuFlQzKewqLVvstRBdlHU+Fn9xuV6wfAuK1eGIAlA4G/jzzVt6uwP5YWVFsA/4/7i1CSd2Z1/klbVImObSsswHIHv5DvINndhZVYDB6HY6JtSO9iFvA0D057O9tpa+rAqztnaGudZ/qjmNX5bG+pFDcDQYEnrT60m62rW+4Cxm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733527648; c=relaxed/simple;
	bh=vMYjRVssX+xS2t07dKdjb+u8GeaGdjNThrIQU1tveN0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sh7g/bGNE4gYFtp8sS5fevIvJekbEwFgrvQLiJsfKkodbzhZcZoJfizlQGfGGw2X5buK94Bw/kuE0IjkWJeMTUJFoQUMtSFYtdaszoToxeGCbKBAyBne8GFqWTSWNk6+QWAd2lHX2e0cX6ZpnBgBrvHhKJyn+82fekh/19wRZMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ULzIKZ3F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ULzIKZ3F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE5EC4CED1;
	Fri,  6 Dec 2024 23:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733527647;
	bh=vMYjRVssX+xS2t07dKdjb+u8GeaGdjNThrIQU1tveN0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ULzIKZ3FP1hbFX+1e8/s2cJGQxBjHTVE8f3SjAHOYOil6ad+IYxf2FWN5BrYnmlNa
	 /cP0/UPMb3exBcwZrjNxzP+rIvE9rpe/p7Tk+XGGgbptSkk/DzKOZnlDWRxGRU4cel
	 wxcmyoIATy6eZIyiHgCAPQkObNyz4pekWlsUPsiRz+kIecec6ZFpe0PLq0e00G5CN6
	 S5Wns3t2ZBtrtapk7n6VrOVW0ClvkblsknfrRPsqnt36C453jwhzZasI3MfwZuChl5
	 0DFU4Gb6PcEHP6yPLBtGlhOSuZjsNLXmmB0jdhGJYHM1byj6BvOiWq4Dp+jedySXns
	 xli0I8TFaYsSw==
Date: Fri, 06 Dec 2024 15:27:26 -0800
Subject: [PATCHSET v5.8 3/9] xfsprogs: metadata inode directory trees
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
In-Reply-To: <20241206232259.GO7837@frogsfrogsfrogs>
References: <20241206232259.GO7837@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

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

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadata-directory-tree

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadata-directory-tree
---
Commits in this patchset:
 * libxfs: constify the xfs_inode predicates
 * libxfs: load metadata directory root at mount time
 * libxfs: enforce metadata inode flag
 * man2: document metadata directory flag in fsgeom ioctl
 * man: update scrub ioctl documentation for metadir
 * libfrog: report metadata directories in the geometry report
 * libfrog: allow METADIR in xfrog_bulkstat_single5
 * xfs_io: support scrubbing metadata directory paths
 * xfs_db: disable xfs_check when metadir is enabled
 * xfs_db: report metadir support for version command
 * xfs_db: don't obfuscate metadata directories and attributes
 * xfs_db: support metadata directories in the path command
 * xfs_db: show the metadata root directory when dumping superblocks
 * xfs_db: display di_metatype
 * xfs_io: support the bulkstat metadata directory flag
 * xfs_io: support scrubbing metadata directory paths
 * xfs_spaceman: report health of metadir inodes too
 * xfs_scrub: tread zero-length read verify as an IO error
 * xfs_scrub: scan metadata directories during phase 3
 * xfs_scrub: re-run metafile scrubbers during phase 5
 * xfs_repair: preserve the metadirino field when zeroing supers
 * xfs_repair: dont check metadata directory dirent inumbers
 * xfs_repair: refactor fixing dotdot
 * xfs_repair: refactor marking of metadata inodes
 * xfs_repair: refactor root directory initialization
 * xfs_repair: refactor grabbing realtime metadata inodes
 * xfs_repair: check metadata inode flag
 * xfs_repair: use libxfs_metafile_iget for quota/rt inodes
 * xfs_repair: rebuild the metadata directory
 * xfs_repair: don't let metadata and regular files mix
 * xfs_repair: update incore metadata state whenever we create new files
 * xfs_repair: pass private data pointer to scan_lbtree
 * xfs_repair: mark space used by metadata files
 * xfs_repair: adjust keep_fsinos to handle metadata directories
 * xfs_repair: metadata dirs are never plausible root dirs
 * xfs_repair: drop all the metadata directory files during pass 4
 * xfs_repair: truncate and unmark orphaned metadata inodes
 * xfs_repair: do not count metadata directory files when doing quotacheck
 * xfs_repair: fix maximum file offset comparison
 * xfs_repair: refactor generate_rtinfo
 * mkfs.xfs: enable metadata directories
---
 db/check.c                          |    6 
 db/field.c                          |    2 
 db/field.h                          |    1 
 db/inode.c                          |   86 +++++-
 db/inode.h                          |    2 
 db/metadump.c                       |  385 ++++++++++++-------------
 db/namei.c                          |   71 ++++-
 db/sb.c                             |   16 +
 include/xfs_inode.h                 |   12 -
 include/xfs_mount.h                 |    1 
 io/bulkstat.c                       |   16 +
 io/scrub.c                          |   62 ++++
 libfrog/bulkstat.c                  |    3 
 libfrog/fsgeom.c                    |    6 
 libfrog/scrub.c                     |   14 +
 libfrog/scrub.h                     |    2 
 libxfs/init.c                       |   26 ++
 libxfs/inode.c                      |    9 +
 libxfs/libxfs_api_defs.h            |    4 
 man/man2/ioctl_xfs_fsgeometry.2     |    3 
 man/man2/ioctl_xfs_scrub_metadata.2 |   44 +++
 man/man8/mkfs.xfs.8.in              |   11 +
 man/man8/xfs_db.8                   |   23 +
 man/man8/xfs_io.8                   |   13 +
 mkfs/lts_4.19.conf                  |    1 
 mkfs/lts_5.10.conf                  |    1 
 mkfs/lts_5.15.conf                  |    1 
 mkfs/lts_5.4.conf                   |    1 
 mkfs/lts_6.1.conf                   |    1 
 mkfs/lts_6.12.conf                  |    1 
 mkfs/lts_6.6.conf                   |    1 
 mkfs/proto.c                        |   68 ++++
 mkfs/xfs_mkfs.c                     |   33 ++
 repair/agheader.c                   |   11 +
 repair/dino_chunks.c                |   43 +++
 repair/dinode.c                     |  198 +++++++++++--
 repair/dinode.h                     |    6 
 repair/dir2.c                       |   51 +++
 repair/globals.c                    |    9 -
 repair/globals.h                    |    9 -
 repair/incore.h                     |   63 +++-
 repair/incore_ino.c                 |    1 
 repair/phase1.c                     |    2 
 repair/phase2.c                     |   58 +++-
 repair/phase4.c                     |   18 +
 repair/phase5.c                     |   12 +
 repair/phase6.c                     |  547 +++++++++++++++++++++++------------
 repair/pptr.c                       |   94 ++++++
 repair/pptr.h                       |    2 
 repair/prefetch.c                   |    2 
 repair/quotacheck.c                 |   22 +
 repair/rt.c                         |  189 ++++++++----
 repair/rt.h                         |   12 -
 repair/sb.c                         |    3 
 repair/scan.c                       |   43 ++-
 repair/scan.h                       |    7 
 repair/versions.c                   |    7 
 repair/xfs_repair.c                 |   56 ++++
 scrub/inodes.c                      |   11 +
 scrub/inodes.h                      |    5 
 scrub/phase3.c                      |    7 
 scrub/phase5.c                      |  102 ++++++-
 scrub/phase6.c                      |   24 +-
 scrub/read_verify.c                 |    8 +
 scrub/scrub.c                       |   18 +
 scrub/scrub.h                       |    7 
 spaceman/health.c                   |    2 
 67 files changed, 1958 insertions(+), 617 deletions(-)

