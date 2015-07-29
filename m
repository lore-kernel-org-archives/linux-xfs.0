Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F2FA07FA8
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 00:02:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D1BFA8F8033
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2015 22:02:36 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	nzRkdIc66P8W8x8Z for <xfs@oss.sgi.com>;
	Tue, 28 Jul 2015 22:02:31 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1ZKJVd-0004PL-BW
	for xfs@oss.sgi.com; Wed, 29 Jul 2015 15:02:29 +1000
Date: Wed, 29 Jul 2015 15:02:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 5461ad9
Message-ID: <20150729050229.GA16638@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5377898975735124766=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============5377898975735124766==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

5461ad9 Merge branch 'xfs-meta-uuid' into for-next

New Commits:

Brian Foster (2):
      [4703da7] xfs: close xc_cil list_empty() races with cil commit sequen=
ce
      [89cebc84] xfs: validate transaction header length on log recovery

Dave Chinner (7):
      [b2442c5] xfs: call dax_fault on read page faults for DAX
      [e3c32ee] xfs: remote attribute headers contain an invalid LSN
      [df150ed1] xfs: remote attributes need to be considered data
      [ab7bb61] xfs: xfs_bunmapi() does not need XFS_BMAPI_METADATA flag
      [1cfc4a9] libxfs: add xfs_bit.c
      [20b8394] Merge branch 'xfs-misc-fixes-for-4.3' into for-next
      [5461ad9] Merge branch 'xfs-meta-uuid' into for-next

Eric Sandeen (1):
      [ce748ea] xfs: create new metadata UUID field and incompat flag

Jan Kara (1):
      [d6077aa] xfs: Remove duplicate jumps to the same label

Joe Perches (1):
      [f41febd] xfs: Use consistent logging message prefixes


Code Diffstat:

 fs/dax.c                           | 14 ++++++++--
 fs/xfs/Makefile                    |  2 +-
 fs/xfs/libxfs/xfs_alloc.c          |  4 +--
 fs/xfs/libxfs/xfs_alloc_btree.c    |  4 +--
 fs/xfs/libxfs/xfs_attr_leaf.c      |  4 +--
 fs/xfs/libxfs/xfs_attr_remote.c    | 53 +++++++++++++++++++++++++++-------=
----
 fs/xfs/{ =3D> libxfs}/xfs_bit.c      |  0
 fs/xfs/libxfs/xfs_bmap_btree.c     |  5 ++--
 fs/xfs/libxfs/xfs_btree.c          | 10 ++++---
 fs/xfs/libxfs/xfs_da_btree.c       |  8 +++---
 fs/xfs/libxfs/xfs_dir2.c           | 33 +++++++++++-------------
 fs/xfs/libxfs/xfs_dir2_block.c     |  4 +--
 fs/xfs/libxfs/xfs_dir2_data.c      |  4 +--
 fs/xfs/libxfs/xfs_dir2_leaf.c      |  4 +--
 fs/xfs/libxfs/xfs_dir2_node.c      |  7 +++--
 fs/xfs/libxfs/xfs_dquot_buf.c      |  4 +--
 fs/xfs/libxfs/xfs_format.h         | 22 +++++++++++++---
 fs/xfs/libxfs/xfs_ialloc.c         |  5 ++--
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c      |  4 +--
 fs/xfs/libxfs/xfs_sb.c             | 24 +++++++++++++----
 fs/xfs/libxfs/xfs_symlink_remote.c |  4 +--
 fs/xfs/xfs_buf.c                   |  5 ++--
 fs/xfs/xfs_file.c                  | 21 ++++++++++-----
 fs/xfs/xfs_inode.c                 | 10 ++-----
 fs/xfs/xfs_log.c                   | 50 +++++++++++++++++------------------
 fs/xfs/xfs_log_cil.c               |  8 +++++-
 fs/xfs/xfs_log_recover.c           | 47 ++++++++++++++++++++++++++-------
 fs/xfs/xfs_symlink.c               |  2 +-
 29 files changed, 233 insertions(+), 131 deletions(-)
 rename fs/xfs/{ =3D> libxfs}/xfs_bit.c (100%)
--=20
Dave Chinner
david@fromorbit.com

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVuF5kAAoJEK3oKUf0dfodYswP/jJEBhKUfUEAhH3Y/vmfxK9d
5u7zywJ/hgpkUHSqIEhfpTSJB45pDYJrPYOCXMtwW4hvP7rE0lzl7k0NGwzu6yDY
3xjuvjXW6Uq7eEfVWZ4ThLcRRZTAhw/YT26KWaZfKaDG/o3B/e56niErhO8DUxMc
64bXHmIhKYVkfezKsn2+TPfqIji+OYSnukugEr0rTwSuJTu9ppVliqieQ8+Qc5Lj
NR9a56LtO8pNNmvp/rgdOigZP+0VLJtpFWy3f1fQ1T/z/P1URcejK35EgmzFzrxB
TX1KydcJGQ0cXeu/9+Kab0WLULJZ99oXFIS4/LMmx6sMWQvWCYV6fyV3cOlZQxke
UysQBbGjFRybzritY708yiRyztMByl+NTnbH4WFKyOq7YfTZw96GMsi8LhnogQA5
8KXipmGoHgkuylMTaHgumy3dOsTOvstqoVonSzH7P3FoGZhKkILkMzfnHAwM/mBY
gALUiDRY01czznfdj4dXXPEqL86HINq7gwo+chqd+H2qN+e+uFaxM0z6I3KVuyIq
v/8Dyyx+QIIG96kg3pOrMNTLpnQ6gj+DsL0r9gmAxluI6dn8GVkVkECgAhp9NFg+
rffFamMow3RFZYj5AJFtv7gSN2AFiANl0BACGrx89WDyDOUSaEuxOvdW1sF3f+17
jISJU/+jdH70wi4SnlXr
=bpBC
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--


--===============5377898975735124766==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5377898975735124766==--
