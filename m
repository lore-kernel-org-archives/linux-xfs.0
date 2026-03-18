Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66F139890A
	for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2026 10:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773831427; cv=none; b=m1spMEPQVoGipaMhG9pMn1p17NcYJh/itLcq3Cpse8NaEJCktUHY606lsJA94Cr//s9Xp5UOeTh/t1q9JCpfuOedaGX5neoEJxkuf195x7IvE5hhTlyYAWnEwPKbVv+uu/UgqQM+0cGmYo5F+8KD1bJ4xA+WufOIYCkflXAwtBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773831427; c=relaxed/simple;
	bh=VE8ZtHL27DAHlDTSlrbDN5swyDFSbnrDjtX8QPzBsVs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rbHspF0UfmI+a6LCI4HkyxtfaAeVWLibiiTwOQaIh1zcK9+7es48Kit3yFz2EKds8T67K640PFGyIbxwA+iLx3Pd4ZgyIvgMT9H7QtXz49ZwcAp4q4Ig/sI4VSgIJu8o8ul4bQfe3vblgi3p8L3kOMfh18CDZcynkUSR2FvRBPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nsCMFucT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nsCMFucT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12852C2BC87;
	Wed, 18 Mar 2026 10:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773831427;
	bh=VE8ZtHL27DAHlDTSlrbDN5swyDFSbnrDjtX8QPzBsVs=;
	h=Date:From:To:Cc:Subject:From;
	b=nsCMFucTK/LvozkMXfAnnThI3i2ajwh89uP1BJYw/Lm6DlA3UfAZ168dncZiMcNxj
	 J+ONbmBF20FIHtWfBd44GuvTk2a6KYbYqpl+1lboX3IJmPdgsu59LGRqFmCfTrmhqp
	 Ro6XmfFcvSRFBhmVP33ywSMU1UYnDqOPtyM4mhxNOr1lmMtOqKUtzpz9+Oy6PdTKyc
	 nalDd0cOc1Kkom4zLs4ZFdBZaJAAfqYpAeNXaUUp6bL1VcMYvZs9czI5EuNT6zIgNx
	 YyHr1lwWsjyUxjseivQJ6duza8seqABj6kJriaxSj7oAjNQCygLi5NbRIC7InlMu8o
	 AXQ7sBBkIRAyw==
Date: Wed, 18 Mar 2026 11:57:01 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, axboe@kernel.dk, bage@debian.org, 
	bfoster@redhat.com, brauner@kernel.org, cem@kernel.org, cmaiolino@redhat.com, 
	djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, hch@lst.de, 
	linux-xfs@vger.kernel.org, lukas@herbolt.com, martin.petersen@oracle.com
Subject: [ANNOUNCE] xfsprogs: v6.19.0 released
Message-ID: <odpacitkqmoe7lb3nhnttb4li6kmzzjena6ciujf6by6ztiirv@ez2hziuqnl27>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs master branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This release consist mostly of improvements and bugfixes. Corruption of the
large files in mkfs.xfs protofiles together with a few memory leaks are fixed.
mkfs.xfs has better calculation of lsunit geometry on 512e and 4kN disks.
Utilize BLKREPORTZONEV2 ioctl() when possible. xfs_mdrestore is fixed for 4k
sector disks. On Debian, in favor of dh_installsystemd, xfsprogs doesn't call
daemon-reload anymore.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the master branch is commit:

2dd2852fd91b48217f91f8205788f09586e95f46

New commits:

Andrey Albershteyn (1):
      [2dd2852fd91b] xfsprogs: Release v6.19.0

Bastian Germann (1):
      [b56b8825a89b] debian: Drop Uploader: Bastian Germann

Brian Foster (2):
      [bcbd49ae01ff] xfs: error tag to force zeroing on debug kernels
      [e5f4b834bb2f] xfs: set max_agbno to allow sparse alloc of last full inode chunk

