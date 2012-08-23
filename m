Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N55Ahf136063 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:05:10 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	plmJ0MfdDwCnlStW for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:05:55 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pbp-0003K7-Bu
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:33 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pbp-0003j7-95
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 093/102] xfs: fix debug_object WARN at xfs_alloc_vextent()
Date: Thu, 23 Aug 2012 15:02:51 +1000
Message-Id: <1345698180-13612-94-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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

From: Jeff Liu <jeff.liu@oracle.com>

Upstream commit: 3b876c8f2a361ceeed3fed894980c69066f903a0

Fengguang reports:

[  780.529603] XFS (vdd): Ending clean mount
[  781.454590] ODEBUG: object is on stack, but not annotated
[  781.455433] ------------[ cut here ]------------
[  781.455433] WARNING: at /c/kernel-tests/sound/lib/debugobjects.c:301 __debug_object_init+0x173/0x1f1()
[  781.455433] Hardware name: Bochs
[  781.455433] Modules linked in:
[  781.455433] Pid: 26910, comm: kworker/0:2 Not tainted 3.4.0+ #51
[  781.455433] Call Trace:
[  781.455433]  [<ffffffff8106bc84>] warn_slowpath_common+0x83/0x9b
[  781.455433]  [<ffffffff8106bcb6>] warn_slowpath_null+0x1a/0x1c
[  781.455433]  [<ffffffff814919a5>] __debug_object_init+0x173/0x1f1
[  781.455433]  [<ffffffff81491c65>] debug_object_init+0x14/0x16
[  781.455433]  [<ffffffff8108842a>] __init_work+0x20/0x22
[  781.455433]  [<ffffffff8134ea56>] xfs_alloc_vextent+0x6c/0xd5

Use INIT_WORK_ONSTACK in xfs_alloc_vextent instead of INIT_WORK.

Reported-by: Wu Fengguang <wfg@linux.intel.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index dfa9454..726418e 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2448,7 +2448,7 @@ xfs_alloc_vextent(
 	DECLARE_COMPLETION_ONSTACK(done);
 
 	args->done = &done;
-	INIT_WORK(&args->work, xfs_alloc_vextent_worker);
+	INIT_WORK_ONSTACK(&args->work, xfs_alloc_vextent_worker);
 	queue_work(xfs_alloc_wq, &args->work);
 	wait_for_completion(&done);
 	return args->result;
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
