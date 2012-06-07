Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q577iiiY051829 for <xfs@oss.sgi.com>; Thu, 7 Jun 2012 02:44:44 -0500
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id 1OrfKymcoDziiA4m (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 Jun 2012 00:44:43 -0700 (PDT)
Message-ID: <4FD05BE0.2010007@oracle.com>
Date: Thu, 07 Jun 2012 15:44:32 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: fix debug_object WARN at xfs_alloc_vextent()
Reply-To: jeff.liu@oracle.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Fengguang Wu <fengguang.wu@intel.com>

Hello,

There is bug report from Fengguang three days ago at:
http://www.spinics.net/lists/linux-fsdevel/msg55866.html

It looks like a XFS issue, I'd like to forward it to here with my fix at below.

Thanks,
-Jeff

Reported-by: Wu Fengguang <wfg@linux.intel.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/xfs/xfs_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 0f0df27..0be396d 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2443,7 +2443,7 @@ xfs_alloc_vextent(
 	DECLARE_COMPLETION_ONSTACK(done);
 
 	args->done = &done;
-	INIT_WORK(&args->work, xfs_alloc_vextent_worker);
+	INIT_WORK_ONSTACK(&args->work, xfs_alloc_vextent_worker);
 	queue_work(xfs_alloc_wq, &args->work);
 	wait_for_completion(&done);
 	return args->result;
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
