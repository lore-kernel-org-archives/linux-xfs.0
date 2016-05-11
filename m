Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E44167CA0
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 19:26:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4E103AC005
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 17:26:25 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	mqpQnM1GsoUhouRF for <xfs@oss.sgi.com>;
	Tue, 10 May 2016 17:26:20 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1b0HyZ-0000zt-6U
	for xfs@oss.sgi.com; Wed, 11 May 2016 10:26:07 +1000
Date: Wed, 11 May 2016 10:26:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to c5d584c
Message-ID: <20160511002607.GK26977@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1391150662673769633=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============1391150662673769633==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Folks,

The xfsprogs repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated. Note that this includes the change of mkfs
command line parsing, so you will see some additional xfstests
failures resulting from that. Those should be fixed soon as filters
and changes are made to xfstests to handle these differences.

-Dave.

The new head of the master branch is commit:

c5d584c xfs_db: fix unaligned accesses

New Commits:

Carlos Maiolino (1):
      [ef25c9e] xfs_io: implement 'inode' command

Christoph Hellwig (3):
      [410c3de] xfs: handle errors from ->free_blocks in xfs_btree_kill_iro=
ot
      [c261f8c] xfs: factor btree block freeing into a helper
      [08caf14] xfs: move buffer invalidation to xfs_btree_free_block

Darrick J. Wong (1):
      [71893d8] mkfs: fix crash when initializing rbmip

Dave Chinner (27):
      [f36349d] xfs: RT bitmap and summary buffers are not typed
      [a3d2294] xfs: RT bitmap and summary buffers need verifiers
      [138659f] xfs: introduce inode log format object
      [1bc6cbe] xfs: remove timestamps from incore inode
      [db17aeb] xfs: cull unnecessary icdinode fields
      [f089fc4] xfs: move v1 inode conversion to xfs_inode_from_disk
      [bcbe04c] xfs: use vfs inode nlink field everywhere
      [6652c25] xfs: move inode generation count to VFS inode
      [9abcc5c] xfs: move di_changecount to VFS inode
      [e37bf53] xfs: mode di_mode to vfs inode
      [294e9dd] Merge branch 'libxfs-4.6-sync' into for-master
      [09033e3] Merge branch 'progs-misc-fixes-for-4.6' into for-master
      [4a32b9e] xfsprogs: use common code for multi-disk detection
      [ff21c70] mkfs: sanitise ftype parameter values.
      [5f1a210] mkfs: Sanitise the superblock feature macros
      [a887c95] mkfs: validate all input values
      [c81c846] mkfs: factor boolean option parsing
      [147e0f3] mkfs: validate logarithmic parameters sanely
      [a9dad67] mkfs: structify input parameter passing
      [56e4d36] mkfs: getbool is redundant
      [1974d3f] mkfs: use getnum_checked for all ranged parameters
      [9090e18] mkfs: add respecification detection to generic parsing
      [627e74f] mkfs: table based parsing for converted parameters
      [6c85562] mkfs: merge getnum
      [3ec1956] mkfs: encode conflicts into parsing table
      [27ae3a5] mkfs: add string options to generic parsing
      [06ac92f] mkfs: don't treat files as though they are block devices

Eric Sandeen (6):
      [43633a3] xfs: wire up Q_XGETNEXTQUOTA / get_nextdqblk
      [499b47f] xfs: remove unused function definitions
      [ff0f39e] libxfs: fix up mismerge in libxfs_iflush_int
      [6aa32b4] xfs_repair: fix agf limit error messages
      [d7006be] metadump: limit permissible sector sizes
      [c5d584c] xfs_db: fix unaligned accesses

Jan Tulak (5):
      [1d43056] build: make librt optional for some platforms
      [ddc3b2d] mkfs: move spinodes crc check
      [6de2e6c] mkfs: unit conversions are case insensitive
      [aa3034d] mkfs: add optional 'reason' for illegal_option
      [2aca16d] mkfs: conflicting values with disabled crc should fail

Mike Frysinger (2):
      [3e50ece] po: respect LINGUAS build setting
      [54e8f4a] configure: add mailing list contact

Zorro Lang (5):
      [6f224a2] xfs_io: modify argument errors of mremap command
      [e0a8808] xfs_io: allow mmap command to reserve some free space
      [2354bb6] xfs_quota: add missed options -D and -P into man page
      [cef37d5] xfs_quota: fully support users and groups beginning with di=
gits
      [3d607a1] xfs_quota: print quota id number if the name can't be found


