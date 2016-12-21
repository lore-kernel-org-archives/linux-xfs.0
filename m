Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35422 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751137AbcLUFeD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 00:34:03 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 9824C9D
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2016 23:33:34 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next branch updated to ebd6aa8
Message-ID: <e1862d0c-6e1d-66d0-bf35-5a8650a08cef@sandeen.net>
Date: Tue, 20 Dec 2016 23:33:39 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tH2Fqp1lG1oEsA8sultxQch6Mnhc5a4vR"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tH2Fqp1lG1oEsA8sultxQch6Mnhc5a4vR
Content-Type: multipart/mixed; boundary="96pqW6OXjV0hMcnFFlvMF67Acv48RsT2q";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <e1862d0c-6e1d-66d0-bf35-5a8650a08cef@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next branch updated to ebd6aa8

--96pqW6OXjV0hMcnFFlvMF67Acv48RsT2q
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This is just a handful of targeted fixes prior to the 4.9.0
release.  If you have something else that you think is absolutely
critical, please let me know ASAP.

I'd appreciate some distributed testing.  If all goes well,
the contents of the for-next branch will be the release this time,
hopefully by the end of the week.

The new head of the for-next branch is commit:

ebd6aa8 xfs_quota: handle wrapped id from GETNEXTQUOTA

New Commits:

Darrick J. Wong (3):
      [5ef80b9] xfs_repair: fix bogus rmapbt record owner check
      [ff14f59] xfs_repair: fix some potential null pointer deferences
      [f9cd7f8] xfs_repair: change null check to assertion

Eric Sandeen (3):
      [f714016] xfs_repair: junk leaf attribute if count =3D=3D 0
      [8ebad4d] xfs_repair: don't indicate dirtiness if FSGEOMETRY fails
      [ebd6aa8] xfs_quota: handle wrapped id from GETNEXTQUOTA


Code Diffstat:

 quota/report.c       |  8 ++++++++
 repair/attr_repair.c |  3 ++-
 repair/phase5.c      | 16 +++++++++++-----
 repair/rmap.c        |  2 +-
 repair/scan.c        |  8 ++++++--
 repair/slab.h        |  2 +-
 repair/xfs_repair.c  |  2 +-
 7 files changed, 30 insertions(+), 11 deletions(-)




--96pqW6OXjV0hMcnFFlvMF67Acv48RsT2q--

--tH2Fqp1lG1oEsA8sultxQch6Mnhc5a4vR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJYWhQ5AAoJECCuFpLhPd7gx+wP/3b6wgZP7Y9vauSwT62VrMOp
EYxwXS+dnJVZcsjey3Sj21sEmm5UnAZpPFO8ww0ldVo0dRnT8PJvayuQYw2jPSO+
3OdE0aOLK4Ffp47vquI8J8CP65GvLcWwkZ+6Uog8WvzA0iJnv/IKYqwp/29w58+f
hku+TqLwlU50lh2wfaOdxvAt2uNv73cXWJikUnt72n5WNlxXQBnFJChhX+o2AsuA
UY1/x2kGHNMf0UCC2B3l2N8uMUKSo/FMa41OjrMgufGJDScuJgDIl1js96N34VHM
QNoheyEyEK0nGmtdzCFB6mIBEG3qclf1we4IukFfBsh5odd0dGehrl4qMEKFrqHB
baHTGdLSMZN6poBFsKJhLKoCM0NUWbczPCbyYf9O8XGtVNdXwwNmIFsm+F0eyX8/
CZ/RnLshOglxkVA5uDKOBX2DjmzIbJVHBOIaV3fVbwyjj6X0lssOYDU5bxSIxkqy
2L9hN5DhBhPohF3RZ0597xYGggmFit9M30VRzo+ZaFRdQhVbSGF0E3nrU2Ormyji
hkX9gS++lq1iYlP9mlxkCMAuKxwN03jVfTFUFdnxc4UdDlPDhBRce8bTausf6Dl6
JOht815mWTdH17HdKhiEzrsVebU0tlrDeIT7dqkDWmQ2e6czgDCl6JIl/nfLZ3w6
6wrp0VqIkwAKNJ6bJPw+
=QW9c
-----END PGP SIGNATURE-----

--tH2Fqp1lG1oEsA8sultxQch6Mnhc5a4vR--
