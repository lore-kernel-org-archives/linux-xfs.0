Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38792 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753737AbdDKVym (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 17:54:42 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id CAC2E7873A6
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2017 16:54:31 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: v4.11.0-rc1 released
Message-ID: <9c2bde5a-dae7-5192-8e4d-500faa67b7ea@sandeen.net>
Date: Tue, 11 Apr 2017 16:54:24 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DfRErrdG9F3VnBj0jfDeiFIp0kBulApWI"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DfRErrdG9F3VnBj0jfDeiFIp0kBulApWI
Content-Type: multipart/mixed; boundary="f4WnjxJP19ENpgTN1koGl21TOeIXnqihl";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <9c2bde5a-dae7-5192-8e4d-500faa67b7ea@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: v4.11.0-rc1 released

--f4WnjxJP19ENpgTN1koGl21TOeIXnqihl
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with xfsprogs: v4.11.0-rc1

This contains a couple more small libxfs updates, along with
the xfsprogs-proper patches which have had a bit of soak and
review time.  This is shaping up to be a "stabilization" release,
I guess, with not too many changes this time around.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

07a3e79 xfsprogs: Release v4.11.0-rc1

New Commits:

Brian Foster (1):
      [948ade7] xfs_repair: detect invalid zero-sized symlink inodes

Calvin Owens (1):
      [c229968] xfs_io: Fix "falloc -p" to pass KEEP_SIZE

Darrick J. Wong (3):
      [b0a898f] libxfs: fix xfs_extent_busy_flush macro definition
      [d15188a] xfs: rework the inline directory verifiers
      [75dc678] xfs_io: support shutdown command on foreign fses

Eric Sandeen (9):
      [e8a1c98] xfsprogs: remove unused libxfs helper #defines
      [47e4870] xfs_repair: warn about dirty log with -n option
      [912ba35] xfs_repair: pass btnum not magic to phase5 functions
      [5893de5] xfsprogs: fix build dep on configure.ac
      [a8cef9f] xfs_io: move stat functions to new file
      [2e03a36] xfs_io: refactor stat functions, add raw dump
      [12caa87] xfs_io: hook up statx
      [4c87a00] xfs.5: document barrier deprecation in xfs
      [07a3e79] xfsprogs: Release v4.11.0-rc1

Code Diffstat:

 Makefile                |   2 +-
 VERSION                 |   4 +-
 configure.ac            |   2 +-
 doc/CHANGES             |   8 +
 io/Makefile             |   2 +-
 io/init.c               |   1 +
 io/io.h                 |   3 +-
 io/open.c               | 160 -------------------
 io/prealloc.c           |   2 +-
 io/shutdown.c           |   2 +-
 io/stat.c               | 414 ++++++++++++++++++++++++++++++++++++++++++=
++++++
 io/statx.h              | 162 +++++++++++++++++++
 libxfs/libxfs_priv.h    |  40 +----
 libxfs/util.c           |   9 ++
 libxfs/xfs_dir2_priv.h  |   3 +-
 libxfs/xfs_dir2_sf.c    |  63 +++++---
 libxfs/xfs_inode_fork.c |  35 ++--
 libxfs/xfs_inode_fork.h |   2 +-
 man/man5/xfs.5          |   6 +
 man/man8/xfs_io.8       |  36 ++++-
 repair/dinode.c         |   5 +
 repair/phase2.c         |   9 +-
 repair/phase5.c         |  63 +++-----
 23 files changed, 736 insertions(+), 297 deletions(-)
 create mode 100644 io/stat.c
 create mode 100644 io/statx.h


--f4WnjxJP19ENpgTN1koGl21TOeIXnqihl--

--DfRErrdG9F3VnBj0jfDeiFIp0kBulApWI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJY7VCXAAoJECCuFpLhPd7gABcP+gMsjXAkS3MVh0cvzRIyQbKv
+tABCbviXP77wfgfv/LZ0npr0cVDN25IpO7ztknjcb/xujhbF3/LL/SzVEuKZIl6
qWkS2mbg8FSAA+TikarhdMCZfqAt4pIEEYu5WswkIQ8U02iBJ9Cya4lL6ydC/zlq
wF+M38Vj5ENfV6JDd2YNG8uiRPcu0x1D5R/g2cXmGKIOfHuYS2D4QC2zfBLuI4Ux
X12A3UEicO6tGjrkHT38x08oaenUaK2zGszZa1HPnSgfF9F5SvLRfaTlUbDcAX2p
B/6/0uMCI+Bdj1P5D0cUcF1PKpCnS7rQmt7JxgWJ6IUbGhqgGyPySvHSDZTynv6X
HyVv2vkTHT1TBk42PJcUj7NcDFJmIAPaGwPMr1pzEgW+z6Jwpb5H+7woHWxk0KIU
SXflgK/6VxWGZ4rgHMk+geqqq3XqCasERqVfcVKYnusjYNQ4vCwvuDW/Uf4kWCCs
TYnBaEdTbEyTIXLzn+RNzxmQXSm9xcVWZPCNgv5iG8ZPab1pOE9PoTZfCzs6TiWb
S6kVsl2qTwhXQWDiROdi50BrSMjUp+X7ED33NpwfztTsH/FisBgemg7AVnsuni4L
uWxMhXl80xCsk7t+ssK5eyMa3rrblnHMwcPPbXtSerGJHCVLqzUqYdlxc8ZAChQO
vU82vqxohg8u8aIwurzL
=ZWZ9
-----END PGP SIGNATURE-----

--DfRErrdG9F3VnBj0jfDeiFIp0kBulApWI--
