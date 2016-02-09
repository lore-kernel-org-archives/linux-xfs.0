Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EDD2F7CA2
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 00:49:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6CDDAAC005
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 22:49:46 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	JvqgcHyCz5Qx5PeY for <xfs@oss.sgi.com>;
	Mon, 08 Feb 2016 22:49:43 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1aT27I-00024F-QR
	for xfs@oss.sgi.com; Tue, 09 Feb 2016 17:49:40 +1100
Date: Tue, 9 Feb 2016 17:49:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch rebased to 4faac78
Message-ID: <20160209064940.GQ27429@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8475757031298708930=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============8475757031298708930==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated. This is a rebase due to needing to fix the
commits in the xfs-rt-fixes-4.6 branch due to a build failure. It
also includes the struct xfs_icdinode size reduction patchset.
See the commit list below for all the new commits compared to the
previous for-next branch.

-Dave.

The new head of the for-next branch is commit:

4faac78 Merge branch 'xfs-gut-icdinode-4.6' into for-next

New Commits:

Dave Chinner (16):
      [f67ca6e] xfs: RT bitmap and summary buffers are not typed
      [bf85e09] xfs: RT bitmap and summary buffers need verifiers
      [f8d55aa] xfs: introduce inode log format object
      [3987848] xfs: remove timestamps from incore inode
      [93f958f] xfs: cull unnecessary icdinode fields
      [faeb4e4] xfs: move v1 inode conversion to xfs_inode_from_disk
      [5099747] xfs: reinitialise recycled VFS inode correctly
      [54d7b5c] xfs: use vfs inode nlink field everywhere
      [9e9a267] xfs: move inode generation count to VFS inode
      [83e06f2] xfs: move di_changecount to VFS inode
      [c19b3b05] xfs: mode di_mode to vfs inode
      [fc0f49c] Merge branch 'xfs-rt-fixes-4.6' into for-next
      [4f22770] Merge branch 'xfs-get-next-dquot-4.6' into for-next
      [0294f79] Merge branch 'xfs-dio-fix-4.6' into for-next
      [18c5e03] Merge branch 'xfs-misc-fixes-4.6' into for-next
      [4faac78] Merge branch 'xfs-gut-icdinode-4.6' into for-next


Code Diffstat:

 fs/xfs/libxfs/xfs_bmap.c       |   6 +-
 fs/xfs/libxfs/xfs_dir2.c       |  12 +--
 fs/xfs/libxfs/xfs_inode_buf.c  | 170 ++++++++++++++++++++++++++-----------=
---
 fs/xfs/libxfs/xfs_inode_buf.h  |  38 ++++++++-
 fs/xfs/libxfs/xfs_inode_fork.c |   2 +-
 fs/xfs/libxfs/xfs_log_format.h |  17 ++--
 fs/xfs/libxfs/xfs_rtbitmap.c   |   2 +-
 fs/xfs/xfs_bmap_util.c         |   4 +-
 fs/xfs/xfs_dir2_readdir.c      |   2 +-
 fs/xfs/xfs_export.c            |   2 +-
 fs/xfs/xfs_file.c              |   6 +-
 fs/xfs/xfs_filestream.c        |   4 +-
 fs/xfs/xfs_icache.c            |  43 +++++++++--
 fs/xfs/xfs_inode.c             | 172 +++++++++++++++++--------------------=
----
 fs/xfs/xfs_inode.h             |   8 +-
 fs/xfs/xfs_inode_item.c        |  82 ++++++++++++++++++--
 fs/xfs/xfs_ioctl.c             |  16 ++--
 fs/xfs/xfs_iops.c              |  53 +++----------
 fs/xfs/xfs_itable.c            |  22 +++---
 fs/xfs/xfs_log_recover.c       |  60 +++++++-------
 fs/xfs/xfs_mount.c             |   2 +-
 fs/xfs/xfs_rtalloc.c           |   2 +-
 fs/xfs/xfs_trans_inode.c       |  14 +---
 23 files changed, 431 insertions(+), 308 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWuYwEAAoJEK3oKUf0dfodurUP/1EATQ+mGOPZsR3ZCXVquDQJ
2SSuGFpaMC/LqKMZzYhv5/vV+jWagNPOZ3+xqTC22Gl6SldhR7EBDKDe4pwgEJUA
S3wNXXwOxWD79CbmcqDVHSofnnZgCaegCGYen4H3I8H7iurM9RPz0h8ClB8VYLNk
QQHEEzfO3ahnHyZr5lsY2718RZjXjqvkugEkT/cH5ve/iRscA7gMeLogXUl8WIMS
jwuYDIWUWkYN6vo5T2vdVQAXrUeTfRrM5sfYmfdM40UlVlFoQtCB7pu3oy/O5Fcz
wg+d9eEHzRD56gA2wRC1I0IO5wtffxgg+OUdWYnsSMLgtLJr8zKQh/whPQUgRtNu
oXQCyaFwZu75Y8tMcf/KuX2nyvhX1hgcpYbZbKC+zwYhq4DmyDtEfte2VlXdBnx9
LHdhp7EuMmQLMV45GyrSPdUwzbFkaXJRcTjTY3vLW+5AbhrZzgvtPjinsE71LNEq
Vqeh+iz4cUh3JUokpgQu3lqAVvHFtier43v4Z71qjrxhgapZaja6yZOMPoa7FoL2
7F6eeUyB7GuiI0e9Dh5PcYij+DCU6ZDXy1WUCfbWEbjzJC+cERgNbHqJoeBY1Xcw
O9nj4Ziijv0rukUMpY3bSM71Gnd13VqWonMtqMp1cOIKfDlMmCWAtXGq56vH9StW
aCHT/vQy7CWX2U+37CmV
=+aFs
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--


--===============8475757031298708930==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8475757031298708930==--
