Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47080 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726747AbfGYV4o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Jul 2019 17:56:44 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 171192B08
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 16:56:13 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 3a3f5b14
Message-ID: <087b7894-93a6-0af0-0278-0c6c45c9db8c@sandeen.net>
Date: Thu, 25 Jul 2019 16:56:42 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WFGR4ke8nTZnWsGWkRWE9JuXoG5WXTAzb"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WFGR4ke8nTZnWsGWkRWE9JuXoG5WXTAzb
Content-Type: multipart/mixed; boundary="WjxYvlLoVtI3OE3WUtMAOS1ThBXoRle01";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <087b7894-93a6-0af0-0278-0c6c45c9db8c@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 3a3f5b14

--WjxYvlLoVtI3OE3WUtMAOS1ThBXoRle01
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This is just my gratuitous modifications of libxfs/trans.c to
more closely resemble kernelspace code.

The new head of the for-next branch is commit:

3a3f5b14 libxfs: don't use enum for buffer flags

New Commits:

Eric Sandeen (4):
      [e6afdab6] libxfs: reorder functions in libxfs/trans.c
      [9c64b9b3] libxfs: cosmetic changes to libxfs/trans.c
      [42b85f55] libxfs: trivial changes to libxfs/trans.c
      [3a3f5b14] libxfs: don't use enum for buffer flags


Code Diffstat:

 include/xfs_trace.h |   2 +
 include/xfs_trans.h |   6 +-
 libxfs/libxfs_io.h  |  17 ++-
 libxfs/trans.c      | 414 ++++++++++++++++++++++++++++++----------------=
------
 4 files changed, 253 insertions(+), 186 deletions(-)


--WjxYvlLoVtI3OE3WUtMAOS1ThBXoRle01--

--WFGR4ke8nTZnWsGWkRWE9JuXoG5WXTAzb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl06JZoACgkQIK4WkuE9
3uChIhAAntL4jdtuUXfFDuoZ2MeGCZAsbAxKZMCJtAR4ip/htS1kpfLv38LtDeN5
vzyE+r8DKRPZrqPvTDRkIppEL0/Q72gmabr732qBUW81TiWaDyylbEqCEcaiG1e9
j7LSjgWUXO7d7N3xG+mf6TwToBjq35coQuqIhnuDAkW78QRNY2wYhfsNf0iWho+i
tVnT3sG3vOlStgv8RqEu8o7xCHZtn5MDD0gv73cDKnja8+UiEmL+nfAJbE6thBus
v6Czz1L7VPq1hdG9/RofywHUok6QDKG9T6BA/oX9c1Rg7qdF2wLjxZ+TNZYj3bs1
a2x3ERB+EKs9HQMqlEuiv0fVmvT2804eSdyI0C3PZpU5CdmlW2nkzsMHf/2V0VLu
ApgFQr2yLtXW31XkrOsxbM9ZnmLj7c2ZELalMVkeTXk5pDEs6at8CVCYJL9sQVGx
/7d7ay2lapmp0JxYfl0lJHi9TGSXkt5wzI3OHSr6vgaux4kp3c3wWLNDT2a4uv2m
bMGywA/bH6EkaNqCwveRKj+oIczHKjy10q4OABVN0G7JuQQehq7FNQm/9mrYo3pL
FeK9yzmbxYabAUgS89vGiUqcvT0KwI87N/xF5oVZUZnhlR0zWurL3h9qmxIeM/lr
I27QLdEHzShQ+FT9uUXSG5VFMgyXPZ0k9KPsZ0DgMmlntM83AMQ=
=E1St
-----END PGP SIGNATURE-----

--WFGR4ke8nTZnWsGWkRWE9JuXoG5WXTAzb--
