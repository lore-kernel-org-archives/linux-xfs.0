Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56936 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932209AbeFGUAU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Jun 2018 16:00:20 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8D04A15D95
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jun 2018 15:00:04 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs libxfs-4.18-sync branch created
Message-ID: <c82a6298-02d7-f0d3-d055-21baccbbfaa7@sandeen.net>
Date: Thu, 7 Jun 2018 15:00:18 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="waBJMZJYmqX9oqGuC9la4miQFkmeYDwkG"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--waBJMZJYmqX9oqGuC9la4miQFkmeYDwkG
Content-Type: multipart/mixed; boundary="9WmRqoHjlEtFzZ6G9Y4qDhJogsGOwUSGo";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <c82a6298-02d7-f0d3-d055-21baccbbfaa7@sandeen.net>
Subject: [ANNOUNCE] xfsprogs libxfs-4.18-sync branch created

--9WmRqoHjlEtFzZ6G9Y4qDhJogsGOwUSGo
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The libxfs-4.18-sync branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been created to incorporate the libxfs changes pending
for 4.18 kernelspace.

This is a work in progress and may get rebased, but it's a line
in the sand.  Darrick had done this work independently and we
mostly matched; this is my mash-up of our two efforts.
Thanks Darrick!

This won't get merged into for-next until xfsprogs-4.17 is released
but it's here to use if it's helpful.

The new head of the libxfs-4.18-sync branch is commit:

e05de95 xfs: fix error handling in xfs_refcount_insert()

New Commits:

Brian Foster (6):
      [760fb49] xfs: create agfl block free helper function
      [d0a88b6] xfs: defer agfl block frees when dfops is available
      [e3b8508] xfs: defer agfl block frees from deferred ops processing =
context
      [59d24f6] xfs: add bmapi nodiscard flag
      [e81d622] xfs: don't discard on free of unwritten extents
      [2da8015] xfs: factor out nodiscard helpers

Darrick J. Wong (21):
      [78d4d85] xfs: bmap debugging should never panic the system
      [af9fe5f] xfs: add missing rmap error return
      [f26f83f] xfs: refactor XFS_QMOPT_DQNEXT out of existence
      [68af868] xfs: remove unnecessary xfs_qm_dqattach parameter
      [a26938c] xfs: replace XFS_QMOPT_DQALLOC with a simple boolean
      [51d6422] xfs: add helpers to calculate btree size
      [9364c4f] xfs: expose various functions to repair code
      [a361d58] xfs: add repair helpers for the reverse mapping btree
      [72ce571] xfs: add repair helpers for the reference count btree
      [4cbc52b] xfs: add BMAPI_NORMAP flag to perform block remapping wit=
hout up
      [df275b0] xfs: superblock scrub should use short-lived buffers
      [99b2438] xfs: hoist xfs_scrub_agfl_walk to libxfs as xfs_agfl_walk=

      [7c446fd] xfs: make xfs_bmapi_remapi work with attribute forks
      [ba8f66b] xfs: teach xfs_bmapi_remap to accept some bmapi flags
      [9083507] xfs: implement the metadata repair ioctl flag
      [5bf39bb] xfs: fix inobt magic number check
      [1e7f5da] xfs: repair superblocks
      [dc7197e] xfs: xfs_rtword_t should be unsigned, not signed
      [0f529a2] xfs: xfs_rtbuf_get should check the bmapi_read results
      [a73b751] xfs: strengthen rtalloc query range checks
      [32898e2] xfs: fix xfs_rtalloc_rec units

Dave Chinner (6):
      [ab4bc2b] xfs: make xfs_buf_incore out of line
      [89147f5] xfs: adder caller IP to xfs_defer* tracepoints
      [d15e391] xfs: get rid of the log item descriptor
      [46dac31] xfs: move growfs core to libxfs
      [3f74d0a] xfs: factor the ag length extension code into libxfs
      [e05de95] xfs: fix error handling in xfs_refcount_insert()

Eric Sandeen (6):
      [fd5fc54] xfs: remove unused flags arg from xfs_dquot_verify
      [03e089e] xfs: check type in quota verifier during quotacheck
      [d579e1c] xfs: pass full xfs_dqblk to repair during quotacheck
      [bf9def5] xfs: add full xfs_dqblk verifier
      [d8f6e90] xfs: print specific dqblk that failed verifiers
      [ce0b965] xfs: implement online get/set fs label


