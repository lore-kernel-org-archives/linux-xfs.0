Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2E3F47CA0
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 18:37:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E59BC8F819A
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 16:37:07 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	DBzTp8WdTcCwjarq for <xfs@oss.sgi.com>;
	Tue, 16 Aug 2016 16:37:05 -0700 (PDT)
Date: Wed, 17 Aug 2016 09:36:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: master branch updated to v4.8-rc2, for-next branch
	updated to d25ed4d
Message-ID: <20160816233659.GE19025@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8451182465278913913=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, linux-xfs@vger.kernel.org


--===============8451182465278913913==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IiVenqGWf+H9Y6IX"
Content-Disposition: inline


--IiVenqGWf+H9Y6IX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

I've just updated the master branch of hte XFS kernel repository to
v4.8-rc2. If you have outstanding patches, can you check they apply
to this updated branch, and if not rebase your patches and resend
them?

I've also updated with the for-next branch with the fixes I intend
to send to Linus at the end of the week. This does not include
Christoph's delayed allocation rework - that still needs more testing
before merging. Full details of the commits merged are below.

-Dave.

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

d25ed4d Merge branch 'iomap-fixes-4.8-rc3' into for-next

New Commits:

Brian Foster (1):
      [4dd3fd7] xfs: don't assert fail on non-async buffers on ioacct decre=
ment

Christoph Hellwig (6):
      [0af32fb] xfs: fix bogus space reservation in xfs_iomap_write_allocate
      [97dd8c9] iomap: remove superflous mark_page_accessed from iomap_writ=
e_actor
      [274c887] iomap: remove superflous pagefault_disable from iomap_write=
_actor
      [f20ac7a] iomap: mark ->iomap_end as optional
      [b95a212] xfs: simplify xfs_file_iomap_begin
      [1d4795e] xfs: (re-)implement FIEMAP_FLAG_XATTR

Darrick J. Wong (1):
      [f32866fd] xfs: store rmapbt block count in the AGF

Dave Chinner (4):
      [8b2180b] xfs: don't invalidate whole file on DAX read/write
      [8896b8f] iomap: fiemap should honor the FIEMAP_FLAG_SYNC flag
      [ac2dc05] iomap: prepare iomap_fiemap for attribute mappings
      [d25ed4d] Merge branch 'iomap-fixes-4.8-rc3' into for-next


Code Diffstat:

 fs/iomap.c                     | 21 ++++++++------
 fs/xfs/libxfs/xfs_alloc.c      |  1 +
 fs/xfs/libxfs/xfs_format.h     | 11 ++++++--
 fs/xfs/libxfs/xfs_rmap_btree.c |  6 ++++
 fs/xfs/xfs_buf.c               |  1 -
 fs/xfs/xfs_file.c              | 13 ++++++++-
 fs/xfs/xfs_fsops.c             |  1 +
 fs/xfs/xfs_iomap.c             | 69 ++++++++++++++++++++++++++++++++++++--=
-------
 fs/xfs/xfs_iomap.h             |  1 +
 fs/xfs/xfs_iops.c              |  9 +++++-
 fs/xfs/xfs_trace.h             |  1 -
 11 files changed, 106 insertions(+), 28 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--IiVenqGWf+H9Y6IX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXs6ObAAoJEK3oKUf0dfod7pgP/R4rSXWGpF40YH5b/c+wPtZM
pJrZRD7iHqJfCB47JHVzcNtBTxT9RdhqrzKJkOiaNt+XHwcQYhRBmvNAQ1oL7L0J
74Ktx1Dv5RQ9YNswiyu4jPGSpukoHd9s9oqN6gABgxis01ZBtFc5wrEiR2NNFjG9
xvjRETuUqkgGY+zpKES4Fr47ciycqlcYsihujPJ5SYBX+9Vap5Scx35s361DDGVE
vXFkj5xTpY9G7D+NvG6Bmi+gJjnjf/BQ9fwyVLtgKA47KbnywEBDvqr5rPWF/K4i
48MY+hkg8auugViv90RrpioMXkpX9FD1e9LG9FZDqA1ICY9kG7T7ILS/AAiNFCbl
wBLuHLVq7mA6snB87cKTsqPX5okPklcIrFajDQRYEB1fi2Kvl5MXPWvce2cxnR9F
fGPTfh1RwE+cGJluFXi6QPUPTIbSqp9tOps8tx3iLZyRsE6CdngP+G9qUXLrV+2u
ZoZOaOOlNnY6iZgxT+6mbgSilQrTSVaSksIGEvoh/Rulo7U9FoGtuJ7rWllKlXsu
YdX6mAC5Jva002wNob3i9+NZks3uD7SUjurCb3llweIxeBprTY09Nc0yfIyNU91n
D5Ewj/SdrFVk/vjsZRm4p+GAqR2S3JhYCXt9edxd29dJ0ZDeeDQQD7tH5FiZb2Fi
8W+Wks2oFgjdabAn3SVK
=TljM
-----END PGP SIGNATURE-----

--IiVenqGWf+H9Y6IX--


--===============8451182465278913913==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8451182465278913913==--
