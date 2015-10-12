Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A87067F3F
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 02:48:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 850C4304053
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 00:48:57 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	f0yFjGTELtLnKHPr for <xfs@oss.sgi.com>;
	Mon, 12 Oct 2015 00:48:54 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1ZlXqd-0006qS-Gt
	for xfs@oss.sgi.com; Mon, 12 Oct 2015 18:48:43 +1100
Date: Mon, 12 Oct 2015 18:48:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 1e2103c
Message-ID: <20151012074843.GB31326@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3734549261620904330=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============3734549261620904330==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

1e2103c Merge branch 'xfs-misc-fixes-for-4.4-1' into for-next

New Commits:

Bill O'Donnell (7):
      [bb230c1] xfs: create global stats and stats_clear in sysfs
      [32f0ea0] xfs: create symlink proc/fs/xfs/stat to sys/fs/xfs/stats
      [50cf5b7] xfs: remove unused procfs code
      [a27c264] xfs: consolidate sysfs ops
      [80529c4] xfs: pass xfsstats structures to handlers and macros
      [225e463] xfs: per-filesystem stats in sysfs
      [ff6d6af] xfs: per-filesystem stats counter implementation

Brian Foster (6):
      [009c6e8] xfs: add missing ilock around dio write last extent alignme=
nt
      [b7cdc66] xfs: log local to remote symlink conversions correctly on v=
5 supers
      [a45086e] xfs: validate metadata LSNs against log on v5 superblocks
      [3136e8b] xfs: always drain dio before extending aio write submission
      [0a50f16] xfs: add an xfs_zero_eof() tracepoint
      [dbd5c8c] xfs: pass total block res. as total xfs_bmapi_write() param=
eter

Dave Chinner (3):
      [316433b] Merge branch 'xfs-logging-fixes' into for-next
      [8a56d7c] Merge branch 'xfs-io-fixes' into for-next
      [1e2103c] Merge branch 'xfs-misc-fixes-for-4.4-1' into for-next

Eric Sandeen (3):
      [91f9f5f] xfs: avoid null *src in memcpy call in xlog_write
      [847f9f6] xfs: more info from kmem deadlocks and high-level error msgs
      [9e92054] xfs: simplify /proc teardown & error handling

Geliang Tang (1):
      [fef4ded] libxfs: fix two comment typos

Jan Tulak (2):
      [4e24761] xfs: prefix XATTR_LIST_MAX with XFS_
      [51fcbfe] xfs: avoid dependency on Linux XATTR_SIZE_MAX

Tetsuo Handa (1):
      [5bf97b1] xfs: Print name and pid when memory allocation loops

Zhaohongjiang (1):
      [5cb13dc] cancel the setfilesize transation when io error happen


