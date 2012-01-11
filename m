Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0BL6COY189930 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 15:06:12 -0600
Message-ID: <4F0DF9C1.2060302@sgi.com>
Date: Wed, 11 Jan 2012 15:06:09 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Introduce SEEK_DATA/SEEK_HOLE to XFS V5
References: <4F06F71A.2010301@oracle.com> <20120110171855.GX6390@sgi.com>
	<4F0D21E5.7010908@oracle.com>
In-Reply-To: <4F0D21E5.7010908@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: jeff.liu@oracle.com
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com


Good work.  I know this is an important addition.

The test in the for loop of the xfs_seek_data() and xfs_seek_hole() 
routines,
are independent of each other except in order of them being called.

One could add a "continue" statement after computing the offset for the next
iteration of the loop.

This allows the addition of an error condition if no conditions are matched.


Rough patch relative to your patch of the idea.

--- fs/xfs/xfs_file.c.orig	2012-01-11 08:50:50.000000000 -0600
+++ fs/xfs/xfs_file.c	2012-01-11 09:12:47.000000000 -0600
@@ -1265,7 +1265,7 @@ xfs_seek_data(
  	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
  	len = XFS_B_TO_FSB(mp, isize);

-	for (;;) {
+	do {
  		struct xfs_bmbt_irec	map[2];
  		int			nmap = 2;
  		loff_t			seekoff;
@@ -1323,6 +1323,7 @@ xfs_seek_data(
  			}

  			fsbno = map[1].br_startoff + map[1].br_blockcount;
+			continue;
  		}

  		/*
@@ -1366,6 +1367,7 @@ xfs_seek_data(
  			}

  			fsbno = map[1].br_startoff + map[1].br_blockcount;
+			continue;
  		}

  		/* Landed in a delay allocated extent or a real data extent */
@@ -1376,11 +1378,14 @@ xfs_seek_data(
  			break;
  		}

+		error = ENXIO;
+		goto out_lock;
+	} while (XFS_FSB_TO_B(mp, fsbno) < isize);
+
  		/* Return ENXIO if beyond eof */
-		if (XFS_FSB_TO_B(mp, fsbno) > isize) {
-			error = ENXIO;
-			goto out_lock;
-		}
+	 if (XFS_FSB_TO_B(mp, fsbno) > isize) {
+		error = ENXIO;
+		goto out_lock;
  	}

  	if (offset < start)
@@ -1424,7 +1429,7 @@ xfs_seek_hole(
  	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
  	len = XFS_B_TO_FSB(mp, isize);

-	for (;;) {
+	do {
  		struct xfs_bmbt_irec	map[2];
  		int			nmap = 2;
  		loff_t			seekoff;
@@ -1507,6 +1512,7 @@ xfs_seek_hole(
  			}

  			fsbno = map[1].br_startoff + map[1].br_blockcount;
+			continue;
  		}

  		/*
@@ -1555,6 +1561,7 @@ xfs_seek_hole(
  			}

  			fsbno = map[1].br_startoff + map[1].br_blockcount;
+			continue;
  		}

  		/* Landed in a hole, its fine to return */
@@ -1564,11 +1571,14 @@ xfs_seek_hole(
  			break;
  		}

+		error = ENXIO;
+		goto out_lock;
+	} while (XFS_FSB_TO_B(mp, fsbno) < isize);
+
  		/* Return ENXIO if beyond eof */
-		if (XFS_FSB_TO_B(mp, fsbno) > isize) {
-			error = ENXIO;
-			goto out_lock;
-		}
+	if (XFS_FSB_TO_B(mp, fsbno) > isize) {
+		error = ENXIO;
+		goto out_lock;
  	}

  	if (offset < start)


--Mark Tinguely

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
