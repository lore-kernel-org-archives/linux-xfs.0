Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:46408 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726529AbeJ3SaA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Oct 2018 14:30:00 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gHQSY-0005Vk-6B
        for linux-xfs@vger.kernel.org; Tue, 30 Oct 2018 20:37:14 +1100
Date: Tue, 30 Oct 2018 20:37:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: master and for-next branches updated
Message-ID: <20181030093711.GO6311@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="iFRdW5/EC4oqxDHL"
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


--iFRdW5/EC4oqxDHL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

I've just updated both the master and for-next branches of
the linux-xfs tree here:

git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

Th emaster branch has been updated to v4.19 so that I can base the
dedupe/clone rework off it without needing to care about conflicts
in 4.19-rc7/-rc8. The for-next branch contains the that rework, and
the details are below. I'm going to let this sit in linux-next for a
couple of days, then ask Linus to pull it if nothing goes awry with
it.

Cheers,

Dave.

The following changes since commit 84df9525b0c27f3ebc2ebb1864fa62a97fdedb7d:

  Linux 4.19 (2018-10-22 07:37:37 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux for-next

for you to fetch changes up to bf4a1fcf0bc18d52cf0fce6571d6f327ab5eaf22:

  xfs: remove [cm]time update from reflink calls (2018-10-30 10:47:48 +1100)

----------------------------------------------------------------
Darrick J. Wong (28):
      vfs: vfs_clone_file_prep_inodes should return EINVAL for a clone from=
 beyond EOF
      vfs: check file ranges before cloning files
      vfs: exit early from zero length remap operations
      vfs: strengthen checking of file range inputs to generic_remap_checks
      vfs: avoid problematic remapping requests into partial EOF block
      vfs: skip zero-length dedupe requests
      vfs: rename vfs_clone_file_prep to be more descriptive
      vfs: rename clone_verify_area to remap_verify_area
      vfs: combine the clone and dedupe into a single remap_file_range
      vfs: pass remap flags to generic_remap_file_range_prep
      vfs: pass remap flags to generic_remap_checks
      vfs: remap helper should update destination inode metadata
      vfs: make remap_file_range functions take and return bytes completed
      vfs: plumb remap flags through the vfs clone functions
      vfs: plumb remap flags through the vfs dedupe functions
      vfs: enable remap callers that can handle short operations
      vfs: hide file range comparison function
      vfs: clean up generic_remap_file_range_prep return value
      ocfs2: truncate page cache for clone destination file before remapping
      ocfs2: fix pagecache truncation prior to reflink
      ocfs2: support partial clone range and dedupe range
      ocfs2: remove ocfs2_reflink_remap_range
      xfs: fix pagecache truncation prior to reflink
      xfs: clean up xfs_reflink_remap_blocks call site
      xfs: support returning partial reflink results
      xfs: remove redundant remap partial EOF block checks
      xfs: remove xfs_reflink_remap_range
      xfs: remove [cm]time update from reflink calls

 Documentation/filesystems/porting |   5 +
 Documentation/filesystems/vfs.txt |  22 ++-
 fs/btrfs/ctree.h                  |   8 +-
 fs/btrfs/file.c                   |   3 +-
 fs/btrfs/ioctl.c                  |  50 ++---
 fs/cifs/cifsfs.c                  |  24 ++-
 fs/ioctl.c                        |  10 +-
 fs/nfs/nfs4file.c                 |  12 +-
 fs/nfsd/vfs.c                     |   8 +-
 fs/ocfs2/file.c                   |  93 +++++++--
 fs/ocfs2/refcounttree.c           | 148 ++++----------
 fs/ocfs2/refcounttree.h           |  24 ++-
 fs/overlayfs/copy_up.c            |   6 +-
 fs/overlayfs/file.c               |  43 ++--
 fs/read_write.c                   | 403 +++++++++++++++++++++-------------=
----
 fs/xfs/xfs_file.c                 |  82 +++++---
 fs/xfs/xfs_reflink.c              | 173 ++++------------
 fs/xfs/xfs_reflink.h              |  15 +-
 include/linux/fs.h                |  55 ++++--
 mm/filemap.c                      | 146 +++++++++++---
 20 files changed, 734 insertions(+), 596 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--iFRdW5/EC4oqxDHL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJb2CZGAAoJEK3oKUf0dfod6AUP/2+bUC73ivHERDJnWMR+3ZnC
CZhmlLkFqzIVu3sYzJifivBwqPpQWgvK9MgHGuAclID4HTHd4aeDn8HNARahz40H
wSQgCo4pzbgo1mNd5eDuHQZ+FJfBuAevDWdLLxo0CgktJQSbVrPJ5FTd8fNxZi9i
bE3RhQQ368/j5lpdaRi/32UvmJy+0ddTT4Xxn2YP6J7KrtglcIiyLQLdRbKoDmc6
begO4RmZ6Y9JzcLk/b24wpwjkYwvoXnJB4zgPKD4z7R0gYueRzTf+BbtYXRmfhgm
q17lhDX/AepzRv4rEyZFlJPKD7d+GwvHgLTBBKdaVudFji2utSYrAEbdQPcCQEQJ
catXdzMXG0OENU9858rFszcwB45LqkTyd5QvWJg3bFGGgP1Kg5clwBterZwPpO4m
8CkJuWYHi58LxX3s0nKbNok1DImLtQPg90AOsxrAPSnRXRx98+hFtxAr191ppI7h
La3rQ/Eib4/nQpuzGeZNzJw253GPQu+gE8B5FGRH3L3I8OP/nOFpBMRfMllFPb+n
dC7DGgatbeAMtYxRPEYaELoonO552PUa0/4rgusyVZKLwYA61sv2iKdVEQ541teU
+n4cwlNZbSo0nY7hj6AdYtqsrdrDawt/qzQNwM4QSgys1QzNLiQd6HhssEbJZdKH
I/gZQN5QpZGcwJYT6CRK
=nn/6
-----END PGP SIGNATURE-----

--iFRdW5/EC4oqxDHL--
