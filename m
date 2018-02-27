Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45244 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751872AbeB0CSv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Feb 2018 21:18:51 -0500
Received: from Liberator-5.local (erlite [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id F332A116F1
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2018 20:17:55 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v4.15.1 released
Message-ID: <485c7496-92bc-b166-a358-c3db18647411@sandeen.net>
Date: Mon, 26 Feb 2018 20:18:49 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7RsnwTLIjfN7ELmSwh482ly1MXqDkOi5j"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7RsnwTLIjfN7ELmSwh482ly1MXqDkOi5j
Content-Type: multipart/mixed; boundary="bItptON9zw7yjRHVVGH6BOWl5SrSp9pep";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <485c7496-92bc-b166-a358-c3db18647411@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v4.15.1 released

--bItptON9zw7yjRHVVGH6BOWl5SrSp9pep
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged w/ v4.15.1

This is a small delta, only debian build fixes (my fault for missing)
and a polish translation update.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

4bfc773 xfsprogs: Release v4.15.1

New Commits:

Darrick J. Wong (2):
      [638c642] debian: add build-depends on pkg-config
      [37c528c] debian: don't fail postinst when upgrading chroot

Eric Sandeen (1):
      [4bfc773] xfsprogs: Release v4.15.1

Jakub Bogusz (1):
      [4f35436] po/pl.po: update Polish translation for 4.15.0


Code Diffstat:

 VERSION          |    2 +-
 configure.ac     |    2 +-
 debian/changelog |    6 +
 debian/control   |    2 +-
 debian/postinst  |    2 +-
 doc/CHANGES      |    5 +
 po/pl.po         | 4218 +++++++++++++++++++++++++++++++++++-------------=
------
 7 files changed, 2743 insertions(+), 1494 deletions(-)


--bItptON9zw7yjRHVVGH6BOWl5SrSp9pep--

--7RsnwTLIjfN7ELmSwh482ly1MXqDkOi5j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlqUwAkACgkQIK4WkuE9
3uCKug/+PTEMYck0ZkGRz9k6HY/XwCdochnfCA7wx+ZvrDVf5Usq5/SzqP6X26qT
5MwghFLGMT3rsDJYEGNgdhKdi1O7kHJnL4RUovpiwDugrkCLy7MQD00Rp9NUifub
JUEBmvpoCxFL3RGEXAtqb5M7oZLqBevLEzDduQX5SUsYVwPXyjI2IFLDbJKaoomb
2J3uKd+8CrHK+TVSmnSQjcXI034hRZiwXUTLHx+5rdfog45egbid7OSRviJB57gw
585+Cc+1UUm0Q+Xv7f/INArw9unjUVgcZbj9a9kBJAXvMw7WTMOgopTZDJMy9SCE
VmWgwMIasvVOk6JPiUnbZ6p6leNvaSMTsWe35Hugh/BSmRvCFc2F0D69RmPv80ef
/jmYvPEJSso79Pi5kY1obVs5/FFV/SXLaWDVrHJULOd1zGPePvVzN+QyUGt1Hkga
MI8SXJovTIf7Ear0RunwxZapQdqdTpsLG87S6RWaAuCjjd+NbREnuaQSs8dMrDYI
7SZvUv7TpVJbgYVUxbIERVYxBda+sS+aSMDCVhxDcEOGbRu9Y1fEeMmyPn6Ts3Cc
QPzyzhcvzzBVxQQ5u5tumieDOz4lNOHUUaAFT+PhGSPGBEFEEzgP5hfo8Ne4P10y
ItzxrjOguPvhlGkj8sj8X3LKIucL35+KnBGgcvSUm0UiE0OEiwM=
=/dVJ
-----END PGP SIGNATURE-----

--7RsnwTLIjfN7ELmSwh482ly1MXqDkOi5j--
