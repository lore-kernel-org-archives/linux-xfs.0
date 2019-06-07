Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39442 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731802AbfFGSZu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Jun 2019 14:25:50 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7DF722B45
        for <linux-xfs@vger.kernel.org>; Fri,  7 Jun 2019 13:25:24 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to ec1b42e
Message-ID: <f938e2bd-fd02-7523-3ed6-a418e91b1ed0@sandeen.net>
Date: Fri, 7 Jun 2019 13:25:48 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2PDssPknkLSrqk9x6TviKcJrXqbjDB9Vu"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2PDssPknkLSrqk9x6TviKcJrXqbjDB9Vu
Content-Type: multipart/mixed; boundary="4qWX6FSeAJ6wKLzVMprFiobMiDza4Bb2O";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <f938e2bd-fd02-7523-3ed6-a418e91b1ed0@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to ec1b42e

--4qWX6FSeAJ6wKLzVMprFiobMiDza4Bb2O
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

ec1b42e mkfs: enable reflink by default

New Commits:

Darrick J. Wong (7):
      [6778635] libxfs: fix attr include mess
      [f747f7d] libxfs: set m_finobt_nores when initializing library
      [2668d32] misc: remove all use of xfs_fsop_geom_t
      [93ab49d] libfrog: fix bitmap return values
      [b8aa6f2] xfs_repair: refactor namecheck functions
      [1500ee2] xfs_scrub: fix background-mode sleep throttling
      [ec1b42e] mkfs: enable reflink by default


Code Diffstat:

 growfs/xfs_growfs.c      |  4 +--
 include/bitmap.h         |  8 ++---
 include/libxfs.h         | 10 +-----
 io/init.c                |  2 +-
 io/io.h                  |  6 ++--
 io/open.c                |  6 ++--
 libfrog/bitmap.c         | 86 +++++++++++++++++++++++-------------------=
------
 libxfs/init.c            |  1 +
 libxfs/libxfs_api_defs.h |  7 ++++
 libxfs/libxfs_priv.h     |  8 -----
 libxfs/xfs_attr.c        |  1 +
 libxfs/xfs_attr_leaf.c   |  1 +
 man/man3/xfsctl.3        |  2 +-
 man/man8/mkfs.xfs.8      |  9 ++++-
 mkfs/xfs_mkfs.c          | 16 ++++-----
 repair/attr_repair.c     | 32 ++++++++----------
 repair/da_util.c         | 27 ---------------
 repair/da_util.h         |  6 ----
 repair/dir2.c            | 12 ++-----
 repair/rmap.c            | 18 ++++++----
 scrub/common.c           | 12 ++++---
 scrub/phase6.c           | 18 ++++------
 spaceman/file.c          |  4 +--
 spaceman/init.c          |  2 +-
 spaceman/space.h         |  6 ++--
 25 files changed, 130 insertions(+), 174 deletions(-)


--4qWX6FSeAJ6wKLzVMprFiobMiDza4Bb2O--

--2PDssPknkLSrqk9x6TviKcJrXqbjDB9Vu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlz6rC0ACgkQIK4WkuE9
3uDQUg/+NsvYdnoONIAat5j/7K4dZhH+4YoDp0eGj5SuxUhcvhR6aRp9iuaQNg1w
lkMJLvjJT5+EPmqXTqe/A+gsfL0NJ6DNG35jiZ0XXo4WPHLMp+Z7IeuFRYrGKeN+
rjhGZlz3zNhSYDpjX8nb09mdJseUDIOOcixBXfhJOxPpQIktk98t3ninh3YlDIq9
Vl44D/auvAUs4AKInK2mgfdfn1aP4pjt2WzbVGEKLZ9LILmGL3ubl0GSRzYaDrUC
8+vKfxSWX9u8x4KsGhf0foNeYXQS7wdtcIiN8Lx8Thugc3pM3btBP8yWx+xF1U7c
TL+/G9Gw1npRtkVYgkZlAAMHu1vEjE5UERf4kom7CjnQRXz2rrG6xP/lMhMTzGIS
tp0EIp0ZHsDX4qARLjbF+fqZQtqLEms9mY5QByuw+84IOG60uTM+xN+SkU+rwvgp
QcZwTO0EN5DtmQ4YDeNDwrF7AQ0LdGLLUOsToJjCtsRDwk/mmgO91b1UYvSCyh9A
aoPoRyanp6RLskYIfJhPpwp/6uimCAp9chAwKfYblGDnQbxrv6zCkr9h2faBu3s9
tG70kSw3DqVohlmwJY2/MnWlPMVFo3zbQ1MblS1qBCtYbJleq2h4lCSWb6yT44lR
UBEYvNzXGJBH9n4V/go7FvsPoz3vr15AbR6D7eoLFqisbiFVfNU=
=GeTP
-----END PGP SIGNATURE-----

--2PDssPknkLSrqk9x6TviKcJrXqbjDB9Vu--
