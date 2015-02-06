Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C26917F47
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 20:56:06 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A1473304032
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 18:56:03 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	bNEt3YohxPiRiqUJ for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 18:56:01 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1YJZ58-0006SB-Rc
	for xfs@oss.sgi.com; Fri, 06 Feb 2015 13:55:46 +1100
Date: Fri, 6 Feb 2015 13:55:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to bf988de
Message-ID: <20150206025546.GK12722@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7934971800785988522=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============7934971800785988522==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
just been updated.

The new head of the master branch is commit:

bf988de xfs_quota: manpage - project command requires arguments

New Commits:

Brian Foster (4):
      [6d23d9a] repair: fix unnecessary secondary scan if only last sb is c=
orrupt
      [8216a58] repair: remove unused strided secondary sb scan logic
      [16e1627] repair: fix v5 sb ino alignment calculation for large block=
sizes
      [ca0a799] repair: check ino alignment value to avoid mod by zero

Eric Sandeen (5):
      [2116b6a] xfs_repair: do not check symlink component lengths
      [7511a9c] xfs_repair: fix max block offset test
      [89c4bb8] libxfs: report VERSION in libxfs_fs_repair_cmn_err()
      [48e75fb] xfs_quota: fix typo in manpage
      [bf988de] xfs_quota: manpage - project command requires arguments

Namjae Jeon (1):
      [555bc8c] xfs_io: add finsert command for insert range

Romain Naour (1):
      [ece49da] xfsprogs: do not do any dynamic linking of libtool libraries


Code Diffstat:

 copy/Makefile        |  2 +-
 db/Makefile          |  2 +-
 growfs/Makefile      |  2 +-
 io/Makefile          |  2 +-
 io/prealloc.c        | 39 ++++++++++++++++++++++++++++-
 libxfs/util.c        |  1 +
 logprint/Makefile    |  2 +-
 man/man8/xfs_quota.8 |  9 ++-----
 mkfs/Makefile        |  2 +-
 repair/Makefile      |  2 +-
 repair/dinode.c      | 39 ++++++-----------------------
 repair/globals.h     |  2 --
 repair/sb.c          | 70 ++++++++++++++++++------------------------------=
----
 repair/scan.c        |  6 +++--
 14 files changed, 84 insertions(+), 96 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJU1C0yAAoJEK3oKUf0dfodq9oP/RoJoayyU5zuM9iuwTh+AoAK
xG2mcGPs9bf/5fzMr6yAgmElbh1rRP3ap1yLZzrsDazPkxFmr4HxcKI7jNpcJVNJ
bIu+lD69/7xK2F/CWrYG8Irhh1tCjgamEu5PF4EgEv2ZYofjL/fgpZX13Gx+vD60
YTWcJA2AniTjDw3XffEZshcugWfvYxDGNjJZcLOkWv7NX6co+is4GFi8qOuUOCdS
JijHi8vTkvD8gRjECVQMnw74zDeECCMhRiMy0dBazNGGEwz7//SvK5Q8KsyO+8yZ
Zk+d3xPgz0ue0goe0kRogZgnifLk/1eb8FAxQG5t23/nW+qnlTLxmQcgyISjaGVF
7VXHvRFBQ35RPCW7l+vLYMVwDkg1LjlGoVt9iU++64ld111a2Iam314RQ9OkJvN7
2WEhmjE24afJ1Ssll6NTQilI5FSfPJtnQvV5jw3rN5yt9BKMcQQFA/feScUioySr
QMjjrBSB6eawEKARo3dwMFDmLWg2QIb+1+hA4m5F2Du2XmqJj6f9rrcIfa9FuAHx
N38nFpmF02KlYNCZJmwe6ypCMybaiaIC/hQT0dZxgdAMLc8ivy/3jHUNgg/OWDvL
Lro35THb87Chlu+KOh1xL+xPYJDMHPR1xYnOeyrp9anLI4V4XLLq/xPvWXHCKAsd
KCuqzvw6+bLABacTYw5u
=7YAe
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--


--===============7934971800785988522==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7934971800785988522==--
