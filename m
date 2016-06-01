Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1E8147CA2
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 03:35:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CECBF8F8039
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 01:35:06 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	HCMOTXfqmxIp7H9a for <xfs@oss.sgi.com>;
	Wed, 01 Jun 2016 01:34:58 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1b81c7-0006u3-SC
	for xfs@oss.sgi.com; Wed, 01 Jun 2016 18:34:55 +1000
Date: Wed, 1 Jun 2016 18:34:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch update to 26f1fe8
Message-ID: <20160601083455.GK12670@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3604244065563510159=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============3604244065563510159==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gj572EiMnwbLXET9"
Content-Disposition: inline


--gj572EiMnwbLXET9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

26f1fe8 xfs: reduce lock hold times in buffer writeback

New Commits:

Brian Foster (2):
      [a3916e5] xfs: fix broken multi-fsb buffer logging
      [0c871f9] xfs: remove spurious shutdown type check from xfs_bmap_fini=
sh()

Christoph Hellwig (1):
      [4478fb1] xfs: define XFS_IOC_FREEZE even if FIFREEZE is defined

Dave Chinner (1):
      [26f1fe8] xfs: reduce lock hold times in buffer writeback

Eric Sandeen (1):
      [0d5a75e] xfs: make several functions static


Code Diffstat:

 fs/xfs/libxfs/xfs_alloc.c     |  2 +-
 fs/xfs/libxfs/xfs_alloc.h     |  7 ------
 fs/xfs/libxfs/xfs_attr_leaf.h |  3 ---
 fs/xfs/libxfs/xfs_fs.h        |  8 ++-----
 fs/xfs/libxfs/xfs_rtbitmap.c  |  2 +-
 fs/xfs/xfs_attr_inactive.c    |  2 +-
 fs/xfs/xfs_attr_list.c        |  2 +-
 fs/xfs/xfs_bmap_util.c        |  6 ++---
 fs/xfs/xfs_bmap_util.h        |  2 --
 fs/xfs/xfs_buf.c              | 60 +++++++++++++++++++++++++++------------=
-------
 fs/xfs/xfs_buf_item.c         | 18 ++++++++++----
 fs/xfs/xfs_inode.c            | 16 ++++---------
 fs/xfs/xfs_inode.h            |  7 ------
 fs/xfs/xfs_log.c              |  8 +++----
 fs/xfs/xfs_log.h              |  5 ----
 fs/xfs/xfs_rtalloc.h          |  2 --
 fs/xfs/xfs_super.c            |  2 +-
 fs/xfs/xfs_super.h            |  2 --
 18 files changed, 65 insertions(+), 89 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--gj572EiMnwbLXET9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXTp4vAAoJEK3oKUf0dfodEbQQAIwGYmYIbSDfg3S4xU9PGMGE
Nq5+YCK+0S7krpw75vfuBGZuJs1K0+A4vs7HtIiZWW8gQcb02NXMQI1H3NMlOs/u
dJOGfs/StUAbYZLi2b99h88DdT9ce2h9hFSaKBsftHcxd5eWJXN6k52G9C6QOB1e
y+9b7ffFK3ztb5sRnDXUTDc7zwjof9QF8hz/zA7E3wzQ1+3SoB0RIeuALzUeoZIG
68EYDOKHUKdz3VN776JF0xVCACCQ25FU+DGRLZ2XUuHdunlb72eVI1WZjmuk4RTG
zY0aHOHVASigip7IkHC87fgIVIu/3fyE0eYMTEJ1jTFBcq15lYXUqe7tcYfHdEXR
lB8Jy8Nri0Pz7ISHPMtwXibz6gNl3nUqv9hv+ufiYsOFK39yGz4+JVaFSVZTJXsf
SoFusB/R1X3b/fl7lFsnPzUcb0G30zem8F1P6Kv1AXKh8LaipawLBgMCaTHTTqAz
ldzxANP6qr8YioqqV85vzfVa17AeHPTxcucBOkk3V7JrVcC5CFrTx8yE3RE1lkNx
qvEpTEtl1mr1zEIdQDdOPGgl2f4UsrgJxWMEV0eIbV7rsDsshqQZKUz7PsKvRqTZ
aKCH1CZ3zBn06lEl9Vip5r/xabo0y9ZKcskdECYTcPs2JOO3Ilc30W8ED+oy0ut6
fxv4fp86dn4ATyAd8fFd
=oh5k
-----END PGP SIGNATURE-----

--gj572EiMnwbLXET9--


--===============3604244065563510159==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3604244065563510159==--
