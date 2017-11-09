Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45946 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751017AbdKIU6x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Nov 2017 15:58:53 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2B1B28A
        for <linux-xfs@vger.kernel.org>; Thu,  9 Nov 2017 14:58:53 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 43ba1d6
Message-ID: <0fd979aa-be20-3c7e-d848-5a3d9beb11f0@sandeen.net>
Date: Thu, 9 Nov 2017 14:58:52 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rh748Pgarb73c1UTPUWoWsjtpfN5noqJ5"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rh748Pgarb73c1UTPUWoWsjtpfN5noqJ5
Content-Type: multipart/mixed; boundary="20ok4qrnk79un1xD3xOjUBnS12X49bvFa";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <0fd979aa-be20-3c7e-d848-5a3d9beb11f0@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 43ba1d6

--20ok4qrnk79un1xD3xOjUBnS12X49bvFa
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

The new head of the for-next branch is commit:

43ba1d6 xfs_io: Allow partial writes

New Commits:

Goldwyn Rodrigues (4):
      [68c269c] xfs_io: Disable -V if pwritev is not available
      [c5deeac] xfs_io: Add support for pwritev2()
      [0799d5c] xfs_io: Add RWF_NOWAIT to pwritev2()
      [43ba1d6] xfs_io: Allow partial writes


Code Diffstat:

 configure.ac          |  1 +
 include/builddefs.in  |  1 +
 io/Makefile           |  4 +++
 io/io.h               |  1 +
 io/pwrite.c           | 87 +++++++++++++++++++++++++++++++++++++++++----=
------
 m4/package_libcdev.m4 | 16 ++++++++++
 man/man8/xfs_io.8     | 31 +++++++++++-------
 7 files changed, 114 insertions(+), 27 deletions(-)


--20ok4qrnk79un1xD3xOjUBnS12X49bvFa--

--rh748Pgarb73c1UTPUWoWsjtpfN5noqJ5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAloEwY0ACgkQIK4WkuE9
3uAy7hAAi75SZ2HTLME3ZzD5qgzgOaXrIehodFyBnyzxwap5ZO6QuL0pkgixfsuq
a/oDQVDLpuP5cj80AWBRAhyCEsUzaE3t6ObNyFXg8Msv/4om4aCgkpPMaPGBrDL5
QrGf9HBNREdaqRrQlZVAMmZMzkq2QYa2P9szsXKgvqbbjxgUO88mvL/uSxJr85Oi
Nc5zSfnYuIFhS4Lfjh30xa+hvUxF7MFAihgwsLlmOyyl3j0TQQl3NVah2zWu8DQT
g5WrYsg0T1ZptE8PJuNizHf1/qz2kpQksqbhEKDCHU7vs8M4TEDO7P14774Bxz8b
zMCM+Zzfv7JG26rSqvxU8Gmv06i+Pq9hg7eMzjJiAZ41LP0QfTrpmk8V1nSfe1IR
ZgH3wllsMSe3UEI1ns0FlvpTAmIdcw0h143+FiXdVEzRu0brQzLUezlFybRIkVWQ
8lJOV6wnV/2i1tuvQz136tVbyFpKPhTEiaM0KZZdB5O1Pun90Wdqtrnv4IlUFY76
JS6RoW5lLLB9bTDxuiSiP+JYtVrStLC/QKt6HclMP2NEe4g5zTGDxDHWLooypkN6
EP19JjjdtFJdcQ2V9ANMYMfgslwwAc7XwReHJ9md3mES950SE4TYR1Wubcnqpac9
kyc+TJfEmUtJ2+/a6LqWfB+OJIXRKzEFDKm+uSGKcvMD9pqTP2o=
=uuqB
-----END PGP SIGNATURE-----

--rh748Pgarb73c1UTPUWoWsjtpfN5noqJ5--
