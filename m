Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 93E3B7F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 22:58:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 17C49AC004
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 20:58:00 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	IFcCQyszPLDStwfT for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 20:57:54 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1ZU5Mc-0001kJ-T3
	for xfs@oss.sgi.com; Tue, 25 Aug 2015 13:57:34 +1000
Date: Tue, 25 Aug 2015 13:57:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: v4.2.0-rc3 released
Message-ID: <20150825035734.GG714@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8166213394870230031=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============8166213394870230031==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Lb0e7rgc7IsuDeGj"
Content-Disposition: inline


--Lb0e7rgc7IsuDeGj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repositories at:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
git://oss.sgi.com/xfs/cmds/xfsprogs

have just been updated to v4.2.0-rc3.

The changes since 4.2.0-rc2 are mainly fixes for problems found by
Eric, Jan, Eryu and Darrick in the past week. I've also pulled the
libxfs bug fixes from the current kernel tree to cover all the
changes made to fix corruption issues that have been found recently.

There was also a revert of an OS X build change - I incorrectly
committed an early version, and the finalised version is not yet
ready.

I think the tree is now pretty close being ready for a 4.2.0
release. If no major problems arise in the next week then I think we
are good to go, which means we are looking at 4.2.0 releasing at
roughly the same time as the 4.2 kernel (Yay!).

The new head of the master branch is commit:

2852f7d xfsprogs: Release v4.2.0-rc3

New Commits:

Darrick J. Wong (3):
      [06e61d6] libxfs: readahead of dir3 data blocks should use the read v=
erifier
      [603ab21] xfs_db: don't crash on a corrupt inode
      [66fc04e] xfs_repair: fix broken EFSBADCRC/EFSCORRUPTED usage with bu=
ffer errors

Dave Chinner (5):
      [db9cba4] xfs: xfs_bunmapi() does not need XFS_BMAPI_METADATA flag
      [92a57a6] xfs: remote attributes need to be considered data
      [d9241d7] xfs: remote attribute headers contain an invalid LSN
      [8b25826] xfsprogs: revert OS X dummy function changes
      [2852f7d] xfsprogs: Release v4.2.0-rc3

Eric Sandeen (7):
      [4334e2e] libxfs: fix memory leasks in libxfs_umount()
      [0a223eb] xfs_repair: free msgbuf on exit
      [4491caa] xfs_repair: call IRELE(ip) after libxfs_trans_iget calls
      [bd75814] xfs_repair: unconditionally free blockmaps when threads com=
plete
      [2dd1360] libxfs: remove self-assignment in libxfs/util.c
      [efb3582] xfs: don't cast string literals
      [66a5607] man pages: Minor fixes for xfs.5

Eryu Guan (1):
      [621b5ff] repair: fix wrong logic when validating node magic number

Jan Kara (2):
      [71a9bb1] libxfs: Fix file type directory corruption for btree direct=
ories
      [fcdd428] xfs: Fix uninitialized return value in xfs_alloc_fix_freeli=
st()

Joe Perches (1):
      [2c2ec8f] xfs: Use consistent logging message prefixes


Code Diffstat:

 VERSION                  |   2 +-
 configure.ac             |   2 +-
 copy/xfs_copy.c          |   3 +
 db/attr.c                |   4 +-
 db/dir2.c                |   4 +-
 db/inode.c               |   2 +
 db/io.c                  |   4 +-
 db/io.h                  |   2 +-
 doc/CHANGES              |  10 ++++
 fsr/xfs_fsr.c            |   8 ---
 include/darwin.h         | 153 +++++--------------------------------------=
----
 libxfs/init.c            |   9 +++
 libxfs/libxfs_priv.h     |   3 +-
 libxfs/util.c            |   9 ---
 libxfs/xfs_alloc.c       |   2 +-
 libxfs/xfs_attr_remote.c |  49 +++++++++++----
 libxfs/xfs_da_btree.c    |   4 +-
 libxfs/xfs_dir2.c        |  33 +++++-----
 libxfs/xfs_dir2_data.c   |   3 +-
 libxfs/xfs_dir2_node.c   |  11 +++-
 libxfs/xfs_format.h      |   4 +-
 libxfs/xfs_sb.c          |  14 +++--
 man/man5/xfs.5           |   4 +-
 repair/attr_repair.c     |   2 +-
 repair/bmap.c            |  17 +++++-
 repair/bmap.h            |   1 +
 repair/dir2.c            |   2 +-
 repair/phase3.c          |   2 +
 repair/phase4.c          |   1 +
 repair/phase6.c          |   6 ++
 repair/scan.c            |  12 ++--
 repair/xfs_repair.c      |   2 +
 32 files changed, 164 insertions(+), 220 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--Lb0e7rgc7IsuDeGj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV2+euAAoJEK3oKUf0dfodsfgP/iCsFjCCW2PFUuxLoMMutq5s
VHOG95GWFEHYhKTcYbxRO11eEDUSRN2y5YhM2p4iH5tqQoy6otakenMKs413vxSb
amhkwTZ4LZbdnUt2AjnS5TjYDMtB3N/OENol3K9NrJqipaa0Hjy1gU5yMWMwD5o/
NuDtgo2q+qcBW+80tTqi7xtGIaxR990ZL0ItO0e0/Bstbt2nV8sYCsGfWSdnoUJv
pdRj7sY6B46kG/qydfS6JqRrbg8PCSYslzDH0VQbmn0V1C+2cg3XSrZzPaMEjdIN
B5iPIL0z2uykAaHnYuLWzl3EFVbPJUr1bDqSrH2QZsyX4qwdFGa2u0RCXYhxyN0p
0v8lIQIgjQQ0ztqpr8uQUDs8vlBvJh2JJ8nK3CNO+JUh2MEN/UtVyV4O1y+YmZID
JV1BkhcbJSTbuW2/lP3ysjHS+9tsvjIGZb0SRvTsQvh+xK8/G4ecARCseGjIIZYU
MCUw2WY7uT/pNPeLeVkHKIMRivxboKAE4jJGeU4R4FphgGBcxpNzSCc7mT5q4iMi
MNsmtoyK2gol6dBVZrOhlLYfDJxxuMNNUzPAHtos2xPleTGWs00cbDaaNNuF2iNU
PGAwYsJ63PATGb+BOXVG8zZtX2sp0gaw73eYf9crvJRmrYaLUSNbf/Iud9ujMQzc
XNnLaqEgvi8ph3eyyhsU
=E6XY
-----END PGP SIGNATURE-----

--Lb0e7rgc7IsuDeGj--


--===============8166213394870230031==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8166213394870230031==--
