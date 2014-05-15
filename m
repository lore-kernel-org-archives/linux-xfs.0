Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 801B57F3F
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 21:38:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 57CE3304048
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 19:38:48 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	bjHrLmQZFUW1LvnK for <xfs@oss.sgi.com>;
	Wed, 14 May 2014 19:38:41 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1WklYY-0006oj-PH
	for xfs@oss.sgi.com; Thu, 15 May 2014 12:38:02 +1000
Date: Thu, 15 May 2014 12:38:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfstests: master branch updated to 9b7f704
Message-ID: <20140515023802.GG5421@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7038208452519788732=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============7038208452519788732==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/WwmFnJnmDyWGHa4"
Content-Disposition: inline


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfstests repository at git://oss.sgi.com/xfs/cmds/xfstests has
just been updated. Patches often get missed, so please check if your
outstanding patches were in this update. If they have not been in
this update, please resubmit them to xfs@oss.sgi.com so they can be
picked up in the next update.

The new head of the master branch is commit:

9b7f704 config: make sure tests check for loop device support

New Commits:

Brian Foster (2):
      [49a4f92] xfs/013: use killall -9 and wait in _cleanup()
      [9b7f704] config: make sure tests check for loop device support

Filipe David Borba Manana (1):
      [fe3fcf2] btrfs: add regression test for send with extrefs

Jeff Layton (1):
      [85a0117] loggen: fix build vs. newer xfsprogs headers


Code Diffstat:

 configure.ac        |   7 ++--
 src/loggen.c        |   7 ++++
 tests/btrfs/050     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++=
++++
 tests/btrfs/050.out |   1 +
 tests/btrfs/group   |   1 +
 tests/shared/298    |   1 +
 tests/xfs/013       |   3 +-
 tests/xfs/206       |   1 +
 tests/xfs/259       |   2 +-
 9 files changed, 127 insertions(+), 5 deletions(-)
 create mode 100755 tests/btrfs/050
 create mode 100644 tests/btrfs/050.out
--=20
Dave Chinner
david@fromorbit.com

--/WwmFnJnmDyWGHa4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdCiKAAoJEK3oKUf0dfod9wsP/idpE6bSK3ci78NUuQoA7Ilq
uV+e98ZHQb8GoPUV6ssPURnHltRR38Wo++6St0z3zXoPEUeh/X9AJ+jf1rHgjcNc
6vlgafWWqkY9Z6Y89KP07qvIo6X4kNQOzRbClfymqStdXb9h8w+Bv0uKG6+81NEm
OmlU/6p8NF963KaM6smuWZVBqEj64j3JSl6USPYqndle1ai3Ja/vXncYErZ9EfOy
7E/+Q/QAeGFmUu7KmF2Cfs2Klq6ELjJ50jtXX4vXzd+LUuBhWzWifQeF445RDhYF
bmc4Q9mf/UgXbUIMX444naJtyghmTu4xvXgxoF5+X6BLObFEiIsj94zFKkxbBjv/
fJd1ylDUhBhJGBW4FkW6ArkM1XVcc2+wDxgw0rNGTrZ6RDJ9/OgrAy1hQhyTQl6m
9Crn9eqx/NAQCk6ZIPvggquCppEovwnB3AOs/77q5aV/uAzLZnWPI3x0vhG0CSrZ
+g9r0VPmBmVHaxsHwpN6eqIofzrWle7YWcYblhLAuLUsbEo65GOkIVK0Q+DNKwBa
m4V8dHJ6LKFwUwIOBKVNaMYZ1Yocyk03CKsVedzvRGKaZvR22JPTF8t4koqoY8dA
5lE+5t+6vJOWRAIkKQ51LxsgmkcHzcptnghleGHUZe2BEMOSjsWAL7HctxdnJwk8
24fUuI35s07vA7I9YlhQ
=8cuJ
-----END PGP SIGNATURE-----

--/WwmFnJnmDyWGHa4--


--===============7038208452519788732==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7038208452519788732==--
