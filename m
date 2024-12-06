Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC76E22C6DC
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733527381; cv=none; b=hdRdBpOOgXiSM8AkMKbNk98mprFpH0ws81xpdovva7zx1DX3geXJCXGGpGCc3VaKruaLFQsczQeN7/V5NRrXXeOKDG/AyvSmF43DvfKJFwhD8vM8L8Xvbm0tZ5b51wO/bIL3mcLwUy6NtueAsJtBzkcxBx9Bl6thhEjSdpYRQIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733527381; c=relaxed/simple;
	bh=a4nZl0FiV9I+RXI/TEMrrz5ryU9bEl+07gwTfRXrhoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=C15tGR3obgn4PAMnQBpRz7c7t9pFvYa6rPJTSUbTYMuLsx1I/tUilxyLmlWopBTPEAfGY5oroGZsnuHSQbG295s+qFahRUAN8NcSIar2hEIQLbDDS1R4FMlIfdvyvICgx1OmpZL48JUgRsRPIkO+gKbFjQWeXcUb6azNBtsHcDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u/y9eXmj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u/y9eXmj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60667C4CED1;
	Fri,  6 Dec 2024 23:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733527381;
	bh=a4nZl0FiV9I+RXI/TEMrrz5ryU9bEl+07gwTfRXrhoQ=;
	h=Date:From:To:Cc:Subject:From;
	b=u/y9eXmjhjEpHj+WW5ykvkW7X8LqEKVJblsUAvc4jDgqQNssT3GdFtsWDOpnqzCVd
	 aS0QtJgUZcMtmsqlD7WSWF4qSRJeFc7tJb+XGMilY06cEBvFyv1nLJDdqYt2fdgM8z
	 H64kpliz7dK9fydCVA9BfAnGCCIqXG3dhLjaBdiHNLPImzETbExHRlhIuXE/eSfKlC
	 vv4lUoYcqjGzFVFsA/PqJb00/wTyySuQ5zoDu6/yeslE1op4Y3KjhSh8LV2HNuaTW9
	 v+MDl9Wa57Y66ocw/U8uoOWnvxYopKk3P71uUMIAVsd5hACirvyuFysYATadVbOz2b
	 SFJJYUmSowCnQ==
Date: Fri, 6 Dec 2024 15:22:59 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [PATCHBOMB v5.8] xfsprogs: metadata directories and realtime groups
Message-ID: <20241206232259.GO7837@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andrey and Christoph,

This begins the first round of review of userspace support for the
metadata directory tree and realtime allocation group code that was
merged into kernel 6.13-rc1.

The first patchset contains bug fixes against xfsprogs 6.12.  I think
they're minor enough that they might as well get rolled into xfsprogs
6.13.

This time around, I'm presenting the libxfs sync for 6.13 a bit
differently than I've done traditionally.  Whereas I usually do all the
kernel sync and only then go to work on the surrounding utilities, I
noticed that the conversion of xfs_perag to be a subclass of generic
xfs_group objects and the introduction of xfs_rtgroup objects causes a
lot of changes in the utilities.

As a result, I decided that it'd be easier to take care of the libxfs
sync for only the metadata directory tree code and the utility changes
*before* moving on to the allocation groups restructuring.  That's why
there are nine patchsets instead of five.  I hope that makes it easier
to tackle.

The second and third patchsets are all the metadir changes.

The fourth patchset augments the mkfs protofile code so that we can
handle large files and xattrs; and provides a tool to generate a
protofile from a directory tree.  Protofiles have existed in Unix for 51
years now, we should modernize our implementation a bit, or possibly
just withdraw it.

Patchsets 5 and 6 are the rest of the 6.13 merge.  Eventually this will
become one patchset, but not all of my bugfixes have made it into the
kernel yet.  I'll be resending bugfixes II shortly after this.

Patchset 7 are the utility changes to handle realtime allocation groups.

Patchsets 8-9 update the utilities for the quota file changes that we
made for metadir filesystems.

As always, you can browse / pull the branch from here:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-quotas_2024-12-06

These are the patches that have not yet been reviewed:

