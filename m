Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:23859 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753455AbcKBAWL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Nov 2016 20:22:11 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1c1jJe-0002vi-Rq
        for linux-xfs@vger.kernel.org; Wed, 02 Nov 2016 11:22:06 +1100
Date: Wed, 2 Nov 2016 11:22:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to 65b4f302b7a1
Message-ID: <20161102002206.GB14023@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UoPmpPX/dBe4BELn"
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


--UoPmpPX/dBe4BELn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Folks,

The master branch of the xfsprogs repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated. This update adds support for creating reflink
enabled filesystems so you'll all be able to test this functionality
straight from the official trees now. I've also included the patches
=66rom Felix to require full LFS support in the build environments and
remove all the *64 type and function variants. This means any
application now including XFS headers with a off_t type that is not
64 bit (i.e. not LFS compliant) will immediately fail compilation.

It also includes a couple of minor bug fixes that will help with
recent xfstests changes that have been committed.

-Dave.

The new head of the master branch is commit:

65b4f302b7a1 platform: remove use of off64_t

New Commits:

Amir Goldstein (1):
      [405eac72c028] xfs_io: add command line option -i to start an idle th=
read

Andreas Gruenbacher (1):
      [41c702ce4b2b] xfs_io: Fix initial -m option

Darrick J. Wong (39):
      [7f123ccebd3a] xfs_logprint: fix up the RUI printing code to reflect =
new format
      [f231685e0bd9] xfs_buflock: handling parsing errors more gracefully
      [e7be63305a7f] libxfs: initialize the in-core mount context for refco=
unt btrees
      [db17bb0e8d7e] libxfs: add xfs_refcount.h to the standard include list
      [cdc9cf256b38] libxfs: plumb in refcount deferred op log items
      [f8f8c8a01e78] libxfs: plumb in bmap deferred op log items
      [a90b9ad20857] libxfs: free the CoW fork from an inode
      [1bc58d936160] libxfs: add fsxattr flags and fields for cowextsize
      [9fb2cb27e678] xfs_db: dump refcount btree data
      [757ad8c74e72] xfs_db: add support for checking the refcount btree
      [e2756db38198] xfs_db: metadump should copy the refcount btree too
      [1f5407accc50] xfs_db: deal with the CoW extent size hint
      [384283555871] xfs_db: print one array element per line
      [24dc67741a7a] xfs_growfs: report the presence of the reflink feature
      [7536ce44f6a3] xfs_io: bmap should support querying CoW fork, shared =
blocks
      [6529e6565e7a] libxfs: add autoconf mechanism to override system head=
er fsxattr
      [1e51132f332f] xfs_io: get and set the CoW extent size hint
      [a136ec62b283] xfs_io: add refcount+bmap error injection types
      [e00481b11b15] xfs_io: support injecting the 'per-AG reservation crit=
ically low' error
      [0c2ed80a3590] xfs_io: provide long-format help for falloc
      [3825c565b2f8] xfs_io: try to unshare copy-on-write blocks via falloc=
ate
      [1fe708d60f2e] xfs_logprint: support cowextsize reporting in log cont=
ents
      [77e3149e8cbc] xfs_logprint: support refcount redo items
      [dc4957dfa10a] xfs_logprint: support bmap redo items
      [c77896fc158d] man: document the inode cowextsize flags & fields
      [15028317fd91] xfs_repair: fix get_agino_buf to avoid corrupting inod=
es
      [18c44aa9f36c] xfs_repair: check the existing refcount btree
      [a406779bc8d8] xfs_repair: handle multiple owners of data blocks
      [00f34bcaaa61] xfs_repair: process reverse-mapping data into refcount=
 data
      [7e174ec71c37] xfs_repair: record reflink inode state
      [ca8d7d6a8c52] xfs_repair: fix inode reflink flags
      [80dbc7832fcf] xfs_repair: check the refcount btree against our obser=
