Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46814 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbfDZWLS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Apr 2019 18:11:18 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id DF05D87E
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2019 17:10:29 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.0.0-rc1 released
Message-ID: <b8ef299a-4068-6b16-3034-bfbcbba6883c@sandeen.net>
Date: Fri, 26 Apr 2019 17:11:16 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bZiJF8mhR3zTGxVtZXEnBla1g9yC9v7WK"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bZiJF8mhR3zTGxVtZXEnBla1g9yC9v7WK
Content-Type: multipart/mixed; boundary="YOg4DDXnM4dcSy8DnXjuPJX2lBWdZ6dHR";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <b8ef299a-4068-6b16-3034-bfbcbba6883c@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v5.0.0-rc1 released

--YOg4DDXnM4dcSy8DnXjuPJX2lBWdZ6dHR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

xfsprogs-5.0.0-rc1 has been tagged & released on the master branch
of the xfsprogs repository.

Here's the human-facing changelog, if anything important seems to
be missing in this condensed version, let me know and I'll fix it up
before final release.

Please test and give feedback, particularly if you find any issues,
otherwise I'll (finally) have v5.0.0 baked & released next week.

thanks,
--Eric

xfsprogs-5.0.0-rc1 (26 Apr 2019)
        - mkfs: validate extent size hint parameters (Darrick Wong)
        - xfs_repair: bump on-disk nlink when adding lost+found (Darrick =
Wong)
        - xfs_repair: reinitialize root directory nlink correctly (Darric=
k Wong)
        - xfs_repair: use lenient verifiers for half-fixed inodes (Darric=
k Wong)
        - xfs_repair: acct for btree shrinks when fixing freelist (Darric=
k Wong)
        - xfs_repair: better cli option parameter checking (Darrick Wong)=

        - xfs_repair: fix deadlock due to failed inode flushes (Dave Chin=
ner)
        - xfs_info: handle devices, mountpoints, and loop files (Darrick =
Wong)
        - xfs_metadump: fix symlink handling (Darrick Wong)
        - xfs_io: fix label parsing and validation (Darrick Wong)
        - xfs_io: print attributes_mask in statx (Darrick Wong)
        - xfs_scrub: fix Make targets which depend on builddefs (Darrick =
Wong)
        - xfs_scrub: check label for misleading characters (Darrick Wong)=

        - xfs_scrub: parallelize based on storage not CPUS (Darrick Wong)=

        - xfs_scrub: activate timer only after system is up (Darrick Wong=
)
        - libxfs: fix buffer & inode lifetimes (Darrick Wong)
        - misc: fix strncpy length complaints from gcc (Darrick Wong)
        - debian build & packaging fixes (Darrick Wong)
        - Merge libxfs from kernel 5.0


--YOg4DDXnM4dcSy8DnXjuPJX2lBWdZ6dHR--

--bZiJF8mhR3zTGxVtZXEnBla1g9yC9v7WK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlzDggQACgkQIK4WkuE9
3uDg0xAAtMVP+Oi6BfdIzRfjKLPtttB4iqA9taoJr7vXIaJ/sWgBuCNuDG4kS+RZ
WY3lI83bzKD1PQBx2rvABuECr5fFgZTICKhePbJb1HB/i502SSRoeHddKfz063Lx
DKTIaHvAYz0XxdRZb1OhvBL9IQVRyS+iU42CuTMi4CEYN92AC3lDj17t0TwXUo/1
7qqydjqQJHosPIKEe8BHFTrbPkxiLTIwP6D7g5mE5BJ1LVyoZClmTl0WQaP1WTWc
UE9tpqiyDsHoX1LFoYnJK+uVopwlykcYFnGrSo2hfnISFJVqZ0XyxOdsNswyGinb
EbHUVpBHYYjHbdWV7DKbqa/s2X2M8mMCL7A7zXzqwWaE1kOuS3yhAtGKaUgjNF+2
pEUsbWI1KzX8M/kst5vHhdsXdHUmiJZ+ECwxxVoLaqMgt2grejZhZSz00QvlugBK
hAayHg389qlKbc2VdqiAp1HGca4dtLth+Udx4AsmXsbF8Rg+u5jM4K2Dhz8rDztZ
DMNY76mr7aJAM68tN9fypr2qUvjoxASkoY9I8ACFC1+lJ/PLiz4wGM917sAiSF8s
aMrqQmOkSn2RDfv2zGsW3GafLdpsNriBxv1TQWHcepdkTdM29hoJpOo8X/CUu4/m
2MIfPxWgk10fIvZFr2SEqJbNXDE674+/fOOW/cEpLbOFgj6edjc=
=ntDo
-----END PGP SIGNATURE-----

--bZiJF8mhR3zTGxVtZXEnBla1g9yC9v7WK--
