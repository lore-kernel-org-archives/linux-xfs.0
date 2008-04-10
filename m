Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 18:47:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A1l6pn006148
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 18:47:09 -0700
Date: Thu, 10 Apr 2008 11:47:38 +1000
From: David Chinner <dgc@sgi.com>
Subject: [patch] fix up xfsbdstrat b0rkage
Message-ID: <20080410014737.GO108924158@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Not sure how this got through testing, but it's screwed.

---

Don't error out on good I/Os in xfsbdstrat().

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/linux-2.6/xfs_lrw.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_lrw.c	2008-04-10 11:02:30.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_lrw.c	2008-04-10 11:40:54.533326543 +1000
@@ -885,8 +885,10 @@ xfsbdstrat(
 	struct xfs_buf		*bp)
 {
 	ASSERT(mp);
-	if (!XFS_FORCED_SHUTDOWN(mp))
+	if (!XFS_FORCED_SHUTDOWN(mp)) {
 		xfs_buf_iorequest(bp);
+		return;
+	}
 
 	xfs_buftrace("XFSBDSTRAT IOERROR", bp);
 	xfs_bioerror_relse(bp);
