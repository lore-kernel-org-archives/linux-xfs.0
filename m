Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9EA0C48BCF
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A73BA61284
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhFMRWj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 13 Jun 2021 13:22:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231915AbhFMRWh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 13 Jun 2021 13:22:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD7AB61107;
        Sun, 13 Jun 2021 17:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623604835;
        bh=g3CBACY5w7E1y1TkTQ46shW8kvRHHuONN/3os9dIIpA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Q+q9SGLwYjK6Vr9vc8SlkeCSYDS3detuWXrfVUETExHDwu08Rr/Dq20Me5+12+xdV
         ywRA3288JQxmfDgFN45QDyuckWEhotsCCCwPPvjfYtUbdl3QNFCY96y2ObOfAO1nXA
         RR5yh3RGpb8ajvtQnzZqUXdgMWD94pxdAj8RruM3NEByUjbjqAV/jBNbT8xbv8RAr9
         2TTMMNLA8d9eoHBQmxDZDPhVQHK89k56esxhrZAkoGUgQmG7AM4B9aq2BHhb9QkYYR
         V0vbUnQV+mA/1apUXriaWEPjeTBMG59GgxWwfgzMGgxnbzy39ZlKmBYV+cGBgGBzdv
         TarvyVEVw8X1w==
Subject: [PATCH 07/16] xfs: drop dead dquots before scheduling inode for
 inactivation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        bfoster@redhat.com
Date:   Sun, 13 Jun 2021 10:20:35 -0700
Message-ID: <162360483541.1530792.3129912273735341414.stgit@locust>
In-Reply-To: <162360479631.1530792.17147217854887531696.stgit@locust>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Since we now defer inode inactivation to a background workqueue, there
can be a considerable delay between the point in time when an inode
moves into NEED_INACTIVE state (and hence quotaoff cannot reach it) and
when xfs_inactive() actually finishes the inode.  To avoid delaying
quotaoff any more than necessary, drop dead dquots as soon as we know
that we're going to inactivate the inode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    6 ++++++
 fs/xfs/xfs_qm.c     |   28 ++++++++++++++++++++++++++++
 fs/xfs/xfs_quota.h  |    2 ++
 3 files changed, 36 insertions(+)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e094c16aa8c5..17c4cd91ea15 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -376,6 +376,12 @@ xfs_inode_mark_reclaimable(
 			xfs_check_delalloc(ip, XFS_COW_FORK);
 			ASSERT(0);
 		}
+	} else {
+		/*
+		 * Drop dquots for disabled quota types to avoid delaying
+		 * quotaoff while we wait for inactivation to occur.
+		 */
+		xfs_qm_prepare_inactive(ip);
 	}
 
 	XFS_STATS_INC(mp, vn_reclaim);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index fe341f3fd419..b193a84e47c2 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -408,6 +408,34 @@ xfs_qm_dqdetach(
 	}
 }
 
+/*
+ * If a quota type is turned off but we still have a dquot attached to the
+ * inode, detach it before tagging this inode for inactivation (or reclaim) to
+ * avoid delaying quotaoff for longer than is necessary.  Because the inode has
+ * no VFS state and has not yet been tagged for reclaim or inactivation, it is
+ * safe to drop the dquots locklessly because iget, quotaoff, blockgc, and
+ * reclaim will not touch the inode.
+ */
+void
+xfs_qm_prepare_inactive(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (!XFS_IS_UQUOTA_ON(mp)) {
+		xfs_qm_dqrele(ip->i_udquot);
+		ip->i_udquot = NULL;
+	}
+	if (!XFS_IS_GQUOTA_ON(mp)) {
+		xfs_qm_dqrele(ip->i_gdquot);
+		ip->i_gdquot = NULL;
+	}
+	if (!XFS_IS_PQUOTA_ON(mp)) {
+		xfs_qm_dqrele(ip->i_pdquot);
+		ip->i_pdquot = NULL;
+	}
+}
+
 struct xfs_qm_isolate {
 	struct list_head	buffers;
 	struct list_head	dispose;
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index d00d01302545..75d8b7bc0e25 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -101,6 +101,7 @@ extern struct xfs_dquot *xfs_qm_vop_chown(struct xfs_trans *,
 extern int xfs_qm_dqattach(struct xfs_inode *);
 extern int xfs_qm_dqattach_locked(struct xfs_inode *ip, bool doalloc);
 extern void xfs_qm_dqdetach(struct xfs_inode *);
+void xfs_qm_prepare_inactive(struct xfs_inode *ip);
 extern void xfs_qm_dqrele(struct xfs_dquot *);
 extern void xfs_qm_statvfs(struct xfs_inode *, struct kstatfs *);
 extern int xfs_qm_newmount(struct xfs_mount *, uint *, uint *);
@@ -162,6 +163,7 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
 #define xfs_qm_dqattach(ip)						(0)
 #define xfs_qm_dqattach_locked(ip, fl)					(0)
 #define xfs_qm_dqdetach(ip)
+#define xfs_qm_prepare_inactive(ip)				((void)0)
 #define xfs_qm_dqrele(d)			do { (d) = (d); } while(0)
 #define xfs_qm_statvfs(ip, s)			do { } while(0)
 #define xfs_qm_newmount(mp, a, b)					(0)

