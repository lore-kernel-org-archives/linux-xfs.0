Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35848 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752846AbeDLVj1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Apr 2018 17:39:27 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E1AE44872F4
        for <linux-xfs@vger.kernel.org>; Thu, 12 Apr 2018 16:38:40 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-4.16.0-rc1 released
Message-ID: <9673fe5a-6350-e469-28c3-7427af1bba18@sandeen.net>
Date: Thu, 12 Apr 2018 16:39:25 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="o5C6JxwUXHdJvzctEchZhk3RiMaBqbPHI"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--o5C6JxwUXHdJvzctEchZhk3RiMaBqbPHI
Content-Type: multipart/mixed; boundary="I9AoL4qx7WSLIeHaR99S0NGH8dnuLB0Gm";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <9673fe5a-6350-e469-28c3-7427af1bba18@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-4.16.0-rc1 released

--I9AoL4qx7WSLIeHaR99S0NGH8dnuLB0Gm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The master branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v4.16.0-rc1

Here's the condensed version of notable changes; full changelog
since prior version is below.

xfsprogs-4.16.0-rc1 (12 Apr 2018)
        - platforms: warn of impending deprecation of irix, freebsd, darw=
in
        - mkfs.xfs : enable sparse inodes by default (Darrick Wong)
        - fsck.xfs: allow forced boot-time repairs using xfs_repair (Jan =
Tulak)
        - xfs_repair: new -e flag alters exit code for fixed errors (Jan =
Tulak)
        - xfs_repair: fix to allow zeroing of corrupt log (Xiao Yang)
        - xfs_repair: remove old dead code (Eric Sandeen)
        - xfs_io: fix operation time reporting (Dave Chinner)
        - xfs_io: add RWF_DSYNC support to pwrite (Dave Chinner)
        - xfs_io: support a basic extent swap command (Brian Foster)
        - xfs_scrub: Many updates, still experimental (Darrick Wong)
        - xfs_db: print transaction reservation type information
        - libxfs: framework to detect memory leaks (Eric Sandeen)
        - misc: Fix up new warnings from gcc 7.3 (Darrick Wong)
        - misc: enable link time optimization, if requested (Darrick Wong=
)
        - misc: enable retpolines across all xfsprogs utilities (Darrick =
Wong)

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

6ae62d7 xfsprogs: Release v4.16.0-rc1

New Commits:

Baruch Siach (2):
      [40b2e29] workqueue: add missing pthreads header
      [e2bc34d] xfs_scrub: add missing paths header

Brian Foster (9):
      [12382cd] xfs: include inobt buffers in ifree tx log reservation
      [727b445] xfs: fix up agi unlinked list reservations
      [ec1b0fd] xfs: truncate transaction does not modify the inobt
      [2025cb0] xfs: include an allocfree res for inobt modifications
      [0b98035] xfs: refactor inode chunk alloc/free tx reservation
      [0197075] xfs: eliminate duplicate icreate tx reservation functions=

      [8504509] xfs: account finobt blocks properly in perag reservation
      [b09294b] xfs: cancel tx on xfs_defer_finish() error during xattr s=
et/remo
      [57e7138] xfs_io: support a basic extent swap command

Carlos Maiolino (1):
      [37d086c] Split buffer's b_fspriv field

Colin Ian King (1):
      [dfcfc5f] xfs: fix check on struct_version for versions 4 or greate=
r

Darrick J. Wong (68):
      [ecdc52f] xfs: remove XFS_FSB_SANITY_CHECK
      [fb75464] xfs: refactor long-format btree header verification routi=
nes
      [bb2a125] xfs: refactor short form btree pointer verification
      [a7e32f0] xfs: remove XFS_WANT_CORRUPTED_RETURN from dir3 data veri=
fiers
      [7e6c95f] xfs: refactor xfs_verifier_error and xfs_buf_ioerror
      [bc01119] xfs: have buffer verifier functions report failing addres=
s
      [1e69795] xfs: refactor verifier callers to print address of failin=
g check
      [9870340] xfs: verify dinode header first
      [ad42e5a] xfs: move inode fork verifiers to xfs_dinode_verify
      [c7a710b] xfs: create structure verifier function for shortform xat=
