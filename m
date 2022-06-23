Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6353C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 01:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378015AbiFWB7Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 21:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378386AbiFWB6u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 21:58:50 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72B16E09F
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 18:56:43 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id BC1785196E5
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 20:55:51 -0500 (CDT)
Message-ID: <3efbe2a8-5f82-896e-e316-e8075dd88c5c@sandeen.net>
Date:   Wed, 22 Jun 2022 20:56:40 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Content-Language: en-US
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs updated to 5.19.0-rc0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------oJCZBK4GHHRpqUEPQXjmBT7f"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------oJCZBK4GHHRpqUEPQXjmBT7f
Content-Type: multipart/mixed; boundary="------------0JjRIu64cjwAZvWrWJKj04yz";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <3efbe2a8-5f82-896e-e316-e8075dd88c5c@sandeen.net>
Subject: [ANNOUNCE] xfsprogs updated to 5.19.0-rc0

--------------0JjRIu64cjwAZvWrWJKj04yz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This is just the 5.19 libxfs sync, plus a small handful of tool updates
to allow mkfs w/ new on disk features, reporting in xfs_info, logprint,
etc.

The new head of the master branch is commit:

29622874 (HEAD -> libxfs-5.19-sync, tag: v5.19.0-rc0, origin/libxfs-5.19-=
sync, korg/for-next) xfsprogs: Release v5.19.0-rc0

New Commits:

Allison Henderson (15):
      [9c0383ad] xfs: Fix double unlock in defer capture code
      [eddff049] xfs: Return from xfs_attr_set_iter if there are no more =
rmtblks to process
      [6bcbc244] xfs: Set up infrastructure for log attribute replay
      [c6ad4bc1] xfs: Implement attr logging and replay
      [669c8c82] xfs: Skip flip flags for delayed attrs
      [4a12ea99] xfs: Add xfs_attr_set_deferred and xfs_attr_remove_defer=
red
      [9ebd7ae8] xfs: Remove unused xfs_attr_*_args
      [a2832031] xfs: Add log attribute error tag
      [5363c39d] xfs: Add larp debug option
      [a951e052] xfs: Merge xfs_delattr_context into xfs_attr_item
      [bc522905] xfs: Add helper function xfs_attr_leaf_addname
      [ef291627] xfs: Add helper function xfs_init_attr_trans
      [7f92d9ee] xfs: add leaf split error tag
      [c818a9fb] xfs: add leaf to node error tag
      [90542cd2] xfs_logprint: Add log item printing for ATTRI and ATTRD

Catherine Hoang (1):
      [08b9530a] xfs: remove warning counters from struct xfs_dquot_res

Chandan Babu R (20):
      [977542a2] xfs: Move extent count limits to xfs_format.h
      [d3e0c71f] xfs: Define max extent length based on on-disk format de=
finition
      [099e5eb3] xfs: Introduce xfs_iext_max_nextents() helper
      [3a2414fa] xfs: Use xfs_extnum_t instead of basic data types
      [5f70c91b] xfs: Introduce xfs_dfork_nextents() helper
      [cacc35ca] xfs: Use basic types to define xfs_log_dinode's di_nexte=
nts and di_anextents
      [4b85994a] xfs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32=
-bits respectively
      [d7eb8fbd] xfs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and associat=
ed per-fs feature bit
      [54a1aecb] xfs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
      [02a86c25] xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helper=
s
      [32b5fe85] xfs: Use uint64_t to count maximum blocks that can be us=
ed by BMBT
      [5a8b4d6a] xfs: Introduce macros to represent new maximum extent co=
unts for data/attr forks
      [8be26c6a] xfs: Introduce per-inode 64-bit extent counters
      [f0683d63] xfs: Directory's data fork extent counter can never over=
flow
      [fcba1629] xfs: Conditionally upgrade existing inodes to use large =
extent counters
      [2420fe02] xfs: Enable bulkstat ioctl to support 64-bit per-inode e=
xtent counters
      [1a8c8e43] xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of sup=
ported flags
      [ac87307e] xfsprogs: Invoke bulkstat ioctl with XFS_BULK_IREQ_NREXT=
64 flag
      [7666cef4] xfs_info: Report NREXT64 feature status
      [69e72722] mkfs: Add option to create filesystem with large extent =
