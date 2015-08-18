Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 980487F5D
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 17:04:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 25A03AC008
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 15:04:37 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	UcXHKDnhudo9XqMZ for <xfs@oss.sgi.com>;
	Tue, 18 Aug 2015 15:04:31 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1ZRozd-0004qF-7c
	for xfs@oss.sgi.com; Wed, 19 Aug 2015 08:04:29 +1000
Date: Wed, 19 Aug 2015 08:04:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANOUNCE] xfsprogs: v4.2.0-rc2 released
Message-ID: <20150818220429.GM714@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5403363617915320976=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============5403363617915320976==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EuxKj2iCbKjpUGkD"
Content-Disposition: inline


--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repositories at:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
git://oss.sgi.com/xfs/cmds/xfsprogs

have just been updated to v4.2.0-rc2.

Changes since 4.2.0-rc1 are mainly bug fixes, OS X build fixes and
mkfs.xfs now defaults to enabling the ftype field in the directory
structure for all filesystem types.

There are still some pending fixes before a 4.2.0 release will be
made; Darrick has found a bunch of error sign issues that he has
patches pending for, as well as a couple of xfs_db and xfs_repair
fixes for problems he found via fuzzing. There are still also a few
outstanding OS X build changes that need to be finalised before
release. Hopefully these will all be finalised in the next couple of
days.

Anyway, go forth and test!

-Dave.

The new head of the master branch is commit:

60feae1 xfsprogs: Release v4.2.0-rc2

New Commits:

Brian Foster (1):
      [237cb37] libxfs: remove sparse inode mount warning

Dave Chinner (2):
      [9a35e0d] db: fix uninitialised variable warnings
      [60feae1] xfsprogs: Release v4.2.0-rc2

Eric Sandeen (2):
      [98166c9] xfs_fsr: Fix parentheses around truth value
      [b990de8] mkfs.xfs: fix ftype-vs-crc option combination testing

Eryu Guan (1):
      [255132a] xfsprogs: fix syntax error in include/buildmacros

Jan Kara (1):
      [28c1c27] libxfs: Fix attr leaf block definition

Jan Tulak (9):
      [54ca4ea] xfsprogs: undefined variable fix
      [19863f7] xfsprogs: Add ifdef dirent checks where it was missing
      [3f25732] xfsprogs: Add includes required for OS X builds
      [ff6f019] xfsprogs: missing and dummy calls for OS X support
      [bfbb770] xfsprogs: prevent LIST_ macros conflicts
      [96f2cfb] build: Change OS X-specific CFLAGS/LDFLAGS
      [5ae294e] build:: Add mntent.h check into autoconf
      [5121281] build: Add fls check into autoconf
      [6f9377f] doc: Update OS X build info and limitations

Roger Willcocks (1):
      [307ae95] libxfs: v3 inodes are only valid on crc-enabled filesystems


Code Diffstat:

 VERSION                |   2 +-
 configure.ac           |   4 +-
 db/check.c             |   2 +-
 db/convert.c           |   2 +-
 doc/CHANGES            |  10 ++++
 doc/INSTALL            |  11 +++-
 fsr/xfs_fsr.c          |  16 +++--
 include/bitops.h       |   2 +
 include/builddefs.in   |  10 +++-
 include/buildmacros    |   2 +-
 include/darwin.h       | 158 ++++++++++++++++++++++++++++++++++++++++++++-=
----
 include/list.h         |  14 +++++
 io/readdir.c           |  12 ++++
 libhandle/Makefile     |   4 ++
 libxcmd/paths.c        |   2 +-
 libxfs/xfs_da_format.h |  11 +++-
 libxfs/xfs_format.h    |   1 -
 libxfs/xfs_inode_buf.c |  13 +++-
 libxfs/xfs_inode_buf.h |   2 +
 libxfs/xfs_sb.c        |   3 -
 m4/package_libcdev.m4  |  20 +++++++
 mkfs/xfs_mkfs.c        |  17 ++----
 repair/dinode.c        |   5 +-
 repair/prefetch.c      |   2 +-
 24 files changed, 273 insertions(+), 52 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--EuxKj2iCbKjpUGkD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV06vsAAoJEK3oKUf0dfodf8QQALpHSdgV0OHAscCMkJQgH8Rs
D9wfbDGwWKpt0jJ4goHBNpAPBi884sH829JCqsGr8quf58w6p3Wo/xRAv36WDL3H
9Tg7im7A/Zie5poE69+ufTDkOOY5/bfveBCnq9Fki3B+zp/Go3Z5vXZsvLcPX38h
fSuVqio7i27uqBH3oaWh1fEbkrw95ER7iRcZLES8IjqMBCEMVIj5GfgSjnuHEYYn
Iji4OgCHhGhkQoZoUsEvWqtyut+gBZqSYVQ3S6ZD5P4AanzCJqNL+XXIbhUGmir+
4QFGa/AXMC1muZp+ST/akH4vtIjpcEpVwb1/Sq0uUH7yFH0iZKYyc9EpXZ7NXXU+
TM8dbO2Z7MJKPh/KplmSiMFRTO4/2r0b4YUH4aoV9hQlRf8AEsGWonOV9BvYbynN
uC0lkVr9pbpwhuTNk4aBxThxjbUQyVJScpGpfptzIX+5YgndB7qJmo/04i9xtoA7
QSc3N6KQqoyIBO6UtBPpPzqrB5rYCyvWknG+F0Cee4itkK8ibLyVlV2MbG0yqDDm
4JblWNIjEkAci41TpmFQnOKA50d+COU4DBJgwdfzUJHAfEMCTFeh0Loa4DhLa/YN
NeE9UFxxOZyp6IhnitR18fBfEQB3RoQwEQzjZcdQmNZqey7OM2DQNbNq7rwBWM1Y
1c3ajXMVOL1L6r+IqxER
=NIeO
-----END PGP SIGNATURE-----

--EuxKj2iCbKjpUGkD--


--===============5403363617915320976==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5403363617915320976==--
