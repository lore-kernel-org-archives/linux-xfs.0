Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44506 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934658AbeFVTsI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Jun 2018 15:48:08 -0400
Received: from Liberator-5.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 77F688A
        for <linux-xfs@vger.kernel.org>; Fri, 22 Jun 2018 14:48:02 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-4.17.0-rc1 released
Message-ID: <4b1a2671-bc08-1d78-a7be-2eaa08bf2f0e@sandeen.net>
Date: Fri, 22 Jun 2018 14:48:05 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ZcwHUofx5iVkOGt6sGqwrW3wJNXO0wpIu"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZcwHUofx5iVkOGt6sGqwrW3wJNXO0wpIu
Content-Type: multipart/mixed; boundary="dag0uaqjy3wmzBmszugIggcwR2ny8zKaS";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <4b1a2671-bc08-1d78-a7be-2eaa08bf2f0e@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-4.17.0-rc1 released

--dag0uaqjy3wmzBmszugIggcwR2ny8zKaS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The master branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v4.17.0-rc1

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update^Wrelease cycle.

The new head of the master branch is commit:

803503c xfsprogs: Release v4.17.0-rc1

Abbreviated changelog follows with full changelog since v4.16.1
after that.

Note that mkfs config files didn't make it in - I can't merge a new
feature at least without any regression testing, and 4.17 is late enough
as it is, sadly.

CHANGELOG:

xfsprogs-4.17.0-rc1 (22 Jun 2018)
        - mkfs.xfs: only stat block devices during mkfs init (Eric Sandee=
n)
        - xfs_repair: multiple fixes and improvements (Darrick Wong)
        - xfs_repair: check and repair quota metadata (Eric Sandeen)
        - xfs_repair: fix shortform root inode parent (Marco Benatto)
        - xfs_db: don't ASSERT on unrecognized metadata (Carlos Maiolino)=

        - xfs_db: add superblock info command ala xfs_info (Darrick Wong)=

        - xfs_spaceman: add superblock info command ala xfs_info (Darrick=
 Wong)
        - xfs_info: call xfs_db for unmounted devices (Darrick Wong)
        - xfs_io: add online label command (Eric Sandeen)
        - xfs_io: add O_PATH and O_NOFOLLOW options (David Howells)
        - xfs_io: recognize *iB units in copy_range (Goldwyn Rodrigues)

New Commits:

Brian Foster (4):
      [65a15e0] xfs: rename agfl perag res type to rmapbt
      [9760cac] xfs: account only rmapbt-used blocks against rmapbt perag=
 res
      [8dbee8f] xfs: detect agfl count corruption and reset agfl
      [19fbb9d] xfs: clean up xfs_mount allocation and dynamic initialize=
rs

Carlos Maiolino (2):
      [97b3ffd] Cleanup old XFS_BTREE_* traces
      [a023e1a] xfs_db: Don't ASSERT on unrecognized metadata

Darrick J. Wong (40):
      [6da71a8] xfs: convert a few more directory asserts to corruption
      [15348e0] xfs: sanity-check the unused space before trying to use i=
t
      [0cf6a3a] xfs: refactor bmap record validation
      [b02a2c9] xfs: refactor inode verifier error logging
      [43f7ceb] xfs: refactor inode buffer verifier error logging
      [fd0c360] xfs: move inode extent size hint validation to libxfs
      [2949b46] xfs: don't accept inode buffers with suspicious unlinked =
chains
      [dee7606] xfs: don't fail when converting shortform attr to long fo=
rm duri
      [930af86] xfs_repair: examine all remote attribute blocks
      [41b465f] xfs_repair: don't leak buffer on xattr remote buf verifie=
r  erro
      [eb9cee6] xfs_repair: validate some of the log space information
      [d2be29d] xfs_repair: zap corrupt remote symlink
      [67a79e2] xfs_repair: treat zero da btree pointers as corruption
      [f9c559f] xfs_repair: invalidate dirty dir buffers when we zap a  d=
