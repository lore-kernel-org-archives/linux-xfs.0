Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41056 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbfBVSdl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Feb 2019 13:33:41 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 03CBD2A9C
        for <linux-xfs@vger.kernel.org>; Fri, 22 Feb 2019 12:33:21 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v4.20.0 released
Message-ID: <59a16d27-0370-12c3-4590-071f88a9d3fb@sandeen.net>
Date: Fri, 22 Feb 2019 12:33:37 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VkFJdGTqQaNwwWBj2nqR3nEQ4Jnh4W1r5"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VkFJdGTqQaNwwWBj2nqR3nEQ4Jnh4W1r5
Content-Type: multipart/mixed; boundary="dOMAW0ak0EYO040XPpga5WXALx9RF5OqS";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <59a16d27-0370-12c3-4590-071f88a9d3fb@sandeen.net>
Subject: [ANNOUNCE] xfsprogs v4.20.0 released

--dOMAW0ak0EYO040XPpga5WXALx9RF5OqS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

=46rom the better-late-than-never dept...

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v4.20.0, with tarballs
available at:

https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-4.20.0.ta=
r.gz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-4.20.0.ta=
r.xz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-4.20.0.ta=
r.sign

This is unchanged from the -rc1 version.  Short changelog follows, with t=
he
full list of changes since v4.19.0 after that.

The new head of the master branch is commit:

413a0f0 xfsprogs: Release v4.20.0

xfsprogs-4.20.0 (22 Feb 2018)
        - No further changes

xfsprogs-4.20.0-rc1 (08 Feb 2018)
        - mkfs.xfs: null-terminate symlinks created via protofile (Eric S=
andeen)
        - xfs_repair: allow '/' in attribute names (Eric Sandeen)
        - xfs_repair: skip block reservation when fixing freelist (Darric=
k Wong)
        - xfs_repair: rebuild dir when nonroot blocks corrupt (Darrick Wo=
ng)
        - xfs_repair: int nonleaf finobt blocks with proper magic (Brian =
Foster)
        - xfs_repair: fix off by one error rebuilding high keys (Darrick =
Wong)
        - xfs_io: allow open file permissions to be changed (Dave Chinner=
)
        - xfs_io: open pipes in non-blocking mode (Dave Chinner)
        - xfs_metadump: multiple stale data zeroing fixes (Stefan Ring)
        - xfs_quota: allow reg files w/o prjinherit flag (Achilles Gaikwa=
d)
        - xfs_db: properly decode finobt record w/ sparse inodes (Darrick=
 Wong)
        - xfs_db: fix frag command to work w/ sparse inodes (Eric Sandeen=
)
        - xfs_scrub: move all executables to /usr/sbin (Darrick Wong)
        - xfs_scrub: handle totally empty inode chunks (Darrick Wong)
        - xfs.5 manpage: Remove barrier related options (Eric Sandeen)
        - xfs_io.8 manpage: rearrange command listings by section (Darric=
k Wong)
        - Remove generated scrub files under make clean (Eric Sandeen)
        - Skip scrub manpage install if not configured (Eric Sandeen)
        - Merge libxfs from kernel 4.20

New Commits:

Achilles Gaikwad (1):
      [b136f48] xfs_quota: fix false error reporting of project inheritan=
ce flag is not set

Allison Henderson (4):
      [2860efe] xfs: Move fs/xfs/xfs_attr.h to fs/xfs/libxfs/xfs_attr.h
      [6db48a6] xfs: Add helper function xfs_attr_try_sf_addname
      [932b563] xfs: Add attibute set and helper functions
      [05b0a4a] xfs: Add attibute remove and helper functions

Brian Foster (1):
      [051dae5] xfs_repair: initialize non-leaf finobt blocks with correc=
t magic

Christoph Hellwig (1):
      [b7fdeb4] xfs: remove suport for filesystems without unwritten exte=
nt flag

Darrick J. Wong (9):
      [782a18d] xfs_io.8: rearrange command listings by section
      [3d2195e] xfs_repair: rebuild directory when non-root leafn blocks =
claim block 0
      [f9c9fd9] xfs_repair: skip block reservation when fixing freelist
      [300661d] xfs_scrub: handle totally empty inode chunks
      [058f45d] xfs_scrub: fix fractional reporting of single inodes
      [f26db47] xfs_scrub: move everything to /usr/sbin
      [9b92d4b] xfs_db: add missing string name for DBM_COWDATA
      [0ba6dae] xfs_repair: fix off by one error when rebuilding high key=
s
      [38c599e] xfs_db: fix finobt record decoding when sparse inodes ena=
bled

Dave Chinner (6):
      [f26e485] xfs: fix overflow in xfs_attr3_leaf_verify
      [eda2a7e] xfs: finobt AG reserves don't consider last AG can be a r=
unt
      [3833299] xfs: delalloc -> unwritten COW fork allocation can go wro=
ng
      [1a05efb] io: open pipes in non-blocking mode
      [2c8482a] xfs_io: allow open file permissions to be changed
      [2a42470] xfs_io: copy_file_range length is a size_t

Eric Sandeen (11):
      [dbd3d46] xfs: fix inverted return from xfs_btree_sblock_verify_crc=

      [80afe23] xfsprogs: don't install xfs_scrub man pages if config'd o=
