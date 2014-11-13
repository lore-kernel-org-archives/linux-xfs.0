Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 32AE77F37
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 01:00:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1DCC88F8033
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 23:00:09 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	JFvMRgaPH9CECpJm for <xfs@oss.sgi.com>;
	Wed, 12 Nov 2014 23:00:08 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1XooNx-00058N-HN
	for xfs@oss.sgi.com; Thu, 13 Nov 2014 18:00:05 +1100
Date: Thu, 13 Nov 2014 18:00:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to 263b537
Message-ID: <20141113070005.GD23575@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7158421198318831961=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============7158421198318831961==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Content-Disposition: inline


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
just been updated.

The new head of the master branch is commit:

263b537 xfs_copy: simplify first_agbno calculation

New Commits:

Eric Sandeen (1):
      [263b537] xfs_copy: simplify first_agbno calculation

Nathan Scott (3):
      [3775434] packaging: rework dh_autoreconf invocation for deb builds
      [12a995c] packaging: clarify xfs header licensing within deb builds
      [b83be57] packaging: update deb changelog for upcoming release


Code Diffstat:

 copy/xfs_copy.c  | 20 +++-----------------
 debian/changelog |  8 ++++++++
 debian/control   |  2 +-
 debian/copyright |  4 ++--
 debian/rules     |  4 ++--
 5 files changed, 16 insertions(+), 22 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUZFb0AAoJEK3oKUf0dfoduKMP/iFUysSjscAlyeuPpGfmF//K
S0t2UdvJtf0WM8VUdZrdTX6FIyUGZ6i9VKMzt6gJom24oMoE1DNTzlIEYw+QAd0r
h1u9Flelirdte8PI65I/L0WkjR5sI2Nm7hVCk44HNaPhHVZkXYCivys3cLSG1+jM
D2eYN8jaMem2WQP9K5PKUgmMGy99lGXdZRj99+xez70+iE1VlAxqOAwffmpdLfyI
h5Ge33jFN/ywUZFlZW/t3In1UziBQe1Y9ulz5rFAG5c7kwcSJ/wt/BhS0H2xf5cR
wUQxXaWK4OBOaMiqtPE4UO/tL5Qb2zfjzn5/T0lbWgTiMUtndN8DPuBeocBCJHf7
Cn848FSkxvZ5JtotjM0thMxt7Lsjt9BQXkGWkwP3dhbYuxYnsLfLKPuSrFZu8uKo
/mEUScjoIw99keRH3O5/zdXL/M9WnUBEdxSNjNyjQ38PSY8yaGs1nULrFBsEsIQV
ORw6Xou+u6QvnisKtZI8eRtgzn+aMiHBiM9bDfD8CAHdSTAD+KRijwm1J2rLQsjp
5TvwHUL7YQiPYWn4JzullT0NrZQX7Lmn4nUfwGyLbpocSOsxCquAAEzYUYn5JjZP
MC+kwIDc2zAoq8NOyzwIVhLOPEEnvpQUPeooWBfmbw+eBLLfRePoXPs24N9lMG8W
Zl4xSVuPCnzY8brfn8wC
=fukd
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--


--===============7158421198318831961==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7158421198318831961==--
