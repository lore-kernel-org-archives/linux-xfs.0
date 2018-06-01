Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42472 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750736AbeFAAlH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 20:41:07 -0400
Received: from [10.0.0.4] (erlite [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5508715B15
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 19:41:01 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to cb1b013
Message-ID: <0e90131c-27e2-04d7-8c87-8668b6049a22@sandeen.net>
Date: Thu, 31 May 2018 19:41:03 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FjmvYN0z9anSsW1WH3p01hKXfOkJfOFY2"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FjmvYN0z9anSsW1WH3p01hKXfOkJfOFY2
Content-Type: multipart/mixed; boundary="JncrNJb52KUfpYGjt4rPuPseB8dhhYnS1";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <0e90131c-27e2-04d7-8c87-8668b6049a22@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to cb1b013

--JncrNJb52KUfpYGjt4rPuPseB8dhhYnS1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This just updates a Coverity regression, thanks Darrick!

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

cb1b013 xfs_io: fix signed comparison problem in copy_file_range

New Commits:

Darrick J. Wong (1):
      [cb1b013] xfs_io: fix signed comparison problem in copy_file_range


Code Diffstat:

 io/copy_file_range.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


--JncrNJb52KUfpYGjt4rPuPseB8dhhYnS1--

--FjmvYN0z9anSsW1WH3p01hKXfOkJfOFY2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlsQliEACgkQIK4WkuE9
3uCJZg//bdcXJ30BiEkoQz3Fr8tyKPCSm/y0E97Fx7Cvxw4Gffkzq2TiCJWpa5Cg
RQbHwftLv9BdjjMYimTTvEAH98XqD8rxAMriB0bASE9lxT5kstPbyyfkZZ4GszvM
3uC+KKovkUzUhO55FRDw86Ykyn+t727LfhB/2x0pLfbw7N3gy64pLFi/ISvMnJuF
qLYpyjrgYvWZz3wSu1HjTrcXRCejzZJKVJI8b8CQNYWG4xoscDBk7zryIa9ga5hN
8zirqpf2VnfmhXYzgLxhSGdzywbAHd8MnK+deRSzpcE+0PJwvnrTDRtm5LC9kTla
pOa0P3R68w+v2Ea0WT/KVVbQISQDitFldOOT+id1OIKIt/2EIJa2KzOZjvH4fZRE
2RFCQTFxpYaH+hFZ9nIjCc3rDhP980xDY72BuBDaYmqEiJuFFh5gLhF+j6+pl5ge
tDQWcBL51JA9rmtT1pYcenIx55w57zFda5e38pblm2ASbJsbr1YqBdVR47w4hqO/
5GUKk9UH+lEU0UOLU8WLWrolz7yU+pFt8LLThoVNK+YGwus1C50HBDasdoxCVdCZ
hoIOqubTTl0X/MRHqK1DuW/yJiYfi2ZwnHn/eceY/4bxf9QNzIkYvhP9939uOmlE
HkVLQzFuux7EDcAzdsViHEK4hqvD/DYLcGZ7jl/mYoWfUUWViTU=
=WeVr
-----END PGP SIGNATURE-----

--FjmvYN0z9anSsW1WH3p01hKXfOkJfOFY2--
