Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CE3BC7F47
	for <xfs@oss.sgi.com>; Sun, 15 Feb 2015 19:16:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6C136AC001
	for <xfs@oss.sgi.com>; Sun, 15 Feb 2015 17:16:13 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Ri6HYFpSdO0B3QZ5 for <xfs@oss.sgi.com>;
	Sun, 15 Feb 2015 17:16:10 -0800 (PST)
Date: Mon, 16 Feb 2015 12:16:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 781355c (pnfs block
	layout support)
Message-ID: <20150216011608.GA4251@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5070486664405287599=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: bfields@fieldses.org, sfr@canb.auug.org.au, hch@lst.de


--===============5070486664405287599==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/WwmFnJnmDyWGHa4"
Content-Disposition: inline


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

This update contains the XFS support for the block layout PNFS
server. It turns out that Bruce had included the changes that
Christoph had sent for the NFS header files (thanks, Bruce!), so the
XFS patches can stand alone without needing any other tree merges.

I've tested that it merges cleanly with the current -linus tree and
compiles, and I repeated bruce's basic "get layout" test to see if
it did what it should on a merge tree. I'll leave this to cycle
through a -next tree for a couple of days, and then ask Linus to
pull it.

The new head of the for-next branch is commit:

781355c xfs: recall pNFS layouts on conflicting access

New Commits:

Christoph Hellwig (2):
      [5278511] xfs: implement pNFS export operations
      [781355c] xfs: recall pNFS layouts on conflicting access


Code Diffstat:

 fs/xfs/Makefile     |   1 +
 fs/xfs/xfs_export.c |   6 +
 fs/xfs/xfs_file.c   |  14 ++-
 fs/xfs/xfs_fsops.c  |   6 +
 fs/xfs/xfs_ioctl.c  |   9 +-
 fs/xfs/xfs_iops.c   |  13 ++-
 fs/xfs/xfs_iops.h   |   1 +
 fs/xfs/xfs_mount.h  |  11 ++
 fs/xfs/xfs_pnfs.c   | 322 ++++++++++++++++++++++++++++++++++++++++++++++++=
++++
 fs/xfs/xfs_pnfs.h   |  18 +++
 10 files changed, 393 insertions(+), 8 deletions(-)
 create mode 100644 fs/xfs/xfs_pnfs.c
 create mode 100644 fs/xfs/xfs_pnfs.h
--=20
Dave Chinner
david@fromorbit.com

--/WwmFnJnmDyWGHa4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJU4UTYAAoJEK3oKUf0dfodf1cP/RqDtKvyEastFj9zHCuYgLDU
bg7Q2EKwbY7zn/P6adusJwfJ25GKHO7sYxo68V/esMSRoWXCVeuRAbOk1apbQx9C
X+DsHdHiA2M4nkVB9jekR5a05zjqHU2gVZwdyVZYE4psLCGOkuMluES9pgacH8Fl
xPBgC3mPg8h9L1m29/YqMYUTDXut1nJSo47B4Bioih5iDIHbe910RggkuzRjyPTF
nQY02ZJN0+f1CKBrASmn3WqRdj1+7Q2dZfPoLrsyOBviEnrf7AYK5p+clYw8j1lA
+IRFwxXatfnzHfxri8dTn6E6YwibDSySwoPLE2s7epkZkiOfmO3tTWYhRCWDj7HC
FNJQ+CNjTXrcMgVzx9+bMpQluBWkkV2HpJkOXIaPTuzkKe8MjNWpm4OSl2mZ4Xpe
R+b7lrWcjviejDybca1WzENABax9BbaRCojlK7V8fa7Hd9PZ46uqlbtCeKaV3Dvi
KiddJk68Hx4rRZh6dgARxUNpTOiABz6VAxCfrdAc5t6zowiNMWsTqI7Msm04/G8R
VmVaUVIet3ZEcqMlEhWPmCcAxJ5XxVqPnNy9WRRcsvaCV/vxl3wxahXRzq0YQbAp
9Aux7p6UuWvLGQ3QmnAamXUoPIlGe/5ebKcjwdzfNSaELBj6SVYv7SyRUjzErRpc
oo/oIvwJmknaGcv/TCWI
=CIsQ
-----END PGP SIGNATURE-----

--/WwmFnJnmDyWGHa4--


--===============5070486664405287599==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5070486664405287599==--
