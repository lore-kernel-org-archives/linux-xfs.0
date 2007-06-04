Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Jun 2007 22:19:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l545JoWt004337
	for <xfs@oss.sgi.com>; Sun, 3 Jun 2007 22:19:54 -0700
Date: Mon, 4 Jun 2007 15:19:44 +1000
From: David Chinner <dgc@sgi.com>
Subject: Review: xfs_bmapi does not update previous extent pointer correctly
Message-ID: <20070604051944.GQ85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

When looping across multiple extents, xfs_bmapi will fail to
update the previous extent pointer which is used in subsequent
loops.

As a result, we can end up with the second loop in xfs_bmapi trying
to use an incorrect previous extent pointer and assert failures or
corrupted in-memory extent lists will result.

Correctly update the previous extent at the end of each loop so that
we DTRT when processing multiple map requests.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_bmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_bmap.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_bmap.c	2007-05-23 16:33:00.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_bmap.c	2007-05-25 11:53:31.949847746 +1000
@@ -5575,10 +5575,10 @@ xfs_bmapi(
 		 * Else go on to the next record.
 		 */
 		ep = xfs_iext_get_ext(ifp, ++lastx);
-		if (lastx >= nextents) {
+		prev = got;
+		if (lastx >= nextents)
 			eof = 1;
-			prev = got;
-		} else
+		else
 			xfs_bmbt_get_all(ep, &got);
 	}
 	ifp->if_lastex = lastx;
