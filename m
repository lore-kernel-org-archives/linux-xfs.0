Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6D1E529E04
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2015 23:07:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5B87E304039
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2015 21:07:08 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	3j3kukXIZKvMG8aV for <xfs@oss.sgi.com>;
	Mon, 02 Nov 2015 21:07:06 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1ZtTo4-0003xT-AS
	for xfs@oss.sgi.com; Tue, 03 Nov 2015 16:06:52 +1100
Date: Tue, 3 Nov 2015 16:06:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch rebased and updated to 264e89a
Message-ID: <20151103050652.GC19199@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1756378757853594926=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============1756378757853594926==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UFHRwCdBEJvubb2X"
Content-Disposition: inline


--UFHRwCdBEJvubb2X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated. I rebased the xfs-misc-fixes-for-4.4-2 branch
to fix the ACL build issue and added Andreas' and Darrick's bug
fixes, and so the for-next branch has rebased as well. This update
also includes all the DAX fixes queued up for 4.4.

-Dave.

The new head of the for-next branch is commit:

264e89a Merge branch 'xfs-dax-updates' into for-next

New Commits:

Andreas Gruenbacher (3):
      [86a21c7] xfs: Validate the length of on-disk ACLs
      [09cb22d] xfs: Plug memory leak in xfs_attrmulti_attr_set
      [47e1bf6] xfs: invalidate cached acl if set via ioctl

Brian Foster (1):
      [67d8e04] xfs: invalidate cached acl if set directly via xattr

Darrick J. Wong (1):
      [af3b638] xfs: don't leak uuid table on rmmod

Dave Chinner (9):
      [3e12dbb] xfs: fix inode size update overflow in xfs_map_direct()
      [3fbbbea] xfs: introduce BMAPI_ZERO for allocating zeroed extents
      [1ca1915] xfs: Don't use unwritten extents for DAX
      [01a155e] xfs: DAX does not use IO completion callbacks
      [3af4928] xfs: add ->pfn_mkwrite support for DAX
      [13ad4fe] xfs: xfs_filemap_pmd_fault treats read faults as write faul=
ts
      [fc0561c] xfs: optimise away log forces on timestamp updates for fdat=
async
      [2da5c4b] Merge branch 'xfs-misc-fixes-for-4.4-2' into for-next
      [264e89a] Merge branch 'xfs-dax-updates' into for-next

Jiri Kosina (1):
      [24ba16b] xfs: clear PF_NOFREEZE for xfsaild kthread


Code Diffstat:

 fs/dax.c                   |  5 +++
 fs/xfs/libxfs/xfs_alloc.c  | 10 ++++-
 fs/xfs/libxfs/xfs_alloc.h  |  8 ++--
 fs/xfs/libxfs/xfs_bmap.c   | 35 ++++++++++++++++-
 fs/xfs/libxfs/xfs_bmap.h   | 13 ++++++-
 fs/xfs/libxfs/xfs_format.h |  8 +++-
 fs/xfs/xfs_acl.c           | 13 ++++---
 fs/xfs/xfs_acl.h           |  3 ++
 fs/xfs/xfs_aops.c          | 96 ++++++++++++++++++++++++------------------=
----
 fs/xfs/xfs_aops.h          |  3 +-
 fs/xfs/xfs_bmap_util.c     | 36 +++++++++++++++++
 fs/xfs/xfs_file.c          | 85 +++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_inode.c         |  2 +
 fs/xfs/xfs_inode_item.c    |  1 +
 fs/xfs/xfs_inode_item.h    |  1 +
 fs/xfs/xfs_ioctl.c         | 15 +++++++-
 fs/xfs/xfs_iomap.c         | 21 +++++++++-
 fs/xfs/xfs_mount.c         | 10 +++++
 fs/xfs/xfs_mount.h         |  4 ++
 fs/xfs/xfs_super.c         |  1 +
 fs/xfs/xfs_trace.h         |  1 +
 fs/xfs/xfs_trans_ail.c     |  1 +
 fs/xfs/xfs_trans_inode.c   |  9 +++++
 fs/xfs/xfs_xattr.c         | 31 ++++++++++++++-
 24 files changed, 331 insertions(+), 81 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--UFHRwCdBEJvubb2X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWOEDrAAoJEK3oKUf0dfodd9YP/iLeW2oVitZhob9fK3idws3U
8adrLkEZJEHp1QAfF9/yDK1oTGSCBrjBZmAUyCOUpYg1qQCrMn2hXRiRVF8rZbAI
EiHXckneXuZ/jsuAKOayThwa/ZXmv8DWdWGRUlfTpzzhvywqYOO1R3keSxb7jiTA
XEY+GjERewLwsEENPnSwbaYzmN/1KD5YSZn6fiBAsoG5LjnCx2MtcAZbTCZeXn4K
ODS0dmTEzqircgTfHi+epq9OLfIYycwLH1LbJ+as+ykCFufoqvRrUt6ot0EXoBac
jaziDo2PjYfRQG3jV7qfiK7wIdAp6t8RgkFgbssKGchbIk9lBU/EJRw8RlyZahT4
fQLrNDQdrKZBylHOa+fvVK+A8kQBo1GLIibS1zsukTHQx2H0yyxrRLe+eRVgb0H2
BMgUt5g6j0yMwTFh2+T51dGqz9dws4v2O35E8AEp5mphqkHSCoRpankgtQ3FY0Yr
VnSrjyy0L0YIaDILlqXT9axrT2qUmV1JTstadIVTBOZSVLAIqbkib0FC0F08NhMw
ZbOmzweYZyaOduCGzN0J7BGPMAm6arg3zSCjmN8364/Rd7+yxAf+y89xGvVJxLfD
r8Uki01od32pbWQyIp7EILz7ULLz9d9tkWhwMKVEDtASzmMFoQfjxe4Ete75Pa4M
s5ZNJ+Jm3sOCx7IVRQ16
=47T0
-----END PGP SIGNATURE-----

--UFHRwCdBEJvubb2X--


--===============1756378757853594926==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1756378757853594926==--
