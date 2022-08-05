Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C2AC00140
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Aug 2022 22:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240182AbiHEW3K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Aug 2022 18:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237858AbiHEW3J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Aug 2022 18:29:09 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9499F1CFE4
        for <linux-xfs@vger.kernel.org>; Fri,  5 Aug 2022 15:29:03 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5F99D450A89
        for <linux-xfs@vger.kernel.org>; Fri,  5 Aug 2022 17:28:01 -0500 (CDT)
Message-ID: <0ad6dde6-9c88-2978-3ba4-0dda8de82808@sandeen.net>
Date:   Fri, 5 Aug 2022 17:29:01 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs 5.19.0-rc1 released
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------OVG490c0q7mgQB0AkbE0SUeL"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------OVG490c0q7mgQB0AkbE0SUeL
Content-Type: multipart/mixed; boundary="------------mNWMujgBIUvcc3piwBu5Sph5";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <0ad6dde6-9c88-2978-3ba4-0dda8de82808@sandeen.net>
Subject: [ANNOUNCE] xfsprogs 5.19.0-rc1 released

--------------mNWMujgBIUvcc3piwBu5Sph5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v5.19.0-rc1

If anything is missing for the final v5.19.0 release, speak now!

The new head of the master branch is commit:

cf06f3af (xfsprogs: Release v5.19.0-rc1

New Commits:

Chandan Babu R (2):
      [91c1d083] xfs_repair: Search for conflicts in inode_tree_ptrs[] wh=
en processing uncertain inodes
      [1b3daa7d] xfs_repair: Add support for upgrading to large extent co=
unters

Darrick J. Wong (26):
      [41cbb27c] xfs: fix TOCTOU race involving the new logged xattrs con=
trol knob
      [53cbe278] xfs: fix variable state usage
      [5e572d1a] xfs: empty xattr leaf header blocks are not corruption
      [c21a5691] xfs: don't hold xattr leaf buffers across transaction ro=
lls
      [95e3fc7f] misc: fix unsigned integer comparison complaints
      [053fcbc7] xfs_logprint: fix formatting specifiers
      [d6bfc06d] libxfs: remove xfs_globals.larp
      [fa0f9232] xfs_repair: always rewrite secondary supers when needsre=
pair is set
      [84c5f08f] xfs_repair: don't flag log_incompat inconsistencies as c=
orruptions
      [766bfbd7] xfs_db: identify the minlogsize transaction reservation
      [baf8a5df] xfs_copy: don't use cached buffer reads until after libx=
fs_mount
      [b83b2ec0] xfs_repair: clear DIFLAG2_NREXT64 when filesystem doesn'=
t support nrext64
      [0ec4cd64] xfs_repair: detect and fix padding fields that changed w=
ith nrext64
      [b6fd1034] mkfs: preserve DIFLAG2_NREXT64 when setting other inode =
attributes
      [42efbb99] mkfs: document the large extent count switch in the --he=
lp screen
      [ad8a3d7c] mkfs: always use new_diflags2 to initialize new inodes
      [f2e38861] xfs_repair: check free rt extent count
      [9d454cca] xfs_repair: check the rt bitmap against observations
      [daebb4ce] xfs_repair: check the rt summary against observations
      [f50d3462] xfs_repair: ignore empty xattr leaf blocks
      [50dba818] mkfs: terminate getsubopt arrays properly
      [28965957] libxfs: stop overriding MAP_SYNC in publicly exported he=
ader files
      [42371fb3] mkfs: ignore data blockdev stripe geometry for small fil=
esystems
      [6e0ed3d1] mkfs: stop allowing tiny filesystems
      [db5b8665] mkfs: complain about impossible log size constraints
      [7aeffc87] xfs_repair: check filesystem geometry before allowing up=
grades

Eric Sandeen (2):
      [e298041e] xfsprogs: Release v5.19.0-rc0.1
      [cf06f3af] xfsprogs: Release v5.19.0-rc1

Zhang Boyang (1):
      [c1c71781] mkfs: update manpage of bigtime and inobtcount

hexiaole (1):
      [03bc6539] xfs: correct nlink printf specifier from hd to PRIu32


Code Diffstat:

 VERSION                  |   2 +-
 configure.ac             |   2 +-
 copy/xfs_copy.c          |   2 +-
 db/check.c               |  10 ++-
 db/logformat.c           |   4 +-
 db/metadump.c            |  11 ++-
 doc/CHANGES              |  26 ++++++
 include/linux.h          |   8 --
 include/xfs_mount.h      |   8 +-
 io/io.h                  |   2 +-
 io/mmap.c                |  25 +++---
 libxfs/init.c            |  24 ++++--
 libxfs/libxfs_api_defs.h |   3 +
 libxfs/util.c            |  15 ++--
 libxfs/xfs_attr.c        |  47 ++++-------
 libxfs/xfs_attr.h        |  17 +---
 libxfs/xfs_attr_leaf.c   |  37 +++++----
 libxfs/xfs_attr_leaf.h   |   3 +-
 libxfs/xfs_da_btree.h    |   4 +-
 logprint/log_misc.c      |   2 +-
 logprint/log_print_all.c |   2 +-
 m4/package_libcdev.m4    |   3 +-
 man/man8/mkfs.xfs.8.in   |  23 +++--
 man/man8/xfs_admin.8     |   7 ++
 mkfs/xfs_mkfs.c          | 121 ++++++++++++++++++++++++++-
 repair/agheader.c        |  23 ++++-
 repair/attr_repair.c     |  20 +++++
 repair/dino_chunks.c     |   3 +-
 repair/dinode.c          |  47 ++++++++++-
 repair/globals.c         |   1 +
 repair/globals.h         |   1 +
 repair/phase2.c          | 137 ++++++++++++++++++++++++++++--
 repair/phase5.c          |  13 ++-
 repair/protos.h          |   1 +
 repair/rt.c              | 212 +++++++++++++++++------------------------=
------
 repair/rt.h              |  18 ++--
 repair/xfs_repair.c      |  18 +++-
 37 files changed, 587 insertions(+), 315 deletions(-)

--------------mNWMujgBIUvcc3piwBu5Sph5--

--------------OVG490c0q7mgQB0AkbE0SUeL
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmLtma0FAwAAAAAACgkQIK4WkuE93uCY
PhAAw+z3pZ2wDszVO4McmvRhrgkQYo3dzNMntW2f4QWkEoX8f3FVE/LQVVKNUB9Kl6LSI7JeJnm5
KHWVwJz2An2mJyjR3KmN7qs6B9Q0ueZP1/lSPBofYcqyW9BguHz/VHhbkzVEy3+7BRhBc5PMBxkH
CKkRFr3HnDDIQbOFxpCQzB5q6YCJVDNxDNTzEftITIHPawgbP38EEugs1TIYeHqhEjgjxGMcFa5d
OWFsAlYNC0NYlo+AkCrDS55xStukzfTi1L2SyOJ+rBj9g/cpSwS1qTlsxA/fJvPcWyFmqK27H7lr
w43jF00Y/Npp9h/DR7U3Nc2W4Ef/gPnR2dGViKLQu2hEGQHDFy1IS6Kucv0q3QzgSueng+ptJLoi
0IYfuGNMVs50aG+sdIeIDAGjYaSbLdSg9NTsOSw0+W88c/RV60dp9ZdoWDWhAy8gxITsbi39kXMO
xmA0nzR0Qh49VaqAvF1GHCp3L35Hv2cnXstNcwhPMuoyhAYZ6uAhd0DUJrLAXXdh5F5dD+ZXxwBe
xz5HN0yI/l9d/sBFEUS40Ntb6FafaRbZxTCwlB1Pb0DOWJSagqIBUlfePdJfMU4V3zv232fLedSI
j7MrBGcJPVyspmlsfKON25QLYN5Ci9SvJe3Gd6/1F7cQy/Gt8qiLWkEmyrWPTxsr/23wcbhtfxOB
AP8=
=Xt3J
-----END PGP SIGNATURE-----

--------------OVG490c0q7mgQB0AkbE0SUeL--
