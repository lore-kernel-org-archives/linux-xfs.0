Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55190 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751443AbdK0VTc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Nov 2017 16:19:32 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 621453258
        for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2017 15:19:06 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 6e72e94
Message-ID: <432840de-7ccc-d883-b33e-1d6ec787a3a4@sandeen.net>
Date: Mon, 27 Nov 2017 15:19:31 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2NhqOKiU10W3QSN72mxbqGEK7etKiBDNk"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2NhqOKiU10W3QSN72mxbqGEK7etKiBDNk
Content-Type: multipart/mixed; boundary="S09PfP2VEcet2rfxMgbolsUWTtLfHwmo0";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <432840de-7ccc-d883-b33e-1d6ec787a3a4@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 6e72e94

--S09PfP2VEcet2rfxMgbolsUWTtLfHwmo0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.  This is "only" the (large!) libxfs
resync for 4.15, so far.  Will get to xfsprogs-specific content
next.

The new head of the for-next branch is commit:

6e72e94 Merge branch 'libxfs-4.15-sync' into for-next

New Commits:

Christoph Hellwig (64):
      [0fcf377] xfs: fix incorrect extent state in xfs_bmap_add_extent_un=
written
      [99a663c] xfs: use xfs_iext_get_extent instead of open coding it
      [e9fa15a] xfs: don't set XFS_BTCUR_BPRV_WASDEL in xfs_bunmapi
      [675b5a2] xfs: rename bno to end in __xfs_bunmapi
      [ad68fd1] xfs: use xfs_bmap_del_extent_delay for the data fork as w=
