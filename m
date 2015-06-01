Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6E6497F37
	for <xfs@oss.sgi.com>; Sun, 31 May 2015 23:06:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EBB74AC003
	for <xfs@oss.sgi.com>; Sun, 31 May 2015 21:06:16 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Z7xQvO9vbmCJ7cwQ for <xfs@oss.sgi.com>;
	Sun, 31 May 2015 21:06:14 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1YzGzA-0004U6-Nr
	for xfs@oss.sgi.com; Mon, 01 Jun 2015 14:06:00 +1000
Date: Mon, 1 Jun 2015 14:06:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to b9a350a
Message-ID: <20150601040600.GH24666@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8023396102274254832=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============8023396102274254832==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

b9a350a Merge branch 'xfs-sparse-inode' into for-next

New Commits:

Brian Foster (20):
      [d4cc540] xfs: create individual inode alloc. helper
      [999633d] xfs: update free inode record logic to support sparse inode=
 records
      [bfe46d4] xfs: support min/max agbno args in block allocator
      [fb4f2b4] xfs: add sparse inode chunk alignment superblock field
      [066a188] xfs: use sparse chunk alignment for min. inode allocation r=
equirement
      [e5376fc] xfs: sparse inode chunks feature helpers and mount requirem=
ents
      [502a4e7] xfs: add fs geometry bit for sparse inode chunks
      [5419040] xfs: introduce inode record hole mask for sparse inode chun=
ks
      [12d0714] xfs: use actual inode count for sparse records in bulkstat/=
inumbers
      [463958a] xfs: pass inode count through ordered icreate log item
      [7f43c90] xfs: handle sparse inode chunks in icreate log recovery
      [4148c34] xfs: helper to convert holemask to inode alloc. bitmap
      [56d1115] xfs: allocate sparse inode chunks on full chunk allocation =
failure
      [1cdadee] xfs: randomly do sparse inode allocations in DEBUG mode
      [26dd521] xfs: filter out sparse regions from individual inode alloca=
tion
      [10ae3dc7] xfs: only free allocated regions of inode chunks
      [09b5660] xfs: skip unallocated regions of inode chunks in xfs_ifree_=
cluster()
      [22ce1e1] xfs: enable sparse inode chunks for v5 superblocks
      [2e588a4] xfs: always log the inode on unwritten extent conversion
      [7f884dc] xfs: fix quota block reservation leak when tp allocates and=
 frees blocks

Dave Chinner (2):
      [e01c025] Merge branch 'xfs-misc-fixes-for-4.2' into for-next
      [b9a350a] Merge branch 'xfs-sparse-inode' into for-next

Eric Sandeen (1):
      [39e56d9] xfs: don't cast string literals

Fanael Linithien (1):
      [4d66ea0] xfs: fix kernel version in docs

Nan Jia (1):
      [339e4f6] xfs: Clean up xfs_trans_dup_dqinfo


Code Diffstat:

 Documentation/filesystems/xfs.txt |  12 +-
 fs/xfs/libxfs/xfs_alloc.c         |  42 ++-
 fs/xfs/libxfs/xfs_alloc.h         |   2 +
 fs/xfs/libxfs/xfs_bmap.c          |  10 +-
 fs/xfs/libxfs/xfs_format.h        |  52 +++-
 fs/xfs/libxfs/xfs_fs.h            |   1 +
 fs/xfs/libxfs/xfs_ialloc.c        | 541 ++++++++++++++++++++++++++++++++++=
----
 fs/xfs/libxfs/xfs_ialloc.h        |  12 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c  |  93 ++++++-
 fs/xfs/libxfs/xfs_ialloc_btree.h  |  10 +
 fs/xfs/libxfs/xfs_sb.c            |  30 ++-
 fs/xfs/xfs_fsops.c                |   4 +-
 fs/xfs/xfs_inode.c                |  28 +-
 fs/xfs/xfs_itable.c               |  13 +-
 fs/xfs/xfs_log_recover.c          |  26 +-
 fs/xfs/xfs_mount.c                |  16 ++
 fs/xfs/xfs_mount.h                |   2 +
 fs/xfs/xfs_quota.h                |   1 -
 fs/xfs/xfs_trace.h                |  47 ++++
 fs/xfs/xfs_trans_dquot.c          |  32 ++-
 20 files changed, 865 insertions(+), 109 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVa9ooAAoJEK3oKUf0dfodNKMP+wWcpIwv4vRjUJL7J0NFcMYX
hQ481BMf/JPcpEv1XPgzq5cebgpd++jd9/ha8mcNFH+iQBYom9I8cNXiaKcFEtoR
fbxy57aEB+hnQwBpfHq3BMTHvLdP7Dw3tDNFmAV6WzgxMYbO2QYGdOHgUTW+qVjW
7Jj7QIrFluwShtw1NWSFt0biV8z1b8Q7RkdUfHrOERMgb02/BclrugSTlOwU8VNS
GNJGYgVORoGB3sbxO46S/v0Wxaf0bQxEhKN17kS2ovsCJ6DRwJZy/eKJvVSjZ1WQ
O8+cbTi/pFZiLbJ2N9t20ANml9yFJ3ZMAF68A8cE5NfqJGrgJ4oGaiE2NTf6xQnW
2s0j+QO2wXhpkp69ZPSgEAFxwaMFKvj9aTCydVNY0df2wYF3Gnl2x712Y0JJSWFL
TthrfAAfKiUGdmtqkPMICtbLRkm4xJvLs/uXcct6/ZO7tlSgGV2NR2tQ7vozwB4i
SRw6voJqjGPSDGpIglcIZp+W18NrMJg30uVZChR9MekxbdkxkvE+PUIzC/11lGdp
LgPFqqGJwKSeMd62FOuRPwdbYpbzx3ZkqpJDtlzaaswGbYdE+GXokavQVAcNpmY6
3+HO5bUHQbss7iMEXAkq8opDRK3dBUWkDWWcis/azJgu4qX8ZvvIGCtRAeAIVWnl
Dkey/uL4N4AUjtPLXbMb
=bNjq
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--


--===============8023396102274254832==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8023396102274254832==--
