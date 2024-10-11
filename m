Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0D233E7
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728606952; cv=none; b=qX4JXAqTXm2XO+VnqtDIiWvF5dkamc3SW6Elyv0bfgvzIIcNpqHKcRCsNmJWk1pQx11qjHh1DJbDBvJYC4WIJOXX/35W7r6nCrUFlUYzSxXYTl35WYzdeVaBMq99nxzbJnR/QtS2FIzaZXNrgW/sOzSHBRbKpHvck1EJ7yrmVPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728606952; c=relaxed/simple;
	bh=zqDtT7foUvL5zF2A7o1KjrJKXCGNXR4I5xJrTPjGxO8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XgfzJy2P/ht53iT3pMsC1xAG+lBGkkO639q+UpIh9ybeYgirkxc5pwLdLqaOdyPPFO0CSSMiwxEgYS3C96dJOhAYWHiDAW9/uU2JkC7Ir+QzIG/64atTxrbrfEb8YiLkWkQN4DR87BtjPqFa8lsFNkdla6prGYElt1CuAh3ZVPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uzOgp9fx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uzOgp9fx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081F6C4CECC;
	Fri, 11 Oct 2024 00:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728606952;
	bh=zqDtT7foUvL5zF2A7o1KjrJKXCGNXR4I5xJrTPjGxO8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uzOgp9fxDnwhSBr3M03S0UyTxWXaKQEI8YukuqCPYpSGe9gK0IWsZ08UL5BMdOJu+
	 LT0ZOAbVhH984MiOAOgpShwSRDzZcX7JJuih5fKXUqpZ0xZ9LUMa2iQ2hsPZtFj2CT
	 zcGIF9EgFDS4ZFYve82sKs0vL/K9xn3aUB6MJSwwbo+f5gCx2B+4Ma1SskRc6wOqWA
	 Oy0FfwX4vD9qa9pVuT1CErJehwT13/pmhXQObZdiz9WVanlmqO4L390P/SOTnt05uj
	 G4CyePeV4xpQUKrFmUwlJ9L/0j2JpPF6AT93xvyy0OFWD4ZbrK4BCEogd1f+pqs/49
	 Od8M+Qm5RXf1Q==
Date: Thu, 10 Oct 2024 17:35:51 -0700
Subject: [PATCHSET v5.0 1/5] xfsprogs: metadata inode directory trees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
In-Reply-To: <20241011002402.GB21877@frogsfrogsfrogs>
References: <20241011002402.GB21877@frogsfrogsfrogs>
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
 * xfs_repair: check metadir superblock padding fields
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
 * mkfs: add a utility to generate protofiles
---
 db/check.c               |    6 +
 db/field.c               |    2 
 db/field.h               |    1 
 db/inode.c               |   86 ++++++-
 db/inode.h               |    2 
 db/metadump.c            |  385 +++++++++++++++-----------------
 db/namei.c               |   71 +++++-
 db/sb.c                  |   32 +++
 io/bulkstat.c            |   16 +
 io/scrub.c               |   62 +++++
 libfrog/bulkstat.c       |    3 
 libfrog/fsgeom.c         |    6 -
 libfrog/scrub.c          |   14 +
 libfrog/scrub.h          |    2 
 libxfs/libxfs_api_defs.h |    4 
 man/man8/mkfs.xfs.8.in   |   11 +
 man/man8/xfs_db.8        |   23 ++
 man/man8/xfs_io.8        |   13 +
 man/man8/xfs_protofile.8 |   33 +++
 mkfs/Makefile            |   10 +
 mkfs/lts_4.19.conf       |    1 
 mkfs/lts_5.10.conf       |    1 
 mkfs/lts_5.15.conf       |    1 
 mkfs/lts_5.4.conf        |    1 
 mkfs/lts_6.1.conf        |    1 
 mkfs/lts_6.6.conf        |    1 
 mkfs/proto.c             |   68 ++++++
 mkfs/xfs_mkfs.c          |   29 ++
 mkfs/xfs_protofile.in    |  152 +++++++++++++
 repair/agheader.c        |    5 
 repair/dino_chunks.c     |   43 ++++
 repair/dinode.c          |  198 ++++++++++++++---
 repair/dinode.h          |    6 -
 repair/dir2.c            |   51 ++++
 repair/globals.c         |    9 -
 repair/globals.h         |    9 -
 repair/incore.h          |   63 ++++-
 repair/incore_ino.c      |    1 
 repair/phase1.c          |    2 
 repair/phase2.c          |   58 ++++-
 repair/phase4.c          |   18 ++
 repair/phase5.c          |   12 +
 repair/phase6.c          |  547 +++++++++++++++++++++++++++++++---------------
 repair/pptr.c            |   94 ++++++++
 repair/pptr.h            |    2 
 repair/prefetch.c        |    2 
 repair/quotacheck.c      |   22 ++
 repair/rt.c              |  189 ++++++++++------
 repair/rt.h              |   12 -
 repair/sb.c              |    8 +
 repair/scan.c            |   43 +++-
 repair/scan.h            |    7 -
 repair/versions.c        |    7 -
 repair/xfs_repair.c      |   56 +++++
 scrub/inodes.c           |   11 +
 scrub/inodes.h           |    5 
 scrub/phase3.c           |    7 +
 scrub/phase5.c           |  102 ++++++++-
 scrub/phase6.c           |   24 ++
 scrub/read_verify.c      |    8 +
 scrub/scrub.c            |   18 ++
 scrub/scrub.h            |    7 +
 spaceman/health.c        |    2 
 63 files changed, 2073 insertions(+), 612 deletions(-)
 create mode 100644 man/man8/xfs_protofile.8
 create mode 100644 mkfs/xfs_protofile.in

