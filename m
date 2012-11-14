Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAEIoRVk156756 for <xfs@oss.sgi.com>; Wed, 14 Nov 2012 12:50:27 -0600
Message-ID: <50A3E86A.2060402@sgi.com>
Date: Wed, 14 Nov 2012 12:52:26 -0600
From: Andrew Dahl <adahl@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02.5/32] xfs: remove xfs_tosspages
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-3-git-send-email-david@fromorbit.com>
	<20121114064247.GC1710@dastard> <50A3E807.5010403@sgi.com>
In-Reply-To: <50A3E807.5010403@sgi.com>
Content-Type: multipart/mixed; boundary="------------090105000206000902040309"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--------------090105000206000902040309
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit



--------------090105000206000902040309
Content-Type: text/plain; charset="UTF-8"; name="xfs_zero_condition_reverse"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="xfs_zero_condition_reverse"

Reversing the check on XFS_IOC_ZERO_RANGE.

Range should be zeroed if the start is less than or equal to the end.

Signed-off-by: Andrew Dahl <adahl@sgi.com>

---

Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c
+++ xfs/fs/xfs/xfs_vnodeops.c
@@ -2188,7 +2188,7 @@ xfs_change_file_space(
 	case XFS_IOC_ZERO_RANGE:
 		prealloc_type |= XFS_BMAPI_CONVERT;
 		end = round_down(startoffset + bf->l_len, PAGE_SIZE) - 1;
-		if (startoffset > end)
+		if (startoffset <= end)
 			truncate_pagecache_range(VFS_I(ip), startoffset, end);
 		/* FALLTHRU */
 	case XFS_IOC_RESVSP:


--------------090105000206000902040309
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------090105000206000902040309--
