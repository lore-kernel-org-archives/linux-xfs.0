Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 Feb 2007 23:53:09 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1K7r2m7002259
	for <xfs@oss.sgi.com>; Mon, 19 Feb 2007 23:53:04 -0800
Message-Id: <200702200753.SAA18328@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: [PATCH] fix bad quota inodes in the superblock causing xfs_repair to crash
Date: Tue, 20 Feb 2007 18:59:12 +1100
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_00E7_01C75521.35B7D3F0"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: xfs-dev@corp.sgi.com

This is a multi-part message in MIME format.

------=_NextPart_000_00E7_01C75521.35B7D3F0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Thanks to Eric for generating bad images with fsfuzzer, bad quota inode
values in the superblock caused xfs_repair to segfault. The patch checks the
validity of the inodes before doing an internal lookup which assumes the
numbers are valid before being called.


------=_NextPart_000_00E7_01C75521.35B7D3F0
Content-Type: application/octet-stream;
	name="bad_quota_ino_crash.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="bad_quota_ino_crash.diff"

--- a/xfsprogs/repair/phase4.c	2007-02-20 18:50:18.000000000 +1100
+++ b/xfsprogs/repair/phase4.c	2007-02-20 18:42:00.764536317 +1100
@@ -1059,8 +1059,12 @@ quotino_check(xfs_mount_t *mp)
 	ino_tree_node_t *irec;
=20
 	if (mp->m_sb.sb_uquotino !=3D NULLFSINO && mp->m_sb.sb_uquotino !=3D 0)  {
-		irec =3D find_inode_rec(XFS_INO_TO_AGNO(mp, mp->m_sb.sb_uquotino),
-			XFS_INO_TO_AGINO(mp, mp->m_sb.sb_uquotino));
+		if (verify_inum(mp, mp->m_sb.sb_uquotino))
+			irec =3D NULL;
+		else
+			irec =3D find_inode_rec(
+				XFS_INO_TO_AGNO(mp, mp->m_sb.sb_uquotino),
+				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_uquotino));
=20
 		if (irec =3D=3D NULL || is_inode_free(irec,
 				mp->m_sb.sb_uquotino - irec->ino_startnum))  {
@@ -1071,8 +1075,12 @@ quotino_check(xfs_mount_t *mp)
 	}
=20
 	if (mp->m_sb.sb_gquotino !=3D NULLFSINO && mp->m_sb.sb_gquotino !=3D 0)  {
-		irec =3D find_inode_rec(XFS_INO_TO_AGNO(mp, mp->m_sb.sb_gquotino),
-			XFS_INO_TO_AGINO(mp, mp->m_sb.sb_gquotino));
+		if (verify_inum(mp, mp->m_sb.sb_gquotino))
+			irec =3D NULL;
+		else
+			irec =3D find_inode_rec(
+				XFS_INO_TO_AGNO(mp, mp->m_sb.sb_gquotino),
+				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_gquotino));
=20
 		if (irec =3D=3D NULL || is_inode_free(irec,
 				mp->m_sb.sb_gquotino - irec->ino_startnum))  {
@@ -1322,7 +1330,7 @@ phase4(xfs_mount_t *mp)
 		/*
 		 * now reset the bitmap for all ags
 		 */
-		bzero(ba_bmap[i],=20
+		bzero(ba_bmap[i],
 		    roundup((mp->m_sb.sb_agblocks+(NBBY/XR_BB)-1)/(NBBY/XR_BB),
 						sizeof(__uint64_t)));
 		for (j =3D 0; j < ag_hdr_block; j++)

------=_NextPart_000_00E7_01C75521.35B7D3F0--
