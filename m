Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Feb 2007 18:00:21 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1L20Cm7014680
	for <xfs@oss.sgi.com>; Tue, 20 Feb 2007 18:00:15 -0800
Message-Id: <200702210200.NAA15545@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: [PATCH] make sure xfs_repair doesn't restore corrupted primary superblock
Date: Wed, 21 Feb 2007 13:05:22 +1100
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_013C_01C755B8.F2097D00"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: xfs-dev@sgi.com

This is a multi-part message in MIME format.

------=_NextPart_000_013C_01C755B8.F2097D00
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Phase 2 in xfs_repair fixes corrupted superblock fields, but in phase 5, the
originally read primary superblock before the phase 2 fix is written to disk
with updated counters. The patch in scan.c makes sure the mount point
superblock copy is updated if the primary superblock is modified.

Included is some fixes to libxfs when IO_DEBUG is enabled.

------=_NextPart_000_013C_01C755B8.F2097D00
Content-Type: application/octet-stream;
	name="update_mp_superblock.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="update_mp_superblock.diff"


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/libxfs/rdwr.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/libxfs/rdwr.c	2007-02-21 12:57:29.000000000 +1100
+++ b/xfsprogs/libxfs/rdwr.c	2007-02-21 11:55:46.529075152 +1100
@@ -305,8 +305,9 @@ libxfs_getbuf(dev_t device, xfs_daddr_t=20
=20
 	if (cache_node_get(libxfs_bcache, &key, (struct cache_node **)&bp)) {
 #ifdef IO_DEBUG
-		fprintf(stderr, "%s: allocated buffer, key=3D%llu(%llu), %p\n",
-			__FUNCTION__, BBTOB(len), LIBXFS_BBTOOFF64(blkno), blkno, buf);
+		fprintf(stderr, "%s: allocated %ubytes buffer, key=3D%llu(%llu), %p\n",
+			__FUNCTION__, BBTOB(len),
+			(long long)LIBXFS_BBTOOFF64(blkno), (long long)blkno, bp);
 #endif
 		libxfs_initbuf(bp, device, blkno, bytes);
 	}
@@ -354,7 +355,7 @@ libxfs_readbufr(dev_t dev, xfs_daddr_t b
 	}
 #ifdef IO_DEBUG
 	fprintf(stderr, "readbufr read %ubytes, blkno=3D%llu(%llu), %p\n",
-		bytes, LIBXFS_BBTOOFF64(blkno), blkno, bp);
+		bytes, (long long)LIBXFS_BBTOOFF64(blkno), (long long)blkno, bp);
 #endif
 	if (bp->b_dev =3D=3D dev &&
 	    bp->b_blkno =3D=3D blkno &&
@@ -403,7 +404,8 @@ libxfs_writebufr(xfs_buf_t *bp)
 	}
 #ifdef IO_DEBUG
 	fprintf(stderr, "writebufr wrote %ubytes, blkno=3D%llu(%llu), %p\n",
-		bp->b_bcount, LIBXFS_BBTOOFF64(bp->b_blkno), bp->b_blkno, bp);
+		bp->b_bcount, (long long)LIBXFS_BBTOOFF64(bp->b_blkno),
+		(long long)bp->b_blkno, bp);
 #endif
 	bp->b_flags |=3D LIBXFS_B_UPTODATE;
 	bp->b_flags &=3D ~(LIBXFS_B_DIRTY | LIBXFS_B_EXIT);
@@ -432,7 +434,7 @@ libxfs_iomove(xfs_buf_t *bp, uint boff,=20
 	if (boff + len > bp->b_bcount) {
 		fprintf(stderr, "Badness, iomove out of range!\n"
 			"bp=3D(bno %llu, bytes %u) range=3D(boff %u, bytes %u)\n",
-			bp->b_blkno, bp->b_bcount, boff, len);
+			(long long)bp->b_blkno, bp->b_bcount, boff, len);
 		abort();
 	}
 #endif
@@ -464,7 +466,7 @@ libxfs_bcache_purge(void)
 	cache_purge(libxfs_bcache);
 }
=20
-void=20
+void
 libxfs_bcache_flush(void)
 {
 	cache_flush(libxfs_bcache);

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/repair/scan.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/repair/scan.c	2007-02-21 12:57:29.000000000 +1100
+++ b/xfsprogs/repair/scan.c	2007-02-21 12:57:26.280306519 +1100
@@ -431,7 +431,7 @@ _("out-of-order bmap key (file offset) i
 	}
=20
 	/*
-	 * If we're the last node at our level, check that the last child=20
+	 * If we're the last node at our level, check that the last child
 	 * block's forward sibling pointer is NULL.
 	 */
 	if (check_dups =3D=3D 0 &&
@@ -1295,6 +1295,8 @@ scan_ag(
 	ASSERT(sb_dirty =3D=3D 0 || (sb_dirty && !no_modify));
=20
 	if (sb_dirty && !no_modify) {
+		if (agno =3D=3D 0)
+			memcpy(&mp->m_sb, sb, sizeof(xfs_sb_t));
 		libxfs_xlate_sb(XFS_BUF_PTR(sbbuf), sb, -1, XFS_SB_ALL_BITS);
 		libxfs_writebuf(sbbuf, 0);
 	} else

------=_NextPart_000_013C_01C755B8.F2097D00--
