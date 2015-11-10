Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F26447CBF
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 23:14:21 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 747E6AC005
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 21:14:18 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	qcivuGx5WO6YexbV for <xfs@oss.sgi.com>;
	Mon, 09 Nov 2015 21:14:13 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1Zw1Fj-0007BD-SV
	for xfs@oss.sgi.com; Tue, 10 Nov 2015 16:13:55 +1100
Date: Tue, 10 Nov 2015 16:13:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: v4.3.0-rc2 released
Message-ID: <20151110051355.GD14311@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6582499335178262019=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============6582499335178262019==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
Content-Disposition: inline


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated. This contains the few fixes and cleanups that
were pending from the 4.3.0-rc1 release as well as a couple of new
fixes that have been posted since. Please test, I'm planning on a
4.3.0 release early next week if no problems are reported in the
next few days...

-Dave.

The new head of the master branch is commit:

af37ed4 xfsprogs: Release v4.3.0-rc2

New Commits:

Darrick J. Wong (2):
      [a9b61ce] libxcmd: provide a common function to report command runtim=
es
      [2afac83] io: update reflink/dedupe ioctl definitions

Dave Chinner (2):
      [5cfd2d5] headers: remove definition of ASSERT from xfs.h
      [af37ed4] xfsprogs: Release v4.3.0-rc2

Jan Tulak (1):
      [7141fc5] xfsprogs: make fsr use mntinfo when there is no mntent

Ville Skytt=E4 (2):
      [2e53a4f] xfs_db.8: Remove stray backslash near bmap
      [6222418] mkfs.xfs.8: Spelling fix


Code Diffstat:

 VERSION                    |   2 +-
 configure.ac               |   2 +-
 doc/CHANGES                |   8 ++
 fsr/Makefile               |   8 ++
 fsr/xfs_fsr.c              | 113 ++++++++++--------
 include/command.h          |   6 +
 include/darwin.h           |  62 ++++++++++
 include/freebsd.h          |  29 +++++
 include/gnukfreebsd.h      |  28 +++++
 include/irix.h             |  29 +++++
 include/linux.h            |  28 +++++
 include/platform_defs.h.in |   6 +
 include/xfs.h              |   6 -
 io/Makefile                |   2 +-
 io/dedupe.c                | 190 -----------------------------
 io/init.c                  |   1 -
 io/io.h                    |   1 -
 io/pread.c                 |  16 +--
 io/pwrite.c                |  17 +--
 io/reflink.c               | 289 ++++++++++++++++++++++++++++++++++-------=
----
 io/sendfile.c              |  16 +--
 libxcmd/command.c          |  27 +++++
 libxfs/xfs_fs.h            |  25 ++--
 man/man8/mkfs.xfs.8        |   2 +-
 man/man8/xfs_db.8          |   2 +-
 man/man8/xfs_io.8          |  29 ++---
 26 files changed, 544 insertions(+), 400 deletions(-)
 delete mode 100644 io/dedupe.c
--=20
Dave Chinner
david@fromorbit.com

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWQX0TAAoJEK3oKUf0dfodZiUQAL0kSok4voiuiE1YEqGDIYUC
5TApAKGHXoHNlHEwr9pEPVM/seVsM8kZH69nKt/Y2tOkDSbmfq3crfLJM2hnuc3Z
f7kpqBg+Nj31l2+mIKNJHw6cvo4bqE/xHS31d6dbUyPPm4qVxTx3EicXZOs6aHVA
jWBXKjwVFpGrSQ8vJcI7+98SF/O8QV+csER10tHgk0P8qX+C99q9SGxeaxl2nwju
RhQ2Db9s/JJ/EPJnRRaozkRAMGBxqhi/m9eE+fFtGhz4Ea0Nk7aiEPRu9RE75qYw
UMEsFylHwwZIrYsVO+lel1aIl4aoashEy+W190MWS0KQqht9W0WYkmMBokvCpS8V
2U8OnsNrGH/MIuEROlpwbs+ovhRJxDQ3mtlk8xIrv42kJpHiEaK2PzxlChw2WCji
2v+VYgipDkn7XxIWaWndF5C8A/ozLGOn1h6VfA+vvl37Ao7ofMl0bvMVVPTZ+v8t
5U9NjLzaQaFJZQRoeXW0S4Z1NvzBe0UH8XlzO/YWkTkdrBfaLMHqpFx5ZxsVBw/h
taygi2eyvKzdyV4/Mz0aDZAAZIrqQR7gtuoo7fmCE20gePveyFh7GUG5YCAvQxKv
M6igJUcrl/SlGHi+x6Ne4EU+Evdtd0fEI3MW6w/pOdqli/qig61v65ewwguzh6Hn
3Y1cabbfapxfCb7p6gwu
=pfQn
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--


--===============6582499335178262019==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6582499335178262019==--
