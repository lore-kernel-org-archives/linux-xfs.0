Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37782 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752498AbeADUHV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Jan 2018 15:07:21 -0500
Received: from [10.0.0.4] (erlite [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2DE9D2AB8
        for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2018 14:07:20 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 532d03d
Message-ID: <edd1c5b5-1cb7-d777-1f9a-ca3e48263050@sandeen.net>
Date: Thu, 4 Jan 2018 14:07:18 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Dc00H4VVKJqCIy175eiTRKJvTAJGjpfhV"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Dc00H4VVKJqCIy175eiTRKJvTAJGjpfhV
Content-Type: multipart/mixed; boundary="u1rfwKYZfM9Fks7qtpaVxTU5RftnhZwX0";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <edd1c5b5-1cb7-d777-1f9a-ca3e48263050@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 532d03d

--u1rfwKYZfM9Fks7qtpaVxTU5RftnhZwX0
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

532d03d xfs_repair: fix libxfs namespace problems

New Commits:

Brian Foster (1):
      [5963006] xfs: refactor buffer logging into buffer dirtying helper

Christoph Hellwig (1):
      [c1a29e9] xfs: remove "no-allocation" reservations for file creatio=
ns

Darrick J. Wong (11):
      [6f67c32] xfs: add the ability to join a held buffer to a defer_ops=

      [3fbc4d7] xfs: hold xfs_buf locked between shortform->leaf conversi=
on and=20
      [db2cf1d] xfs: account for null transactions in bunmapi
      [6428e6c] xfs: move xfs_iext_insert tracepoint to report useful inf=
ormatio
      [a44b23a] xfs: queue deferred rmap ops for cow staging extent alloc=
/free i
      [3ee858a] xfs: always honor OWN_UNKNOWN rmap removal requests
      [19f9a63] xfs: only skip rmap owner checks for unknown-owner rmap r=
emoval
      [1ad4d3b] libhandle: zap fdhash in fshandle_destroy
      [b638281] xfs_db: check should deal with cow staging extents correc=
tly
      [945e47e] xfs_db: fix crash when field list selector string has tra=
iling s
      [532d03d] xfs_repair: fix libxfs namespace problems

Dave Chinner (7):
      [a9857ca] mkfs: use opts parameter during option parsing
      [a6fb6ab] mkfs: simplify minimum log size calculation
      [f1301cc] mkfs: protofile only needs to be set up once
      [cedf1c4] mkfs: support arbitrary conflict specification
      [64e924d] mkfs: convert subopt name, val pairs to enums and declare=
d array
      [6c75555] mkfs: resolve sector size CLI conflicts
      [2cf637c] mkfs: remove logarithm based CLI options

Eric Sandeen (10):
      [5c40ca1] xfs: fix leaks on corruption errors in xfs_bmap.c
      [df90234] Merge branch 'libxfs-4.15-sync' into for-next
      [b729d14] mkfs: Don't emit default config message yet
      [ec64d06] mkfs: remove unused m_uuid in sb_feat_args
      [639d0b0] mkfs: invert project id width boolean name
      [852b325] mkfs: document sb_feat_args members
      [129d98a] mkfs: remove use-once default macros
      [c66bd30] mkfs: un-document removed logarithm based CLI options
      [e5e612a] mkfs: pass switch case value directly into getnum/getstr
      [9502da2] mkfs: do not allow both "dev" and "name" subopts for log =
or real

Ross Zwisler (2):
      [dad7968] xfs_io: add MAP_SYNC support to mmap()
      [851c5d1] xfs_io: add a new 'log_writes' command


Code Diffstat:

 configure.ac             |   2 +
 db/check.c               |  19 +-
 db/flist.c               |   1 +
 debian/control           |   2 +-
 include/builddefs.in     |   3 +
 include/linux.h          |   8 +
 include/xfs_multidisk.h  |   9 -
 include/xfs_trans.h      |   1 +
 io/Makefile              |  10 +
 io/init.c                |   1 +
 io/io.h                  |   7 +
 io/log_writes.c          | 106 ++++++
 io/mmap.c                |  29 +-
 libhandle/handle.c       |   1 +
 libxfs/libxfs_api_defs.h |   3 +-
 libxfs/trans.c           |  35 +-
 libxfs/util.c            |   7 +-
 libxfs/xfs_alloc.c       |   4 +-
 libxfs/xfs_attr.c        |  20 +-
 libxfs/xfs_attr_leaf.c   |   9 +-
 libxfs/xfs_attr_leaf.h   |   3 +-
 libxfs/xfs_bmap.c        |   8 +-
 libxfs/xfs_defer.c       |  39 ++-
 libxfs/xfs_defer.h       |   5 +-
 libxfs/xfs_ialloc.c      |  10 +-
 libxfs/xfs_ialloc.h      |   1 -
 libxfs/xfs_iext_tree.c   |   4 +-
 libxfs/xfs_refcount.c    |  52 ++-
 libxfs/xfs_rmap.c        |  99 ++++--
 libxfs/xfs_rmap.h        |  16 +-
 m4/Makefile              |   1 +
 m4/package_devmapper.m4  |  11 +
 m4/package_libcdev.m4    |  16 +
 man/man8/mkfs.xfs.8      |  58 ++--
 man/man8/xfs_io.8        |  29 +-
 mkfs/Makefile            |   2 +-
 mkfs/maxtrres.c          | 102 ------
 mkfs/xfs_mkfs.c          | 828 ++++++++++++++++++++++-------------------=
------
 repair/dino_chunks.c     |   2 +-
 repair/phase6.c          |   2 +-
 40 files changed, 858 insertions(+), 707 deletions(-)
 create mode 100644 io/log_writes.c
 create mode 100644 m4/package_devmapper.m4
 delete mode 100644 mkfs/maxtrres.c


--u1rfwKYZfM9Fks7qtpaVxTU5RftnhZwX0--

--Dc00H4VVKJqCIy175eiTRKJvTAJGjpfhV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlpOiXcACgkQIK4WkuE9
3uCuGQ/7BwGekR/PXSib0FL4CjYIlI/ZKEu4LaXTgsQ8Dd025Qpsdz3VViksvHjd
mB1VMsQuXg9xP3BV+G9i5NxCquNH3R+XW9x/Z/j83Yzyysoq9hjCfoXdYXwfYIBb
Y5XT2I1VtdSstIV+juSfJBH8PnSNz/x/TdkDVx6LnFrjRsXjf0rqK0ABalMKtxTJ
1K+im3oji1IiF+7qOlNT/+JFncYPo7OKrFmgZBdQ8lqyDyTkyPGE41TNkkZTpu4h
uBsJWWwZrZTzNMe3VCt4KjldJh6DgkxXZKiuhHzUgzyuYuWoguYHXuW/iuap7NZb
J8jvusI7f4BSkWcW1TVgYNAWJJVX1nbAYlkHiwR8lVtBwkZdxNBbcZbMK6hqMLkj
vmewo5M/Ux3/R8Nsy2Cf6e0HcEmicyJl7YmRKtIQLD0qt2Pi1fKRPK1WJT7t1Gfp
A3i4B1B9ODnL8TmXKfAIz7HS8u7lV09SblIyEsyme3h1L9uuYACykDsqmWvjrJ1t
+rd0ijQpYvohegY7BdhTp09LEVtBwmrfieT6VtHDIZg0u9VARiZ3A+paUw6TBL8e
ntBZgHkyjkXF3UpKtdDSxlxDq9ufROCTXgN7hyhxJSHqFSf/IXPBYVoTQAhE2DuA
cIgnGG88bSpxgZ81gCD9Rp3zR3Z6YaGbr+sUYAySKthALcI73Sg=
=P8kh
-----END PGP SIGNATURE-----

--Dc00H4VVKJqCIy175eiTRKJvTAJGjpfhV--
