Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AD4557F4E
	for <xfs@oss.sgi.com>; Mon, 26 May 2014 21:45:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4A931AC002
	for <xfs@oss.sgi.com>; Mon, 26 May 2014 19:45:43 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	r4JbA77t1RZYSQWV for <xfs@oss.sgi.com>;
	Mon, 26 May 2014 19:45:41 -0700 (PDT)
Date: Tue, 27 May 2014 12:44:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfstests: master branch updated to 45d1fac
Message-ID: <20140527024437.GC8554@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0334533643021868879=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: fstests@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com


--===============0334533643021868879==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AkbCVLjbJ9qUtAXD"
Content-Disposition: inline


--AkbCVLjbJ9qUtAXD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfstests repository at git://oss.sgi.com/xfs/cmds/xfstests has
just been updated. Patches often get missed, so please check if your
outstanding patches were in this update. If they have not been in
this update, please resubmit them to fstests@vger.kernel.org so they
can be picked up in the next update.

I've sent this announcement to fstests, linux-fsdevel and the XFS,
ext4 and btrfs lists. Future fstests announcements will only be
directed to the fstests and linux-fsdevel lists.

The new head of the master branch is commit:

45d1fac btrfs: test for btrfs send when nested subvols/snapshots exist

New Commits:

Eryu Guan (2):
      [82afae2] generic: new ENOSPC regression test
      [caca581] xfs/005: filter _scratch_mount output to match golden image

Filipe David Borba Manana (5):
      [e7dd9f1] btrfs: add test for btrfs send with long paths
      [86da66c] common: add helper require function _require_btrfs_cloner
      [d140277] btrfs: add test for clone operation
      [3318629] btrfs: add test for btrfs send with large xattrs
      [45d1fac] btrfs: test for btrfs send when nested subvols/snapshots ex=
ist


Code Diffstat:

 common/rc             |   7 +
 tests/btrfs/035       |   4 +-
 tests/btrfs/051       |  85 +++++++++
 tests/btrfs/051.out   |   1 +
 tests/btrfs/052       | 171 +++++++++++++++++
 tests/btrfs/052.out   | 499 ++++++++++++++++++++++++++++++++++++++++++++++=
++++
 tests/btrfs/053       | 109 +++++++++++
 tests/btrfs/053.out   |   1 +
 tests/btrfs/054       | 109 +++++++++++
 tests/btrfs/054.out   |   1 +
 tests/btrfs/group     |   4 +
 tests/generic/027     | 107 +++++++++++
 tests/generic/027.out |   2 +
 tests/generic/group   |   1 +
 tests/xfs/005         |   7 +-
 15 files changed, 1104 insertions(+), 4 deletions(-)
 create mode 100755 tests/btrfs/051
 create mode 100644 tests/btrfs/051.out
 create mode 100755 tests/btrfs/052
 create mode 100644 tests/btrfs/052.out
 create mode 100755 tests/btrfs/053
 create mode 100644 tests/btrfs/053.out
 create mode 100755 tests/btrfs/054
 create mode 100644 tests/btrfs/054.out
 create mode 100755 tests/generic/027
 create mode 100644 tests/generic/027.out
--=20
Dave Chinner
david@fromorbit.com

--AkbCVLjbJ9qUtAXD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTg/wUAAoJEK3oKUf0dfodUUgP/2Q2n/WpbhrwHtWRQkQgsQMO
LNvYOMACzn9ayFqVZ0AZW+CmTprEim8tPSmO6F2Zfg8bHbJxl6dS1IU2Ff/ksT8b
y52HNh4Co9rX6+0d9aat7+YmP1X8ZBbSc0uIbWeeGuWpZ1BPSiCCS///Th342qNm
tg+cIhavASweeU/cXTk8711sTyfS2GZkrfOW6cPru96vlwg/g61nqLI7seLdfN5F
qXY825WbQ1azI473JnvTXJ7aHY7iTO+O7lX2oMhRnHDhWVpaRmZLAKL1r398sAXV
5hTUEw79KrfRlsFN371nK2eMzdHJ4XcUwtAOtz0g8CXhGEGEkP9CDPjXghHnBs3J
mS3/uxQcm6BwD0iYJheW0r5kBHmIs0Rm36QrHVSSKPX/zekKYm2zjhxdUNXXWgIA
FLAhhFijMv9Dz11xfV5EZmK1musjovBchtP8MX+ObUudVeiWmplhkkISVFH9DE0X
2GqOxYCHMSuj1UuFe2/9vtZn22tBR/O09VRhLCB2iTYz0dgeaz4FJcil6lbrOROV
ADlqbzX83B8jOJBEfCGw/anKCL4pIhe67NBxuj5Kl3o77GubXS6JN91E1VhXduR8
AyzpB0QWkq/ymFMc+nKn+8rxA85SiFldaigRX7Y3X/Ob62xbpDzCN75KTpMzgFuA
rWbLcEnPvkB+7C8Tslm8
=yWMA
-----END PGP SIGNATURE-----

--AkbCVLjbJ9qUtAXD--


--===============0334533643021868879==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0334533643021868879==--
