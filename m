Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F045C61E
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 10:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.77.79.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706007250; cv=none; b=obCoGv3PUcBoZvVF5fsK62dqrsRa8TM2sjx5kPkSqU2hlB/xkO3m2bBWg/9qrIm3d6gyse4NNvoXXBBYFNEsq3s1p6ABZuHrhlFvYSxIfr5lkFP6ILO+4RvQt4WQZoLnrzsMxd3hEXaPsOc1rGuI1MPny+sSHtqKvqVXisStcyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706007250; c=relaxed/simple;
	bh=2mbcflZTKQkmmhwNpMkpGCif3vDTqaK3T+bRbMrbsFk=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=CQJDrWMrc6lC4Bfd0Tn4nPzG1IY+5VWQ+JH8JoXTAHQPsfmFRKSEQzIxWyYMqUePQy9YufC9wXHmOQPaKicL0vJQJQ8nZFTJZi+7zUOpOjOYQjYfEvV6tbhaPxZY3YFwr7MnjnPddA+f2JHq1z3/s8JPhNotlCbEofgThgCiHbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=maiolino.me; spf=pass smtp.mailfrom=maiolino.me; dkim=pass (2048-bit key) header.d=maiolino.me header.i=@maiolino.me header.b=btfpJUVN; arc=none smtp.client-ip=51.77.79.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=maiolino.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=maiolino.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=maiolino.me header.i=@maiolino.me header.b="btfpJUVN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maiolino.me;
	s=protonmail; t=1706007230; x=1706266430;
	bh=YAZQi10pS/yjiTBeia08rBOtZi9Kro5MBn9i+Efp/Bs=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=btfpJUVNh/LpIEt/7+Lu0UMZIySAnAwE8sW7InvjjlRG9dUxTwp1XWDBxvCxl2FU/
	 tEvsFVBR76cSYJFlpVpVqDGlibK9kCbsIsEzYT0U+ZBl0wiDaDxPk2g/9gtTmWHCdL
	 38raTa1h8Bo1E4KmEqDJSPb2XIL+GQE90+YE2X9uAliG+n8ziqwcY+Hhzr9c634b+G
	 8AIM4uMCjGsLIVCWZThyULj8FjlTxsTXWz1xQW6rYjp6P5TfmAQQnatdEUIBhT+1i+
	 0XvsPb0HvdplPwNwau9pCzRsdQ55bCsuA4pGwFDfvjno6Tda3kkSy+mf18V5G24vPt
	 5Ywu/i1GE4f1g==
Date: Tue, 23 Jan 2024 10:53:25 +0000
To: linux-xfs@vger.kernel.org
From: Carlos Maiolino <carlos@maiolino.me>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 3ec53d438
Message-ID: <l6nxtgxvlwmcejoylpuevoyzxxylkcl2vcsw4pwzilos6rph2k@o5ontnahuhz2>
Feedback-ID: 28765827:user:proton
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="------c8faceac6d44604142a4d67de75be870fe9e941f71ae4574789ee9279b5675cc"; charset=utf-8

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------c8faceac6d44604142a4d67de75be870fe9e941f71ae4574789ee9279b5675cc
Content-Type: text/plain; charset=UTF-8
Date: Tue, 23 Jan 2024 11:53:21 +0100
From: Carlos Maiolino <carlos@maiolino.me>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to 3ec53d438
Message-ID: <l6nxtgxvlwmcejoylpuevoyzxxylkcl2vcsw4pwzilos6rph2k@o5ontnahuhz2>
MIME-Version: 1.0
Content-Disposition: inline

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

Also, we've been working to make the patch submission process more
straight-forward by merging pull requests, so this update also contains a list
of merge commits. Such merge commits were created even if pull could be done in
a fast-forward mode, so in this way we can individually identify git pulls and
keep the cover-letters in the git history

Any comments, concerns, suggestions, etc, please let me know.

This is the last for-next push before v6.6 is released, so if you plan to submit
anything else for xfsprogs, it will be postponed to v6.7 or v6.8.

The new head of the for-next branch is commit:

3ec53d43866f7cd35c8453206e5d855b1088a4a3

43 new commits:

Carlos Maiolino (6):
      [dd8306b39] Merge tag 'xfsprogs-fixes-6.6_2023-12-21' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [b5f2a1ff1] Merge tag 'xfsprogs-fixes-6.6_2024-01-11' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [813262c78] Merge tag 'scrub-fix-legalese-6.6_2024-01-11' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [0f7e58a38] Merge tag 'scrub-repair-fixes-6.6_2024-01-11' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [9b641bcd1] Merge tag 'scrub-service-fixes-6.6_2024-01-11' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next
      [3ec53d438] Merge tag 'scruball-service-fixes-6.6_2024-01-11' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev into for-next

