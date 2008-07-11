Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 22:37:36 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6B5bNag029246
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 22:37:24 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: [PATCH] hack to test create + ea
Date: Fri, 11 Jul 2008 15:38:15 +1000
Message-Id: <1215754695-6958-2-git-send-email-xaiki@sgi.com>
In-Reply-To: <1215754695-6958-1-git-send-email-xaiki@sgi.com>
References: <1215675545-2707-5-git-send-email-xaiki@sgi.com>
 <1215754695-6958-1-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Niv Sardi <xaiki@sgi.com>

---
 fs/xfs/xfs_vnodeops.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index e475e37..48df96b 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1789,6 +1789,9 @@ xfs_create(
 	 */
 	XFS_QM_DQVOPCREATE(mp, tp, ip, udqp, gdqp);
 
+	/* hack to test create + ea */
+	xfs_attr_set_int_trans(&tp, ip, name, "TEST", strlen("TEST"), ATTR_ROOT);
+
 	/*
 	 * xfs_trans_commit normally decrements the vnode ref count
 	 * when it unlocks the inode. Since we want to return the
-- 
1.5.6.2
