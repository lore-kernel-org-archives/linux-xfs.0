Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227150250.yhjpksatwnaeowpd@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from sandeen.net ([63.231.237.45]:43980 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751221AbdBZU0x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 26 Feb 2017 15:26:53 -0500
Received: from [10.0.0.4] (erlite [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7B8AE2B2B
        for <linux-xfs@vger.kernel.org>; Sun, 26 Feb 2017 14:18:06 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: v4.10.0 released!
Message-ID: <c952b785-66e5-1959-77be-014ba5914c1b@sandeen.net>
Date: Sun, 26 Feb 2017 14:17:59 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XSCU5M7tkKVcVnm21t20DRapcsRAtm5Na"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XSCU5M7tkKVcVnm21t20DRapcsRAtm5Na
Content-Type: multipart/mixed; boundary="mGiJNXGhqD9J35ShEClRkPEXxpRAbBV16";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <c952b785-66e5-1959-77be-014ba5914c1b@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: v4.10.0 released!

--mGiJNXGhqD9J35ShEClRkPEXxpRAbBV16
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v4.10.0

This should be a relatively uneventful release, with fairlly minor
changes and updates to userspace utilities, along with the usual
libxfs syncup.  Changes I deemed worthy of CHANGELOG entries are:

	- build: fix __bitwise definitions vs kernel headers (Darrick Wong)
	- build: fix cross-compile (Gwendal Grignou)
	- remove old Irix support (Christoph Hellwig)
	- xfs_repair: various additional checks (Darrick Wong)
	- xfs_repair: document dirty log conditions (Darrick Wong)
	- xfs_repair: document exit codes (Zirong Lang)
	- xfs_io: fix building with musl (Ralph Sennhauser)
	- xfs_io: add set_encpolicy / get_encpolicy (Eric Biggers)
	- xfs_io: Fix command iteration (Dave Chinner)
	- xfs_io: fix missing syncfs command  (Amir Goldstein)
	- xfs_db: fix 'source' command when passed as a -c option (Darrick Wong)=

	- xfs_logprint: handle log operation split of inode item (Hou Tao)
	- xfs_metadump: ignore empty attribute leaf (Eric Sandeen)
	- libxfs: don't OOM on corrupt agcount (Darrick Wong)

The only change since v4.10.0-rc1 is a minor build from Darrick, first
item above.

Full commit list and diffstat since v4.9.0 is below.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

25babb5 xfsprogs: Release v4.10.0

New Commits:

Amir Goldstein (5):
      [3cfabff] xfs: sanity check directory inode di_size
      [3e86cfd] xfs: add missing include dependencies to xfs_dir2.h
      [3297e0c] xfs: replace xfs_mode_to_ftype table with switch statemen=
t
      [0962b5b] xfs: sanity check inode di_mode
      [eb24bcf] xfs_io: fix missing syncfs command

Anna Schumaker (1):
      [4314180] xfs_io: Improvements to copy_range return code handling

Arnd Bergmann (1):
      [5b1caea] xfs: fix xfs_mode_to_ftype() prototype

Bhumika Goyal (1):
      [b6b8672] fs: xfs: libxfs: constify xfs_nameops structures

Brian Foster (3):
      [d4fa7e6] xfs: fix btree cursor error cleanups
      [f7b1a8b] xfs: track preallocation separately in xfs_bmapi_reserve_=
delalloc()
      [4be4441] xfs: remove racy hasattr check from attr ops

Christoph Hellwig (17):
      [41db92d] xfs: new inode extent list lookup helpers
      [b038536] xfs: cleanup xfs_bmap_last_before
      [c2d73ed] xfs: use new extent lookup helpers in xfs_bmapi_read
      [8241194] xfs: use new extent lookup helpers in xfs_bmapi_write
      [246eb90] xfs: use new extent lookup helpers in __xfs_bunmapi
      [d41d230] xfs: remove prev argument to xfs_bmapi_reserve_delalloc
      [9ee1fc5] xfs: remove xfs_bmap_search_extents
      [f5f0bea] xfs: remove NULLEXTNUM
      [8eeb15e] xfs: bump up reserved blocks in xfs_alloc_set_aside
      [a3b4a95] xfs: fix bogus minleft manipulations
      [2c003dc] xfs: adjust allocation length in xfs_alloc_space_availabl=
e
      [3fe4a6d] xfs: don't rely on ->total in xfs_alloc_space_available
      [744a862] xfsprogs: remove irix support
      [7075a23] xfs: fix COW writeback race
      [2ffa676] xfs: only update mount/resv fields on success in __xfs_ag=
_resv_init
      [74e502a] xfs: use per-AG reservations for the finobt
      [3f5dd6c] xfs: extsize hints are not unlikely in xfs_bmap_btalloc

Darrick J. Wong (34):
      [11b2abf] tools: create libxfs-diff to compare libxfses
      [1c193cc] libxfs-apply: port to stgit
      [3c73a9a] xfs_io: fix libxfs naming violation
      [3524467] libxfs: remove unnecessary hascrc test in btree verifiers=

      [4ca4eb8] libxfs: refactor btree crc verifier
      [eae096c] libxfs: fix whitespace to match the kernel
      [a29ab3d] libxfs: return bool from sb_version_hasmetauuid
      [bc19946] libxfs: remove useless stuff from the kernel
      [187f8c2] libxfs: fix line lengths
      [135c7b5] libxfs: synchronize dinode_verify with userspace
      [7b111d3] libxfs: clean up _dir2_data_freescan
      [6921638] xfs: check return value of _trans_reserve_quota_nblks
      [342ec63] xfs: check minimum block size for CRC filesystems
      [f0d92f0] xfs: factor rmap btree size into the indlen calculations
      [00795aa] xfs: forbid AG btrees with level =3D=3D 0
      [312eea2] xfs: check for bogus values in btree block headers
      [43a48f6] xfs: complain if we don't get nextents bmap records
      [5f48ab1] xfs: don't crash if reading a directory results in an une=
xpected hole
      [9656ed1] xfs: error out if trying to add attrs and anextents > 0
      [9d85eb4] xfs: don't allow di_size with high bit set
      [762989e] xfs: use GPF_NOFS when allocating btree cursors
      [f21c57e] xfs: use the actual AG length when reserving blocks
      [2ca36c2] xfs_io: prefix dedupe command error messages consistently=

      [0bd6599] xfs_io: fix the minimum arguments to the reflink command
      [c327e1f] xfs_io: fix some documentation problems
      [9fcc120] xfs_repair.8: document dirty log conditions
      [c8dc423] xfs_db: fix the 'source' command when passed as a -c opti=
on
      [02b56f8] xfs_repair: strengthen geometry checks
      [fa2a8c1] xfs_repair: zero shared_vn
      [ce746a2] xfs_repair: trash dirattr btrees that cycle to the root
      [ae9069f] tools/find-api-violations: fix fs -> fsr in the directory=
 list
      [2e6fca2] xfs: verify dirblocklog correctly
      [ce24180] libxfs: sync up FSGETXATTR names and definitions with the=
 kernel
      [84a083b] include: don't collide __bitwise definitions in 4.10

Dave Chinner (8):
      [5d8acc4] xfs: make xfs btree stats less huge
      [0bb9021] xfs: optimise CRC updates
      [7a9b731] libxcmd: check CMD_FLAG_GLOBAL inside args_command()
      [ef346a2] libxcmd: rename args_command to command_iterator
      [d6ac046] libxcmd: merge command() and iterate_command()
      [92058d2] libxcmd: don't check generic library commands
      [16bf046] xfs_io: make various commands one-shot only
      [58a1899] libxcmd: add non-iterating user commands

Deepa Dinamani (1):
      [8211d1b] xfs_io: implement 'utimes' command

Eric Biggers (3):
      [06e7a37] xfs_io.8: remove duplicate .TP commands
      [0cf66b0] xfs_io: implement 'set_encpolicy' and 'get_encpolicy' com=
mands
      [c4cd257] xfsprogs: Fix building xfsprogs on 32-bit platforms (agai=
n)

Eric Sandeen (17):
      [cd9f2a5] xfs: set XFS_DA_OP_OKNOENT in xfs_attr_get
      [d09d4e5] xfs: provide helper for counting extents from if_bytes
      [ccade85] repair: use new extent lookup helpers in bmap_next_offset=

      [1b52147] xfs: Move AGI buffer type setting to xfs_read_agi
      [b12f5cb] xfs: pass state not whichfork to trace_xfs_extlist
      [8f690d2] xfs: handle cow fork in xfs_bmap_trace_exlist
      [601410b] xfs: several xattr functions can be void
      [a002f1d] xfs: ignore leaf attr ichdr.count in verifier during log =
replay
      [3c84c54] xfs_logprint: di_gen is unsigned
      [5e303e2] xfsprogs: fix a couple 32-bit build warnings
      [11613dd] Update licenses in COPYING file
      [1f31bd2] build: add tar.xz target
      [1162297] libxfs-apply: minor improvements
      [a547152] libxfs: sanitize agcount on load
      [3eafb26] xfs_repair: Fix uninit var in process_leaf_attr_level
      [5956291] xfs_metadump: ignore attr leaf with 0 entries
      [25babb5] xfsprogs: Release v4.10.0

Eryu Guan (1):
      [6954769] xfs_io: add DAX and CoW extent-size flags to chattr manpa=
ge

Gwendal Grignou (1):
      [0a71e38] build: Allow compiling xfsprogs in a cross compile enviro=
nment

Hou Tao (1):
      [04f1d80] xfs_logprint: handle log operation split of inode item co=
rrectly

Jan Engelhardt (2):
      [30a0fce] build: resolve autoheader warning
      [8432255] build: add missing AC_PROG_INSTALL

Ralph Sennhauser (1):
      [2b86cff] xfs_io: fix building with musl

Zirong Lang (1):
      [29043c6] xfs_repair: update the manual content about xfs_repair ex=
it status

chandan (1):
      [47dd674] xfs_db: Interpret inode's di_format field as unsigned


Code Diffstat:

 Makefile                     |  10 ++-
 VERSION                      |   2 +-
 configure.ac                 |  24 ++++--
 db/init.c                    |   8 +-
 db/inode.c                   |   2 +-
 db/input.c                   |  43 +++++++---
 db/io.c                      |   2 +-
 db/metadump.c                |  13 ++-
 debian/changelog             |   6 ++
 doc/CHANGES                  |  18 ++++
 doc/COPYING                  | 414 ++++++++-----------------------------=
-------------------------------------------------------
 doc/INSTALL                  |  44 ----------
 fs/xfs/xfs_rmap_item.c       |   0
 fs/xfs/xfs_rmap_item.h       |   0
 include/Makefile             |   2 +-
 include/builddefs.in         |  11 ++-
 include/command.h            |  13 ++-
 include/input.h              |   1 +
 include/irix.h               | 491 -------------------------------------=
------------------------------------------------------------------------
 include/xfs.h                |   2 -
 include/xfs_arch.h           |   8 +-
 include/xfs_mount.h          |   1 +
 io/Makefile                  |   6 +-
 io/copy_file_range.c         |   5 +-
 io/cowextsize.c              |   6 +-
 io/encrypt.c                 | 302 +++++++++++++++++++++++++++++++++++++=
++++++++++++++++++++++++++++++
 io/file.c                    |   4 +-
 io/freeze.c                  |   4 +-
 io/getrusage.c               |   3 +-
 io/imap.c                    |   2 +-
 io/init.c                    |  29 ++++---
 io/inject.c                  |   2 +-
 io/io.h                      |   2 +
 io/link.c                    |   2 +-
 io/mmap.c                    |   7 +-
 io/open.c                    |  11 +--
 io/readdir.c                 |  11 ++-
 io/reflink.c                 |  14 ++--
 io/resblks.c                 |   2 +-
 io/shutdown.c                |   2 +-
 io/sync.c                    |   3 +-
 io/utimes.c                  |  81 ++++++++++++++++++
 libxcmd/command.c            | 159 +++++++++++++++++++++++------------
 libxcmd/help.c               |   2 +-
 libxcmd/input.c              |  22 +++++
 libxcmd/quit.c               |   2 +-
 libxfs/Makefile              |   4 +-
 libxfs/init.c                |  23 ++++++
 libxfs/libxfs_api_defs.h     |   3 +-
 libxfs/libxfs_priv.h         |  18 ++--
 libxfs/xfs_ag_resv.c         |  73 +++++++++++++----
 libxfs/xfs_alloc.c           | 125 ++++++++--------------------
 libxfs/xfs_alloc.h           |   2 +-
 libxfs/xfs_alloc_btree.c     |  10 +--
 libxfs/xfs_attr.c            |   8 +-
 libxfs/xfs_attr_leaf.c       |   8 +-
 libxfs/xfs_attr_leaf.h       |   2 +-
 libxfs/xfs_bmap.c            | 383 +++++++++++++++++++++++++++++++++++++=
------------------------------------------------
 libxfs/xfs_bmap.h            |  22 ++---
 libxfs/xfs_bmap_btree.c      |   6 +-
 libxfs/xfs_btree.c           |  24 +++++-
 libxfs/xfs_btree.h           |  43 +---------
 libxfs/xfs_cksum.h           |  26 +++++-
 libxfs/xfs_dir2.c            |  41 ++++++----
 libxfs/xfs_dir2.h            |  12 ++-
 libxfs/xfs_dir2_data.c       |  14 +++-
 libxfs/xfs_dir2_node.c       |   2 +
 libxfs/xfs_format.h          |   3 +-
 libxfs/xfs_fs.h              |   5 +-
 libxfs/xfs_ialloc.c          |  18 ++--
 libxfs/xfs_ialloc_btree.c    |  96 ++++++++++++++++++++--
 libxfs/xfs_ialloc_btree.h    |   3 +
 libxfs/xfs_inode_buf.c       |  19 ++++-
 libxfs/xfs_inode_buf.h       |   2 -
 libxfs/xfs_inode_fork.c      |  78 +++++++++++++++---
 libxfs/xfs_inode_fork.h      |   7 ++
 libxfs/xfs_refcount_btree.c  |  10 ++-
 libxfs/xfs_refcount_btree.h  |   3 +-
 libxfs/xfs_rmap_btree.c      |  15 ++--
 libxfs/xfs_rmap_btree.h      |   3 +-
 libxfs/xfs_sb.c              |   8 +-
 libxfs/xfs_types.h           |   1 -
 logprint/log_misc.c          |  30 ++++---
 logprint/log_print_all.c     |   2 +-
 m4/package_libcdev.m4        |   2 +-
 m4/package_types.m4          |   1 +
 man/man8/xfs_io.8            |  88 +++++++++++++++++---
 man/man8/xfs_repair.8        |  35 +++++++-
 quota/init.c                 |  13 +--
 quota/init.h                 |   2 -
 quota/path.c                 |   4 +-
 quota/report.c               |   2 +-
 repair/attr_repair.c         |  17 ++--
 repair/dino_chunks.c         |   6 +-
 repair/dir2.c                |   4 +-
 repair/globals.h             |   3 +-
 repair/phase1.c              |   7 ++
 repair/phase6.c              |  13 ++-
 repair/sb.c                  |  27 +++---
 repair/xfs_repair.c          |   2 +
 tools/find-api-violations.sh |   2 +-
 tools/libxfs-apply           |  41 +++++++++-
 tools/libxfs-diff            |  25 ++++++
 103 files changed, 1632 insertions(+), 1612 deletions(-)
 delete mode 100644 fs/xfs/xfs_rmap_item.c
 delete mode 100644 fs/xfs/xfs_rmap_item.h
 delete mode 100644 include/irix.h
 create mode 100644 io/encrypt.c
 create mode 100755 io/utimes.c
 create mode 100755 tools/libxfs-diff


--mGiJNXGhqD9J35ShEClRkPEXxpRAbBV16--

--XSCU5M7tkKVcVnm21t20DRapcsRAtm5Na
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJYszf+AAoJECCuFpLhPd7gbXEP/Rv1u5/Q1Xwu8OYbulMkQ3rn
sYipmMUnoXZRP2OFNdU4/CWOpragVIUka7eprKozVj+1srYN1U39REuOY8qTVksX
v/9Kt+AeeVCyY9P1AEXlf8+/S9jmd9fu2+D+7x1gI0nIsboVIGiGKkkqccMkqIJX
mcGTUCNnoJpxecNuYrGezeQtePFqpPEoUedebiIWadi+ON+peahWKfUBnW0q+wsG
XC58vIQvk/hBSFaqD17fpSRGolFyUE4TTX+MD3aZcIj0jrc3C7Fq8syjs4UO9sww
3ptcpXkh2KTrxwLfw8J0GSWTtUwUgVZupG/4ylLOUUhGFuZfYwmyWJu8OKOaNyhU
0a4VOtMJBYysi6J7QQofjQm3Z34vxeEQzGzEN8LvmQjRVtH1nqUn0u2hkT+ziAp1
44YiKV/2K5U6Rad5Nj1kafmQ54+F4FciS2RlaGAmvJH6a751fzF7rWramQ0rpVQG
ZkkFMHtGAdRERrreHb1fzX20bLD7CTzxpkdDrAyEVDT7JqJK8z+flIZVwvY4OZGJ
WwwHKuYhPFWRTKT9mSxbXPljJTxwSykYIziDrqzGqgg4PkCaAUzpQn7RAUqQkei3
fsozNwL2Mod6ffJAZe2IPjzJdqpFctfYNHHDnYlqzRxdFEGY1acN+6ND5i1KG70X
gQIP1b4cOfTHZr4D3cy2
=8/AM
-----END PGP SIGNATURE-----

--XSCU5M7tkKVcVnm21t20DRapcsRAtm5Na--
