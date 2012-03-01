Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q21NUR7e205865 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 17:30:27 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id f7q9H44CqMMqPVgG for
	<xfs@oss.sgi.com>; Thu, 01 Mar 2012 15:30:26 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q21NUPvq021036
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 18:30:25 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q21NUOQh021700
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 18:30:25 -0500
Message-ID: <4F500690.2080804@redhat.com>
Date: Thu, 01 Mar 2012 17:30:24 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: pick up 4k physical sector size
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

This splits the fs topology sectorsize into logical & physical,
and gets both via blkid_get_topology.

After that there are various gyrations & warnings to handle
various combinations of specified sector, blocksize, and
what's actually found on disk.

mkfs.xfs's "sector size" gets reduced to logical if
a block size < physical sector size is specified, for
example.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 140837a..9e9f6c1 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -33,7 +33,8 @@ struct fs_topology {
 	int	dsunit;		/* stripe unit - data subvolume */
 	int	dswidth;	/* stripe width - data subvolume */
 	int	rtswidth;	/* stripe width - rt subvolume */
-	int	sectorsize;
+	int	lsectorsize;	/* logical sector size &*/
+	int	psectorsize;	/* physical sector size */
 	int	sectoralign;
 };
 
@@ -373,7 +374,8 @@ static void blkid_get_topology(
 	const char	*device,
 	int		*sunit,
 	int		*swidth,
-	int		*sectorsize,
+	int		*lsectorsize,
+	int		*psectorsize,
 	int		force_overwrite)
 {
 
@@ -408,8 +410,11 @@ static void blkid_get_topology(
 	val = blkid_topology_get_optimal_io_size(tp) >> 9;
 	if (val > 1)
 		*swidth = val;
-	val = blkid_probe_get_sectorsize(pr);
-	*sectorsize = val;
+
+	val = blkid_topology_get_logical_sector_size(tp);
+	*lsectorsize = val;
+	val = blkid_topology_get_physical_sector_size(tp);
+	*psectorsize = val;
 
 	if (blkid_topology_get_alignment_offset(tp) != 0) {
 		fprintf(stderr,
@@ -422,8 +427,8 @@ static void blkid_get_topology(
 
 			exit(EXIT_FAILURE);
 		}
-		/* force a 512b sector size if the device is misaligned */
-		*sectorsize = BBSIZE;
+		/* Do not use physical sector size if the device is misaligned */
+		*psectorsize = *lsectorsize;
 	}
 
 	blkid_free_probe(pr);
@@ -445,14 +450,14 @@ static void get_topology(
 		const char *dfile = xi->volname ? xi->volname : xi->dname;
 
 		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
-				   &ft->sectorsize, force_overwrite);
+				   &ft->lsectorsize, &ft->psectorsize,
+				   force_overwrite);
 	}
 
 	if (xi->rtname && !xi->risfile) {
 		int dummy;
-
 		blkid_get_topology(xi->rtname, &dummy, &ft->rtswidth,
-				   &dummy, force_overwrite);
+				   &dummy, &dummy, force_overwrite);
 	}
 }
 #else /* ENABLE_BLKID */
@@ -1663,9 +1668,28 @@ main(
 	} else if (!ssflag) {
 		/*
 		 * Unless specified manually on the command line use the
-		 * advertised sector size of the device.
+		 * advertised sector size of the device.  We use the physical
+		 * sector size unless the requested block size is smaller
+		 * than that, then we can use logical, but warn about the
+		 * inefficiency.
 		 */
-		sectorsize = ft.sectorsize ? ft.sectorsize : XFS_MIN_SECTORSIZE;
+
+		/* Older kernels may not have physical/logical distinction */
+		if (!ft.psectorsize)
+			ft.psectorsize = ft.lsectorsize;
+
+		sectorsize = ft.psectorsize ? ft.psectorsize :
+					      XFS_MIN_SECTORSIZE;
+
+		if ((blocksize < sectorsize) && (blocksize >= ft.lsectorsize)) {
+			fprintf(stderr, _("specified blocksize %d is less than "
+					  "device physical sector size %d\n"),
+					  blocksize, ft.psectorsize);
+			fprintf(stderr, _("switching to logical sector "
+					  "size %d\n"), ft.lsectorsize);
+			sectorsize = ft.lsectorsize ? ft.lsectorsize :
+						      XFS_MIN_SECTORSIZE;
+		}
 	}
 
 	if (ft.sectoralign || !ssflag) {
@@ -1678,12 +1702,17 @@ main(
 
 	if (sectorsize < XFS_MIN_SECTORSIZE ||
 	    sectorsize > XFS_MAX_SECTORSIZE || sectorsize > blocksize) {
-		fprintf(stderr, _("illegal sector size %d\n"), sectorsize);
+		if (ssflag)
+			fprintf(stderr, _("illegal sector size %d\n"), sectorsize);
+		else
+			fprintf(stderr, _("block size %d cannot be smaller than "
+					  "logical sector size %d\n"),
+				blocksize, ft.lsectorsize);
 		usage();
 	}
-	if (sectorsize < ft.sectorsize) {
+	if (sectorsize < ft.lsectorsize) {
 		fprintf(stderr, _("illegal sector size %d; hw sector is %d\n"),
-			sectorsize, ft.sectorsize);
+			sectorsize, ft.lsectorsize);
 		usage();
 	}
 	if (lsectorsize < XFS_MIN_SECTORSIZE ||

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