[PATCHSET 1/9] xfsprogs: bug fixes for 6.12
  [PATCH 2/2] man: document the -n parent mkfs option
[PATCHSET v5.8 3/9] xfsprogs: metadata inode directory trees
  [PATCH 04/41] man2: document metadata directory flag in fsgeom ioctl
  [PATCH 05/41] man: update scrub ioctl documentation for metadir
  [PATCH 06/41] libfrog: report metadata directories in the geometry
  [PATCH 07/41] libfrog: allow METADIR in xfrog_bulkstat_single5
  [PATCH 08/41] xfs_io: support scrubbing metadata directory paths
  [PATCH 09/41] xfs_db: disable xfs_check when metadir is enabled
  [PATCH 10/41] xfs_db: report metadir support for version command
  [PATCH 11/41] xfs_db: don't obfuscate metadata directories and
  [PATCH 12/41] xfs_db: support metadata directories in the path
  [PATCH 13/41] xfs_db: show the metadata root directory when dumping
  [PATCH 14/41] xfs_db: display di_metatype
  [PATCH 15/41] xfs_io: support the bulkstat metadata directory flag
  [PATCH 16/41] xfs_io: support scrubbing metadata directory paths
  [PATCH 17/41] xfs_spaceman: report health of metadir inodes too
  [PATCH 18/41] xfs_scrub: tread zero-length read verify as an IO error
  [PATCH 19/41] xfs_scrub: scan metadata directories during phase 3
  [PATCH 20/41] xfs_scrub: re-run metafile scrubbers during phase 5
  [PATCH 21/41] xfs_repair: preserve the metadirino field when zeroing
  [PATCH 22/41] xfs_repair: dont check metadata directory dirent
  [PATCH 23/41] xfs_repair: refactor fixing dotdot
  [PATCH 24/41] xfs_repair: refactor marking of metadata inodes
  [PATCH 25/41] xfs_repair: refactor root directory initialization
  [PATCH 26/41] xfs_repair: refactor grabbing realtime metadata inodes
  [PATCH 27/41] xfs_repair: check metadata inode flag
  [PATCH 28/41] xfs_repair: use libxfs_metafile_iget for quota/rt
  [PATCH 29/41] xfs_repair: rebuild the metadata directory
  [PATCH 30/41] xfs_repair: don't let metadata and regular files mix
  [PATCH 31/41] xfs_repair: update incore metadata state whenever we
  [PATCH 32/41] xfs_repair: pass private data pointer to scan_lbtree
  [PATCH 33/41] xfs_repair: mark space used by metadata files
  [PATCH 34/41] xfs_repair: adjust keep_fsinos to handle metadata
  [PATCH 35/41] xfs_repair: metadata dirs are never plausible root dirs
  [PATCH 36/41] xfs_repair: drop all the metadata directory files
  [PATCH 37/41] xfs_repair: truncate and unmark orphaned metadata
  [PATCH 38/41] xfs_repair: do not count metadata directory files when
  [PATCH 39/41] xfs_repair: fix maximum file offset comparison
  [PATCH 41/41] mkfs.xfs: enable metadata directories
[PATCHSET v5.8 4/9] mkfs: make protofiles less janky
  [PATCH 1/4] libxfs: resync libxfs_alloc_file_space interface with the
  [PATCH 2/4] mkfs: support copying in large or sparse files
  [PATCH 3/4] mkfs: support copying in xattrs
  [PATCH 4/4] mkfs: add a utility to generate protofiles
[PATCHSET 5/9] xfsprogs: new code for 6.13
  [PATCH 11/46] libfrog: add memchr_inv
[PATCHSET 6/9] xfsprogs: bug fixes for 6.13
  [PATCH 1/6] xfs: return a 64-bit block count from
  [PATCH 2/6] xfs: fix error bailout in xfs_rtginode_create
  [PATCH 5/6] xfs: fix sb_spino_align checks for large fsblock sizes
  [PATCH 6/6] xfs: return from xfs_symlink_verify early on V4
