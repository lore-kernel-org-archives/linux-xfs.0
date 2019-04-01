Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42462 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728697AbfDASWK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Apr 2019 14:22:10 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 9750C7B96
        for <linux-xfs@vger.kernel.org>; Mon,  1 Apr 2019 13:21:54 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: ANNOUNCE: xfsprogs for-next updated to 28bbc15
Message-ID: <d2aa70e8-b99e-64fa-d375-48d82d006bc4@sandeen.net>
Date: Mon, 1 Apr 2019 13:22:03 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5Fd60a5upaYpgCTJ3rg9GtLVkB01wR9ea"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5Fd60a5upaYpgCTJ3rg9GtLVkB01wR9ea
Content-Type: multipart/mixed; boundary="kgrpVzJGNzx9jfUBPXR5egwrxfsz3HDZq";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <d2aa70e8-b99e-64fa-d375-48d82d006bc4@sandeen.net>
Subject: ANNOUNCE: xfsprogs for-next updated to 28bbc15

--kgrpVzJGNzx9jfUBPXR5egwrxfsz3HDZq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Darrick, this is pretty much just your ever-expanding megaseries,
I pulled in what's been reviewed thus far.  I'll keep going, but
figured a little progress might buoy spirits.  ;)  No need to resend
your series of course.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

28bbc15 xfs_db: use TYP_FINOBT for finobt metadump

New Commits:

Darrick J. Wong (17):
      [f562940] configure: use sys/xattr.h for fsetxattr detection
      [09c343e] configure.ac: fix alignment of features
      [4efcad5] debian: drop dangling libhandle.a symlinks in xfslibs-dev=

      [33d7c25] debian: don't bypass top level Makefile when building sub=
dirs
      [e3d9ff3] debian: enable parallel make
      [30cc0fd] xfs_io: actually check copy file range helper return valu=
es
      [ec5002a] xfs_io: statx -r should print attributes_mask
      [f019d5b] xfs_io: don't walk off the end of argv in fzero_f
      [ab11d01] xfs_scrub_all: walk the lsblk device/fs hierarchy correct=
ly
      [5e7a043] xfs_scrub_all.timer: activate after most of the system is=
 up
      [32c6cc0] xfs_scrub: rename the global nr_threads
      [9662644] xfs_scrub: use datadev parallelization estimates for thre=
ad count
      [41c0860] xfs_scrub: don't expose internal pool state
      [f1bb169] xfs_scrub: one read/verify pool per disk
      [aa26c33] xfs_scrub: don't close mnt_fd when mnt_fd open fails
      [3baa69c] xfs_scrub: check label for misleading characters
      [28bbc15] xfs_db: use TYP_FINOBT for finobt metadump

Dave Chinner (1):
      [6570dc5] libxfs: fix repair deadlock due to failed inode flushes.

Eric Sandeen (1):
      [7d8f4a1] xfs_io: document fzero_f -k option in manpage


Code Diffstat:

 configure.ac                   |  28 ++++-----
 db/metadump.c                  |   2 +-
 debian/rules                   |  14 +++--
 io/copy_file_range.c           |  17 +++++-
 io/prealloc.c                  |  20 ++++---
 io/stat.c                      |   4 ++
 io/statx.h                     |   2 +-
 libxfs/trans.c                 |  17 ++++--
 m4/package_libcdev.m4          |   4 +-
 man/man8/xfs_io.8              |   5 +-
 scrub/common.c                 |   4 +-
 scrub/disk.c                   |   4 +-
 scrub/phase1.c                 |  22 ++++----
 scrub/phase5.c                 |  54 ++++++++++++++++++
 scrub/phase6.c                 | 125 ++++++++++++++++++++++++++---------=
------
 scrub/read_verify.c            |  63 +++++++++++++++------
 scrub/read_verify.h            |  18 ++----
 scrub/unicrash.c               |  24 ++++++++
 scrub/unicrash.h               |   5 ++
 scrub/xfs_scrub.c              |   6 +-
 scrub/xfs_scrub.h              |   2 +-
 scrub/xfs_scrub_all.in         |  28 +++++----
 scrub/xfs_scrub_all.service.in |   1 +
 23 files changed, 330 insertions(+), 139 deletions(-)


--kgrpVzJGNzx9jfUBPXR5egwrxfsz3HDZq--

--5Fd60a5upaYpgCTJ3rg9GtLVkB01wR9ea
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlyiVtEACgkQIK4WkuE9
3uCyuw//ZChWpz01uQgXJ4MX5J5goR4TEocNOZplcjoqKDkmUttn8tLxadKwC0n3
vSnc+mVtV6WMF9gPv7ssGB88mFkbyCAAuzSN2e53vgJRTQ9/i5/zopgD9ctqPHS1
ftH4Fmio9cBOKQ8EOeRHb3sbr5hyCT+hGxhfX2EaGtGsrdweGzX7o8YNimwuglAn
L2YBrnTxd2RkN6Uso/zt61bWieDNS+xnbUW261MGn5+dnlzoTQrxn4P76e8ASI20
LXJD7+17yRqIRDfkbQfFItTsJ1HU3OsJqm0cz3MZnMTua7O11prdLylER48997RR
/H1HkO0AHm19FOZ1/F/8vo7DCO0tuRSX52hB+nSo9wCSYAGgRJPn4vXi/aYv0AGD
g5GYNpXikAz/2FdR1xnMtQQDfH1pEzL9FPRmwgC8PrBD6NMXgHLQJfuPZGpYMYlQ
TxCrbX8fAwXJzyHFvTGBgiebdnMjyfL7hCimcfVvH3K96zES2gNuuCtsFMOWC2Jd
Pm7BF4guqeK5r/m9QRPX5Bwe+jO2iQ/F8Loenezu3giUqzv3gwmvYeVLrFVGXKnC
C9cjpJ9q93W6F25qYYmOIrvlyWCX9u3aq9yUVeFzR3Yx31I5PctmoMPJOPevqj+2
bp7lU9Gu+Jkt3PzUgUkDudA5jIwds4tYZVgezODb+zsF+bUd2rU=
=xKf+
-----END PGP SIGNATURE-----

--5Fd60a5upaYpgCTJ3rg9GtLVkB01wR9ea--
