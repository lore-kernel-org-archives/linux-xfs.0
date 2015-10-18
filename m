Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C50497F55
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2015 18:24:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A1DD98F8033
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2015 16:24:24 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	YTaAGbPoLe8GbvgH for <xfs@oss.sgi.com>;
	Sun, 18 Oct 2015 16:24:22 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1ZnxIl-00081u-E8
	for xfs@oss.sgi.com; Mon, 19 Oct 2015 10:23:43 +1100
Date: Mon, 19 Oct 2015 10:23:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to fcd8a39
Message-ID: <20151018232343.GB27164@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0665079396293358561=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============0665079396293358561==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sHrvAb52M6C8blB9"
Content-Disposition: inline


--sHrvAb52M6C8blB9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

fcd8a39 Merge branch 'xfs-stats-fixes' into for-next

New Commits:

Dan Carpenter (1):
      [f9d460b] xfs: fix an error code in xfs_fs_fill_super()

Dave Chinner (2):
      [985ef4d] xfs: stats are no longer dependent on CONFIG_PROC_FS
      [fcd8a39] Merge branch 'xfs-stats-fixes' into for-next


Code Diffstat:

 fs/xfs/Makefile    | 2 +-
 fs/xfs/xfs_stats.c | 2 ++
 fs/xfs/xfs_super.c | 2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--sHrvAb52M6C8blB9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWJCn+AAoJEK3oKUf0dfodmsAQALo9bwJL3wmCnE6NU8xI3Get
levf9wTTgP5m/Pk88gTSO5XmybUHCh38uhOpalTcap8t6xcN9CsWvGcBvXTRn5Yx
uBl0qE4hkjUGJQr7tSPkTDKidmFN+tJM+wgp8Q8zkoXeVYCZZVpsagf0nqpPnWMV
PFbKRXQZujyUYDhGwKw0HuSou5nPxUf+2cqiUUxXBFFppEtF+BVMQg0XgDD5gey8
SugzGYL3gjdjYIiMV6jpVoRxfE01VjUXeFDaUdC+g2pPDh6mdBBACbrNRZoVvvJI
LipB2D/UWiFPMDs/UyvhC4exuWUqsYi4jIebfL1Fir0LGsQK4AP6H0jZrHLX6zTt
c5RyXQK4SW5ePHcu98Xw4qbsZ3jtnnC4HNRuHTHkEng/+8mUa+eH5QNmsZbiDfMp
GtUlfLe66AzUBVCIZuwz5+L+xUjte1Vvahv/QRnxGY6lODm8mrDD0CckZ4wOwmQr
mztY40Bafp/VD+3PCVmAsiGvceO6j7omJP2ii742nsS/GIKPTtTOs18CF+IfWAs9
RVIMPdozPeF7VAGDyfSvCJ27bBOtoCpbiKQlz8RRkx28G2V0MFLTVLAWhluHpytx
weOYXyDKWAG+NfsLyN7CipAHrJhgzBPucS61wqr4+ToPJ+cLZq0/YaGQdhGuZJp7
tlvF6bXxPiJ2rl//o4fE
=V8dt
-----END PGP SIGNATURE-----

--sHrvAb52M6C8blB9--


--===============0665079396293358561==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0665079396293358561==--
