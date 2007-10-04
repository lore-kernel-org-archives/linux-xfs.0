Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 03 Oct 2007 22:16:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l945G0Kk015585
	for <xfs@oss.sgi.com>; Wed, 3 Oct 2007 22:16:03 -0700
Message-ID: <4704780C.2020100@sgi.com>
Date: Thu, 04 Oct 2007 15:20:12 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: review: fix infinite loop in bulkstat
Content-Type: multipart/mixed;
 boundary="------------030308020602070609060809"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------030308020602070609060809
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This fix prevents bulkstat from spinning in an infinite loop.

Here 'agino' increments through the inodes in an allocation group.
At the end of the innermost 'for' loop it will hold the value of the
next inode to look at (ie the first inode in the next cluster/chunk).
Assigning 'lastino' to 'agino' resets it to the last inode in the
last inode cluster we just looked at.  This causes us to look up
the very same cluster and examine all the inodes all over again,
and again, and again...

We also want to set 'lastino' for the cases when we're not interested
in the inode so that the next call to bulkstat wont re-examine the
same uninteresting inodes.

--------------030308020602070609060809
Content-Type: text/x-patch;
 name="bulkstat.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="bulkstat.diff"

--- fs/xfs/xfs_itable.c_1.155	2007-10-03 13:05:22.000000000 +1000
+++ fs/xfs/xfs_itable.c	2007-10-04 12:16:46.000000000 +1000
@@ -622,8 +622,10 @@ xfs_bulkstat(
 				/*
 				 * Skip if this inode is free.
 				 */
-				if (XFS_INOBT_MASK(chunkidx) & irbp->ir_free)
+				if (XFS_INOBT_MASK(chunkidx) & irbp->ir_free) {
+					lastino = ino;
 					continue;
+				}
 				/*
 				 * Count used inodes as free so we can tell
 				 * when the chunk is used up.
@@ -632,8 +634,10 @@ xfs_bulkstat(
 				ino = XFS_AGINO_TO_INO(mp, agno, agino);
 				bno = XFS_AGB_TO_DADDR(mp, agno, agbno);
 				if (!xfs_bulkstat_use_dinode(mp, flags, bp,
-							     clustidx, &dip))
+							     clustidx, &dip)) {
+					lastino = ino;
 					continue;
+				}
 				/*
 				 * If we need to do an iget, cannot hold bp.
 				 * Drop it, until starting the next cluster.
@@ -694,8 +698,7 @@ xfs_bulkstat(
 			if (end_of_ag) {
 				agno++;
 				agino = 0;
-			} else
-				agino = XFS_INO_TO_AGINO(mp, lastino);
+			}
 		} else
 			break;
 	}

--------------030308020602070609060809--
