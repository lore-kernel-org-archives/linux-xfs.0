Return-Path: <SRS0=CZ9Z=WM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73280C3A59C
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 17:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D36F205F4
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 17:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbfHPRhf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Aug 2019 13:37:35 -0400
Received: from sandeen.net ([63.231.237.45]:39228 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727286AbfHPRhf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Aug 2019 13:37:35 -0400
Received: from Liberator-6.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id DD38B2A9C
        for <linux-xfs@vger.kernel.org>; Fri, 16 Aug 2019 12:37:33 -0500 (CDT)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 7c3f161
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <5bd58b40-4487-b3cc-ccbd-74122a3715f0@sandeen.net>
Date:   Fri, 16 Aug 2019 12:37:32 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Srdwm4YZqMzDaE2maVDzEvcdIeFJOsxfY"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Srdwm4YZqMzDaE2maVDzEvcdIeFJOsxfY
Content-Type: multipart/mixed; boundary="HNWNY5BInNZGVkoLqAR5rd1TFxdCS8jw4";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <5bd58b40-4487-b3cc-ccbd-74122a3715f0@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 7c3f161

--HNWNY5BInNZGVkoLqAR5rd1TFxdCS8jw4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v5.3.0-rc0

I'm aware that there are unmerged patches on the list, so no need
to resend anything at this time.

The new head of the for-next branch is commit:

7c3f161 xfsprogs: Release v5.3.0-rc0

New Commits:

Brian Foster (4):
      [6802ae4] xfs: clean up small allocation helper
      [2328093] xfs: move small allocation helper
      [05479bb] xfs: skip small alloc cntbt logic on NULL cursor
      [9f09e97] xfs: always update params on small allocation

Christoph Hellwig (2):
      [f312f63] xfs: add struct xfs_mount pointer to struct xfs_buf
      [6aeb1c0] xfs: remove XFS_TRANS_NOFS

Darrick J. Wong (19):
      [251ee0f] xfs: separate inode geometry
      [5ee6a39] xfs: refactor inode geometry setup routines
      [5fc96f4] xfs: fix inode_cluster_size rounding mayhem
      [adee858] xfs: finish converting to inodes_per_cluster
      [64fb6e0] xfs: move xfs_ino_geometry to xfs_shared.h
      [5575259] xfs: refactor free space btree record initialization
      [d85f37f] xfs: account for log space when formatting new AGs
      [a52f3fd] xfs: create iterator error codes
      [c9d1c30] xfs: create simplified inode walk function
      [32dd7d9] xfs: remove various bulk request typedef usage
      [2224df6] xfs: introduce new v5 bulkstat structure
      [2cd4504] xfs: introduce v5 inode group structure
      [860c3ae] xfs: wire up new v5 bulkstat ioctls
      [c6c1a0d] xfs: wire up the v5 inumbers ioctl
      [55bcd62] xfs: specify AG in bulk req
      [6d73993] xfs: allow single bulkstat of special inodes
      [07380ef] xfs: attribute scrub should use seen_enough to pass error=
 values
      [a8742dd] xfs: remove more ondisk directory corruption asserts
      [85afaac] xfs: don't crash on null attr fork xfs_bmapi_read

Eric Sandeen (4):
      [3d35020] xfs: remove unused flags arg from getsb interfaces
      [9238783] xfs: remove unused flag arguments
      [4798848] xfs: remove unused header files
      [7c3f161] xfsprogs: Release v5.3.0-rc0


Code Diffstat:

 VERSION                     |   4 +-
 configure.ac                |   2 +-
 db/check.c                  |  50 ++++-----
 db/frag.c                   |   9 +-
 db/inode.c                  |   9 +-
 db/metadump.c               |  25 +++--
 debian/changelog            |   6 ++
 doc/CHANGES                 |   3 +
 fsr/xfs_fsr.c               |  36 +++----
 include/jdm.h               |   8 +-
 include/xfs_mount.h         |  22 +---
 include/xfs_trans.h         |   2 +-
 io/imap.c                   |   4 +-
 io/parent.c                 |  18 ++--
 libhandle/jdm.c             |  16 +--
 libxfs/init.c               |  57 ++---------
 libxfs/libxfs_io.h          |   3 +-
 libxfs/libxfs_priv.h        |   2 +-
 libxfs/rdwr.c               |   9 +-
 libxfs/trans.c              |  10 +-
 libxfs/xfs_ag.c             | 101 +++++++++++++++---
 libxfs/xfs_ag_resv.c        |  11 --
 libxfs/xfs_alloc.c          | 228 ++++++++++++++++++++------------------=
---
 libxfs/xfs_alloc_btree.c    |   5 +-
 libxfs/xfs_attr.c           |   2 -
 libxfs/xfs_attr.h           |   8 +-
 libxfs/xfs_attr_leaf.c      |  15 ++-
 libxfs/xfs_attr_remote.c    |  11 +-
 libxfs/xfs_bit.c            |   1 -
 libxfs/xfs_bmap.c           |  46 +++++----
 libxfs/xfs_bmap_btree.c     |   4 +-
 libxfs/xfs_btree.c          |  50 ++++-----
 libxfs/xfs_btree.h          |  14 +--
 libxfs/xfs_da_btree.c       |  29 +++---
 libxfs/xfs_da_format.c      |   3 -
 libxfs/xfs_defer.c          |   6 --
 libxfs/xfs_dir2.c           |   6 +-
 libxfs/xfs_dir2_block.c     |  10 +-
 libxfs/xfs_dir2_data.c      |  14 +--
 libxfs/xfs_dir2_leaf.c      |  10 +-
 libxfs/xfs_dir2_node.c      |  13 ++-
 libxfs/xfs_dir2_sf.c        |   3 +-
 libxfs/xfs_dquot_buf.c      |  13 +--
 libxfs/xfs_format.h         |   2 +-
 libxfs/xfs_fs.h             | 124 ++++++++++++++++++++--
 libxfs/xfs_health.h         |   2 +-
 libxfs/xfs_ialloc.c         | 245 +++++++++++++++++++++++++++++---------=
------
 libxfs/xfs_ialloc.h         |  18 +---
 libxfs/xfs_ialloc_btree.c   |  56 +++++++---
 libxfs/xfs_ialloc_btree.h   |   3 +
 libxfs/xfs_iext_tree.c      |   4 -
 libxfs/xfs_inode_buf.c      |  10 +-
 libxfs/xfs_inode_fork.c     |   3 +-
 libxfs/xfs_log_rlimit.c     |   2 -
 libxfs/xfs_refcount.c       |   3 -
 libxfs/xfs_refcount_btree.c |   5 +-
 libxfs/xfs_rmap.c           |   7 --
 libxfs/xfs_rmap_btree.c     |   6 +-
 libxfs/xfs_rtbitmap.c       |   4 -
 libxfs/xfs_sb.c             |  39 ++-----
 libxfs/xfs_shared.h         |  49 ++++++++-
 libxfs/xfs_symlink_remote.c |   9 +-
 libxfs/xfs_trans_inode.c    |   3 -
 libxfs/xfs_trans_resv.c     |  18 ++--
 libxfs/xfs_trans_space.h    |   7 +-
 libxfs/xfs_types.c          |  13 +--
 mkfs/proto.c                |   2 +-
 mkfs/xfs_mkfs.c             |  16 +--
 quota/quot.c                |   8 +-
 repair/dino_chunks.c        |  46 +++++----
 repair/dinode.c             |   5 +-
 repair/phase2.c             |   2 +-
 repair/phase5.c             |  28 ++---
 repair/prefetch.c           |  14 +--
 repair/scan.c               |  19 ++--
 repair/xfs_repair.c         |  14 +--
 76 files changed, 920 insertions(+), 764 deletions(-)


--HNWNY5BInNZGVkoLqAR5rd1TFxdCS8jw4--

--Srdwm4YZqMzDaE2maVDzEvcdIeFJOsxfY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl1W6d0ACgkQIK4WkuE9
3uBYnQ//UVxOTvaQs69gd5lbdIRyjXOWt8G+E/BtQxbrnB0C//FaOUs+MEE5duwy
0fZ1dXwmcG2QAq+p3SXfRjytIXVOT50L3eU5okhlAbHRjuRGnqeBRes6QekHM+kR
knTyJrWrTuWXZERL0Upsc3eht7Zm5h/MHzE2csh3+x4DzkzynRwCXY5NsVW5LqvC
vpoS6jxY5lLQCPIaKo3K4pVPMXp4INjpCdo5u1/OipvxqyrFgvjPZfeu7oeU21Cd
YEob19VGT7kJCGCRhhAxacbo+Rov9M3/4FeF8Ds2iDVun7eyndb8LMeiAeLCt1O8
kHlYQv3cCDn/Xg3GY1dNObSWU2Ks09oMKD2duwxQ3oC7YTm/yTbub9LvD0MsD1O3
UwyMdMn8tZqkwAaYINEq9p6vWd+Hw1xz4QXe3maPPNTUdYawa7M1Pn6WV3pLRNlZ
2Oxajm4KyFz8GSsQjKUYkgJpuZgs1EKr5Hri7ln7FNsjCdBbK8qkOwvGut4PzIVt
IXGIUd7WpTDAv87Ef626BeSAW7QPMqrTrstEIxQK1oG1xe3P+W33hS6Xt0uTY2o/
oVOwaxyZZeF99JQtjez4ZQwKEl9p5rgQrZiB/ZBusL1HB/z6kSdit7ZP62TVIQZM
b85m+wkx7aaQkEnzh80SssUC7HJclPM7IYmRgILI184PytbhHdk=
=3f1n
-----END PGP SIGNATURE-----

--Srdwm4YZqMzDaE2maVDzEvcdIeFJOsxfY--
