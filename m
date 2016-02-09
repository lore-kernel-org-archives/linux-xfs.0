Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D35AE7CA2
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 01:50:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 95AE88F8040
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 23:50:28 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 0dxE2r7CDvMYfNoD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 23:50:24 -0800 (PST)
Date: Mon, 8 Feb 2016 23:50:19 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v4.1 00/23] xfstests: test the nfs/cifs/btrfs/xfs
	reflink/dedupe ioctls
Message-ID: <20160209075019.GA6346@birch.djwong.org>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
	<20160209072106.GH19486@dastard>
	<20160209072511.GA23904@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160209072511.GA23904@birch.djwong.org>
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
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Aha, /me finds git request-pull.  Sorry for the noise.

--D

The following changes since commit d98149c205559950c03d6b1d539e45fd35b5630e:

  Fix prerequisite packages to build fstests on Ubuntu (2016-02-08 09:27:15 +1100)

are available in the git repository at:

  https://github.com/djwong/xfstests for-dave

for you to fetch changes up to 9799e5c5397b7aa14dbc660645ef4ccaf5418c78:

  reflink: test reflink+cow+enospc all at the same time (2016-02-08 17:07:36 -0800)

----------------------------------------------------------------
Darrick J. Wong (23):
      generic/182: this is a dedupe test, check for dedupe
      xfstests: filter whitespace in 128 and 132
      xfstests: make _scratch_mkfs_blocksized usable
      reflink: remove redundant filesystem checks from the end of the tests
      common/dmerror: add some more dmerror routines
      dio unwritten conversion bug tests
      reflink: test intersecting CoW and falloc/fpunch/fzero/fcollapse/finsert/ftrunc
      reflink: test CoW behavior with IO errors
      reflink: test CoW operations against the source file
      xfs: more reflink tests
      reflink: ensure that we can handle reflinking a lot of extents
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

 .gitignore                  |   2 +
 common/dmerror              |  27 ++-
 common/rc                   |  52 +++++
 common/reflink              |  32 +--
 common/xfs                  |  63 ++++++
 src/Makefile                |   2 +-
 src/aio-dio-regress/aiocp.c | 489 ++++++++++++++++++++++++++++++++++++++++++++
 src/punch-alternating.c     |  59 ++++++
 tests/btrfs/100             |   2 +-
 tests/btrfs/101             |   2 +-
 tests/generic/157           |   1 -
 tests/generic/158           |   1 -
 tests/generic/161           |   1 -
 tests/generic/162           |   1 -
 tests/generic/163           |   1 -
 tests/generic/164           |   1 -
 tests/generic/165           |   1 -
 tests/generic/166           |   7 +-
 tests/generic/167           |   7 +-
 tests/generic/168           |   1 -
 tests/generic/170           |   1 -
 tests/generic/171           |   1 -
 tests/generic/172           |   1 -
 tests/generic/173           |   1 -
 tests/generic/174           |   1 -
 tests/generic/175           |  43 ++--
 tests/generic/175.out       |   6 +
 tests/generic/176           |  51 +++--
 tests/generic/176.out       |   4 +-
 tests/generic/182           |   9 +-
 tests/generic/183           |   1 -
 tests/generic/185           |   1 -
 tests/generic/186           |   1 -
 tests/generic/187           |   1 -
 tests/generic/188           |   1 -
 tests/generic/189           |   1 -
 tests/generic/190           |   1 -
 tests/generic/191           |   1 -
 tests/generic/194           |   1 -
 tests/generic/195           |   1 -
 tests/generic/196           |   3 +-
 tests/generic/197           |   3 +-
 tests/generic/199           |   1 -
 tests/generic/200           |   1 -
 tests/generic/201           |   1 -
 tests/generic/202           |   1 -
 tests/generic/203           |   1 -
 tests/generic/205           |   1 -
 tests/generic/206           |   1 -
 tests/generic/216           |   1 -
 tests/generic/217           |   1 -
 tests/generic/218           |   1 -
 tests/generic/220           |   1 -
 tests/generic/222           |   1 -
 tests/generic/227           |   1 -
 tests/generic/229           |   1 -
 tests/generic/238           |   1 -
 tests/generic/242           |   1 -
 tests/generic/243           |   1 -
 tests/generic/250           | 104 ++++++++++
 tests/generic/250.out       |  10 +
 tests/generic/252           | 107 ++++++++++
 tests/generic/252.out       |  10 +
 tests/generic/253           |  93 +++++++++
 tests/generic/253.out       |  13 ++
 tests/generic/254           |  93 +++++++++
 tests/generic/254.out       |  13 ++
 tests/generic/259           |  93 +++++++++
 tests/generic/259.out       |  13 ++
 tests/generic/261           |  93 +++++++++
 tests/generic/261.out       |  13 ++
 tests/generic/262           |  96 +++++++++
 tests/generic/262.out       |  13 ++
 tests/generic/264           |  93 +++++++++
 tests/generic/264.out       |  13 ++
 tests/generic/265           | 102 +++++++++
 tests/generic/265.out       |  11 +
 tests/generic/266           | 103 ++++++++++
 tests/generic/266.out       |  12 ++
 tests/generic/267           | 103 ++++++++++
 tests/generic/267.out       |  10 +
 tests/generic/268           | 106 ++++++++++
 tests/generic/268.out       |  12 ++
 tests/generic/271           | 102 +++++++++
 tests/generic/271.out       |  11 +
 tests/generic/272           | 103 ++++++++++
 tests/generic/272.out       |  12 ++
 tests/generic/276           | 103 ++++++++++
 tests/generic/276.out       |  11 +
 tests/generic/278           | 106 ++++++++++
 tests/generic/278.out       |  12 ++
 tests/generic/279           | 103 ++++++++++
 tests/generic/279.out       |  11 +
 tests/generic/281           | 104 ++++++++++
 tests/generic/281.out       |  12 ++
 tests/generic/282           | 104 ++++++++++
 tests/generic/282.out       |  10 +
 tests/generic/283           | 107 ++++++++++
 tests/generic/283.out       |  12 ++
 tests/generic/284           |  95 +++++++++
 tests/generic/284.out       |  13 ++
 tests/generic/287           |  95 +++++++++
 tests/generic/287.out       |  13 ++
 tests/generic/289           | 102 +++++++++
 tests/generic/289.out       |  13 ++
 tests/generic/290           | 102 +++++++++
 tests/generic/290.out       |  13 ++
 tests/generic/291           | 102 +++++++++
 tests/generic/291.out       |  13 ++
 tests/generic/292           | 102 +++++++++
 tests/generic/292.out       |  13 ++
 tests/generic/293           | 107 ++++++++++
 tests/generic/293.out       |  13 ++
 tests/generic/295           | 107 ++++++++++
 tests/generic/295.out       |  13 ++
 tests/generic/296           |  96 +++++++++
 tests/generic/296.out       |  13 ++
 tests/generic/297           | 101 +++++++++
 tests/generic/297.out       |   6 +
 tests/generic/298           | 101 +++++++++
 tests/generic/298.out       |   6 +
 tests/generic/301           | 105 ++++++++++
 tests/generic/301.out       |  11 +
 tests/generic/302           | 105 ++++++++++
 tests/generic/302.out       |  11 +
 tests/generic/303           |  99 +++++++++
 tests/generic/303.out       |  21 ++
 tests/generic/304           | 100 +++++++++
 tests/generic/304.out       |  22 ++
 tests/generic/305           | 105 ++++++++++
 tests/generic/305.out       |  23 +++
 tests/generic/326           | 105 ++++++++++
 tests/generic/326.out       |  23 +++
 tests/generic/327           |  92 +++++++++
 tests/generic/327.out       |  13 ++
 tests/generic/328           | 109 ++++++++++
 tests/generic/328.out       |  26 +++
 tests/generic/329           | 105 ++++++++++
 tests/generic/329.out       |  12 ++
 tests/generic/330           |  96 +++++++++
 tests/generic/330.out       |  11 +
 tests/generic/331           | 107 ++++++++++
 tests/generic/331.out       |  12 ++
 tests/generic/332           |  97 +++++++++
 tests/generic/332.out       |  11 +
 tests/generic/333           | 104 ++++++++++
 tests/generic/333.out       |   6 +
 tests/generic/334           | 104 ++++++++++
 tests/generic/334.out       |   6 +
 tests/generic/group         |  49 ++++-
 tests/xfs/122               |   3 +
 tests/xfs/122.out           |   4 +
 tests/xfs/127               |   1 -
 tests/xfs/128               |   3 +-
 tests/xfs/128.out           |   8 +-
 tests/xfs/131               |   1 -
 tests/xfs/132               |  10 +-
 tests/xfs/132.out           |  40 ++--
 tests/xfs/139               |   1 -
 tests/xfs/140               |   1 -
 tests/xfs/169               |  90 ++++++++
 tests/xfs/169.out           |   8 +
 tests/xfs/179               | 119 +++++++++++
 tests/xfs/179.out           |  10 +
 tests/xfs/180               | 111 ++++++++++
 tests/xfs/180.out           |  12 ++
 tests/xfs/182               | 111 ++++++++++
 tests/xfs/182.out           |  13 ++
 tests/xfs/184               | 110 ++++++++++
 tests/xfs/184.out           |  11 +
 tests/xfs/192               | 110 ++++++++++
 tests/xfs/192.out           |  11 +
 tests/xfs/193               | 107 ++++++++++
 tests/xfs/193.out           |  11 +
 tests/xfs/198               | 107 ++++++++++
 tests/xfs/198.out           |  11 +
 tests/xfs/200               | 114 +++++++++++
 tests/xfs/200.out           |  11 +
 tests/xfs/204               | 114 +++++++++++
 tests/xfs/204.out           |  11 +
 tests/xfs/207               | 104 ++++++++++
 tests/xfs/207.out           |  10 +
 tests/xfs/208               | 154 ++++++++++++++
 tests/xfs/208.out           |  15 ++
 tests/xfs/209               |  88 ++++++++
 tests/xfs/209.out           |   6 +
 tests/xfs/210               | 125 +++++++++++
 tests/xfs/210.out           |  14 ++
 tests/xfs/211               | 111 ++++++++++
 tests/xfs/211.out           |  12 ++
 tests/xfs/212               | 106 ++++++++++
 tests/xfs/212.out           |  14 ++
 tests/xfs/213               | 110 ++++++++++
 tests/xfs/213.out           |  23 +++
 tests/xfs/214               | 109 ++++++++++
 tests/xfs/214.out           |  23 +++
 tests/xfs/215               | 108 ++++++++++
 tests/xfs/215.out           |  14 ++
 tests/xfs/218               | 108 ++++++++++
 tests/xfs/218.out           |  14 ++
 tests/xfs/219               | 108 ++++++++++
 tests/xfs/219.out           |  14 ++
 tests/xfs/221               | 108 ++++++++++
 tests/xfs/221.out           |  14 ++
 tests/xfs/223               | 113 ++++++++++
 tests/xfs/223.out           |  14 ++
 tests/xfs/224               | 113 ++++++++++
 tests/xfs/224.out           |  14 ++
 tests/xfs/225               | 108 ++++++++++
 tests/xfs/225.out           |  14 ++
 tests/xfs/226               | 108 ++++++++++
 tests/xfs/226.out           |  14 ++
 tests/xfs/228               | 137 +++++++++++++
 tests/xfs/228.out           |  14 ++
 tests/xfs/230               | 137 +++++++++++++
 tests/xfs/230.out           |  14 ++
 tests/xfs/231               | 135 ++++++++++++
 tests/xfs/231.out           |  17 ++
 tests/xfs/232               | 137 +++++++++++++
 tests/xfs/232.out           |  17 ++
 tests/xfs/233               |  78 +++++++
 tests/xfs/233.out           |   6 +
 tests/xfs/234               |  89 ++++++++
 tests/xfs/234.out           |   6 +
 tests/xfs/235               | 108 ++++++++++
 tests/xfs/235.out           |  14 ++
 tests/xfs/236               |  93 +++++++++
 tests/xfs/236.out           |   8 +
 tests/xfs/237               | 107 ++++++++++
 tests/xfs/237.out           |  12 ++
 tests/xfs/239               |  98 +++++++++
 tests/xfs/239.out           |  11 +
 tests/xfs/240               | 109 ++++++++++
 tests/xfs/240.out           |  12 ++
 tests/xfs/241               |  99 +++++++++
 tests/xfs/241.out           |  11 +
 tests/xfs/243               | 169 +++++++++++++++
 tests/xfs/243.out           |  27 +++
 tests/xfs/245               |  99 +++++++++
 tests/xfs/245.out           |  13 ++
 tests/xfs/group             |  44 +++-
 241 files changed, 11012 insertions(+), 177 deletions(-)
 create mode 100644 common/xfs
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