trs
      [6db3a80] xfs: create structure verifier function for short form sy=
mlinks
      [1f98251] xfs: refactor short form directory structure verifier fun=
ction
      [20e882d] xfs: provide a centralized method for verifying inline fo=
rk data
      [e9998c6] xfs: fail out of xfs_attr3_leaf_lookup_int if it looks co=
rrupt
      [95d9582] xfs: create a new buf_ops pointer to verify structure met=
adata
      [055b84e] xfs: separate dquot repair into a separate function
      [71ffd55] xfs: standardize quota verification function outputs
      [079e8ef] xfs: trace log reservations at mount time
      [a2a5238] xfs: hoist xfs_fs_geometry to libxfs
      [fdef0e8] xfs: refactor the geometry structure filling function
      [493b46c] xfs: harden directory integrity checks some more
      [ef4109d] xfs: change 0x%p -> %p in print messages
      [d7e7160] xfs: use %px for data pointers when debugging
      [1fe41a7] xfs: add scrub cross-referencing helpers for the free spa=
ce btre
      [9deb7f6] xfs: add scrub cross-referencing helpers for the inode bt=
rees
      [556c739] xfs: add scrub cross-referencing helpers for the rmap btr=
ees
      [1048d0e] xfs: add scrub cross-referencing helpers for the refcount=
 btrees
      [221b1dd] xfs: cross-reference the realtime bitmap
      [b67317e] xfs: directory scrubber must walk through data block to o=
ffset
      [f596a90] xfs: attr leaf verifier needs to check for obviously bad =
count
      [e4b963e] xfs: btree format ifork loader should check for zero numr=
ecs
      [faaad1d] xfs: recheck reflink / dirty page status before freeing C=
oW rese
      [e91df84] xfs: check sb_agblocks and sb_agblklog when validating su=
perbloc
      [1d3bac1] xfs: refactor inode verifier corruption error printing
      [3cb6881] xfs: refactor accounting updates out of xfs_bmap_btalloc
      [d07cc72] xfs: treat CoW fork operations as delalloc for quota acco=
unting
      [c38464f] xfs: don't screw up direct writes when freesp is fragment=
ed
      [ffe5df5] xfs: fix u32 type usage in sb validation function
      [1b0adc7] misc: enable retpolines across all xfsprogs utilities
      [e61f155] misc: enable link time optimization, if requested
      [a93fcc0] misc: fix gcc 7.3 warnings
      [de24d64] xfs_db: don't crash in ablock if there's no inode
      [7c30915] xfs_scrub: log operational messages when interactive
      [c767c5a] xfs_scrub: don't ask user to run xfs_repair for only warn=
ings
      [a440f87] xfs_scrub: fix #include ordering to avoid build failure
      [e24ee6b] xfs_scrub: don't try to scan xattrs if bstat says there a=
ren't a
      [ad9ac92] xfs_db: print transaction reservation type information
      [12ac6e0] xfs_repair: don't fail directory repairs when grabbing in=
odes
      [3452f45] xfs_repair: implement custom ifork verifiers
      [be66eb8] libfrog: fs_table_lookup_mount should realpath the argume=
nt
      [938f7b7] xfs_fsr: refactor mountpoint finding to use libfrog paths=
 functi
      [9cf846b] mkfs: enable sparse inodes by default
      [19177e6] xfs_spaceman: remove incorrect linux/fs.h include
      [99ea301] xfs_scrub: avoid buffer overflow when scanning attributes=

      [55290cf] xfs_scrub: only run ascii name checks if unicode name che=
cker
      [d2cf5c2] xfs_scrub: don't complain about different normalization
      [95c2f78] xfs_scrub: communicate name problems via flagset instead =
of bool
      [3029a02] xfs_scrub: make name_entry a first class structure
      [bff5d1a] xfs_scrub: transition from libunistring to libicu for Uni=
code pr
      [baa9ed8] xfs_scrub: check name for suspicious characters
      [367db2f] xfs_scrub: use Unicode skeleton function to find confusin=
g names
      [5fa5a86] xfs_scrub: don't warn about confusing names if dir/file o=
nly wri
      [680eaca] xfs_scrub: refactor mountpoint finding code to use libfro=
