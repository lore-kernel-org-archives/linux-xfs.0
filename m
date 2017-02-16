Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34682 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751635AbdBPEPS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Feb 2017 23:15:18 -0500
Received: from Liberator.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A56BB2A6A
        for <linux-xfs@vger.kernel.org>; Wed, 15 Feb 2017 22:15:17 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: v4.10.0-rc1 released
Message-ID: <a9d5dc78-f707-5d8e-d08d-62e85237b195@sandeen.net>
Date: Wed, 15 Feb 2017 22:15:09 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TGnCiWiOXgoqMKxgPfEDPrGFJ30vdph0V"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TGnCiWiOXgoqMKxgPfEDPrGFJ30vdph0V
Content-Type: multipart/mixed; boundary="wfCw80ELNqhrtiLw41mIRa4i2s4XpDQV6";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <a9d5dc78-f707-5d8e-d08d-62e85237b195@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: v4.10.0-rc1 released

--wfCw80ELNqhrtiLw41mIRa4i2s4XpDQV6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The master branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v4.10.0-rc1.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

5956291 xfs_metadump: ignore attr leaf with 0 entries

New Commits:

Arnd Bergmann (1):
      [5b1caea] xfs: fix xfs_mode_to_ftype() prototype

Brian Foster (1):
      [4be4441] xfs: remove racy hasattr check from attr ops

Christoph Hellwig (4):
      [7075a23] xfs: fix COW writeback race
      [2ffa676] xfs: only update mount/resv fields on success in __xfs_ag=
_resv_init
      [74e502a] xfs: use per-AG reservations for the finobt
      [3f5dd6c] xfs: extsize hints are not unlikely in xfs_bmap_btalloc

Darrick J. Wong (2):
      [2e6fca2] xfs: verify dirblocklog correctly
      [ce24180] libxfs: sync up FSGETXATTR names and definitions with the=
 kernel

Eric Biggers (1):
      [c4cd257] xfsprogs: Fix building xfsprogs on 32-bit platforms (agai=
n)

Eric Sandeen (2):
      [3eafb26] xfs_repair: Fix uninit var in process_leaf_attr_level
      [5956291] xfs_metadump: ignore attr leaf with 0 entries


Code Diffstat:

 db/metadump.c             |  3 ++-
 include/builddefs.in      |  2 +-
 include/xfs_mount.h       |  1 +
 io/cowextsize.c           |  6 +++---
 libxfs/xfs_ag_resv.c      | 70 +++++++++++++++++++++++++++++++++++++++++=
++++++++++++++---------------
 libxfs/xfs_attr.c         |  6 ------
 libxfs/xfs_bmap.c         | 48 ++++++++++++++++++++++++++++++++++-------=
-------
 libxfs/xfs_bmap.h         |  6 +++++-
 libxfs/xfs_dir2.c         |  2 +-
 libxfs/xfs_dir2.h         |  2 +-
 libxfs/xfs_fs.h           |  5 ++---
 libxfs/xfs_ialloc_btree.c | 90 +++++++++++++++++++++++++++++++++++++++++=
++++++++++++++++++++++++++++++++++++++++++++++---
 libxfs/xfs_ialloc_btree.h |  3 +++
 libxfs/xfs_sb.c           |  2 +-
 repair/attr_repair.c      |  2 +-
 15 files changed, 197 insertions(+), 51 deletions(-)


--wfCw80ELNqhrtiLw41mIRa4i2s4XpDQV6--

--TGnCiWiOXgoqMKxgPfEDPrGFJ30vdph0V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJYpSdVAAoJECCuFpLhPd7gWaoP/2PYViQV8xWCzTWAoR6bzw3j
wBsbgkxOKsZ26W9u2GQr2jH+ejc4HfCylfPaXYmADCS4EfViLf/hy20ZnREdczAj
Nva66y4heJcLEDRW06Fsy41xcG3HADr/NuzE+ruk1wo3CZhWZ6VrZtmWy73rYkHX
aYDjLAuLKeih1efLW/sw/0e+dGmMT1jW+Gp4P00LsM5FZy+1eQhgChqolNkPlt+/
Ikh3VSYsjywv3TBc71Bu85B8Y98F98AQ2n3AQVOguVXgINs1W0TNhU+webaiANaZ
6UeBWNfN+nuzCG56MO2YSTM2O4bYfkMpPBTZ1wZbJxXyqr+8TJr6VyqqLGrDhjEq
EFDjzTRUACJ3Bwqe97g/LFgeVT/kc1Ui7ADx5wjo5wKYquQXH9CaS3cZM6ubaZjw
D6dIRSfc2h4fcZy8u3tTXtn+pOyzpqOPYr2Wj3/ecUyVFuxf3DCg6JiXRgQ75RLY
HhQ5VuFUSxNAC/4I+ZjB2vEAOiL1g0GNjWz1vD7ZMgnkIxpIx+tJPl11hEVSz64E
/PLQ6qKuwGpTMpIadckiS+yHOCL/DdfuBN0O1iHEdaNCHvxCwZ+9e6jiXTB2u+jd
RjwPp4v1TRhsUEtuQagICUDsjowERThBMvjoMPHzfWp/8tD8Q/2P5eclyEeqDQ2m
Ii9MJkcF67TtCS/BNMyy
=Volo
-----END PGP SIGNATURE-----

--TGnCiWiOXgoqMKxgPfEDPrGFJ30vdph0V--
