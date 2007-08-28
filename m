Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Aug 2007 14:10:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7SLAi4p030052
	for <xfs@oss.sgi.com>; Tue, 28 Aug 2007 14:10:45 -0700
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l7SLAiLi002571
	for <xfs@oss.sgi.com>; Tue, 28 Aug 2007 17:10:44 -0400
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l7SLAiIm012516
	for <xfs@oss.sgi.com>; Tue, 28 Aug 2007 17:10:44 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id l7SLAiS9010028
	for <xfs@oss.sgi.com>; Tue, 28 Aug 2007 17:10:44 -0400
Message-ID: <46D48F54.8080200@sandeen.net>
Date: Tue, 28 Aug 2007 16:10:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] fix up XFS_ERROR() usage in xfs_lrw.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs mailing list <xfs@oss.sgi.com>

Fix up a couple of XFS_ERROR callers who send a negative errno
rather than negating the macro itself, at odds with all other
callers (if xfs_etrap contained EINVAL this would not be caught)

(hm, should xfs_read be using generic_segment_checks?)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c
@@ -210,7 +210,7 @@ xfs_read(
 		 */
 		size += iv->iov_len;
 		if (unlikely((ssize_t)(size|iv->iov_len) < 0))
-			return XFS_ERROR(-EINVAL);
+			return -XFS_ERROR(EINVAL);
 	}
 	/* END copy & waste from filemap.c */
 
@@ -740,7 +740,7 @@ start:
 
 		if ((pos & target->bt_smask) || (count & target->bt_smask)) {
 			xfs_iunlock(xip, XFS_ILOCK_EXCL|iolock);
-			return XFS_ERROR(-EINVAL);
+			return -XFS_ERROR(EINVAL);
 		}
 
 		if (!need_i_mutex && (VN_CACHED(vp) || pos > xip->i_size)) {
