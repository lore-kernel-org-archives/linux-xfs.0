Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58318 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbfEPRIi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 May 2019 13:08:38 -0400
Received: from Liberator-6.local (c-73-242-75-113.hsd1.mn.comcast.net [73.242.75.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 145CA1170D
        for <linux-xfs@vger.kernel.org>; Thu, 16 May 2019 12:08:19 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 065a57f
Message-ID: <dfac01fe-44d3-1459-3210-dd5fae4d7ec4@sandeen.net>
Date: Thu, 16 May 2019 12:08:35 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7G1bCgHBsRlIyaJSGewJqlmiRjEoYPAtZ"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7G1bCgHBsRlIyaJSGewJqlmiRjEoYPAtZ
Content-Type: multipart/mixed; boundary="5XGEbM59A7Sh02xg2yHVQV01IgH7y6FvJ";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <dfac01fe-44d3-1459-3210-dd5fae4d7ec4@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 065a57f

--5XGEbM59A7Sh02xg2yHVQV01IgH7y6FvJ
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

065a57f libxfs: rename bp_transp to b_transp in ASSERTs

New Commits:

Eric Sandeen (4):
      [b7dae40] libxfs: remove i_transp
      [da6bf62] libxfs: remove xfs_inode_log_item ili_flags
      [b8fca65] libxfs: remove unused cruft
      [065a57f] libxfs: rename bp_transp to b_transp in ASSERTs


Code Diffstat:

 include/libxfs.h         |  3 ---
 include/xfs_inode.h      |  1 -
 include/xfs_trans.h      | 10 ----------
 libxfs/libxfs_api_defs.h |  5 -----
 libxfs/libxfs_priv.h     |  9 ---------
 libxfs/trans.c           | 52 +++++++++++-------------------------------=
---------
 libxfs/util.c            | 29 ----------------------------
 7 files changed, 11 insertions(+), 98 deletions(-)


--5XGEbM59A7Sh02xg2yHVQV01IgH7y6FvJ--

--7G1bCgHBsRlIyaJSGewJqlmiRjEoYPAtZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlzdmRQACgkQIK4WkuE9
3uB7HhAApc5YH3imzlUTsZJQo1TMPhoSIzJG/Xdi+VlrL83z/jE/kt0TzkY53FeZ
RzqOeZ4QyazOUvVS0dnn9OiZEgEUZgW8iObfCKta+m79GXtgWGRxRT27FRrtSe8H
rJ90rKB3M9SOQ8cUvESBER13wMWpQJap3AE2EyRmBEfShpQEnK7fhDG0tR0UThu6
6H7e+/aWqOI46oj445x7T7RktHSicGKrW9Vqklxk8HwXRiWdBzOwdslZPVekoLuO
9m7R63G/4ix2exph2K/iHihnVxs4u5QoBgtd/dZnf/hwQEwtv7xCCIqXb0AVUung
UCZ1eb7wd9TyxVkWspiBDrZ6VYAIOvzG/1owpreDDr/ciTaDjGfrsEOElj3PC2mc
EywN5qaUrZKUX46GbpUGpZQoYhz/KEVcxBBL3H/I934jSvcfqjSDCuPdgAqkCVZm
+JXL9/59PT1UsGIUwbiz3sbkkbXJzT6Uy75swDqVczmIcOxFyVo+gtYKIg9Z+u16
S3ARl1DMVv3D8yPjZjHQCwepvi1RPpjrfmpTCk0zlRWqL8R2g1ZJZSwO1r2kugSZ
NdMydjfGYDfKMCtsPYfidWz+HrXrVFJKP2PN6P31VcN9SRk5b7H1ciY2rR71h/i7
o9PmyEp5T+OEP0RmobrIBlhEQ2w2PQqdWvd+gFZC6Lb3V/GyCTU=
=QvCM
-----END PGP SIGNATURE-----

--7G1bCgHBsRlIyaJSGewJqlmiRjEoYPAtZ--
