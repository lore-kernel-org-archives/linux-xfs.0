Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36796 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967571AbdIZQ6K (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Sep 2017 12:58:10 -0400
Received: from Liberator-5.local (50-206-144-190-static.hfc.comcastbusiness.net [50.206.144.190])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B1FC28C0939
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2017 11:57:53 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v4.13.0 released
Message-ID: <9a968cc5-4dcf-400c-4132-9b2b4f24a1d8@sandeen.net>
Date: Tue, 26 Sep 2017 11:58:01 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fo8R3ncNrbpFTqhfV7G8tLO1bWN81OmMA"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fo8R3ncNrbpFTqhfV7G8tLO1bWN81OmMA
Content-Type: multipart/mixed; boundary="heDAwv1WUwjvsFSvVULkLKXtuGW1iVuWT";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <9a968cc5-4dcf-400c-4132-9b2b4f24a1d8@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v4.13.0 released

--heDAwv1WUwjvsFSvVULkLKXtuGW1iVuWT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v4.13.0 release.

Tarballs will be on kernel.org shortly.

There are no changes since v4.13.0-rc2; what follows is the
entire changelog since v4.12.0.

Patches often get missed, so please check if your outstanding
patches were in this release. If they have not been in this release,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

d7d22f7 xfsprogs: Release v4.13.0

New Commits:

Andreas Gruenbacher (1):
      [866d7fc] xfs_io: add seek consistency checks

Brian Foster (1):
      [2c6c632] libxfs: init ->b_maps on contig buffers for uncached comp=
atibility

Carlos Maiolino (1):
      [b4056fe] xfs_io: Print filesystem statfs flags in 'statfs' command=


Christoph Hellwig (4):
      [a9d26e4] xfs: remove XFS_HSIZE
      [baebed8] xfs: fixup xfs_attr_get_ilocked
      [7fb34b5] Revert "xfs: grab dquots without taking the ilock"
      [15a8bcc] xfs: fix multi-AG deadlock in xfs_bunmapi

Darrick J. Wong (37):
      [594956f] xfs: try to avoid blowing out the transaction reservation=
 when bunmaping a shared extent
      [f296858] xfs: optimize _btree_query_all
      [4a492e7] xfs: remove double-underscore integer types
      [e493253] xfs: always compile the btree inorder check functions
      [50bb67d] xfs: export various function for the online scrubber
      [4e388bc] xfs: plumb in needed functions for range querying of vari=
ous btrees
      [b5f6747] xfs: export _inobt_btrec_to_irec and _ialloc_cluster_alig=
nment for scrub
      [94ffb80] xfs: return the hash value of a leaf1 directory block
      [581ce8a] xfs: pass along transaction context when reading director=
y block buffers
      [b2d5ffd] xfs: pass along transaction context when reading xattr bl=
ock buffers
      [e2a190d] xfs: remove unneeded parameter from XFS_TEST_ERROR
      [cb0dc9b] xfs: grab dquots without taking the ilock
      [b8fb8c9] xfs: rename MAXPATHLEN to XFS_SYMLINK_MAXLEN
      [a6c6b1b] xfs: don't crash on unexpected holes in dir/attr btrees
      [c3d6d07] xfs: check _btree_check_block value
      [66d19ae] xfs: set firstfsb to NULLFSBLOCK before feeding it to _bm=
api_write
      [d705962] xfs: check _alloc_read_agf buffer pointer before using
      [f9f5e90] xfs: check that dir block entries don't off the end of th=
e buffer
      [14f8b68] xfsprogs: remove double-underscore integer types
      [5a707ca] xfs_repair: fix symlink target length checks by changing =
MAXPATHLEN to XFS_SYMLINK_MAXLEN
      [449df23] xfs_db: fix metadump redirection (again)
      [a05feed] xfs_db: dump dir/attr btrees
      [29b90b5] xfs_db: print attribute remote value blocks
      [89baf91] xfs_db: write values into dir/attr blocks and recalculate=
 CRCs
      [984af2e] xfs_db: introduce fuzz command
      [3540b41] xfs_db: btdump should avoid eval for push and pop of curs=
or
      [a749e25] xfs_db: reset metadump output flag
      [6a07c22] xfs_db: free field list when failing out of fuzz
      [ef209a9] xfs_db: make write/fuzz -c and -d work on non-crc filesys=
tems
      [592c101] xfs_db: bit fuzzing should read the right bit when flippi=
ng
      [2fc6b16] xfs_io: clarify the fsmap documentation
      [5d52e7a] xfs_repair: take the ag_lock before recording rmap for a =
bmbt record
      [9587a34] misc: fix more stupid compiler warnings
      [789eb52] libxfs: remove getcwd/chdir dance from initialization
      [99a13e2] mkfs: add documentation for forgotten mkfs flags
      [06b8035] mkfs: pass a custom cowextsize into the created filesyste=
m
      [85c9f7f] xfs_repair: handle missing extent states

Donald Douwsma (1):
      [9a106b5] mkfs.xfs: Don't stagger AG for a single disk

Eric Sandeen (8):
      [61a1556] xfs_db: associate proper type with free inode btree root
      [e66eae0] xfs_metadump: properly handle obfuscation of all remote a=
ttribute blocks
      [1e9c13c] xfs_db: use TYP_F_CRC_FUNC for inodes & dquots
      [fa9f6f1] xfs_bmap: fix -n documentation in manpage
      [459cadd] Merge branch 'libxfs-4.13-sync' into for-next
      [211bdc7] xfsprogs: Release v4.13.0-rc1
      [f462230] xfsprogs: Release v4.13.0-rc2
      [d7d22f7] xfsprogs: Release v4.13.0

Jan Tulak (1):
      [02c3e10] mkfs: add missing translation

Jeff Mahoney (4):
      [8d2666e] fsr: fix uninitialized fs usage after timeout
      [53dc81d] xfs_repair: clear pthread_t when pthread_create fails
      [e8ff627] xfs_repair: add prefetch trace calls to debug thread crea=
tion failures
      [b97ad96] xfs_repair: fix thread creation failure recovery

Masatake YAMATO (1):
      [67ea25f] xfs_repair: don't use do_warn for normal log message

Nikolay Borisov (6):
      [3d12c08] fiemap: Remove blocksize variable
      [05ef291] fiemap: Make max_extents a global var
      [cb404e2] fiemap: Eliminate num_extents
      [997bfca] fiemap: De-obfuscate last_logical and cur_extent manipula=
tion
      [abd0c76] fiemap: Factor out common code used for printing holes
      [e7eaace] fiemap: Fix semantics of max_extents (-n arguments)

Omar Sandoval (1):
      [ef54efb] xfs: fix inobt inode allocation search optimization

Ross Zwisler (1):
      [e13a325] xfs_io: allow lsattr & lsproj on foreign filesystems

Zirong Lang (1):
      [f810b1b] xfs_db: version command misses RMAPBT feature string


Code Diffstat:

 VERSION                     |   2 +-
 configure.ac                |   2 +-
 copy/xfs_copy.c             |  14 +-
 copy/xfs_copy.h             |   2 +-
 db/Makefile                 |   3 +-
 db/agi.c                    |   2 +-
 db/attr.c                   | 103 +++++++++-
 db/attr.h                   |   2 +
 db/attrshort.c              |   4 +-
 db/bit.c                    |  21 +-
 db/bit.h                    |   7 +-
 db/block.c                  |   8 +-
 db/btdump.c                 | 275 ++++++++++++++++++++++++--
 db/check.c                  |  20 +-
 db/command.c                |   2 +
 db/convert.c                |  28 +--
 db/dir2.c                   |  37 ++++
 db/dir2.h                   |   1 +
 db/dquot.c                  |  11 ++
 db/dquot.h                  |   1 +
 db/faddr.c                  |  14 +-
 db/field.c                  |  47 ++---
 db/field.h                  |   1 +
 db/fprint.c                 |   8 +-
 db/frag.c                   |   8 +-
 db/fuzz.c                   | 463 ++++++++++++++++++++++++++++++++++++++=
++++++
 db/fuzz.h                   |  21 ++
 db/inode.c                  |  45 +++--
 db/inode.h                  |   1 +
 db/io.c                     |  59 ++----
 db/io.h                     |   9 +-
 db/metadump.c               |  62 ++++--
 db/sb.c                     |   8 +-
 db/type.c                   |  60 ++++--
 db/type.h                   |   3 +
 db/write.c                  |  16 +-
 debian/changelog            |   6 +
 doc/CHANGES                 |  23 +++
 fsr/xfs_fsr.c               |  15 +-
 include/darwin.h            |  18 +-
 include/freebsd.h           |   6 +-
 include/gnukfreebsd.h       |   6 +-
 include/libxcmd.h           |   6 +-
 include/linux.h             |   8 +-
 include/xfs_arch.h          |  22 +--
 include/xfs_inode.h         |   4 +-
 include/xfs_log_recover.h   |   2 +-
 include/xfs_metadump.h      |   4 +-
 include/xfs_mount.h         |  22 +--
 io/attr.c                   |   2 +-
 io/fiemap.c                 | 174 ++++++++---------
 io/fsmap.c                  |   2 +
 io/open.c                   |   2 +-
 io/seek.c                   |  13 +-
 io/stat.c                   |   1 +
 libhandle/handle.c          |   2 +-
 libhandle/jdm.c             |   2 +-
 libxcmd/topology.c          |  14 +-
 libxfs/darwin.c             |   2 +-
 libxfs/defer_item.c         |   9 +-
 libxfs/freebsd.c            |   2 +-
 libxfs/init.c               |  18 +-
 libxfs/irix.c               |   2 +-
 libxfs/libxfs_io.h          |   1 +
 libxfs/libxfs_priv.h        |  11 +-
 libxfs/linux.c              |   2 +-
 libxfs/logitem.c            |   2 +-
 libxfs/radix-tree.c         |   8 +-
 libxfs/rdwr.c               |  16 +-
 libxfs/util.c               |  72 ++++++-
 libxfs/xfs_ag_resv.c        |   3 +-
 libxfs/xfs_alloc.c          |   8 +-
 libxfs/xfs_alloc.h          |   2 +
 libxfs/xfs_alloc_btree.c    |  26 +--
 libxfs/xfs_attr.c           |  28 ++-
 libxfs/xfs_attr_leaf.c      |   2 +-
 libxfs/xfs_attr_remote.c    |  13 +-
 libxfs/xfs_attr_sf.h        |  10 +-
 libxfs/xfs_bit.h            |  24 +--
 libxfs/xfs_bmap.c           |  74 +++++--
 libxfs/xfs_bmap.h           |   2 +-
 libxfs/xfs_bmap_btree.c     |  34 +++-
 libxfs/xfs_btree.c          |  58 +++---
 libxfs/xfs_btree.h          |  33 ++--
 libxfs/xfs_cksum.h          |  16 +-
 libxfs/xfs_da_btree.c       |  14 +-
 libxfs/xfs_da_btree.h       |   8 +-
 libxfs/xfs_da_format.c      |  28 +--
 libxfs/xfs_da_format.h      |  64 +++---
 libxfs/xfs_dir2.c           |   3 +-
 libxfs/xfs_dir2.h           |   8 +-
 libxfs/xfs_dir2_block.c     |   2 +-
 libxfs/xfs_dir2_data.c      |   4 +
 libxfs/xfs_dir2_leaf.c      |  18 +-
 libxfs/xfs_dir2_node.c      |  10 +-
 libxfs/xfs_dir2_priv.h      |  10 +-
 libxfs/xfs_dir2_sf.c        |   4 +-
 libxfs/xfs_format.h         | 113 +++++------
 libxfs/xfs_fs.h             |  16 +-
 libxfs/xfs_ialloc.c         |  55 +++---
 libxfs/xfs_ialloc.h         |   5 +
 libxfs/xfs_ialloc_btree.c   |  36 +++-
 libxfs/xfs_inode_buf.c      |   7 +-
 libxfs/xfs_inode_buf.h      |  31 +--
 libxfs/xfs_log_format.h     | 256 ++++++++++++------------
 libxfs/xfs_quota_defs.h     |   4 +-
 libxfs/xfs_refcount.c       |  20 +-
 libxfs/xfs_refcount.h       |  16 ++
 libxfs/xfs_refcount_btree.c |  12 +-
 libxfs/xfs_rmap.c           |  14 +-
 libxfs/xfs_rmap.h           |  11 +-
 libxfs/xfs_rmap_btree.c     |  34 ++--
 libxfs/xfs_rtbitmap.c       |   4 +-
 libxfs/xfs_sb.c             |   4 +-
 libxfs/xfs_symlink_remote.c |   2 +-
 libxfs/xfs_trans_resv.c     |   4 +-
 libxfs/xfs_types.h          |  46 ++---
 logprint/log_misc.c         |   6 +-
 man/man8/mkfs.xfs.8         |  29 +++
 man/man8/xfs_bmap.8         |   5 +-
 man/man8/xfs_db.8           |  88 ++++++++-
 man/man8/xfs_io.8           |   7 +-
 mdrestore/xfs_mdrestore.c   |   2 +-
 mkfs/proto.c                |   2 +-
 mkfs/xfs_mkfs.c             | 102 ++++++----
 quota/edit.c                |  64 +++---
 quota/free.c                |  44 ++---
 quota/quot.c                |  24 +--
 quota/quota.c               |   4 +-
 quota/quota.h               |  12 +-
 quota/report.c              |   4 +-
 quota/state.c               |   2 +-
 quota/util.c                |  66 +++----
 repair/README               |   2 +-
 repair/agheader.h           |  14 +-
 repair/attr_repair.h        |  26 +--
 repair/avl64.c              |  38 ++--
 repair/avl64.h              |  18 +-
 repair/dinode.c             |  51 ++---
 repair/dinode.h             |   4 +-
 repair/dir2.c               |   2 +-
 repair/globals.h            |  18 +-
 repair/incore.c             |  10 +-
 repair/incore.h             |  46 ++---
 repair/incore_ext.c         |   6 +-
 repair/incore_ino.c         |  72 +++----
 repair/phase2.c             |   4 +-
 repair/phase3.c             |   6 +-
 repair/phase4.c             |   4 +-
 repair/phase5.c             |  28 +--
 repair/phase6.c             |  20 +-
 repair/phase7.c             |   6 +-
 repair/prefetch.c           |  49 ++++-
 repair/progress.c           |  30 +--
 repair/progress.h           |   4 +-
 repair/rmap.c               |  18 +-
 repair/rmap.h               |   2 +-
 repair/sb.c                 |  24 +--
 repair/scan.c               |  53 ++---
 repair/scan.h               |  12 +-
 repair/xfs_repair.c         |   2 +-
 161 files changed, 2709 insertions(+), 1386 deletions(-)
 create mode 100644 db/fuzz.c
 create mode 100644 db/fuzz.h



--heDAwv1WUwjvsFSvVULkLKXtuGW1iVuWT--

--fo8R3ncNrbpFTqhfV7G8tLO1bWN81OmMA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJZyocgAAoJECCuFpLhPd7gah8P/0Xv9Fje1Nk7kcSJBYtcaHbt
9lXE3pDy2qEeA8WXmDdFzOr/mipKRv+VwjP/JOYbWrEFem/3fGVj1VhLmm7A12Ce
qUUCDZOY6Sa2ZJnrM1K1rR06EyUnb5YBU8VHbeFy68YkO8Vbp2egeLBO8LN751rY
N921gpyv69BEEH3wmwIj/9PpZokeRgHZEMww2AaofbRp4xAKg3qn0CaCskWBeP5d
eVzDtiUS+PuXnDVVyzo7F9XLS4CfxjmttfmTysG8JJce0Ve78iBf4azcUO523E+d
5ZqqYA+3F3vxbGefGWwHjNDlfY6+Z0I7ytw/VPx4NclMZzIN0JSt0mlklbvxsZrq
EYbXSybpaHq4dpElFvgOt8GEbxxoADBW4I1Alcd5vd4YCpruI2beXzUnaplPpSud
kP22KPTt7B4CbSXhu0AoVY9ZVSzovjZHVyR8t+BHSksKI4LPqUqYeyD0htamtjbo
g8UtDm5pgFaT8BSvyXBXs0xWTNZExoXXFgj8QA0T6Al1UqBeZ7aQUt1FnH+euA7f
fAqeATBNc7tzCdCNewk58XkBtzFSfo9/QsQKR42QZAKuvy742V8TT96JsgwwHq/C
Cxvum9l4mHzyMdPC9kaRQI1dWdvC5sn1t3c/W3/ugT++u6SIZS3CgcQ+cUZWL6OS
cDNQxrpUPG4f49Uahtdv
=BDt+
-----END PGP SIGNATURE-----

--fo8R3ncNrbpFTqhfV7G8tLO1bWN81OmMA--
