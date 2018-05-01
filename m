Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52096 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751512AbeEADGp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Apr 2018 23:06:45 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 6D080479AE3
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 22:05:32 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-4.16.1 released
Message-ID: <4e7144a7-5349-734c-6c5a-6b214d8f4776@sandeen.net>
Date: Mon, 30 Apr 2018 22:06:43 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fDjRuykiJuuVLVK2hFzokjQnkw8LL2Bzb"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fDjRuykiJuuVLVK2hFzokjQnkw8LL2Bzb
Content-Type: multipart/mixed; boundary="0ym5iPJ2hKIYlfu3OU1tmLOJFZl5ZS012";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <4e7144a7-5349-734c-6c5a-6b214d8f4776@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-4.16.1 released

--0ym5iPJ2hKIYlfu3OU1tmLOJFZl5ZS012
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The master branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v4.16.1

This fixes an issue with fsck.xfs using a bashim with a sh-shebang,
which at best is ignored on some systems, or may range from warnings
to errors to boot failures on systems that enforce a strict sh shell
with no bashisms available.

The new head of the master branch is commit:

27c3aeb xfsprogs: Release v4.16.1

New Commits:

Eric Sandeen (2):
      [7a58ab0] fsck.xfs: do not use 'function' keyword
      [27c3aeb] xfsprogs: Release v4.16.1


Code Diffstat:

 VERSION          | 2 +-
 configure.ac     | 2 +-
 debian/changelog | 7 +++++++
 doc/CHANGES      | 3 +++
 fsck/xfs_fsck.sh | 2 +-
 5 files changed, 13 insertions(+), 3 deletions(-)


--0ym5iPJ2hKIYlfu3OU1tmLOJFZl5ZS012--

--fDjRuykiJuuVLVK2hFzokjQnkw8LL2Bzb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlrn2cQACgkQIK4WkuE9
3uAI2BAApKB7iAtMGTqrbVu44G5R4acaxi89FTboWjAAeONcGXcT4l7xGYxB3IiR
3jw447TPcg399ay7W3CAyap4uoUP8+gBRgSBVEP1/O755C7FTxVZE/FLSDges+UN
R1MFNUAfg1MjXT9NZdzCm3wK4uqiIFUuAeCSRhWkl3n3/XBHGXmubStL/IN1rys8
CE4Z+rAeR0c/znmMfy5GBb4u5tZ96x2gwVCjR5xVxzsI28s1vMBOtWEqL+EXDMtf
tIgAHrowbteoVg7RjM9sdnpDEl3OO2AlON1cBTH8gc8FiqViZgfVKos54nSyWt2R
OEBjlV3DV5XdQMBBpHSGuY3ZSOKbEK1QJioIhHv2y9yDJU4ocbNuvcf0xW+QG1Xw
o/w4QtRAEcktX2xdzjLjvwNzVJ1Gsi7rrGzhtY+gkGZ8An4gMgnqRSiooMnRPy3c
HpywseUcOoEPGANKDfNmWFbrf3gTXea+AiQWses/9RuqpTP5h1hDxlufqzOlOknb
8hfb0WaLGJ9qnRq/x+5XE+JM5/3+pXRsjRpdiqHKFvF2rT5xGXJC/kzg2MkfYQ+8
V9WPJc2ABPN8DLGU/hvPMimb2bQy9bcnQLRgXePAjh9qZ5ZThOq+MU62YgTR2QSw
3RGb2Jw+jpVtaT9NzMmEfIaPNR62rkBlzrnVLh+/XC90mG8oJcQ=
=q9lw
-----END PGP SIGNATURE-----

--fDjRuykiJuuVLVK2hFzokjQnkw8LL2Bzb--
