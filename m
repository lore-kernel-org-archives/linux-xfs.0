Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 261FC7CA0
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2016 16:02:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D9811304048
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2016 14:02:16 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	5My07qy0pIrEZyI3 for <xfs@oss.sgi.com>;
	Tue, 30 Aug 2016 14:02:13 -0700 (PDT)
Date: Wed, 31 Aug 2016 07:01:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to ea78d80
Message-ID: <20160830210134.GV19025@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5021302968288948554=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-xfs@vger.kernel.org


--===============5021302968288948554==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Uu2n37VG4rOBDVuR"
Content-Disposition: inline


--Uu2n37VG4rOBDVuR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated with another regression fix.

-Dave.

The new head of the for-next branch is commit:

ea78d80 xfs: track log done items directly in the deferred pending work item

New Commits:

Darrick J. Wong (1):
      [ea78d80] xfs: track log done items directly in the deferred pending =
work item


Code Diffstat:

 fs/xfs/libxfs/xfs_defer.c | 17 ++++-------------
 fs/xfs/libxfs/xfs_defer.h |  2 +-
 fs/xfs/xfs_trace.h        |  2 +-
 3 files changed, 6 insertions(+), 15 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--Uu2n37VG4rOBDVuR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXxfQtAAoJEK3oKUf0dfodh7QQAIlpUa1n169KB6V95G90x1ek
jIhBkWme6WrLM5adbV9Ip8cXI+V7UHdkF7HDXYBsproNC9oCqiCzWJTQ2r3vzuhN
aQJET9jaD72k3N5l+LtdKKc1G3Re2q1FuBysVMIEh+xkIGCOvF/xcq17eNj/Nwl/
r1UNKAadGuD9WI0ghaRNwfl05bJw9JWgaGNDSPbW2/zy9Nc+npjw1Saf/o+ab9A1
rVq5ML9/Ia21ai7SyldEqJRpZpSSv9xPWzsI2Y5fVg4gdeg5t9arMmzw2LYw3d4B
6+aZjdiJxyPtcBNpfuBDFdlgAxu5WmAlf2Ja8YGeX6eEYLexwBiSccd2ajDa21DI
9EkLqiYM3STmOzNYPG81KjqIalRHMC8D3KH8NLZmn7Gus4fWiqH6gzn1epgEoFye
hfXurazL4smh8rcY9lNjXK6hufjgPB0ENkC2Y1Kp3LslL8mNulO1KhuKeOWkOCTO
Hq0Tsu6fyjL2SKl00nWum9F1E1vpbbsMeL/QxeuzkH26EvFmPAIl1dpIdAYVm16S
LAch6gEp3pEX6kS+WXq90LBa53zDre3xivX0xJiKeDovkv8I2C1DPJQ3jXLc52IH
I+O3FkQrJfoxWXNzF9rcljbbnzDPeSCCT7q0CBlOMA3YpcClLs7ZYHbY4AUEWJKc
6uQ6jp+5o5Jz7IKflfeY
=gO5J
-----END PGP SIGNATURE-----

--Uu2n37VG4rOBDVuR--


--===============5021302968288948554==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5021302968288948554==--