g  path
      [3dd9147] xfs_scrub_all: report version
      [e4e022f] xfs_scrub: disable private /tmp for scrub service
      [07c6fd5] xfs_scrub_all: escape paths being passed to systemd servi=
ce inst
      [74aed9c] xfs_scrub_all: use system encoding for lsblk output decod=
ing
      [98884b6] xfs_repair: fix getsubopt name definitions to use enums

Dave Chinner (2):
      [d976382] xfs_io: add RWF_DSYNC support to pwrite
      [7459528] xfs_io: fix operation time reporting

Eric Sandeen (23):
      [fc9f709] libxfs: Replace XFS_BUF_SET_PTR with xfs_buf_associate_me=
mory
      [864028e] libxfs: add function to free all buffers in bcache
      [bf0e024] libxfs: move xfs_inode_zone to rdwr.c
      [4448849] libxfs: Catch non-empty zones on destroy
      [2ce8bff] xfsprogs: call libxfs_destroy from other utilities
      [f50eb2c] xfsprogs: new libxfs-apply option for Signed-off-by: tag
      [f8cd7da] xfs_repair: use custom ifork verifier in mv_orphanage
      [4aa3c02] metadump/restore: don't use errno after fwrite/fread fail=
ures
      [25992d9] xfs_scrub: synchronize error levels & logging
      [6d135e8] xfs_scrub: initialize movon in xfs_scrub_connections
      [8aee048] libfrog: handle NULL dir && blkdev in __fs_table_lookup_m=
ount
      [497d070] xfs_repair: remove unused fs_attributes_allowed
      [232470f] xfs_repair: remove unused fs_attributes2_allowed
      [99a1e0d] xfs_repair: remove unused fs_has_extflgbit_allowed
      [dd17791] xfs_repair: remove unused fs_aligned_inodes_allowed
      [644589b] xfs_repair: remove unused fs_sb_feature_bits_allowed
      [a425d16] xfs_repair: remove unused fs_has_extflgbit_allowed
      [ea94cb6] xfs_repair: remove unused fs_shared_allowed variable
      [42fa89b] xfs_repair: remove pre_65_beta option
      [28a4f9c] xfsprogs: remove unused delete_attr_ok
      [31506b3] xfs_repair: test XFS_SB_VERSION_SHAREDBIT only once
      [a8502cc] libxfs: warn about deprecation of irix, freebsd, darwin
      [6ae62d7] xfsprogs: Release v4.16.0-rc1

Goldwyn Rodrigues (1):
      [99d6e84] xfs_io: Add missing perror for write_once (-O)

Jan Tulak (2):
      [7c3e94a] xfs_repair: add flag -e to modify exit code for corrected=
 errors
      [04a2d5d] fsck.xfs: allow forced repairs using xfs_repair

Jeff Layton (1):
      [d5105a8] xfs: convert to new i_version API

Luis R. Rodriguez (1):
      [9d50331] xfs_scrub: make interpreter explicit to python3

Shan Hai (1):
      [885ba5c] xfs: bmap code cleanup

Xiao Yang (1):
      [a2e8105] xfs_repair: Add missing braces to allow zeroing of corrup=
t log


