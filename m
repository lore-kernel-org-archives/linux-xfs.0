Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Nov 2007 21:23:38 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA95NDcJ017668
	for <xfs@oss.sgi.com>; Thu, 8 Nov 2007 21:23:17 -0800
Message-ID: <4733EEF2.9010504@sgi.com>
Date: Fri, 09 Nov 2007 16:24:02 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] bulkstat fixups
Content-Type: multipart/mixed;
 boundary="------------080005070805090205050607"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------080005070805090205050607
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Here's a collection of fixups for bulkstat for all the remaining issues.

- sanity check for NULL user buffer in xfs_ioc_bulkstat[_compat]()

- remove the special case for XFS_IOC_FSBULKSTAT with count == 1.  This special
   case causes bulkstat to fail because the special case uses xfs_bulkstat_single()
   instead of xfs_bulkstat() and the two functions have different semantics.
   xfs_bulkstat() will return the next inode after the one supplied while skipping
   internal inodes (ie quota inodes).  xfs_bulkstate_single() will only lookup the
   inode supplied and return an error if it is an internal inode.

- in xfs_bulkstat(), need to initialise 'lastino' to the inode supplied so in cases
   were we return without examining any inodes the scan wont restart back at zero.

- sanity check for valid *ubcountp values.  Cannot sanity check for valid ubuffer
   here because some users of xfs_bulkstat() don't supply a buffer.