counters

Darrick J. Wong (29):
      [90880f92] xfs: pass explicit mount pointer to rtalloc query functi=
ons
      [d8873a58] xfs: use a separate frextents counter for rt extent rese=
rvations
      [4a195282] xfs: simplify xfs_rmap_lookup_le call sites
      [8b03b413] xfs: speed up rmap lookups by using non-overlapped looku=
ps when possible
      [92798496] xfs: speed up write operations by using non-overlapped l=
ookups when possible
      [b12b9411] xfs: count EFIs when deciding to ask for a continuation =
of a refcount update
      [eb9a1cac] xfs: stop artificially limiting the length of bunmap cal=
ls
      [ad769a07] xfs: create shadow transaction reservations for computin=
g minimum log size
      [3deaaa1f] xfs: report "max_resp" used for min log size computation=

      [e9d34a55] xfs: reduce the absurdly large log operation count
      [94fe6a31] xfs: reduce transaction reservations with reflink
      [b8e570fc] xfs: rename xfs_*alloc*_log_count to _block_count
      [5b391189] xfs: don't leak da state when freeing the attr intent it=
em
      [52bc8534] xfs: don't leak the retained da state when doing a leaf =
to node conversion
      [40c3c9f0] xfs: reject unknown xattri log item filter flags during =
recovery
      [ecc6ab2b] xfs: clean up xfs_attr_node_hasname
      [209da5f6] xfs: put the xattr intent item op flags in their own nam=
espace
      [3b0ca632] xfs: use a separate slab cache for deferred xattr work s=
tate
      [05ea32a5] xfs: remove struct xfs_attr_item.xattri_flags
      [96bcaff6] xfs: put attr[id] log item cache init with the others
      [6d8c85b5] xfs: clean up state variable usage in xfs_attr_node_remo=
ve_attr
      [eff5933f] xfs: rename struct xfs_attr_item to xfs_attr_intent
      [433bc15b] xfs: do not use logged xattr updates on V4 filesystems
      [128ba9ce] xfs: share xattr name and value buffers when logging xat=
tr updates
      [03032e77] xfs: don't leak btree cursor when insrec fails after a s=
plit
      [f4706037] xfs: refactor buffer cancellation table allocation
      [3ce2772e] xfs: move xfs_attr_use_log_assist out of xfs_log.c
      [d539f713] xfs: convert buf_cancel_table allocation to kmalloc_arra=
y
      [f4ba72b0] xfs: move xfs_attr_use_log_assist usage out of libxfs

Dave Chinner (39):
      [73e894b3] xfs: log tickets don't need log client id
      [a204dd20] xfs: convert attr type flags to unsigned.
      [03b05132] xfs: convert scrub type flags to unsigned.
      [7ce54306] xfs: convert bmap extent type flags to unsigned.
      [6e22af31] xfs: convert bmapi flags to unsigned.
      [a562dd2f] xfs: convert AGF log flags to unsigned.
      [a8f712a6] xfs: convert AGI log flags to unsigned.
      [812099c1] xfs: convert btree buffer log flags to unsigned.
      [2ae91167] xfs: convert da btree operations flags to unsigned.
      [802a88ba] xfs: convert dquot flags to unsigned.
      [f5fa1fb2] xfs: convert quota options flags to unsigned.
      [5a282e43] xfs: zero inode fork buffer at allocation
      [227a3b63] xfs: hide log iovec alignment constraints
      [93d8bb2f] xfs: don't commit the first deferred transaction without=
 intents
      [2dea773a] xfs: tag transactions that contain intent done items
      [4a845716] xfs: detect self referencing btree sibling pointers
      [173809af] xfs: validate inode fork size against fork format
      [61761328] xfs: set XFS_FEAT_NLINK correctly
      [b12d5ae5] xfs: validate v5 feature fields
      [bacc4c4c] xfs: avoid empty xattr transaction when attrs are inline=

      [94f29129] xfs: make xattri_leaf_bp more useful
      [52396d81] xfs: rework deferred attribute operation setup
      [cb787289] xfs: separate out initial attr_set states
      [c3e7bcbb] xfs: kill XFS_DAC_LEAF_ADDNAME_INIT
      [21b9a05d] xfs: consolidate leaf/node states in xfs_attr_set_iter
      [03a861f4] xfs: split remote attr setting out from replace path
      [3d434104] xfs: XFS_DAS_LEAF_REPLACE state only needed if !LARP
      [d6d0318d] xfs: remote xattr removal in xfs_attr_set_iter() is cond=