Code Diffstat:

 VERSION                     |   4 +-
 configure.ac                |  28 +-
 copy/xfs_copy.c             |   1 +
 db/attrset.c                |   6 +-
 db/bit.c                    |   4 +-
 db/block.c                  |   5 +
 db/command.c                |   1 +
 db/init.c                   |   2 +
 db/logformat.c              |  59 +++++
 db/logformat.h              |   1 +
 db/metadump.c               |   4 +-
 debian/control              |   2 +-
 debian/rules                |   4 +-
 doc/CHANGES                 |  17 ++
 fsck/xfs_fsck.sh            |  57 +++-
 fsr/Makefile                |   4 +-
 fsr/xfs_fsr.c               |  73 +-----
 include/builddefs.in        |  22 +-
 include/kmem.h              |   1 +
 include/path.h              |   1 +
 include/workqueue.h         |   2 +
 include/xfs_inode.h         |   5 +-
 io/Makefile                 |   4 +-
 io/init.c                   |   1 +
 io/io.h                     |   1 +
 io/pwrite.c                 |  12 +-
 io/swapext.c                | 107 ++++++++
 libfrog/paths.c             |  54 +++-
 libxcmd/input.c             |  16 +-
 libxfs/darwin.c             |   4 +
 libxfs/freebsd.c            |   4 +
 libxfs/init.c               |  42 +--
 libxfs/irix.c               |   4 +
 libxfs/kmem.c               |  14 +
 libxfs/libxfs_api_defs.h    |   4 +-
 libxfs/libxfs_io.h          |  16 +-
 libxfs/libxfs_priv.h        |  40 ++-
 libxfs/logitem.c            |   8 +-
 libxfs/rdwr.c               |  74 +++++-
 libxfs/trans.c              |  44 ++--
 libxfs/util.c               |  43 +++-
 libxfs/xfs_alloc.c          | 124 +++++----
 libxfs/xfs_alloc.h          |  10 +
 libxfs/xfs_alloc_btree.c    |  47 ++--
 libxfs/xfs_attr.c           |   4 -
 libxfs/xfs_attr_leaf.c      | 148 +++++++++--
 libxfs/xfs_attr_leaf.h      |   1 +
 libxfs/xfs_attr_remote.c    | 104 +++++---
 libxfs/xfs_bmap.c           | 120 ++++++---
 libxfs/xfs_bmap_btree.c     |  58 ++---
 libxfs/xfs_btree.c          | 117 +++++++--
 libxfs/xfs_btree.h          |  16 +-
 libxfs/xfs_da_btree.c       |  70 +++--
 libxfs/xfs_da_format.h      |   6 +
 libxfs/xfs_dir2.c           |   5 +-
 libxfs/xfs_dir2.h           |   2 +
 libxfs/xfs_dir2_block.c     |  39 +--
 libxfs/xfs_dir2_data.c      | 208 ++++++++-------
 libxfs/xfs_dir2_leaf.c      |  89 ++++---
 libxfs/xfs_dir2_node.c      |  89 ++++---
 libxfs/xfs_dir2_priv.h      |  12 +-
 libxfs/xfs_dir2_sf.c        |  30 +--
 libxfs/xfs_dquot_buf.c      | 174 ++++++-------
 libxfs/xfs_fs.h             |   7 +
 libxfs/xfs_ialloc.c         | 143 ++++++++--
 libxfs/xfs_ialloc.h         |   6 +
 libxfs/xfs_ialloc_btree.c   |  65 +++--
 libxfs/xfs_inode_buf.c      | 133 +++++++---
 libxfs/xfs_inode_buf.h      |   4 +-
 libxfs/xfs_inode_fork.c     | 152 ++++-------
 libxfs/xfs_inode_fork.h     |  14 +
 libxfs/xfs_log_rlimit.c     |   2 +-
 libxfs/xfs_quota_defs.h     |   9 +-
 libxfs/xfs_refcount.c       |  19 ++
 libxfs/xfs_refcount.h       |   3 +
 libxfs/xfs_refcount_btree.c |  40 +--
 libxfs/xfs_rmap.c           |  67 +++++
 libxfs/xfs_rmap.h           |   5 +
 libxfs/xfs_rmap_btree.c     |  40 +--
 libxfs/xfs_rtbitmap.c       |  21 ++
 libxfs/xfs_sb.c             | 113 +++++++-
 libxfs/xfs_sb.h             |   4 +
 libxfs/xfs_shared.h         |   4 +
 libxfs/xfs_symlink_remote.c |  75 ++++--
 libxfs/xfs_trans_resv.c     | 199 +++++++-------
 libxlog/xfs_log_recover.c   |   4 +-
 m4/Makefile                 |   2 +-
 m4/package_icu.m4           |   6 +
 m4/package_libcdev.m4       |  48 ++++
 m4/package_unistring.m4     |  19 --
 man/man8/fsck.xfs.8         |   7 +
 man/man8/xfs_db.8           |   6 +
 man/man8/xfs_io.8           |  15 +-
 man/man8/xfs_repair.8       |  22 +-
 man/man8/xfs_scrub.8        |   2 +-
 man/man8/xfs_scrub_all.8    |  10 +
 mdrestore/xfs_mdrestore.c   |  13 +-
 mkfs/xfs_mkfs.c             |   5 +-
 repair/dinode.c             |  14 +-
 repair/globals.h            |   2 -
 repair/phase2.c             |   3 +-
 repair/phase5.c             |   2 +-
 repair/phase6.c             |  72 +++++-
 repair/scan.c               |   1 +
 repair/versions.c           | 147 ++---------
 repair/versions.h           |  26 --
 repair/xfs_repair.c         |  75 +++---
 scrub/Makefile              |   9 +-
 scrub/bitmap.c              |   5 +-
 scrub/common.c              | 136 ++++------
 scrub/common.h              |  11 +-
 scrub/counter.c             |   2 +-
 scrub/disk.c                |   9 +-
 scrub/filemap.c             |   6 +-
 scrub/fscounters.c          |   5 +-
 scrub/inodes.c              |   4 +-
 scrub/phase1.c              |  25 +-
 scrub/phase2.c              |   5 +-
 scrub/phase3.c              |   5 +-
 scrub/phase4.c              |   6 +-
 scrub/phase5.c              |  46 ++--
 scrub/phase6.c              |   5 +-
 scrub/phase7.c              |   5 +-
 scrub/progress.c            |   4 +-
 scrub/read_verify.c         |   5 +-
 scrub/scrub.c               |   6 +-
 scrub/spacemap.c            |   5 +-
 scrub/unicrash.c            | 616 +++++++++++++++++++++++++++++++++-----=
