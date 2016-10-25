Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:19133 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751302AbcJYGIC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 02:08:02 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1byutw-0000lT-OM
        for linux-xfs@vger.kernel.org; Tue, 25 Oct 2016 17:07:56 +1100
Date: Tue, 25 Oct 2016 17:07:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: for-next branch updated to 077dd509197e
Message-ID: <20161025060756.GB23194@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HCdXmnRlPgeNBad2"
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


--HCdXmnRlPgeNBad2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Folks,

The for-next branch xfsprogs repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated. This is the libxfs sync with the 4.9-rc1
kernel code, along with all the fixes pending for 4.9-rc3. This
brings the tree up to the state where we can start adding all of
Darrick's userspace work to support shared data extents, and I can
catch up with all the other patches sitting on the list for
xfsprogs.

Darrick, can you compare these with your latest tree and point out
all the things I missed, even though the result compiles and seems
to run through xfstests fine. Also, if you rebase your next round of
userspace updates on this I can start reviewing them and pulling
them in...

-Dave.

The new head of the for-next branch is commit:

077dd509197e xfs: defer should abort intent items if the trans roll fails

New Commits:

Christoph Hellwig (3):
      [4488e42190ea] xfs: rewrite and optimize the delalloc write path
      [ece930fa14a3] xfs: refactor xfs_bunmapi_cow
      [2873ab2b8520] xfs: remove xfs_bunmapi_cow

Colin Ian King (1):
      [dd84fc92d7c4] xfs: remove redundant assignment of ifp

Darrick J. Wong (49):
      [11d87237b70f] xfs: track log done items directly in the deferred pen=
ding work item
      [a2fc338e64be] xfs: convert RUI log formats to use variable length ar=
rays
      [45413937e67f] xfs: remove xfs_btree_bigkey
      [fc8c849d1ca5] xfs: create a standard btree size calculator code
      [2cccc8cee723] xfs: count the blocks in a btree
      [0590692ed11e] xfs: defer should allow ->finish_item to request a new=
 transaction
      [cf8ce2204958] xfs: set up per-AG free space reservations
      [88ce079228b1] xfs: introduce refcount btree definitions
      [2a96beb95cb6] xfs: refcount btree add more reserved blocks
      [d8079fe03fe6] xfs: define the on-disk refcount btree format
      [dfa69e0a5cdd] xfs: account for the refcount btree in the alloc/free =
log reservation
      [bc859611285b] xfs: add refcount btree operations
      [a5a35c0d82f3] xfs: create refcount update intent log items
      [c1ea40108f36] xfs: log refcount intent items
      [56ef8c337692] xfs: adjust refcount of an extent of blocks in refcoun=
t btree
      [23a15a6c29c8] xfs: connect refcount adjust functions to upper layers
      [cfe32f0db83c] xfs: adjust refcount when unmapping file blocks
      [868c70e32419] xfs: reserve AG space for the refcount btree root
      [940973309b87] xfs: introduce reflink utility functions
      [0f7dadcf5bc9] xfs: create bmbt update intent log items
      [34f8f3e12ea5] xfs: log bmap intent items
      [34621a4761b8] xfs: map an inode's offset to an exact physical block
      [36b16da8bf88] xfs: pass bmapi flags through to bmap_del_extent
      [aeb88300f19d] xfs: implement deferred bmbt map/unmap operations
      [3d36acda7f86] xfs: return work remaining at the end of a bunmapi ope=
ration
      [f0b8028cb025] xfs: add reflink feature flag to geometry
      [9d3f10866346] xfs: don't allow reflinked dir/dev/fifo/socket/pipe fi=
les
      [cb8a004a12f7] xfs: introduce the CoW fork
      [cc66acaf151a] xfs: support bmapping delalloc extents in the CoW fork
      [1277a5e09266] xfs: support allocating delayed extents in CoW fork
      [d35205bac9f9] xfs: support removing extents from CoW fork
      [10e6550346b5] xfs: store in-progress CoW allocations in the refcount=
 btree
      [464e5807ebc6] xfs: teach get_bmapx about shared extents and the CoW =
fork
      [104609946adc] xfs: create a separate cow extent size hint for the al=
locator
      [02cc8b2a1b04] xfs: preallocate blocks for worst-case btree expansion
      [68d06dce0646] xfs: try other AGs to allocate a BMBT block
      [043983327af8] xfs: increase log reservations for reflink
      [2b7e542877b1] xfs: add shared rmap map/unmap/convert log item types
      [6c6bdf6f7982] xfs: use interval query for rmap alloc operations on s=
hared files
      [9c7bc093c30e] xfs: convert unwritten status of reverse mappings for =
shared files
      [183537ed6ee2] xfs: check for invalid inode reflink flags
      [378ed4e785ae] xfs: don't mix reflink and DAX mode for now
      [c7bf13987fdb] xfs: simulate per-AG reservations being critically low
      [2c834d2078b2] xfs: recognize the reflink feature bit
      [09a5b0e23115] xfs: implement swapext for rmap filesystems
      [22a693224bf7] xfs: rework refcount cow recovery error handling
      [2375c1f73b0d] libxfs: clean up _calc_dquots_per_chunk
      [b3fd8db7f773] xfs: add xfs_trim_extent
      [077dd509197e] xfs: defer should abort intent items if the trans roll=
 fails

Dave Chinner (4):
      [1516533c8c83] libxfs_apply: filter commits from libxfs only
      [ae11d3088dd7] libxfs_apply: filterdiff can't handle /dev/null proper=
