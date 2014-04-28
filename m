Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F21997F3F
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2014 20:00:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D0A888F806F
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2014 18:00:20 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	zZ0NBqj4HeRWrksM for <xfs@oss.sgi.com>;
	Sun, 27 Apr 2014 18:00:18 -0700 (PDT)
Date: Mon, 28 Apr 2014 11:00:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfstests: master branch updated to ce0aa2b
Message-ID: <20140428010015.GL15995@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8046966459538027536=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org


--===============8046966459538027536==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WBsA/oQW3eTA3LlM"
Content-Disposition: inline


--WBsA/oQW3eTA3LlM
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

ce0aa2b common: Use _require_xfs_io_command() instead of helpers

New Commits:

Dave Chinner (6):
      [31a50c7] generic/204: tweak reserve pool size
      [ca93123] generic: cleanup space after test in TESTDIR
      [9d7807d] xfs: remove dmapi tests from the auto group
      [03227f9] filter: xfs_repair emits new corruption messagse
      [a12a56f] shared/051: remove ACL count subtest
      [a841a6d] generic: introduce new large ACL test

Lukas Czerner (1):
      [ce0aa2b] common: Use _require_xfs_io_command() instead of helpers


Code Diffstat:

 common/attr           |  31 ++++++++++++
 common/defrag         |   2 +-
 common/rc             |  41 ---------------
 common/repair         |   3 ++
 tests/btrfs/026       |   2 +-
 tests/btrfs/027       |   2 +-
 tests/btrfs/028       |   2 +-
 tests/btrfs/047       |   2 +-
 tests/ext4/001        |   2 +-
 tests/ext4/002        |   2 +-
 tests/generic/009     |   2 +-
 tests/generic/012     |   8 +--
 tests/generic/016     |   8 +--
 tests/generic/017     |   4 +-
 tests/generic/021     |   8 +--
 tests/generic/022     |   8 +--
 tests/generic/026     | 132 ++++++++++++++++++++++++++++++++++++++++++++++=
++
 tests/generic/026.out |   9 ++++
 tests/generic/070     |   1 +
 tests/generic/204     |   2 -
 tests/generic/213     |   2 +-
 tests/generic/214     |   2 +-
 tests/generic/223     |   2 +-
 tests/generic/228     |   2 +-
 tests/generic/255     |   6 +--
 tests/generic/256     |   2 +-
 tests/generic/274     |   2 +-
 tests/generic/300     |   4 +-
 tests/generic/311     |   2 +-
 tests/generic/312     |   2 +-
 tests/generic/316     |   4 +-
 tests/generic/group   |   1 +
 tests/shared/051      |  45 -----------------
 tests/shared/051.out  | 135 ----------------------------------------------=
----
 tests/shared/298      |   2 +-
 tests/xfs/252         |   4 +-
 tests/xfs/290         |   2 +-
 tests/xfs/292         |   2 +
 tests/xfs/group       |  50 +++++++++----------
 39 files changed, 249 insertions(+), 293 deletions(-)
 create mode 100644 tests/generic/026
 create mode 100644 tests/generic/026.out
--=20
Dave Chinner
david@fromorbit.com

--WBsA/oQW3eTA3LlM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTXagfAAoJEK3oKUf0dfodi9AP/iWS0robDYMnjkzFaSfYadSa
pQUL0K1j1Pq9lZXLwpVOSHVQp863QWCU6LefPN4u0e8sMVKuqmRgdKNb8aMIGdNr
oxTPPsWIZdoUQCGMUTG3rtre9uATtSJwtJMp43JeSCVzuU3D1D2UHC1MOZvfE3aH
B2JG2qF6j9q5IIxzJbAJqz/miAhOk8YrGYpHxkNNJ/w7OdZMBPxfxkmpub9xzYwo
e3c+okmEcBOkNW6COy008gZcmaBFhmptlNBsu67rXCS9S7K19Nh9gyygTgI3iwbW
9JaBEm8pjd9GzroP/Vbw4SKyOmeYqrztzWCwVXZc2i5SvONau1QcI0i21eHY2DbT
ATsCbAD88ASjr9HhM3ZdG9VjniHOIDPdwkDBk9thc9Aqnj8UPVLIdssKf9LLDPFk
hc0Sb8EucSk2yTILcW6W2FKE5NAz47twkr0xDRU+wc6hlqa4yXqRIcn/u24cwEek
Lti0mZ6jR+Yjou2hdIk+8yO5mNM13ZWJpuDsbPhc0kHqgul9RwmF9Nf/IhCfIXMP
E2yOuA990MBUY7bXFgLs7DWimxGJ/EC4kKSnlH610u6FbjD278FNt79gmR9jTghT
/jRSV4pARvKCGcLl76tPqDgzJSzeBW4SWgduHufUIqIZPbKfncNfDVubBdXQz1cu
OVtkKF8F4zAlVWqAB6DV
=rKnH
-----END PGP SIGNATURE-----

--WBsA/oQW3eTA3LlM--


--===============8046966459538027536==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8046966459538027536==--
