Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DD7757F90
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 00:21:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AEA49304077
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2015 22:21:09 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	tPMjUn62k93c2GLA for <xfs@oss.sgi.com>;
	Sun, 01 Feb 2015 22:21:04 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1YIANa-0004bE-4i
	for xfs@oss.sgi.com; Mon, 02 Feb 2015 17:21:02 +1100
Date: Mon, 2 Feb 2015 17:21:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 1790736
Message-ID: <20150202062102.GH6282@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8527922141466994241=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============8527922141466994241==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

1790736 Merge branch 'xfs-ioctl-setattr-cleanup' into for-next

New Commits:

Brian Foster (1):
      [4d94902] xfs: remove incorrect error negation in attr_multi ioctl

Christoph Hellwig (2):
      [8add71c] xfs: factor out a xfs_update_prealloc_flags() helper
      [2ba6623] xfs: don't allocate an ioend for direct I/O completions

Dave Chinner (10):
      [3fd1b0d] Merge branch 'xfs-misc-fixes-for-3.20-3' into for-next
      [817b6c4] xfs: FSX_NONBLOCK is not used
      [29a17c0] xfs: separate xflags from xfs_ioctl_setattr
      [8f3d17a] xfs: factor out xfs_ioctl_setattr transaciton preamble
      [f96291f] xfs: disaggregate xfs_ioctl_setattr
      [fd179b9] xfs: kill xfs_ioctl_setattr behaviour mask
      [41c1452] xfs: XFS_IOCTL_SETXATTR can run in user namespaces
      [d4388d3c] xfs: factor extsize hint checking out of xfs_ioctl_setattr
      [23bd073] xfs: factor projid hint checking out of xfs_ioctl_setattr
      [1790736] Merge branch 'xfs-ioctl-setattr-cleanup' into for-next

Iustin Pop (1):
      [9b94fcc] xfs: fix behaviour of XFS_IOC_FSSETXATTR on directories

Wang, Yalin (1):
      [f3d2155] xfs: change kmem_free to use generic kvfree()


Code Diffstat:

 fs/xfs/kmem.c        |  10 -
 fs/xfs/kmem.h        |   5 +-
 fs/xfs/xfs_aops.c    | 149 +++++++--------
 fs/xfs/xfs_aops.h    |   3 -
 fs/xfs/xfs_file.c    |  64 ++++---
 fs/xfs/xfs_inode.h   |   9 +
 fs/xfs/xfs_ioctl.c   | 501 +++++++++++++++++++++++++----------------------=
----
 fs/xfs/xfs_ioctl32.c |   2 +-
 8 files changed, 360 insertions(+), 383 deletions(-)

--=20
Dave Chinner
david@fromorbit.com

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUzxdNAAoJEK3oKUf0dfodv6EQAL50006ViebOdq6cg6DQvK1+
72EWe9tzzCTFE1zTv9plQ6EB0MQJSdWQSMyv+MlikoYN809ekciWFt97F50AyR0m
vcYvVQT5g/SpPjZ0SUdV7r7WpkdWUCWHxVUOngLmYCYOYoOLsCCSxI2EhlBZ38sr
OvKppQWs3n9UJh4EvwKISziRXyTpJN8lD7FPVjDnOpBpSr3O8eIaMbjRLDNejE/V
V1P4x0vkD2G1v32RSgKPU43tcKJWuS1ayrDrLwCVJAfn2QLK4WSWXE1VFBZzc8Xz
sBXWrvx4BK+m0rSBAtHMQRxSq9YNfuwQQgdSfdnsY9llv+8ZlVOWWTUxBpiku08v
wcvpvM6OULXEU3F8GnyFUglnFGsJhDDTadiI1GQFWTBKUAQ5sm7LoS/aIImaE11q
06bYiYrO0LCxbJeNeS2xdfF3NWYk1qjvAMbjWVqR40MLdz8aQgBZJv85JQpO/JLi
0DTtG5knXct/tsTgvOICSi9R5b/zHUVRfewOPpimPHR9XvJgyQ6cLi9S8vg0eJP/
pGNnpJpg2Kck6L05l6GMEXF1bQGtgJAWhVOdnQgDlcmfoqdW545WSyHLJurnz1Ix
syWHOT/ARF9eCZe+CWe9SESjjBIHkiFV567iXDi27lsAvA0A5ojLcRKRGNfoqUOc
tD15xrV22mbvuO0S7M5F
=RT3i
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--


--===============8527922141466994241==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8527922141466994241==--
