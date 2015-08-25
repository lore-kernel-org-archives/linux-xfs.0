Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B165F7F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 22:37:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4631CAC002
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 20:37:24 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	F59yTpvHBhPoBPKa for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 20:37:22 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1ZU52q-0001hV-5d
	for xfs@oss.sgi.com; Tue, 25 Aug 2015 13:37:08 +1000
Date: Tue, 25 Aug 2015 13:37:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 70b33a7
Message-ID: <20150825033708.GF714@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6200002567440519686=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============6200002567440519686==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cQXOx3fnlpmgJsTP"
Content-Disposition: inline


--cQXOx3fnlpmgJsTP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

70b33a7 Merge branch 'xfs-misc-fixes-for-4.3-3' into for-next

New Commits:

Dave Chinner (3):
      [b6a9947] xfs: lockdep annotations throw warnings on non-debug builds
      [f79af0b] xfs: fix non-debug build warnings
      [70b33a7] Merge branch 'xfs-misc-fixes-for-4.3-3' into for-next

Eric Sandeen (1):
      [2ccf4a9] xfs: collapse allocsize and biosize mount option handling

Jan Kara (2):
      [c184f85] xfs: Fix uninitialized return value in xfs_alloc_fix_freeli=
st()
      [0375423] xfs: Fix file type directory corruption for btree directori=
es


Code Diffstat:

 fs/xfs/libxfs/xfs_alloc.c     |  2 +-
 fs/xfs/libxfs/xfs_dir2_node.c | 10 +++++++++-
 fs/xfs/xfs_buf.c              |  4 +---
 fs/xfs/xfs_buf_item.c         | 20 +++++++++++++-------
 fs/xfs/xfs_buf_item.h         |  2 +-
 fs/xfs/xfs_inode.c            |  8 +++++++-
 fs/xfs/xfs_super.c            | 12 ++----------
 7 files changed, 34 insertions(+), 24 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--cQXOx3fnlpmgJsTP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV2+LjAAoJEK3oKUf0dfodSosQAKvojDW6mqBsUZlXkTGHgBmc
T7Br0gwkCwMFdz8eBAJLQX8bJLVFzg5VnyfyOZ6ozHTTOgZL+S3AmsDtxMmF5hQ4
DOGN+D6Sb9FDWier1BN/RXwbfF99/iL/9ug38tjK66hHbM4/zz422RYreHeWriQv
E2EasnN/IIRetUgAjJqR9iADoGI8C2DPrzJe5DeAmnpNdZT2hoiPWAw7rNueN9ZR
5XigIS6lMycwBggpgLASKf6JpkHw73LrL2etR5ZqsxHAY/FmvyCu4lsR+lSu45fT
61fsSW4KFQB+29Bmm6rfyn8HZBwrnLfKC0LDq8XlJP49DfiQSqHf2CFKcad01b2q
yTBkQB1qKH0xw2SPWMph3bqUA+aodA4WZfRpGD77WlnncsW0W96PmIwScdQf5ABc
FwUppHEF+R/udijR8K1aD9xTP+l6Dis7/NMQQs0RcIMwmtYijcUwSC4m1sPGLlx1
wI6OeiH6hHtbFjTyqITUCbeQFrLqMMSk8PhWVzsGiEAK8ozRVMKmOELd3r1ZP40i
y3qQZjFEqm95bUxg/Zt3NNiTQErNK02nG6xnmzSiRQFPJU3+iScWwBWm6mQEwYLG
UIVl0I23rbLFfHTkEXFSBRbAvqbLatk7jjFJcw8IaOYck/kJHSXACeAkZ9COZP+v
QmLMJYiyjJqocaOAXaLv
=xqCu
-----END PGP SIGNATURE-----

--cQXOx3fnlpmgJsTP--


--===============6200002567440519686==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6200002567440519686==--
