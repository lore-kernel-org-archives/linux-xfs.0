Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 728727F3F
	for <xfs@oss.sgi.com>; Tue,  7 Jan 2014 02:48:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 60307304081
	for <xfs@oss.sgi.com>; Tue,  7 Jan 2014 00:48:33 -0800 (PST)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id zlt9J5Hf7NMUh6Cu for
	<xfs@oss.sgi.com>; Tue, 07 Jan 2014 00:48:27 -0800 (PST)
Subject: [PATCH 2/3] xfs: Calling destroy_work_on_stack() to pair with
	INIT_WORK_ONSTACK()
From: Chuansheng Liu <chuansheng.liu@intel.com>
In-Reply-To: <1389084605.3650.66.camel@cliu38-desktop-build>
References: <1389084605.3650.66.camel@cliu38-desktop-build>
Date: Tue, 07 Jan 2014 16:53:34 +0800
Message-ID: <1389084814.3650.70.camel@cliu38-desktop-build>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: dchinner@fromorbit.com, bpm@sgi.com
Cc: chuansheng.liu@intel.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com


In case CONFIG_DEBUG_OBJECTS_WORK is defined, it is needed to
call destroy_work_on_stack() which frees the debug object to pair
with INIT_WORK_ONSTACK().

Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
---
 fs/xfs/xfs_bmap_util.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 1394106..82e0dab 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -287,6 +287,7 @@ xfs_bmapi_allocate(
 	INIT_WORK_ONSTACK(&args->work, xfs_bmapi_allocate_worker);
 	queue_work(xfs_alloc_wq, &args->work);
 	wait_for_completion(&done);
+	destroy_work_on_stack(&args->work);
 	return args->result;
 }
 
-- 
1.7.9.5



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
