Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40396 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbeKJGaK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 10 Nov 2018 01:30:10 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 3FF3F7BB3
        for <linux-xfs@vger.kernel.org>; Fri,  9 Nov 2018 14:46:56 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-4.19.0 released
Message-ID: <9db76717-c6f2-2202-5e1c-7bb674d52a73@sandeen.net>
Date: Fri, 9 Nov 2018 14:47:53 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OfelbyBM9xzU1ZWfUxlv7ZgaqERl3uH7M"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OfelbyBM9xzU1ZWfUxlv7ZgaqERl3uH7M
Content-Type: multipart/mixed; boundary="jeYqJh0GJF6P2eyMAaQ5b13j5scMXkUg1";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <9db76717-c6f2-2202-5e1c-7bb674d52a73@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-4.19.0 released

--jeYqJh0GJF6P2eyMAaQ5b13j5scMXkUg1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v4.19.0, with tarballs
available at:

https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-4.19.0.ta=
r.gz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-4.19.0.ta=
r.xz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-4.19.0.ta=
r.sign

This was a pretty big one, with 157 patches and major libxfs rework
involved.  Other notable changes include the removal of non-linux platfor=
m
support, easy access to sparse semantic checking in the Makefile and
lots of associated patches to clean that up, cross-platform build fixes,
retpoline support removal, an xfs_repair performance regression fix,
and other xfs_repair fixes.  Here's the digest, full change list and
diffstat since 4.18.0 follows at the end:

xfsprogs-4.19.0 (09 Nov 2018)
        - Fix up debian subdir build w.r.t. CHECK_CMD (Darrick Wong)

xfsprogs-4.19.0-rc1 (02 Nov 2018)
        - Remove non-linux platforms (Eric Sandeen)
        - Remove retpoline support (Eric Sandeen)
        - Add sparse checking & related fixes/cleanups (Eric Sandeen)
        - Fix cross-platform building w.r.t. crc32selftest
        - libxfs: add agfl free deferred op type (Darrick Wong)
        - mkfs.xfs: discard only after all validations (Jan Tulak)
        - xfs_repair: fix segfault in longform_dir2_entry_check (Eric San=
deen)
        - xfs_repair: fix ASSERT in xfs_bunmapi (Eric Sandeen)
        - xfs_repair: fix readahead thread deadlock/stall (Eric Sandeen)
        - xfs_repair: avoid writing back all inodes (Dave Chinner)
        - xfs_repair: don't treat directory root LEAFN as corrupt (Dave C=
hinner)
        - xfs_io: add crc32 self test (Darrick Wong)
        - xfs_io: remove useless do_preadv and do_pwritev arguments (Zorr=
o Lang)
        - xfs_scrub: make scrub build config-optional (Eric Sandeen)
        - xfs_scrub: lack of kernel support is not a service failure (Dar=
rick Wong)
        - xfs_scrub_all: fix systemd escaping (Darrick Wong)

xfsprogs-4.19.0-rc0 (10 Oct 2018)
        - Majority of 4.19 libxfs changes merged from kernel
        - Big sparse static checker cleanup (Eric Sandeen)
        - mkfs.xfs discard fixes (Jan Tulak)
        - xfs_io readv/writev cleanup (Zorro Lang)
        - libxfs transaction commit error checking (Darrick Wong)


Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

caa9104 xfsprogs: Release v4.19.0

New Commits:

Bill O'Donnell (1):
      [5a52762] libxfs: add more bounds checking to sb sanity checks

Brian Foster (61):
      [55fb19b] xfs: rename xfs_trans ->t_agfl_dfops to ->t_dfops
      [c5f9547] xfs: remove dfops parameter from ifree call stack
      [44be382] xfs: remove dfops param from high level dirname calls
      [e599d8b] xfs: use ->t_dfops for attr set/remove operations
      [97236fa] xfs: remove dfops param in attr fork add path
      [31c3bf6] xfs: use ->t_dfops in extent split tx and remove param
      [a50d2ab] xfs: replace xfs_da_args->dfops accesses with ->t_dfops a=