ell
      [bd92a38] xfs: move some more code into xfs_bmap_del_extent_real
      [d0a03e5] xfs: use correct state defines in xfs_bmap_del_extent_{co=
w,delay
      [b039ac7] xfs: use the state defines in xfs_bmap_del_extent_real
      [70bf753] xfs: refactor xfs_del_extent_real
      [450b398] xfs: refactor xfs_bmap_add_extent_hole_delay
      [3281eb9] xfs: refactor xfs_bmap_add_extent_hole_real
      [1988471] xfs: refactor xfs_bmap_add_extent_delay_real
      [5bfca47] xfs: refactor delalloc accounting in xfs_bmap_add_extent_=
delay_r
      [fd19685] xfs: refactor xfs_bmap_add_extent_unwritten_real
      [d0e5f1f] xfs: pass a struct xfs_bmbt_irec to xfs_bmbt_update
      [70a9311] xfs: pass a struct xfs_bmbt_irec to xfs_bmbt_lookup_eq
      [4f76f49] xfs: replace xfs_bmbt_lookup_ge with xfs_bmbt_lookup_firs=
t
      [adddf4b] xfs: remove all xfs_bmbt_set_* helpers except for xfs_bmb=
t_set_a
      [bb318cd] xfs: remove xfs_bmbt_get_state
      [7bd4333] xfs: add a xfs_bmap_fork_to_state helper
      [1a32da8] xfs: make better use of the 'state' variable in xfs_bmap_=
del_ext
      [cfe299d] xfs: remove post-bmap tracing in xfs_bmap_local_to_extent=
s
      [df926c0] xfs: move pre/post-bmap tracing into xfs_iext_update_exte=
nt
      [322fd80] xfs: remove XFS_BMAP_TRACE_EXLIST
      [95817f5] xfs: remove the never fully implemented UUID fork format
      [551174e] xfs: remove if_rdev
      [6835c36] xfs: remove XFS_BMAP_MAX_SHIFT_EXTENTS
      [a9f5d25] xfs: split xfs_bmap_shift_extents
      [364937e] xfs: remove xfs_bmse_shift_one
      [f36ccac] xfs: update got in xfs_bmap_shift_update_extent
      [bac2049] xfs: don't rely on extent indices in xfs_bmap_collapse_ex=
tents
      [bd80a80] xfs: don't rely on extent indices in xfs_bmap_insert_exte=
nts
      [2d3a650] xfs: rewrite xfs_bmap_first_unused to make better use of =
xfs_iex
      [6d79c95] xfs: merge xfs_bmap_read_extents into xfs_iread_extents
      [d6fbe8f] xfs: add a new xfs_iext_lookup_extent_before helper
      [4ed3a0f] xfs: remove the inode log format from the inode log item
      [d29ce39] xfs: don't create overlapping extents in xfs_bmap_add_ext=
ent_del
      [bc5dec5] xfs: remove a duplicate assignment in xfs_bmap_add_extent=
_delay_
      [12ebbfe] xfs: treat idx as a cursor in xfs_bmap_add_extent_delay_r=
eal
      [ee2bb3f] xfs: treat idx as a cursor in xfs_bmap_add_extent_hole_de=
lay
      [501dd27] xfs: treat idx as a cursor in xfs_bmap_add_extent_hole_re=
al
      [8121dd7] xfs: treat idx as a cursor in xfs_bmap_add_extent_unwritt=
en_real
      [2844122] xfs: treat idx as a cursor in xfs_bmap_del_extent_*
      [c162e31] xfs: treat idx as a cursor in xfs_bmap_collapse_extents
      [36d7c0a] xfs: pass an on-disk extent to xfs_bmbt_validate_extent
      [f11e750] xfs: iterate over extents in xfs_iextents_copy
      [62ed733] xfs: iterate over extents in xfs_bmap_extents_to_btree
      [9788e05] xfs: introduce the xfs_iext_cursor abstraction
      [8e87c88] xfs: simplify xfs_reflink_convert_cow
      [07fe466] xfs: remove support for inlining data/extents into the in=
ode for
      [c2e6c70] xfs: allow unaligned extent records in xfs_bmbt_disk_set_=
all
      [b37d753] xfs: use a b+tree for the in-core extent list
      [26a75f6] xfs: remove the nr_extents argument to xfs_iext_insert
      [cf455a6] xfs: remove the nr_extents argument to xfs_iext_remove
      [080f0c7] xfs: pass struct xfs_bmbt_irec to xfs_bmbt_validate_exten=
t
      [5837f99] xfs: move xfs_bmbt_irec and xfs_exntst_t to xfs_types.h
      [246486c] xfs: mark xfs_btree_check_lblock and xfs_btree_check_ptr =
static
      [fd4c3ba] xfs: fix number of records handling in xfs_iext_split_lea=
f
      [ba0bf2c] xfs: add some comments to xfs_iext_insert/xfs_iext_insert=
_node
      [f3c6504] xfs: remove a superflous assignment in xfs_iext_remove_no=
de
      [c45b87c] xfs: trivial indentation fixup for xfs_iext_remove_node
      [373c077] xfs: add comments documenting the rebalance algorithm
      [546f383] xfs: handle zero entries case in xfs_iext_rebalance_leaf
      [dc9b1f5] xfs: abstract out dev_t conversions

Colin Ian King (1):
      [d92c880] xfs: remove redundant assignment to variable bit

Darrick J. Wong (28):
      [9bef625] xfs: create block pointer check functions
      [d5c546d] xfs: refactor btree pointer checks
      [b47beff] xfs: refactor btree block header checking functions
      [be3bf25] xfs: create inode pointer verifiers
      [afbe3b6] xfs: create an ioctl to scrub AG metadata
      [d17a627] xfs: probe the scrub ioctl
      [15c4e6e] xfs: scrub the shape of a metadata btree
      [f253a97] xfs: scrub the secondary superblocks
      [d6e1f78] xfs: scrub AGF and AGFL
      [1770bca] xfs: scrub the AGI
      [1b07bd7] xfs: scrub free space btrees
      [3898cda] xfs: scrub inode btrees
      [d21c412] xfs: scrub rmap btrees
      [286f7cc] xfs: scrub refcount btrees
      [1155b77] xfs: scrub inodes
      [c123295] xfs: scrub inode block mappings
      [16c101b] xfs: scrub directory metadata
      [97ebbf2] xfs: scrub extended attributes
      [3db552c] xfs: scrub symbolic links
      [9d9d4f0] xfs: scrub directory parent pointers
      [1da1b67] xfs: scrub realtime bitmap/summary
      [821a975] xfs: scrub quota information
      [9473ee3] xfs: abort dir/attr btree operation if btree is obviously=
 weird
      [0ad12e7] xfs: compare btree block keys to parent block's keys duri=
ng scru
      [e784bcd] xfs: remove inode log format typedef
      [56d3fc2] xfs: move error injection tags into their own file
      [52da310] xfs: remove u_int* type usage
      [0484232] xfs: fix type usage

Dave Chinner (1):
      [893d9af] xfs: convert remaining xfs_sb_version_... checks to bool

Eric Sandeen (1):
      [6e72e94] Merge branch 'libxfs-4.15-sync' into for-next

Shu Wang (1):
      [c822b63] xfs: fix memory leak in xfs_iext_free_last_leaf


Code Diffstat:

 include/libxfs.h          |   17 +-
 include/xfs_inode.h       |    1 +
 include/xfs_trace.h       |    7 +-
 include/xfs_trans.h       |    1 -
 libxfs/Makefile           |    2 +
 libxfs/libxfs_priv.h      |   23 +
 libxfs/logitem.c          |    5 -
 libxfs/util.c             |   24 +-
 libxfs/xfs_ag_resv.c      |    1 +
 libxfs/xfs_alloc.c        |   50 ++
 libxfs/xfs_alloc.h        |    4 +
 libxfs/xfs_attr_leaf.c    |    6 +-
 libxfs/xfs_bmap.c         | 2061 ++++++++++++++++++---------------------=
------
 libxfs/xfs_bmap.h         |   66 +-
 libxfs/xfs_bmap_btree.c   |  250 +-----
 libxfs/xfs_bmap_btree.h   |   22 +-
 libxfs/xfs_btree.c        |  259 +++---
 libxfs/xfs_btree.h        |   32 +-
 libxfs/xfs_da_btree.c     |   22 +-
 libxfs/xfs_dir2.c         |   24 +-
 libxfs/xfs_dir2.h         |   17 +
 libxfs/xfs_errortag.h     |  106 +++
 libxfs/xfs_format.h       |   35 +-
 libxfs/xfs_fs.h           |   77 ++
 libxfs/xfs_ialloc.c       |   91 ++
 libxfs/xfs_ialloc.h       |    7 +
 libxfs/xfs_iext_tree.c    | 1043 +++++++++++++++++++++++
 libxfs/xfs_inode_buf.c    |    1 +
 libxfs/xfs_inode_fork.c   | 1331 ++---------------------------
 libxfs/xfs_inode_fork.h   |  138 ++-
 libxfs/xfs_log_format.h   |   24 +-
 libxfs/xfs_refcount.c     |    1 +
 libxfs/xfs_rmap.c         |    1 +
 libxfs/xfs_rtbitmap.c     |   13 +-
 libxfs/xfs_types.h        |   22 +
 libxlog/xfs_log_recover.c |    4 +-
 logprint/log_misc.c       |   17 +-
 logprint/log_print_all.c  |    4 +-
 logprint/logprint.h       |    4 +-
 repair/phase6.c           |   10 +-
 40 files changed, 2740 insertions(+), 3083 deletions(-)
 create mode 100644 libxfs/xfs_errortag.h
 create mode 100644 libxfs/xfs_iext_tree.c


--S09PfP2VEcet2rfxMgbolsUWTtLfHwmo0--

--2NhqOKiU10W3QSN72mxbqGEK7etKiBDNk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlocgWMACgkQIK4WkuE9
3uCLIg//Yw+XnMuc7qEhtE8y+7OgDeXKoecgL2d7SPLa2VZ8psp8NzT0+k79SCZM
uMcnlR6qA7gnHPuzaOvgIrNiyjnPcqLtpRRXpfVf6n7rd1WCdODVcb37mOolNkeW
eOy/Zl7/w3k4A3pzqSVYNACqvk4qEfh7aMK4kUCn2WHRuLAt1w6yZhe2yUjAEQz+
3/oUZ+xD7x+7ubZq+1JDWXk7TVF5ll6afh6jldT5an2ISlVR3vzJVDLS5NC/etRT
rjpbV7hW5GQx1WSwVm8QJW5p0gOaaER3/UgMAHzd+rGVr5+IuN/v1qB2ubZzxL4q
tJjsgkMzEWQ6OQyXki/S65VtHIuJY0ohelNQOLr3dUguD+tsxKpStEFAHycToF+c
oCbJFe1MSd7KtnWEERddFlVlcw200afl+DLI2kMXv6qYuZ6FbQz5gVuvSVFS+UF7
xvIH4g+u0oNoW0z25+YZeWLVyrXa+tECM2K05FCuD/q3zSniwVJXf30+cG98TtuT
d3R5ESxWcBvN+3oZJwR7/8e3JYNNh2nBTpeott69Zh42r26SivLvTvSbVztaAgby
0sjcyQQ45uvXUNjK7DFSqNqClBDF3/ylrCxi7LyDVjxVS4IyhkHbk/i7mP+FkaiO
egBETnR55Dm4sPYyLCBPFQuLFcQpeWrRLgl0rbw0lsfJa1E8x30=
=gD45
-----END PGP SIGNATURE-----

--2NhqOKiU10W3QSN72mxbqGEK7etKiBDNk--
