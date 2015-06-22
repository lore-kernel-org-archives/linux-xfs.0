Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F40E57F47
	for <xfs@oss.sgi.com>; Mon, 22 Jun 2015 18:28:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8F892AC007
	for <xfs@oss.sgi.com>; Mon, 22 Jun 2015 16:28:28 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	nXAIevvyDqXvbttP for <xfs@oss.sgi.com>;
	Mon, 22 Jun 2015 16:28:22 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1Z7B8W-0002Hx-BP
	for xfs@oss.sgi.com; Tue, 23 Jun 2015 09:28:20 +1000
Date: Tue, 23 Jun 2015 09:28:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to de50e16
Message-ID: <20150622232820.GD22807@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6807002547337536072=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============6807002547337536072==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

de50e16 Merge branch 'xfs-misc-fixes-for-4.2-3' into for-next

New Commits:

Brian Foster (1):
      [f66bf04] xfs: don't truncate attribute extents if no extents exist

Christoph Hellwig (5):
      [db9d67d] xfs: remove __psint_t and __psunsigned_t
      [fc51c2b] xfs: remove inst_t
      [88ee2df] xfs: return a void pointer from xfs_buf_offset
      [5809d5e] xfs: use void pointers in log validation helpers
      [b2a922c] xfs: remove xfs_caddr_t

Dave Chinner (6):
      [50adbcb] xfs: xfs_alloc_fix_freelist() can use incore perag structur=
es
      [72d5528] xfs: factor out free space extent length check
      [396503f] xfs: sanitise error handling in xfs_alloc_fix_freelist
      [496817b] xfs: clean up XFS_MIN_FREELIST macros
      [3d238b7] Merge branch 'xfs-freelist-cleanup' into for-next
      [de50e16] Merge branch 'xfs-misc-fixes-for-4.2-3' into for-next

Eric Sandeen (1):
      [2ac56d3] xfs: fix remote symlinks on V5/CRC filesystems


Code Diffstat:

 fs/xfs/libxfs/xfs_alloc.c       | 239 ++++++++++++++++++++++--------------=
----
 fs/xfs/libxfs/xfs_alloc.h       |   8 +-
 fs/xfs/libxfs/xfs_bmap.c        |   3 +-
 fs/xfs/libxfs/xfs_format.h      |  13 ---
 fs/xfs/libxfs/xfs_ialloc.h      |   3 +-
 fs/xfs/libxfs/xfs_inode_buf.c   |   8 +-
 fs/xfs/libxfs/xfs_trans_resv.h  |   4 +-
 fs/xfs/libxfs/xfs_trans_space.h |   2 +-
 fs/xfs/xfs_attr_inactive.c      |  10 +-
 fs/xfs/xfs_buf.c                |   6 +-
 fs/xfs/xfs_buf.h                |   2 +-
 fs/xfs/xfs_error.c              |   4 +-
 fs/xfs/xfs_error.h              |   4 +-
 fs/xfs/xfs_extfree_item.c       |   2 +-
 fs/xfs/xfs_filestream.c         |   3 +-
 fs/xfs/xfs_inode.c              |   2 +-
 fs/xfs/xfs_linux.h              |  14 ---
 fs/xfs/xfs_log.c                |  40 ++++---
 fs/xfs/xfs_log_priv.h           |   2 +-
 fs/xfs/xfs_log_recover.c        |  63 ++++++-----
 fs/xfs/xfs_symlink.c            |   2 +-
 fs/xfs/xfs_trans_ail.c          |   6 +-
 22 files changed, 219 insertions(+), 221 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJViJoTAAoJEK3oKUf0dfodbGQQAKvphgT+DkOQDtzQP4CZiIJe
erDwTUkaUPccQchn47TdiYDomzk3BTAYrxYr7qt4jAYj5IAYxi39T7fdn5FYVqvZ
tjg67Ld1j9DqMKa6UO6wkfv/oOlFQhwXvjqNn73g994W0DS4WaItXL6iAL3wTCHv
OrkDnAvOECW5t0ixCM3kCi4+YEVQAcOGsPbDCZdg0UB2ujzsYTc5lIVK+9J+nukB
lzK0+AyPjpTNIG4o0z30sQvXOHeLO21kuEQDnQx3bbx+XAz9feX2VCOoVZv0p/Xl
LaRgfFH5KA/vmEnIdeCfjuznctxeO98ivyZj3S48Hvhu37GCrZpbPAj6VUfW/n63
kHaZiIgr2t1CRTL5jked+QasjJIlJMzk4zJEiBKPIk0kQ+uZURMAgc+MO+PoZrdg
ahtnOvZkITExDndeovF0zyCIPfaOHnUvTVNvTlfVn4Na2r95nL/57Pf3y1XE/1zY
kwlSudx04DCa9XKvYVFVYTNjQ//UxbFKXzMjCPKrsqLpMAOF09KL3I/EmbTwF/CB
1wYdQv5yOCsVkmEbuCA212M2OXg8ySy7zciiQ5NgyWvrRuU4NalyYNXkt7DKdpK9
pi6H/BiDG4O5mA8oojM8BzREOhI8tw3NLrebSP8PL4aDUZHpKhph2dSMLP7nyeiB
B51xoWjHsT1cLGQT4v7Y
=TJLB
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--


--===============6807002547337536072==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6807002547337536072==--