irector
      [bf67850] xfs_repair: only update in-core extent state after scanni=
ng full
      [3cc93dd] xfs_repair: don't crash if da btree is corrupt
      [7554707] xfs_repair: actually fix .. entries that point to inode z=
ero
      [8fec4f7] xfs_repair: check inode nsec for obviously garbage values=

      [369c0b5] xfs_repair: don't assert on bad '.' entry in no-modify mo=
de
      [fe08f67] libfrog: move platform specific runtime support code out =
of libx
      [96aaf9b] libfrog: refactor fs geometry printing function
      [ebc2e79] mkfs: use geometry generation / helper functions
      [172793e] xfs_db: add a superblock info command
      [6fb7087] xfs_spaceman: print a nicer message when file path isn't =
on xfs
      [6719d62] xfs_spaceman: add a superblock info command
      [3fda24e] xfs_info: move to xfs_spaceman
      [6750f2b] xfs_info: call xfs_db for offline filesystems
      [35f7c5b] xfs_growfs: refactor geometry reporting
      [7931f86] xfs_repair: fix integer handling issues
      [c2b571f] xfs_buflock: ignore if buffer already locked
      [ece9fa6] xfs_buflock: record line number of trace where we locked =
the buf
      [184798f] xfs_buflock: record buffer initialization
      [e3f20e6] fsck: fix more bashisms
      [6c05cc5] xfs_scrub: actually check for errors coming from close()
      [7856ed0] xfs_io: fix null pointer deref when complaining about scr=
ub comm
      [87a271c] xfs_db: handle realtime bitmap / summary files as text
      [cb1b013] xfs_io: fix signed comparison problem in copy_file_range
      [5480678] xfs_bmap: don't reject -e
      [27915b8] xfs_bmap: remove -c from manpage
      [c9a048f] xfs_io: clarify -c in bmap documentation

Dave Chinner (2):
      [b816550] xfs: convert XFS_AGFL_SIZE to a helper function
      [d206fcb] xfs: remove dead inode version setting code

David Howells (1):
      [fc52865] xfs_io: Allow -P and -L to be given to open for O_PATH an=
d  O_NO

Eric Sandeen (11):
      [1421de3] xfs: non-scrub - remove unused function parameters
      [4152dae] Merge branch 'libxfs-4.17-sync' into for-next
      [3060f26] xfs: enhance dinode verifier
      [7c4d311] xfs: set format back to extents if xfs_bmap_extents_to_bt=
ree
      [73b28e5] Merge branch 'libxfs-4.17-sync' into for-next
      [98c4a01] xfsprogs: be careful about what we stat in platform_check=
_mount
      [5857dce] xfs_repair: check and repair quota metadata
      [cfa10b0] xfs_io: add label command
      [585acbe] xfs_repair: fix libxfs api violations in quota repair cod=
e
      [14c57d5] mkfs.xfs: if either sunit or swidth is nonzero,  the othe=
r must=20
      [803503c] xfsprogs: Release v4.17.0-rc1

Goldwyn Rodrigues (1):
      [25b4549] xfs_io: Make copy_range arguments understand *iB values

Jeff Layton (1):
      [7c4889e] xfs_io: syncfs can fail

Marco Benatto (1):
      [77b3425] xfs_repair: Fix root inode's parent when it's bogus for s=
f direc


