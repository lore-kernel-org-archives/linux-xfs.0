Received: from mail-4317.proton.ch (mail-4317.proton.ch [185.70.43.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4B620DCB
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 13:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707140373; cv=none; b=nf5Kiee5Hkjk+8V/nfFoGR7Ci/g0Rc+GlX0NHxoqjA8aOEyAIMs0k6UcWPtyDA46/ab8NZILJKvGChouFro7P480AUqnB1Tw0nYf82LlRREHBfqWCLvy0KjIJizKA68ktgRACOV6Xae1JHfl6x222ripa/nV5HZiWccd7/0+Ofk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707140373; c=relaxed/simple;
	bh=jQucnYg0pSSDVY7EF2Wi3yJGKX/34rRJD4TNUz1by70=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=lI54NP3GSYSzPGJ6huugIt1TItDhy87n3+GhP2VBInGJ6kRE+5tkE4VXbEMAHB9zap4L64W+/bJZZ99OTuFzuVB6QRTOvqJJIXWPhDpT808OS9l7d/RNeLXyHz/ceG/u+cvvDRlcm6RmcoOQh5OkCsAR7ZM+bu4hTVgY/ZvTV3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=maiolino.me; spf=pass smtp.mailfrom=maiolino.me; dkim=pass (2048-bit key) header.d=maiolino.me header.i=@maiolino.me header.b=pKhD9FQx; arc=none smtp.client-ip=185.70.43.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=maiolino.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=maiolino.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=maiolino.me header.i=@maiolino.me header.b="pKhD9FQx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maiolino.me;
	s=protonmail; t=1707140359; x=1707399559;
	bh=a+19Gbt7rCKio9mjGysSvgOsEw4pNbLEJabEIVljyGk=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=pKhD9FQx1bv50i+tAwNkNsUyMuFW3lUfurZZ+lYfci06zO3J34iMVdKrIboHxR/Ap
	 2Sda8oeA0w6GuQX1oZuuoCJI17Y+UrSD1zFFiFatfn3u3DrGsxfZtg4FOseIGjbcIs
	 YcnoAgsGEhbJQkHNV0tp8pKb2oWLLbOiGJkzX8OwcWljoiU7GCK0+GxuL0TlxwK6K6
	 JDj1U7RCX0T5ZPab1cUxJu06hnHqFctVFF02XZf0ho4jnVwvwNOPT04UaQmarEQCjo
	 11ygVs7go2bchJ/Q5z1dTkCHdzklnlzoAcQwN30yGXS033+0uNlZDBAHo5lpdKwOb6
	 J0CRwE90sLIOQ==
Date: Mon, 05 Feb 2024 13:39:04 +0000
To: linux-xfs@vger.kernel.org
From: Carlos Maiolino <carlos@maiolino.me>
Subject: [ANNOUNCE] xfsprogs v6.6.0 released
Message-ID: <2kvbqcrcqpwdjkze3tcjie64x65yn5eli5o7cogkohoy5433g6@6wxhgi2qsyc5>
Feedback-ID: 28765827:user:proton
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="------de0ae8994ff7860abade0f480d189702b1bf8f4359a167a7d0a0eeae8d9424b3"; charset=utf-8

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------de0ae8994ff7860abade0f480d189702b1bf8f4359a167a7d0a0eeae8d9424b3
Content-Type: text/plain; charset=UTF-8
Date: Mon, 5 Feb 2024 14:39:02 +0100
From: Carlos Maiolino <carlos@maiolino.me>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs v6.6.0 released
Message-ID: <2kvbqcrcqpwdjkze3tcjie64x65yn5eli5o7cogkohoy5433g6@6wxhgi2qsyc5>
MIME-Version: 1.0
Content-Disposition: inline

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the master branch is commit:

7a7b09c2b027b6f45de61c6e56b36154c1138c0c

New commits:

Carlos Maiolino (1):
      [7a7b09c2b] xfsprogs: Release v6.6.0

Chandan Babu R (21):
      [3ea310101] metadump: Use boolean values true/false instead of 1/0
      [0d3650b23] mdrestore: Fix logic used to check if target device is large enough
      [c7196b8bb] metadump: Declare boolean variables with bool type
      [fb4697dd6] metadump: Define and use struct metadump
      [eba3f43eb] metadump: Add initialization and release functions
      [1e4702774] metadump: Postpone invocation of init_metadump()
      [be75f7d73] metadump: Introduce struct metadump_ops
      [1a5a88ec8] metadump: Introduce metadump v1 operations
      [46944d200] metadump: Rename XFS_MD_MAGIC to XFS_MD_MAGIC_V1
      [ead066280] metadump: Define metadump v2 ondisk format structures and macros
      [119265828] metadump: Define metadump ops for v2 format
      [0323bbf6b] xfs_db: Add support to read from external log device
      [50f2031ac] mdrestore: Declare boolean variables with bool type
      [1fb3dccce] mdrestore: Define and use struct mdrestore
      [214bf0a21] mdrestore: Detect metadump v1 magic before reading the header
      [80240ae3d] mdrestore: Add open_device(), read_header() and show_info() functions
      [bb78872ff] mdrestore: Replace metadump header pointer argument with a union pointer
      [0f47a5004] mdrestore: Introduce mdrestore v1 operations
      [019ddea09] mdrestore: Extract target device size verification into a function
      [fa9f484b7] mdrestore: Define mdrestore ops for v2 format
      [b1de31281] mdrestore: Add support for passing log device as an argument

Christian Brauner (1):
      [faea09b8b] Revert "xfs: switch to multigrain timestamps"

Christoph Hellwig (25):
      [2c7fe3b33] db: fix unsigned char related warnings
      [3bd45ce1c] repair: fix the call to search_rt_dup_extent in scan_bmapbt
      [73352da7d] libxfs: remove the unused icache_flags member from struct libxfs_xinit
      [74c77adf5] libxfs: remove the dead {d,log,rt}path variables in libxfs_init
      [e634be8f1] libxfs/frog: remove latform_find{raw,block}path
      [732f5b904] libxfs: remove the volname concept
      [7b17b49e7] xfs_logprint: move all code to set up the fake xlog into logstat()
      [809310c4a] libxlog: remove the verbose argument to xlog_is_dirty
      [09746c2a7] libxlog: add a helper to initialize a xlog without clobbering the x structure
      [c42edb2e8] libxlog: don't require a libxfs_xinit structure for xlog_init
      [cf9162582] libxlog: remove the global libxfs_xinit x structure
      [01dcfd9e4] libxfs: rename struct libxfs_xinit to libxfs_init
      [ddd9942bc] libxfs: pass a struct libxfs_init to libxfs_mount
      [ca8cc76e8] libxfs: pass a struct libxfs_init to libxfs_alloc_buftarg
      [b6e08bf37] libxfs: merge the file vs device cases in libxfs_init
      [23d889559] libxfs: making passing flags to libxfs_init less confusing
      [8798d4a6a] libxfs: remove the setblksize == 1 case in libxfs_device_open
      [a3106f329] libfrog: make platform_set_blocksize exit on fatal failure
      [f73596118] libxfs: remove dead size < 0 checks in libxfs_init
      [4f112cb17] libxfs: mark libxfs_device_{open,close} static
      [652683748] libxfs: return the opened fd from libxfs_device_open
      [024b577aa] libxfs: pass the device fd to discard_blocks
      [28cd682be] xfs_repair: remove various libxfs_device_to_fd calls
      [7b47b1bc2] libxfs: stash away the device fd in struct xfs_buftarg
      [fc83c7574] libxfs: split out a libxfs_dev structure from struct libxfs_init

Darrick J. Wong (40):
      [be49fa968] xfs: allow userspace to rebuild metadata structures
      [e01fe994e] xfs: fix log recovery when unknown rocompat bits are set
      [38d34b01d] xfs: adjust the incore perag block_count when shrinking
      [af71e8c1f] libfrog: move 64-bit division wrappers to libfrog
      [b9166aea5] libxfs: don't UAF a requeued EFI
      [a4722a004] xfs_metadump.8: update for external log device options
      [cad0e6155] xfs_mdrestore: fix uninitialized variables in mdrestore main
      [14c6aa54a] xfs_mdrestore: emit newlines for fatal errors
      [c0c39802f] xfs_mdrestore: EXTERNALLOG is a compat value, not incompat
      [abb66bd7b] xfs_mdrestore: fix missed progress reporting
      [2cbc52f5c] xfs_mdrestore: refactor progress printing and sb fixup code
      [1067f3cd6] xfs_io: set exitcode = 1 on parsing errors in scrub/repair command
      [4c91ffcfa] xfs_io: collapse trivial helpers
      [99a0612bd] xfs_io: extract control number parsing routines
      [9de9b7404] xfs_io: support passing the FORCE_REBUILD flag to online repair
      [817d1b67b] xfs_scrub: handle spurious wakeups in scan_fs_tree
      [603850fe9] xfs_copy: distinguish short writes to EOD from runtime errors
      [61060062b] xfs_scrub: don't retry unsupported optimizations
      [6ecc67122] xfs_copy: actually do directio writes to block devices
      [c2371fdd0] xfs_scrub: try to use XFS_SCRUB_IFLAG_FORCE_REBUILD
      [1665923a8] xfs_db: report the device associated with each io cursor
      [55021e753] libxfs: fix krealloc to allow freeing data
      [dc0611945] debian: install scrub services with dh_installsystemd
      [7c4b91c5c] xfs_scrub_all: escape service names consistently
      [8d318d62d] xfs_scrub: fix author and spdx headers on scrub/ files
      [595874f26] xfs_scrub: fix pathname escaping across all service definitions
      [eb62fccab] xfs_scrub: add missing license and copyright information
      [497ca97c1] xfs_scrub: flush stdout after printing to it
      [83535ee5c] xfs_scrub_fail: fix sendmail detection
      [525205221] xfs_scrub: update copyright years for scrub/ files
      [96ac83c88] xfs_scrub: don't report media errors for space with unknowable owner
      [731c95408] xfs_scrub_fail: return the failure status of the mailer program
      [2201a9d57] xfs_scrub_fail: add content type header to failure emails
      [27df677a7] xfs_scrub_all: fix argument passing when invoking xfs_scrub manually
      [fd650873e] xfs_scrub_fail: advise recipients not to reply
      [3abc6a0c3] xfs_scrub_all: survive systemd restarts when waiting for services
      [e0cb10f5f] xfs_scrub_fail: move executable script to /usr/libexec
      [0c22427fe] xfs_scrub_all: simplify cleanup of run_killable
      [3d37d8bf5] xfs_scrub_all.cron: move to package data directory
      [1c95c17c8] xfs_scrub_all: fix termination signal handling

Eric Biggers (1):
      [e97caf714] xfs_io/encrypt: support specifying crypto data unit size

Jakub Bogusz (1):
      [c1b65c9cd] Polish translation update for xfsprogs 6.5.0.

Jeff Layton (2):
      [6cfd0b487] xfs: convert to ctime accessor functions
      [f99988c2f] xfs: switch to multigrain timestamps

Pavel Reichl (1):
      [9448c82ef] xfs_quota: fix missing mount point warning

Code Diffstat:

 VERSION                          |     2 +-
 configure.ac                     |     3 +-
 copy/xfs_copy.c                  |    43 +-
 db/block.c                       |    14 +-
 db/crc.c                         |     2 +-
 db/fuzz.c                        |     2 +-
 db/hash.c                        |    45 +-
 db/info.c                        |     2 +-
 db/init.c                        |    29 +-
 db/init.h                        |     3 +-
 db/io.c                          |    91 +-
 db/io.h                          |     5 +
 db/metadump.c                    |   781 +-
 db/output.c                      |     2 +-
 db/sb.c                          |    18 +-
 db/write.c                       |     2 +-
 db/xfs_metadump.sh               |     3 +-
 debian/changelog                 |     6 +
 debian/rules                     |     1 +
 doc/CHANGES                      |     9 +
 growfs/xfs_growfs.c              |    24 +-
 include/builddefs.in             |     6 +-
 include/libxfs.h                 |    88 +-
 include/libxlog.h                |     7 +-
 include/xfs_inode.h              |    26 +-
 include/xfs_metadump.h           |    70 +-
 include/xfs_mount.h              |     3 +-
 io/encrypt.c                     |    72 +-
 io/scrub.c                       |   255 +-
 libfrog/Makefile                 |     1 +
 libfrog/div64.h                  |    96 +
 libfrog/linux.c                  |    39 +-
 libfrog/paths.c                  |    18 +-
 libfrog/platform.h               |     6 +-
 libxfs/defer_item.c              |     7 +
 libxfs/init.c                    |   398 +-
 libxfs/kmem.c                    |    10 +
 libxfs/libxfs_io.h               |     5 +-
 libxfs/libxfs_priv.h             |    77 +-
 libxfs/rdwr.c                    |    16 +-
 libxfs/topology.c                |    23 +-
 libxfs/topology.h                |     4 +-
 libxfs/xfs_ag.c                  |     6 +
 libxfs/xfs_fs.h                  |     6 +-
 libxfs/xfs_inode_buf.c           |     5 +-
 libxfs/xfs_sb.c                  |     3 +-
 libxfs/xfs_trans_inode.c         |     2 +-
 libxlog/util.c                   |    49 +-
 logprint/logprint.c              |    79 +-
 m4/package_libcdev.m4            |    21 +
 man/man8/xfs_io.8                |     8 +-
 man/man8/xfs_mdrestore.8         |    12 +
 man/man8/xfs_metadump.8          |    21 +-
 mdrestore/xfs_mdrestore.c        |   543 +-
 mkfs/xfs_mkfs.c                  |   249 +-
 po/pl.po                         | 21543 +++++++++++++++++++------------------
 repair/globals.h                 |     2 +
 repair/init.c                    |    40 +-
 repair/phase2.c                  |    27 +-
 repair/prefetch.c                |     2 +-
 repair/protos.h                  |     2 +-
 repair/sb.c                      |    18 +-
 repair/scan.c                    |     6 +-
 repair/xfs_repair.c              |    15 +-
 scrub/Makefile                   |    28 +-
 scrub/common.c                   |     6 +-
 scrub/common.h                   |     6 +-
 scrub/counter.c                  |     6 +-
 scrub/counter.h                  |     6 +-
 scrub/descr.c                    |     4 +-
 scrub/descr.h                    |     4 +-
 scrub/disk.c                     |     6 +-
 scrub/disk.h                     |     6 +-
 scrub/filemap.c                  |     6 +-
 scrub/filemap.h                  |     6 +-
 scrub/fscounters.c               |     6 +-
 scrub/fscounters.h               |     6 +-
 scrub/inodes.c                   |     6 +-
 scrub/inodes.h                   |     6 +-
 scrub/phase1.c                   |    34 +-
 scrub/phase2.c                   |     6 +-
 scrub/phase3.c                   |     6 +-
 scrub/phase4.c                   |     6 +-
 scrub/phase5.c                   |     6 +-
 scrub/phase6.c                   |    19 +-
 scrub/phase7.c                   |     6 +-
 scrub/progress.c                 |     6 +-
 scrub/progress.h                 |     6 +-
 scrub/read_verify.c              |     6 +-
 scrub/read_verify.h              |     6 +-
 scrub/repair.c                   |     6 +-
 scrub/repair.h                   |     6 +-
 scrub/scrub.c                    |    67 +-
 scrub/scrub.h                    |     7 +-
 scrub/spacemap.c                 |     6 +-
 scrub/spacemap.h                 |     6 +-
 scrub/unicrash.c                 |     6 +-
 scrub/unicrash.h                 |     6 +-
 scrub/vfs.c                      |     8 +-
 scrub/vfs.h                      |     6 +-
 scrub/xfs_scrub.c                |    11 +-
 scrub/xfs_scrub.h                |     7 +-
 scrub/xfs_scrub@.service.in      |    11 +-
 scrub/xfs_scrub_all.cron.in      |     5 +
 scrub/xfs_scrub_all.in           |   208 +-
 scrub/xfs_scrub_all.service.in   |     5 +
 scrub/xfs_scrub_all.timer        |     5 +
 scrub/xfs_scrub_fail             |    26 -
 scrub/xfs_scrub_fail.in          |    39 +
 scrub/xfs_scrub_fail@.service.in |     9 +-
 110 files changed, 13306 insertions(+), 12332 deletions(-)
 create mode 100644 libfrog/div64.h
 delete mode 100755 scrub/xfs_scrub_fail
 create mode 100755 scrub/xfs_scrub_fail.in


-- 
Carlos

--------de0ae8994ff7860abade0f480d189702b1bf8f4359a167a7d0a0eeae8d9424b3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wnUEARYIACcFAmXA5PgJEOk12U/828uvFiEEj32Dn/1+aNUZzl9s6TXZT/zb
y68AAMz5APwLhAD/YUa4Qe7fACDS52hGSHeNHsebgIwdFscr5jAqDQEArAQg
LSdi00WSnzzHgwGJiznpiz9peMPlLD8r6vhoEAA=
=c+1X
-----END PGP SIGNATURE-----


--------de0ae8994ff7860abade0f480d189702b1bf8f4359a167a7d0a0eeae8d9424b3--

