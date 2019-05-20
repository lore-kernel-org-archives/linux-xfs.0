Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55304 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbfETV31 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 17:29:27 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C98D178A9
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 16:29:24 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsdump updated to 86b0b04
Message-ID: <e9755095-5845-9ab6-2148-3af523acd888@sandeen.net>
Date: Mon, 20 May 2019 16:29:24 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qEldC44RxUgWxTwjGZpIifwo6sJJ2696M"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qEldC44RxUgWxTwjGZpIifwo6sJJ2696M
Content-Type: multipart/mixed; boundary="DjEcnM5gtzq4iNt4tty1FU6lXrxrixNOZ";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <e9755095-5845-9ab6-2148-3af523acd888@sandeen.net>
Subject: [ANNOUNCE] xfsdump updated to 86b0b04

--DjEcnM5gtzq4iNt4tty1FU6lXrxrixNOZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsdump repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

86b0b04 xfs_restore: support fallocate when reserving space for a file

New Commits:

Darrick J. Wong (4):
      [c50e407] xfs_restore: refactor open-coded file creation code
      [678f0f3] xfs_restore: check return value
      [0ca06d3] xfs_restore: fix unsupported ioctl detection
      [86b0b04] xfs_restore: support fallocate when reserving space for a=
 file

Jan Tulak (9):
      [354d07d] xsfsdump: (style) remove trailing whitespaces
      [fc342f7] xfsdump: do not split function call with ifdef
      [6ff49bf] common/types.h: Wrap #define UUID_STR_LEN 36 in #ifndef
      [8866703] common/drive.c: include stdlib.h
      [db93af5] xfsdump: don't fail installation if /sbin is symlink of  =
/usr/sbin
      [dae8f55] xfsdump: (style) remove spaces from parentheses
      [cbe6e30] xfsdump: (style) remove spaces in front of commas/semicol=
ons
      [ef3a1e2] xfsdump: (style) remove spaces for pointers and negations=

      [46a0d93] xfsdump: add a space after commas and semicolons where wa=
s none


Code Diffstat:

 common/arch_xlate.c     |   32 +-
 common/cldmgr.c         |  134 +-
 common/cldmgr.h         |   16 +-
 common/cleanup.c        |   68 +-
 common/cleanup.h        |   18 +-
 common/content.h        |   44 +-
 common/content_common.c |   94 +-
 common/content_common.h |    2 +-
 common/content_inode.h  |   94 +-
 common/dlog.c           |  288 +--
 common/dlog.h           |   32 +-
 common/drive.c          |  181 +-
 common/drive.h          |  134 +-
 common/drive_minrmt.c   | 2185 +++++++++----------
 common/drive_scsitape.c | 3028 +++++++++++++-------------
 common/drive_simple.c   |  742 +++----
 common/exit.h           |    4 +-
 common/fs.c             |  188 +-
 common/fs.h             |   12 +-
 common/getdents.c       |    2 +-
 common/global.c         |  212 +-
 common/global.h         |   32 +-
 common/hsmapi.c         |   24 +-
 common/inventory.c      |  396 ++--
 common/inventory.h      |   82 +-
 common/lock.c           |   14 +-
 common/lock.h           |    6 +-
 common/main.c           | 1608 +++++++-------
 common/media.c          |  130 +-
 common/media.h          |   20 +-
 common/media_rmvtape.h  |    8 +-
 common/mlog.c           |  340 +--
 common/mlog.h           |   60 +-
 common/openutil.c       |   72 +-
 common/openutil.h       |   22 +-
 common/path.c           |  190 +-
 common/path.h           |    8 +-
 common/qlock.c          |  126 +-
 common/qlock.h          |   18 +-
 common/rec_hdr.h        |    6 +-
 common/ring.c           |  232 +-
 common/ring.h           |   22 +-
 common/stream.c         |  100 +-
 common/stream.h         |   26 +-
 common/timeutil.c       |    8 +-
 common/timeutil.h       |    6 +-
 common/ts_mtio.h        |   64 +-
 common/types.h          |   64 +-
 common/util.c           |  268 +--
 common/util.h           |   60 +-
 configure.ac            |    2 +
 dump/Makefile           |    4 +-
 dump/content.c          | 3726 ++++++++++++++++----------------
 dump/getopt.h           |    2 +-
 dump/inomap.c           |  776 +++----
 dump/inomap.h           |   32 +-
 dump/var.c              |   96 +-
 dump/var.h              |    4 +-
 include/builddefs.in    |    1 +
 include/swab.h          |   30 +-
 include/swap.h          |   30 +-
 inventory/getopt.h      |    2 +-
 inventory/inv_api.c     |  584 ++---
 inventory/inv_core.c    |  128 +-
 inventory/inv_files.c   |   10 +-
 inventory/inv_fstab.c   |  188 +-
 inventory/inv_idx.c     |  368 ++--
 inventory/inv_mgr.c     |  418 ++--
 inventory/inv_oref.c    |  148 +-
 inventory/inv_oref.h    |   16 +-
 inventory/inv_priv.h    |  286 +--
 inventory/inv_stobj.c   | 1008 ++++-----
 inventory/inventory.h   |   88 +-
 inventory/testmain.c    |  322 +--
 invutil/cmenu.h         |   38 +-
 invutil/fstab.c         |   20 +-
 invutil/invidx.c        |  126 +-
 invutil/invutil.c       |  302 +--
 invutil/invutil.h       |    6 +-
 invutil/menu.c          |    8 +-
 invutil/screen.c        |    2 +-
 invutil/stobj.c         |   38 +-
 librmt/rmtcommand.c     |    2 +-
 librmt/rmtfstat.c       |    8 +-
 librmt/rmtioctl.c       |   52 +-
 librmt/rmtlib.h         |    2 +-
 librmt/rmtopen.c        |    6 +-
 librmt/rmtstatus.c      |    8 +-
 librmt/rmtwrite.c       |    2 +-
 m4/Makefile             |    1 +
 m4/package_libcdev.m4   |   15 +
 restore/Makefile        |    8 +-
 restore/bag.c           |   72 +-
 restore/bag.h           |   20 +-
 restore/content.c       | 5524 +++++++++++++++++++++++------------------=