[PATCHSET v5.8 7/9] xfsprogs: shard the realtime section
  [PATCH 02/50] libxfs: adjust xfs_fsb_to_db to handle segmented
  [PATCH 03/50] xfs_repair,mkfs: port to
  [PATCH 04/50] libxfs: use correct rtx count to block count conversion
  [PATCH 05/50] libfrog: scrub the realtime group superblock
  [PATCH 06/50] man: document the rt group geometry ioctl
  [PATCH 07/50] libxfs: port userspace deferred log item to handle
  [PATCH 08/50] libxfs: implement some sanity checking for enormous
  [PATCH 09/50] libfrog: support scrubbing rtgroup metadata paths
  [PATCH 10/50] libfrog: report rt groups in output
  [PATCH 11/50] libfrog: add bitmap_clear
  [PATCH 12/50] xfs_logprint: report realtime EFIs
  [PATCH 13/50] xfs_repair: adjust rtbitmap/rtsummary word updates to
  [PATCH 15/50] xfs_repair: refactor offsetof+sizeof to offsetofend
  [PATCH 16/50] xfs_repair: improve rtbitmap discrepancy reporting
  [PATCH 21/50] xfs_repair: find and clobber rtgroup bitmap and summary
  [PATCH 22/50] xfs_repair: support realtime superblocks
  [PATCH 23/50] xfs_repair: repair rtbitmap and rtsummary block headers
  [PATCH 25/50] xfs_db: fix the rtblock and rtextent commands for
  [PATCH 26/50] xfs_db: fix rtconvert to handle segmented rtblocks
  [PATCH 27/50] xfs_db: listify the definition of enum typnm
  [PATCH 28/50] xfs_db: support dumping realtime group data and
  [PATCH 29/50] xfs_db: support changing the label and uuid of rt
  [PATCH 30/50] xfs_db: enable conversion of rt space units
  [PATCH 32/50] xfs_db: metadump realtime devices
  [PATCH 33/50] xfs_db: dump rt bitmap blocks
  [PATCH 34/50] xfs_db: dump rt summary blocks
  [PATCH 35/50] xfs_db: report rt group and block number in the bmap
  [PATCH 36/50] xfs_mdrestore: restore rt group superblocks to realtime
  [PATCH 37/50] xfs_io: support scrubbing rtgroup metadata
  [PATCH 38/50] xfs_io: support scrubbing rtgroup metadata paths
  [PATCH 39/50] xfs_io: add a command to display allocation group
  [PATCH 40/50] xfs_io: add a command to display realtime group
  [PATCH 41/50] xfs_io: display rt group in verbose bmap output
  [PATCH 42/50] xfs_io: display rt group in verbose fsmap output
  [PATCH 43/50] xfs_spaceman: report on realtime group health
  [PATCH 44/50] xfs_scrub: scrub realtime allocation group metadata
  [PATCH 45/50] xfs_scrub: check rtgroup metadata directory connections
  [PATCH 46/50] xfs_scrub: call GETFSMAP for each rt group in parallel
  [PATCH 47/50] xfs_scrub: trim realtime volumes too
  [PATCH 48/50] xfs_scrub: use histograms to speed up phase 8 on the
  [PATCH 49/50] mkfs: add headers to realtime bitmap blocks
  [PATCH 50/50] mkfs: format realtime groups
[PATCHSET v5.8 8/9] xfsprogs: store quota files in the metadir
  [PATCH 1/7] libfrog: scrub quota file metapaths
  [PATCH 2/7] xfs_db: support metadir quotas
  [PATCH 3/7] xfs_repair: refactor quota inumber handling
  [PATCH 4/7] xfs_repair: hoist the secondary sb qflags handling
  [PATCH 5/7] xfs_repair: support quota inodes in the metadata
  [PATCH 6/7] xfs_repair: try not to trash qflags on metadir
  [PATCH 7/7] mkfs: add quota flags when setting up filesystem
[PATCHSET v5.8 9/9] xfsprogs: enable quota for realtime voluems
  [PATCH 1/2] xfs_quota: report warning limits for realtime space
  [PATCH 2/2] mkfs: enable rt quota options

--D
