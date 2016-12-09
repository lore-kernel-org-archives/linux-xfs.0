Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:16135 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751983AbcLIGcN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Dec 2016 01:32:13 -0500
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1cFEij-0003Dw-Ee
        for linux-xfs@vger.kernel.org; Fri, 09 Dec 2016 17:31:49 +1100
Date: Fri, 9 Dec 2016 17:31:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next updated to 9807b773dad4
Message-ID: <20161209063149.GP4219@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks.

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

Ok, I was wrong, there were sufficient outstanding patches that I'd
missed to do another update before the 4.10 cycle. This should be
the last update now, honest! (Especially as the 4.10 merge window
will be abbreviated by Linus' xmas holiday schedule.)

-Dave.

The new head of the for-next branch is commit:

9807b773dad4 Merge branch 'xfs-4.10-misc-fixes-4' into for-next

New Commits:

Darrick J. Wong (1):
      [b24a978c377b] xfs: use GPF_NOFS when allocating btree cursors

Dave Chinner (3):
      [2291dab2c9d1] xfs: Always flush caches when integrity is required
      [4cf4573d899c] xfs: deprecate barrier/nobarrier mount option
      [9807b773dad4] Merge branch 'xfs-4.10-misc-fixes-4' into for-next

Eric Sandeen (2):
      [2e1d23370e75] xfs: ignore leaf attr ichdr.count in verifier during l=
og replay
      [9875258ca7ab] xfs: nuke unused tracepoint definitions

Eryu Guan (1):
      [0c187dc508d7] xfs: use xfs_vn_setattr_size to check on new size


Code Diffstat:

 Documentation/filesystems/xfs.txt |  12 ++---
 fs/xfs/libxfs/xfs_alloc_btree.c   |   2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c     |   8 ++-
 fs/xfs/libxfs/xfs_bmap_btree.c    |   2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c  |   2 +-
 fs/xfs/xfs_buf.c                  |   3 +-
 fs/xfs/xfs_file.c                 |  29 +++++-----
 fs/xfs/xfs_iops.c                 |   2 +-
 fs/xfs/xfs_log.c                  |  39 ++++++--------
 fs/xfs/xfs_super.c                |  25 +++++----
 fs/xfs/xfs_trace.h                | 109 ----------------------------------=
----
 11 files changed, 60 insertions(+), 173 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYSk/UAAoJEK3oKUf0dfodMZwQAJlNeBhPUnWDo8mD+xaRcvBh
NC2aYiHhy1D+HKrT1STB8g4MBocrAbT9HVjH9hQ54UliFfntKtgur8dUo0pZrnwF
BrLhlBh8Z5e09hw/NK5j1/xu5L3K9SHxysyM226rl2xZesNOr/62TyAB8V7qj6xe
yN09yCZPFUYAGOdHDb2g/wgk9t77wla7gFfyAUMEE6olKwKA1ASk9VPlvLqOLZNG
zswDpprCGas+oLSqKce+YAMd3XRbCjfGPWCWREHaCRavc/wZO0zDXydIjf9HIll9
veY5Fhn3e4tnt/bzIh/+EhH6N82Ys8J++RALf2G1lt3YVInpxVx/l5BgMqBpg6bo
blYdYOz2PlIHHbYPFs47JjvsbkjefhfkyxDdbMfyDAfGjlhAJEndujwpfAz+wDWH
kGn7hCPkOir/kwucRluGyn+PhKRGpUuw93Ghto9zpRKMcuuSmOTeWR9OJeJCHxN1
5uP4E7gnEAZgAzyASg+0E5sWrCz7NLeNNgP5Z6ODWgdw8Lm1y4z7+P/U9UXlvipq
g7XubL3QEsRT1bL7zTUThmize2YOu9ZAxS1/SiKwQCQTJyWfoAdWczHlSpFjkf78
9BVbgdkwjZKZbrNd5fhvqNDpuPJiNvXIznZ91rOihFghOp2x/IGxKSrYtEPgCkms
Xr77k7SwqJ98lMxJ6bQU
=Sosd
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--