nd remo
      [cbdfb3a] xfs: remove xfs_bmapi_write() dfops param
      [160ed12] xfs: remove xfs_bunmapi() dfops param
      [b5d7ff9] xfs: remove xfs_bmapi_remap() dfops param
      [f717e15] xfs: remove struct xfs_bmalloca dfops field
      [38aa99c] xfs: use ->t_dfops for collapse/insert range operations
      [52f6ed9] xfs: remove dfops param from internal bmap extent helpers=

      [b0f500a] xfs: remove xfs_btree_cur bmbt dfops field
      [5ff5ced] xfs: remove unused btree cursor bc_private.a.dfops field
      [f50f99f] xfs: use ->t_dfops in reflink cow recover path
      [fe89118] xfs: refactor dfops init to attach to transaction
      [78f7b3f] xfs: allow null firstblock in xfs_bmapi_write() when tp i=
s null
      [255682d] xfs: add firstblock field to xfs_trans
      [015bc82] xfs: remove firstblock param from xfs dir ops
      [d9313ca] xfs: use ->t_firstblock in attrfork add
      [d2391b2] xfs: use ->t_firstblock in xattr ops
      [35f5766] xfs: use ->t_firstblock for all xfs_bunmapi() callers
      [f9a6ff4] xfs: use ->t_firstblock in xfs_bmapi_remap()
      [b39f9fc] xfs: remove xfs_bmapi_write() firstblock param
      [d3c5f3d] xfs: remove xfs_bunmapi() firstblock param
      [a397f27] xfs: remove bmap insert/collapse firstblock param
      [312350c] xfs: use ->t_firstblock in bmap extent split
      [80dc7f2] xfs: remove xfs_bmalloca firstblock field
      [64e8b4a] xfs: remove bmap extent add helper firstblock params
      [f725350] xfs: remove bmap format helpers firstblock params
      [f44a348] xfs: remove xfs_btree_cur private firstblock field
      [03aeb29] xfs: remove xfs_alloc_arg firstblock field
      [f7994b9] xfs: replace no-op firstblock init with ->t_firstblock
      [5cebfb2] xfs: remove xfs_defer_init() firstblock param
      [b6e2c0c] xfs: fix transaction leak on remote attr set/remove failu=
re
      [ad84d07] xfs: make deferred processing safe for embedded dfops
      [e89bdff] xfs: remove unused deferred ops committed field
      [1a3fd2f] xfs: reset dfops to initial state after finish
      [bd87cf3] xfs: pack holes in xfs_defer_ops and xfs_trans
      [f5f4497] xfs: support embedded dfops in transaction
      [7879772] xfs: use internal dfops in attr code
      [29ae66e] xfs: remove all boilerplate defer init/finish code
      [82d7af8] xfs: remove unnecessary dfops init calls in xattr code
      [ac0a222] xfs: drop unnecessary xfs_defer_finish() dfops parameter
      [ca7e896] xfs: bypass final dfops roll in trans commit path
      [3645e8e] xfs: refactor internal dfops initialization
      [2291355] xfs: remove unused __xfs_defer_cancel() internal helper
      [76a3c33] xfs: pass transaction to dfops reset/move helpers
      [565e96c] xfs: replace dop_low with transaction flag
      [8364f6d] xfs: add missing defer ijoins for held inodes
      [f2ea6bf] xfs: automatic dfops buffer relogging
      [c086049] xfs: automatic dfops inode relogging
      [7b3ab23] xfs: drop dop param from xfs_defer_op_type ->finish_item(=
) callb
      [1e6b0a7] xfs: clean out superfluous dfops dop params/vars
      [9f5a828] xfs: cancel dfops on xfs_defer_finish() error
      [3e1da12] xfs: replace xfs_defer_ops ->dop_pending with on-stack li=
st
      [21375e5] xfs: pass transaction to xfs_defer_add()
      [6dc2412] xfs: always defer agfl block frees
      [92a8736] xfs: fold dfops into the transaction
      [50fba28] xfs: remove last of unnecessary xfs_defer_cancel() caller=
s

Carlos Maiolino (1):
      [e66d0a4] libxfs: Fix a couple of sparse complaintis

Christoph Hellwig (6):
      [8197bce] xfs: remove the now unused XFS_BMAPI_IGSTATE flag
      [9685aa3] xfs: remove if_real_bytes
      [2282d1d] xfs: simplify xfs_idata_realloc
      [e07055b] xfs: remove the xfs_ifork_t typedef
      [68fc8c4] xfs: maintain a sequence count for inode fork manipulatio=
ns
      [c02e034] xfs: use WRITE_ONCE to update if_seq

