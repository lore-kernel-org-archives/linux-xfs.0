Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53800 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391538AbfDRSXZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Apr 2019 14:23:25 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 565DF450A82
        for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2019 13:22:47 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to b8aba37
Message-ID: <619d0edb-6914-cd37-e4d9-2a94d19341e7@sandeen.net>
Date: Thu, 18 Apr 2019 13:23:22 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="C9UHgQqTKdTCx2K07QZGJqiGumnAmo4ov"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--C9UHgQqTKdTCx2K07QZGJqiGumnAmo4ov
Content-Type: multipart/mixed; boundary="sHtLirSTH4ejnYCuoTO13sL6yfXNW53zV";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <619d0edb-6914-cd37-e4d9-2a94d19341e7@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to b8aba37

--sHtLirSTH4ejnYCuoTO13sL6yfXNW53zV
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

b8aba37 xfsprogs: remove unused function prototypes

New Commits:

Darrick J. Wong (21):
      [9cfe71b] mkfs: validate extent size hint parameters
      [728a6a8] xfs_repair: reinitialize the root directory nlink  correc=
tly
      [297078c] xfs_repair: bump the irec on-disk nlink when adding  lost=
+found
      [f008949] xfs_repair: fix uninitialized variable warnings
      [95e379d] xfs_repair: refactor buffer ops assignments during  phase=
 5
      [f5aa050] xfs_repair: pass ops through during scan
      [a2d9815] libfrog: hoist bitmap out of scrub
      [a27cf9e] libxfs: refactor the open-coded libxfs_trans_bjoin  calls=

      [f8100fa] libxfs: remove libxfs_trans_iget
      [0cc7b71] xfs_scrub: include unicrash.h in unicrash.c
      [afbb713] xfs_io: don't read garbage stack contents if INUMBERS  go=
es nuts
      [8c87579] xfs_io: fix label parsing and validation
      [20fb1bc] xfs_repair: better cli option parameter checking
      [346e90c] xfs_db: refactor metadump handling of multi-fsb objects
      [041b431] xfs_db: refactor multi-fsb object detection  decision mak=
ing
      [1e1a512] xfs_db: metadump should handle symlinks properly
      [cccfe9d] xfs_scrub: remove xfs_ prefixes from structure names
      [fef860a] xfs_scrub: rename confusing structure
      [771859e] xfs_scrub: remove pointless xfs_verify_error_info  struct=

      [86f4d9a] mkfs: don't use DIFLAG values for fsx_xflags
      [0457721] xfs_scrub: remove redundant function declarations

Eric Sandeen (2):
      [7026a78] xfs_scrub: fix typo in unicrash header file
      [b8aba37] xfsprogs: remove unused function prototypes


Code Diffstat:

 db/crc.h                    |  1 -
 db/faddr.h                  |  1 -
 db/io.h                     |  3 +-
 db/metadump.c               | 92 ++++++++++++++++++++++++++++++++++-----=
------
 {scrub =3D> include}/bitmap.h |  6 +--
 include/input.h             |  1 -
 include/libxlog.h           |  1 -
 include/xfs_trans.h         |  2 -
 io/label.c                  | 10 ++++-
 io/open.c                   |  3 ++
 libfrog/Makefile            |  1 +
 {scrub =3D> libfrog}/bitmap.c |  0
 libxfs/libxfs_api_defs.h    |  1 -
 libxfs/libxfs_io.h          |  1 -
 libxfs/trans.c              | 53 ++------------------------
 libxfs/util.c               |  4 +-
 libxfs/xfs_dir2_priv.h      |  4 --
 mkfs/xfs_mkfs.c             | 89 +++++++++++++++++++++++++++++++++++++++=
++--
 repair/dinode.c             |  4 +-
 repair/phase5.c             | 54 ++++++++++++++++++++------
 repair/phase6.c             | 37 +++++++++++-------
 repair/phase7.c             |  4 +-
 repair/scan.c               | 39 ++++++++-----------
 repair/xfs_repair.c         | 12 ++++++
 scrub/Makefile              |  2 -
 scrub/phase5.c              |  8 ++--
 scrub/phase6.c              | 92 ++++++++++++++++++++-------------------=
------
 scrub/phase7.c              | 66 ++++++++++++++++----------------
 scrub/scrub.h               |  2 -
 scrub/unicrash.c            |  1 +
 scrub/unicrash.h            |  2 +-
 31 files changed, 356 insertions(+), 240 deletions(-)
 rename {scrub =3D> include}/bitmap.h (87%)
 rename {scrub =3D> libfrog}/bitmap.c (100%)


--sHtLirSTH4ejnYCuoTO13sL6yfXNW53zV--

--C9UHgQqTKdTCx2K07QZGJqiGumnAmo4ov
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAly4wJsACgkQIK4WkuE9
3uAE3Q//Q2tVat4ofFz2f+yIHbCBaj33cdh4No9blVGhzZ2UOQobtCQ+voNf5A8q
FIj76SIW6U1gtW2XEfMn3cpHDO1JkSJhnbjE22ImpRrSwqjHuk0Z22vPp2hA7i9H
kS8YvJtDQ0bZp5c5glNNy77TGrcIRNsWrToAacKMRYsNnnWOAZCHlaNFhwc/NFjn
K5vVFAr2D2Z/9V3ZukUQzs7rKL2dETfQMYB9PatGFngzAcDqAYLflWg22uIZyYTH
AE22eikvpW3u4azA8ETYcMbMMJVElMoo8h16MdrcUprvwDOquigihfcXCiQMqFQr
R7octvVA2ZYrBDCVFtHWqnlS6wKBvVeIIyVKXfsgGcUvgLlb2IvhOsZUPNogZmdP
Y1f3yPU9uGZ3CNyC1LabRcp+t73++zNOXeyZ1qLS15D2IVioEvCKzIFmEZ1eR9vb
ZWskfLj8b+L9f293FqkhMFGuDyt2VMbBML8ZUoxFVWLGHFsWA6kgvrQzc0YnNxe5
196HNcY36K5qTjKkaJ6q08kexmYGeOqBYkzLeESrZ1s7yEU0AVR8jJye1ec5OrH6
2IOCzAXp4audEVAh4IRtf1mk12BorszcJSgLExsdhXtVGRnUgXbNEfgneryLYnrx
EfXkbht0n0TFUIPLI+YY/o9490lg05xOqcCqM+SO4krYroE6ZzY=
=lah/
-----END PGP SIGNATURE-----

--C9UHgQqTKdTCx2K07QZGJqiGumnAmo4ov--
