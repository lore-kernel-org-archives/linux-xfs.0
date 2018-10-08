Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:12829 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726540AbeJIG3M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Oct 2018 02:29:12 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1g9ejw-0000HL-62
        for linux-xfs@vger.kernel.org; Tue, 09 Oct 2018 10:15:04 +1100
Date: Tue, 9 Oct 2018 10:15:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to b39989009bdb
Message-ID: <20181008231504.GE6311@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs-linux repository at:

        git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated. This is an update with a bunch of important
reflink fixes intended for 4.19-rc7, so please update and test this
so I can send a pull request to greg before the end of the week.

-Dave.

The following changes since commit e55ec4ddbef9897199c307dfb23167e3801fdaf5:

  xfs: fix error handling in xfs_bmap_extents_to_btree (2018-10-01 08:11:07=
 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux for-next

for you to fetch changes up to b39989009bdb84992915c9869f58094ed5becf10:

  xfs: fix data corruption w/ unaligned reflink ranges (2018-10-06 11:44:39=
 +1000)

----------------------------------------------------------------
Darrick J. Wong (3):
      xfs: refactor clonerange preparation into a separate helper
      xfs: zero posteof blocks when cloning above eof
      xfs: update ctime and remove suid before cloning files

Dave Chinner (2):
      xfs: fix data corruption w/ unaligned dedupe ranges
      xfs: fix data corruption w/ unaligned reflink ranges

 fs/xfs/xfs_reflink.c | 200 ++++++++++++++++++++++++++++++++++++++++++-----=
----
 1 file changed, 165 insertions(+), 35 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbu+T3AAoJEK3oKUf0dfodYvcP/1Mk9fkhA+5TLSrrQGUpl8AO
kioIRKp4UBFll71QoWNhPj28Hxjs6oIZ+HbIOlKbDXJ0Zo26hioN0qLUo7rKdMgy
hdr005Fi5GFx5mXdteECzn8BOUgaLM75j5lN4N6J2/k57QNENHw9IleVcjS/b8I4
jiYj91OGNrx+1KQ+0wevsHZYf+mnc1DNycbBAgTb8gknsNlCZ5eMauFeXJM0cvKC
vH6Yzni2bpQUlqMp05SIucBGo569TU2jEdv07LDyvRRaRCNyKQz7BkU6HUCCmiu8
nk1P0/6iD0AykJ/NtGOMVmX6Es0t3WnhzAXB8u3KXqoBeYNglr2Ft79Fn4G3+6Ig
qmsHtLLoPZQwgf179BVXFKoT6J2nUUf7/vzjPkSoJJw1IQVMzc8kKryFy6vVm9rY
fD78jnIpacM1cpiU7Wlt8uaS1igHPgonY5x1AxK3Zt+qE1wEKqgVtsBDq7i114o4
+VUyUO3OMLab3eHNFgK8uWvd7Hvegg6Sp+SWWiJbTMUzWc70jxsAZlKPLIW0u34T
QBDNs3pO5NIsaZM0IWyb/Vc+6gw101S05kq0LqrRfSdpir7tqVHvk9Tvb1y57WtA
Brg1hvRTZAPwBDm2rDPG6r2H7uDOw6wJLbQe0DZaoZiobj9EYnfXMegLis71831K
LKoOBYl/Q1WFkWx7KwPa
=3Ebg
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
