Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59876 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933643AbeFMDaZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Jun 2018 23:30:25 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B4FEC450A83
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jun 2018 22:30:01 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs mkfs-config branch updated to e6e27ae
Message-ID: <e59d0963-93ca-5c97-470d-5e137d5b2fba@sandeen.net>
Date: Tue, 12 Jun 2018 22:30:23 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gXrbZho42Gp7Nxifxu9TI0KVcLI7NFMmy"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gXrbZho42Gp7Nxifxu9TI0KVcLI7NFMmy
Content-Type: multipart/mixed; boundary="D9RPKLQt4To7G8VsVSBN7VyBFzhuvAfzz";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <e59d0963-93ca-5c97-470d-5e137d5b2fba@sandeen.net>
Subject: [ANNOUNCE] xfsprogs mkfs-config branch updated to e6e27ae

--D9RPKLQt4To7G8VsVSBN7VyBFzhuvAfzz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The mkfs-config branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This is part of a, uh, sprint(?) to see if we can get configfiles
ready to go for the 4.17 release.

The new head of the mkfs-config branch is commit:

e6e27ae mkfs: remove gotos in parse_defaults_file

New Commits:

Eric Sandeen (7):
      [b1bdd71] mkfs: document the config file option
      [8d0747e] mkfs: move mkfs.xfs.8 to an .in file
      [ef74ddd] mkfs: parameterize sysconfdir in mkfs.xfs.8
      [62037d8] mkfs: tidy up whitespace in mkfs/config.c
      [cf30510] mkfs: properly fix TOCTOU open/stat race in config file h=
andling
      [b70f08f] mkfs: consolidate and streamline config opening function
      [e6e27ae] mkfs: remove gotos in parse_defaults_file


Code Diffstat:

 man/man8/Makefile                      |   8 +-
 man/man8/{mkfs.xfs.8 =3D> mkfs.xfs.8.in} |  85 ++++++++++++
 mkfs/config.c                          | 233 ++++++++++++++-------------=
------
 mkfs/config.h                          |   3 +-
 mkfs/xfs_mkfs.c                        |  15 ++-
 5 files changed, 203 insertions(+), 141 deletions(-)
 rename man/man8/{mkfs.xfs.8 =3D> mkfs.xfs.8.in} (93%)


--D9RPKLQt4To7G8VsVSBN7VyBFzhuvAfzz--

--gXrbZho42Gp7Nxifxu9TI0KVcLI7NFMmy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlsgj9AACgkQIK4WkuE9
3uCyBw//RlivqZh+r8RiuUKkRHYSnHVeSzWd9mVW8ivZNBd71SfnSsVEeWBQInPF
sY8uZFJL7PFundp0/1fRlpy2ya4IUM/bmOUo6TpBi8BVIj5MeDuiYpajTc1cqCYy
pOtslaRWwBu19RWjOrpRDEj7azuIA2qUZibf4pmZundCtlE339CNfDdvGRaIQg10
0pcvTADMJHZWYAdVgai/AdTyiqGsJzu6n5GiofvYulYCYv0vufjPrxmQYeJNrluv
Hn2OGqMt5VcmSL0D9lnqZxEMEGMmKzriDruTE1lIgH7l7/PfwC9SECHDXHPJylnX
Dj77nuYXTfxOrE4WFwrglggK3uJEVCwSyaDZYYcIryp/gaEp/1/WamyPIVLgXoAn
el8gKZxJFr5eF2l1SFydumtL/OfhFrgGEJXmmxN2w9t2drXXBAZ7wOBt5iQWgv5H
wUL8OHvoGACIzksNmGorWIuy9r/hEHKCwzNQsUgrQtNKPHPiDizUt8hnSZFbPF6C
+Aln5/6HkjY1vJSoi6dUEo75YedSe1zr8cFu7343JrNARtrfNEOK4OOfRJV+OwKE
4W0MbslgE8M6/Qq/LHZHAir0aT11E8WhCN4RD3VRO6UsA9FM0WW2HP//eb5j2w+R
KEy6b49tCf27uMLJyTE5QXs2HUPSIxlQWdcN19zerbXp9Ldf1wM=
=GX2e
-----END PGP SIGNATURE-----

--gXrbZho42Gp7Nxifxu9TI0KVcLI7NFMmy--
