Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58146 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751728AbdIUWHT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Sep 2017 18:07:19 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 610E0831098
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 17:07:10 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: master updated to f462230 (4.13.0-rc2)
Message-ID: <5fc7a2e0-3707-a02d-6961-e5d22fddf1a5@sandeen.net>
Date: Thu, 21 Sep 2017 17:07:13 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="S5N4HI5VvpnPGIq8pGf3438RvSxvGMS1i"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--S5N4HI5VvpnPGIq8pGf3438RvSxvGMS1i
Content-Type: multipart/mixed; boundary="F6W5RT6vjn5sQak12l5cOmECewtEdhTso";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <5fc7a2e0-3707-a02d-6961-e5d22fddf1a5@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: master updated to f462230 (4.13.0-rc2)

--F6W5RT6vjn5sQak12l5cOmECewtEdhTso
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

f462230 xfsprogs: Release v4.13.0-rc2

New Commits:

Darrick J. Wong (2):
      [06b8035] mkfs: pass a custom cowextsize into the created filesyste=
m
      [85c9f7f] xfs_repair: handle missing extent states

Eric Sandeen (1):
      [f462230] xfsprogs: Release v4.13.0-rc2

Zirong Lang (1):
      [f810b1b] xfs_db: version command misses RMAPBT feature string


Code Diffstat:

 VERSION             |  2 +-
 configure.ac        |  2 +-
 db/sb.c             |  2 ++
 doc/CHANGES         |  5 +++++
 libxfs/util.c       | 64 +++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++--
 man/man8/mkfs.xfs.8 |  7 +++++++
 mkfs/xfs_mkfs.c     | 20 ++++++++++++++++++++
 repair/dinode.c     |  7 +++++++
 8 files changed, 105 insertions(+), 4 deletions(-)


--F6W5RT6vjn5sQak12l5cOmECewtEdhTso--

--S5N4HI5VvpnPGIq8pGf3438RvSxvGMS1i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJZxDgWAAoJECCuFpLhPd7gXUoQAISee/vW6RASt59RxuNdFWfm
06zsynfJRM9XAtq5gF502bT59oWQDa95thntNU8D+JHmyp/Gwa4vaSvDBJTWh2Ww
eVYEGIoIRa6ltQG434QHJwHUyteqISRqNlhYqmIAkUWaQt9rLnqpY7skabV5/7um
XyEgFNJILoF6Qxz0g7JOYAKjCaB6LfOKzEuBK0lqk/ai8DA7fMS4uaBCDYjUUxjJ
YSJWapS0XrkVcZxZ6c7alnEgqzxwWu+IPZNQ6y2tVlbxe/zb1zrQfr+27IuPi8HV
oRS8wc4KYlLKuB1YyH6kIl2tOCN4Appyo6wZ9Zev+U84LZuf+4hX5tIgNQzGgo6E
jDdsr+mvtHDxB5/PXTVgPBQOrCBWSAZ1yjBFgHN1wjEa4a68ewJkdKdcmxOFwA4Q
FFetpHJBp/WC3xB1v3DMEceHzsZvfL7d40fFwK6VQalEZ84b0gfMdj+u1xQewKVm
EhVQap4OYO3PSfzLxg2i10CWZSqNzHIk8rF19PsuBXiXhFEf9BqPetFQ3xtqlbts
0Up4k8r30yNDPJxx+wHLNYUxiO0PtLyQOr7VZqHWTneS3O2EQGjuNg00qV7Ky6xE
yOLLRolO63sdkqKWTAjq5wxaVazM8MsbZo2f4Cy4gAkj/nrWHCQH4xWiujmtPh39
QdtQVmVri9NDFkS7R2gA
=dLGK
-----END PGP SIGNATURE-----

--S5N4HI5VvpnPGIq8pGf3438RvSxvGMS1i--
