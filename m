Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8C99329DF5
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 23:41:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7795B8F8040
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 21:41:27 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	097Q4qJj4tYW7LyG for <xfs@oss.sgi.com>;
	Tue, 09 Feb 2016 21:41:24 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1aTNWk-0004vn-53
	for xfs@oss.sgi.com; Wed, 10 Feb 2016 16:41:22 +1100
Date: Wed, 10 Feb 2016 16:41:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 63a1962
Message-ID: <20160210054122.GK14668@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3480365205346087174=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============3480365205346087174==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

63a1962 Merge branch 'xfs-buf-macro-cleanup-4.6' into for-next

New Commits:

Dave Chinner (7):
      [b0388bf] xfs: remove XBF_DONE flag wrapper macros
      [1157b32c] xfs: remove XBF_ASYNC flag wrapper macros
      [0cac682] xfs: remove XBF_READ flag wrapper macros
      [b68c082] xfs: remove XBF_WRITE flag wrapper macros
      [5cfd28b] xfs: remove XBF_STALE flag wrapper macros
      [12877da] xfs: remove XFS_BUF_ZEROFLAGS macro
      [63a1962] Merge branch 'xfs-buf-macro-cleanup-4.6' into for-next


Code Diffstat:

 fs/xfs/xfs_buf.c         |  2 +-
 fs/xfs/xfs_buf.h         | 26 +-------------------------
 fs/xfs/xfs_buf_item.c    | 10 +++++-----
 fs/xfs/xfs_inode.c       |  2 +-
 fs/xfs/xfs_log.c         | 20 ++++++++------------
 fs/xfs/xfs_log_recover.c | 10 ++++------
 fs/xfs/xfs_mount.c       |  2 +-
 fs/xfs/xfs_trans_buf.c   | 10 +++++-----
 8 files changed, 26 insertions(+), 56 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWus2BAAoJEK3oKUf0dfodELkQAM2br4Y+pNXX4mWWDfriOT0y
yH4FDDFa25elSvXeo7hni7ievF/z827QUIyXoeSPQIhKF75K8XDlSX779IGB8HE6
ENiMOwhwjT0boPt4L/BOFj6GtBK3f8Gu1Si4ioWB/GVNkTCn20mF8evMUflEAZZv
Tce974CmXQy68EuirzyiElwce8zuayNMb46z27H3+6dS0CmKv94iw9FZoZmvcjtW
+tGWKfy+uDFAf8zjEXukOIVPiT721u8tBuiHDsFlRql6W8dYVbuoZV9j+x4sPaCy
BkvL6BG3L2BV42WUPbcNZTgMTdqnCnVTkmUFzjpFMP0he25HiMjxaEo7T8ysGjwi
Ih3K7xkJhVe62eY7aXGa7szrwbvgeco0cLBaPZfm8WqIPbkAciCgt2ARBQ/CcVl8
rRMRC1qzxrcmChNtmFuQRhlLgrvy07OcR2qw0zLnXg7ckt0vyZMoHibKlwB38NsK
trTypL4U5405Vw+g/utsnG4rRIFeCiajCXCU/EhadwNtJ+LV1CgpIVBbDlu1opGn
8CaygQ2jhbIGk3LrW0IrtziduTcrco9O3C3saHv1u5L6FZkWj39j/3e4c63Mkq+G
wBYoFkOcQUPtAy9Eu5BtFMRyDl1R9gDXOnKVHJWubQ2QeHdh6yr0OkogHCiwKdx9
qPhn8NTYvyuJCZSVCz6l
=BYFL
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--


--===============3480365205346087174==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3480365205346087174==--
