Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37040 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932305AbdK0RIz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Nov 2017 12:08:55 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 47A1B4425
        for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2017 11:08:29 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v4.14.0 released
Message-ID: <dc7e7f37-70aa-e34d-0242-a362f1a90857@sandeen.net>
Date: Mon, 27 Nov 2017 11:08:53 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NIjFLqvu9Sj2NHOK396p5cISmU7u65c8x"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NIjFLqvu9Sj2NHOK396p5cISmU7u65c8x
Content-Type: multipart/mixed; boundary="p0O6K1wVb2f1fkTRlRIdOaOWpPIJ6Lea9";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <dc7e7f37-70aa-e34d-0242-a362f1a90857@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v4.14.0 released

--p0O6K1wVb2f1fkTRlRIdOaOWpPIJ6Lea9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v4.14.0 release.

Tarballs will be on kernel.org shortly.

There are no changes since v4.14.0-rc2.

Patches often get missed, so please check if your outstanding
patches were in this release. If they have not been in this release,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

19ca9b0 xfsprogs: Release v4.14.0

A brief summary of changes in this release:

        - xfs_repair: fix deadlock on failed refcountbt checks (Darrick W=
ong)
        - xfs_repair: fix cowextsize field checking and repairing (Darric=
k Wong)
        - xfs_repair: clear DAX flag from non-file inodes (Darrick Wong)
        - xfs_repair: fix bag memory overwrite problems (Darrick Wong)
        - xfs_metadump: zap stale data in DIR2_LEAF1 dirs (Eric Sandeen)
        - xfs_metadump: allow large directory extents by default (Darrick=
 Wong)
        - xfs_copy: don't hang if all targets hit write errors (Darrick W=
ong)
        - xfs_io: stat: treat statfs.f_flags as optional (Jeff Mahoney)
        - xfs_io: stat: fix typo in statfs->f_flags (Jeff Mahoney)
        - xfs_io: Allow partial writes in pwrite (Goldwyn Rodrigues)
        - xfs_io: Add support for pwritev2() (Goldwyn Rodrigues)
        - xfs_io: Add RWF_NOWAIT to pwritev2() (Goldwyn Rodrigues))
        - xfs_io: Disable pwrite -V if pwritev unavailable (Goldwyn Rodri=
gues)
        - xfs_io: add new error injection knobs to inject command (Darric=
k Wong)
        - xfs_io: report io errors from pwrite -W and -w (Liu Bo)



--p0O6K1wVb2f1fkTRlRIdOaOWpPIJ6Lea9--

--NIjFLqvu9Sj2NHOK396p5cISmU7u65c8x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlocRqUACgkQIK4WkuE9
3uAw+BAAqwBjXEcZG7p4cCQMiMmI6nuvwGD/BiHNBadpN0ofpk6Tz9dVgrMVODol
FyDFIRwA/shuoXv9NuaruS+9bNUkxa5lXbLxGlDWcv0RKhuw272TevQrZFT8zWo5
H48UZKr9htTc+n3y0PsD6G4oUcEgP66mYz2yc6r0zXUe0hYY8f5LG0SwdDmeoeMm
58vdPjp1oK67IQyZfzDZf02VPVb5bP/EffSQW1i61IEuT2bOBwv+rlL5GJzPWeYB
qK+WVybnONeafUwEwOCXt4LUZirgCGxFBUNmhgcMCdAorzVHLhMhSoHr7oU07rCx
WFsBecde7lT3GsZj6ng45gWS2nvJfvdDb9DVf58mWfRGv4Y6mz+gH1YBpfmrSfR0
ZS5n0iTIpnuOwITciavq5NdfEXR+pRu3AZymMkEQz+/tUutrzIvbBa1+BAr5duAU
TAZkCHrXgrYNi2uDSXa5msVKyECxBxzNeNGMU5HrchUYdP4tRyU73wiWdRdSW/II
hbjwOioVOgDGRTeOMOFyW/RknagOyDc9zEOYzHXInQ43BC1HseYgQpexkI83p09r
ikSQkWT5iTdGJmlp2NGBk5r0xI18saBxoJ31Ppy71AfpN1zWeWQrIya4kvcsWEOA
7675/gch82q/T8ynGdmygn86b/eDscoQx8lnwYh90I5bAJ2eF/0=
=O23n
-----END PGP SIGNATURE-----

--NIjFLqvu9Sj2NHOK396p5cISmU7u65c8x--
