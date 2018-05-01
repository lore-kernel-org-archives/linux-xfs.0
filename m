Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49170 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751429AbeEACSg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Apr 2018 22:18:36 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 358AF479AE3
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 21:17:23 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 43d5ec8
Message-ID: <b8905265-4c18-d927-9a92-9cfededb8ae0@sandeen.net>
Date: Mon, 30 Apr 2018 21:18:34 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="va0HUKGlhRllUWVrrtoBdus0ObCXszXyW"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--va0HUKGlhRllUWVrrtoBdus0ObCXszXyW
Content-Type: multipart/mixed; boundary="DaK1S7hQ3jt5iPEI4SpQuzB9nZonE81sC";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <b8905265-4c18-d927-9a92-9cfededb8ae0@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 43d5ec8

--DaK1S7hQ3jt5iPEI4SpQuzB9nZonE81sC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.  I've merged the 4.17 libxfs changes from the
libxfs-4.17-sync branch into for-next.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

43d5ec8 Merge branch 'libxfs-4.17-sync' into for-next

New Commits:

Brian Foster (4):
      [65a15e0] xfs: rename agfl perag res type to rmapbt
      [9760cac] xfs: account only rmapbt-used blocks against rmapbt perag=
 res
      [8dbee8f] xfs: detect agfl count corruption and reset agfl
      [19fbb9d] xfs: clean up xfs_mount allocation and dynamic initialize=
rs

Carlos Maiolino (1):
      [97b3ffd] Cleanup old XFS_BTREE_* traces

Darrick J. Wong (7):
      [6da71a8] xfs: convert a few more directory asserts to corruption
      [15348e0] xfs: sanity-check the unused space before trying to use i=
t
      [0cf6a3a] xfs: refactor bmap record validation
      [b02a2c9] xfs: refactor inode verifier error logging
      [43f7ceb] xfs: refactor inode buffer verifier error logging
      [fd0c360] xfs: move inode extent size hint validation to libxfs
      [2949b46] xfs: don't accept inode buffers with suspicious unlinked =
chains

Dave Chinner (2):
      [b816550] xfs: convert XFS_AGFL_SIZE to a helper function
      [d206fcb] xfs: remove dead inode version setting code

Eric Sandeen (2):
      [1421de3] xfs: non-scrub - remove unused function parameters
      [43d5ec8] Merge branch 'libxfs-4.17-sync' into for-next


Code Diffstat:

 db/agfl.c                   |   2 +-
 db/check.c                  |   6 +--
 db/freesp.c                 |   6 +--
 db/metadump.c               |   2 +-
 include/libxfs.h            |   1 +
 include/xfs_mount.h         |  10 +++--
 include/xfs_trace.h         |   2 +
 libxfs/libxfs_api_defs.h    |   2 +
 libxfs/libxfs_priv.h        |  11 ++++++
 libxfs/xfs_ag_resv.c        |  39 ++++++++++---------
 libxfs/xfs_ag_resv.h        |  31 +++++++++++++++
 libxfs/xfs_alloc.c          | 145 ++++++++++++++++++++++++++++++++++++++=
++++++++++++++++++++++-----------
 libxfs/xfs_alloc.h          |   7 ++--
 libxfs/xfs_alloc_btree.c    |   8 +---
 libxfs/xfs_bmap.c           |  54 +++++++++++++++++++++++----
 libxfs/xfs_bmap.h           |   5 ++-
 libxfs/xfs_bmap_btree.c     |   4 +-
 libxfs/xfs_bmap_btree.h     |  14 -------
 libxfs/xfs_btree.c          | 127 +++++---------------------------------=
------------------------
 libxfs/xfs_btree.h          |  25 +------------
 libxfs/xfs_dir2.h           |   2 +-
 libxfs/xfs_dir2_block.c     |  59 +++++++++++++++++------------
 libxfs/xfs_dir2_data.c      |  78 +++++++++++++++++++++++++++++---------=

 libxfs/xfs_dir2_leaf.c      |  13 +++++--
 libxfs/xfs_dir2_node.c      |  16 +++++---
 libxfs/xfs_format.h         |  13 +------
 libxfs/xfs_ialloc.c         |   2 +-
 libxfs/xfs_ialloc_btree.c   |  11 ++----
 libxfs/xfs_inode_buf.c      | 124 ++++++++++++++++++++++++++++++++++++++=
++++++++++++++++++----
 libxfs/xfs_inode_buf.h      |   5 +++
 libxfs/xfs_inode_fork.c     |  27 +++++++++-----
 libxfs/xfs_refcount.c       |  22 ++++-------
 libxfs/xfs_refcount_btree.c |  10 +----
 libxfs/xfs_refcount_btree.h |   3 +-
 libxfs/xfs_rmap.c           |   3 +-
 libxfs/xfs_rmap_btree.c     |  17 ++++-----
 libxfs/xfs_rmap_btree.h     |   2 +-
 libxfs/xfs_sb.c             |  11 ++----
 libxfs/xfs_trans_resv.c     |  10 ++---
 mkfs/xfs_mkfs.c             |   4 +-
 repair/agheader.c           |  12 +++---
 repair/phase5.c             |  20 +++++-----
 repair/rmap.c               |   2 +-
 repair/scan.c               |   6 +--
 44 files changed, 585 insertions(+), 388 deletions(-)


--DaK1S7hQ3jt5iPEI4SpQuzB9nZonE81sC--

--va0HUKGlhRllUWVrrtoBdus0ObCXszXyW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlrnznoACgkQIK4WkuE9
3uCgJhAAoX9cmoFFQfltdmyFFoHparNz0sUjX+ssrzj6QUj/I/Xu7U6NzazWcIGC
35Zc71ZuDCxcfgie63JDORjkKWfp87nah2nD5fjdNssCRMSy2krJXe5VfktpbkMZ
/0t2VQTKz5zFRNtlHg/9kk6XVnykqbzkT3k51rHqBqqqdQ/QEIX3QtsWeoqP569m
G8IevZh//mDEkeEH5IiN/FwV67TBhGtHCIHEcflcJlDV4VrpqzfylVN3NpDZb5yV
IJQ5BKEqGG4unlL1asbowjVRgdx14oknryYmfKodbvlBjuyd74lPW/Vy116r/PHe
VoQjOBT+DoTDmRar0YRE5I9En7rZeKDjG6VDFKqGBqWYtQ0QpkIhLnesTgcX98nO
k5oB2wz+tuE1AdlmighEsoR0VuHRMCXCOzOhmtoXkS8a9MEk9Vyhlr+KGTpWw9jk
iVTAnKnJFp0+g1vNsVAfg7XyWme7qKm5LmRZaNWp18CMAmRy53p1UpNkgCFGcQMq
3GunxZ+MxOEtvwVSEl9AuViKh0e12t8C4SSC/JfcBUlzm/cgFX84pod01VD4bKsv
j8pk96i5dyBRauql0Y5Q1FnqTeRH9fjHKLSRQNvlP5Xxxh9sS1uHVHycXAzJk0qg
41fjea+T05YMzRNgzTvRYgVRSKDBcf56vUFQG7l0W+HXCchQul8=
=cFYh
-----END PGP SIGNATURE-----

--va0HUKGlhRllUWVrrtoBdus0ObCXszXyW--
