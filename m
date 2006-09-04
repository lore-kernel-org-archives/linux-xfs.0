Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Sep 2006 17:18:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k840I3DW002413
	for <xfs@oss.sgi.com>; Sun, 3 Sep 2006 17:18:15 -0700
Date: Mon, 4 Sep 2006 10:17:11 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: review: minor cleanup in xfs_read locking
Message-ID: <20060904101711.A3331169@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: xfs@oss.sgi.com

Hi Lachlan,

Could you check this for me - it just folds the second direct I/O
conditional added in your recent deadlock fix back into the prior
branch, which is also direct I/O specific...

thanks.

-- 
Nathan


Index: xfs-linux/linux-2.6/xfs_lrw.c
===================================================================
--- xfs-linux.orig/linux-2.6/xfs_lrw.c	2006-09-04 09:59:10.955973000 +1000
+++ xfs-linux/linux-2.6/xfs_lrw.c	2006-09-04 09:59:42.205926000 +1000
@@ -270,12 +270,12 @@ xfs_read(
 		}
 	}
 
-	if (unlikely((ioflags & IO_ISDIRECT) && VN_CACHED(vp)))
-		bhv_vop_flushinval_pages(vp, ctooff(offtoct(*offset)),
-						-1, FI_REMAPF_LOCKED);
-
-	if (unlikely(ioflags & IO_ISDIRECT))
+	if (unlikely((ioflags & IO_ISDIRECT))) {
+		if (VN_CACHED(vp))
+			bhv_vop_flushinval_pages(vp, ctooff(offtoct(*offset)),
+						 -1, FI_REMAPF_LOCKED);
 		mutex_unlock(&inode->i_mutex);
+	}
 
 	xfs_rw_enter_trace(XFS_READ_ENTER, &ip->i_iocore,
 				(void *)iovp, segs, *offset, ioflags);
