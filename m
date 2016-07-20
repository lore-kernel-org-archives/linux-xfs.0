Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A68AE7CA0
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 00:10:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 782B88F8035
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 22:10:26 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	vU8Z6PnOmYmgI4DC for <xfs@oss.sgi.com>;
	Tue, 19 Jul 2016 22:10:19 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1bPjlx-000152-7z
	for xfs@oss.sgi.com; Wed, 20 Jul 2016 15:10:17 +1000
Date: Wed, 20 Jul 2016 15:10:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to dc4113d2
Message-ID: <20160720051017.GJ16044@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5866914470293292456=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============5866914470293292456==
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

has just been updated. Christoph, I pulled all of your DAX vs DIO
patchset except for the last patch that changed the locking. I'm
still undecided on that and my focus is on other things (like rmap)
right now, so I've left it out for the moment.

Speaking of rmap, that's the last piece I want to get into this
cycle. There are a couple of ther fixes that would be nice to have,
but rmap is the main one right now....

-Dave.

The new head of the for-next branch is commit:

dc4113d2 Merge branch 'xfs-4.8-dir2-sf-fixes' into for-next

New Commits:

Brian Foster (2):
      [c891c30] xfs: exclude never-released buffers from buftarg I/O accoun=
ting
      [9c7504a] xfs: track and serialize in-flight async buffers against un=
mount

Christoph Hellwig (10):
      [8f3e205] xfs: don't pass ioflags around in the ioctl path
      [3176c3e] xfs: kill ioflags
      [cf81071] xfs: remove s_maxbytes enforcement in xfs_file_read_iter
      [bbc5a74] xfs: split xfs_file_read_iter into buffered and direct I/O =
helpers
      [f1285ff] xfs: stop using generic_file_read_iter for direct I/O
      [fa8d972] xfs: direct calls in the direct I/O path
      [16d4d43] xfs: split direct I/O and DAX path
      [8353a64] xfs: kill xfs_dir2_sf_off_t
      [266b696] xfs: kill xfs_dir2_inou_t
      [aa2dd0a] xfs: remove __arch_pack

Dan Carpenter (1):
      [fbc21f3] xfs: don't allow negative error tags

Dave Chinner (4):
      [f637161] Merge branch 'xfs-4.8-misc-fixes-3' into for-next
      [bbfeb61] Merge branch 'xfs-4.8-buf-fixes' into for-next
      [b47ec80] Merge branch 'xfs-4.8-split-dax-dio' into for-next
      [dc4113d2] Merge branch 'xfs-4.8-dir2-sf-fixes' into for-next

Eric Sandeen (3):
      [e97f6c5] xfs: fix xfs_error_get_cfg for negative errnos
      [0b4db5d] xfs: remove extraneous buffer flag changes
      [5539d36] xfs: don't reset b_retries to 0 on every failure

Hou Tao (1):
      [ad70328] xfs: remove the magic numbers in xfs_btree_block-related le=
n macros

Jann Horn (1):
      [7f1b624] xfs: fix type confusion in xfs_ioc_swapext

Kaho Ng (1):
      [fbfb24b] xfs: indentation fix in xfs_btree_get_iroot()


Code Diffstat:

 fs/xfs/libxfs/xfs_btree.c     |   8 +-
 fs/xfs/libxfs/xfs_da_format.c |  31 +++---
 fs/xfs/libxfs/xfs_da_format.h |  43 +++------
 fs/xfs/libxfs/xfs_dir2_sf.c   |  38 +++-----
 fs/xfs/libxfs/xfs_format.h    |  66 ++++++++-----
 fs/xfs/xfs_aops.c             |  24 +----
 fs/xfs/xfs_aops.h             |   3 +
 fs/xfs/xfs_buf.c              | 170 ++++++++++++++++++++++++---------
 fs/xfs/xfs_buf.h              |   7 +-
 fs/xfs/xfs_buf_item.c         |  12 +--
 fs/xfs/xfs_error.c            |   2 +-
 fs/xfs/xfs_error.h            |   2 +-
 fs/xfs/xfs_file.c             | 232 ++++++++++++++++++++++++++++++++++----=
-------
 fs/xfs/xfs_inode.h            |  10 --
 fs/xfs/xfs_ioctl.c            |  33 ++++---
 fs/xfs/xfs_ioctl.h            |   3 -
 fs/xfs/xfs_ioctl32.c          |   6 +-
 fs/xfs/xfs_linux.h            |   7 --
 fs/xfs/xfs_log.c              |   5 +-
 fs/xfs/xfs_mount.c            |  10 +-
 fs/xfs/xfs_ondisk.h           |   6 +-
 fs/xfs/xfs_sysfs.c            |   3 +
 fs/xfs/xfs_trace.h            |  21 ++--
 23 files changed, 451 insertions(+), 291 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXjwe4AAoJEK3oKUf0dfodqTkP/3k/QggiAWH3LftPpgLEhzHh
rJqJbXAbuFsAlZuFJTpQMQVFpeySePOHCddoT+wmLntQdPvJ70In2a3yw09CC3H7
XUlrz0OlSuB8YkyD/SAkjhQvI+HB791Lkv5/PdTfCoUHPhkvZKaa+KT18MMHGSxN
vNd89WceP5SzQcMh1BkR/6IYtQ01nGWnWApzemKxFWRyWowia8YXFCjQ57f4kjfR
Vp81Y6BlqkJvzKew2EhOk/kx+tEWM5+FtUIZYVkZXP9nhDUh11tDOIwIvr2b9y1z
ct7aQM4b0880b8ERT/qE3N/dLDuSKFIbBPRQRSQ0cXopoKJGnEkjMzQl+kiHjZD7
OlkuoGvAz9jjdOq2A0QZPLHBOHLg7R4jjlS2k2Df89uRzMTQ9UMLQ4hng3HxEPWE
M1GA0wNnO9MMc8qYv9Y0ktX63CYDFFeZWdVOOf4L7E1+YBn0uOFwGWJKwwNnZz4q
f00kV9LWH1kViCXwBxRPaZPvqcfxEegrNqAX/6R1ydGktipv0vgMtQNgm38zp3ei
/63W5PXrtRzYLo4Wtob3l138zUAyvIZc7HuRyD9kQayD2acELhg7eh/LMS5tRRJE
zk+DLyybxH9HK7BxiN6stnWZDHQW5pAeuKVe6ToxAOkd4p+M7SC7YoL0AfpvQUd5
BHo8/NpTc1TcuKQqd4sS
=mNl3
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--


--===============5866914470293292456==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5866914470293292456==--
