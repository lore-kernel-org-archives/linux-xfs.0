Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53802 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729062AbfGLCAO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jul 2019 22:00:14 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E9916D5E
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2019 21:00:04 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.1.0-rc1 tagged
Message-ID: <f28373cc-94c8-3640-2839-86302cdab6f0@sandeen.net>
Date: Thu, 11 Jul 2019 21:00:11 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8mjlSamgIZcXEqGDLyM2CDNnFHlnSq3KU"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8mjlSamgIZcXEqGDLyM2CDNnFHlnSq3KU
Content-Type: multipart/mixed; boundary="KkZsATsa3W7nVGKnuaIbWcffUbemEemgw";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <f28373cc-94c8-3640-2839-86302cdab6f0@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.1.0-rc1 tagged

--KkZsATsa3W7nVGKnuaIbWcffUbemEemgw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

f5de3c7 xfsprogs: Release v5.1.0-rc1

Barring horrific problems this will be what is released as
5.1.0, so if I'm missing something speak up now.

New Commits:

Allison Collins (1):
      [59cf967] xfsprogs: Fix uninitialized cfg->lsunit

Alvin Zheng (1):
      [c72f16b] mkfs.xfs.8: Fix an inconsistency between the code and the=
 man page.

Amir Goldstein (1):
      [10d4ca4] xfs_io: allow passing an open file to copy_range

Darrick J. Wong (9):
      [21e8caf] man: create a separate GETXATTR/SETXATTR ioctl manpage
      [b427c81] man: create a separate GEOMETRY ioctl manpage
      [9a59e45] man: create a separate FSBULKSTAT ioctl manpage
      [6237c49] man: link to the SCRUB_METADATA ioctl manpage from xfsctl=
=2E3
      [59f96d9] man: create a separate INUMBERS ioctl manpage
      [1a7af84] man: create a separate FSCOUNTS ioctl manpage
      [cb5c5cb] man: create a separate RESBLKS ioctl manpage
      [647d25c] man: create a separate GETBMAPX/GETBMAPA/GETBMAP ioctl ma=
npage
      [8a91e33] man: create a separate xfs shutdown ioctl manpage

Eric Sandeen (3):
      [9c726ef] mkfs: don't use xfs_verify_fsbno() before m_sb is fully s=
et up
      [328148f] xfs_io: reorganize source file handling in copy_range
      [f5de3c7] xfsprogs: Release v5.1.0-rc1

Yang Xu (1):
      [b68e255] mkfs: remove useless log options in usage


Code Diffstat:

 VERSION                            |   2 +-
 configure.ac                       |   2 +-
 debian/changelog                   |   6 +
 doc/CHANGES                        |  15 ++
 io/copy_file_range.c               |  30 ++-
 man/man2/ioctl_xfs_fsbulkstat.2    | 216 +++++++++++++++++++++
 man/man2/ioctl_xfs_fscounts.2      |  69 +++++++
 man/man2/ioctl_xfs_fsgetxattr.2    | 242 +++++++++++++++++++++++
 man/man2/ioctl_xfs_fsgetxattra.2   |   1 +
 man/man2/ioctl_xfs_fsinumbers.2    | 122 ++++++++++++
 man/man2/ioctl_xfs_fsop_geometry.2 | 221 +++++++++++++++++++++
 man/man2/ioctl_xfs_fssetxattr.2    |   1 +
 man/man2/ioctl_xfs_getbmap.2       |   1 +
 man/man2/ioctl_xfs_getbmapa.2      |   1 +
 man/man2/ioctl_xfs_getbmapx.2      | 176 +++++++++++++++++
 man/man2/ioctl_xfs_getresblks.2    |  67 +++++++
 man/man2/ioctl_xfs_goingdown.2     |  60 ++++++
 man/man2/ioctl_xfs_setresblks.2    |   1 +
 man/man3/xfsctl.3                  | 386 +++++++------------------------=
------
 man/man8/mkfs.xfs.8                |  14 +-
 man/man8/xfs_io.8                  |  10 +-
 mkfs/xfs_mkfs.c                    |  11 +-
 22 files changed, 1306 insertions(+), 348 deletions(-)
 create mode 100644 man/man2/ioctl_xfs_fsbulkstat.2
 create mode 100644 man/man2/ioctl_xfs_fscounts.2
 create mode 100644 man/man2/ioctl_xfs_fsgetxattr.2
 create mode 100644 man/man2/ioctl_xfs_fsgetxattra.2
 create mode 100644 man/man2/ioctl_xfs_fsinumbers.2
 create mode 100644 man/man2/ioctl_xfs_fsop_geometry.2
 create mode 100644 man/man2/ioctl_xfs_fssetxattr.2
 create mode 100644 man/man2/ioctl_xfs_getbmap.2
 create mode 100644 man/man2/ioctl_xfs_getbmapa.2
 create mode 100644 man/man2/ioctl_xfs_getbmapx.2
 create mode 100644 man/man2/ioctl_xfs_getresblks.2
 create mode 100644 man/man2/ioctl_xfs_goingdown.2
 create mode 100644 man/man2/ioctl_xfs_setresblks.2


--KkZsATsa3W7nVGKnuaIbWcffUbemEemgw--

--8mjlSamgIZcXEqGDLyM2CDNnFHlnSq3KU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl0n6awACgkQIK4WkuE9
3uAjoA//dLzPh+ofNgTx3zKubXpIXnIhmNtoKrW2/QkoNO9pcqN3KG8dRGYOnQyF
aoi43fwWpXWimf0d8xgOOV73S4n3zefzFZ9cQ9sKO+1RK7cNlMJ3OcOLD1E9LnGQ
25SYecGnzKijpYfSe7SlV4QN8SZbohTNbOTWQUvtCRywjoSJ6F7QgOp2GmXCgKX0
jJEmjpxVPnW+OCSJYDH1GprWwXU8hfPSZLLI8Vc20SpYMeX1fPdiiJEgyruVDS4Y
icKvKy/Eg98RhwcAHZM77EIbVPYfaJrvobcRNC4kYtjKvHc6HbCQgYRrNMl2pp0F
aZWZDC1BZLbioe0m8R2/nN70BZeZr4Pvk68PGsGtcwQH4e+NlUM/hDgZT82pZkPg
06ZQxuKSpcLCr5XrBKUBYHhI2hIMEN9VxznIkWp23EjcXNNQihM1lIflK4HOknT4
lZEzUYVjFcXl/M+hKol5nyyjRfz2YEiY2UJFTlw3uOhGTzGFonn3cEQmtS8YzvW2
BxM3MCM6MlTojhb7+sxelEhNb0Xczr1f7VbHAl+zWUpPu08VvGFk4AJp/eZoxQAW
fOcONWXaoKbDH2TxWYNmKsDQPrX6KNbaqD+tom2tdqd2EO/mhI9up3+2Qbza0ZJ3
sXDslJ0bK6EMo9O2am0+bsV8ATPWDAoBWLWP7yfTgMCLJD2U7Sg=
=xpoj
-----END PGP SIGNATURE-----

--8mjlSamgIZcXEqGDLyM2CDNnFHlnSq3KU--