Code Diffstat:

 VERSION                          |   4 +-
 configure.ac                     |   2 +-
 db/Makefile                      |   2 +-
 db/agfl.c                        |   2 +-
 db/check.c                       |   6 +-
 db/command.c                     |   1 +
 db/command.h                     |   1 +
 db/freesp.c                      |   6 +-
 db/info.c                        |  74 +++++++++++++
 db/metadump.c                    |   2 +-
 db/print.c                       |   5 +-
 db/type.c                        |  12 +--
 debian/changelog                 |   6 ++
 doc/CHANGES                      |  13 +++
 fsck/xfs_fsck.sh                 |  12 +--
 growfs/Makefile                  |   2 -
 growfs/xfs_growfs.c              |  88 +---------------
 include/fsgeom.h                 |  24 +++++
 include/libxfs.h                 |   1 +
 include/xfs_mount.h              |  10 +-
 include/xfs_trace.h              |   2 +
 io/Makefile                      |   6 +-
 io/bmap.c                        |   1 +
 io/copy_file_range.c             |  30 +++---
 io/file.c                        |   6 +-
 io/init.c                        |   9 +-
 io/io.h                          |   3 +
 io/label.c                       | 108 +++++++++++++++++++
 io/open.c                        |  41 +++++++-
 io/scrub.c                       |   3 +-
 io/sync.c                        |   6 +-
 io/xfs_bmap.sh                   |   5 +-
 libfrog/Makefile                 |   5 +
 {libxfs =3D> libfrog}/darwin.c     |   0
 {libxfs =3D> libfrog}/freebsd.c    |   0
 libfrog/fsgeom.c                 |  82 +++++++++++++++
 {libxfs =3D> libfrog}/irix.c       |   0
 {libxfs =3D> libfrog}/linux.c      |  10 ++
 libxfs/Makefile                  |   3 -
 libxfs/libxfs_api_defs.h         |   9 ++
 libxfs/libxfs_priv.h             |  13 ++-
 libxfs/xfs_ag_resv.c             |  39 ++++---
 libxfs/xfs_ag_resv.h             |  31 ++++++
 libxfs/xfs_alloc.c               | 145 ++++++++++++++++++++++----
 libxfs/xfs_alloc.h               |   7 +-
 libxfs/xfs_alloc_btree.c         |   8 +-
 libxfs/xfs_attr.c                |   9 +-
 libxfs/xfs_bmap.c                |  58 +++++++++--
 libxfs/xfs_bmap.h                |   5 +-
 libxfs/xfs_bmap_btree.c          |   4 +-
 libxfs/xfs_bmap_btree.h          |  14 ---
 libxfs/xfs_btree.c               | 127 ++---------------------
 libxfs/xfs_btree.h               |  25 +----
 libxfs/xfs_dir2.h                |   2 +-
 libxfs/xfs_dir2_block.c          |  59 ++++++-----
 libxfs/xfs_dir2_data.c           |  78 ++++++++++----
 libxfs/xfs_dir2_leaf.c           |  13 ++-
 libxfs/xfs_dir2_node.c           |  16 ++-
 libxfs/xfs_format.h              |  13 +--
 libxfs/xfs_ialloc.c              |   2 +-
 libxfs/xfs_ialloc_btree.c        |  11 +-
 libxfs/xfs_inode_buf.c           | 145 ++++++++++++++++++++++++--
 libxfs/xfs_inode_buf.h           |   5 +
 libxfs/xfs_inode_fork.c          |  27 +++--
 libxfs/xfs_quota_defs.h          |   2 +
 libxfs/xfs_refcount.c            |  22 ++--
 libxfs/xfs_refcount_btree.c      |  10 +-
 libxfs/xfs_refcount_btree.h      |   3 +-
 libxfs/xfs_rmap.c                |   3 +-
 libxfs/xfs_rmap_btree.c          |  17 ++-
 libxfs/xfs_rmap_btree.h          |   2 +-
 libxfs/xfs_sb.c                  |  11 +-
 libxfs/xfs_trans_resv.c          |  10 +-
 man/man8/xfs_bmap.8              |   6 +-
 man/man8/xfs_db.8                |   8 ++
 man/man8/xfs_growfs.8            |  47 +--------
 man/man8/xfs_info.8              |  97 +++++++++++++++++
 man/man8/xfs_io.8                |  27 ++++-
 man/man8/xfs_spaceman.8          |   7 ++
 mkfs/xfs_mkfs.c                  |  61 ++++-------
 repair/agheader.c                |  12 +--
 repair/attr_repair.c             |   7 +-
 repair/da_util.c                 |   8 ++
 repair/dinode.c                  | 217 +++++++++++++++++++++++++++++++++=
