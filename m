Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54862 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbfFYU3u (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jun 2019 16:29:50 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 29A6278D0
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 15:29:40 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 80704dd8
Message-ID: <637c74e5-01b9-af25-0576-ba544ff8f0e6@sandeen.net>
Date: Tue, 25 Jun 2019 15:29:47 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DTK5tcwtxK8Ha7FI9cM3yLjHi7WRUODrl"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DTK5tcwtxK8Ha7FI9cM3yLjHi7WRUODrl
Content-Type: multipart/mixed; boundary="2aDeQPoMOFcNzn71RUH5jWarwTT20Fl53";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <637c74e5-01b9-af25-0576-ba544ff8f0e6@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 80704dd8

--2aDeQPoMOFcNzn71RUH5jWarwTT20Fl53
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

80704dd8 (HEAD -> for-next, korg/for-next, refs/patches/for-next/xfs_io__=
repair_f_should_use_its_own_name.patch) xfs_io: repair_f should use its o=
wn name

New Commits:

Amir Goldstein (1):
      [34ea9bb2] xfs_info: limit findmnt to find mounted xfs filesystems

Darrick J. Wong (4):
      [4f2c97eb] libfrog: don't set negative errno in conversion function=
s
      [dde3c46f] libfrog: cvt_u64 should use strtoull, not strtoll
      [bd7f9d76] mkfs: validate start and end of aligned logs
      [80704dd8] xfs_io: repair_f should use its own name


Code Diffstat:

 io/scrub.c           |  2 +-
 libfrog/convert.c    | 22 +++++++++++-----------
 mkfs/xfs_mkfs.c      | 15 ++++++++++++++-
 spaceman/xfs_info.sh |  2 +-
 4 files changed, 27 insertions(+), 14 deletions(-)


--2aDeQPoMOFcNzn71RUH5jWarwTT20Fl53--

--DTK5tcwtxK8Ha7FI9cM3yLjHi7WRUODrl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl0ShDwACgkQIK4WkuE9
3uDNWQ//demfXk2e1/eDN9vDOl6+o6qIpdOKtDoQ/sfQ9xdSnfH9jYXlN6EO3foB
x/cBWojwCa2ammqKv4GGZVE4zE0u2BH+gSvXCGuL1EGp3Dhoxsp5a/lgBh2Kkcty
27MFaqM+mif3ntyJk9zj+9Gyx/poySUCiU4qdG0ZHhvECtOZHsWq1lS4HVcJMShN
u5QHvkcGMgrKx/enpRO38oY06oF4Ylt92aC5uInAsffDdY5C02wW8CKhklfK0M9y
pkTx/CThkffjMxNrwXsXWbwcIgzmXUdygpIGdUfbeY3zalygA09p1syf8sH3HIwy
zQ7xJpbYgKBCjgwOGdX3+MSBGCnOEq25V//NpZw6nHXqyuIqJ1yKsWBH4u/khb8H
eEbzdaCT5RYgSod5+x9DKICkmpjNHqm1pGfugbm7LS92byH8twc/TACnfHhCsQ0k
mKEW5NKKIFtWV+T1SM5fUsRkqwQ0MlZEcp4bKqEEzd3XoaiJ5HMlYA3nlYvSOspo
jqOS2Pic4I1lKDi4eqLRpE6QGUdPhq4D28POhXethjjZXFtOpKegMoiDNxZoGZf/
ON9OxNX/AwgxpP7fswt4sify5YPhCkrJQycTJ01gbQJ143D55RgCHR/RISxN4H/6
Xcm50ws7TJlr2uVeUiCMJIn2p3mk1Yn1RwhfW7RYlUX5ncLevLQ=
=XPOj
-----END PGP SIGNATURE-----

--DTK5tcwtxK8Ha7FI9cM3yLjHi7WRUODrl--
