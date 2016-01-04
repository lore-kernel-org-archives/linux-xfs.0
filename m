Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 35A407F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 15:37:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CBFDCAC002
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 13:37:14 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	9v8HZ37XyFcbesP8 for <xfs@oss.sgi.com>;
	Mon, 04 Jan 2016 13:37:08 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1aGCnz-0002nq-QY
	for xfs@oss.sgi.com; Tue, 05 Jan 2016 08:36:43 +1100
Date: Tue, 5 Jan 2016 08:36:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch rebased to 4922be5
Message-ID: <20160104213643.GE19802@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7124995019607249565=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============7124995019607249565==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kVXhAStRUZ/+rrGn"
Content-Disposition: inline


--kVXhAStRUZ/+rrGn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated. I rebased the xfs-log-torn-write branch to
include the 32bit arch build fix that the kbuild robot noticed and
Brain fixed. It's the base branch in the for-next tree so while
only one commit changed, I had to restart the for-next branch
build from scratch...

-Dave

The new head of the for-next branch is commit:

4922be5 Merge branch 'xfs-dax-fixes-for-4.5' into for-next

New Commits:

Alexander Kuleshov (1):
      [211fe1a] xfs: make xfs_buf_ioend_async() static

Brian Foster (8):
      [a70f9fe] xfs: detect and handle invalid iclog size set by mkfs
      [9d94901] xfs: refactor log record unpack and data processing
      [b94fb2d] xfs: refactor and open code log record crc check
      [d7f3769] xfs: return start block of first bad log record during reco=
very
      [6528250] xfs: support a crc verification only log record pass
      [eed6b46] xfs: refactor log record start detection into a new helper
      [7088c41] xfs: detect and trim torn writes during log recovery
      [609adfc] xfs: debug mode log record crc error injection

Darrick J. Wong (5):
      [2e9101d] libxfs: make xfs_alloc_fix_freelist non-static
      [9b434a3] xfs: fix log ticket type printing
      [6d3eb1e] libxfs: use a convenience variable instead of open-coding t=
he fork
      [96f859d] libxfs: pack the agfl header structure so XFS_AGFL_SIZE is =
correct
      [c5ab131] libxfs: refactor short btree block verification

Dave Chinner (4):
      [3b0fe47] xfs: Don't use reserved blocks for data blocks with DAX
      [a6d7636] xfs: fix recursive splice read locking with DAX
      [7eeabbd] Merge branch 'xfs-misc-fixes-for-4.5' into for-next
      [4922be5] Merge branch 'xfs-dax-fixes-for-4.5' into for-next

Eric Sandeen (2):
      [233135b] xfs: print name of verifier if it fails
      [f1f96c4] xfs: get mp from bma->ip in xfs_bmap code

Jia He (1):
      [1d4292b] libxfs: Optimize the loop for xfs_bitmap_empty

Markus Elfring (1):
      [a841b64] XFS: Use a signed return type for suffix_kstrtoint()

Masatake YAMATO (1):
      [ffc671f] xfs: send warning of project quota to userspace via netlink


Code Diffstat:

 fs/xfs/libxfs/xfs_alloc.c          |   4 +-
 fs/xfs/libxfs/xfs_alloc.h          |   1 +
 fs/xfs/libxfs/xfs_alloc_btree.c    |  35 +--
 fs/xfs/libxfs/xfs_attr_leaf.c      |   1 +
 fs/xfs/libxfs/xfs_attr_remote.c    |   1 +
 fs/xfs/libxfs/xfs_bit.c            |   6 +-
 fs/xfs/libxfs/xfs_bmap.c           |  27 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |   1 +
 fs/xfs/libxfs/xfs_btree.c          |  58 ++++
 fs/xfs/libxfs/xfs_btree.h          |   3 +
 fs/xfs/libxfs/xfs_da_btree.c       |   1 +
 fs/xfs/libxfs/xfs_dir2_block.c     |   1 +
 fs/xfs/libxfs/xfs_dir2_data.c      |   2 +
 fs/xfs/libxfs/xfs_dir2_leaf.c      |   2 +
 fs/xfs/libxfs/xfs_dir2_node.c      |   1 +
 fs/xfs/libxfs/xfs_dquot_buf.c      |   1 +
 fs/xfs/libxfs/xfs_format.h         |   2 +-
 fs/xfs/libxfs/xfs_ialloc.c         |   1 +
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  27 +-
 fs/xfs/libxfs/xfs_inode_buf.c      |   2 +
 fs/xfs/libxfs/xfs_log_recover.h    |   1 +
 fs/xfs/libxfs/xfs_sb.c             |   2 +
 fs/xfs/libxfs/xfs_symlink_remote.c |   1 +
 fs/xfs/xfs_buf.c                   |   2 +-
 fs/xfs/xfs_buf.h                   |   1 +
 fs/xfs/xfs_error.c                 |   4 +-
 fs/xfs/xfs_file.c                  |  25 +-
 fs/xfs/xfs_iomap.c                 |  11 +-
 fs/xfs/xfs_log.c                   |  51 +++-
 fs/xfs/xfs_log_priv.h              |   3 +
 fs/xfs/xfs_log_recover.c           | 572 ++++++++++++++++++++++++++++++---=
----
 fs/xfs/xfs_super.c                 |   2 +-
 fs/xfs/xfs_sysfs.c                 |  36 +++
 fs/xfs/xfs_trans_dquot.c           |  14 +-
 34 files changed, 693 insertions(+), 209 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--kVXhAStRUZ/+rrGn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWiuXrAAoJEK3oKUf0dfodsOcP+gLWHk4z3AYYaKUwWLpfuCq9
HWPm68c+2WE3MvoX90UMUAxKhVPzZhWas4zbLEiKKzhWj+oANm28jnUqX+cRbvrQ
EihIp1cuJVvtm5ZYv8FQNEup0PlfhzhNro9DrCU5k7X8qHfCNxUWnRSk97gbIUiQ
cYymhYudBc4CUkyroShqX9obCYtJAlITxW3zZwGktXDFO+6mlRBIeZ38ok4A5+zb
QszqglLqHUFx8XrKYB8CG03FFp2ShNZ7J0MgeYsCnT7yooD7taUPi2VrwdcR78d5
RDrzgw7f/eXypaxk2lUSjRR9Vwk6xEkBw8RoPHuWOMCzayMP235CduD5kFY7Fshd
PZ5USCqYOu14vGjBtpZbDAYCjsUBEa7IPUxNMGScl8wfnYYCtwKDSSv6vvEEmcn0
+sl4lwv+Sd2+63f94quCxKDyyfCIlrBo+hkPtns2Q7cCRz3uBSfDyrc+wJ8DFtDO
Sb+31kvrO1Rmy3Kd+5JKQyRZqZbbyuWWNPUl5QEoYhXw+Qxe619/oeZgk11JY0hJ
nyp74AEpVAUvyzRIUTI93KKlgp4jANnRB+y36kR9yxsgfCEhpP6Few4nvVuGqASy
oPCqVOXxqyb99pyJKDw7F+s0OHyvxxSMA9g807R1tMFhW8ZeF2KuTi1ntBEF8O5p
KnKKjeI+FRl2DxMeAT7A
=MYxv
-----END PGP SIGNATURE-----

--kVXhAStRUZ/+rrGn--


--===============7124995019607249565==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7124995019607249565==--
