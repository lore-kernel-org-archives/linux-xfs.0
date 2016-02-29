Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7D0477C8C
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 00:24:06 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E5E55AC003
	for <xfs@oss.sgi.com>; Sun, 28 Feb 2016 22:24:02 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jrBxj5tZrdWUjbn0 for <xfs@oss.sgi.com>;
	Sun, 28 Feb 2016 22:24:00 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1aaHFM-0000LA-9u
	for xfs@oss.sgi.com; Mon, 29 Feb 2016 17:23:56 +1100
Date: Mon, 29 Feb 2016 17:23:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: for-next branch updated to c062cfe
Message-ID: <20160229062356.GG29057@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2890514037036415258=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============2890514037036415258==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hHWLQfXTYDoKhP50"
Content-Disposition: inline


--hHWLQfXTYDoKhP50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Folks,

The for-next branch of the xfsprogs repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated, bringing it back in line with the current
master branch, fixing bugs in the libxfs sync branch, and adding
Carlos' new inode command.

The new head of the master branch is commit:

c062cfe Merge branch 'progs-misc-fixes-for-4.6' into for-next

New Commits:

Carlos Maiolino (1):
      [ef25c9e] xfs_io: implement 'inode' command

Darrick J. Wong (1):
      [71893d8] mkfs: fix crash when initializing rbmip

Dave Chinner (2):
      [3efa0bd] Merge branch 'libxfs-4.6-sync' into for-next
      [c062cfe] Merge branch 'progs-misc-fixes-for-4.6' into for-next

Dmitry Monakhov (1):
      [2ab8ecb] xfs_io: Prevent devide by zero from {pread,pwrite}_random

Eric Sandeen (2):
      [fa247a5] xfs_db: Fix dquot command docs
      [ff0f39e] libxfs: fix up mismerge in libxfs_iflush_int

Zorro Lang (1):
      [c614d3b] xfs_quota: modify commands which can't handle multiple types


Code Diffstat:

 db/dquot.c           |   8 +--
 io/open.c            | 150 +++++++++++++++++++++++++++++++++++++++++++++++=
++++++
 io/pread.c           |   6 ++-
 io/pwrite.c          |   6 ++-
 libxfs/util.c        |   2 +-
 man/man8/xfs_db.8    |   4 +-
 man/man8/xfs_quota.8 |  14 ++---
 mkfs/proto.c         |   2 +-
 quota/edit.c         |  60 ++++++++++++++-------
 quota/quot.c         |  15 ++++--
 quota/quota.c        |  15 ++++--
 quota/report.c       |  20 ++++---
 12 files changed, 250 insertions(+), 52 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--hHWLQfXTYDoKhP50
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJW0+P7AAoJEK3oKUf0dfodSAoQALqXHt2LVzdu229iYNdCtBUQ
9eAXxAVkm2I6ZDr0sNg2PxSFgCwpMo6cIFXCOzIsXA41o/r9DC7o1drbG0x2Fj87
Ce2wP4Ngb3pyA0bM+4wgbeSwPe2LEJyUzfmXL1UE+mpO6L5FpmIOgax+joYO5i+W
3Xia7gK+/v4FOCyPMaWwyjlVRdnKNBnsK27qDLIw8hAgt12tixX+taONZUovH1iR
gJK1RzVi91OfMvQ/COvXfAgXJ8TC6fD1iO7SgfUSaWtMtXE+xN+42zOlvfjrvLoq
wBQ2iOaBT/vvvvuyDDfP2Uu9jlXEiV9U90d/oUkQah6EgFOR8IpXkOnYZlLsJMV0
7l/Y4Sur94JN/GlGuMCNhKU+VGFtbjgFAfShpbHgt5e8eUhYvD+VpKjKcM86p4XX
qNyN+onmB0bIIvYKoWM8v4us4z8QBf3PbEUIm6GpiLhT8Fajn2FkCOFcz4eZ3p7+
bDbxrAsRmiDPBejUKOM5EvKJTyf+wdJpGPL/xamzWpYAkaCartZQSXt3UbvXPhAs
Dh9vuB0YfLdT6yTjaTlCp5Mx/1+tcexIVeWyAfJ6XjS5zo47g7kDqwiaNmmWNW1H
NAhei3V4cAZSC2wJKVCorA5QySzDzyzFTmfWjzsEiZ9L3SkSvkDN8sD4vz4xOOPi
fkZ44s2zHrKNihXwvHO7
=DTca
-----END PGP SIGNATURE-----

--hHWLQfXTYDoKhP50--


--===============2890514037036415258==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2890514037036415258==--
