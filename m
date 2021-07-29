Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC73C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:44:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2E9A60F5E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhG2Sog (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:44:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229807AbhG2Sof (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jul 2021 14:44:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A22460F4B;
        Thu, 29 Jul 2021 18:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627584272;
        bh=d1PNL0m1A1eBNw7CyvgH/BCUYQbG2jCgtPuEMqH6J2I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=F1bPwbIEE7ulUT0gh/OTXHaXddLHQxZBTiJYmSlAjILK1QYhfVTVOtJIM2iB5q6PY
         q1/ubqkkaKHD/Uv4nLPy99A8UF3BDGmZux3vj/RcUkEZojI773o7sEheuZXzdrdMyD
         GvR2O16BSPbwyMBGeitNlexo4pjXtpNKamsTc7T9hWCDYI/t0WTfro976FYv6lzN1m
         Upa4C+E3owrsSrDBUc59tMtHd/7MykCfKf+qb+jiRsFzTUbteN9zMlGBIWZyGlOH32
         8U3HQ5KR94V2jgbL87G7VcbketQYUO8zTrBu3XNFiFVacwJ4ineUhQr2PqXycDyYYN
         byzKfcB+LJktw==
Subject: [PATCH 07/20] xfs: queue inodegc worker immediately when memory is
 tight
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 29 Jul 2021 11:44:32 -0700
Message-ID: <162758427220.332903.7964745098855992435.stgit@magnolia>
In-Reply-To: <162758423315.332903.16799817941903734904.stgit@magnolia>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If there is enough memory pressure that we're scheduling inodes for
inactivation from a shrinker, queue the inactivation worker immediately
to try to facilitate reclaming inodes.  This patch prepares us for
adding a configurable inodegc delay in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   34 ++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_trace.h  |    1 +
 2 files changed, 33 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index abd95f16b697..e0803544ea19 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -212,6 +212,32 @@ xfs_reclaim_work_queue(
 	rcu_read_unlock();
 }
 
+/*
+ * Compute the lag between scheduling and executing some kind of background
+ * garbage collection work.  Return value is in ms.
+ */
+static inline unsigned int
+xfs_gc_delay_ms(
+	struct xfs_mount	*mp,
+	unsigned int		tag)
+{
+	switch (tag) {
+	case XFS_ICI_INODEGC_TAG:
+		/* If we're in a shrinker, kick off the worker immediately. */
+		if (current->reclaim_state != NULL) {
+			trace_xfs_inodegc_delay_mempressure(mp,
+					__return_address);
+			return 0;
+		}
+		break;
+	default:
+		ASSERT(0);
+		return 0;
+	}
+
+	return 0;
+}
+
 /*
  * Background scanning to trim preallocated space. This is queued based on the
  * 'speculative_prealloc_lifetime' tunable (5m by default).
@@ -242,8 +268,12 @@ xfs_inodegc_queue(
 
 	rcu_read_lock();
 	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG)) {
-		trace_xfs_inodegc_queue(mp, 0);
-		queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work, 0);
+		unsigned int	delay;
+
+		delay = xfs_gc_delay_ms(mp, XFS_ICI_INODEGC_TAG);
+		trace_xfs_inodegc_queue(mp, delay);
+		queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work,
+				msecs_to_jiffies(delay));
 	}
 	rcu_read_unlock();
 }
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b4dfa7e7e700..d3f3f6a32872 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -192,6 +192,7 @@ DEFINE_FS_EVENT(xfs_inodegc_stop);
 DEFINE_FS_EVENT(xfs_inodegc_worker);
 DEFINE_FS_EVENT(xfs_inodegc_throttled);
 DEFINE_FS_EVENT(xfs_fs_sync_fs);
+DEFINE_FS_EVENT(xfs_inodegc_delay_mempressure);
 
 TRACE_EVENT(xfs_inodegc_requeue_mempressure,
 	TP_PROTO(struct xfs_mount *mp, unsigned long nr, void *caller_ip),