ved reference counts when -n
      [586a8fc3f2a8] xfs_repair: rebuild the refcount btree
      [13ef9674d053] xfs_repair: complain about copy-on-write leftovers
      [42627ba6ba6d] xfs_repair: check the CoW extent size hint
      [7ba02033425e] xfs_repair: use range query when while checking rmaps
      [7f168643f471] xfs_repair: check for mergeable refcount records
      [39bbc0a9e345] xfs_repair: use thread pools to sort rmap data
      [a5132d9b3634] mkfs.xfs: format reflink enabled filesystems

Felix Janda (14):
      [69268aaec5fb] configure: use AC_SYS_LARGEFILE
      [ebe750ed747c] configure: error out when LFS does not work
      [4a06616678f6] configure: remove unecessary definitions of _FILE_OFFS=
ET_BITS
      [f594a0d1db79] xfsprogs: replace [fl]stat64 by equivalent [fl]stat
      [dde67673040d] xfsprogs: replace ftruncate64 by equivalent ftruncate
      [dc8878f4b7e7] xfsprogs: replace lseek64 by equivalent lseek
      [2f9a125c3a39] xfsprogs: replace pread64/pwrite64 by equivalent pread=
/pwrite
      [0fe998999903] xfsprogs: replace sendfile64 by equivalent sendfile
      [f8edba5a5167] xfs_io: replace posix_fadvise64 by equivalent posix_fa=
dvise
      [ec0a99fa79d6] Makefile: disable fsr for Mac OS X
      [0ec6b7e972f8] fsr: remove workaround for statvfs on Mac OS X
      [09d38d96fccc] xfsprogs: replace statvfs64 by equivalent statvfs
      [7fda99a0c297] xfs.h: require transparent LFS for all users
      [65b4f302b7a1] platform: remove use of off64_t

Grozdan (1):
      [7efb94da61e4] xfsprogs: Update FSF address in COPYING file


Code Diffstat:

 Makefile                  |   6 +-
 configure.ac              |   4 +
 copy/xfs_copy.c           |  22 +-
 db/agf.c                  |   9 +
 db/btblock.c              |  55 +++++
 db/btblock.h              |   5 +
 db/check.c                | 149 +++++++++++++-
 db/field.c                |  13 ++
 db/field.h                |   6 +
 db/inode.c                |   7 +
 db/metadump.c             |  74 +++++++
 db/print.c                |   2 +-
 db/sb.c                   |   2 +
 db/type.c                 |   5 +
 db/type.h                 |   2 +-
 doc/COPYING               |   6 +-
 fsr/xfs_fsr.c             |  62 +++---
 growfs/xfs_growfs.c       |  12 +-
 include/builddefs.in      |   6 +-
 include/darwin.h          |  16 +-
 include/freebsd.h         |  13 +-
 include/irix.h            |   8 +-
 include/libxfs.h          |   2 +
 include/linux.h           |  19 +-
 include/xfs.h             |   5 +
 include/xfs_multidisk.h   |   3 +-
 include/xfs_trans.h       |   2 +
 io/Makefile               |   4 +-
 io/attr.c                 |   5 +-
 io/bmap.c                 |  43 +++-
 io/copy_file_range.c      |  10 +-
 io/cowextsize.c           | 202 ++++++++++++++++++
 io/fadvise.c              |   2 +-
 io/fiemap.c               |   1 -
 io/init.c                 |  36 +++-
 io/inject.c               |  10 +-
 io/io.h                   |   2 +
 io/open.c                 |  21 +-
 io/pread.c                |  16 +-
 io/prealloc.c             |  63 +++++-
 io/pwrite.c               |  10 +-
 io/seek.c                 |   6 +-
 io/sendfile.c             |  10 +-
 io/truncate.c             |   2 +-
 libxcmd/paths.c           |   4 +-
 libxfs/darwin.c           |   8 +-
 libxfs/defer_item.c       | 237 +++++++++++++++++++++
 libxfs/freebsd.c          |   8 +-
 libxfs/init.c             |  16 +-
 libxfs/init.h             |   6 +-
 libxfs/irix.c             |   8 +-
 libxfs/libxfs_api_defs.h  |   6 +
 libxfs/linux.c            |  20 +-
 libxfs/rdwr.c             |  20 +-
 logprint/log_misc.c       |  30 ++-
 logprint/log_print_all.c  |  28 +++
 logprint/log_redo.c       | 293 +++++++++++++++++++++++++-
 logprint/logprint.c       |   2 +-
 logprint/logprint.h       |  10 +
 m4/package_libcdev.m4     |  46 ++++-
 man/man3/xfsctl.3         |  28 ++-
 man/man8/mkfs.xfs.8       |  28 +++
 man/man8/xfs_bmap.8       |  14 ++
 man/man8/xfs_db.8         |  47 ++++-
 man/man8/xfs_io.8         |  31 ++-
 mdrestore/xfs_mdrestore.c |  12 +-
 mkfs/maxtrres.c           |   5 +-
 mkfs/proto.c              |   4 +-
 mkfs/xfs_mkfs.c           |  78 ++++++-
 po/de.po                  |  28 +--
 po/pl.po                  |  32 +--
 repair/dino_chunks.c      |   1 +
 repair/dinode.c           | 200 +++++++++++++++---
 repair/dinode.h           |  12 +-
 repair/incore.h           |  42 +++-
 repair/incore_ino.c       |   2 +
 repair/phase4.c           |  64 +++++-
 repair/phase5.c           | 316 +++++++++++++++++++++++++++-
 repair/prefetch.c         |   2 +-
 repair/rmap.c             | 544 ++++++++++++++++++++++++++++++++++++++++++=