itional
      [cf76c917] xfs: clean up final attr removal in xfs_attr_set_iter
      [5a9d08d8] xfs: xfs_attr_set_iter() does not need to return EAGAIN
      [3d7e9d5c] xfs: introduce attr remove initial states into xfs_attr_=
set_iter
      [fc32183a] xfs: switch attr remove to xfs_attri_set_iter
      [00ee9b95] xfs: remove xfs_attri_remove_iter
      [aacbe991] xfs: use XFS_DA_OP flags in deferred attr ops
      [9c4aae58] xfs: ATTR_REPLACE algorithm with LARP enabled needs rewo=
rk
      [d45dd440] xfs: detect empty attr leaf blocks in xfs_attr3_leaf_ver=
ify
      [29c42f23] xfs: don't assert fail on perag references on teardown
      [494b7c2e] xfs: assert in xfs_btree_del_cursor should take into acc=
ount error
      [582285d2] xfs: avoid unnecessary runtime sibling pointer endian co=
nversions

Eric Sandeen (1):
      [29622874] xfsprogs: Release v5.19.0-rc0

Julia Lawall (1):
      [7e5dda22] xfs: fix typo in comment


Code Diffstat:

 VERSION                       |    4 +-
 configure.ac                  |    2 +-
 db/block.c                    |    4 +-
 db/bmap.c                     |   24 +-
 db/bmap.h                     |    5 +-
 db/btdump.c                   |    4 +-
 db/check.c                    |   37 +-
 db/dquot.c                    |    2 +-
 db/faddr.c                    |   16 +-
 db/field.c                    |    7 +-
 db/field.h                    |    2 -
 db/frag.c                     |    6 +-
 db/inode.c                    |  230 +++++-
 db/metadump.c                 |    6 +-
 db/sb.c                       |    2 +
 fsr/xfs_fsr.c                 |    4 +-
 include/xfs_inode.h           |    5 +
 include/xfs_log_recover.h     |    6 -
 include/xfs_mount.h           |   10 +
 include/xfs_trace.h           |    7 +
 io/bulkstat.c                 |    1 +
 io/inject.c                   |    3 +
 libfrog/bulkstat.c            |   29 +-
 libfrog/fsgeom.c              |    6 +-
 libxfs/Makefile               |    1 +
 libxfs/defer_item.c           |   99 +++
 libxfs/libxfs_io.h            |    2 +
 libxfs/libxfs_priv.h          |   14 +-
 libxfs/linux-err.h            |   60 ++
 libxfs/rdwr.c                 |    8 +
 libxfs/util.c                 |    6 +
 libxfs/xfs_ag.c               |    3 +-
 libxfs/xfs_alloc.c            |   12 +-
 libxfs/xfs_alloc.h            |    2 +-
 libxfs/xfs_attr.c             | 1674 ++++++++++++++++++++---------------=
