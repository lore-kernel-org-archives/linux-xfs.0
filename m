Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n73K1r5O109498 for <xfs@oss.sgi.com>; Mon, 3 Aug 2009 15:01:54 -0500
Received: from mx.ugf.br (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5DB743A193B
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2009 13:02:42 -0700 (PDT)
Received: from mx.ugf.br (mx.ugf.br [200.222.48.3]) by cuda.sgi.com with ESMTP
	id Xroqpe9IavHdwGc9 for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2009 13:02:42 -0700 (PDT)
Subject: [PATCH 1/1] XFS: __xfs_get_blocks check pointer to the target device
From: Ramon de Carvalho Valle <ramon@risesecurity.org>
Date: Mon, 03 Aug 2009 17:03:28 -0300
Message-Id: <1249329808.7686.26.camel@logos>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3879957300465142844=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org
Cc: mszeredi@novell.com, hch@lst.de, xfs@oss.sgi.com


--===============3879957300465142844==
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VTFjpbaH1EVlaQBVvifE"


--=-VTFjpbaH1EVlaQBVvifE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

The __xfs_get_blocks function does not check if the pointer to the target
device is valid before dereferencing it.

Signed-off-by: Ramon de Carvalho Valle <ramon@risesecurity.org>
Cc: stable <stable@kernel.org>
---
 fs/xfs/linux-2.6/xfs_aops.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index aecf251..bf482d5 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -1419,7 +1419,11 @@ __xfs_get_blocks(
 	 * If this is a realtime file, data may be on a different device.
 	 * to that pointed to from the buffer_head b_bdev currently.
 	 */
-	bh_result->b_bdev =3D iomap.iomap_target->bt_bdev;
+	if (!iomap.iomap_target)
+		return -XFS_ERROR(EIO);
+
+	if (iomap.iomap_flags & IOMAP_REALTIME)
+		bh_result->b_bdev =3D iomap.iomap_target->bt_bdev;
=20
 	/*
 	 * If we previously allocated a block out beyond eof and we are now
--=20
1.5.6.3


--=-VTFjpbaH1EVlaQBVvifE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkp3QowACgkQGIS0iEuhp4PoBgCg3SOUddJ1Glh94VrZs1wDlc64
YpEAn2JaNQZZQiiSpjDuFPivkiOy+7jl
=FB/W
-----END PGP SIGNATURE-----

--=-VTFjpbaH1EVlaQBVvifE--


--===============3879957300465142844==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3879957300465142844==--
