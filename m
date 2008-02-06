Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Feb 2008 16:20:05 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m160Jt4r007620
	for <xfs@oss.sgi.com>; Tue, 5 Feb 2008 16:20:00 -0800
Date: Wed, 06 Feb 2008 11:20:45 +1100
Subject: [PATCH] Fix mkfs.xfs default AG sizing
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------wK0q2RDgzG3paggCTWdLgh
MIME-Version: 1.0
Message-ID: <op.t52twvh83jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>

------------wK0q2RDgzG3paggCTWdLgh
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 7bit

Based on Eric's patches and my investigations, I have generated
the attached patch.

------------wK0q2RDgzG3paggCTWdLgh
Content-Disposition: attachment; filename=fix_mkfs.patch
Content-Type: text/x-patch; name=fix_mkfs.patch
Content-Transfer-Encoding: Quoted-Printable

--- a/xfsprogs/mkfs/xfs_mkfs.c	2008-02-06 11:17:50.000000000 +1100
+++ b/xfsprogs/mkfs/xfs_mkfs.c	2008-02-06 11:17:10.769672851 +1100
@@ -412,7 +412,9 @@
 	/*
 	 * First handle the extremes - the points at which we will
 	 * always use the maximum AG size, the points at which we
-	 * always use the minimum, and a "small-step" for 16-128Mb.
+	 * always use the minimum, and a "small-step" for 16-128MB.
+	 *
+	 * These apply regardless of storage configuration.
 	 */
 	if (dblocks >=3D TERABYTES(32, blocklog)) {
 		blocks =3D XFS_AG_MAX_BLOCKS(blocklog);
@@ -427,6 +429,8 @@
 	}
=20
 	/*
+	 * Sizes between 128MB and 32TB:
+	 *
 	 * For the remainder we choose an AG size based on the
 	 * number of data blocks available, trying to keep the
 	 * number of AGs relatively small (especially compared
@@ -435,7 +439,9 @@
 	 * count can be increased by growfs, so prefer to use
 	 * smaller counts at mkfs time.
 	 *
-	 * This scales us up smoothly between min/max AG sizes.
+	 * For a single underlying storage device less than 4TB
+	 * in size, just use 4 AGs, otherwise (for JBOD/RAIDs)
+	 * scale up smoothly between min/max AG sizes.
 	 */
=20
 	if (!multidisk) {
@@ -443,12 +449,8 @@
                         blocks =3D XFS_AG_MAX_BLOCKS(blocklog);
                         goto done;
                 }
-                count =3D 4;
-
-                goto done;
-        }
-
-	if (dblocks > GIGABYTES(512, blocklog))
+                shift =3D 2;
+        } else if (dblocks > GIGABYTES(512, blocklog))
 		shift =3D 5;
 	else if (dblocks > GIGABYTES(8, blocklog))
 		shift =3D 4;
@@ -456,14 +458,17 @@
 		shift =3D 3;
 	else
 		ASSERT(0);
-	blocks =3D dblocks >> shift;
+	/*
+	 * If dblocks is not evenly divisible by the number of
+	 * desired AGs, add 1 to "blocks" so we don't lose the
+	 * last bit of the filesystem. The same principle applies
+	 * to the AG count, so we don't lose the last AG!
+	 */
+	blocks =3D (dblocks >> shift) + ((dblocks & xfs_mask32lo(shift)) !=3D 0);
=20
 done:
-	ASSERT (count || blocks);
 	if (!count)
 		count =3D dblocks / blocks + (dblocks % blocks !=3D 0);
-	if (!blocks)
-		blocks =3D dblocks / count;
=20
 	*agsize =3D blocks;
 	*agcount =3D count;
@@ -1391,7 +1396,7 @@
=20
 	sectoralign =3D 0;
 	xlv_dsunit =3D xlv_dswidth =3D 0;
-	if (!nodsflag && !xi.disfile)
+	if (!xi.disfile)
 		get_subvol_stripe_wrapper(dfile, SVTYPE_DATA,
 				&xlv_dsunit, &xlv_dswidth, &sectoralign);
 	if (sectoralign) {
@@ -1797,12 +1802,9 @@
=20
 	} else if (daflag)	/* User-specified AG count */
 		agsize =3D dblocks / agcount + (dblocks % agcount !=3D 0);
-	else {
-		get_subvol_stripe_wrapper(dfile, SVTYPE_DATA,
-					  &xlv_dsunit, &xlv_dswidth, &sectoralign),
-			calc_default_ag_geometry(blocklog, dblocks, xlv_dsunit | xlv_dswidth,
-						 &agsize, &agcount);
-	}
+	else
+		calc_default_ag_geometry(blocklog, dblocks,
+				xlv_dsunit | xlv_dswidth, &agsize, &agcount);
=20
 	/*
 	 * If the last AG is too small, reduce the filesystem size
@@ -1817,24 +1819,28 @@
=20
 	validate_ag_geometry(blocklog, dblocks, agsize, agcount);
=20
-	if (!nodsflag && dsunit) {
-		if (xlv_dsunit && xlv_dsunit !=3D dsunit) {
-			fprintf(stderr,
-				_("%s: Specified data stripe unit %d is not "
-				"the same as the volume stripe unit %d\n"),
-				progname, dsunit, xlv_dsunit);
-		}
-		if (xlv_dswidth && xlv_dswidth !=3D dswidth) {
-			fprintf(stderr,
-				_("%s: Specified data stripe width %d is not "
-				"the same as the volume stripe width %d\n"),
-				progname, dswidth, xlv_dswidth);
+	if (!nodsflag) {
+		if (dsunit) {
+			if (xlv_dsunit && xlv_dsunit !=3D dsunit) {
+				fprintf(stderr,
+					_("%s: Specified data stripe unit %d "
+					"is not the same as the volume stripe "
+					"unit %d\n"),
+					progname, dsunit, xlv_dsunit);
+			}
+			if (xlv_dswidth && xlv_dswidth !=3D dswidth) {
+				fprintf(stderr,
+					_("%s: Specified data stripe width %d "
+					"is not the same as the volume stripe "
+					"width %d\n"),
+					progname, dswidth, xlv_dswidth);
+			}
+		} else {
+			dsunit =3D xlv_dsunit;
+			dswidth =3D xlv_dswidth;
+			nodsflag =3D 1;
 		}
-	} else {
-		dsunit =3D xlv_dsunit;
-		dswidth =3D xlv_dswidth;
-		nodsflag =3D 1;
-	}
+	} /* else dsunit & dswidth can't be set if nodsflag is set */
=20
 	/*
 	 * If dsunit is a multiple of fs blocksize, then check that is a

------------wK0q2RDgzG3paggCTWdLgh--
