Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 317237F3F
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 12:52:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0921D8F8039
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 10:52:28 -0700 (PDT)
Received: from b.mx.filmlight.ltd.uk (b.mx.filmlight.ltd.uk [77.107.81.251])
	by cuda.sgi.com with SMTP id mnDmnrjDVPjUH60v for
	<xfs@oss.sgi.com>; Mon, 12 May 2014 10:52:27 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: [PATCH] xfsprogs: fix compile error when libxfs header used in C++
	code
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <5370E964.50805@sandeen.net>
Date: Mon, 12 May 2014 18:52:28 +0100
Message-Id: <C6349E20-EE08-44E3-89E5-FADB707D36C1@filmlight.ltd.uk>
References: <1399908138.4857.28.camel@montana.filmlight.ltd.uk>
	<5370E964.50805@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Roger Willcocks <roger@filmlight.ltd.uk>, xfs@oss.sgi.com

xfs_ialloc.h:102: error: expected =91,=92 or =91...=92 before =91delete=92

Simple parameter rename, no changes to behaviour.

Signed-off-by: Roger Willcocks <roger@filmlight.ltd.uk>
---
 include/xfs_ialloc.h |    2 +-
 libxfs/xfs_ialloc.c  |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/xfs_ialloc.h b/include/xfs_ialloc.h
index a8f76a5..c8ac0a4 100644
--- a/include/xfs_ialloc.h
+++ b/include/xfs_ialloc.h
@@ -89,7 +89,7 @@ xfs_difree(
 	struct xfs_trans *tp,		/* transaction pointer */
 	xfs_ino_t	inode,		/* inode to be freed */
 	struct xfs_bmap_free *flist,	/* extents to free */
-	int		*delete,	/* set if inode cluster was deleted */
+	int		*deleted,	/* set if inode cluster was deleted */
 	xfs_ino_t	*first_ino);	/* first inode in deleted cluster */
 =

 /*
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index c19d84a..1dabb6c 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1080,7 +1080,7 @@ xfs_difree(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_ino_t	inode,		/* inode to be freed */
 	xfs_bmap_free_t	*flist,		/* extents to free */
-	int		*delete,	/* set if inode cluster was deleted */
+	int		*deleted,	/* set if inode cluster was deleted */
 	xfs_ino_t	*first_ino)	/* first inode in deleted cluster */
 {
 	/* REFERENCED */
@@ -1180,7 +1180,7 @@ xfs_difree(
 	if (!(mp->m_flags & XFS_MOUNT_IKEEP) &&
 	    (rec.ir_freecount =3D=3D XFS_IALLOC_INODES(mp))) {
 =

-		*delete =3D 1;
+		*deleted =3D 1;
 		*first_ino =3D XFS_AGINO_TO_INO(mp, agno, rec.ir_startino);
 =

 		/*
@@ -1208,7 +1208,7 @@ xfs_difree(
 				agno, XFS_INO_TO_AGBNO(mp,rec.ir_startino)),
 				XFS_IALLOC_BLOCKS(mp), flist, mp);
 	} else {
-		*delete =3D 0;
+		*deleted =3D 0;
 =

 		error =3D xfs_inobt_update(cur, &rec);
 		if (error) {
-- =

1.7.1


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
