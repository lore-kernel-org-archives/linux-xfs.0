Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5946D29DFC
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 07:40:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 305A3304077
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 05:40:45 -0700 (PDT)
Received: from mail-qe0-f44.google.com (mail-qe0-f44.google.com
	[209.85.128.44]) by cuda.sgi.com with ESMTP id Cuwb5DoxYs6LJ9uZ
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 30 Jul 2013 05:40:44 -0700 (PDT)
Received: by mail-qe0-f44.google.com with SMTP id 6so3039042qeb.3
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 05:40:43 -0700 (PDT)
From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/9] xfs: WQ_NON_REENTRANT is meaningless and going away
Date: Tue, 30 Jul 2013 08:40:26 -0400
Message-Id: <1375188028-11910-8-git-send-email-tj@kernel.org>
In-Reply-To: <1375188028-11910-1-git-send-email-tj@kernel.org>
References: <1375188028-11910-1-git-send-email-tj@kernel.org>
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
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: Tejun Heo <tj@kernel.org>, Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, shli@kernel.org, xfs@oss.sgi.com

Hello,

Please route this through the subsystem tree.  As written in the
description, this shouldn't make any functional difference and just
prepares for the removal of WQ_NON_REENTRANT which is already noop.

Thanks.

------ 8< -------
dbf2576e37 ("workqueue: make all workqueues non-reentrant") made
WQ_NON_REENTRANT no-op and the flag is going away.  Remove its usages.

This patch doesn't introduce any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: xfs@oss.sgi.com
---
 fs/xfs/xfs_super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 1d68ffc..aeef0fc 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -870,17 +870,17 @@ xfs_init_mount_workqueues(
 		goto out_destroy_unwritten;
 
 	mp->m_reclaim_workqueue = alloc_workqueue("xfs-reclaim/%s",
-			WQ_NON_REENTRANT, 0, mp->m_fsname);
+			0, 0, mp->m_fsname);
 	if (!mp->m_reclaim_workqueue)
 		goto out_destroy_cil;
 
 	mp->m_log_workqueue = alloc_workqueue("xfs-log/%s",
-			WQ_NON_REENTRANT, 0, mp->m_fsname);
+			0, 0, mp->m_fsname);
 	if (!mp->m_log_workqueue)
 		goto out_destroy_reclaim;
 
 	mp->m_eofblocks_workqueue = alloc_workqueue("xfs-eofblocks/%s",
-			WQ_NON_REENTRANT, 0, mp->m_fsname);
+			0, 0, mp->m_fsname);
 	if (!mp->m_eofblocks_workqueue)
 		goto out_destroy_log;
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
