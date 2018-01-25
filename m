Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49330 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751106AbeAYUBL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Jan 2018 15:01:11 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 69D27170B45
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jan 2018 14:00:59 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] for-next updated to 50663dc
Message-ID: <1e9b02d2-3a94-b444-1e11-80b7c6f2aba8@sandeen.net>
Date: Thu, 25 Jan 2018 14:01:10 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Otr16r16lzVXhaHneLosoA1YINcTiu3jB"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Otr16r16lzVXhaHneLosoA1YINcTiu3jB
Content-Type: multipart/mixed; boundary="dex1093hCcuMiv2EKhvIvLop6ie9kcGtA";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <1e9b02d2-3a94-b444-1e11-80b7c6f2aba8@sandeen.net>
Subject: [ANNOUNCE] for-next updated to 50663dc

--dex1093hCcuMiv2EKhvIvLop6ie9kcGtA
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

Still working on scrub review, hoping to have that in the next
point release.

The new head of the for-next branch is commit:

50663dc xfsprogs: update dead urls

New Commits:

Christoph Hellwig (2): (note these are merges from older kernelspace)
      [38d096b] xfs: remove wrappers around b_fspriv
      [cfc06b6] xfs: add a proper transaction pointer to struct xfs_buf

Darrick J. Wong (1):
      [50663dc] xfsprogs: update dead urls

Eric Sandeen (5):
      [2e2caf7] libxfs: remove unused buf_fsprivate3
      [67d7227] libxfs: use a memory zone for transactions
      [a1c5615] libxfs: use a memory zone for log items
      [12f365e] xfs_logprint: fix v3 inode formatting
      [d0ca5d8] xfs_copy: accept CRC version of ABTB_MAGIC in ASSERT


Code Diffstat:

 README                   |   2 +-
 copy/xfs_copy.c          |   3 +-
 debian/control           |   6 +--
 debian/copyright         |   2 +-
 debian/watch             |   2 +-
 libxfs/init.c            |   4 ++
 libxfs/libxfs_io.h       |  10 +---
 libxfs/logitem.c         |   8 ++-
 libxfs/trans.c           | 137 ++++++++++++++++++++++++-----------------=
------
 libxfs/util.c            |   2 +-
 logprint/log_print_all.c |   2 +-
 11 files changed, 87 insertions(+), 91 deletions(-)


--dex1093hCcuMiv2EKhvIvLop6ie9kcGtA--

--Otr16r16lzVXhaHneLosoA1YINcTiu3jB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlpqN4YACgkQIK4WkuE9
3uC9Fw/9HJXaDe5sU7LN+Hd6fDb0n18191NT9ZnzQhZZdkEFsVrnyUV0Hk4xMVci
VzJeejwiqMR6L/AyMwq/YSTlYh4YVQOMc81bsWlOal7IvucfsXpiDclp4vteHb4Y
gHmR8XvKPGgE/N8umhq3RX7bA9ROvO00TrL4b5R1XImPj0wtQLdx79fkg1S0IknJ
YOVuFZ95kZZUn23I3bYe9Qsco1SZLA4e6SmKGH/5KHvipu2J+dwgHzvAp62FdDVc
EY9BRV+oC3h757gi0mM7PoNhMNQZplgm6g4UGYN9Poodn0QN7JK3VjJxHdSPmhaf
qXM1ujzWAwrj0wDXKQHHUuHr0/Q4CI3Y/i4+Ry7Hed2vgo8ncbV9YYjyEmX8O8sG
V313qCxARpretN+vedny1Jfg96uS0Fxwh/pOgdX3iqalu01zXbLU6GKoUmLqzGfS
wIaIKD82C95vTMbsLP2zb4lLlD95i6cxY9eMiKxul3ffxDxMGWEVOUdnLkur8sv0
0eRgxrZ5PjjJANTEvQRA1wKGd/74+kBok+zLogY1FYGqnWIJjQdZ2V9jwg2XaH6o
E+fpeVAluo360nv3GQAIe01+0LEgtmdL5G4XfR7Ef4enYoGfUQLti8h44qY0Csay
u9+JEDRKc8F2701gAGH09cYvsf/hxnVGDiQlLatoiqBNj2n6gTY=
=bNWz
-----END PGP SIGNATURE-----

--Otr16r16lzVXhaHneLosoA1YINcTiu3jB--
