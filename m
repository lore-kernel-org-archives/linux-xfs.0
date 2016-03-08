Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 02B0F29E05
	for <xfs@oss.sgi.com>; Tue,  8 Mar 2016 15:28:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6E461AC004
	for <xfs@oss.sgi.com>; Tue,  8 Mar 2016 13:28:53 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	tmrBGHAJl1FWMR8C for <xfs@oss.sgi.com>;
	Tue, 08 Mar 2016 13:28:49 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1adPBP-0006Hk-D6
	for xfs@oss.sgi.com; Wed, 09 Mar 2016 08:28:47 +1100
Date: Wed, 9 Mar 2016 08:28:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to ab9d1e4
Message-ID: <20160308212847.GW30721@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8177607362893924854=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============8177607362893924854==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u65IjBhB3TIa72Vp"
Content-Disposition: inline


--u65IjBhB3TIa72Vp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

ab9d1e4 Merge branch 'xfs-misc-fixes-4.6-3' into for-next

New Commits:

Darrick J. Wong (3):
      [49ca911] xfs: fix computation of inode btree maxlevels
      [5110cd8] xfs: use named array initializers for log item dumping
      [30cbc59] xfs: check sizes of XFS on-disk structures at compile time

Dave Chinner (2):
      [a798011] xfs: reinitialise per-AG structures if geometry changes dur=
ing recovery
      [ab9d1e4] Merge branch 'xfs-misc-fixes-4.6-3' into for-next

Luis de Bethencourt (1):
      [a5fd276] xfs: remove impossible condition


Code Diffstat:

 fs/xfs/libxfs/xfs_bmap.c   |   5 +-
 fs/xfs/libxfs/xfs_ialloc.c |   4 +-
 fs/xfs/xfs_log.c           | 132 ++++++++++++++++++++++++-----------------=
------
 fs/xfs/xfs_log_recover.c   |  22 ++++----
 fs/xfs/xfs_ondisk.h        | 117 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_super.c         |   3 ++
 6 files changed, 204 insertions(+), 79 deletions(-)
 create mode 100644 fs/xfs/xfs_ondisk.h
--=20
Dave Chinner
david@fromorbit.com

--u65IjBhB3TIa72Vp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJW30QOAAoJEK3oKUf0dfod5D0QAJzURbu6zN/k5MgCUNeVD8CV
OXuKsmxq06FvPM7KEqS/snOfmmGX0TfwAiwe8wPwPaxwlFhAnYy+bVJKJ7B13oKb
dEX7D47xrjxwfbXeJwmaKWETYeQ5Xf/4SAiqyDsvCGb9k3KboPnnboO8oEqk6CX9
XJH8BM/jOdAXZ+SdsYS+wIQM8xJjxSJ4PxKyaVfeGgKpaGcpz/NiUuLqRF++ZoUZ
cPwMZbgpuA/QxCb6tjCc9JOWmfFJYls73vaYqyaByaSLiv6qbZq9KOKjjYcNgilE
oLdnwkyGANzXEuo4OX5rXgTbtpX+xPFTqAXJaLCfgMjgTYF2/XDdqw67eP+pCfBi
l7hMk47d0GPdb/Rg2WTQWK5iL6pxt705e/jY18988b+RLCBtBtvZTdQoPupZQ1f8
qYTCrtl3kwGzEPgb6sWZV2sIfK9IyL4YZ3bNJL/tSFOPEwRwfWc+hYpPPktJpZYA
eonbRXwjb8C1mplRsu9096V0e9J7km3S/HuRYrswI2CF7O3e5j/CKXudjCY1PlR0
KQ64UDtXQ77n7/aS/InugjOKMrUkjwXbhyL2fgARo/BGpxFvmod+TFUHyEBkm74I
H2/+XbcNea4wTBbywcUbYfv2hbaM7+lwS3F47X8LcIbgtu7YD724ds92as7ZFMyQ
ZUXn37M0cBDT3X1hIXJY
=rsfB
-----END PGP SIGNATURE-----

--u65IjBhB3TIa72Vp--


--===============8177607362893924854==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8177607362893924854==--