Darrick J. Wong (37):
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

Code Diffstat:

 copy/xfs_copy.c                  |  24 ++--
 db/block.c                       |  14 ++-
 db/io.c                          |  35 +++++-
 db/io.h                          |   3 +
 debian/rules                     |   1 +
 include/builddefs.in             |   2 +-
 include/libxfs.h                 |   1 +
 io/scrub.c                       | 255 +++++++++++++++++++++------------------
 libfrog/Makefile                 |   1 +
 libfrog/div64.h                  |  96 +++++++++++++++
 libxfs/defer_item.c              |   7 ++
 libxfs/kmem.c                    |  10 ++
 libxfs/libxfs_priv.h             |  77 +-----------
 man/man8/xfs_io.8                |   3 +
 man/man8/xfs_mdrestore.8         |   6 +-
 man/man8/xfs_metadump.8          |   7 +-
 mdrestore/xfs_mdrestore.c        | 122 +++++++++++--------
 scrub/Makefile                   |  28 +++--
 scrub/common.c                   |   6 +-
 scrub/common.h                   |   6 +-
 scrub/counter.c                  |   6 +-
 scrub/counter.h                  |   6 +-
 scrub/descr.c                    |   4 +-
 scrub/descr.h                    |   4 +-
 scrub/disk.c                     |   6 +-
 scrub/disk.h                     |   6 +-
 scrub/filemap.c                  |   6 +-
 scrub/filemap.h                  |   6 +-
 scrub/fscounters.c               |   6 +-
 scrub/fscounters.h               |   6 +-
 scrub/inodes.c                   |   6 +-
 scrub/inodes.h                   |   6 +-
 scrub/phase1.c                   |  34 +++++-
 scrub/phase2.c                   |   6 +-
 scrub/phase3.c                   |   6 +-
 scrub/phase4.c                   |   6 +-
 scrub/phase5.c                   |   6 +-
 scrub/phase6.c                   |  19 ++-
 scrub/phase7.c                   |   6 +-
 scrub/progress.c                 |   6 +-
 scrub/progress.h                 |   6 +-
 scrub/read_verify.c              |   6 +-
 scrub/read_verify.h              |   6 +-
 scrub/repair.c                   |   6 +-
 scrub/repair.h                   |   6 +-
 scrub/scrub.c                    |  67 +++++-----
 scrub/scrub.h                    |   7 +-
 scrub/spacemap.c                 |   6 +-
 scrub/spacemap.h                 |   6 +-
 scrub/unicrash.c                 |   6 +-
 scrub/unicrash.h                 |   6 +-
 scrub/vfs.c                      |   8 +-
 scrub/vfs.h                      |   6 +-
 scrub/xfs_scrub.c                |  11 +-
 scrub/xfs_scrub.h                |   7 +-
 scrub/xfs_scrub@.service.in      |  11 +-
 scrub/xfs_scrub_all.cron.in      |   5 +
 scrub/xfs_scrub_all.in           | 208 +++++++++++++++++++++----------
 scrub/xfs_scrub_all.service.in   |   5 +
 scrub/xfs_scrub_all.timer        |   5 +
 scrub/xfs_scrub_fail             |  26 ----
 scrub/xfs_scrub_fail.in          |  39 ++++++
 scrub/xfs_scrub_fail@.service.in |   9 +-
 63 files changed, 825 insertions(+), 504 deletions(-)
 create mode 100644 libfrog/div64.h
 delete mode 100755 scrub/xfs_scrub_fail
 create mode 100755 scrub/xfs_scrub_fail.in

--------c8faceac6d44604142a4d67de75be870fe9e941f71ae4574789ee9279b5675cc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wnUEARYIACcFAmWvmqQJEOk12U/828uvFiEEj32Dn/1+aNUZzl9s6TXZT/zb
y68AAEuaAQCKRECoKQ1iDP2yss+WnXaQPNSoxSkTz8Btaml4rCCMLwEA4qwJ
dWHdfqeNcGp+980qeki0wrxk77qcb350guZDBQ0=
=Xrh2
-----END PGP SIGNATURE-----


--------c8faceac6d44604142a4d67de75be870fe9e941f71ae4574789ee9279b5675cc--

