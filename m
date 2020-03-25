Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF6A5C54FD2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 01:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E0032073E
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 01:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbgCYBmM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 21:42:12 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46322 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727315AbgCYBmL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 21:42:11 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A4A047EB97A
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 12:42:06 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jGv3V-0006HQ-Sk
        for linux-xfs@vger.kernel.org; Wed, 25 Mar 2020 12:42:05 +1100
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jGv3V-00036M-KG
        for linux-xfs@vger.kernel.org; Wed, 25 Mar 2020 12:42:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 8/8] xfs: factor inode lookup from xfs_ifree_cluster
Date:   Wed, 25 Mar 2020 12:42:05 +1100
Message-Id: <20200325014205.11843-9-david@fromorbit.com>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200325014205.11843-1-david@fromorbit.com>
References: <20200325014205.11843-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=v6uQa3AzV7p3N87VeX4A:9 a=ZwzrRA4ZDw6rHXVS:21 a=MFCUz6Zf14C1qaC9:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

There's lots of indent in this code which makes it a bit hard to
follow. We are also going to completely rework the inode lookup code
as part of the inode reclaim rework, so factor out the inode lookup
code from the inode cluster freeing code.

Based on prototype code from Christoph Hellwig.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 152 +++++++++++++++++++++++++--------------------
 1 file changed, 84 insertions(+), 68 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 14b922f2a6db7..5c930863ed5b8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2503,6 +2503,88 @@ xfs_iunlink_remove(
 	return error;
 }
 
+/*
+ * Look up the inode number specified and mark it stale if it is found. If it is
+ * dirty, return the inode so it can be attached to the cluster buffer so it can
+ * be processed appropriately when the cluster free transaction completes.
+ */
+static struct xfs_inode *
+xfs_ifree_get_one_inode(
+	struct xfs_perag	*pag,
+	struct xfs_inode	*free_ip,
+	int			inum)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_inode	*ip;
+
+retry:
+	rcu_read_lock();
+	ip = radix_tree_lookup(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, inum));
+
+	/* Inode not in memory, nothing to do */
+	if (!ip)
+		goto out_rcu_unlock;
+
+	/*
+	 * because this is an RCU protected lookup, we could find a recently
+	 * freed or even reallocated inode during the lookup. We need to check
+	 * under the i_flags_lock for a valid inode here. Skip it if it is not
+	 * valid, the wrong inode or stale.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	if (ip->i_ino != inum || __xfs_iflags_test(ip, XFS_ISTALE)) {
+		spin_unlock(&ip->i_flags_lock);
+		goto out_rcu_unlock;
+	}
+	spin_unlock(&ip->i_flags_lock);
+
+	/*
+	 * Don't try to lock/unlock the current inode, but we _cannot_ skip the
+	 * other inodes that we did not find in the list attached to the buffer
+	 * and are not already marked stale. If we can't lock it, back off and
+	 * retry.
+	 */
+	if (ip != free_ip) {
+		if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
+			rcu_read_unlock();
+			delay(1);
+			goto retry;
+		}
+
+		/*
+		 * Check the inode number again in case we're racing with
+		 * freeing in xfs_reclaim_inode().  See the comments in that
+		 * function for more information as to why the initial check is
+		 * not sufficient.
+		 */
+		if (ip->i_ino != inum) {
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			goto out_rcu_unlock;
+		}
+	}
+	rcu_read_unlock();
+
+	xfs_iflock(ip);
+	xfs_iflags_set(ip, XFS_ISTALE);
+
+	/*
+	 * We don't need to attach clean inodes or those only with unlogged
+	 * changes (which we throw away, anyway).
+	 */
+	if (!ip->i_itemp || xfs_inode_clean(ip)) {
+		ASSERT(ip != free_ip);
+		xfs_ifunlock(ip);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		goto out_no_inode;
+	}
+	return ip;
+
+out_rcu_unlock:
+	rcu_read_unlock();
+out_no_inode:
+	return NULL;
+}
+
 /*
  * A big issue when freeing the inode cluster is that we _cannot_ skip any
  * inodes that are in memory - they all must be marked stale and attached to
@@ -2603,77 +2685,11 @@ xfs_ifree_cluster(
 		 * even trying to lock them.
 		 */
 		for (i = 0; i < igeo->inodes_per_cluster; i++) {
-retry:
-			rcu_read_lock();
-			ip = radix_tree_lookup(&pag->pag_ici_root,
-					XFS_INO_TO_AGINO(mp, (inum + i)));
-
-			/* Inode not in memory, nothing to do */
-			if (!ip) {
-				rcu_read_unlock();
+			ip = xfs_ifree_get_one_inode(pag, free_ip, inum + i);
+			if (!ip)
 				continue;
-			}
-
-			/*
-			 * because this is an RCU protected lookup, we could
-			 * find a recently freed or even reallocated inode
-			 * during the lookup. We need to check under the
-			 * i_flags_lock for a valid inode here. Skip it if it
-			 * is not valid, the wrong inode or stale.
-			 */
-			spin_lock(&ip->i_flags_lock);
-			if (ip->i_ino != inum + i ||
-			    __xfs_iflags_test(ip, XFS_ISTALE)) {
-				spin_unlock(&ip->i_flags_lock);
-				rcu_read_unlock();
-				continue;
-			}
-			spin_unlock(&ip->i_flags_lock);
-
-			/*
-			 * Don't try to lock/unlock the current inode, but we
-			 * _cannot_ skip the other inodes that we did not find
-			 * in the list attached to the buffer and are not
-			 * already marked stale. If we can't lock it, back off
-			 * and retry.
-			 */
-			if (ip != free_ip) {
-				if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
-					rcu_read_unlock();
-					delay(1);
-					goto retry;
-				}
-
-				/*
-				 * Check the inode number again in case we're
-				 * racing with freeing in xfs_reclaim_inode().
-				 * See the comments in that function for more
-				 * information as to why the initial check is
-				 * not sufficient.
-				 */
-				if (ip->i_ino != inum + i) {
-					xfs_iunlock(ip, XFS_ILOCK_EXCL);
-					rcu_read_unlock();
-					continue;
-				}
-			}
-			rcu_read_unlock();
 
-			xfs_iflock(ip);
-			xfs_iflags_set(ip, XFS_ISTALE);
-
-			/*
-			 * we don't need to attach clean inodes or those only
-			 * with unlogged changes (which we throw away, anyway).
-			 */
 			iip = ip->i_itemp;
-			if (!iip || xfs_inode_clean(ip)) {
-				ASSERT(ip != free_ip);
-				xfs_ifunlock(ip);
-				xfs_iunlock(ip, XFS_ILOCK_EXCL);
-				continue;
-			}
-
 			iip->ili_last_fields = iip->ili_fields;
 			iip->ili_fields = 0;
 			iip->ili_fsync_fields = 0;
-- 
2.26.0.rc2