Code Diffstat:

 configure.ac                               |    9 +-
 db/check.c                                 |  116 +-
 db/frag.c                                  |    4 +-
 db/metadump.c                              |   23 +-
 doc/INSTALL                                |    6 +-
 include/Makefile                           |    5 +-
 include/xfs_inode.h                        |   45 +-
 mkfs/xfs_mkfs.h =3D> include/xfs_multidisk.h |   50 +-
 io/mmap.c                                  |   54 +-
 io/open.c                                  |  150 +++
 libxcmd/input.c                            |    4 +-
 libxfs/init.c                              |   16 +-
 libxfs/libxfs_api_defs.h                   |    4 +-
 libxfs/linux.c                             |   11 +-
 libxfs/rdwr.c                              |    4 +-
 libxfs/util.c                              |   60 +-
 libxfs/xfs_alloc_btree.c                   |    2 -
 libxfs/xfs_bmap.c                          |    6 +-
 libxfs/xfs_bmap_btree.c                    |    1 -
 libxfs/xfs_btree.c                         |   32 +-
 libxfs/xfs_dir2.c                          |   12 +-
 libxfs/xfs_ialloc_btree.c                  |   12 +-
 libxfs/xfs_inode_buf.c                     |  169 ++-
 libxfs/xfs_inode_buf.h                     |   38 +-
 libxfs/xfs_inode_fork.c                    |    2 +-
 libxfs/xfs_log_format.h                    |   19 +-
 libxfs/xfs_quota_defs.h                    |    3 +-
 libxfs/xfs_rtbitmap.c                      |   32 +-
 libxfs/xfs_sb.h                            |    1 -
 libxfs/xfs_shared.h                        |    1 +
 logprint/log_misc.c                        |    7 +-
 logprint/log_print_all.c                   |   18 +-
 m4/package_rt.m4                           |   12 +
 man/man8/mkfs.xfs.8                        |   29 +-
 man/man8/xfs_io.8                          |   22 +-
 man/man8/xfs_quota.8                       |   22 +-
 mdrestore/xfs_mdrestore.c                  |   22 +-
 mkfs/Makefile                              |    2 +-
 mkfs/maxtrres.c                            |    2 +-
 mkfs/proto.c                               |   70 +-
 mkfs/xfs_mkfs.c                            | 2011 +++++++++++++++++++-----=
-------
 po/Makefile                                |    5 +-
 quota/report.c                             |   16 +-
 repair/agheader.c                          |    4 +-
 repair/phase6.c                            |   58 +-
 repair/phase7.c                            |   43 +-
 repair/xfs_repair.c                        |   44 +-
 47 files changed, 2087 insertions(+), 1191 deletions(-)
 rename mkfs/xfs_mkfs.h =3D> include/xfs_multidisk.h (61%)
 create mode 100644 m4/package_rt.m4
--=20
Dave Chinner
david@fromorbit.com

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXMnweAAoJEK3oKUf0dfodRu0P/1KF7i05etM5DAKJ+idz+95i
pKrld+S43uxo1Bu7tjEamQ7ei9Yhx0RFLCcH8BAVYd/GbrMhX3eDlZLnzr8dgIFy
D9AZA/FX1UNHaA3+PfcbppQiNFkFmSW9fp+GUhBfIcuNra2ymg4fkEr8fiKZ36m5
o3lzUkz62EWR6qnevckYyAzC8SxiQhnBfcN6NoR1ILlTZGItKjDBuBw1QxNPPhzz
trdCoOKd/Ibe8ow51EidCtUcSgzsi270TItISm0gNCIHa/WyTJLHgaP0vEBegZzB
TQMpj/hqsw23KhieoEQtcUI8rHxGXA9hZnwxJhqgv3u4xiHbqs97JhOK+8PQRrq8
IPPeZrEKz9gUDE9fVbjcLAu7FDw9LijENJFbkVqw7Zmat49o7tu6ymCSte38coB2
HgmhLb4/vta0GAFHsQGg4ECwfS6dIsE20GqX71CQw44rqcN8Fx/z3C7TifoSugks
yPD1cgpxneiOPVm1KgmA/uBvE05j6erzsgRnnucPCeiSdp9IYpwXSs72VVMIwGmY
j3YDLStySS4c09K7xGwPx3euH3iuGbQX//RdCOg1hsqkMB1zcPA1DJb0LQ656U1l
gLz3H7+kgRoS7U8kxlQM/cUPawSdXO0IiJRxPnkszo9MzjhAqnvzggL8Q1uiPsys
SySo9BQbKN1EpWk3BORE
=PGv6
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--


--===============1391150662673769633==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1391150662673769633==--
