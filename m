Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40046 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751788AbdLFP2u (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Dec 2017 10:28:50 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 4545A3262
        for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2017 09:28:12 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 70c1cce
Message-ID: <fbe15ea6-9668-afa0-728e-47480098faff@sandeen.net>
Date: Wed, 6 Dec 2017 09:28:48 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RJQB3BThUM6GrUMTpnVPeabdAbwPgXexe"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RJQB3BThUM6GrUMTpnVPeabdAbwPgXexe
Content-Type: multipart/mixed; boundary="M35dhQVdM55P6LDc0cnPxi6L0LKGdpdnT";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <fbe15ea6-9668-afa0-728e-47480098faff@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 70c1cce

--M35dhQVdM55P6LDc0cnPxi6L0LKGdpdnT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
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

70c1cce xfs_db: add missing padding fields

mkfs refactoring comes next.

New Commits:

Darrick J. Wong (17):
      [904d971] xfs_io: pull xfs errortag definitions from libxfs
      [813c67c] xfs_io: provide an interface to the scrub ioctls
      [5591018] man: describe the metadata scrubbing ioctl
      [5caa042] libfrog: move all the userspace support stuff into a new =
library
      [24f4f99] libfrog: move libxfs_log2_roundup to libfrog
      [1ca68d6] libfrog: add bit manipulation functions
      [b28b84c] libfrog: move list_sort out of libxfs
      [67f3faf] libfrog: promote avl64 code from xfs_repair
      [f434fd9] libfrog: create a threaded workqueue
      [695fc50] libfrog: move topology code out of libxcmd
      [b95410d] libfrog: move conversion factors out of libxcmd
      [bd987fe] libfrog: move paths.c out of libxcmd
      [ce1abf9] libfrog: add missing function fs_table_destroy
      [852fe01] libhandle: add missing destructor
      [62843f3] xfs_repair: remove old workqueue stuff in favor of libfro=
g code
      [31df6ad] xfs_db: print structure padding fields consistently
      [70c1cce] xfs_db: add missing padding fields

Dave Chinner (1):
      [41198ef] xfs_io: fix gcc-7 related printf warnings

Eric Sandeen (1):
      [fc60b66] xfs_io: add buf_lru_ref tag to inject table

Nikolay Borisov (1):
      [7c18973] xfs_io: implement ranged fiemap query


Code Diffstat:

 Makefile                            |   6 +-
 copy/Makefile                       |   4 +-
 db/Makefile                         |   4 +-
 db/agi.c                            |   3 +-
 db/attr.c                           |   2 +-
 db/dir2.c                           |   5 +-
 db/dquot.c                          |   2 +-
 db/inode.c                          |   2 +
 debian/rules                        |   2 +-
 growfs/Makefile                     |   4 +-
 {repair =3D> include}/avl64.h         |   0
 include/bitops.h                    |  58 ++++++
 include/builddefs.in                |   1 +
 include/convert.h                   |  37 ++++
 include/handle.h                    |   2 +
 include/input.h                     |  15 +-
 include/libfrog.h                   |  23 +++
 include/libxfs.h                    |   2 +-
 include/workqueue.h                 |  55 ++++++
 include/xfs.h                       |   4 +
 io/Makefile                         |   7 +-
 io/fiemap.c                         |  81 ++++++--
 io/fsmap.c                          |   4 +-
 io/init.c                           |   1 +
 io/inject.c                         |  37 +---
 io/io.h                             |   2 +
 io/scrub.c                          | 252 +++++++++++++++++++++++
 libfrog/Makefile                    |  38 ++++
 {repair =3D> libfrog}/avl64.c         |   4 +-
 libfrog/convert.c                   | 384 ++++++++++++++++++++++++++++++=
++++++
 {libxfs =3D> libfrog}/list_sort.c     |   7 +-
 {libxcmd =3D> libfrog}/paths.c        |  20 ++
 {libxcmd =3D> libfrog}/projects.c     |   0
 {libxfs =3D> libfrog}/radix-tree.c    |  26 +--
 {libxcmd =3D> libfrog}/topology.c     |   0
 libfrog/util.c                      |  36 ++++
 libfrog/workqueue.c                 | 174 ++++++++++++++++
 libhandle/handle.c                  |  13 ++
 libxcmd/Makefile                    |  10 +-
 libxcmd/input.c                     | 375 ------------------------------=
-----
 libxfs/Makefile                     |   2 -
 libxfs/util.c                       |  12 --
 logprint/Makefile                   |   4 +-
 man/Makefile                        |   2 +-
 man/man2/Makefile                   |  22 +++
 man/man2/ioctl_xfs_scrub_metadata.2 | 318 +++++++++++++++++++++++++++++
 man/man8/xfs_io.8                   |  22 ++-
 mdrestore/Makefile                  |   4 +-
 mkfs/Makefile                       |   5 +-
 mkfs/maxtrres.c                     |   4 +-
 mkfs/xfs_mkfs.c                     |   4 +-
 quota/Makefile                      |   4 +-
 repair/Makefile                     |  10 +-
 repair/phase3.c                     |  16 +-
 repair/phase4.c                     |  26 +--
 repair/phase6.c                     |   4 +-
 repair/phase7.c                     |   9 +-
 repair/prefetch.c                   |  20 +-
 repair/prefetch.h                   |   4 +-
 repair/sb.c                         |   4 +-
 repair/scan.c                       |  16 +-
 repair/slab.c                       |   4 +-
 repair/threads.c                    | 125 ++----------
 repair/threads.h                    |  38 +---
 spaceman/Makefile                   |   4 +-
 65 files changed, 1677 insertions(+), 708 deletions(-)
 rename {repair =3D> include}/avl64.h (100%)
 create mode 100644 include/convert.h
 create mode 100644 include/libfrog.h
 create mode 100644 include/workqueue.h
 create mode 100644 io/scrub.c
 create mode 100644 libfrog/Makefile
 rename {repair =3D> libfrog}/avl64.c (99%)
 create mode 100644 libfrog/convert.c
 rename {libxfs =3D> libfrog}/list_sort.c (98%)
 rename {libxcmd =3D> libfrog}/paths.c (97%)
 rename {libxcmd =3D> libfrog}/projects.c (100%)
 rename {libxfs =3D> libfrog}/radix-tree.c (97%)
 rename {libxcmd =3D> libfrog}/topology.c (100%)
 create mode 100644 libfrog/util.c
 create mode 100644 libfrog/workqueue.c
 create mode 100644 man/man2/Makefile
 create mode 100644 man/man2/ioctl_xfs_scrub_metadata.2


--M35dhQVdM55P6LDc0cnPxi6L0LKGdpdnT--

--RJQB3BThUM6GrUMTpnVPeabdAbwPgXexe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlooDLEACgkQIK4WkuE9
3uDodxAAiuZz7PQesKyPUoYT75th8jrqJ91WcBYPEX/8rcxLWRz7AXnmvO5jVN2E
T/g8+opvOigEaUMhz27ZSl0/mrkNsE/sUZfAyVrUr/nab6WlVCnAdrcpOPFF+zX5
BAJ4lwb2cLXlbuwcs7HeeD8CRC5JU4ZkmNneA3urlEmZZ3fWzyjDvKPk+W19g36Q
hjZ8DR6Uj2qmcp+0MQ5hxr9Ns0KXH+7C9QNe4YBBFQoLW+/qlQKC4YQ0JmStoTQ2
wA8MXgGgL4lUpe2J8ygrf7Ai11vh+02xEBEzSxtaY9JayxLlw5g8NZZqFmZLw4VP
vICE4ciaf5KagXub/qIkfjUt5fBSydSoqGWJUdT4gnvKy58z7ydUOAVz4K6IakrP
9v9MYCj3XH1HuvxC+oRvoofJrkT7suDWe5HKc3u+ams1nXGLpap7tpAbY/H5Z5Nf
IxkjVBsMFFEbevQVbLsYoqhNebsaEo3UgwBSGm/qVq3ftYYDlOG1FYepXKNa/7a2
K/6gypakmsg0saYzcPzgN7XUQffLusFiyaFlaTH3v2xkhkSeD1KPf3fDSP7uVVcH
+f2mnzRznV1COBOUSV6E0t5PW/7vYyQGYR7Gm+TaoxtIj6n7rsEfN1YKz7ey6fRU
uPWcjtfB8voShTAY3RQPe1mdqXwpnknUWX3aGQL5PHWUKaMTZWA=
=0Ys2
-----END PGP SIGNATURE-----

--RJQB3BThUM6GrUMTpnVPeabdAbwPgXexe--