ly
      [85428dd23fd0] xfs: fix superblock inprogress check
      [1fccd5c892c9] xfs: remote attribute blocks aren't really userdata

Eric Biggers (1):
      [1e85c20d20e2] xfs: add some 'static' annotations

Eric Sandeen (1):
      [114c49821dfe] xfs: remove pointless error goto in xfs_bmap_remap_all=
oc


Code Diffstat:

 include/darwin.h            |    1 +
 include/freebsd.h           |   13 +-
 include/gnukfreebsd.h       |   11 +-
 include/irix.h              |   10 +-
 include/linux.h             |    1 +
 include/xfs_inode.h         |   10 +
 include/xfs_mount.h         |   42 ++
 include/xfs_trace.h         |   84 +++
 libxfs/Makefile             |    6 +
 libxfs/defer_item.c         |    3 +-
 libxfs/libxfs_io.h          |    2 +-
 libxfs/libxfs_priv.h        |    7 +-
 libxfs/rdwr.c               |   20 +-
 libxfs/xfs_ag_resv.c        |  337 +++++++++
 libxfs/xfs_ag_resv.h        |   35 +
 libxfs/xfs_alloc.c          |  155 +++--
 libxfs/xfs_alloc.h          |   25 +-
 libxfs/xfs_bmap.c           |  782 +++++++++++++++++----
 libxfs/xfs_bmap.h           |   79 ++-
 libxfs/xfs_bmap_btree.c     |   18 +
 libxfs/xfs_btree.c          |   67 +-
 libxfs/xfs_btree.h          |   44 +-
 libxfs/xfs_defer.c          |  111 ++-
 libxfs/xfs_defer.h          |    4 +-
 libxfs/xfs_dquot_buf.c      |    1 -
 libxfs/xfs_format.h         |   97 ++-
 libxfs/xfs_fs.h             |   10 +-
 libxfs/xfs_ialloc_btree.c   |    2 +-
 libxfs/xfs_inode_buf.c      |   24 +-
 libxfs/xfs_inode_buf.h      |    1 +
 libxfs/xfs_inode_fork.c     |   70 +-
 libxfs/xfs_inode_fork.h     |   28 +-
 libxfs/xfs_log_format.h     |  128 +++-
 libxfs/xfs_refcount.c       | 1697 +++++++++++++++++++++++++++++++++++++++=
+++++++
 libxfs/xfs_refcount.h       |   70 ++
 libxfs/xfs_refcount_btree.c |  450 ++++++++++++
 libxfs/xfs_refcount_btree.h |   74 ++
 libxfs/xfs_rmap.c           | 1120 +++++++++++++++++++++++++++---
 libxfs/xfs_rmap.h           |    7 +
 libxfs/xfs_rmap_btree.c     |   82 ++-
 libxfs/xfs_rmap_btree.h     |    7 +
 libxfs/xfs_sb.c             |   12 +-
 libxfs/xfs_shared.h         |    2 +
 libxfs/xfs_trans_resv.c     |   23 +-
 libxfs/xfs_trans_resv.h     |    3 +
 libxfs/xfs_trans_space.h    |    9 +
 libxfs/xfs_types.h          |    3 +-
 repair/phase5.c             |    3 +-
 tools/libxfs-apply          |   52 +-
 49 files changed, 5387 insertions(+), 455 deletions(-)
 create mode 100644 libxfs/xfs_ag_resv.c
 create mode 100644 libxfs/xfs_ag_resv.h
 create mode 100644 libxfs/xfs_refcount.c
 create mode 100644 libxfs/xfs_refcount.h
 create mode 100644 libxfs/xfs_refcount_btree.c
 create mode 100644 libxfs/xfs_refcount_btree.h
--=20
Dave Chinner
david@fromorbit.com

--HCdXmnRlPgeNBad2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYDva8AAoJEK3oKUf0dfodETgP/2lrxEbTBmXvtyV6TDKyX8hG
h19L8soSui5jziLkamd4Au4/COgiKDdZqh2ZlWRaItW5IW60Jy/jlEFZJnoh3GE8
mdKTL6QU866OR8I3n16DTW3dTaLAfhbRKcn0oPN2Fuhw6CwMEvIlo3V7ApZJp3PI
4zoWzadq8fhH7h7i6r7+WtGZ3mJ6pDVUqJkBY/ryqfzmRct7K1l8isZSPz9PXa1R
XHgDd4MbKy6C9rz6+foJ3wxJWKffOlzrk/tYFyFBHpyTPduzzKGei1TcJ2zECn3C
yvhISAxO5MzY+0gW5J/D21G5nU7Tw+3KQccuIRt0EjFoC89A0F8wvIWKcDn2F/Yr
lybHkFrCp0VsptkdRse4JkHgRR9ufZJ+LCWT3lPNZwjVhclb+uhlnzCPivbwkKK3
nd6Rk6O62/3Voovr0ajDSs0BLFabM/aoIixgXfZDj4yEGA3LhX0g6hzHuilkHyRY
abImMlGBIFVmg/mTwO63Igqe1RRm35xozSHDwfKyfQmLrO4C4QMkbcd1aVKriSqF
7C2PJzYSZKI0D9N0I9263UOZ+fP7LduKgSK0kHhbgk1AzLeGRi715euYG0vO6UDM
kerEADx41u3vXdeutqRSK6/JS/PJFIFsWdktK0jfPdBhn5Upp20PYk3WaH6ZG8Rf
mW8X71M9lWopSd7Ewjz5
=VGA0
-----END PGP SIGNATURE-----

--HCdXmnRlPgeNBad2--
