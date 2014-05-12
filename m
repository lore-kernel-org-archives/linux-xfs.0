Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0B3D229E00
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 12:52:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 77FFFAC001
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 10:52:35 -0700 (PDT)
Received: from b.mx.filmlight.ltd.uk (b.mx.filmlight.ltd.uk [77.107.81.251])
	by cuda.sgi.com with SMTP id ri3SELeFosFrmP3Q for
	<xfs@oss.sgi.com>; Mon, 12 May 2014 10:52:33 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: [PATCH] xfs: fix compile error when libxfs header used in C++ code
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <5370E964.50805@sandeen.net>
Date: Mon, 12 May 2014 18:52:34 +0100
Message-Id: <3EEEF4AD-A192-4A5B-A81A-5FC38F5CF95F@filmlight.ltd.uk>
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

xfs_ialloc.h:102: error: expected =91,=92 or =91...=92 before =91delete'

Simple parameter rename, no changes to behaviour.

Signed-off-by: Roger Willcocks <roger@filmlight.ltd.uk>
---
 fs/xfs/xfs_ialloc.c |    6 +++---
 fs/xfs/xfs_ialloc.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 8f711db..b819263 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1109,7 +1109,7 @@ xfs_difree(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_ino_t	inode,		/* inode to be freed */
 	xfs_bmap_free_t	*flist,		/* extents to free */
-	int		*delete,	/* set if inode cluster was deleted */
+	int		*deleted,	/* set if inode cluster was deleted */
 	xfs_ino_t	*first_ino)	/* first inode in deleted cluster */
 {
 	/* REFERENCED */
@@ -1209,7 +1209,7 @@ xfs_difree(
 	if (!(mp->m_flags & XFS_MOUNT_IKEEP) &&
 	    (rec.ir_freecount =3D=3D mp->m_ialloc_inos)) {
 =

-		*delete =3D 1;
+		*deleted =3D 1;
 		*first_ino =3D XFS_AGINO_TO_INO(mp, agno, rec.ir_startino);
 =

 		/*
@@ -1237,7 +1237,7 @@ xfs_difree(
 				  XFS_AGINO_TO_AGBNO(mp, rec.ir_startino)),
 				  mp->m_ialloc_blks, flist, mp);
 	} else {
-		*delete =3D 0;
+		*deleted =3D 0;
 =

 		error =3D xfs_inobt_update(cur, &rec);
 		if (error) {
diff --git a/fs/xfs/xfs_ialloc.h b/fs/xfs/xfs_ialloc.h
index 812365d..95ad1c0 100644
--- a/fs/xfs/xfs_ialloc.h
+++ b/fs/xfs/xfs_ialloc.h
@@ -90,7 +90,7 @@ xfs_difree(
 	struct xfs_trans *tp,		/* transaction pointer */
 	xfs_ino_t	inode,		/* inode to be freed */
 	struct xfs_bmap_free *flist,	/* extents to free */
-	int		*delete,	/* set if inode cluster was deleted */
+	int		*deleted,	/* set if inode cluster was deleted */
 	xfs_ino_t	*first_ino);	/* first inode in deleted cluster */
 =

 /*
-- =

1.7.1


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
