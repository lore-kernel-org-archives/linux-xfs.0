Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 772357F6C
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 03:36:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 479B5304067
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 01:36:41 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	nTpArPXLC7TBgdvh for <xfs@oss.sgi.com>;
	Tue, 20 May 2014 01:36:38 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1WmfX7-0006M8-4v
	for xfs@oss.sgi.com; Tue, 20 May 2014 18:36:25 +1000
Date: Tue, 20 May 2014 18:36:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to 2c35010
Message-ID: <20140520083625.GK18954@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6955406086246777432=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============6955406086246777432==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
just been updated.

If I missed any patches that had been delayed for the 3.2.0 release
in this sweep, please point them out to me so I can pick them up. I
plan to pull in the free inode btree patches in the next couple of
days, and then stabilise for a 3.2.1 release by the middle of June.

The new head of the master branch is commit:

2c35010 xfs_repair: don't let bplist index go negative in prefetch

New Commits:

Eric Sandeen (2):
      [bfc541e] xfsprogs: remove xfs_check
      [2c35010] xfs_repair: don't let bplist index go negative in prefetch

Junxiao Bi (1):
      [2277ce3] xfs_copy: use exit() to replace killall()

Mark Tinguely (2):
      [dd2c21d] libxfs: remove unused argument in trans_iput
      [260c85e] libxfs: dont free xfs_inode until complete

Roger Willcocks (1):
      [6626020] libxfs: fix compile error when libxfs header used in C++ co=
de


Code Diffstat:

 copy/xfs_copy.c          |  30 +------
 db/Makefile              |   3 +-
 db/attrset.c             |   4 +-
 db/xfs_check.sh          |  42 ----------
 include/libxfs.h         |   7 +-
 include/xfs_ialloc.h     |   2 +-
 libxfs/init.c            |   4 +-
 libxfs/rdwr.c            |   2 +-
 libxfs/trans.c           |  60 ++------------
 libxfs/util.c            |   1 -
 libxfs/xfs.h             |   1 -
 libxfs/xfs_ialloc.c      |   6 +-
 man/man8/xfs_check.8     | 203 -------------------------------------------=
----
 man/man8/xfs_db.8        |  68 +++++++++++++---
 man/man8/xfs_mdrestore.8 |   1 -
 man/man8/xfs_ncheck.8    |   7 +-
 man/man8/xfs_repair.8    |   1 -
 mkfs/proto.c             |  18 +----
 repair/phase6.c          |  15 ++--
 repair/phase7.c          |   2 +-
 repair/prefetch.c        |   2 +-
 21 files changed, 88 insertions(+), 391 deletions(-)
 delete mode 100755 db/xfs_check.sh
 delete mode 100644 man/man8/xfs_check.8
--=20
Dave Chinner
david@fromorbit.com

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTexQIAAoJEK3oKUf0dfodHp0QAJe3/mrAATuzAZWzccB1ZAds
iW+SoU+mN4QaXnkAK8oKJNLAxNXCWjYUjTqvCii5VkzO7m3wAYTnzqURUCsFcbbW
7Ar8QgpNXdqlJhD0WXskeJU5PRgKSm6tRCrYVb5rFrdYqQjCtStgxvKVCDyn9eYk
60JaSxfuJHkvA8Z86FPjTXbMhiPmNfwkgBPWIRscUxTsZ9MGN3VafwRREiDu4GS5
ATmt29MZkLdYnRS6BNp6Zewf3phwM7EykCZqqz6q+PEi/MUHkwpFxdzmcreeryDL
cywxj0A1V2RWQVNc4O5M8ZtWRQU8Vcr1gjdIS1CZzJVEAM9uLD3XZ35XI5U8yXbo
gDylwbEKAniQin5FoyatyeOOvXorgoMFaaSS0QiYSrJEGPwa1oX3i1Yq4d+BjE8b
grdToZIFfo6OPRs9q7exaL9AMK8nAmGTU4Qi7IxUnLKWnclz3INaybwzYd9gViW5
Rfzg4nlQJraUXou3nK89Lhkdj8xTNjgJZTJaXcK6Dw04OopPQiVxE0NLyFS6WLsD
QSxq/0Nc24a4/0zww9xMpZTUCCfbyneO1TitZO1e3q1F9LqoK0R85ifuRWgzsXP4
0lbABV6PPIa7bPSwjOEKZEKydjLiQQf8UciOQSZ/4vdcVT67e2iS800pG2yz/ep6
eUBGK3ICAdmcSGFrMFd0
=Kr6h
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--


--===============6955406086246777432==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6955406086246777432==--