ff
      [153d2ff] mkfs.xfs: null-terminate symlinks created via protofile
      [2a5eb70] xfs_db: teach the frag command about sparse inode chunks
      [45571fd] xfs_repair: allow '/' in attribute names
      [17728a4] xfsprogs: remove generated scrub files under clean target=

      [e3f66d1] xfs_db: add -d to short help for write command
      [193bc42] xfsprogs: Remove barrier/nobarrier mount options from xfs=
=2E5
      [2cd8d66] xfs_repair: fix incorrect return value in namecheck()
      [d586cf7] xfsprogs: Release v4.20.0-rc1
      [413a0f0] xfsprogs: Release v4.20.0

Stefan Ring (5):
      [11f3d9f] xfs_metadump: Extend data zapping to XFS_DIR{2,3}_LEAFN_M=
AGIC blocks
      [b04e7e9] xfs_metadump: Zap multi fsb blocks
      [c3387ef] xfs_metadump: Zap freeindex blocks in directory inodes
      [07b75e3] xfs_metadump: Zap unused space in inode btrees
      [b32d0eb] xfs_metadump: Zap dev inodes


Code Diffstat:

 VERSION                   |   2 +-
 configure.ac              |   2 +-
 db/check.c                |  11 +
 db/frag.c                 |  61 +++--
 db/metadump.c             | 132 +++++++++--
 db/sb.c                   |   6 +-
 db/type.c                 |   2 +-
 db/write.c                |   2 +-
 debian/changelog          |  12 +
 doc/CHANGES               |  25 +-
 io/copy_file_range.c      |   6 +-
 io/open.c                 |  67 ++++++
 libxfs/libxfs_api_defs.h  |   1 +
 libxfs/xfs_attr.c         | 236 +++++++++++--------
 libxfs/xfs_attr.h         | 150 ++++++++++++
 libxfs/xfs_attr_leaf.c    |  11 +-
 libxfs/xfs_bmap.c         |  75 +++---
 libxfs/xfs_bmap.h         |   1 +
 libxfs/xfs_btree.c        |   2 +-
 libxfs/xfs_format.h       |   8 +-
 libxfs/xfs_ialloc_btree.c |  11 +-
 libxfs/xfs_sb.c           |   5 +-
 man/man5/xfs.5            |  30 +--
 man/man8/Makefile         |   6 +-
 man/man8/xfs_db.8         |   2 +-
 man/man8/xfs_io.8         | 570 ++++++++++++++++++++++++----------------=
------
 mkfs/proto.c              |  13 +-
 quota/project.c           |   2 +-
 repair/attr_repair.c      |  20 +-
 repair/da_util.c          |  20 +-
 repair/da_util.h          |   3 +-
 repair/dinode.c           |  18 +-
 repair/dir2.c             |  27 ++-
 repair/phase5.c           |  12 +-
 repair/rmap.c             |   3 +-
 repair/sb.c               |   7 +-
 repair/versions.c         |   5 +-
 scrub/Makefile            |  14 +-
 scrub/common.c            |   5 +-
 scrub/common.h            |   2 +-
 scrub/inodes.c            |   6 +
 scrub/phase7.c            |  34 +--
 42 files changed, 1054 insertions(+), 573 deletions(-)
 create mode 100644 libxfs/xfs_attr.h


--dOMAW0ak0EYO040XPpga5WXALx9RF5OqS--

--VkFJdGTqQaNwwWBj2nqR3nEQ4Jnh4W1r5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlxwQIIACgkQIK4WkuE9
3uBQVg//fV529J5Z5wyp9OM/UaCEvnlfv5Y1eHuP3KAnjju44IyDv3iK5qvbTFd9
WfVSIOfLEO66jm6rtV+f3YKY7AvAFhbmJK1hJ7tZlPYCUts75fgU3MhQtZvTXhvx
W4kAOWCLxHMCRDiI8n33E6iiUAo3OvtHf8okRoebflEqGsOJjF7ErsxhwVu+BawF
iF+DGtSVZEBhSurplLMxMuJxceSdBn72hTKO1UuQSmNaz/pHMrlRxtGdjbN6JVNy
L+Zh3Tj5qtKkNp9d0+UnkfrzKUvrJNQ91VqQDT+6b53Xc7A1Fy6P3FhBaWUWvMga
o0wkf+hoCTWlYi4BoiS/iiDpf9m1tVI+L4oHi8UGX6vsqcH4MsJgvt95lTm/Z6hS
aUS7Y+NHBkejiZBdJMpA9IsK3RpWQu4mrGbNbCyZ1jLeugrnMBwgr/r8cHCWuIsd
btUyXj6PBb/AJ2TpSQhh4n5+tMqdVc/zW/Drgj87sFlsC99MtvUWVddQHFykLitR
4tvMV3RG7ra2vVVFc4OJBq677yNU3T5OfGGyzRFfKQcCbhh8Uu2DxJjAeoRfVrU4
MIfn1fIfhoNcFdbdEJNMwhkH3apzOpDzrULURTQbBfcu98+fAORT8PGJP42NmEkA
dThlvsvPKW7taq7ZE4kAg4BDTHXjV0oHiY19Gxd28owPOOVHopo=
=GP9Y
-----END PGP SIGNATURE-----

--VkFJdGTqQaNwwWBj2nqR3nEQ4Jnh4W1r5--
