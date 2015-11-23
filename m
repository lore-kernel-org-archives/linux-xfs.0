Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4200C7F37
	for <xfs@oss.sgi.com>; Sun, 22 Nov 2015 22:45:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0A5E48F8039
	for <xfs@oss.sgi.com>; Sun, 22 Nov 2015 20:45:09 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	128A51nZ99BDDkBw for <xfs@oss.sgi.com>;
	Sun, 22 Nov 2015 20:45:01 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1a0ize-0004qg-Ti
	for xfs@oss.sgi.com; Mon, 23 Nov 2015 15:44:46 +1100
Date: Mon, 23 Nov 2015 15:44:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: v4.3.0 released
Message-ID: <20151123044446.GL19199@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6337012905939582332=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============6337012905939582332==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jTMWTj4UTAEmbWeb"
Content-Disposition: inline


--jTMWTj4UTAEmbWeb
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repositories have just been updated and tagged with the
v4.3.0 release tag. It can be found here:

git://oss.sgi.com/xfs/cmds/xfsprogs.git v4.3.0
git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git v4.3.0

A signed gzipped-tar archive of the source code is available
here:

ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-4.3.0.tar.gz
ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-4.3.0.tar.gz.sign

The archive is signed with my gpg key (the same one that this
release announcement is signed with).

Many thanks go to all the contributors to this release. The sumary
of changes since v4.2.0 can be found listed in doc/CHANGES, which I
have reproduced in part below.

-Dave.

xfsprogs-4.3.0 (23 Nov 2015)
        - xfs_fsr: cleanups to recent changes (Eric Sandeen)
        - xfs_fsr: improved temp file attr fork handling (Eric Sandeen)
        - libxfs: output verifier names in warnings (Eric Sandeen)
        - xfs_repair: enable verifier corruption warnings on very verbose
          output settings (Eric Sandeen)
        - debian: update initramfs in postinst script (Steve McIntyre)

xfsprogs-4.3.0-rc2 (10 Nov 2015)
        - xfs_fsr: abstract mntinfo/mntent differences (Jan Tulak)
        - xfs_io: update reflink/dedupe ioctl definitions and implementation
          (Darrick Wong)
        - libxcmd: factoring of runtime reporting (Darrick Wong)
        - man page fixes (Ville Skytt=E4)
        - removal of ASSERT from exported headers

xfsprogs-4.3.0-rc1 (14 Oct 2015)
        - xfs_io: reflink and dedupe operation support (Darrick Wong)
        - xfs_db: blockget/blocktrash support for v5 filesystems
          (Darrick Wong)
        - xfs_repair: many directory/attr cleanups and fixes (Eric Sandeen)
        - More OS X build improvements (Jan Tulak)
        - Log zeroing rework for v5 filesystems to prevent log sequence
          numbers from going backwards (Brain Foster)


The new head of the master branch is commit:

2c909e1 xfsprogs: Release v4.3.0

New Commits since 4.3.0-rc2:

Dave Chinner (2):
      [a32546b] fsr: clean up mountpoint checks
      [2c909e1] xfsprogs: Release v4.3.0

Eric Sandeen (4):
      [7849d55] fsr: more tidy up work
      [e7e3152] fsr: more selinux fixes
      [a3fac93] libxfs: print name of verifier if it fails
      [23639f7] repair: print XFS_WANT_CORRUPTED info with -vvv

Steve McIntyre (1):
      [c8b04a6] debian: update initramfs in postinst


Code Diffstat:

 VERSION                     |  2 +-
 configure.ac                |  2 +-
 db/attr.c                   |  1 +
 db/dir2.c                   |  1 +
 db/metadump.c               |  3 +-
 debian/changelog            |  8 +++++
 debian/postinst             | 25 +++++++++++++
 doc/CHANGES                 | 10 +++++-
 fsr/xfs_fsr.c               | 87 +++++++++++++++++------------------------=
----
 include/xfs_mount.h         |  1 +
 libxfs/libxfs_io.h          |  1 +
 libxfs/libxfs_priv.h        | 23 +++++++++---
 libxfs/rdwr.c               |  5 +--
 libxfs/util.c               |  4 +--
 libxfs/xfs_alloc.c          |  2 ++
 libxfs/xfs_alloc_btree.c    |  1 +
 libxfs/xfs_attr_leaf.c      |  1 +
 libxfs/xfs_attr_remote.c    |  1 +
 libxfs/xfs_bmap_btree.c     |  1 +
 libxfs/xfs_da_btree.c       |  1 +
 libxfs/xfs_dir2_block.c     |  1 +
 libxfs/xfs_dir2_data.c      |  2 ++
 libxfs/xfs_dir2_leaf.c      |  2 ++
 libxfs/xfs_dir2_node.c      |  1 +
 libxfs/xfs_dquot_buf.c      |  1 +
 libxfs/xfs_ialloc.c         |  1 +
 libxfs/xfs_ialloc_btree.c   |  1 +
 libxfs/xfs_inode_buf.c      |  2 ++
 libxfs/xfs_sb.c             |  2 ++
 libxfs/xfs_symlink_remote.c |  1 +
 man/man8/xfs_repair.8       |  2 +-
 repair/xfs_repair.c         |  4 +++
 32 files changed, 132 insertions(+), 68 deletions(-)
 create mode 100644 debian/postinst
--=20
Dave Chinner
david@fromorbit.com

--jTMWTj4UTAEmbWeb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWUpm+AAoJEK3oKUf0dfodmA0P/1s9CgE2RDuZFAtUuc41AY3E
s4/7vc4y8vdNccEz/Jbz9kkTYJdEjon0wKcLo+pvYKXeaLcPqa5Y0VH/ywCoYxMz
WHgjL+IHXBFoQCi6agwXgdmD6hXe0NAyIUX376eh7HezDph5rvUK34gYHZG5zoCZ
s78gw7GnIFvw+F9YnOWgpNAkXaI074YhtkC5uJn7K7r7ufyMtEoEZGLhq+yO8y26
CLtkKqaQO2b1e7TiZHfw8O+yF344iPegYnEQicBL03u6LfTlW48mkOkIoo9L+Txc
EJ2XGgnMMwcIc/SSTQXsDCvOQN3H/zUGn1QNZ/yzwGEl71OndaswobZKaCNKMg2E
iWNFMOWYUBPTfwieCLHQTBWKWmPHpMUXyL0xSzb7fiCmlHyN+bxJKR2YI7Upezpp
F+YmLshs6ReYvl96l/KglNF4MHKMhdvKj73fRIW25VEW96N144hfYZECwVoi8vTq
w/l3NA50LunUBwAh0ch6QQNxQxTyHsu3jYssHnHo7BOPIsBBEph3yVinCQ6taCTv
YNqJAXQRv5bkfuxv6g1TVsd06G7Tom6LMUjcCoUwGDd5J6b0gfjz05iXRf6+vlFo
NYsjViLw1EZBS25zlNJKu7LZKs45bk3xcoLZvHbc/VUjjLv8Gm8chy9M8GCiN4dY
3UEZqD2l+vgsBf2f5PsU
=f5Af
-----END PGP SIGNATURE-----

--jTMWTj4UTAEmbWeb--


--===============6337012905939582332==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6337012905939582332==--
