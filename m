Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4B4027F37
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 19:40:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1E1888F804B
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 17:40:33 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	N7m4K1b7ulneN1SM for <xfs@oss.sgi.com>;
	Tue, 13 Oct 2015 17:40:26 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1ZmA6l-0003Yo-6D
	for xfs@oss.sgi.com; Wed, 14 Oct 2015 11:39:55 +1100
Date: Wed, 14 Oct 2015 11:39:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: v4.3.0-rc1 released
Message-ID: <20151014003955.GK31326@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0288040013240928911=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============0288040013240928911==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y7xTucakfITjPcLV"
Content-Disposition: inline


--Y7xTucakfITjPcLV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated. This update is tagged as the first release
candidate for v4.3.0 as it contains all the bg fixes and
enhancements that will be in the release. There is still some
libxfs user/kernel sync work that needs to be done - I plan to have
that done for an -rc2 release within a week, along with whatever
problems people hit in testing this rc release....

-Dave.

The new head of the master branch is commit:

f7efc5e xfsprogs: Release v4.3.0-rc1

New Commits:

Brian Foster (18):
      [a65d8d2] libxfs: validate metadata LSNs against log on v5 superblocks
      [7d77349] libxfs: track largest metadata LSN in use via verifiers
      [ad9b88e] libxfs: don't hardcode cycle 1 into unmount op header
      [0c12ba5] libxfs: pass lsn param to log clear and record header loggi=
ng helpers
      [0337f27] libxfs: add ability to clear log to arbitrary log cycle
      [0ab627d] libxlog: pull struct xlog out of xlog_is_dirty()
      [1d6cb11] xfs_repair: track log state throughout all recovery phases
      [1ef257c] xfs_repair: process the log in no_modify mode
      [1926558] xfs_repair: format the log with forward cycle number on v5 =
supers
      [f2053bc] xfs_repair: don't clear the log by default
      [9d2d8bd] xfs_repair: seed the max lsn from log state in phase 2
      [7f72564] xfs_db: do not reset current lsn from uuid command on v5 su=
pers
      [1c12a81] db/metadump: bump lsn when log is cleared on v5 supers
      [3616eb8] xfs_copy: check for dirty log on non-duplicate copies
      [96866b0] xfs_copy: genericize write helper to facilitate separate lo=
g buf
      [08f2b83] xfs_copy: store data buf alignment in buf data structure
      [54b0c4d] xfs_copy: refactor log format code into new helper
      [b4d947d] xfs_copy: format v5 sb logs correctly

Darrick J. Wong (4):
      [bb8aab6] xfs_io: support reflinking and deduping file ranges
      [bdc2a20] xfs_db: enable blocktrash for checksummed filesystems
      [37faa0d] xfs_db: trash the block at the top of the cursor stack
      [e96864f] xfs_db: enable blockget for v5 filesystems

Dave Chinner (2):
      [293e343] db: fix AGI ops definition in CRC type table
      [f7efc5e] xfsprogs: Release v4.3.0-rc1

Eric Sandeen (18):
      [2f644bc] xfs_repair: remove trace-only 'n' member from da_level_state
      [54aeafa] xfs_repair: remove type from da & dir2 cursors
      [e41dd63] xfs_repair: make CRC checking consistent in path verificati=
on
      [b63f5df] xfs_repair: use multibuffer read routines in attr_repair.c
      [82137e5] xfs_repair: fix use-after-free in verify_final_dir2_path
      [2b8a278] xfs_repair: add XR_DIR_TRACE to dir2.c
      [259d52f] xfs_repair: Remove BUF_PTR from attr_repair.c
      [02f1c21] xfs_repair: catch bad level/depth in da node
      [08724aa] xfs_repair: better checking of v5 attributes
      [d8c7dd7] xfs_repair: Remove more differences between attr & dir2
      [e315cdf] xfs_repair: whitespace & comments
      [360f4a2] xfs_repair: move common dir2 and attr_repair code to da_uti=
l.c
      [5cd3b07] xfs_repair: Fix up warning strings in da_util.c
      [d781a1b] libxfs: avoid negative (and full-width) shifts in radix-tre=
e.c
      [fb36a55] xfs_repair: fix unaligned accesses
      [6f947c9] xfs_logprint: fix some unaligned accesses
      [1bec3a6] xfs_metadump: Fix unaligned accesses
      [c782bf0] xfs_repair: fix left-shift overflows

Jan Tulak (13):
      [6635d6a] build: make libblkid usage optional
      [c6e8a13] platform: Add XATTR_LIST_MAX to OS X headers
      [ec9d24e] libxfs: avoid dependency on Linux XATTR_SIZE_MAX
      [54e724c] libxfs: prefix XATTR_LIST_MAX with XFS_
      [7f7fd8a] build: Add includes required for OS X
      [c14c7b7] build: Add autoconf check for fsetxattr call
      [dccb965] platform: uuid changes for OS X
      [ad8371f] platform: Remove conflicting define for OS X
      [137200b] xfs_estimate: change nftw64 to nftw
      [07b010a] platform: Add a timer implementation for OS X
      [b35b4eb] platform: Add statvfs64 for OS X
      [a49984b] io: Make mremap conditional
      [9776e84] platform: rename lstat64 to lstat for OS X

Mika Eloranta (1):
      [6af48b9] mkfs.xfs: option for using a pre-defined filesystem UUID


