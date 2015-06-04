Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 964BE7FAA
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 17:59:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 80852304048
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 15:59:12 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	pJfs6abcWboSUTIs for <xfs@oss.sgi.com>;
	Thu, 04 Jun 2015 15:59:10 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1Z0e5x-00064V-Ml
	for xfs@oss.sgi.com; Fri, 05 Jun 2015 08:58:41 +1000
Date: Fri, 5 Jun 2015 08:58:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 4ea7976
Message-ID: <20150604225841.GW24666@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6857214101554027986=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============6857214101554027986==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Content-Disposition: inline


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

4ea7976 Merge branch 'xfs-commit-cleanup' into for-next

New Commits:

Brian Foster (2):
      [3cdaa18] xfs: fix sparse inodes 32-bit compile failure
      [46fc58d] xfs: check min blks for random debug mode sparse allocations

Christoph Hellwig (5):
      [2e6db6c] xfs: switch remaining xfs_trans_dup users to xfs_trans_roll
      [eacb24e] xfs: pass a boolean flag to xfs_trans_free_items
      [4906e21] xfs: remove the flags argument to xfs_trans_cancel
      [7039331] xfs: saner xfs_trans_commit interface
      [f78c390] xfs: fix xfs_log_done interface

Dave Chinner (11):
      [ec56b1f] xfs: mmap lock needs to be inside freeze protection
      [e842f29] dax: don't abuse get_block mapping for endio callbacks
      [ce5c5d5] dax: expose __dax_fault for filesystems with locking constr=
aints
      [6b698ed] xfs: add DAX file operations support
      [4f69f57] xfs: add DAX block zeroing support
      [9969441] xfs: add DAX truncate support
      [6e1ba0b] xfs: add DAX IO path support
      [cbe4dab] xfs: add initial DAX support
      [66e8ac7] Merge branch 'xfs-dax-support' into for-next
      [4497f28] Merge branch 'xfs-misc-fixes-for-4.2-2' into for-next
      [4ea7976] Merge branch 'xfs-commit-cleanup' into for-next


Code Diffstat:

 fs/dax.c                   |  34 +++++++--
 fs/ext2/file.c             |   4 +-
 fs/ext4/file.c             |  16 +++-
 fs/ext4/inode.c            |  21 ++----
 fs/xfs/libxfs/xfs_attr.c   |  25 +++----
 fs/xfs/libxfs/xfs_bmap.c   |  16 ++--
 fs/xfs/libxfs/xfs_ialloc.c |  15 ++--
 fs/xfs/libxfs/xfs_sb.c     |   4 +-
 fs/xfs/libxfs/xfs_shared.h |   6 --
 fs/xfs/xfs_aops.c          | 158 +++++++++++++++++++++++++++------------
 fs/xfs/xfs_aops.h          |   7 +-
 fs/xfs/xfs_attr_inactive.c |   6 +-
 fs/xfs/xfs_bmap_util.c     |  89 +++++++++++-----------
 fs/xfs/xfs_dquot.c         |   8 +-
 fs/xfs/xfs_file.c          | 166 ++++++++++++++++++++++++-----------------
 fs/xfs/xfs_fsops.c         |   6 +-
 fs/xfs/xfs_inode.c         | 180 ++++++++++++-----------------------------=
----
 fs/xfs/xfs_ioctl.c         |  14 ++--
 fs/xfs/xfs_iomap.c         |  18 ++---
 fs/xfs/xfs_iops.c          |  48 ++++++------
 fs/xfs/xfs_log.c           |  11 +--
 fs/xfs/xfs_log.h           |  13 +---
 fs/xfs/xfs_log_cil.c       |  12 +--
 fs/xfs/xfs_log_recover.c   |   8 +-
 fs/xfs/xfs_mount.h         |   2 +
 fs/xfs/xfs_pnfs.c          |   4 +-
 fs/xfs/xfs_qm.c            |   7 +-
 fs/xfs/xfs_qm_syscalls.c   |  20 +++--
 fs/xfs/xfs_rtalloc.c       |  16 ++--
 fs/xfs/xfs_super.c         |  25 ++++++-
 fs/xfs/xfs_symlink.c       |  17 ++---
 fs/xfs/xfs_trans.c         |  91 ++++++++---------------
 fs/xfs/xfs_trans.h         |   7 +-
 fs/xfs/xfs_trans_priv.h    |   2 +-
 include/linux/fs.h         |   9 ++-
 35 files changed, 537 insertions(+), 548 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVcNghAAoJEK3oKUf0dfod8e8QAIT28D86Met2Kn5r3y8MSB/V
5VLRP6Zd5HXCOoiwoku69J4qjhL9o8culVvrAvIjZ7mI30OdydKlIujfCjZEeNzG
h0Ky57KjNwiXae6XFx6ZMHP1rAisd55lwGCiwyoLhtLsngW6f7C2hHyqf45sALs9
fuWd7lWalkRH7t7M5ostrAkOOf3rBYgjelU13w8+ErE0kTh3Cd4YqIMQWx1kEcnT
5Olt3jz/gXbG4IQ6dDbPKBrk+TSDM1dTjLRnqISwbWN/ffnAnWas6uOHZAzsSo6y
xJVqjjY8Q68k+yWWdaIMgx65+x55C9XLP0BxaGZ/32AWrdtVNX9HzsGIkd0bOcKY
A5KQD+zz2DDyXYEwFt4qUnXUSqCNOgKE9kBx1+6vkbvnBwqd1mMmrktnXak7p3Bq
0OgjyEGURtCtCZW6lB7kvn5trekTcYKk2C6DHxUfjA13KXwkvKlG3hjIvmQbvvHZ
lwqAwYybu+2COzsdSjxpAO5ZLwjIvJFtwFL5K40Ue9zIwFvNUAgW/dv5rATZyofk
vzk2a/zrDeL738pPPUeID3e6kEApd0Kfmh2rvs5EOYE2oOsb4ENx6BX0hR5jclSA
8iWgHBZ7IEM5aCzCcIaeVQIuIOSGeIx9x3Ole/TPope6GU+d6qbo3rQzLZdiU/Bl
PtdZTDxSKBrCdx85vVO/
=d3z0
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--


--===============6857214101554027986==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6857214101554027986==--
