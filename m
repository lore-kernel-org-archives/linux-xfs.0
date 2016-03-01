Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E08267CA0
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 02:03:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A3F54304039
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 00:03:11 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	qi4cdEOwMMVjMzhZ for <xfs@oss.sgi.com>;
	Tue, 01 Mar 2016 00:03:05 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1aafGn-0003Be-Ub
	for xfs@oss.sgi.com; Tue, 01 Mar 2016 19:03:01 +1100
Date: Tue, 1 Mar 2016 19:03:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to fa3a3a8
Message-ID: <20160301080301.GG30721@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3729274162002106173=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============3729274162002106173==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

fa3a3a8 Merge branch 'xfs-dax-fixes-4.6' into for-next

New Commits:

Dave Chinner (5):
      [e889752] xfs: XFS_DIFLAG_DAX is only for regular files or directories
      [db10c69] xfs: S_DAX is only for regular files
      [3a6a854] xfs: dynamically switch modes when XFS_DIFLAG2_DAX is set/c=
leared
      [6448543] xfs: XFS_DIFLAG2_DAX limited by PAGE_SIZE
      [fa3a3a8] Merge branch 'xfs-dax-fixes-4.6' into for-next


Code Diffstat:

 fs/xfs/xfs_ioctl.c | 105 +++++++++++++++++++++++++++++++++++++++++++++++++=
++----
 fs/xfs/xfs_iops.c  |   6 ++--
 2 files changed, 102 insertions(+), 9 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJW1Uy1AAoJEK3oKUf0dfodowQQAI/pkplKTOUWeaLDwyDIxWfx
75NGi9pvnEP1xebJQ6/IeVT3TW/s6QmSbndCKCsgXKBP4FTu1Mvc4Rc92YG3nYLs
ybQSvcCzSQ9kpdUSOhenaW2YwqHY5MrW/qBgfT2e4mYTYPbAOYRZQD5v0Ej50EFk
/h1auxfQlCXmMDSmQbbbwpW2pkuVRLkzKlR1Bkkx4FpGGvM/sseE6vwaG96etAcX
vru1wcurO2f/mswtsXVcWQSZsFXAks/QmPnJzbPPvskdSj91KfyqhZO4AsKqJeJ8
uMEsHBk+hFG77svXKnDfRP+7YajXUf8ak4nhqjPT37NXdi6jOJIOhKdvb7swt5EE
Ah1JSDbM7bAafYk0GGjVFoQPK26LjEDypnuxGfbADe9vlOrsWzPKM62lFkiwRhFk
Nv/xd/2enGnm/V//NX6XSyclLjASvchI5GyThgAvl9JnLYsgXw8Wsg7XAwmkIcy1
Eklm2k+judU4VGJJjp350KIYnn9PQpjv5TaXD1Az7Lme5RvTUz8eSy6QLrdJ0Mnw
vYiFH+LZ+GoK/jGsXTWWPPH8xYU8oRDVKw0lQMY+7HfGaXEyOTlL4KReQLsDOWNH
s2ifeKJfuXWze8kiC9FwyH9HoGvZl+8QvBgX1Xs1dR+9PhwHLLx1EKge7706ZjXS
S5tEr5mR2vqCsYw/gRmb
=RWKd
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--


--===============3729274162002106173==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3729274162002106173==--