Code Diffstat:

 Makefile                    |   2 +-
 VERSION                     |   4 +-
 configure.ac                |  14 +-
 copy/Makefile               |   4 +-
 copy/xfs_copy.c             | 196 +++++++++---
 copy/xfs_copy.h             |   1 +
 db/check.c                  | 331 ++++++++++++++++++---
 db/init.c                   |  25 +-
 db/metadump.c               |  29 +-
 db/sb.c                     |  18 +-
 db/type.c                   |   6 +-
 doc/CHANGES                 |   9 +
 estimate/xfs_estimate.c     |   6 +-
 fsr/xfs_fsr.c               |  10 +
 include/builddefs.in        |  12 +-
 include/darwin.h            |  86 +++++-
 include/libxfs.h            |  17 +-
 include/libxlog.h           |   3 +-
 include/xfs_mount.h         |   6 +
 io/Makefile                 |   6 +-
 io/dedupe.c                 | 190 ++++++++++++
 io/init.c                   |   2 +
 io/io.h                     |   3 +
 io/mmap.c                   |   8 +
 io/reflink.c                | 180 +++++++++++
 libhandle/handle.c          |   4 +-
 libhandle/jdm.c             |   4 +-
 libxfs/libxfs_priv.h        |   2 +
 libxfs/radix-tree.c         |  14 +-
 libxfs/rdwr.c               | 160 ++++++++--
 libxfs/util.c               |  41 +++
 libxfs/xfs_alloc.c          |  12 +-
 libxfs/xfs_attr_leaf.c      |   2 +
 libxfs/xfs_attr_remote.c    |   2 +-
 libxfs/xfs_btree.c          |  16 +-
 libxfs/xfs_da_btree.c       |   3 +
 libxfs/xfs_dir2_block.c     |   2 +
 libxfs/xfs_dir2_data.c      |   2 +
 libxfs/xfs_dir2_leaf.c      |   2 +
 libxfs/xfs_dir2_node.c      |   2 +
 libxfs/xfs_format.h         |  10 +-
 libxfs/xfs_fs.h             |  45 +++
 libxfs/xfs_ialloc.c         |   9 +-
 libxfs/xfs_sb.c             |   9 +
 libxfs/xfs_symlink_remote.c |   3 +
 libxlog/util.c              |  37 +--
 logprint/log_misc.c         |  21 +-
 m4/package_libcdev.m4       |  26 ++
 man/man8/mkfs.xfs.8         |   4 +
 man/man8/xfs_db.8           |  15 +-
 man/man8/xfs_io.8           |  67 +++++
 mkfs/xfs_mkfs.c             |  53 +++-
 release.sh                  |   6 +
 repair/Makefile             |   6 +-
 repair/attr_repair.c        | 618 +-------------------------------------
 repair/da_util.c            | 708 ++++++++++++++++++++++++++++++++++++++++=
++++
 repair/da_util.h            |  83 ++++++
 repair/dinode.c             |  47 +--
 repair/dir2.c               | 601 +------------------------------------
 repair/dir2.h               |  42 ---
 repair/incore_ino.c         |  14 +-
 repair/phase2.c             |  90 ++++--
 repair/prefetch.c           |   6 +-
 repair/progress.c           |   3 +-
 repair/xfs_repair.c         |  79 ++++-
 65 files changed, 2511 insertions(+), 1527 deletions(-)
 create mode 100644 io/dedupe.c
 create mode 100644 io/reflink.c
 create mode 100644 repair/da_util.c
 create mode 100644 repair/da_util.h
--=20
Dave Chinner
david@fromorbit.com

--Y7xTucakfITjPcLV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWHaRaAAoJEK3oKUf0dfodWtgQAKiFO2xYREsDa+Kqg901U4yk
zzyW0j5YgOvxjORJ1sikbZHxD03IvgDd5qYqQJRIfBYDTYDpqhDzxIMhFREMPHev
vV0Qz7nrUBfGkvPgSrV1jRpvuZC9wN/uCH7CkyOsK1xEd6Gxv9s4h5LbnbN9PRVP
nkHpxAbbKNlpFep/y1Gb8msgtjHM7KdJKRk7EUDrFYW3aMr2uQhjVzBsWViGENT/
nh/GuAzEny1QExWB4EPrlkvMCT++yz4P6q5ofeBmBN1KSqN7+SRhR5JWahc2Pgbc
zcEoZadN9xwtOStddnlbUc/GYYFcrGPivtz1cdTOxa1vDLgaS03oB5RLfbZx1nSk
3uafjf1+MjPuzAmPZQFmBViMzogCQ3XVAA5L3U6UE4XRuJfpUQNasWy8sY7m9nUe
5ZdvIBYcwnHZCSXVU+Tx1+QPS0PYUD+wonl6gU5S5PNeVpPh0yxE72yv+nsH1I+A
qRqrx8uCoPRBlrPf/kJUrs1YuwLvjz7jAfV7lLVv+aeAaheG8jRd8VOZzDo04Osh
X6+qBkYXfRCg0cqzZ5mvAeRNlv4wM2iiuUpOb0FzT7mGwFE6vv4adisKgCuXuTgs
pSJ9TvLcHX+BO+v/kJOk6FIfF7UWEHqhHSKr+KS1S01QXf9azhh0MO+GmZnyCRri
nG/CXbiAlmpYAfDLB4iR
=3I7u
-----END PGP SIGNATURE-----

--Y7xTucakfITjPcLV--


--===============0288040013240928911==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0288040013240928911==--