Christoph Hellwig (12):
      [c7a07fadf4ff] include blkzoned.h in platform_defs.h
      [b7c900385985] libfrog: enable cached report zones
      [2fbd34e77b7f] xfs: add a xfs_groups_to_rfsbs helper
      [19a0fe73785d] xfs: use a lockref for the xfs_dquot reference count
      [222095f4c52a] xfs: add a XLOG_CYCLE_DATA_SIZE constant
      [d2b51c1cf4fd] xfs: remove xlog_in_core_2_t
      [ee001dba26ef] xfs: remove the xlog_rec_header_t typedef
      [6aa2b48a6b66] xfs: validate that zoned RT devices are zone aligned
      [c250d4da5191] xfs: mark __xfs_rtgroup_extents static
      [5756ae33c98b] xfs: fix an overly long line in xfs_rtgroup_calc_geometry
      [705858765a3a] xfs_io: fix fsmap help
      [69721699daeb] xfs_io: print more realtime subvolume related information in statfs

Damien Le Moal (3):
      [b3d17aa18f73] xfs: use blkdev_report_zones_cached()
      [453b0e8be7ef] mkfs: remove unnecessary return value affectation
      [e2a429986eb9] libfrog: lift common zone reporting code from mkfs and repair

Darrick J. Wong (10):
      [81bedc02de7d] mkfs: set rtstart from user-specified dblocks
      [9547c3f44e64] xfs_logprint: print log data to the screen in host-endian order
      [026ebbb7ef9d] mkfs: quiet down warning about insufficient write zones
      [49157d0df63a] xfs_mdrestore: fix restoration on filesystems with 4k sectors
      [609a3154ba08] debian: don't explicitly reload systemd from postinst
      [783268546e98] xfs_scrub_all: fix non-service-mode arguments to xfs_scrub
      [39c683bf82ae] misc: fix a few memory leaks
      [2c9b0236b0d8] libxfs: fix data corruption bug in libxfs_file_write
      [ca3452967778] mkfs: fix protofile data corruption when in/out file block sizes don't match
      [32921df27199] mkfs: fix log sunit automatic configuration

Hans Holmberg (1):
      [396517b382aa] xfs: remove xarray mark for reclaimable zones

Lukas Herbolt (1):
      [ca1eb448e116] mkfs.xfs fix sunit size on 512e and 4kN disks.

Code Diffstat:

 VERSION                   |   2 +-
 configure.ac              |   2 +-
 debian/changelog          |   6 +++
 debian/control            |   2 +-
 debian/postinst           |   3 --
 doc/CHANGES               |  19 ++++++++
 include/libxlog.h         |   4 +-
 include/platform_defs.h   |  15 ++++++
 io/fsmap.c                |   5 +-
 io/stat.c                 |   6 +++
 libfrog/Makefile          |   6 ++-
 libfrog/zones.c           |  59 +++++++++++++++++++++++
 libfrog/zones.h           |  16 +++++++
 libxfs/rdwr.c             |   2 +-
 libxfs/util.c             |   5 +-
 libxfs/xfs_errortag.h     |   6 ++-
 libxfs/xfs_group.h        |   9 ++++
 libxfs/xfs_ialloc.c       |  11 +++--
 libxfs/xfs_log_format.h   |  38 +++++++--------
 libxfs/xfs_ondisk.h       |   6 ++-
 libxfs/xfs_quota_defs.h   |   4 +-
 libxfs/xfs_rtgroup.c      |  53 ++++++++++----------
 libxfs/xfs_rtgroup.h      |  16 +++----
 libxfs/xfs_sb.c           |  15 ++++++
 libxfs/xfs_zones.c        |   2 +-
 libxlog/util.c            |   6 +--
 libxlog/xfs_log_recover.c |  52 +++++++++++---------
 logprint/log_dump.c       |   4 +-
 logprint/log_print_all.c  |   5 +-
 logprint/logprint.c       |   5 ++
 logprint/logprint.h       |   1 +
 man/man8/xfs_logprint.8   |   4 ++
 mdrestore/xfs_mdrestore.c |  17 +++++--
 mkfs/proto.c              |  28 +++++++----
 mkfs/xfs_mkfs.c           | 120 ++++++++++++++++++++++++----------------------
 repair/zoned.c            |  36 +++++---------
 scrub/Makefile            |   2 +-
 scrub/xfs_scrub_all.py.in |   3 +-
 38 files changed, 386 insertions(+), 209 deletions(-)
 create mode 100644 libfrog/zones.c
 create mode 100644 libfrog/zones.h

-- 
- Andrey