------
 restore/dirattr.c       |  763 ++++---
 restore/dirattr.h       |   48 +-
 restore/getopt.h        |    2 +-
 restore/inomap.c        |  290 +--
 restore/inomap.h        |   34 +-
 restore/mmap.c          |    2 +-
 restore/namreg.c        |  280 +--
 restore/namreg.h        |   12 +-
 restore/node.c          |  330 +--
 restore/node.h          |   12 +-
 restore/tree.c          | 2930 ++++++++++++-------------
 restore/tree.h          |   48 +-
 restore/win.c           |  138 +-
 restore/win.h           |   12 +-
 109 files changed, 15455 insertions(+), 15497 deletions(-)
 create mode 100644 m4/package_libcdev.m4


--DjEcnM5gtzq4iNt4tty1FU6lXrxrixNOZ--

--qEldC44RxUgWxTwjGZpIifwo6sJJ2696M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlzjHDUACgkQIK4WkuE9
3uBdIw//XYVti4SeVK2s0T8r/PYqkAHwuGB+6Ns8B9BsraRju1akwQBYRlB3fN3J
nZjD/HDlTezDSuAykPihB4vKk8nUiC29K+XC5V1HHA5VxjdqeoidIQleum729JjA
dvqNbs1L+VhK7NJOgJX+VtFgsnEsiBoZO4ZeW6iCwKGXRH0MqhEmm5+JBlkbuGc0
zNK367A6defciXSn5R826/c1CaQMLAq149puhCiX66b2f16FPxyYTBZftuoTVaQD
4G5QM4jEQhCodEnjCH4AI1bRuvsTjCnPcizqJHiQisCJgoUW/Yqd/EVBJRSHeVab
j/AP3YquObxHxSjjnpaGkEBXMZq64C2CxOf9SRNuSLNu3O0MtdJaE34VQL2szrLP
jqz5mzKnNOKTR0tbTgOuj/3s6QNCWpSlkxNHWBZExqi4dm6qGUbgWVjIZhV+4H8A
pKJnFGq8sxXh3bAb7fFvyzgcNOBb8USRiidPsVdF9WKhx0TOK6OQE/KBXdG6bm9d
OgBd5RlzDwzkUeOcE9uXgqmzMHfoz8aFyDIkvNlqDv4ym08WIvxcYXzbUH0ZuUDA
gwBBoBFBkhsyAjRj1OjreSNbRn0RPK2MwLHZ5H5o4krYTiY5qsaRvJPFg9oiKYl7
iAYMZK+o6PvphORmRrFF81QIdlXF8ZoWC+Y+AodBQYIC7A/O6IM=
=l7o3
-----END PGP SIGNATURE-----

--qEldC44RxUgWxTwjGZpIifwo6sJJ2696M--