Code Diffstat:

 fs/xfs/kmem.c                      |  10 +-
 fs/xfs/libxfs/xfs_alloc.c          |  20 ++--
 fs/xfs/libxfs/xfs_attr.c           |   6 +-
 fs/xfs/libxfs/xfs_attr_leaf.c      |   3 +
 fs/xfs/libxfs/xfs_attr_remote.c    |   2 +-
 fs/xfs/libxfs/xfs_bmap.c           |  30 +++---
 fs/xfs/libxfs/xfs_btree.c          |  21 ++++-
 fs/xfs/libxfs/xfs_btree.h          |  39 ++++----
 fs/xfs/libxfs/xfs_da_btree.c       |   4 +
 fs/xfs/libxfs/xfs_dir2.c           |   6 +-
 fs/xfs/libxfs/xfs_dir2_block.c     |   3 +
 fs/xfs/libxfs/xfs_dir2_data.c      |   3 +
 fs/xfs/libxfs/xfs_dir2_leaf.c      |   3 +
 fs/xfs/libxfs/xfs_dir2_node.c      |   3 +
 fs/xfs/libxfs/xfs_format.h         |  10 +-
 fs/xfs/libxfs/xfs_fs.h             |  10 ++
 fs/xfs/libxfs/xfs_ialloc.c         |  10 +-
 fs/xfs/libxfs/xfs_sb.c             |  10 ++
 fs/xfs/libxfs/xfs_symlink_remote.c |   7 ++
 fs/xfs/xfs_aops.c                  |  23 +++--
 fs/xfs/xfs_attr_list.c             |   2 +-
 fs/xfs/xfs_bmap_util.c             |   2 +-
 fs/xfs/xfs_buf.c                   |  21 +++--
 fs/xfs/xfs_dir2_readdir.c          |   2 +-
 fs/xfs/xfs_dquot.c                 |  14 +--
 fs/xfs/xfs_file.c                  |  29 +++---
 fs/xfs/xfs_icache.c                |  18 ++--
 fs/xfs/xfs_inode.c                 |   6 +-
 fs/xfs/xfs_ioctl.c                 |   8 +-
 fs/xfs/xfs_ioctl32.c               |   2 +-
 fs/xfs/xfs_iomap.c                 |  51 ++++++----
 fs/xfs/xfs_iops.c                  |   4 +-
 fs/xfs/xfs_linux.h                 |   7 ++
 fs/xfs/xfs_log.c                   |  93 +++++++++++++++----
 fs/xfs/xfs_log.h                   |   1 +
 fs/xfs/xfs_log_priv.h              |  51 ++++++++++
 fs/xfs/xfs_log_recover.c           |  12 ++-
 fs/xfs/xfs_message.c               |   7 ++
 fs/xfs/xfs_mount.c                 |  11 ++-
 fs/xfs/xfs_mount.h                 |   1 +
 fs/xfs/xfs_pnfs.c                  |   5 +
 fs/xfs/xfs_qm.c                    |  14 +--
 fs/xfs/xfs_stats.c                 |  91 +++++++++---------
 fs/xfs/xfs_stats.h                 |  36 +++++---
 fs/xfs/xfs_super.c                 |  49 ++++++++--
 fs/xfs/xfs_sysctl.c                |  15 +--
 fs/xfs/xfs_sysfs.c                 | 185 ++++++++++++++++++++++-----------=
----
 fs/xfs/xfs_sysfs.h                 |   1 +
 fs/xfs/xfs_trace.h                 |   1 +
 fs/xfs/xfs_trans.c                 |   6 +-
 fs/xfs/xfs_trans_ail.c             |  12 +--
 51 files changed, 655 insertions(+), 325 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWG2XbAAoJEK3oKUf0dfod4AUP/1gTJ9O0KKVa39kKgBW2VGAc
JHSyrr1U3Pva7JVCWolnlthNCAY6O6SGC/z2Va5AT42SMpXCsH5TkLUaThf3difs
KxT2GMeaF/LtpOEkpx6zJKDIvn5tFPcMW8cHzRYun+NIJQ1vumLS8yaHYsjldUwW
mTEYC1PXVH9a/cSEovE5C2ALJEIRoGGWjWruRXEThCn7w10u8ffipyjqk7LMxxHW
U+LwINmCDHtGtt7oEh6VcsIF54YfwfuU4rn8PoocI58ENX/YuPU/735xmtAzc6rX
/6iNiDtJN70w4dGcfIpZJXkPXfe/iZvarVwRAusmfGR5ZFqdkI4GzgS9b8L1kL4J
ONCOGEzlPhzQENWPQN4BPwcXOrtFfQVSzJDwIy/1Q2Th4UBMk3ihXANUQJDhCoOW
lgLTzYvnWRxKMbuPl5LZ6DcaIpXLxZQvxo3Jk+8zBiwwvFhRjzQo9Wx/zfSevGl0
hH3SdPLhjGGUtsmj6rjOMF+ABXncUIgbdK6Y+CS20IHeyc0kjhdGnl6qaHY7APrW
p/o+StHKXT2bJU/W2iMt//u9FmTKLaAJsrus1yuMFlrdqHLYpA/w77GhIK+3n8X5
xHHNiNFWTFXcnJfVBtyn2AEm2dryNow0ZalL3BVic+9pCgJH0ZayVPn3dMRa7BRw
Uz2D10c/+mJByZ+CTgad
=kSOA
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--


--===============3734549261620904330==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3734549261620904330==--
