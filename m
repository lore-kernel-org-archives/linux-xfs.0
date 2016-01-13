Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6728D7F37
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 23:12:56 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 49B058F8040
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 21:12:53 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	OGVj8IlwwwNbt6HZ for <xfs@oss.sgi.com>;
	Tue, 12 Jan 2016 21:12:50 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] Revert "xfs: clear PF_NOFREEZE for xfsaild kthread"
Date: Wed, 13 Jan 2016 16:12:48 +1100
Message-Id: <1452661968-11482-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: jkosina@suse.cz

This reverts commit 24ba16bb3d499c49974669cd8429c3e4138ab102 as it
prevents machines from suspending. This regression occurs when the
xfsaild is idle on entry to suspend, and so there s no activity to
wake it from it's idle sleep and hence see that it is supposed to
freeze. Hence the freezer times out waiting for it and suspend is
cancelled.

There is no obvious fix for this short of freezing the filesystem
properly, so revert this change for now.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_trans_ail.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index aa67339..4f18fd9 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -497,7 +497,6 @@ xfsaild(
 	long		tout = 0;	/* milliseconds */
 
 	current->flags |= PF_MEMALLOC;
-	set_freezable();
 
 	while (!kthread_should_stop()) {
 		if (tout && tout <= 20)
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
