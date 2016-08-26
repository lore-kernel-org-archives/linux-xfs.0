Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 550697CA4
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 01:03:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1DC3C8F8040
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 23:03:55 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	TBrO6deVMv9tHG0A for <xfs@oss.sgi.com>;
	Thu, 25 Aug 2016 22:47:51 -0700 (PDT)
Date: Fri, 26 Aug 2016 15:47:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to b64af2c
Message-ID: <20160826054742.GR22388@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3758047591547275448=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, linux-xfs@vger.kernel.org


--===============3758047591547275448==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
Content-Disposition: inline


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Folks,

The master and for-next branch xfsprogs repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

have just been updated. This update includes various reverse mapping
fixes and new xfs_quota functionality. It also enables xfs_quota to
be used on non-XFS filesystems.

This is the first time the reverse mapping support has appeared in
the master branch - it pulls in all the previous changes staged int
eh for-next branch as well as the commits listed below. If this
settles without serious issues, I'll probably tag it with 4.8-rc1.

-Dave.

The new head of the master branch is commit:

b64af2c xfs_db: add crc manipulation commands

New Commits:

Bill O'Donnell (2):
      [29647c8] xfs_quota: add capabilities for use on non-XFS filesystems
      [b20b6c2] xfs_quota: certain commands must always be available

Darrick J. Wong (7):
      [574b415] xfs: don't perform lookups on zero-height btrees
      [94a22de] xfs: fix some key handling problems in _btree_simple_query_=
range
      [a365498] xfs: simple btree query range should look right if LE looku=
p fails
      [83d4957] libxcmd: fix mount option parsing to find rt/log devices
      [138ce9f] misc: fix Coverity errors
      [e2f6065] misc: fix libxfs api violations
      [2d27377] xfs_repair: fix naming problems in repair/rmap.c

Eric Sandeen (3):
      [74642d8] xfs_metadump: don't warn about unobfuscated log with -o
      [bb92709] xfs_quota: wire up XFS_GETQSTATV
      [b64af2c] xfs_db: add crc manipulation commands


Code Diffstat:

 db/Makefile                  |   2 +-
 db/bmap.c                    |   4 +-
 db/bmroot.c                  |   4 +-
 db/check.c                   |   6 +-
 db/command.c                 |   2 +
 db/crc.c                     | 188 +++++++++++++++++++++++++++++++++++++++=
+++++++
 db/crc.h                     |  21 ++++++
 db/flist.c                   |  35 +++++++++
 db/flist.h                   |   1 +
 db/frag.c                    |   2 +-
 db/fsmap.c                   |  15 ++--
 db/init.c                    |   2 +-
 db/io.c                      |  34 +++++++--
 db/logformat.c               |   2 +-
 db/metadump.c                |  10 ++-
 db/write.h                   |   2 +-
 include/command.h            |   3 +-
 include/path.h               |   1 +
 include/xqm.h                |  32 ++++++++
 io/init.h                    |   2 +-
 io/open.c                    |   2 +-
 libxcmd/help.c               |   3 +-
 libxcmd/paths.c              |  20 +++--
 libxcmd/quit.c               |   3 +-
 libxfs/libxfs_api_defs.h     |  15 ++++
 libxfs/xfs_btree.c           |  14 +++-
 man/man8/xfs_db.8            |  27 +++++--
 man/man8/xfs_quota.8         |   7 ++
 mkfs/maxtrres.c              |   2 +-
 mkfs/xfs_mkfs.c              |  46 ++++++------
 quota/free.c                 |   2 +
 quota/init.c                 |  48 +++++++++++-
 quota/init.h                 |   3 +
 quota/linux.c                |   2 +
 quota/path.c                 |   5 +-
 quota/project.c              |   1 +
 quota/quot.c                 |   1 +
 quota/quota.c                |   2 +
 quota/report.c               |  11 ++-
 quota/state.c                | 121 +++++++++++++++++++++--------
 quota/util.c                 |   1 +
 repair/dinode.c              |  10 +--
 repair/phase4.c              |  12 +--
 repair/phase5.c              |  73 +++++++++---------
 repair/phase6.c              |   6 +-
 repair/prefetch.c            |   4 +-
 repair/rmap.c                | 104 ++++++++++++-------------
 repair/rmap.h                |  26 +++----
 repair/sb.c                  |   2 +-
 repair/scan.c                |   6 +-
 repair/xfs_repair.c          |   4 +-
 tools/find-api-violations.sh |  38 ++++++++++
 52 files changed, 754 insertions(+), 235 deletions(-)
 create mode 100644 db/crc.c
 create mode 100644 db/crc.h
 create mode 100755 tools/find-api-violations.sh
--=20
Dave Chinner
david@fromorbit.com

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXv9f+AAoJEK3oKUf0dfodqIMP/juPmogeb0PUxg0bnbVDoqWh
BUa0lXfXXvf2OoEQl4uuupKlsnRT92lqkV58wkYX36Y4se/lEg/OQoqdxN+lSXN5
wseSHSS2OjQ9oipDvIHLJKnn31fcECQANhJRdLts0+KixOkDPBePwLFnnkuqReng
A9/E8+A2XAgWNS3jQRTYIl2bm62KeQLP6o+12pTIzpxbFSjvr8abOj8ymEtcEg/S
2QRpI6fY4qWJR/KEG1YfcV5j4VYlgjlK62PQvwwrd2gaNSu0B+a5Easvxiwou/DF
kQFHdWQc0z2XL2PkY/hthtSYlWRv8a/9CDf8DI565tKTHDV6wnX9/l6VoYmZ6fqe
HH72oQ/QcmLEQsWPM8VtRSilP5Uc/21y0PdAswm/LbN9cnRFTyHhYlA6wqfWJoby
hsSNM40mU54cYf+Tgqq7y1sH7Vpt14FORuEpYRo/5wx9i8YMTT8vVbCbeDJRGyqQ
MFtJ7yzR1vYSec9kPg0zLPtBXrnDKwtOThO33uJeCFKIMT/MZSGEYzYgslto4Jh7
NaL9D0yLvq2y3GcZXdQHIS6ngU5T60hetU2q9cXdsJl7hHIH9JdcVPkr4mrSC5JI
NuQBCrudurvU5bu2LDHzRf0I1NIPKJX9XKCRbkzzK2OgvRC2G5xqXtHYCkWWRvSX
pvPE6O7a4oIBzqiZurQ3
=TOFf
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--


--===============3758047591547275448==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3758047591547275448==--
