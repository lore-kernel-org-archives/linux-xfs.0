Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39220 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752299AbdAZCH2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jan 2017 21:07:28 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id BFA8F2B46
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2017 20:06:20 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next branch updated to ae9069f
Message-ID: <4da2a262-75cd-d4d9-89e9-6036e87e9c05@sandeen.net>
Date: Wed, 25 Jan 2017 20:07:20 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AwQR1hqtsE7Uk3fDn9QmlbdO8et6cLTmb"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AwQR1hqtsE7Uk3fDn9QmlbdO8et6cLTmb
Content-Type: multipart/mixed; boundary="LwjhHHQEQxfFtx7E2A8dWW0dmJjse4Um2";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <4da2a262-75cd-d4d9-89e9-6036e87e9c05@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next branch updated to ae9069f

--LwjhHHQEQxfFtx7E2A8dWW0dmJjse4Um2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

ae9069f tools/find-api-violations: fix fs -> fsr in the directory list

This does the -rc5 libxfs sync, as well as miscellaneous fixes accumulate=
d
since the last push.

After a bit of soak I'll push it all to master as well.

Thanks,
-Eric

New Commits:

Amir Goldstein (5):
      [3cfabff] xfs: sanity check directory inode di_size
      [3e86cfd] xfs: add missing include dependencies to xfs_dir2.h
      [3297e0c] xfs: replace xfs_mode_to_ftype table with switch statemen=
t
      [0962b5b] xfs: sanity check inode di_mode
      [eb24bcf] xfs_io: fix missing syncfs command

Christoph Hellwig (1):
      [744a862] xfsprogs: remove irix support

Darrick J. Wong (5):
      [c8dc423] xfs_db: fix the 'source' command when passed as a -c opti=
on
      [02b56f8] xfs_repair: strengthen geometry checks
      [fa2a8c1] xfs_repair: zero shared_vn
      [ce746a2] xfs_repair: trash dirattr btrees that cycle to the root
      [ae9069f] tools/find-api-violations: fix fs -> fsr in the directory=
 list

Eric Sandeen (1):
      [a547152] libxfs: sanitize agcount on load

Eryu Guan (1):
      [6954769] xfs_io: add DAX and CoW extent-size flags to chattr manpa=
ge

Hou Tao (1):
      [04f1d80] xfs_logprint: handle log operation split of inode item co=
rrectly

chandan (1):
      [47dd674] xfs_db: Interpret inode's di_format field as unsigned


Code Diffstat:

 configure.ac                 |   1 +
 db/init.c                    |   8 +-
 db/inode.c                   |   2 +-
 db/input.c                   |  43 +++++++---
 db/metadump.c                |  10 +++
 doc/INSTALL                  |  44 -----------
 include/Makefile             |   2 +-
 include/builddefs.in         |   5 +-
 include/irix.h               | 491 -------------------------------------=
-------------------------------------------------------------------------=
---
 include/xfs.h                |   2 -
 io/open.c                    |   4 -
 libxfs/init.c                |  23 ++++++
 libxfs/xfs_dir2.c            |  39 +++++----
 libxfs/xfs_dir2.h            |   8 +-
 libxfs/xfs_inode_buf.c       |  10 ++-
 logprint/log_misc.c          |  30 ++++---
 m4/package_libcdev.m4        |   2 +-
 man/man8/xfs_io.8            |   2 +-
 repair/attr_repair.c         |  17 ++--
 repair/dino_chunks.c         |   6 +-
 repair/globals.h             |   3 +-
 repair/phase1.c              |   7 ++
 repair/phase6.c              |   2 +-
 repair/sb.c                  |  27 ++++---
 repair/xfs_repair.c          |   2 +
 tools/find-api-violations.sh |   2 +-
 26 files changed, 177 insertions(+), 615 deletions(-)
 delete mode 100644 include/irix.h


--LwjhHHQEQxfFtx7E2A8dWW0dmJjse4Um2--

--AwQR1hqtsE7Uk3fDn9QmlbdO8et6cLTmb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJYiVneAAoJECCuFpLhPd7g5IwP/24bT72BxVFKS6x2nTMsJ5Ps
DffWN2y9UCeN6JBt/BjuuxVE1LbRrH2NmARStN4o+CaBCXqYQqXTp6xT9dZuUfeq
KZpuTp7MB+XxH+NA9oMyyr2iXSW40fCFbAFWvyI/tLjxaKjupuOlufMm6AfPgwXY
f4UDepVe+w+a0q06xj9iwSam2SVx0fNphwh2Glzxe2/oEI6Up764gdA4h5AgvdBI
cn9tKMyTaYgMjjzxZf6xt3jbBLbvHz3eFUJX7u0Vl6qMSwzJ40R7351ms5hYA7vh
ECi8J9zfmOLvrlmIeN7uoaTNF6jMw8klxeR5dzGxYytMCFdwwYf4DpY3YUOlHnB8
vzKBOuauWplQD/c1+QNwH5c3yUoYDedRxRO1z/oziq4PpCMCjERf1p2OuWtmzQ/k
YLKNG+OGpmP59hG6KYpEAqU1RQUpuwVNm45PuTJP1a495QMZ9wuAWOaoN52asTya
K02fgcE4QiX6NJshsVsSrfo0DUAGnPQ2+RJgYNIuZGllvKp00FmHuIaj+ZnKTaDl
tF5SkFv2XgUJnVv2yZ9tph4HhXzgfkUJyEJ3j51h3SEx9Xrf/PPKLKqTlMPGfsAb
m50EWWFa4odZ5PmFWnZ7cGeenYLbuexIvZsgBqVmA2tncKU6z0mtnm22yRWfAaSt
lcRUEcUI9+kCbXvLxMR7
=R+25
-----END PGP SIGNATURE-----

--AwQR1hqtsE7Uk3fDn9QmlbdO8et6cLTmb--
