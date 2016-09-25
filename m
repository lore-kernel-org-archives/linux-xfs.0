Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D21D77CA0
	for <xfs@oss.sgi.com>; Sun, 25 Sep 2016 14:20:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A39048F8040
	for <xfs@oss.sgi.com>; Sun, 25 Sep 2016 12:20:14 -0700 (PDT)
Received: from mail-pf0-f195.google.com (mail-pf0-f195.google.com
	[209.85.192.195]) by cuda.sgi.com with ESMTP id
	NvIeOFzBqpyvdSsC (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 25 Sep 2016 12:20:12 -0700 (PDT)
Received: by mail-pf0-f195.google.com with SMTP id q2so8019580pfj.0
	for <xfs@oss.sgi.com>; Sun, 25 Sep 2016 12:20:12 -0700 (PDT)
Date: Mon, 26 Sep 2016 00:50:06 +0530
From: Sudip Midya <midya.sudip@gmail.com>
Subject: [PATCH] mm: remove unnecessary rcu_lock/unlock around
	radix_tree_tagged lockless function. The function queue_delayed_work is
	already protected with interrupts disabled, hence no need to add
	rcu_lock/unlock.
Message-ID: <20160925192005.GA6517@sudip-Dell-System-Vostro-3450>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com, david@fromorbit.com, hch@infradead.org

Signed-off-by: Sudip Midya <midya.sudip@gmail.com>
---
 fs/xfs/xfs_icache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index fb39a66..887c868 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -153,12 +153,10 @@ xfs_reclaim_work_queue(
 	struct xfs_mount        *mp)
 {
 
-	rcu_read_lock();
 	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG)) {
 		queue_delayed_work(mp->m_reclaim_workqueue, &mp->m_reclaim_work,
 			msecs_to_jiffies(xfs_syncd_centisecs / 6 * 10));
 	}
-	rcu_read_unlock();
 }
 
 /*
-- 
1.9.1


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
