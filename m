Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3A5077F3F
	for <xfs@oss.sgi.com>; Sun, 10 May 2015 19:55:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 11FA48F8035
	for <xfs@oss.sgi.com>; Sun, 10 May 2015 17:55:29 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	QEV2qtMQusahk8KZ for <xfs@oss.sgi.com>;
	Sun, 10 May 2015 17:55:26 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1Yrc0D-00044B-1x
	for xfs@oss.sgi.com; Mon, 11 May 2015 10:55:25 +1000
Date: Mon, 11 May 2015 10:55:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to v3.2.3-rc1
Message-ID: <20150511005524.GE16689@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5280932527795786824=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============5280932527795786824==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Content-Disposition: inline


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
just been updated. This update is the first candidate for a
v3.2.3 release, so please test and report any problems you find.

The new head of the master branch is commit:

c8c0837 xfsprogs: update for 3.2.3-rc1 release

New Commits:

Dave Chinner (3):
      [566ebd5] mkfs: default to CRC enabled filesystems
      [e24ee60] mkfs: inode/block size error messages confusing
      [c8c0837] xfsprogs: update for 3.2.3-rc1 release

Eric Sandeen (1):
      [b7fc3b3] xfs_db: report FINOBT in version output

Jan =C5=A4ul=C3=A1k (1):
      [52b8334] xfsprogs: Removing deprecated _BSD_SOURCE definition.


Code Diffstat:

 VERSION              |  2 +-
 db/sb.c              |  2 ++
 doc/CHANGES          | 28 ++++++++++++++++++++++++++++
 include/builddefs.in |  2 +-
 include/xfs_types.h  |  3 +++
 man/man8/mkfs.xfs.8  |  9 +++++----
 mkfs/xfs_mkfs.c      | 33 +++++++++++++++++++++++----------
 7 files changed, 63 insertions(+), 16 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVT/38AAoJEK3oKUf0dfodBXQQAI9KWZSwqRojE54wEurB6m/K
J9w4bYp6bLerMBbpSrrLQ9anbDhIcn9vCDS0hYPjPZWo/4LTqzPkwiG1dZ36qP7i
r4/vbuGogq245oHOziAQoTaRMUWv1xApZHWJHKVHWgtdxY6j4uerKN6IJ+0XA+BZ
ZM7HYgcE9B4Wuk5fg7YkMYRKOG4zaRnK0pWVEwEIJtbmNAnXwyso7dpRDnfUEma+
kSCDHUisinNhX/OflIWrse/s5EyDVdoFW21JihRE/pB0+43e1zdtYuQYQtgLpmyh
/kzqH3+AJpoBaCdwBPRxIDVpY073Mnsnf6lRgWEhfSq5DU+tHFGnqLNqol9sdvfB
2bAglswPOCtkFJE2P5uY/Rciac+1vwa0pz2EhfYjNcbKRvGpB3PKHeYZB8nWBBQM
mniAKlD6CUH1BWvpAt5Bor8VPoBgTKaC6fLBbtj4zmWOdOxuo8vUINqq0A59qb+L
jjxtRVRwrgIJmaUrC05DDCGjHmMDb0ZFM1CDrgPLApF+I8GsHjtdZaSRMe2Oz9hd
fpbHmqpO/hTk2wnBIVTHgbb2U9GJJ/B2hwekfVyrjvgiSAPYDinZm32QgiCuWpDR
Gnn11HllUFqTdHT+Yw7Ae0E+V5mYnN+nMtZ5RZA0/CkX5YRjk6GxwisPE/DBR3oq
5RvrJxuxWu44jhdGdQBu
=SZOp
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--


--===============5280932527795786824==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5280932527795786824==--
