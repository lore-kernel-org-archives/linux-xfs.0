Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D15097CBB
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 18:40:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A2A1E304048
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 16:40:32 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	9XtWXa1OSGvHJD3K for <xfs@oss.sgi.com>;
	Tue, 01 Mar 2016 16:40:27 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1aatVX-00051R-8L
	for xfs@oss.sgi.com; Wed, 02 Mar 2016 10:15:11 +1100
Date: Wed, 2 Mar 2016 10:15:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs; for-next branch updated to 31bb236
Message-ID: <20160301231511.GM30721@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4383276065190453898=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============4383276065190453898==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

31bb236 Merge branch 'xfs-misc-fixes-4.6-2' into for-next

New Commits:

Christoph Hellwig (1):
      [a7e5d03] xfs: remove xfs_trans_get_block_res

Colin Ian King (1):
      [5d518bd] xfs: fix format specifier , should be %llx and not %llu

Dave Chinner (1):
      [31bb236] Merge branch 'xfs-misc-fixes-4.6-2' into for-next

Eric Sandeen (3):
      [2e74af0] xfs: convert mount option parsing to tokens
      [a08ee40] xfs: sanitize remount options
      [12c3f05] xfs: fix up inode32/64 (re)mount handling

Mateusz Guzik (1):
      [2e83b79] xfs: fix two memory leaks in xfs_attr_list.c error paths


Code Diffstat:

 fs/xfs/libxfs/xfs_bmap.c       |   6 +-
 fs/xfs/libxfs/xfs_bmap_btree.c |   4 +-
 fs/xfs/xfs_attr_list.c         |  19 +-
 fs/xfs/xfs_discard.c           |   2 +-
 fs/xfs/xfs_mount.c             |  20 +-
 fs/xfs/xfs_mount.h             |   5 +-
 fs/xfs/xfs_super.c             | 525 +++++++++++++++++++++++--------------=
------
 fs/xfs/xfs_super.h             |   4 +-
 fs/xfs/xfs_trans.h             |   1 -
 9 files changed, 304 insertions(+), 282 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJW1iJ+AAoJEK3oKUf0dfodUrsP/i9U30bIJeSd2dmoGQlKPtL4
zpgTEu13ZVN+XjpFeV0OViAze0aG8ITlNKmSGERN3sx05IhbugfHJM6ok7YOvxfj
m9si6G66eoAAb2MJUrfjh9XZoq59mpWmOehjidrAqB9+YGDABhp1rMdlCg+xXgTr
PGbT/53/buwxoVN7FI32bo2sdSVAV17GUfla3Dh+d4wKUKud3J4vw2jx2K8VBoqM
4HezNR0qml96+85F/hZ1oauzbP0AGTg8aRCUc/2DbdZCX7SoRS80cyGMXl5FASis
/UZYk1sUeXLnIGTOsifqgE+98ycYg5oFtEPYZTLDvf070KbBvEEZxn/dsN87OubN
EywjdB3xO9mfFWCyyuZZdIR1Xp5h/OPaf1wvD6P2g3MBCNd1vjTbpvRPydEE7lVb
yRrFOivTTkHjr58RqK3C384FQzpXEatYeDP7jOPT7aO6KfPa/BpfYvEurCdBlBu8
1cYcVvGR90o8dwXjcz3NHHpeGic4GNjUirnuoBNv7mE67K5gfeVti4QjVHbVyTZD
PtJUC5TaEqkNJk1eOUok5lEyU1wyoTzMpHqCq+qK4k/4Acq/rkJ4evTkKFTZ9mE5
8rtrSMG7u6QP+HM4Canu+JZhykRTA636FiqO434x3un1xTY0yf9pMofboozwW4uP
T4rWjxcszb7+lmtEnc6u
=eLos
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--


--===============4383276065190453898==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4383276065190453898==--