------
 scrub/unicrash.h            |   4 +-
 scrub/vfs.c                 |   4 +-
 scrub/xfs_scrub.c           |  50 ++--
 scrub/xfs_scrub.h           |   4 +-
 scrub/xfs_scrub@.service.in |   3 +-
 scrub/xfs_scrub_all.in      |  39 ++-
 spaceman/trim.c             |   1 -
 tools/libxfs-apply          |  17 +-
 136 files changed, 3248 insertions(+), 1688 deletions(-)
 create mode 100644 io/swapext.c
 create mode 100644 m4/package_icu.m4
 delete mode 100644 m4/package_unistring.m4


--I9AoL4qx7WSLIeHaR99S0NGH8dnuLB0Gm--

--o5C6JxwUXHdJvzctEchZhk3RiMaBqbPHI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlrP0g4ACgkQIK4WkuE9
3uD8QQ//VHddhxY8ifslwpRPGYz8vOnEPFoBSig2orFbehXQ35DgWlFwmGU9LSXT
sswKEpU38Jw/PwVyqBbrUeqwmHTOk0H7mZWR9bgWHIFQL99xC1ACUuMOQvw8nWpd
Un+UdKqcG9wcBlTAK77L8ES+/urVhbf1Lre+6LQXe3eb3JvGzWY0/Knv9/qy60Fw
CQczufR8VQNlte6zD9ac9o4t4NRyqRfhkG9iHpEaEZ6ajh5AYS9Nu81BDSW4UPm+
MHhgrJV6ckOfFYnbHjMbLNqr9xrg3piLHcwogQQTbCQj7cNZbAX32nuxNSKPvn0h
T/OfTbrV65YSQyLmpRAcYmdRy/CGAPnBpP7zJdRT8MwaLPtZQ/pZ3TZcgnJswMYc
7LZhWnPkAMG/QZx2Uwoe8hQaIV6yaAMm+yzTIBFHmC9fmJ6aILu5b3nIR+wSlm2a
PEVbr6zelinmVsn4OF7GzwOcRp/0rCmIO2J8nHmFDjIQXyT007Eemm76iK/cz+zx
EAee+qO5rTsYGj2MFDQTtRVZP6QTQg2edsbxBZGzT6Ed3xCBVlbMg2CqfJPuEOof
+7rlI7ItxP4v9uGVO2M1/urxnSfp1MM6CQYbaBWP0WQa88hHoOSiiKVCAy43bHtl
asfivvVY5jgA7yxUVGhBPIH1ZCtPlPuDwJHCfbH77f18Wz2HbDc=
=rXd0
-----END PGP SIGNATURE-----

--o5C6JxwUXHdJvzctEchZhk3RiMaBqbPHI--