------
 libxfs/xfs_attr.h             |  205 ++++-
 libxfs/xfs_attr_leaf.c        |   64 +-
 libxfs/xfs_attr_remote.c      |   37 +-
 libxfs/xfs_attr_remote.h      |    6 +-
 libxfs/xfs_bmap.c             |  167 ++--
 libxfs/xfs_bmap.h             |   58 +-
 libxfs/xfs_bmap_btree.c       |    9 +-
 libxfs/xfs_btree.c            |  185 +++--
 libxfs/xfs_btree.h            |   26 +-
 libxfs/xfs_da_btree.c         |   14 +
 libxfs/xfs_da_btree.h         |   26 +-
 libxfs/xfs_da_format.h        |    9 +-
 libxfs/xfs_defer.c            |   96 ++-
 libxfs/xfs_defer.h            |    3 +
 libxfs/xfs_dir2.c             |    8 +
 libxfs/xfs_errortag.h         |    8 +-
 libxfs/xfs_format.h           |  189 +++--
 libxfs/xfs_fs.h               |   41 +-
 libxfs/xfs_ialloc.c           |    8 +-
 libxfs/xfs_ialloc.h           |    2 +-
 libxfs/xfs_inode_buf.c        |  118 ++-
 libxfs/xfs_inode_fork.c       |   51 +-
 libxfs/xfs_inode_fork.h       |   76 +-
 libxfs/xfs_log_format.h       |   87 ++-
 libxfs/xfs_log_rlimit.c       |   75 +-
 libxfs/xfs_quota_defs.h       |   50 +-
 libxfs/xfs_refcount.c         |   14 +-
 libxfs/xfs_refcount.h         |   13 +-
 libxfs/xfs_rmap.c             |  161 ++--
 libxfs/xfs_rmap.h             |    7 +-
 libxfs/xfs_rtbitmap.c         |    9 +-
 libxfs/xfs_sb.c               |   80 +-
 libxfs/xfs_shared.h           |   24 +-
 libxfs/xfs_symlink_remote.c   |    2 +-
 libxfs/xfs_trans_resv.c       |  225 ++++--
 libxfs/xfs_trans_resv.h       |   16 +-
 libxfs/xfs_types.h            |   11 +-
 logprint/log_misc.c           |   70 +-
 logprint/log_print_all.c      |   28 +-
 logprint/log_redo.c           |  194 +++++
 logprint/logprint.h           |   12 +
 man/man2/ioctl_xfs_bulkstat.2 |   10 +-
 man/man8/mkfs.xfs.8.in        |    7 +
 mkfs/lts_4.19.conf            |    1 +
 mkfs/lts_5.10.conf            |    1 +
 mkfs/lts_5.15.conf            |    1 +
 mkfs/lts_5.4.conf             |    1 +
 mkfs/xfs_mkfs.c               |   29 +-
 repair/attr_repair.c          |    2 +-
 repair/dinode.c               |  119 +--
 repair/dinode.h               |    4 +-
 repair/phase4.c               |    2 +-
 repair/prefetch.c             |    2 +-
 repair/rmap.c                 |   12 +-
 repair/scan.c                 |   12 +-
 repair/scan.h                 |    6 +-
 91 files changed, 3322 insertions(+), 1674 deletions(-)
 create mode 100644 libxfs/linux-err.h

--------------0JjRIu64cjwAZvWrWJKj04yz--

--------------oJCZBK4GHHRpqUEPQXjmBT7f
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmKzyFgFAwAAAAAACgkQIK4WkuE93uCK
dQ//TpZG33f9HS78VkvQXbHZ1Q9VTEge2/fXgpekahwuJ6TdHUC4dN3XTy4mq5umTJSnR1iT4zr5
OaLyPfn4ZvgCEHF9G92UGD6b8SmqbjwoxQVed0bYd0kmPkWEpI1VUqJnEDcLMYBAQBaTJVvaSuIT
EFIi3Z4d701PuHmMPCc4KvYfVn6tLZ3Qlg8QTnI+L6kEc10nIoi09jjTlixJwJ7ruKeDZJUeYmk6
0iyMxNNU5wp4mKjLwo1VnaZp+LhBZOR7BnTtQI/S8BkBwSom5o8GgFKpXff9YW1MGmKTWxI0/jJL
dlEHG3hA/Kt3bcT6Eso+hfZ9mz0y3JwDtJYACg3ecyRqal0U97cAoUn7m6ys29mRGAfzTJUrGa+M
D5v0rcF5E0WKTOPNiGEA7dDVcntLqd5Q75ozea1y4+O3+v4H6lxw1BO5ArU6wlYSR/zSaneouG30
XJYqb7EN0oIZY2gvKqCuoiPgr8f69bS6J3EZUIBbngn7Bs4g94/khZKMEhWlubPM61uiv1WohruF
HiU4TZLXTYLWvjEWdC+MMN7kSIuX3AWDY4ZiHK46EyvXH3tUYZmueJ/RLcMepSwoGzi12uoMI4ED
tqGSNDkqaexliBqAzgykhkIBHGBYUndKmQCXd5RbGtUHy+yvbTypHuiyKGkH7EPphLmddlHK80z3
wWI=
=FcZf
-----END PGP SIGNATURE-----

--------------oJCZBK4GHHRpqUEPQXjmBT7f--
