Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56562 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936073AbeFOCZJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jun 2018 22:25:09 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E745C452087
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jun 2018 21:24:42 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs mkfs-config branch updated to 32dc4b5
Message-ID: <98f840e7-f892-1651-2ffc-ae3f7259b8c7@sandeen.net>
Date: Thu, 14 Jun 2018 21:25:07 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="t86idF9lhQZc2lQ2VUkv5Pnv5AAhPxJk0"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--t86idF9lhQZc2lQ2VUkv5Pnv5AAhPxJk0
Content-Type: multipart/mixed; boundary="UgABl1PXcoepQ20n05BlDsOwaL1yfIFl6";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <98f840e7-f892-1651-2ffc-ae3f7259b8c7@sandeen.net>
Subject: [ANNOUNCE] xfsprogs mkfs-config branch updated to 32dc4b5

--UgABl1PXcoepQ20n05BlDsOwaL1yfIFl6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The mkfs-config branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the mkfs-config branch is commit:

32dc4b5 mkfs: add -c option to the --help screen

New Commits:

Darrick J. Wong (1):
      [32dc4b5] mkfs: add -c option to the --help screen

Eric Sandeen (3):
      [df8584d] mkfs: initialize return value of parse_config_stream to s=
uccess
      [5058161] mkfs: remove notion of config "type"
      [76a2003] mkfs: manpage fixups in config file section


Code Diffstat:

 man/man8/mkfs.xfs.8.in | 56 ++++++++++++++++++++++++++++----------------=
------
 mkfs/config.c          | 22 ++++++++------------
 mkfs/config.h          | 31 ----------------------------
 mkfs/xfs_mkfs.c        |  9 ++++----
 4 files changed, 45 insertions(+), 73 deletions(-)


--UgABl1PXcoepQ20n05BlDsOwaL1yfIFl6--

--t86idF9lhQZc2lQ2VUkv5Pnv5AAhPxJk0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlsjI4QACgkQIK4WkuE9
3uBBaw/9HmhWW6ze0YanVZpAifIEK7Py3coy3e1KW8zJcv/eA3iqWl1RN4YJ+NAM
lA0rtSkm7TLVHCKV5QeJDpzKUpu70gd9/MX8htqylMMvMeWeShbUXTtTb2R9+DHE
PAuXqLjZkPjfRXN79RtcNFkRpHm5xpawNpw6oBPOp/gLRIfR/NAXsh+kI5+F60sj
5BcbOiYS+wFjhTaVQ3WES1W9b+6TeXpLL9o3NRDAlozSJktqDxWDCU+wHhjb6435
0Nqxfbn7Tdu/q9qHIOwEB+2lYnCw3JYhqwjpKWqpoRjYL9hOXfnFnoQjUIpzzUps
j4t2bSDkvbT7ssc7M3awTfaKJmddmJhbpX/VqfrvFTSc2jZsihi9FewUJqrosNc4
HMmnrG8vxURvJH6ZP9Iycc20iMOpbpanj6KeafGKAXc1nltkeC2aSeM5vcd3CHlp
IIywu0SPUCCAymu3+KvWgv8vQliGWlMSkps6uOdgMShYW+3S6FIoIYf7VOfIYhA2
R6jFuKof85E+61znCpV+PIMduJzuPaMDrTiLduuCCKvhjWrEcR1h7IizVWqqD2XZ
annCvK2kT5RlMBu9G2VOpzR+grBxTzPac/mL7IkGlxmWKk9UoiV+G1Xv2/oL98yx
cyuPfgJhn75aVVqu+xQLU7buxZbb+MtHy6IG44Bf6kF35ybrFa8=
=h7lq
-----END PGP SIGNATURE-----

--t86idF9lhQZc2lQ2VUkv5Pnv5AAhPxJk0--