Darrick J. Wong (30):
      [f94c53c] libxfs: port kernel transaction code
      [a7bbf18] libxfs: fix libxfs_trans_alloc callsite problems
      [1530d23] xfs_repair: fix block reservation in mk_rsumino
      [225e4bb] libxfs: fix xfs_trans_alloc reservation abuse
      [41ab920] libxfs: track transaction block reservation usage like th=
e kerne
      [a6ad7ea] xfs: don't assume a left rmap when allocating a new rmap
      [f43b1b3] xfs: check leaf attribute block freemap in verifier
      [04f6507] xfs: return from _defer_finish with a clean transaction
      [660265b] xfs: trivial xfs_btree_del_cursor cleanups
      [a8a538b] xfs: clean up xfs_btree_del_cursor callers
      [52f4e12] xfs: detect and fix bad summary counts at mount
      [ecefbcb] xfs: refactor unmount record write
      [b09a597] xfs: force summary counter recalc at next mount
      [0d80232] xfs: pass transaction lock while setting up agresv on cyc=
lic met
      [e228770] xfs: refactor superblock verifiers
      [751d83b] xfs: verify icount in superblock write
      [bc226d3] xfs: only validate summary counts on primary superblock
      [f0874fc] xfs: check for unknown v5 feature bits in superblock writ=
e verif
      [1f248827] xfs: move extent busy tree initialization to xfs_initial=
ize_per
      [d780a2f] xfs: refactor log recovery check
      [ea09a74] xfs: use a local variable for magic number in xfs_da3_nod=
e_looku
      [b403e02] xfs: check da node magic in _node_lookup_int
      [f2279d8] libxfs: check libxfs_trans_commit return values
      [31845e4] libxfs: clean up IRELE/iput callsites
      [2937043] xfs_scrub_all: fix systemd escaping again
      [d18ae0e] misc: only build with lto if explicitly enabled
      [f6302b0] xfs_scrub: lack of kernel support is not a service failur=
e
      [c8dc76e] libxfs: add missing agfl free deferred op type
      [99a5535] xfs_io: add crc32 self test
      [fa001e4] make: don't spray static check failures all over the subd=
ir  bui

Dave Chinner (5):
      [d7c2f6c] xfs: fix error handling in xfs_bmap_extents_to_btree
      [9060cb3] xfsprogs: document changes for 4.19.0-rc0
      [b9df750] xfsprogs: remove unused functions
      [71a6af8] Revert "xfs_repair: treat zero da btree pointers as corru=
ption"
      [119383b] xfs_repair: don't dirty inodes unconditionally when testi=
ng unli

Eric Sandeen (47):
      [498b6cf] xfsprogs: Release v4.19.0-rc0
      [f69ea1f] xfs: don't treat unknown di_flags2 as corruption in scrub=

      [91b32a0] xfs: validate inode di_forkoff
      [c4bd48e] xfsprogs: remove irix platform files
      [36b6291] xfsprogs: remove bsd platform files
      [231a533] xfsprogs: remove darwin platform files
      [bf64c90] xfsprogs: remove PKG_PLATFORM macro
      [ea01951] scrub: remove redundant debug test
      [669be3c] xfsprogs: document environment variables
      [9fae859] xfsprogs: make scrub build config-optional
      [8791bf6] xfsprogs: define xfs_stack_trace() for debug builds
      [f6ebe7c] xfsprogs: minor sparse fixes
      [e66e9ee] xfsprogs: use ANSI declarations of void-arg functions
      [33dc45c] mkfs.xfs: include full parser prototype in subopts defini=
tion
      [3dd2705] xfsprogs: don't use 0 as pointer
      [7e4109b] libxfs: avoid redefinitions of macros in mount.h
      [73ab3f6] xfsprogs: remove write-only variables
      [00ff2b1] xfsprogs: make static things static
      [a5e0945] xfsprogs: kill EXTERN macro
      [5f56a56] libxfs: export unused nonstatic functions to quiet static=
 checke
      [b657185] xfsprogs: don't include all xfs headers just for crc32
      [6a40ccc] xfs_db: convert single-bit bitfields to bools
      [8e1338f] xfsprogs: minor endian annotation fixes
      [2bba5a0] xfsprogs: avoid redefinition of NBBY
      [4a87b33] xfsprogs: include headers for extern variables
      [4e00636] libxfs: add several zone extern declarations to libxfs_pr=
iv.h
      [1281240] libxfs: silence static warnings about platform_* function=
