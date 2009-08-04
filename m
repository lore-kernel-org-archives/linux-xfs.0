Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n74InxGp187138 for <xfs@oss.sgi.com>; Tue, 4 Aug 2009 13:49:59 -0500
Received: from mx.ugf.br (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DD16AEE758
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2009 12:00:11 -0700 (PDT)
Received: from mx.ugf.br (mx.ugf.br [200.222.48.3]) by cuda.sgi.com with ESMTP
	id HHZfpmatcyWh6Sg7 for <xfs@oss.sgi.com>;
	Tue, 04 Aug 2009 12:00:11 -0700 (PDT)
Subject: [PATCH 1/1] XFS: xfs_iformat realtime device target pointer check
From: Ramon de Carvalho Valle <ramon@risesecurity.org>
In-Reply-To: <4A786110.8090404@sandeen.net>
References: <1249329808.7686.26.camel@logos>
	<20090803214929.GB3167@infradead.org> <1249351241.7513.18.camel@logos>
	<4A786110.8090404@sandeen.net>
Date: Tue, 04 Aug 2009 15:51:38 -0300
Message-Id: <1249411898.7576.19.camel@logos>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7907631473442969397=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, mszeredi@novell.com, hch@lst.de, xfs@oss.sgi.com


--===============7907631473442969397==
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2wK6llDeVaSPI7mttvrQ"


--=-2wK6llDeVaSPI7mttvrQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

The xfs_iformat function does not check if the realtime device target point=
er
is valid when the XFS_DIFLAG_REALTIME flag is set on the ondisk inode
structure.

Signed-off-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Ramon de Carvalho Valle <ramon@risesecurity.org>
Cc: stable <stable@kernel.org>
---
 fs/xfs/xfs_inode.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1f22d65..37d3ee5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -343,13 +343,24 @@ xfs_iformat(
 		return XFS_ERROR(EFSCORRUPTED);
 	}
=20
+	if (unlikely((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) &&
+			!ip->i_mount->m_rtdev_targp)) {
+		xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
+			"corrupt dinode %Lu, flags =3D 0x%x.",
+			(unsigned long long)ip->i_ino,
+			ip->i_d.di_flags);
+		XFS_CORRUPTION_ERROR("xfs_iformat(3)", XFS_ERRLEVEL_LOW,
+				     ip->i_mount, dip);
+		return XFS_ERROR(EFSCORRUPTED);
+	}
+
 	switch (ip->i_d.di_mode & S_IFMT) {
 	case S_IFIFO:
 	case S_IFCHR:
 	case S_IFBLK:
 	case S_IFSOCK:
 		if (unlikely(dip->di_format !=3D XFS_DINODE_FMT_DEV)) {
-			XFS_CORRUPTION_ERROR("xfs_iformat(3)", XFS_ERRLEVEL_LOW,
+			XFS_CORRUPTION_ERROR("xfs_iformat(4)", XFS_ERRLEVEL_LOW,
 					      ip->i_mount, dip);
 			return XFS_ERROR(EFSCORRUPTED);
 		}
@@ -371,7 +382,7 @@ xfs_iformat(
 					"corrupt inode %Lu "
 					"(local format for regular file).",
 					(unsigned long long) ip->i_ino);
-				XFS_CORRUPTION_ERROR("xfs_iformat(4)",
+				XFS_CORRUPTION_ERROR("xfs_iformat(5)",
 						     XFS_ERRLEVEL_LOW,
 						     ip->i_mount, dip);
 				return XFS_ERROR(EFSCORRUPTED);
@@ -384,7 +395,7 @@ xfs_iformat(
 					"(bad size %Ld for local inode).",
 					(unsigned long long) ip->i_ino,
 					(long long) di_size);
-				XFS_CORRUPTION_ERROR("xfs_iformat(5)",
+				XFS_CORRUPTION_ERROR("xfs_iformat(6)",
 						     XFS_ERRLEVEL_LOW,
 						     ip->i_mount, dip);
 				return XFS_ERROR(EFSCORRUPTED);
@@ -400,14 +411,14 @@ xfs_iformat(
 			error =3D xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
 			break;
 		default:
-			XFS_ERROR_REPORT("xfs_iformat(6)", XFS_ERRLEVEL_LOW,
+			XFS_ERROR_REPORT("xfs_iformat(7)", XFS_ERRLEVEL_LOW,
 					 ip->i_mount);
 			return XFS_ERROR(EFSCORRUPTED);
 		}
 		break;
=20
 	default:
-		XFS_ERROR_REPORT("xfs_iformat(7)", XFS_ERRLEVEL_LOW, ip->i_mount);
+		XFS_ERROR_REPORT("xfs_iformat(8)", XFS_ERRLEVEL_LOW, ip->i_mount);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 	if (error) {
@@ -430,7 +441,7 @@ xfs_iformat(
 				"(bad attr fork size %Ld).",
 				(unsigned long long) ip->i_ino,
 				(long long) size);
-			XFS_CORRUPTION_ERROR("xfs_iformat(8)",
+			XFS_CORRUPTION_ERROR("xfs_iformat(9)",
 					     XFS_ERRLEVEL_LOW,
 					     ip->i_mount, dip);
 			return XFS_ERROR(EFSCORRUPTED);
--=20
1.5.6.3


--=-2wK6llDeVaSPI7mttvrQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkp4gzYACgkQGIS0iEuhp4Pm1wCaAjx+9EUEotKoCh5I65XKRta1
C08AmwQQ+mC+8QIkB43Eiunbx0RGWqtw
=3U2b
-----END PGP SIGNATURE-----

--=-2wK6llDeVaSPI7mttvrQ--


--===============7907631473442969397==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7907631473442969397==--
