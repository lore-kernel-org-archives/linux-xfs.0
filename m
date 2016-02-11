Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1308B7CA3
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:39:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B4FC6AC003
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:39:25 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 5aihXUSwCSaDK00X (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:39:21 -0800 (PST)
Subject: [PATCH v4.2 00/32] xfstests: test the nfs/cifs/btrfs/xfs
	reflink/dedupe ioctls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:39:16 -0800
Message-ID: <20160211233916.2202.40961.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Dave Chinner: I've renumbered the new tests and pushed to github[3] if
you'd like to pull.  See the pull request at the end of this message.

This is a patch set against the reflink/dedupe test cases in xfstests.
The first three patches fix errors in the existing reflink tests, some
of which are from Christoph Hellwig.

The next eight patches fix style errors, refactor commonly used code,
remove unnecessary clutter, and add missing _require* checks to the
existing reflink tests.

Patch 12 adds a test checking that unwritten extent conversion does
NOT happen after a directio write to an unwritten extent hits a disk
error.   Due to a bug in the VFS directio code, ext4 can disclose
stale disk contents if an aio dio write fails; XFS suffers this
problem for any failing dio write to an unwritten extent.  Christoph's
kernel patchset titled "vfs/xfs: directio updates to ease COW handling
V2" (and a separate ext4 warning cleanup) is needed to fix this.

Patches 13-31 add more reflink tests focusing on correct CoW behavior
particularly with the CoW extent size hint enabled.  It also provides
a few regression tests for bugs that have been hit while running XFS
reflink, a few tests of the quota accounting when various reflink
operations happen, and a few tests for get_bmapx to ensure that what
it reports is at least somewhat accurate.

Patch 25 adds a few basic reverse-mapping tests for XFS.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], xfstests[3],
xfs-docs[4], and man-pages[5].  All tests should pass on XFS, YMWV on
btrfs and ocfs2.

Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux/tree/for-dave
[2] https://github.com/djwong/xfsprogs/tree/for-dave
[3] https://github.com/djwong/xfstests/tree/for-dave
[4] https://github.com/djwong/xfs-documentation/tree/for-dave
[5] https://github.com/djwong/man-pages/commits/for-mtk

---

The following changes since commit d98149c205559950c03d6b1d539e45fd35b5630e:

  Fix prerequisite packages to build fstests on Ubuntu (2016-02-08 09:27:15 +1100)

are available in the git repository at:

  https://github.com/djwong/xfstests for-dave

for you to fetch changes up to 6e560dc336d857bc589b1debbf610fd2a3344ccd:

  reflink: kick the slow tests out of the 'quick' group (2016-02-11 15:27:47 -0800)