++++++-
 repair/rmap.h             |  10 +
 repair/sb.c               |   6 +-
 repair/scan.c             | 295 ++++++++++++++++++++++++++-
 repair/slab.c             |  46 ++++-
 repair/xfs_repair.c       |   6 +-
 rtcp/xfs_rtcp.c           |  18 +-
 tools/xfsbuflock.py       |   5 +-
 87 files changed, 3261 insertions(+), 315 deletions(-)
 create mode 100644 io/cowextsize.c
--=20
Dave Chinner
david@fromorbit.com

--UoPmpPX/dBe4BELn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYGTGuAAoJEK3oKUf0dfodAjUP/2zcK6cXpbWfnQHEk0FOLD8N
f9sQvhi13TCq16Q8DVxyWDvfl8iAUIqEra0/ICHEmJkbjPni53PEADwHwRv0t41B
sg8zhWP+6ichvgCYRBqDP10hZfyAe+SVVDaieCgr43Ez4PkdyM5ZWPItkggxbSfB
WYIG/V0pcPbmaWa5WyxPnzZg9kQXMqcD9LicltcTimymMFClFqWffeIe7Xl9zch1
5In84HvE+kejI2uhsFoKsreyUSzffxdPTnysIpxdEJz/VXCy88Su+nNlX93UiRrJ
c9TXU2dgKYM60L7uds7R1F+w3r6zjcITI75R7+5BmD6UhLjQSgnbSbf9R9kPR3SW
DqofsFqE3+9jqwFJGvS1MXFoQsI+DJLQtW+OkJiwal/IRJNkpvwufMvJl5bkrBK2
t7ppaQUdubyx20Wr2Co3CoKH/Z/l1SDpcUXRWMbc7Z5ekMHYW1LLmUkBYnMC+Cly
dr0t9dwtlzWMaghfDfwX7lxtW/wtbX1aKVd+2dXIosTuBwXS+XbqfW9Ytp5iB1pF
/JIGmhgK4hWIQJ8j+PhJgOWPqY1S72OYRqnp1eaQnIRjNSL0jYcRD8r/BzlG8Wmx
rdO0Apl1dHpcyOzzG2tIQLSxWQK3TZGYHc9w4wMvy/kx3T+Wz5VBfkI4yaL0FcES
DeNCGoSyxXAV28uVk+Lp
=P+cl
-----END PGP SIGNATURE-----

--UoPmpPX/dBe4BELn--
