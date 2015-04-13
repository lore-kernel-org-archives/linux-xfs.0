Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 06F8F7F63
	for <xfs@oss.sgi.com>; Sun, 12 Apr 2015 23:33:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 06099304039
	for <xfs@oss.sgi.com>; Sun, 12 Apr 2015 21:33:28 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	QiWI7oz6BN7WH4rU for <xfs@oss.sgi.com>;
	Sun, 12 Apr 2015 21:33:23 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1YhW3Y-0006Qt-Sf
	for xfs@oss.sgi.com; Mon, 13 Apr 2015 14:33:08 +1000
Date: Mon, 13 Apr 2015 14:33:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: master branch updated to 21c3ea1
Message-ID: <20150413043308.GQ15810@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2284289304617785616=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============2284289304617785616==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XF85m9dhOBO43t/C"
Content-Disposition: inline


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

21c3ea1 xfs: unlock i_mutex in xfs_break_layouts

New Commits:

Brian Foster (3):
      [2f66124] xfs: pass attr geometry to attr leaf header conversion func=
tions
      [e87021a] xfs: use larger in-core attr firstused field and detect ove=
rflow
      [66db810] xfs: kill unnecessary firstused overflow check on attr3 lea=
f removal

Christoph Hellwig (1):
      [21c3ea1] xfs: unlock i_mutex in xfs_break_layouts

Eric Sandeen (1):
      [bbe051c] xfs: disallow ro->rw remount on norecovery mount

kbuild test robot (1):
      [72c1a73] xfs: xfs_shift_file_space can be static


Code Diffstat:

 fs/xfs/libxfs/xfs_attr_leaf.c | 150 ++++++++++++++++++++++++++++++++------=
----
 fs/xfs/libxfs/xfs_attr_leaf.h |   6 +-
 fs/xfs/libxfs/xfs_da_format.h |  14 +++-
 fs/xfs/xfs_attr_inactive.c    |   3 +-
 fs/xfs/xfs_attr_list.c        |   9 ++-
 fs/xfs/xfs_bmap_util.c        |   2 +-
 fs/xfs/xfs_file.c             |   4 +-
 fs/xfs/xfs_ioctl.c            |   2 +-
 fs/xfs/xfs_iops.c             |   2 +-
 fs/xfs/xfs_pnfs.c             |   7 +-
 fs/xfs/xfs_pnfs.h             |   5 +-
 fs/xfs/xfs_super.c            |   6 ++
 12 files changed, 159 insertions(+), 51 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--XF85m9dhOBO43t/C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVK0cEAAoJEK3oKUf0dfodmI4QALF+z0DEH5QUk95gfbqvOgQT
G4V37TKVm5te0YHwLUPujUdMJNSh3wIMRX6jQYopJ2Uo/3viKeE5uP952N8e9jvU
ib5uANXGA8Y3epvYfev2HBxuOwFkFaKNYCcqHhLi3lcPFua/b8TdMpQFJFrRJQl8
B/W3bp7sW1Fe98B0RVuBxUFDILw7J+xBxQoJk0cDZAZK6V8NScDSaZ/xiD52FoAq
qJHNdV291EYNbkWbjRo2mcBFCnbUHz2bqboHe6Iz1/SYx1EwPucYebR0kZ0NtCf/
a1hYJr0BAgBHECkpbg50CXDb0tFiFgTdYwsOSi9XpG6wYFzLTgocRoljVyvqAl8j
BU6BS8GSXRRjZcdW6Ql68bwSFQx6ylRKN5riEppAsL/GvZa+lsWtBemLMrEWGY4V
nSf/x4vp1jPEG1hdl0CgRvlPnF4NmJPxHUKhlwkMWN69NaJrNn1Hcc7WqtftfifY
ZTrQ5gaE5I1qqhkWMaC4NbQrpFDpBMw3JCdaG2+PGaz0SihGJlTGOgv++7BmZUck
T/QCqh4f5tQi51WPUogUZYv3R7KqJEFWIVDkv9RlssOGAjxcbkLrDgabylrTKC+V
9pBRD1u9wx/cFSG3Gx5chbNxJtKQjis5gQ3r1XM1xfxxZ/93l7Y8xuJk4+Z915Op
mSvvW8YqaopdFT6tVebq
=X+d0
-----END PGP SIGNATURE-----

--XF85m9dhOBO43t/C--


--===============2284289304617785616==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2284289304617785616==--
