Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:5918 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752933AbcKJEaH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Nov 2016 23:30:07 -0500
Date: Thu, 10 Nov 2016 15:29:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 0fc204e2eb64
Message-ID: <20161110042953.GY28177@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz, tytso@mit.edu, ross.zwisler@linux.intel.com


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated. This update has a couple of new patches
for iomap and XFS, and a fixup of a cleanup patch. The topic
branches were re-merged, so it's a rebuilt tree.

I added the IOMAP_FAULT patch into the dax-4.10-iomap-pmd branch as
Christoph requested. This will cause some minor hassles - that topic
branch is based on 4.9-rc1, and there is a IOMAP_REPORT flag added
in 4.9-rc3. Hence when you merge it into a more recent tree, a merge
conflict will occur. The merge conflict resolution is trivial but if
you need help it can be seen in the for-next branch (in the merge
commit currently known as b649c42e25b7).

-Dave.

The new head of the for-next branch is commit:

0fc204e2eb64 Merge branch 'xfs-4.10-misc-fixes-1' into for-next

New Commits:

Brian Foster (1):
      [98efe8af1c9f] xfs: fix unbalanced inode reclaim flush locking

Darrick J. Wong (1):
      [bec9d48d7a30] xfs: check minimum block size for CRC filesystems

Dave Chinner (3):
      [b649c42e25b7] Merge branch 'dax-4.10-iomap-pmd' into for-next
      [8f23d318aa74] Merge branch 'xfs-4.10-libxfs-cleanups' into for-next
      [0fc204e2eb64] Merge branch 'xfs-4.10-misc-fixes-1' into for-next

Jan Kara (1):
      [9484ab1bf446] dax: Introduce IOMAP_FAULT flag


Code Diffstat:

 fs/dax.c               |  4 ++--
 fs/iomap.c             |  5 +++--
 fs/xfs/libxfs/xfs_sb.c |  3 +--
 fs/xfs/xfs_icache.c    | 27 ++++++++++++++-------------
 fs/xfs/xfs_inode.h     | 11 ++++++-----
 include/linux/iomap.h  |  1 +
 6 files changed, 27 insertions(+), 24 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYI/fBAAoJEK3oKUf0dfodKJMP/jpNrCoMTRUmTTcqdO+N7cGn
6Jm/d3sLWRjeLDX0+OeUILkZ4HV9+o8qbRSr2KtYv7qHrOzmFGD2N3nHFXDmYXfP
cN0XyTY//x8BsxagVSfqmwZjOoH+txJPOiHgeDzG15cYxniZg1CIGGzzZRkz7V0l
fbTBwXPhtQ4A9ET6LQTTcW2vG6hgIbCfS+EQjO6pqy1oJ8hIFrZioA+PFkTZvrqC
f/v+bbxPoeQIdVaSZuTnBYzrwY9NRFw2az0a2e/C7KzPOAS78ehPZJYRjVOhQW3w
ai5gYqPozsoUsHcOuinZA9on0OUDPudbHI+K0V8rFODSQlXKw+ARX1qkaPwkJCJq
PJskdHoVb1euNPaxiSfm3tyNuXHpk4IS5mz0V4g+rfKdjVKFwCgf5u5s9lo6OhVG
sVe816S+k2DUgjt6YAlJNljEf5Ew9yxwlXcz1nAdfyw+JRGFt+1YT1flzzMDYqeW
K0gMPRvotYU+GsvabguWOr+iYSDPuFbuhThzDd58if1sJcQtkSC8BGKSIfil9gFC
AJEQQQsgxQ0fRJUZCdhLRq8UA+ugu09U6DV2vuvd1nOEbVo4oxnk6vPJGY/qsM/q
AQ1Ci9W7q4r8U6jt7IKH5B8mej3wavttW6umeTM029QtXQzt8x1EMVAmxFkslv7X
dfZYkZKmt00RpE24LvV/
=rr/H
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
