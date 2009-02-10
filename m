Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1A1NeMF019069 for <xfs@oss.sgi.com>; Mon, 9 Feb 2009 19:23:41 -0600
Received: from [134.14.52.238] (unknown [134.14.52.238])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 47C558F80DE
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2009 17:23:00 -0800 (PST)
Message-ID: <4990D7EA.7020902@sgi.com>
Date: Tue, 10 Feb 2009 12:27:06 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] Check if AIL has been started before stopping it
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

A failure during mount can result in shutting down the AIL when
it may not have been started up yet.

Index: xfs-patch/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs-patch.orig/fs/xfs/linux-2.6/xfs_super.c
+++ xfs-patch/fs/xfs/linux-2.6/xfs_super.c
@@ -913,7 +913,8 @@ void
  xfsaild_stop(
  	struct xfs_ail	*ailp)
  {
-	kthread_stop(ailp->xa_task);
+	if (ailp->xa_task)
+		kthread_stop(ailp->xa_task);
  }


Index: xfs-patch/fs/xfs/xfs_trans_ail.c
===================================================================
--- xfs-patch.orig/fs/xfs/xfs_trans_ail.c
+++ xfs-patch/fs/xfs/xfs_trans_ail.c
@@ -598,8 +598,10 @@ xfs_trans_ail_destroy(
  {
  	struct xfs_ail	*ailp = mp->m_ail;

-	xfsaild_stop(ailp);
-	kmem_free(ailp);
+	if (ailp) {
+		xfsaild_stop(ailp);
+		kmem_free(ailp);
+	}
  }

  /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