++++--
 repair/dir2.c                    |  27 ++++-
 repair/globals.h                 |   3 +-
 repair/incore.h                  |   3 +
 repair/phase5.c                  |  20 ++--
 repair/phase6.c                  |  49 ++++++++-
 repair/rmap.c                    |   2 +-
 repair/sb.c                      |  28 +++++
 repair/scan.c                    |   6 +-
 repair/xfs_repair.c              |   2 +
 scrub/phase1.c                   |   6 +-
 scrub/phase3.c                   |  27 ++++-
 scrub/phase5.c                   |   8 +-
 scrub/phase6.c                   |  10 +-
 scrub/vfs.c                      |   4 +-
 spaceman/Makefile                |   4 +-
 spaceman/file.c                  |   7 +-
 spaceman/info.c                  |  96 +++++++++++++++++
 spaceman/init.c                  |   6 +-
 spaceman/space.h                 |   1 +
 {growfs =3D> spaceman}/xfs_info.sh |  14 ++-
 tools/xfsbuflock.py              |  22 +++-
 105 files changed, 1724 insertions(+), 656 deletions(-)
 create mode 100644 db/info.c
 create mode 100644 include/fsgeom.h
 create mode 100644 io/label.c
 rename {libxfs =3D> libfrog}/darwin.c (100%)
 rename {libxfs =3D> libfrog}/freebsd.c (100%)
 create mode 100644 libfrog/fsgeom.c
 rename {libxfs =3D> libfrog}/irix.c (100%)
 rename {libxfs =3D> libfrog}/linux.c (93%)
 create mode 100644 man/man8/xfs_info.8
 create mode 100644 spaceman/info.c
 rename {growfs =3D> spaceman}/xfs_info.sh (55%)


--dag0uaqjy3wmzBmszugIggcwR2ny8zKaS--

--ZcwHUofx5iVkOGt6sGqwrW3wJNXO0wpIu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlstUnYACgkQIK4WkuE9
3uBpOg//WtfH1GdeRs2894mBph3E3+f+1s1HqM+uqSKh4FbSHIBLWtSSomlzJTzX
4ZcB4MUuzafV38Heg0EWG/PpE/hM/fIfgMqhmFUQXhWBWHMariBSlp8YlE+WrMJ9
EhNR33O8QMRQdAkDMz4iZkhjcs4KmKHzGZt8SIosiS/v4vOKn+uXfKcRROw39w7j
dXW+ELoG9u/TCEzy3C/a/31d8AWYc+x4NtOcnX97moPdLcaaTOgo1CzRF41ws/T7
ayHz5UJxVRsRJxj2oLffkGIb8ncWocI+qq4WBxJGCO2VJVGq15qGyAyt3SAAiy5Z
588TjPb8gTd1B6sO/4eQH936GLRuSm5RzzIm07GUtE0wyE8mJpOyaTleLQD22KIz
e0mw1w7fTTilXIDYNj2bHKC7oKnnkaRhdfggnk8bcVNbHAu7CoZ2kr7gjH5V8ceS
9z9g14sxRNpgD6aprF1VbX1WTHvbfWOycgwskSDmRMdIMDeMTWTFgKugN6oUUWvm
M5pnsYwEMX9vD4UrvMUl5M9Rl76PzbWZxzxOnovMc870+/tvJnsU4GlEcQ8k+B8m
NJy2/4DBgPs0wTD9Or2XZD9vsjYrkDx1zV1iQgNVzl/2M8dOpUjyYUXViYJtKuto
6JE1zgvPbAIo2uF/Qs3B7WwQ6lXt77ouhRmIQ4xtqOzowxnGsJY=
=waBm
-----END PGP SIGNATURE-----

--ZcwHUofx5iVkOGt6sGqwrW3wJNXO0wpIu--
