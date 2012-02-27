Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1R0bdVl008342 for <xfs@oss.sgi.com>; Sun, 26 Feb 2012 18:37:40 -0600
Received: from mail-pw0-f53.google.com (mail-pw0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id tlHpsB4u84NuscNH
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 26 Feb 2012 16:37:38 -0800 (PST)
Received: by pbbrq13 with SMTP id rq13so1149845pbb.26
	for <xfs@oss.sgi.com>; Sun, 26 Feb 2012 16:37:37 -0800 (PST)
Date: Mon, 27 Feb 2012 06:07:33 +0530
From: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Subject: [PATCH] Printk for ENOSPC due to lack of inodes
Message-ID: <20120227003733.GA28162@Xye>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0486931327823456553=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============0486931327823456553==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

While diagnosing a MySQL crash (on a Centos 5.7 box), I noticed=20
that it had failed with ENOSPC earlier; it was rebooted after=20
that; now after reboot, even though space was there, ENOSPC was=20
showing up, I also did df -i and it showed inodes available. At=20
this point, mounting with inode64 option was tried, which fixed=20
it.=20

http://oss.sgi.com/archives/xfs/2011-03/msg00299.html helped me=20
here.

So, I have attached a patch here.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


When a ENOSPC is encountered and it is due to lack of inodes (particularly
without inode64), it is not possible to detect this (df -i doesn't help her=
e),
so adding a printk which can aid in detecting this.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
  fs/xfs/xfs_qm.c       |    3 +++
  fs/xfs/xfs_vnodeops.c |   10 ++++++++--
  2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index c872fea..fbefa87 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -987,6 +987,9 @@ xfs_qm_qino_alloc(
 =20
  	error =3D xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, 1, ip, &committed);
  	if (error) {
+		if (error =3D=3D ENOSPC)
+			xfs_err(mp, "Out of inodes: Required %d, Current %llu, Maximum %llu",
+					XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_maxicount);
  		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
  				 XFS_TRANS_ABORT);
  		return error;
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index ebdb888..7542c36 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -946,8 +946,11 @@ xfs_create(
  	error =3D xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev,
  			       prid, resblks > 0, &ip, &committed);
  	if (error) {
-		if (error =3D=3D ENOSPC)
+		if (error =3D=3D ENOSPC) {
+			xfs_err(mp, "Out of inodes: Required %d, Current %llu, Maximum %llu",
+					XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_maxicount);
  			goto out_trans_cancel;
+		}
  		goto out_trans_abort;
  	}
 =20
@@ -1610,8 +1613,11 @@ xfs_symlink(
  	error =3D xfs_dir_ialloc(&tp, dp, S_IFLNK | (mode & ~S_IFMT), 1, 0,
  			       prid, resblks > 0, &ip, NULL);
  	if (error) {
-		if (error =3D=3D ENOSPC)
+		if (error =3D=3D ENOSPC) {
+			xfs_err(mp, "Out of inodes: Required %d, Current %llu, Maximum %llu",
+					XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_maxicount);
  			goto error_return;
+		}
  		goto error1;
  	}
 =20
--=20
1.7.9.2

Regards,
--=20
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPStBNAAoJEKYW3KHXK+l3hpIIAMErmcgcTqglLhRXFRWsraBZ
/ZQC+g5BeaJr9u534ap/v/5KElSW1t3dtwdZeBKm6FJLQNjKjER+LWchlzhhdWCA
Qs5ytamXqCbfVDKZmz8OSk35D6nW3Z2B3ezqG/KnCOawXo5iIVT5HvMcd/5ooOlK
c/0Q9o3yoDoXqpUZP5Y2goNeyNg/sjKnzlZzCbeJYPHBXrj6cMaQcD5ZaNtQrwbh
bOSs7rFbfexu31dY7lZGhC41DoYD6LRrOL3O8KyWVt8YiUj1fWowKsKlBrBRdxDv
csP/04spDJnM8qWx7osf0U5hLCnbXnruG7/D+F+XNkTYtDDIXNG4WJ9hq1PgMHQ=
=jbDx
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--


--===============0486931327823456553==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0486931327823456553==--
