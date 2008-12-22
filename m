Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMGiBxW006550 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 10:44:11 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D3E3177579B
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:44:10 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GVZUEPqfZhIFVdjg for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:44:10 -0800 (PST)
Message-Id: <20081222164409.990496000@bombadil.infradead.org>
References: <20081222163831.755809000@bombadil.infradead.org>
Date: Mon, 22 Dec 2008 11:38:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 15/20] fix xfsqa 189 for log and rt devices
Content-Disposition: inline; filename=xfstests-fix-189-for-log-and-rtdev
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Matthew Kent <mkent@magoazul.com>                                            


Reviewed-by: Christoph Hellwig <hch@lst.de>

--- xfs-cmds/xfstests/189.orig	2008-11-21 13:43:33.000000000 -0800
+++ xfs-cmds/xfstests/189	2008-11-21 13:42:48.000000000 -0800
@@ -188,8 +188,8 @@
 _need_to_be_root
 _require_scratch
 
-unset SCRATCH_OPTIONS
-unset MOUNT_OPTIONS
+unset SCRATCH_RTDEV
+unset SCRATCH_LOGDEV
 
 _scratch_mkfs_xfs | _filter_mkfs 2>/dev/null
 

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
