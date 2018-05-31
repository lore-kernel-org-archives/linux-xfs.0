Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47926 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754030AbeEaTQc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 15:16:32 -0400
Received: from [10.0.0.4] (erlite [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2BD30116F9
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 14:16:27 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to a023e1a
Message-ID: <bcd26b6c-0c04-1e6b-424d-c2dc82949ca8@sandeen.net>
Date: Thu, 31 May 2018 14:16:30 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JiEyIs7NGlcBEBaSiZXspEVD0VxzAorz4"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JiEyIs7NGlcBEBaSiZXspEVD0VxzAorz4
Content-Type: multipart/mixed; boundary="uAZGYoquj8RsQB6Dx1f2oL7N3oOJeIQGv";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <bcd26b6c-0c04-1e6b-424d-c2dc82949ca8@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to a023e1a

--uAZGYoquj8RsQB6Dx1f2oL7N3oOJeIQGv
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

I'm still holding out a little hope that we can get the config file
code into the xfsprogs 4.17 release, so if that gels within the next
week or so, I'll do it.

If you have other small bugfixes I've missed now's the time.  Anything
else feature-wise, we'll hold off for xfsprogs 4.18.

Thanks,
-Eric

The new head of the for-next branch is commit:

a023e1a xfs_db: Don't ASSERT on unrecognized metadata

New Commits:

Carlos Maiolino (1):
      [a023e1a] xfs_db: Don't ASSERT on unrecognized metadata

Darrick J. Wong (8):
      [7931f86] xfs_repair: fix integer handling issues
      [c2b571f] xfs_buflock: ignore if buffer already locked
      [ece9fa6] xfs_buflock: record line number of trace where we locked =
the buf
      [184798f] xfs_buflock: record buffer initialization
      [e3f20e6] fsck: fix more bashisms
      [6c05cc5] xfs_scrub: actually check for errors coming from close()
      [7856ed0] xfs_io: fix null pointer deref when complaining about scr=
ub comm
      [87a271c] xfs_db: handle realtime bitmap / summary files as text

Eric Sandeen (2):
      [585acbe] xfs_repair: fix libxfs api violations in quota repair cod=
e
      [14c57d5] mkfs.xfs: if either sunit or swidth is nonzero,  the othe=
r must=20

Goldwyn Rodrigues (1):
      [25b4549] xfs_io: Make copy_range arguments understand *iB values


Code Diffstat:

 db/print.c               |  5 +++--
 db/type.c                | 12 ++++++------
 fsck/xfs_fsck.sh         | 12 +++++-------
 io/copy_file_range.c     | 28 +++++++++++++++-------------
 io/scrub.c               |  3 +--
 libxfs/libxfs_api_defs.h |  4 ++++
 mkfs/xfs_mkfs.c          |  3 ++-
 repair/dinode.c          | 13 +++++++------
 repair/sb.c              |  3 ++-
 scrub/phase1.c           |  6 +++++-
 scrub/phase3.c           | 27 +++++++++++++++++++++++++--
 scrub/phase5.c           |  8 ++++++--
 scrub/phase6.c           | 10 +++++++---
 scrub/vfs.c              |  4 +++-
 tools/xfsbuflock.py      | 22 +++++++++++++++++++---
 15 files changed, 110 insertions(+), 50 deletions(-)


--uAZGYoquj8RsQB6Dx1f2oL7N3oOJeIQGv--

--JiEyIs7NGlcBEBaSiZXspEVD0VxzAorz4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlsQSg8ACgkQIK4WkuE9
3uDIgxAAg/FHDGJwg2Q6f9t/4UzIgKmsXbogK9RF63PW/Ek4CfjX267EeB1aHVbT
PdFP5XHNJiqI25ZdY4jqZvGfj+UayVCeTQXh6WUzJH4U2tAoFk9u8AF97auvdHoa
h96r0cH6jtP12iJ5U9Wki4po15kmOA5KW6PoK0AQNiR53BKpObdydiEbH4aBM23S
3EWHU599zCQ2Z8RGUC+QFyOK1vF3sPumgD+wiuJWvN+Y9X+lN78O6SP4hH/JOrtn
4scdhO1z9eIpl7hHfbYvFBmCBml2xbNvrGvvXkjAUPYZ9BF3hjY2Acg/QP6u8aBK
MV73leZ4pWBI0+1+KfzDCptDlO/4ctpYFIF+g05cA5KH2whMSj1RFmrEaTlZ5WKO
hYjbTr6QMQaOh7QouorMlHSyNJof9PkKHDz4kgTMJvOEQyCURQwaYpcyILNwe5yl
V46gES4p1f8Vyo7PcJ4OTcKOxhO5cdDzuQaxJUEkTSHbAevb1Tn9DswqXYm3LrQH
RZnNCN6DEZQtV8nwGiCesmUQCxzAs1EAo8XTMvpYMCfuBbAy2ZqoD/hfY7u3QEYE
BkDFpjJs2sMqU20bOjdsH+6WdXeP/n1K4r8RVAQQpgVQ8aEtOKFQvA+uv4lHtIJb
37RY0jLNxXc0w3hl/7xgYqqSFcmDbA4lXqOpMuXGDrsZOJ2n2zo=
=hG0r
-----END PGP SIGNATURE-----

--JiEyIs7NGlcBEBaSiZXspEVD0VxzAorz4--
