Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 349297F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 00:29:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 15149304032
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 22:29:13 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	tqEDSj6IPAk95EjE for <xfs@oss.sgi.com>;
	Sun, 03 Jan 2016 22:29:09 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1aFydf-0000z8-DB
	for xfs@oss.sgi.com; Mon, 04 Jan 2016 17:29:07 +1100
Date: Mon, 4 Jan 2016 17:29:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 887a9f2
Message-ID: <20160104062907.GC19802@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5109957181891331085=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============5109957181891331085==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Content-Disposition: inline


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

887a9f2 Merge branch 'xfs-dax-fixes-for-4.5' into for-next

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
      [841af8e] xfs: detect and trim torn writes during log recovery
      [35de070] xfs: debug mode log record crc error injection

Darrick J. Wong (5):
      [2e9101d] libxfs: make xfs_alloc_fix_freelist non-static
      [9b434a3] xfs: fix log ticket type printing
      [6d3eb1e] libxfs: use a convenience variable instead of open-coding t=
he fork
      [96f859d] libxfs: pack the agfl header structure so XFS_AGFL_SIZE is =
correct
      [c5ab131] libxfs: refactor short btree block verification

Dave Chinner (4):
      [289542c] Merge branch 'xfs-misc-fixes-for-4.5' into for-next
      [3b0fe47] xfs: Don't use reserved blocks for data blocks with DAX
      [a6d7636] xfs: fix recursive splice read locking with DAX
      [887a9f2] Merge branch 'xfs-dax-fixes-for-4.5' into for-next

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
 fs/xfs/xfs_log_recover.c           | 569 ++++++++++++++++++++++++++++++---=
----
 fs/xfs/xfs_super.c                 |   2 +-
 fs/xfs/xfs_sysfs.c                 |  36 +++
 fs/xfs/xfs_trans_dquot.c           |  14 +-
 34 files changed, 691 insertions(+), 208 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWihEyAAoJEK3oKUf0dfodH6sP/0MHR5pfBQZM+ug4YiZDWr4F
PNs1VrgWyq/D4vLYXq9Qn8lLnsLf0x+hk+wcbXLFDJzhg4vR7ypUtjkMC8QblMIj
H/3/djztjSUrm36cBBWhHEL/awqGAFus3ll/RDC+F0qvbdeOmWsOYmXlVzXhOtmB
e42HzZBCU9Rb5cjP2AAViCj4qDBj9mD73XXznJPVFPNKsCknerOvz5YZejOqTfjJ
5iz0eeZ+u+W2ydVoqTB9LVv+IyJ200w8LK7yHyT5asbEp5wjwt0f7Fd7ODjZamLg
6j4BuKJpofDlOHW6EQ+COfNwz0TtBeEG0T7AhgXMh/YpJ0k9lAu5TGmYwmNYxFzw
vGETWkPZxdwOld355bskQrtXUriUfLr0GBJpjc+GjipjzGAA474B6M8qQssT7p1e
ehmE3HT3TTH93ULjCNjHriru4uZiTk5hDituWxZR6M1j2U0rd+DRobkuMgr1P+Za
vW9s/VhLIlup02U4MruTMSSHbxqdxMka3EFRUWGA2m/EGQGSo0/5pFG+zf4Kh75B
v5GxzfKVTUOncLrrv3c4Yatrk1QHNzwT5j2gYpbH8nvEISnUgDWt2ji+g3T3YRpM
CmIC6t/yBsl8GlftPthxgoc7CK9bkK2ge/DARZtCsPkmF8nCFQvf/VAzqpymcrW4
Je+7A3NhQUnVCpfi9Tzx
=yEBf
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--


--===============5109957181891331085==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5109957181891331085==--
