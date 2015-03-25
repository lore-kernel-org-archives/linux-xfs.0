Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AE66D7F50
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 01:03:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6DB5E8F8096
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 23:03:51 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	IahJ3QUuybWkstS4 for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 23:03:48 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1YaeKp-0005QE-0e
	for xfs@oss.sgi.com; Wed, 25 Mar 2015 16:58:35 +1100
Date: Wed, 25 Mar 2015 16:58:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to a448f8f
Message-ID: <20150325055834.GX28621@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6876013429942042092=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============6876013429942042092==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

a448f8f Merge branch 'fallocate-insert-range' into for-next

New Commits:

Byoungyoung Lee (1):
      [20dafee] xfs: xfs_mru_cache_insert() should use GFP_NOFS

Dave Chinner (9):
      [95afcf5] xfs: clean up inode locking for RENAME_WHITEOUT
      [445883e] xfs: cleanup xfs_rename error handling
      [310606b] xfs: factor out xfs_finish_rename()
      [eeacd32] xfs: make xfs_cross_rename() complete fully
      [7dcf5c3] xfs: add RENAME_WHITEOUT support
      [d41bb03] Merge branch 'xfs-rename-whiteout' into for-next
      [d64588c] xfs: remove xfs_bmap_sanity_check()
      [2b93681] Merge branch 'xfs-misc-fixes-for-4.1-2' into for-next
      [a448f8f] Merge branch 'fallocate-insert-range' into for-next

Eric Sandeen (1):
      [b26384d] xfs: fix NULL pointer dereference in xfs_filestream_lookup_=
ag()

Fabian Frederick (2):
      [86aaf02] xfs: use bool instead of int in xfs_rename()
      [29916df] xfs: fix shadow warning in xfs_da3_root_split()

Joe Perches (1):
      [5e9383f] xfs: Fix incorrect positive ENOMEM return

Namjae Jeon (2):
      [dd46c78] fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
      [a904b1c] xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate

Scott Wood (1):
      [65dd297] xfs: %pF is only for function pointers


Code Diffstat:

 fs/open.c                    |   8 +-
 fs/xfs/libxfs/xfs_bmap.c     | 388 ++++++++++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_bmap.h     |  13 +-
 fs/xfs/libxfs/xfs_da_btree.c |   8 +-
 fs/xfs/xfs_bmap_util.c       | 131 ++++++++++----
 fs/xfs/xfs_bmap_util.h       |   2 +
 fs/xfs/xfs_error.c           |   2 +-
 fs/xfs/xfs_file.c            |  41 ++++-
 fs/xfs/xfs_filestream.c      |   2 +-
 fs/xfs/xfs_inode.c           | 408 +++++++++++++++++++++++++--------------=
----
 fs/xfs/xfs_iops.c            |   2 +-
 fs/xfs/xfs_mru_cache.c       |   2 +-
 fs/xfs/xfs_super.c           |   2 +-
 fs/xfs/xfs_trace.h           |  21 +--
 include/linux/falloc.h       |   6 +
 include/uapi/linux/falloc.h  |  17 ++
 16 files changed, 747 insertions(+), 306 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVEk6KAAoJEK3oKUf0dfod/nMP/2Q4A9viBM4t1wk/EDLKVorA
CAQWwWm7fU6Bzf75WremdzYeYFfS15K4abatzrAnxgdS1fWIlym2IZNRBGR/SHli
8PW2aLKOBTN7kgn9b4B02zrWF8NSr2H/pwAvH9ja80n9rdgx9ZWgZqBPzMKpmkM2
cgG0HLaeGOVuqvfNaMjWuzU5rbKkGHQIhYs2KBNECwCWQfhw998hESKt8DLbHODt
k0uC/YNva6jIoMT1qu0pB4cXYIG3p1P4XjqM+lCtjsUMtJ4JMxZYjJj42yvqY8sX
s1tuw+EtccgGd/Q4yIo8ey/lQB/I3HVsCc1AmQXsln6cXdhfCxP9b2tdBdd0Zhv1
DhfVi6Lb/A2lMl7PJW7T+t4zz7TUWyBMc4c3lnjJmgk7EBkzC7K9tCbgehNrWuc8
pnP12FLaE20Ur8kS9AWxK4omt56EEmDUSwBntS1HF8oJ3mG+ou6HC/sHMVvoaL/3
chXmWurGCsp4cANO/sTb37ssNSMq8ObuhbcDJaRw05ATMNIW/gwrnMMYNtQbjKCa
FUiIOmzd2FmDScYhrjOjG9vz8QxAqSIMfZcmdNgjU27VUqgW8xhK7u9emdiW1Tx5
Loqfb+4O1yeWts0gq8hlaw08p9TNknx5Z7P179ZUE+TuJQBDHaWG3u73ADmb0zkl
TVp4d2XOGb7irYcZZqPc
=VjfA
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--


--===============6876013429942042092==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6876013429942042092==--
