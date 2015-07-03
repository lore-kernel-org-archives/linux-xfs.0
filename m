Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E33047F84
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2015 22:34:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B006A8F8050
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2015 20:34:32 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	uzIsOxwgXI9520O6 for <xfs@oss.sgi.com>;
	Thu, 02 Jul 2015 20:34:30 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1ZArkB-0007XW-9S
	for xfs@oss.sgi.com; Fri, 03 Jul 2015 13:34:27 +1000
Date: Fri, 3 Jul 2015 13:34:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: for-next branch updated to b488748
Message-ID: <20150703033427.GN7943@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7281716438357534875=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============7281716438357534875==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at
git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git has just been
updated.

This update brings the libxfs code up to the same state as what has
just been merged into the 4.2 kernel tree. This update was done
using the new libxfs-apply tool to pull the required kernel commits
across to the xfsprogs repository, hence the commits retain the
correct author and signoffs from the kernel commits. Some of the
patches required minor changes outside xfsprogs so I did them as
necessary.

-Dave.

The new head of the master branch is commit:

b488748 Merge branch 'libxfs-4.2-rc1-update' into for-next

New Commits:

Brian Foster (2):
      [ac2ed13] xfs: always log the inode on unwritten extent conversion
      [e736ab9] xfs: check min blks for random debug mode sparse allocations

Christoph Hellwig (1):
      [1817f86] xfs: return a void pointer from xfs_buf_offset

Dave Chinner (7):
      [70e6227] xfs: extent size hints can round up extents past MAXEXTLEN
      [7c128bd] xfs: xfs_attr_inactive leaves inconsistent attr fork state =
behind
      [fe57a2e] xfs: xfs_alloc_fix_freelist() can use incore perag structur=
es
      [d37baa7] xfs: factor out free space extent length check
      [33f3851] xfs: sanitise error handling in xfs_alloc_fix_freelist
      [d29c243] xfs: clean up XFS_MIN_FREELIST macros
      [b488748] Merge branch 'libxfs-4.2-rc1-update' into for-next

George Wang (1):
      [b0e6012] xfs: use percpu_counter_read_positive for mp->m_icount


Code Diffstat:

 libxfs/libxfs_io.h       |   2 +-
 libxfs/libxfs_priv.h     |   5 +-
 libxfs/util.c            |   2 +-
 libxfs/xfs_alloc.c       | 239 ++++++++++++++++++++++++++-----------------=
----
 libxfs/xfs_alloc.h       |   8 +-
 libxfs/xfs_attr_leaf.c   |   8 +-
 libxfs/xfs_attr_leaf.h   |   2 +-
 libxfs/xfs_bmap.c        |  44 ++++++---
 libxfs/xfs_format.h      |  13 ---
 libxfs/xfs_ialloc.c      |  24 +++--
 libxfs/xfs_ialloc.h      |   3 +-
 libxfs/xfs_inode_buf.c   |   8 +-
 libxfs/xfs_trans_resv.h  |   4 +-
 libxfs/xfs_trans_space.h |   2 +-
 mkfs/xfs_mkfs.c          |  12 ++-
 repair/phase5.c          |   3 +-
 repair/xfs_repair.c      |   7 +-
 17 files changed, 213 insertions(+), 173 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVlgLCAAoJEK3oKUf0dfod0t4P/15iqZa3+EecW3ddo9TINQvD
bJ1ik4F7bJfwOHKkB9JRYyWoQg1Zz6r4MgMgI4cYNKA5V6+bN8keIdDF9hohPqR+
ZbsjfDaEsdSumez2v7kN/yFjC1XimJI2yqZ5g4iuAbkXNj8krso93O7no4p1tyvf
UCYX/Mafl+6geBu2BUrQ6yn2ZXvyjbsDHYBYk7KOuy6eI9/9nGt/RMUav6YEbh00
l6z6DTSty5SO+sMFuoT/olPvdkRgV/Hu5vFyXY6ekGdfWmFARJF7YhIaNJSfHfkh
7OGpAzsGbSBzbWkgQ8EpfelODswUinQmcZ1Do3/0hAcRS57ph9BngMAKlbE3HVQc
mwOlqgOSI1C+ps5BR+6DbI5qVW30NGgKdzqBLFeoheTsUU3eOoYSew5ZanwFTmak
Hru6qGM6l+tNKOOzZmPDE5hNgipjRuM0rhy/TALyw7BTMI0fXjDCrPek3FHPEwSL
FYHVQ7AZbtv81IFh5BCk+g4QowI1DAqfQK/tP02O7uESrk/JIVGihV1odIXoIKGA
odLvxcCYpZ42CYPn3pqpOZ17veiJr9aqXZeQ9majvtGuBna7clHohjvv+OjfZnlS
8q+qQpFgZ3/VZviL4POpc+XQK/q+/4YvU5fJaxmjGBDiMeBUY19M9JnverQqf6Gd
axvMWsooEofzFplYX7he
=Rk5q
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--


--===============7281716438357534875==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7281716438357534875==--
