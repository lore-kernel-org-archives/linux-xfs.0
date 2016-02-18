Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A2FEC7F37
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 19:13:55 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 61D198F8039
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 17:13:55 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	457ePtDwsoedVwAO for <xfs@oss.sgi.com>;
	Wed, 17 Feb 2016 17:13:49 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1aWD9f-0007C2-Ct
	for xfs@oss.sgi.com; Thu, 18 Feb 2016 12:13:15 +1100
Date: Thu, 18 Feb 2016 12:13:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: for-next branch updated to e37bf53
Message-ID: <20160218011315.GK19486@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6248318390834361807=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============6248318390834361807==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aT9PWwzfKXlsBJM1"
Content-Disposition: inline


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Folks,

The for-next branch of the xfsprogs repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated. This start the next development cycle with
a libxfs kernel sync from the for-next branch of the kernel tree.

-Dave.

The new head of the master branch is commit:

e37bf53 xfs: mode di_mode to vfs inode

New Commits:

Christoph Hellwig (3):
      [410c3de] xfs: handle errors from ->free_blocks in xfs_btree_kill_iro=
ot
      [c261f8c] xfs: factor btree block freeing into a helper
      [08caf14] xfs: move buffer invalidation to xfs_btree_free_block

Dave Chinner (10):
      [f36349d] xfs: RT bitmap and summary buffers are not typed
      [a3d2294] xfs: RT bitmap and summary buffers need verifiers
      [138659f] xfs: introduce inode log format object
      [1bc6cbe] xfs: remove timestamps from incore inode
      [db17aeb] xfs: cull unnecessary icdinode fields
      [f089fc4] xfs: move v1 inode conversion to xfs_inode_from_disk
      [bcbe04c] xfs: use vfs inode nlink field everywhere
      [6652c25] xfs: move inode generation count to VFS inode
      [9abcc5c] xfs: move di_changecount to VFS inode
      [e37bf53] xfs: mode di_mode to vfs inode

Eric Sandeen (2):
      [43633a3] xfs: wire up Q_XGETNEXTQUOTA / get_nextdqblk
      [499b47f] xfs: remove unused function definitions


Code Diffstat:

 db/check.c                | 114 ++++++++++++++++----------------
 include/xfs_inode.h       |  45 ++++++++++++-
 libxfs/libxfs_api_defs.h  |   4 +-
 libxfs/rdwr.c             |   4 +-
 libxfs/util.c             |  60 ++++++-----------
 libxfs/xfs_alloc_btree.c  |   2 -
 libxfs/xfs_bmap.c         |   6 +-
 libxfs/xfs_bmap_btree.c   |   1 -
 libxfs/xfs_btree.c        |  32 ++++++---
 libxfs/xfs_dir2.c         |  12 ++--
 libxfs/xfs_ialloc_btree.c |  12 +---
 libxfs/xfs_inode_buf.c    | 169 +++++++++++++++++++++++++++++++-----------=
------
 libxfs/xfs_inode_buf.h    |  38 ++++++++++-
 libxfs/xfs_inode_fork.c   |   2 +-
 libxfs/xfs_log_format.h   |  19 +++---
 libxfs/xfs_quota_defs.h   |   3 +-
 libxfs/xfs_rtbitmap.c     |  32 ++++++++-
 libxfs/xfs_sb.h           |   1 -
 libxfs/xfs_shared.h       |   1 +
 logprint/log_misc.c       |   7 +-
 logprint/log_print_all.c  |  18 +++---
 mkfs/proto.c              |  12 ++--
 repair/phase6.c           |  58 ++++++-----------
 repair/phase7.c           |  43 ++++--------
 24 files changed, 400 insertions(+), 295 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--aT9PWwzfKXlsBJM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWxRqqAAoJEK3oKUf0dfod6JIP/03qM0OiGDkIevQ/d9qZYzuP
U3P3SwMvd65/myULRh1WfP3tyKsLulP/t5gJqewxNkF9VbwKM2p9+9xUsZy+6J3P
0gUsFRznFkdXRBBNQmULk+EMwGJg3u/vrEKQq9RpPF2EbZVlRSZIKM4ftIiUnxbV
i7/XnuVBLV2F/UC9wp++SiyjrnZ/G3Hc+6mNAOkBrLipOaXQLE8OpteeWm94PVLU
dP14CYsPMOcNwxTgCRnDdeEDdg6v+HYFwtK0dO6zSztQIw7x0RsayaocTVsvwIzM
huFgu3mRlgU23mBpmwGFVy0Kti6gQM4xQ51S9vxpVRMhf1Gu7nosi4V+VAVRS0U9
LsowL5Fv0d2pqtuuBFGccXl3kQVX+RH5KBC2KwYqNRsNXYG0bzXYcYjpBXaif+7R
GKTQEoBAaGhFRMULyoSxNghjQQ3B8fJ9ICieFbXJ4H4kvFJTcxE23ClAXTUkRgLV
RZFVlgVhvZWDsXBI2j1VSrQArudlncGgYQJWaR5wm4+Xg5cYxHSmDYsm0zZGxgua
/mBwx4ZdKBx7zdJkQKDVJFUxKhZ6XVdohKk3akpFNbiSKALZ6rpDqh8udCAqkdh9
g2tMWP5EJWU0ChLkhVHG7gOHTrpK/x/7fLQKxv+94d6F5siKJBo8OMxbRRVtN4+X
3Xd5/RVimL0td7b4KG8r
=+U+P
-----END PGP SIGNATURE-----

--aT9PWwzfKXlsBJM1--


--===============6248318390834361807==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6248318390834361807==--
