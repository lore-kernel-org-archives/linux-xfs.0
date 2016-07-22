Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 35B127CA1
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 23:23:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 907FCAC004
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 21:23:41 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	HclIKWE9UmdNEdj3 for <xfs@oss.sgi.com>;
	Thu, 21 Jul 2016 21:23:38 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1bQRzs-00063U-38
	for xfs@oss.sgi.com; Fri, 22 Jul 2016 14:23:36 +1000
Date: Fri, 22 Jul 2016 14:23:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to f2bdfda
Message-ID: <20160722042336.GQ16044@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2275935377492440586=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============2275935377492440586==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5I6of5zJg18YgZEa"
Content-Disposition: inline


--5I6of5zJg18YgZEa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

f2bdfda Merge branch 'xfs-4.8-misc-fixes-4' into for-next

New Commits:

Arnd Bergmann (1):
      [f021bd0] xfs: remove dax code from object file when disabled

Brian Foster (1):
      [99579cc] xfs: skip dirty pages in ->releasepage()

Dave Chinner (5):
      [160ae76] libxfs: directory node splitting does not have an extra blo=
ck
      [b1c5ebb] xfs: allocate log vector buffers outside CIL context lock
      [28b783e] xfs: bufferhead chains are invalid after end_page_writeback
      [72ccbbe] xfs: remove EXPERIMENTAL tag from sparse inode feature
      [f2bdfda] Merge branch 'xfs-4.8-misc-fixes-4' into for-next


Code Diffstat:

 fs/xfs/libxfs/xfs_da_btree.c |  59 ++++++-----
 fs/xfs/xfs_aops.c            |  29 +++++-
 fs/xfs/xfs_buf_item.c        |   1 +
 fs/xfs/xfs_dquot.c           |   1 +
 fs/xfs/xfs_dquot_item.c      |   2 +
 fs/xfs/xfs_extfree_item.c    |   2 +
 fs/xfs/xfs_file.c            |   4 +-
 fs/xfs/xfs_inode_item.c      |   1 +
 fs/xfs/xfs_log_cil.c         | 258 ++++++++++++++++++++++++++++++++++-----=
-------
 fs/xfs/xfs_super.c           |   4 -
 fs/xfs/xfs_trans.h           |   1 +
 11 files changed, 259 insertions(+), 103 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--5I6of5zJg18YgZEa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXkZ/HAAoJEK3oKUf0dfodJBMP/36kCKl0SR0GLxyT2QlJmKS5
Ge7qEyOkwvrDZ1qNehdzAGOo2ntxidFThQhNk3JZzaCHTJsyLsdszW/BTMAGBdVu
vFZL7r85b9YkA/xDL0Dou21FE9E6fn30H2iOHGP5+tSNWWKTtw2xddKoQixbd6z2
tT62zz++Bex4F4LWJUtAA/pzvn/0WT27MVT4Irhw13JbHd7BhI3Wby0cfXrPt1iN
vVvsCHkJe8SamwRknacn/0xHCq4baYjAUmoue1/+G9DQ66mazv8j+XdL5Y/r3a+3
ImmQBJbw6ORxp5TfOhrPrr4QNA1C4sz8aAVsllSo5B/yroJhzvYZsqHJtTqyih90
L2NfuWrwnsmZOpv6JD1ygLavnM1/HZTTTz/eLLFfk8/HIR5gLTVRHYqB2MJ2d/uJ
qnSV+yUz/mfyEqRYNXmJSvtfa+r2fqwtOAWXi+NYGhw7bSKr97OOAfoaXaLujfmM
MiQSXNMKv9d+zUesnYBBlHAAbjScmZOPJFM2yUY9/WMTB1QmOOmH35/Ox2ak54Ui
YEY/5aLfpRZFlLvSdqadY39SInJpq/DX2kP9YX+hzhzDLNXSpHr3Ky34XDvT1L2o
R33zUiyR5aoI8CoF5OMABt6PpaYmODWwJxAe6CobvIzlo7xl6wHRlL3jegrB/3qE
LvXvgfPJA5pNSYlUshID
=iZYP
-----END PGP SIGNATURE-----

--5I6of5zJg18YgZEa--


--===============2275935377492440586==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2275935377492440586==--
