Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60604 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfHITkH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Aug 2019 15:40:07 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8B9FD328A16
        for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2019 14:40:06 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.2.0 released
Message-ID: <e172f478-0923-b9cd-2032-70ffae337d15@sandeen.net>
Date: Fri, 9 Aug 2019 14:40:04 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="a4jNrQfPmXxLdvGXuoPbj6kMFY9CjRENj"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--a4jNrQfPmXxLdvGXuoPbj6kMFY9CjRENj
Content-Type: multipart/mixed; boundary="zwQSGMd8rxxqtShwbeXRTFViFTLnK9jtA";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <e172f478-0923-b9cd-2032-70ffae337d15@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.2.0 released

--zwQSGMd8rxxqtShwbeXRTFViFTLnK9jtA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

xfsprogs v5.2.0 has been released, and the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Tarballs are available at:

https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.2.0.tar=
=2Egz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.2.0.tar=
=2Exz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.2.0.tar=
=2Esign


This is the most boring release ever(tm).  It contains only libxfs syncup=
s,
and some cosmetic changes unique to xfsprogs-specific libxfs/ files.
Onward to 5.3!

Thanks,
-Eric

The new head of the master branch is commit:

2976bfe xfsprogs: Release v5.2.0

New Commits since v5.1.0:

Brian Foster (3):
      [580a438] xfs: don't account extra agfl blocks as available
      [b8b9c3c] xfs: make tr_growdata a permanent transaction
      [d85d342] xfs: assert that we don't enter agfl freeing with a non-p=
ermanent transaction

Darrick J. Wong (11):
      [f866934] xfs: track metadata health status
      [7b55f0f] xfs: replace the BAD_SUMMARY mount flag with the equivale=
nt health code
      [25b8487] xfs: clear BAD_SUMMARY if unmounting an unhealthy filesys=
tem
      [debdc16] xfs: add a new ioctl to describe allocation group geometr=
y
      [69423ea] xfs: report fs and rt health via geometry structure
      [378d9e6] xfs: report AG health via AG geometry ioctl
      [f394edc] xfs: report inode health via bulkstat
      [f73690f] xfs: track delayed allocation reservations across the fil=
esystem
      [9833c1a] xfs: always rejoin held resources during defer roll
      [e9caede] xfs: add online scrub for superblock counters
      [247c499] xfs: don't reserve per-AG space for an internal log

Dave Chinner (1):
      [4ddaada] xfs: bump XFS_IOC_FSGEOMETRY to v5 structures

Eric Sandeen (7):
      [a37cde5] xfs: change some error-less functions to void types
      [e20cbd1] xfsprogs: Release v5.2.0-rc0
      [e6afdab] libxfs: reorder functions in libxfs/trans.c
      [9c64b9b] libxfs: cosmetic changes to libxfs/trans.c
      [42b85f5] libxfs: trivial changes to libxfs/trans.c
      [3a3f5b1] libxfs: don't use enum for buffer flags
      [2976bfe] xfsprogs: Release v5.2.0


Code Diffstat:

 VERSION                     |   2 +-
 configure.ac                |   2 +-
 db/info.c                   |  10 +-
 debian/changelog            |   6 +
 doc/CHANGES                 |   6 +
 fsr/xfs_fsr.c               |   8 +-
 include/xfs_mount.h         |   8 +
 include/xfs_trace.h         |   5 +
 include/xfs_trans.h         |   7 +-
 libxfs/libxfs_api_defs.h    |   1 +
 libxfs/libxfs_io.h          |  17 +-
 libxfs/libxfs_priv.h        |   1 +
 libxfs/trans.c              | 406 +++++++++++++++++++++++++++-----------=
------
 libxfs/util.c               |  21 ++-
 libxfs/xfs_ag.c             |  54 ++++++
 libxfs/xfs_ag.h             |   2 +
 libxfs/xfs_alloc.c          |  13 +-
 libxfs/xfs_attr.c           |  35 ++--
 libxfs/xfs_attr.h           |   2 +-
 libxfs/xfs_bmap.c           |  17 +-
 libxfs/xfs_defer.c          |  14 +-
 libxfs/xfs_dquot_buf.c      |   4 +-
 libxfs/xfs_fs.h             | 139 +++++++++++----
 libxfs/xfs_health.h         | 190 +++++++++++++++++++++
 libxfs/xfs_ialloc_btree.c   |   9 +
 libxfs/xfs_quota_defs.h     |   2 +-
 libxfs/xfs_refcount_btree.c |   9 +
 libxfs/xfs_rmap_btree.c     |   9 +
 libxfs/xfs_sb.c             |  18 +-
 libxfs/xfs_sb.h             |   2 +-
 libxfs/xfs_trans_resv.c     |   6 +-
 libxfs/xfs_types.c          |   2 +-
 libxfs/xfs_types.h          |   2 +
 mkfs/xfs_mkfs.c             |  11 +-
 rtcp/xfs_rtcp.c             |   2 +-
 35 files changed, 766 insertions(+), 276 deletions(-)
 create mode 100644 libxfs/xfs_health.h


--zwQSGMd8rxxqtShwbeXRTFViFTLnK9jtA--

--a4jNrQfPmXxLdvGXuoPbj6kMFY9CjRENj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl1NzBUACgkQIK4WkuE9
3uB2Dg/+JPQYh31RMx927fpPAkcMEZFGQN8b2nMMVhvraiNvAlfeaRiQEmtmysdy
KQDRDuejV6NXi1jbMpD1VuxShCmi/2gr0ZGVtAn8NqToCOx8fcjGNXEEMJcuBqjb
nFOYfzdYs9DqE1TL9quny4eWlvtW+dOyRFtSYrUMlEqG5D/2ZJ6ZNdArk9JEQt5O
2QMavBzysgKlwQK9mJRfaAOGzfH1/R6tZscZpNEBCj2MeLxvemgoxnWugku0s/58
+7Qo2noOFRABwBQQPTiLRnXu6Hrs4sSs92aBR2/J0uer4nEDrBxx1+iOy0p+174/
K6ZcjXVfYNaXIQFulRxOpwl5KN3QJjzGD3ufKNAz3STDc+2N8H2UVfz1nbqTKwFV
B5R5pbeOS0Xlpk9UDQCG3CnAdh6UodheEOozPCr8w/VWO6/txO4ZnauEACZ3SRws
jSvyUiEk24bV+zGNpqcriSQgdZg6jKci4zP7qFNQ9gesXxEU1kluyAalgRkeSm6a
WHCxUpIic1ZPR7wHm7WCw6UL9dAd5QQnYNMQaLH9pCiKPh+b9+myu/Qpvb+0Fm9Z
17l+kNXd48BybugEBHjTlDqVw1qeybTQ4AlHNOtALQi/p3d9ti5QrgGRf4ad5kIZ
D1lImq7Ovi2aaOR+bn38YS7S8dn1lQCnk7PC4WyPFpxj8zPVtv8=
=/+NG
-----END PGP SIGNATURE-----

--a4jNrQfPmXxLdvGXuoPbj6kMFY9CjRENj--