Code Diffstat:

 include/xfs_trace.h       |  14 +-
 include/xfs_trans.h       |   9 +-
 io/inject.c               |   1 +
 libxfs/Makefile           |   1 +
 libxfs/init.c             |   4 -
 libxfs/libxfs_api_defs.h  |   2 +-
 libxfs/libxfs_priv.h      |  43 ++++-
 libxfs/logitem.c          |  18 +-
 libxfs/trans.c            |  58 ++----
 libxfs/xfs_ag.c           | 465 ++++++++++++++++++++++++++++++++++++++++=
++++++
 libxfs/xfs_ag.h           |  30 +++
 libxfs/xfs_alloc.c        | 129 +++++++++++--
 libxfs/xfs_alloc.h        |  23 ++-
 libxfs/xfs_alloc_btree.c  |   9 +
 libxfs/xfs_alloc_btree.h  |   2 +
 libxfs/xfs_attr.c         |   4 +-
 libxfs/xfs_attr_remote.c  |   2 +-
 libxfs/xfs_bmap.c         |  92 +++++----
 libxfs/xfs_bmap.h         |  30 ++-
 libxfs/xfs_bmap_btree.c   |   9 +
 libxfs/xfs_bmap_btree.h   |   3 +
 libxfs/xfs_btree.c        |  25 ++-
 libxfs/xfs_btree.h        |   3 +-
 libxfs/xfs_defer.c        |  24 ++-
 libxfs/xfs_defer.h        |   1 +
 libxfs/xfs_dquot_buf.c    |  94 ++++++----
 libxfs/xfs_errortag.h     |   4 +-
 libxfs/xfs_format.h       |   7 +-
 libxfs/xfs_fs.h           |   9 +-
 libxfs/xfs_ialloc.c       |   2 +-
 libxfs/xfs_ialloc.h       |   3 +
 libxfs/xfs_ialloc_btree.c |  11 +-
 libxfs/xfs_ialloc_btree.h |   2 +
 libxfs/xfs_quota_defs.h   |   9 +-
 libxfs/xfs_refcount.c     |  24 ++-
 libxfs/xfs_refcount.h     |   7 +
 libxfs/xfs_rmap.c         |  83 +++++++++
 libxfs/xfs_rmap.h         |   4 +
 libxfs/xfs_rtbitmap.c     |  26 ++-
 libxfs/xfs_sb.c           | 149 +++++++++++++++
 libxfs/xfs_sb.h           |  16 ++
 libxfs/xfs_shared.h       |  16 +-
 libxfs/xfs_types.h        |   2 +-
 repair/dinode.c           |   4 +-
 44 files changed, 1262 insertions(+), 211 deletions(-)
 create mode 100644 libxfs/xfs_ag.c
 create mode 100644 libxfs/xfs_ag.h


--9WmRqoHjlEtFzZ6G9Y4qDhJogsGOwUSGo--

--waBJMZJYmqX9oqGuC9la4miQFkmeYDwkG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlsZjtIACgkQIK4WkuE9
3uC40w/8C/pn26BhlICimIOhuWs9m4T4+AHD2rUF3rIrmkw0bQTVHwH4629an3As
x+VVt9eSDyg/YGvUnVSARtnBdioj+hDM6bx5DNPTnG/CM1SW/OcnUb+uYEOrqCCN
WRJkSLA32Pf2AfWexE6nRj5/B26KbTNqsVKRZGghayyr+5ppUFkl5AxDrvua+ohw
GNwWd/7HuuRzV70SmyVX26utygPxbho5eEbgOvG9ZZ8qh7z2rfM9hehgeUgAxoOP
UpFShDChTxUXeNQNhb4CMu9w2FPH6JHQXaE3z2TRPM5domtlfyIICAsuSJthpYzE
JI8uS//ydoLnv2G36Z9K5C2UPao5qpVSwFndIdfJFzfqsLgH8e4ymvUA44QRBdo0
meD7yaA6qSVf3EzA3ep3N0d+7eY2bJFhWEkBWBPWW/PxAtV2qkatbdShhkHyAupf
NhSuekNimB6P4bmpMI5HPttxMU2A/g/LbRMUqWnL+xHcm7sI4iIYX/ltYXXCdXgR
WKgtxDvfdwlLVx8wp+MK6X6TVyL0LNYaQVX4jHsoB4xut3peQ2IQaKF0K05nLScQ
GcrwBWrsGfhIr67W8VWhpaOcMkuXEe/VrBL6YER3Zgu5SIJhEc49mSGSyP2DxXyD
uLNTjYrW1RB2HcTdDJeApBz0m2HHCAOkidM+PZqV9O7lachlU8I=
=EgQD
-----END PGP SIGNATURE-----

--waBJMZJYmqX9oqGuC9la4miQFkmeYDwkG--
