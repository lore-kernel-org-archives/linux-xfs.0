Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52174 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751376AbeDCRFx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Apr 2018 13:05:53 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id F177D1727B
        for <linux-xfs@vger.kernel.org>; Tue,  3 Apr 2018 12:05:18 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to a8502cc
Message-ID: <0b8de007-499d-ae6b-bb14-f8666b37ecfe@sandeen.net>
Date: Tue, 3 Apr 2018 12:05:50 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="n2w5KdqZLZfod1mPuHkhZ6ISkYbGX91II"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--n2w5KdqZLZfod1mPuHkhZ6ISkYbGX91II
Content-Type: multipart/mixed; boundary="Qr2MNj6HacE6TluKOB28jxIvSlva0A8nA";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <0b8de007-499d-ae6b-bb14-f8666b37ecfe@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to a8502cc

--Qr2MNj6HacE6TluKOB28jxIvSlva0A8nA
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

a8502cc libxfs: warn about deprecation of irix, freebsd, darwin

New Commits:

Eric Sandeen (11):
      [497d070] xfs_repair: remove unused fs_attributes_allowed
      [232470f] xfs_repair: remove unused fs_attributes2_allowed
      [99a1e0d] xfs_repair: remove unused fs_has_extflgbit_allowed
      [dd17791] xfs_repair: remove unused fs_aligned_inodes_allowed
      [644589b] xfs_repair: remove unused fs_sb_feature_bits_allowed
      [a425d16] xfs_repair: remove unused fs_has_extflgbit_allowed
      [ea94cb6] xfs_repair: remove unused fs_shared_allowed variable
      [42fa89b] xfs_repair: remove pre_65_beta option
      [28a4f9c] xfsprogs: remove unused delete_attr_ok
      [31506b3] xfs_repair: test XFS_SB_VERSION_SHAREDBIT only once
      [a8502cc] libxfs: warn about deprecation of irix, freebsd, darwin


Code Diffstat:

 libxfs/darwin.c     |   4 ++
 libxfs/freebsd.c    |   4 ++
 libxfs/irix.c       |   4 ++
 repair/dinode.c     |  13 ++---
 repair/globals.h    |   2 -
 repair/versions.c   | 147 +++++++---------------------------------------=
------
 repair/versions.h   |  26 ----------
 repair/xfs_repair.c |  19 -------
 8 files changed, 35 insertions(+), 184 deletions(-)


--Qr2MNj6HacE6TluKOB28jxIvSlva0A8nA--

--n2w5KdqZLZfod1mPuHkhZ6ISkYbGX91II
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlrDtG8ACgkQIK4WkuE9
3uD6fQ/9EIGkX/1ERrm4dR1z+WarwPIiwNDXOqHzhLXQB4f+uwBVF3IhkaM7EFbp
p6oNqeY71N+/5/ht4KeX2Yq3cBuWeHxQ6TukQtu/2iLmNJZ6f8Bjo83uDxcwq4HA
DkZzB6sb5wkVAA8Y5Mx+LSvk4V6JtRw8Aj1CdSLW5mMLqcW4l/prhFfA7zwB7n8a
Hcqjpa+RVMck+AJw/K7toxZzZfm8hfKO3TBkxhBzDqO2C1m6ipOYjlQ3SMQjS8zz
nA5I7OislhFiqQJDiFkW72BKvGV8420wvDF0OBY5CSd/kzcSGRs5KEzJNZZm6VVR
umtmOiV8IKhuYKRrxS2eItHMzbRhjX5Ya8UteBazKl6aGaepz3TdICyvmYl+P/Hp
rpNIxvNXP3FlJjXSHeqYX80o1AQPLEmCQz8xM2JjXJ445Jx23SMH1S8A7SE4v1cl
o/iINqxRyFqcHmLy/hlHeFZjZlaUYPE1Hwe9Ibr0XSxMuXbmh0uyMYei6fcksPLY
soSOGAj9JOXNtbaM9u2DRJGRwqNIsHulWehIGMx9nrcsN4/m1g5VkBfAXeyttlC7
S02Np8SwSxdNBmtKYj2LRE2Scy8XsCb13YRuDEgL6hvhNcLCNmaoVQKKNzLkK9xk
Nz2nCZUJpdY72XA7Nr6JcHlVQ7eq8RNF2H1lpWmpvD8hlPeowqE=
=KFAH
-----END PGP SIGNATURE-----

--n2w5KdqZLZfod1mPuHkhZ6ISkYbGX91II--