----------------------------------------------------------------
Darrick J. Wong (32):
      generic/182: this is a dedupe test, check for dedupe
      xfstests: filter whitespace in 128 and 132
      xfstests: make _scratch_mkfs_blocksized usable
      reflink: remove redundant filesystem checks from the end of the tests
      reflink: remove unnecessary umounts from test code
      common/dmerror: add some more dmerror routines
      common: create _require_test_program to look for programs in src/
      common: provide a method to repair the scratch fs
      reflink: refactor mixed block creation code
      reflink: fix style problems in existing tests
      reflink: add _require_odirect to the directio tests
      dio: unwritten conversion bug tests
      reflink: test intersecting CoW and falloc/fpunch/fzero/fcollapse/finsert/ftrunc
      reflink: test CoW behavior with IO errors
      reflink: test CoW operations against the source file
      reflink: ensure that we can handle reflinking a lot of extents
      xfs: more reflink tests
      xfs/122: support refcount/rmap data structures
      xfs: test fragmentation characteristics of copy-on-write
      reflink: high offset reflink and dedupe tests
      reflink: test xfs cow behavior when the filesystem crashes
      reflink: test quota accounting
      reflink: test CoW across a mixed range of block types with cowextsize set
      xfs: test the automatic cowextsize extent garbage collector
      xfs: test rmapbt functionality
      reflink: test aio copy on write
      xfs: aio cow tests
      xfs: test xfs_getbmapx behavior with shared extents
      reflink: test reflink+cow+enospc all at the same time
      xfs: ensure that we don't crash when freeing the ag reservations on a ro mount
      xfs: test source CoW across mixed block types with cowextsz set
      reflink: kick the slow tests out of the 'quick' group

 .gitignore                  |   2 +
 common/dmerror              |  27 ++-
 common/rc                   | 117 +++++++++++
 common/reflink              | 202 +++++++++++++++---
 src/Makefile                |   2 +-
 src/aio-dio-regress/aiocp.c | 489 ++++++++++++++++++++++++++++++++++++++++++++
 src/punch-alternating.c     |  59 ++++++
 tests/btrfs/100             |   2 +-
 tests/btrfs/101             |   2 +-
 tests/generic/010           |   2 +-
 tests/generic/094           |   2 +-
 tests/generic/110           |   2 +-
 tests/generic/111           |   2 +-
 tests/generic/115           |   2 +-
 tests/generic/116           |  44 ++--
 tests/generic/118           |  42 ++--
 tests/generic/119           | 102 ++++-----
 tests/generic/121           |  44 ++--
 tests/generic/122           |  44 ++--
 tests/generic/134           |  78 +++----
 tests/generic/136           |  78 +++----
 tests/generic/137           |  44 ++--
 tests/generic/138           | 104 +++++-----
 tests/generic/139           |  99 ++++-----
 tests/generic/140           | 104 +++++-----
 tests/generic/142           |  37 ++--
 tests/generic/143           |  38 ++--
 tests/generic/144           | 124 +++++------
 tests/generic/145           | 150 +++++++-------
 tests/generic/146           | 132 ++++++------
 tests/generic/147           | 146 ++++++-------
 tests/generic/148           |  84 ++++----
 tests/generic/149           | 132 ++++++------
 tests/generic/150           |  23 ++-
 tests/generic/151           |  35 ++--
 tests/generic/152           |  39 ++--
 tests/generic/153           |  41 ++--
 tests/generic/154           |  43 ++--
 tests/generic/155           |  40 ++--
 tests/generic/156           |  43 ++--
 tests/generic/157           |  64 +++---
 tests/generic/157.out       |   1 -
 tests/generic/158           |  66 +++---
 tests/generic/158.out       |   1 -
 tests/generic/159           |  19 +-
 tests/generic/160           |  19 +-
 tests/generic/161           |  30 ++-
 tests/generic/161.out       |   2 -
 tests/generic/162           |  36 ++--
 tests/generic/162.out       |   2 -
 tests/generic/163           |  36 ++--
 tests/generic/163.out       |   2 -
 tests/generic/164           |  40 ++--
 tests/generic/164.out       |   2 -
 tests/generic/165           |  39 ++--
 tests/generic/165.out       |   2 -
 tests/generic/166           |  36 ++--
 tests/generic/166.out       |   2 -
 tests/generic/167           |  35 ++--
 tests/generic/167.out       |   2 -
 tests/generic/168           |  37 ++--
 tests/generic/168.out       |   2 -
 tests/generic/170           |  38 ++--
 tests/generic/170.out       |   2 -
 tests/generic/171           |  62 +++---
 tests/generic/171.out       |   1 -
 tests/generic/172           |  62 +++---
 tests/generic/172.out       |   1 -
 tests/generic/173           |  54 +++--
 tests/generic/173.out       |   1 -
 tests/generic/174           |  63 +++---
 tests/generic/174.out       |   1 -
 tests/generic/175           |  47 ++---
 tests/generic/175.out       |   5 +
 tests/generic/176           |  54 +++--
 tests/generic/176.out       |   5 +-
 tests/generic/178           |  31 +--
 tests/generic/179           |  50 ++---
 tests/generic/180           |  50 ++---
 tests/generic/181           |  38 ++--
 tests/generic/182           |  89 ++++----
 tests/generic/183           |  55 +++--
 tests/generic/183.out       |   1 -
 tests/generic/185           |  54 +++--
 tests/generic/185.out       |   1 -
 tests/generic/186           |  73 ++++---
 tests/generic/186.out       |   1 -
 tests/generic/187           |  74 +++----
 tests/generic/187.out       |   1 -
 tests/generic/188           |  47 ++---
 tests/generic/188.out       |   1 -
 tests/generic/189           |  46 ++---
 tests/generic/189.out       |   1 -
 tests/generic/190           |  47 ++---
 tests/generic/190.out       |   1 -
 tests/generic/191           |  46 ++---
 tests/generic/191.out       |   1 -
 tests/generic/194           |  52 ++---
 tests/generic/194.out       |   1 -
 tests/generic/195           |  51 ++---
 tests/generic/195.out       |   1 -
 tests/generic/196           |  49 ++---
 tests/generic/196.out       |   1 -
 tests/generic/197           |  48 ++---
 tests/generic/197.out       |   1 -
 tests/generic/199           |  70 ++-----
 tests/generic/199.out       |   5 +-
 tests/generic/200           |  70 ++-----
 tests/generic/200.out       |   5 +-
 tests/generic/201           |  42 ++--
 tests/generic/201.out       |   1 -
 tests/generic/202           |  41 ++--
 tests/generic/202.out       |   1 -
 tests/generic/203           |  42 ++--
 tests/generic/203.out       |   1 -
 tests/generic/205           |  51 +++--
 tests/generic/205.out       |   1 -
 tests/generic/206           |  52 +++--
 tests/generic/206.out       |   1 -
 tests/generic/216           |  51 +++--
 tests/generic/216.out       |   1 -
 tests/generic/217           |  52 +++--
 tests/generic/217.out       |   1 -
 tests/generic/218           |  43 ++--
 tests/generic/218.out       |   1 -
 tests/generic/220           |  44 ++--
 tests/generic/220.out       |   1 -
 tests/generic/222           |  51 +++--
 tests/generic/222.out       |   1 -
 tests/generic/225           |   2 +-
 tests/generic/227           |  52 +++--
 tests/generic/227.out       |   1 -
 tests/generic/229           |  77 ++++---
 tests/generic/229.out       |   1 -
 tests/generic/238           |  78 ++++---
 tests/generic/238.out       |   1 -
 tests/generic/242           |  51 +++--
 tests/generic/242.out       |   1 -
 tests/generic/243           |  52 +++--
 tests/generic/243.out       |   1 -
 tests/generic/250           | 100 +++++++++
 tests/generic/250.out       |  10 +
 tests/generic/252           | 103 ++++++++++
 tests/generic/252.out       |  10 +
 tests/generic/253           |  90 ++++++++
 tests/generic/253.out       |  12 ++
 tests/generic/254           |  90 ++++++++
 tests/generic/254.out       |  12 ++
 tests/generic/259           |  90 ++++++++
 tests/generic/259.out       |  12 ++
 tests/generic/261           |  90 ++++++++
 tests/generic/261.out       |  12 ++
 tests/generic/262           |  93 +++++++++
 tests/generic/262.out       |  12 ++
 tests/generic/264           |  90 ++++++++
 tests/generic/264.out       |  12 ++
 tests/generic/265           |  99 +++++++++
 tests/generic/265.out       |  11 +
 tests/generic/266           |  97 +++++++++
 tests/generic/266.out       |  11 +
 tests/generic/267           | 100 +++++++++
 tests/generic/267.out       |  10 +
 tests/generic/268           | 103 ++++++++++
 tests/generic/268.out       |  12 ++
 tests/generic/271           | 100 +++++++++
 tests/generic/271.out       |  11 +
 tests/generic/272           |  98 +++++++++
 tests/generic/272.out       |  11 +
 tests/generic/276           | 101 +++++++++
 tests/generic/276.out       |  11 +
 tests/generic/278           | 104 ++++++++++
 tests/generic/278.out       |  12 ++
 tests/generic/279           | 100 +++++++++
 tests/generic/279.out       |  11 +
 tests/generic/281           |  98 +++++++++
 tests/generic/281.out       |  11 +
 tests/generic/282           | 101 +++++++++
 tests/generic/282.out       |  10 +
 tests/generic/283           | 104 ++++++++++
 tests/generic/283.out       |  12 ++
 tests/generic/284           |  89 ++++++++
 tests/generic/284.out       |  12 ++
 tests/generic/285           |   2 +-
 tests/generic/286           |   2 +-
 tests/generic/287           |  90 ++++++++
 tests/generic/287.out       |  12 ++
 tests/generic/289           |  91 +++++++++
 tests/generic/289.out       |  12 ++
 tests/generic/290           |  92 +++++++++
 tests/generic/290.out       |  12 ++
 tests/generic/291           |  91 +++++++++
 tests/generic/291.out       |  12 ++
 tests/generic/292           |  92 +++++++++
 tests/generic/292.out       |  12 ++
 tests/generic/293           |  93 +++++++++
 tests/generic/293.out       |  12 ++
 tests/generic/295           |  94 +++++++++
 tests/generic/295.out       |  12 ++
 tests/generic/296           |  90 ++++++++
 tests/generic/296.out       |  12 ++
 tests/generic/297           |  99 +++++++++
 tests/generic/297.out       |   6 +
 tests/generic/298           |  99 +++++++++
 tests/generic/298.out       |   6 +
 tests/generic/301           | 100 +++++++++
 tests/generic/301.out       |  10 +
 tests/generic/302           | 101 +++++++++
 tests/generic/302.out       |  10 +
 tests/generic/303           |  98 +++++++++
 tests/generic/303.out       |  21 ++
 tests/generic/304           |  99 +++++++++
 tests/generic/304.out       |  22 ++
 tests/generic/305           | 100 +++++++++
 tests/generic/305.out       |  22 ++
 tests/generic/311           |   2 +-
 tests/generic/326           | 101 +++++++++
 tests/generic/326.out       |  22 ++
 tests/generic/327           |  87 ++++++++
 tests/generic/327.out       |  12 ++
 tests/generic/328           | 105 ++++++++++
 tests/generic/328.out       |  25 +++
 tests/generic/329           | 102 +++++++++
 tests/generic/329.out       |  12 ++
 tests/generic/330           |  93 +++++++++
 tests/generic/330.out       |  11 +
 tests/generic/331           | 104 ++++++++++
 tests/generic/331.out       |  12 ++
 tests/generic/332           |  94 +++++++++
 tests/generic/332.out       |  11 +
 tests/generic/333           |  99 +++++++++
 tests/generic/333.out       |   4 +
 tests/generic/334           |  98 +++++++++
 tests/generic/334.out       |   4 +
 tests/generic/group         |  71 +++++--
 tests/xfs/032               |   3 +-
 tests/xfs/044               |   2 +-
 tests/xfs/122               |   3 +
 tests/xfs/122.out           |   4 +
 tests/xfs/127               |  33 ++-
 tests/xfs/127.out           |   1 -
 tests/xfs/128               |  97 +++++----
 tests/xfs/128.out           |   9 +-
 tests/xfs/129               |  33 ++-
 tests/xfs/131               |  25 +--
 tests/xfs/131.out           |   1 -
 tests/xfs/132               |  53 ++---
 tests/xfs/132.out           |  40 ++--
 tests/xfs/139               |  35 ++--
 tests/xfs/139.out           |   1 -
 tests/xfs/140               |  41 ++--
 tests/xfs/140.out           |   1 -
 tests/xfs/169               |  86 ++++++++
 tests/xfs/169.out           |   7 +
 tests/xfs/179               | 118 +++++++++++
 tests/xfs/179.out           |  10 +
 tests/xfs/180               | 106 ++++++++++
 tests/xfs/180.out           |  11 +
 tests/xfs/182               | 107 ++++++++++
 tests/xfs/182.out           |  12 ++
 tests/xfs/184               | 105 ++++++++++
 tests/xfs/184.out           |  10 +
 tests/xfs/192               | 106 ++++++++++
 tests/xfs/192.out           |  10 +
 tests/xfs/193               | 102 +++++++++
 tests/xfs/193.out           |  10 +
 tests/xfs/198               | 103 ++++++++++
 tests/xfs/198.out           |  10 +
 tests/xfs/200               | 109 ++++++++++
 tests/xfs/200.out           |  10 +
 tests/xfs/204               | 110 ++++++++++
 tests/xfs/204.out           |  10 +
 tests/xfs/207               | 101 +++++++++
 tests/xfs/207.out           |  18 ++
 tests/xfs/208               | 138 +++++++++++++
 tests/xfs/208.out           |  13 ++
 tests/xfs/209               |  82 ++++++++
 tests/xfs/209.out           |  13 ++
 tests/xfs/210               | 108 ++++++++++
 tests/xfs/210.out           |  23 +++
 tests/xfs/211               | 107 ++++++++++
 tests/xfs/211.out           |  11 +
 tests/xfs/212               |  99 +++++++++
 tests/xfs/212.out           |  13 ++
 tests/xfs/213               | 105 ++++++++++
 tests/xfs/213.out           |  22 ++
 tests/xfs/214               | 106 ++++++++++
 tests/xfs/214.out           |  22 ++
 tests/xfs/215               | 102 +++++++++
 tests/xfs/215.out           |  13 ++
 tests/xfs/218               | 101 +++++++++
 tests/xfs/218.out           |  13 ++
 tests/xfs/219               | 102 +++++++++
 tests/xfs/219.out           |  13 ++
 tests/xfs/221               | 101 +++++++++
 tests/xfs/221.out           |  13 ++
 tests/xfs/223               | 104 ++++++++++
 tests/xfs/223.out           |  13 ++
 tests/xfs/224               | 103 ++++++++++
 tests/xfs/224.out           |  13 ++
 tests/xfs/225               | 102 +++++++++
 tests/xfs/225.out           |  13 ++
 tests/xfs/226               | 101 +++++++++
 tests/xfs/226.out           |  13 ++
 tests/xfs/228               | 110 ++++++++++
 tests/xfs/228.out           |  13 ++
 tests/xfs/230               | 110 ++++++++++
 tests/xfs/230.out           |  13 ++
 tests/xfs/231               | 130 ++++++++++++
 tests/xfs/231.out           |  16 ++
 tests/xfs/232               | 132 ++++++++++++
 tests/xfs/232.out           |  16 ++
 tests/xfs/233               |  73 +++++++
 tests/xfs/233.out           |   5 +
 tests/xfs/234               |  88 ++++++++
 tests/xfs/234.out           |   6 +
 tests/xfs/235               | 108 ++++++++++
 tests/xfs/235.out           |  14 ++
 tests/xfs/236               |  88 ++++++++
 tests/xfs/236.out           |   7 +
 tests/xfs/237               | 105 ++++++++++
 tests/xfs/237.out           |  12 ++
 tests/xfs/239               |  98 +++++++++
 tests/xfs/239.out           |  11 +
 tests/xfs/240               | 110 ++++++++++
 tests/xfs/240.out           |  12 ++
 tests/xfs/241               | 100 +++++++++
 tests/xfs/241.out           |  11 +
 tests/xfs/243               | 165 +++++++++++++++
 tests/xfs/243.out           |  26 +++
 tests/xfs/245               |  95 +++++++++
 tests/xfs/245.out           |  12 ++
 tests/xfs/246               |  65 ++++++
 tests/xfs/246.out           |   6 +
 tests/xfs/247               |  57 ++++++
 tests/xfs/247.out           |   2 +
 tests/xfs/248               |  91 +++++++++
 tests/xfs/248.out           |  12 ++
 tests/xfs/249               |  92 +++++++++
 tests/xfs/249.out           |  12 ++
 tests/xfs/251               |  93 +++++++++
 tests/xfs/251.out           |  12 ++
 tests/xfs/254               |  94 +++++++++
 tests/xfs/254.out           |  12 ++
 tests/xfs/255               |  93 +++++++++
 tests/xfs/255.out           |  12 ++
 tests/xfs/256               |  94 +++++++++
 tests/xfs/256.out           |  12 ++
 tests/xfs/257               |  95 +++++++++
 tests/xfs/257.out           |  12 ++
 tests/xfs/258               |  96 +++++++++
 tests/xfs/258.out           |  12 ++
 tests/xfs/group             |  56 ++++-
 352 files changed, 13925 insertions(+), 2729 deletions(-)
 create mode 100644 src/aio-dio-regress/aiocp.c
 create mode 100644 src/punch-alternating.c
 create mode 100755 tests/generic/250
 create mode 100644 tests/generic/250.out
 create mode 100755 tests/generic/252
 create mode 100644 tests/generic/252.out
 create mode 100755 tests/generic/253
 create mode 100644 tests/generic/253.out
 create mode 100755 tests/generic/254
 create mode 100644 tests/generic/254.out
 create mode 100755 tests/generic/259
 create mode 100644 tests/generic/259.out
 create mode 100755 tests/generic/261
 create mode 100644 tests/generic/261.out
 create mode 100755 tests/generic/262
 create mode 100644 tests/generic/262.out
 create mode 100755 tests/generic/264
 create mode 100644 tests/generic/264.out
 create mode 100755 tests/generic/265
 create mode 100644 tests/generic/265.out
 create mode 100755 tests/generic/266
 create mode 100644 tests/generic/266.out
 create mode 100755 tests/generic/267
 create mode 100644 tests/generic/267.out
 create mode 100755 tests/generic/268
 create mode 100644 tests/generic/268.out
 create mode 100755 tests/generic/271
 create mode 100644 tests/generic/271.out
 create mode 100755 tests/generic/272
 create mode 100644 tests/generic/272.out
 create mode 100755 tests/generic/276
 create mode 100644 tests/generic/276.out
 create mode 100755 tests/generic/278
 create mode 100644 tests/generic/278.out
 create mode 100755 tests/generic/279
 create mode 100644 tests/generic/279.out
 create mode 100755 tests/generic/281
 create mode 100644 tests/generic/281.out
 create mode 100755 tests/generic/282
 create mode 100644 tests/generic/282.out
 create mode 100755 tests/generic/283
 create mode 100644 tests/generic/283.out
 create mode 100755 tests/generic/284
 create mode 100644 tests/generic/284.out
 create mode 100755 tests/generic/287
 create mode 100644 tests/generic/287.out
 create mode 100755 tests/generic/289
 create mode 100644 tests/generic/289.out
 create mode 100755 tests/generic/290
 create mode 100644 tests/generic/290.out
 create mode 100755 tests/generic/291
 create mode 100644 tests/generic/291.out
 create mode 100755 tests/generic/292
 create mode 100644 tests/generic/292.out
 create mode 100755 tests/generic/293
 create mode 100644 tests/generic/293.out
 create mode 100755 tests/generic/295
 create mode 100644 tests/generic/295.out
 create mode 100755 tests/generic/296
 create mode 100644 tests/generic/296.out
 create mode 100755 tests/generic/297
 create mode 100644 tests/generic/297.out
 create mode 100755 tests/generic/298
 create mode 100644 tests/generic/298.out
 create mode 100755 tests/generic/301
 create mode 100644 tests/generic/301.out
 create mode 100755 tests/generic/302
 create mode 100644 tests/generic/302.out
 create mode 100755 tests/generic/303
 create mode 100644 tests/generic/303.out
 create mode 100755 tests/generic/304
 create mode 100644 tests/generic/304.out
 create mode 100755 tests/generic/305
 create mode 100644 tests/generic/305.out
 create mode 100755 tests/generic/326
 create mode 100644 tests/generic/326.out
 create mode 100755 tests/generic/327
 create mode 100644 tests/generic/327.out
 create mode 100755 tests/generic/328
 create mode 100644 tests/generic/328.out
 create mode 100755 tests/generic/329
 create mode 100644 tests/generic/329.out
 create mode 100755 tests/generic/330
 create mode 100644 tests/generic/330.out
 create mode 100755 tests/generic/331
 create mode 100644 tests/generic/331.out
 create mode 100755 tests/generic/332
 create mode 100644 tests/generic/332.out
 create mode 100755 tests/generic/333
 create mode 100644 tests/generic/333.out
 create mode 100755 tests/generic/334
 create mode 100644 tests/generic/334.out
 create mode 100755 tests/xfs/169
 create mode 100644 tests/xfs/169.out
 create mode 100755 tests/xfs/179
 create mode 100644 tests/xfs/179.out
 create mode 100755 tests/xfs/180
 create mode 100644 tests/xfs/180.out
 create mode 100755 tests/xfs/182
 create mode 100644 tests/xfs/182.out
 create mode 100755 tests/xfs/184
 create mode 100644 tests/xfs/184.out
 create mode 100755 tests/xfs/192
 create mode 100644 tests/xfs/192.out
 create mode 100755 tests/xfs/193
 create mode 100644 tests/xfs/193.out
 create mode 100755 tests/xfs/198
 create mode 100644 tests/xfs/198.out
 create mode 100755 tests/xfs/200
 create mode 100644 tests/xfs/200.out
 create mode 100755 tests/xfs/204
 create mode 100644 tests/xfs/204.out
 create mode 100755 tests/xfs/207
 create mode 100644 tests/xfs/207.out
 create mode 100755 tests/xfs/208
 create mode 100644 tests/xfs/208.out
 create mode 100755 tests/xfs/209
 create mode 100644 tests/xfs/209.out
 create mode 100755 tests/xfs/210
 create mode 100644 tests/xfs/210.out
 create mode 100755 tests/xfs/211
 create mode 100644 tests/xfs/211.out
 create mode 100755 tests/xfs/212
 create mode 100644 tests/xfs/212.out
 create mode 100755 tests/xfs/213
 create mode 100644 tests/xfs/213.out
 create mode 100755 tests/xfs/214
 create mode 100644 tests/xfs/214.out
 create mode 100755 tests/xfs/215
 create mode 100644 tests/xfs/215.out
 create mode 100755 tests/xfs/218
 create mode 100644 tests/xfs/218.out
 create mode 100755 tests/xfs/219
 create mode 100644 tests/xfs/219.out
 create mode 100755 tests/xfs/221
 create mode 100644 tests/xfs/221.out
 create mode 100755 tests/xfs/223
 create mode 100644 tests/xfs/223.out
 create mode 100755 tests/xfs/224
 create mode 100644 tests/xfs/224.out
 create mode 100755 tests/xfs/225
 create mode 100644 tests/xfs/225.out
 create mode 100755 tests/xfs/226
 create mode 100644 tests/xfs/226.out
 create mode 100755 tests/xfs/228
 create mode 100644 tests/xfs/228.out
 create mode 100755 tests/xfs/230
 create mode 100644 tests/xfs/230.out
 create mode 100755 tests/xfs/231
 create mode 100644 tests/xfs/231.out
 create mode 100755 tests/xfs/232
 create mode 100644 tests/xfs/232.out
 create mode 100755 tests/xfs/233
 create mode 100644 tests/xfs/233.out
 create mode 100755 tests/xfs/234
 create mode 100644 tests/xfs/234.out
 create mode 100755 tests/xfs/235
 create mode 100644 tests/xfs/235.out
 create mode 100755 tests/xfs/236
 create mode 100644 tests/xfs/236.out
 create mode 100755 tests/xfs/237
 create mode 100644 tests/xfs/237.out
 create mode 100755 tests/xfs/239
 create mode 100644 tests/xfs/239.out
 create mode 100755 tests/xfs/240
 create mode 100644 tests/xfs/240.out
 create mode 100755 tests/xfs/241
 create mode 100644 tests/xfs/241.out
 create mode 100755 tests/xfs/243
 create mode 100644 tests/xfs/243.out
 create mode 100755 tests/xfs/245
 create mode 100644 tests/xfs/245.out
 create mode 100755 tests/xfs/246
 create mode 100644 tests/xfs/246.out
 create mode 100755 tests/xfs/247
 create mode 100644 tests/xfs/247.out
 create mode 100755 tests/xfs/248
 create mode 100644 tests/xfs/248.out
 create mode 100755 tests/xfs/249
 create mode 100644 tests/xfs/249.out
 create mode 100755 tests/xfs/251
 create mode 100644 tests/xfs/251.out
 create mode 100755 tests/xfs/254
 create mode 100644 tests/xfs/254.out
 create mode 100755 tests/xfs/255
 create mode 100644 tests/xfs/255.out
 create mode 100755 tests/xfs/256
 create mode 100644 tests/xfs/256.out
 create mode 100755 tests/xfs/257
 create mode 100644 tests/xfs/257.out
 create mode 100755 tests/xfs/258
 create mode 100644 tests/xfs/258.out

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
