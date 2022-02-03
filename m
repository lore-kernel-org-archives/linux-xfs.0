Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6A19C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Feb 2022 20:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbiBCULX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Feb 2022 15:11:23 -0500
Received: from sandeen.net ([63.231.237.45]:59332 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353954AbiBCULT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Feb 2022 15:11:19 -0500
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id AAC1648FB
        for <linux-xfs@vger.kernel.org>; Thu,  3 Feb 2022 14:10:56 -0600 (CST)
Message-ID: <77c2d242-e220-1952-5d89-bf4f4a725142@sandeen.net>
Date:   Thu, 3 Feb 2022 14:11:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs 5.15.0-rc0 released
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------SeaMzu6INNqta0KNH0TaPcHc"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------SeaMzu6INNqta0KNH0TaPcHc
Content-Type: multipart/mixed; boundary="------------AVxThNPOz2dFe1VFWXkUTfEk";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <77c2d242-e220-1952-5d89-bf4f4a725142@sandeen.net>
Subject: [ANNOUNCE] xfsprogs 5.15.0-rc0 released

--------------AVxThNPOz2dFe1VFWXkUTfEk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This is primarily just the libxfs-sync from 5.15. A /GIANT/ thank you to
djwong for much of the real work behind this.

Next up I'll pull in bugfixes. I have a list from Darrick, but please fee=
l
free to remind me of anything else outstanding that should be considered.=


I'll move on to a 5.16 release fairly quickly after that, I hope.

The new head of the master branch is commit:

9a31fd83 (HEAD -> for-next, tag: v5.15.0-rc0, origin/libxfs-5.15-sync, or=
igin/for-next) xfsprogs: Release v5.15.0-rc0

New Commits:

Allison Henderson (2):
      [a42f01a1] xfs: add attr state machine tracepoints
      [4acc0d5d] xfs: Rename __xfs_attr_rmtval_remove

Christoph Hellwig (2):
      [b38197ad] xfs: remove support for disabling quota accounting on a =
mounted file system
      [128b8b99] xfs: remove the active vs running quota differentiation

Darrick J. Wong (23):
      [575f24e5] xfs_{copy,db,logprint,repair}: pass xfs_mount pointers i=
nstead of xfs_sb pointers
      [aaf3c5c9] xfs: allow setting and clearing of log incompat feature =
flags
      [9eb4f400] xfs: make xfs_rtalloc_query_range input parameters const=

      [901acb0e] xfs: make the key parameters to all btree key comparison=
 functions const
      [d34c6373] xfs: make the key parameters to all btree query range fu=
nctions const
      [e62318a3] xfs: make the record pointer passed to query_range funct=
ions const
      [c65978b6] xfs: mark the record passed into btree init_key function=
s as const
      [141bbc5c] xfs: make the keys and records passed to btree inorder f=
unctions const
      [cd5f520d] xfs: mark the record passed into xchk_btree functions as=
 const
      [67e6075e] xfs: make the pointer passed to btree set_root functions=
 const
      [43cbf380] xfs: make the start pointer passed to btree alloc_block =
functions const
      [99c5a767] xfs: make the start pointer passed to btree update_lastr=
ec functions const
      [36f59768] xfs: constify btree function parameters that are not mod=
ified
      [b4751eea] xfs: resolve fork names in trace output
      [04fdbc32] libxlog: replace xfs_sb_version checks with feature flag=
 checks
      [eefdf2ab] libxfs: replace xfs_sb_version checks with feature flag =
checks
      [2660e653] xfs_{copy,db,logprint,repair}: replace xfs_sb_version ch=
ecks with feature flag checks
      [2420d095] libxfs: use opstate flags and functions for libxfs mount=
 options
      [ed8f5980] Get rid of these flags and the m_flags field, since none=
 of them do anything anymore.
      [e42c53f3] libxfs: clean up remaining LIBXFS_MOUNT flags
      [f043c63e] libxfs: always initialize internal buffer map
      [a25314af] libxfs: replace XFS_BUF_SET_ADDR with a function
      [246e2283] libxfs: rename buffer cache index variable b_bn

Dave Chinner (17):
      [5cb09fa6] xfs: replace kmem_alloc_large() with kvmalloc()
      [b3749469] xfs: sb verifier doesn't handle uncached sb buffer
      [57e2264b] xfs: rename xfs_has_attr()
      [caf32c70] xfs: rework attr2 feature and mount options
      [3bc1fdd4] xfs: reflect sb features in xfs_mount
      [b16a427a] xfs: replace xfs_sb_version checks with feature flag che=
cks
      [914e2a04] xfs: convert mount flags to features
      [0ee9753e] xfs: convert remaining mount flags to state flags
      [93adb06a] xfs: replace XFS_FORCED_SHUTDOWN with xfs_is_shutdown
      [fa25ff74] xfs: convert xfs_fs_geometry to use mount feature checks=

      [e5f19702] xfs: open code sb verifier feature checks
      [94541a16] xfs: convert xfs_sb_version_has checks to use mount feat=
ures
      [586d90c3] xfs: remove unused xfs_sb_version_has wrappers
      [667010d6] xfs: introduce xfs_sb_is_v5 helper
      [03d8044d] xfs: kill xfs_sb_version_has_v3inode()
      [d4aaa66b] xfs: introduce xfs_buf_daddr()
      [f1208396] xfs: convert bp->b_bn references to xfs_buf_daddr()

Eric Sandeen (1):
      [9a31fd83] xfsprogs: Release v5.15.0-rc0

Theodore Ts'o (1):
      [b3aba575] xfsprogs: fix static build problems caused by liburcu


Code Diffstat:

 VERSION                     |   4 +-
 configure.ac                |   2 +-
 copy/Makefile               |   4 +-
 copy/xfs_copy.c             |  34 +++---
 db/Makefile                 |   4 +-
 db/attrset.c                |  12 +-
 db/btblock.c                |   2 +-
 db/btdump.c                 |   4 +-
 db/check.c                  |  20 ++--
 db/crc.c                    |   2 +-
 db/frag.c                   |   2 +-
 db/fsmap.c                  |  10 +-
 db/fuzz.c                   |   4 +-
 db/info.c                   |   2 +-
 db/init.c                   |   6 +-
 db/inode.c                  |   6 +-
 db/io.c                     |   4 +-
 db/logformat.c              |   4 +-
 db/metadump.c               |  24 ++--
 db/namei.c                  |   2 +-
 db/sb.c                     |  82 +++++++-------
 db/timelimit.c              |   2 +-
 db/write.c                  |   4 +-
 doc/CHANGES                 |   3 +
 growfs/Makefile             |   4 +-
 include/kmem.h              |   3 +-
 include/libxfs.h            |  56 ++++++++++
 include/xfs_arch.h          |  10 +-
 include/xfs_mount.h         | 146 ++++++++++++++++++++++--
 include/xfs_trace.h         |   6 +
 libxfs/init.c               |  63 +++++------
 libxfs/kmem.c               |   6 +-
 libxfs/libxfs_api_defs.h    |   1 +
 libxfs/libxfs_io.h          |  14 ++-
 libxfs/libxfs_priv.h        |  23 +---
 libxfs/logitem.c            |   4 +-
 libxfs/rdwr.c               |  29 +++--
 libxfs/util.c               |  14 +--
 libxfs/xfs_ag.c             |  25 ++---
 libxfs/xfs_alloc.c          |  56 +++++-----
 libxfs/xfs_alloc.h          |  12 +-
 libxfs/xfs_alloc_btree.c    | 100 ++++++++---------
 libxfs/xfs_alloc_btree.h    |   2 +-
 libxfs/xfs_attr.c           |  56 +++++++---
 libxfs/xfs_attr.h           |   1 -
 libxfs/xfs_attr_leaf.c      |  55 ++++-----
 libxfs/xfs_attr_remote.c    |  21 ++--
 libxfs/xfs_attr_remote.h    |   2 +-
 libxfs/xfs_bmap.c           |  38 +++----
 libxfs/xfs_bmap_btree.c     |  56 +++++-----
 libxfs/xfs_bmap_btree.h     |   9 +-
 libxfs/xfs_btree.c          | 141 ++++++++++++------------
 libxfs/xfs_btree.h          |  56 +++++-----
 libxfs/xfs_btree_staging.c  |  14 +--
 libxfs/xfs_da_btree.c       |  18 +--
 libxfs/xfs_da_format.h      |   2 +-
 libxfs/xfs_dir2.c           |   6 +-
 libxfs/xfs_dir2_block.c     |  14 +--
 libxfs/xfs_dir2_data.c      |  20 ++--
 libxfs/xfs_dir2_leaf.c      |  14 +--
 libxfs/xfs_dir2_node.c      |  20 ++--
 libxfs/xfs_dir2_priv.h      |   2 +-
 libxfs/xfs_dir2_sf.c        |  12 +-
 libxfs/xfs_dquot_buf.c      |   8 +-
 libxfs/xfs_format.h         | 224 ++++---------------------------------
 libxfs/xfs_ialloc.c         |  67 ++++++-----
 libxfs/xfs_ialloc.h         |   3 +-
 libxfs/xfs_ialloc_btree.c   |  88 +++++++--------
 libxfs/xfs_ialloc_btree.h   |   2 +-
 libxfs/xfs_inode_buf.c      |  22 ++--
 libxfs/xfs_inode_buf.h      |  11 +-
 libxfs/xfs_log_format.h     |   6 +-
 libxfs/xfs_log_rlimit.c     |   2 +-
 libxfs/xfs_quota_defs.h     |  30 +----
 libxfs/xfs_refcount.c       |  12 +-
 libxfs/xfs_refcount.h       |   2 +-
 libxfs/xfs_refcount_btree.c |  54 ++++-----
 libxfs/xfs_rmap.c           |  34 +++---
 libxfs/xfs_rmap.h           |  11 +-
 libxfs/xfs_rmap_btree.c     |  72 ++++++------
 libxfs/xfs_rtbitmap.c       |  14 +--
 libxfs/xfs_sb.c             | 263 +++++++++++++++++++++++++++++++-------=
------
 libxfs/xfs_sb.h             |   4 +-
 libxfs/xfs_symlink_remote.c |  14 +--
 libxfs/xfs_trans_inode.c    |   2 +-
 libxfs/xfs_trans_resv.c     |  48 ++------
 libxfs/xfs_trans_resv.h     |   2 -
 libxfs/xfs_trans_space.h    |   6 +-
 libxfs/xfs_types.c          |   2 +-
 libxfs/xfs_types.h          |   5 +
 libxlog/util.c              |   6 +-
 libxlog/xfs_log_recover.c   |  24 ++--
 logprint/Makefile           |   4 +-
 logprint/logprint.c         |   3 +-
 mdrestore/Makefile          |   3 +-
 mkfs/Makefile               |   4 +-
 mkfs/xfs_mkfs.c             |   8 +-
 repair/Makefile             |   2 +-
 repair/agbtree.c            |  10 +-
 repair/agheader.c           |   6 +-
 repair/attr_repair.c        |  10 +-
 repair/dino_chunks.c        |   6 +-
 repair/dinode.c             |  26 ++---
 repair/incore.h             |   4 +-
 repair/incore_ino.c         |   2 +-
 repair/phase2.c             |  25 +++--
 repair/phase4.c             |   2 +-
 repair/phase5.c             |  30 ++---
 repair/phase6.c             |  22 ++--
 repair/prefetch.c           |  22 ++--
 repair/quotacheck.c         |   4 +-
 repair/rmap.c               |  16 +--
 repair/scan.c               |  32 +++---
 repair/versions.c           |  87 +++++++--------
 repair/versions.h           |   4 +-
 repair/xfs_repair.c         |  14 +--
 scrub/Makefile              |   4 +-
 117 files changed, 1447 insertions(+), 1315 deletions(-)

--------------AVxThNPOz2dFe1VFWXkUTfEk--

--------------SeaMzu6INNqta0KNH0TaPcHc
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmH8NuUFAwAAAAAACgkQIK4WkuE93uDn
3hAAjXGWZSIFERD1zsWzv2NtzgFMjmiR3EFjwIOgjMLob9/s+uAnXdjTptFnHYCmkspNxp/iKxEm
VgWseSCfyQsbnXYcnEgKKi9yXGSin/NaKi6csbhNwq22krbwgvOnW9fg2S/a0IRmxN/scJP9h6Uc
YyRZJEdyCiVCCZTv9OBQHbrtKDk6qGPNKlBwtcy5PR6uvLC7UhkrDimKdl68r0uwPxdiXEMRLxB8
Uiogfkk/oq1z4A1PQPkjUiOCJYmMzrxbm5p7Y//GA8l8jJSR6b22CAizxhYy9gjgAVPDNgltIT1r
uPN1A4KvAJvO764HY4djsjPgKi1MriVsGw33UvSTfy+BZCQ2dzS8uUVnZieRAEruO5LqcW3Z4s2o
Bp2ayaIRzZEv/BRj1JYVNbJQ3sNdsOQhTeXgSV+Y+sBtbLo1Ayi8mA5ZA+In6JO63NrHfV/VpSsi
jhl+D1rx/LeDoDX0foqzKODbWicsaYNBBaRa4UxvLcI6UHJJXu6ptbPmFJLXmHKRXGLttlNeC4xD
3xpktRW8IpE8R/oMtCMZa4HG6iy5fsCvwxpS606/QADDBDDQOcJO40Z9P8qoFCWy1STQq9zmQ7OI
hToZsvmhvgYULpz9uzPVynIca5bdKtSD3fHkb0ptV3OBCZI/IWrTjuzubZHOfq+3lRHQ2P3lpTqb
PAk=
=E0W1
-----END PGP SIGNATURE-----

--------------SeaMzu6INNqta0KNH0TaPcHc--