s
      [011f253] xfs_io: include io.h to silence static function warnings
      [7ed3b9b] libxfs: silence sparse static function warnings in util.c=

      [37717cc] avl64: export avl64_firstino / avl64_firstino from avl64.=
h
      [28e36fc] xfsprogs: misc static function warning fixes
      [4add9d5] xfsprogs: don't shadow global libxfs_init x variable
      [86715cc] xfs_io: rename global buffer variable
      [4a706e0] xfs_logprint: fix shadow var in xlog_print_trans_buffer
      [925638b] xfs_repair: fix 'bno' shadow vars in scan.c
      [4ace28d] xfs_scrub: remove shadow var from run_scrub_phases()
      [8ab6f7e] xfs_metadump: remove shadow variable
      [440cb37] libfrog: change project entity variable scope to local/st=
atic.
      [d4739a5] xfsprogs: enable sparse checking with make C=3D1
      [e51fde0] xfsprogs: enable sparse checking with make C=3D2
      [44ec419] xfsprogs: remove retpoline support
      [1624c34] xfs_repair: initialize realloced bplist in longform_dir2_=
entry_c
      [ea7be34] xfs_repair: continue after xfs_bunmapi deadlock avoidance=

      [7cf2aa1] xfs_repair: kick processing thread if ra_count is at limi=
t
      [cb5de90] xfs_db: print freecount in xfs_inobt_rec as unsigned
      [6c26bea] xfsprogs: Release v4.19.0-rc1
      [caa9104] xfsprogs: Release v4.19.0

Gustavo A. R. Silva (2):
      [50c8d19] xfs_attr_leaf: use swap macro in xfs_attr3_leaf_rebalance=

      [7ef369e] xfs: use swap macro in xfs_dir2_leafn_rebalance

Jan Tulak (2):
      [915a27a] mkfs: discard only after all validations
      [cb46aab] mkfs: move 'mounted' check before 'existing fs' check

Shan Hai (1):
      [b5c71bc] xfs: fix a null pointer dereference in xfs_bmap_extents_t=
o_btree

Zorro Lang (1):
      [248b6f9] xfs_io: remove useless do_preadv and do_pwritev arguments=



Code Diffstat:

 Makefile                    |  22 +-
 VERSION                     |   2 +-
 configure.ac                |  28 +-
 copy/xfs_copy.c             |  71 +++--
 db/attrset.c                |   4 +-
 db/btblock.c                |   4 +-
 db/check.c                  |  23 +-
 db/crc.c                    |   7 +-
 db/dir2sf.c                 |   4 +-
 db/fsmap.c                  |   2 +-
 db/fuzz.c                   |   1 +
 db/hash.c                   |   1 +
 db/init.c                   |   8 +-
 db/input.c                  |   6 +-
 db/io.c                     |   2 +-
 db/io.h                     |  10 +-
 db/logformat.c              |   3 +-
 db/metadump.c               |  13 +-
 db/symlink.c                |   2 +-
 db/text.c                   |   1 +
 db/write.c                  |   4 +-
 debian/changelog            |  19 ++
 doc/CHANGES                 |  28 ++
 doc/INSTALL                 |  54 ----
 doc/README-env-vars.txt     |  26 ++
 doc/sparse.txt              |  12 +-
 estimate/xfs_estimate.c     |  34 +--
 fsr/Makefile                |   4 -
 fsr/xfs_fsr.c               |  50 ++--
 include/Makefile            |   8 +-
 include/avl64.h             |   6 +
 include/builddefs.in        |  24 +-
 include/buildrules          |  23 ++
 include/crc32cselftest.h    | 706 ++++++++++++++++++++++++++++++++++++++=
++++++
 include/darwin.h            | 303 -------------------
 include/freebsd.h           | 198 -------------
 include/gnukfreebsd.h       | 144 ---------
 include/platform_defs.h.in  |   2 +
 include/xfs.h               |   6 -
 include/xfs_inode.h         |   4 +-
 include/xfs_trace.h         |  20 +-
 include/xfs_trans.h         |  15 +-
 io/Makefile                 |  21 +-
 io/bmap.c                   |   2 +-
 io/crc32cselftest.c         |  37 +++
 io/fiemap.c                 |   2 +-
 io/freeze.c                 |   4 +-
 io/fsmap.c                  |   2 +-
 io/getrusage.c              |   1 +
 io/imap.c                   |   2 +-
 io/init.c                   |  14 +-
 io/inject.c                 |   6 +-
 io/io.h                     |  12 +-
 io/label.c                  |   1 -
 io/log_writes.c             |   1 +
 io/madvise.c                |   2 +-
 io/mincore.c                |   2 +-
 io/mmap.c                   |  16 +-
 io/parent.c                 |   2 +-
 io/pread.c                  |  63 ++--
 io/pwrite.c                 |  33 +--
 io/readdir.c                |   2 +-
 io/seek.c                   |   4 +-
 io/stat.c                   |   8 +-
 libfrog/Makefile            |   9 +-
 libfrog/crc32.c             | 675 +-------------------------------------=
