Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 52E587CA1
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2016 00:08:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 137C5304048
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 22:08:25 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	s45FHwRSZA3EsYwq for <xfs@oss.sgi.com>;
	Tue, 28 Jun 2016 22:08:22 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1bI7jY-0002Z5-B8
	for xfs@oss.sgi.com; Wed, 29 Jun 2016 15:08:20 +1000
Date: Wed, 29 Jun 2016 15:08:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to ee37542
Message-ID: <20160629050820.GO12670@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2214672862006389086=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============2214672862006389086==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KR/qxknboQ7+Tpez"
Content-Disposition: inline


--KR/qxknboQ7+Tpez
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Folks,

The xfsprogs repository at:

git://oss.sgi.com/xfs/cmds/xfsprogs
git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

The new head of the master branch is commit:

ee37542 xfs_repair: don't call xfs_sb_quota_from_disk twice

New Commits:

Bill O'Donnell (1):
      [dd36660] xfs_repair: resolve Coverity OVERFLOW_BEFORE_WIDEN

Dave Chinner (2):
      [8730711] libxfs: fix use after from in xfs_trans_roll
      [3fbf002] libxfs: fix double free in libxfs_alloc_file_space

Eric Sandeen (1):
      [ee37542] xfs_repair: don't call xfs_sb_quota_from_disk twice


Code Diffstat:

 libxfs/trans.c  | 4 +++-
 libxfs/util.c   | 4 ----
 libxfs/xfs_sb.c | 7 +++++--
 repair/sb.c     | 4 +---
 repair/scan.c   | 1 -
 5 files changed, 9 insertions(+), 11 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--KR/qxknboQ7+Tpez
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXc1fDAAoJEK3oKUf0dfodzkwP/1aOJN26x7FsD8sfmYyYamxu
wTTDSnj9EVAlF2oH+M502c2oHwADHCCdu6YZQS7+TJLGrqk1wPRp8fQlCJDy4IcS
TSTV2B4z5trXQKjnzPZZTi6DK/IoOpK+cboc0gLtv50BJOj5tgBOupYoJ7WER2lw
Ouj2C1jUU6XdLWtBSsAjZ3QjditLZh4yBc1vV76IvEHYTIwZdjWEu0kpIN5YN3Sd
DrNid9T8nHVH8+KUZn4t39jsnt8SpPwG42w4pqaFZcxCIxm4sn23Be86dNdfuVVW
/wX55rkHn+UVSQSEixGQkAFjCS56zrFyBraPyUJJlPfe2pkzCbeBFCdQBwoR+t99
0/XRhlGz9PrByHiJR3ZLIAZqLXr+4+RNHWYAX25qXPOmRprQDk9LGqK7Xx54ahfq
o8vYsgLrvW5Qo/V/UCWUAsoYGrweGFc5xYAEobNC+bj5rXav3sZj+AXkfc0ZNKBX
8s8zmpHxR/me+ZG40WQAIbghgkTtUbZtqvrSad6x4lcilxkQWiTopEugsvIUoCqW
m7DTUEdN/f9SIK5ETwPcseaaiTKmm1t/ruKapwo0FqsVRhQYbWuhJrrQUKZag41u
pqqnO/rs6/29pI8GQ0vnxiQGNmojpZmmY7gRXjHxAQDlOwf0yATdD5VouJQoQjLb
Wo6gMEezFL3e6WX4ll5p
=0P80
-----END PGP SIGNATURE-----

--KR/qxknboQ7+Tpez--


--===============2214672862006389086==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2214672862006389086==--
