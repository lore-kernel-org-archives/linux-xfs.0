Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39432 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751901AbeC0WqY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Mar 2018 18:46:24 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 66AF02B0F
        for <linux-xfs@vger.kernel.org>; Tue, 27 Mar 2018 17:45:59 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 8aee048
Message-ID: <9d8c111b-b2e4-6018-43a3-9bd4de3e15c6@sandeen.net>
Date: Tue, 27 Mar 2018 17:46:22 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oQ1EDy1B9J43TDyKRYzKjokiaG3k8ejII"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oQ1EDy1B9J43TDyKRYzKjokiaG3k8ejII
Content-Type: multipart/mixed; boundary="umL3NHljLmCHF3IlegmSMwmKIH1PrbnYQ";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <9d8c111b-b2e4-6018-43a3-9bd4de3e15c6@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 8aee048

--umL3NHljLmCHF3IlegmSMwmKIH1PrbnYQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This picks up a patch I missed from Darrick and fixes all the
woeful coverity errors he introduced.  ;)

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

8aee048 libfrog: handle NULL dir && blkdev in __fs_table_lookup_mount

New Commits:

Darrick J. Wong (1):
      [19177e6] xfs_spaceman: remove incorrect linux/fs.h include

Eric Sandeen (3):
      [25992d9] xfs_scrub: synchronize error levels & logging
      [6d135e8] xfs_scrub: initialize movon in xfs_scrub_connections
      [8aee048] libfrog: handle NULL dir && blkdev in __fs_table_lookup_m=
ount


Code Diffstat:

 libfrog/paths.c |  3 +++
 scrub/common.c  | 29 +++++++++++++----------------
 scrub/phase5.c  |  2 +-
 spaceman/trim.c |  1 -
 4 files changed, 17 insertions(+), 18 deletions(-)


--umL3NHljLmCHF3IlegmSMwmKIH1PrbnYQ--

--oQ1EDy1B9J43TDyKRYzKjokiaG3k8ejII
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlq6yb4ACgkQIK4WkuE9
3uCe6Q/5ASz3hw9TzWkGaYib39QHY82S3Ul1Bv0CSlvumnlywhExNVZPpoU8wirf
0+EC+Tj6iX58wPMkucmijPnFLQT6/6eX4zsdLmAOgKWYP1Tx0EeInWT6u/HAhN6Q
hIdvzuETSAkQcjZMbLQtUmMJ1Q+VTn91i+Cxpla+/LeWIuOKA+2cgZcD/J4L8MqZ
GCDT+4eggjSUJ1V0NpZm7DudHCGjNmu25HlxQqhclYhgHSrmfI75G8GDul/XKHc4
kBNPVBg9t9pTnY4kLkgFtRuSurTIcSyt8O08qt91uOL/HF+GZReu35z9GrdeqXWi
FsDvBvaA+JqpYos76JqKs6AzG+kbX0HXg2ou/DUgvwLt5kKwpIeVVMyuk2dbvZFf
cubcvp8n7ieXTQXX8T5DcNmypJjGjWJAOZ7y1ZxY7RlHO1l1P4a1TtNEoyjt54m7
tPF5eSjgpBX/+Gra/kdF2LhfLfgZK/xeJpG4PJ5rA5foQew164i2vJSLLZG/fJQE
s65ftU0lkSS5aa0l20JXYKuZ84OWlODTSVv7VMqh1br5NAIs9SSuCvlJ1EOoFI4C
yOVlVNfjC65v/InXFjTKPZYQ+j0vcp5qvRZxY+o1f4RCL0lI95gIXxnLTatz91Dj
+xPDhNjiyUUpy8Qmvk5VKpsfsvz5rBKaGtkGmyaUB3JKiXJtkFA=
=ldQe
-----END PGP SIGNATURE-----

--oQ1EDy1B9J43TDyKRYzKjokiaG3k8ejII--