----
 libfrog/darwin.c            | 136 ---------
 libfrog/freebsd.c           | 193 ------------
 libfrog/irix.c              | 103 -------
 libfrog/linux.c             |   3 +-
 libfrog/paths.c             |  55 ----
 libfrog/projects.c          |  12 +-
 libhandle/Makefile          |   4 -
 libxcmd/command.c           |   4 +-
 libxfs/cache.c              |   2 +-
 libxfs/defer_item.c         |  52 +++-
 libxfs/init.c               |  17 +-
 libxfs/init.h               |   4 +-
 libxfs/libxfs_api_defs.h    |   2 -
 libxfs/libxfs_priv.h        |  79 ++++-
 libxfs/rdwr.c               |  25 +-
 libxfs/trans.c              | 254 +++++++++++++---
 libxfs/util.c               |  81 +----
 libxfs/xfs_ag_resv.c        |  13 +-
 libxfs/xfs_ag_resv.h        |   4 +-
 libxfs/xfs_alloc.c          |  42 +--
 libxfs/xfs_alloc.h          |   1 -
 libxfs/xfs_attr.c           | 140 ++++-----
 libxfs/xfs_attr_leaf.c      |  70 +++--
 libxfs/xfs_attr_remote.c    |  32 +-
 libxfs/xfs_bmap.c           | 456 +++++++++++-----------------
 libxfs/xfs_bmap.h           |  48 ++-
 libxfs/xfs_bmap_btree.c     |  22 +-
 libxfs/xfs_btree.h          |   4 -
 libxfs/xfs_da_btree.c       |  37 ++-
 libxfs/xfs_da_btree.h       |   3 -
 libxfs/xfs_defer.c          | 321 ++++++++++----------
 libxfs/xfs_defer.h          |  41 +--
 libxfs/xfs_dir2.c           |  74 ++---
 libxfs/xfs_dir2.h           |  10 +-
 libxfs/xfs_dir2_node.c      |  17 +-
 libxfs/xfs_errortag.h       |   4 +-
 libxfs/xfs_format.h         |   2 +
 libxfs/xfs_ialloc.c         |  33 +--
 libxfs/xfs_ialloc.h         |   1 -
 libxfs/xfs_ialloc_btree.c   |  12 +-
 libxfs/xfs_ialloc_btree.h   |   4 +-
 libxfs/xfs_iext_tree.c      |  20 ++
 libxfs/xfs_inode_buf.c      |  30 ++
 libxfs/xfs_inode_fork.c     |  74 ++---
 libxfs/xfs_inode_fork.h     |   6 +-
 libxfs/xfs_log_format.h     |  13 +
 libxfs/xfs_refcount.c       | 107 +++----
 libxfs/xfs_refcount.h       |  25 +-
 libxfs/xfs_refcount_btree.c |  13 +-
 libxfs/xfs_refcount_btree.h |   7 +-
 libxfs/xfs_rmap.c           |  99 +++----
 libxfs/xfs_rmap.h           |  22 +-
 libxfs/xfs_rmap_btree.c     |   5 +-
 libxfs/xfs_rmap_btree.h     |   2 +-
 libxfs/xfs_sb.c             | 271 +++++++++++------
 libxfs/xfs_shared.h         |  12 +
 libxfs/xfs_types.c          |  34 +++
 libxfs/xfs_types.h          |   1 +
 logprint/log_misc.c         |  82 ++---
 logprint/log_print_all.c    |   2 +-
 logprint/logprint.c         |   6 +-
 m4/package_globals.m4       |   4 -
 m4/package_libcdev.m4       |  41 +--
 man/man8/xfs_io.8           |   4 +
 man/man8/xfs_quota.8        |  11 +-
 mdrestore/xfs_mdrestore.c   |   6 +-
 mkfs/proto.c                | 141 ++++-----
 mkfs/xfs_mkfs.c             |  92 +++---
 quota/Makefile              |   6 +-
 quota/darwin.c              |  21 --
 quota/freebsd.c             |  19 --
 quota/irix.c                |  54 ----
 repair/agheader.c           |   2 +-
 repair/btree.c              |  23 --
 repair/dinode.c             |  24 +-
 repair/dir2.c               |   6 +-
 repair/globals.c            | 121 +++++++-
 repair/globals.h            | 136 +++++----
 repair/incore_ext.c         |  10 +-
 repair/incore_ino.c         |   4 +-
 repair/phase2.c             |   2 -
 repair/phase5.c             |   3 +-
 repair/phase6.c             | 284 ++++++++----------
 repair/phase7.c             |   2 +-
 repair/prefetch.c           |   4 +
 repair/progress.c           |   2 +-
 repair/rmap.c               |  17 +-
 repair/sb.c                 |   2 +-
 repair/scan.c               |  24 +-
 repair/scan.h               |   2 +
 repair/versions.c           |  23 +-
 repair/versions.h           |  16 +-
 rtcp/xfs_rtcp.c             |   4 +-
 scrub/Makefile              |   4 +-
 scrub/fscounters.c          |   2 +-
 scrub/inodes.c              |   6 +-
 scrub/scrub.c               |   2 +-
 scrub/xfs_scrub.c           |  17 +-
 scrub/xfs_scrub.h           |   2 +
 scrub/xfs_scrub_all.in      |   9 +-
 spaceman/Makefile           |   6 +-
 spaceman/init.c             |   4 +-
 168 files changed, 3110 insertions(+), 4125 deletions(-)
 create mode 100644 doc/README-env-vars.txt
 create mode 100644 include/crc32cselftest.h
 delete mode 100644 include/darwin.h
 delete mode 100644 include/freebsd.h
 delete mode 100644 include/gnukfreebsd.h
 create mode 100644 io/crc32cselftest.c
 delete mode 100644 libfrog/darwin.c
 delete mode 100644 libfrog/freebsd.c
 delete mode 100644 libfrog/irix.c
 delete mode 100644 quota/darwin.c
 delete mode 100644 quota/freebsd.c
 delete mode 100644 quota/irix.c