- checks against 'ubleft' (the space left in the user's buffer) should be against
   'statstruct_size' which is the supplied minimum object size.  The mixture of
   checks against statstruct_size and 0 was one of the reasons we were skipping
   inodes.

- if the formatter function returns BULKSTAT_RV_NOTHING and an error and the error
   is not ENOENT or EINVAL then we need to abort the scan.  ENOENT is for inodes that
   are no longer valid and we just skip them.  EINVAL is returned if we try to lookup
   an internal inode so we skip them too.  For a DMF scan if the inode and DMF
   attribute cannot fit into the space left in the user's buffer it would return
   ERANGE.  We didn't handle this error and skipped the inode.  We would continue to
   skip inodes until one fitted into the user's buffer or we completed the scan.

- put back the recalculation of agino (that got removed with the last fix) at the
   end of the while loop.  This is because the code at the start of the loop expects
   agino to be the last inode examined if it is non-zero.

- if we found some inodes but then encountered an error, return success this time
   and the error next time.  If the formatter aborted with ENOMEM we will now return
   this error but only if we couldn't read any inodes.  Previously if we encountered
   ENOMEM without reading any inodes we returned a zero count and no error which
   falsely indicated the scan was complete.

--------------080005070805090205050607
Content-Type: text/x-patch;
 name="bulkstat.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="bulkstat.diff"

--- fs/xfs/linux-2.6/xfs_ioctl.c_1.158	2007-11-09 15:51:03.000000000 +1100
+++ fs/xfs/linux-2.6/xfs_ioctl.c	2007-11-09 11:57:50.000000000 +1100
@@ -1024,24 +1024,20 @@ xfs_ioc_bulkstat(
 	if ((count = bulkreq.icount) <= 0)
 		return -XFS_ERROR(EINVAL);
 
+	if (bulkreq.ubuffer == NULL)
+		return -XFS_ERROR(EINVAL);
+
 	if (cmd == XFS_IOC_FSINUMBERS)
 		error = xfs_inumbers(mp, &inlast, &count,
 					bulkreq.ubuffer, xfs_inumbers_fmt);
 	else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE)
 		error = xfs_bulkstat_single(mp, &inlast,
 						bulkreq.ubuffer, &done);
-	else {	/* XFS_IOC_FSBULKSTAT */
-		if (count == 1 && inlast != 0) {
-			inlast++;
-			error = xfs_bulkstat_single(mp, &inlast,
-					bulkreq.ubuffer, &done);
-		} else {
-			error = xfs_bulkstat(mp, &inlast, &count,
-				(bulkstat_one_pf)xfs_bulkstat_one, NULL,
-				sizeof(xfs_bstat_t), bulkreq.ubuffer,
-				BULKSTAT_FG_QUICK, &done);
-		}
-	}
+	else	/* XFS_IOC_FSBULKSTAT */
+		error = xfs_bulkstat(mp, &inlast, &count,
+			(bulkstat_one_pf)xfs_bulkstat_one, NULL,
+			sizeof(xfs_bstat_t), bulkreq.ubuffer,
+			BULKSTAT_FG_QUICK, &done);
 
 	if (error)
 		return -error;
--- fs/xfs/linux-2.6/xfs_ioctl32.c_1.23	2007-11-02 14:27:11.000000000 +1100
+++ fs/xfs/linux-2.6/xfs_ioctl32.c	2007-11-02 14:13:27.000000000 +1100
@@ -292,6 +292,9 @@ xfs_ioc_bulkstat_compat(
 	if ((count = bulkreq.icount) <= 0)
 		return -XFS_ERROR(EINVAL);
 
+	if (bulkreq.ubuffer == NULL)
+		return -XFS_ERROR(EINVAL);
+
 	if (cmd == XFS_IOC_FSINUMBERS)
 		error = xfs_inumbers(mp, &inlast, &count,
 				bulkreq.ubuffer, xfs_inumbers_fmt_compat);
--- fs/xfs/xfs_itable.c_1.157	2007-10-25 17:22:09.000000000 +1000
+++ fs/xfs/xfs_itable.c	2007-11-01 17:22:28.000000000 +1100
@@ -353,7 +353,7 @@ xfs_bulkstat(
 	xfs_inobt_rec_incore_t	*irbp;	/* current irec buffer pointer */
 	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
 	xfs_inobt_rec_incore_t	*irbufend; /* end of good irec buffer entries */
-	xfs_ino_t		lastino=0; /* last inode number returned */
+	xfs_ino_t		lastino; /* last inode number returned */
 	int			nbcluster; /* # of blocks in a cluster */
 	int			nicluster; /* # of inodes in a cluster */
 	int			nimask;	/* mask for inode clusters */
@@ -373,6 +373,7 @@ xfs_bulkstat(
 	 * Get the last inode value, see if there's nothing to do.
 	 */
 	ino = (xfs_ino_t)*lastinop;
+	lastino = ino;
 	dip = NULL;
 	agno = XFS_INO_TO_AGNO(mp, ino);
 	agino = XFS_INO_TO_AGINO(mp, ino);
@@ -382,6 +383,9 @@ xfs_bulkstat(
 		*ubcountp = 0;
 		return 0;
 	}
+	if (!ubcountp || *ubcountp <= 0) {
+		return EINVAL;
+	}
 	ubcount = *ubcountp; /* statstruct's */
 	ubleft = ubcount * statstruct_size; /* bytes */
 	*ubcountp = ubelem = 0;
@@ -560,7 +564,7 @@ xfs_bulkstat(
 			 * Now process this chunk of inodes.
 			 */
 			for (agino = irbp->ir_startino, chunkidx = clustidx = 0;
-			     ubleft > 0 &&
+			     ubleft >= statstruct_size &&
 				irbp->ir_freecount < XFS_INODES_PER_CHUNK;
 			     chunkidx++, clustidx++, agino++) {
 				ASSERT(chunkidx < XFS_INODES_PER_CHUNK);
@@ -663,15 +667,13 @@ xfs_bulkstat(
 						ubleft, private_data,
 						bno, &ubused, dip, &fmterror);
 				if (fmterror == BULKSTAT_RV_NOTHING) {
-                                        if (error == EFAULT) {
-                                                ubleft = 0;
-                                                rval = error;
-                                                break;
-                                        }
-					else if (error == ENOMEM)
+					if (error && error != ENOENT &&
+						error != EINVAL) {
 						ubleft = 0;
-					else
-						lastino = ino;
+						rval = error;
+						break;
+					}
+					lastino = ino;
 					continue;
 				}
 				if (fmterror == BULKSTAT_RV_GIVEUP) {
@@ -694,11 +696,12 @@ xfs_bulkstat(
 		/*
 		 * Set up for the next loop iteration.
 		 */
-		if (ubleft > 0) {
+		if (ubleft >= statstruct_size) {
 			if (end_of_ag) {
 				agno++;
 				agino = 0;
-			}
+			} else
+				agino = XFS_INO_TO_AGINO(mp, lastino);
 		} else
 			break;
 	}
@@ -707,6 +710,11 @@ xfs_bulkstat(
 	 */
 	kmem_free(irbuf, irbsize);
 	*ubcountp = ubelem;
+	/*
+	 * Found some inodes, return them now and return the error next time.
+	 */
+	if (ubelem)
+		rval = 0;
 	if (agno >= mp->m_sb.sb_agcount) {
 		/*
 		 * If we ran out of filesystem, mark lastino as off

--------------080005070805090205050607--