--jeYqJh0GJF6P2eyMAaQ5b13j5scMXkUg1--

--OfelbyBM9xzU1ZWfUxlv7ZgaqERl3uH7M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlvl8noACgkQIK4WkuE9
3uAoMw/8CPwmCA6dmpIZsSrUWD1zmaoYe39gy9tHHUHD2a6+hHcxDh/iOtMiuyyu
Z38xfCIGpRYxFiWpow/aU5KIa7/QDPpW5H/OLg2dj0tJw3igBOOcAB+Ze7qsZMb4
fKKBCerkpd5Ogo4Jf9dfVAYRwUfXN1U3+s9sOhng2PowXwy82io2TEvHb3vm7sAY
dcjvVC9Pt/fDOfdGcDfYVE5RZAb4HuazJ+OTrrjoIcxcXFJiD4TqtiS9nNreVNCc
15xQ79LBv+53um9EEsG5auRZ429SFmUQ1R+UO+gHCz66P1W/uQJpnRyXHPE9t8ba
+Jz4Jp0u0KqN5Bp8yjeLq0bVCdbChukmfAnRvCrfeKyWtdQCR9yHJi1GpIwrg8HK
MQPaYhhfUhJAmfbAnh9YYunAdCbjWC7V0Nf/qL1+8CexddEH0I2oq/ZzhbUSZjVJ
P1hL7z9oUVkp1vJTAK0E0YoaGVM5UuNm+oknAuE5DQhl2ScGc4undv2A8B5W1+dY
0ZOw48EriEoMhvt0P5B8OKk2TEvdRJdQZ4sad76YiCjFDPV04mBORkRTjKe+zKTd
qwk7off67iUJXnwvu72r3Zz4PV8BzSLNZTVmuXFOF5aFmCAfR7ip6zUFAB+KwFsc
wL6sVi1MdzA5wXlZf+o4u8MqoTImKhFbNVnNeHD9DoRLAt9lzg8=
=q13P
-----END PGP SIGNATURE-----

--OfelbyBM9xzU1ZWfUxlv7ZgaqERl3uH7M--
