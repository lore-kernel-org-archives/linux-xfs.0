Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 933EDC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DA9C60F4B
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhG2Sph (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:45:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230002AbhG2Spg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jul 2021 14:45:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11C0860F5C;
        Thu, 29 Jul 2021 18:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627584333;
        bh=EKDynGcpPqyFp+UygYFpyJMD4l8p8gqk0kBEuySXPwQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LyTIShLyEqrWqfc1Yf6nNXoIJrSDu5A/NMW0pIba+ZrFsapus/emFHrSN8XGkbDvk
         inr+O8AgcG1FQPpSRmmELTAhlZ/mFJk6iz8eaOVVr1RayNks2j821e6SAexOBiUcpV
         oQC7WUgd7rgs0M7Gmd2Gy9Y4MHWjgkg5lZl8JibJHohsZwa3FwfwP5ZuLNeKMRHLW+
         YJynuEKsx/pclaKKNZZjbJMtTVwQO6tjcL+WLmByD/GLFOGP8xTX64EoJowUvfqMy1
         tfVrObeU1EkGhA7JzGnx7ffvb/fl63Lvq6utpakT5GB+nhoIJKAzm3I77j9lFtR4r/
         QyjO0bKL6ctVw==
Subject: [PATCH 18/20] xfs: scale speculative preallocation gc delay based on
 free space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 29 Jul 2021 11:45:32 -0700
Message-ID: <162758433279.332903.4586314916064996933.stgit@magnolia>
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

Now that we have the ability to scale down the lag between scheduling
and executing background cleanup work for inode inactivations, apply the
same logic to speculative preallocation gc.  In other words, be more
proactive about trimming unused speculative preallocations if space is
low.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 9b1274f25ed0..59a9526a25ff 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -426,6 +426,9 @@ xfs_gc_delay_ms(
 			return 0;
 		}
 		break;
+	case XFS_ICI_BLOCKGC_TAG:
+		default_ms = xfs_blockgc_secs * 1000;
+		break;
 	default:
 		ASSERT(0);
 		return 0;
@@ -453,7 +456,8 @@ xfs_gc_delay_ms(
  */
 static inline void
 xfs_blockgc_queue(
-	struct xfs_perag	*pag)
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
 {
 	struct xfs_mount        *mp = pag->pag_mount;
 
@@ -462,8 +466,9 @@ xfs_blockgc_queue(
 
 	rcu_read_lock();
 	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCKGC_TAG)) {
-		unsigned int	delay = xfs_blockgc_secs * 1000;
+		unsigned int	delay;
 
+		delay = xfs_gc_delay_ms(pag, ip, XFS_ICI_BLOCKGC_TAG);
 		trace_xfs_blockgc_queue(pag, delay);
 		queue_delayed_work(mp->m_gc_workqueue, &pag->pag_blockgc_work,
 				msecs_to_jiffies(delay));
@@ -519,6 +524,11 @@ xfs_gc_requeue_now(
 		default_ms = xfs_inodegc_ms;
 		opflag_bit = XFS_OPFLAG_INODEGC_RUNNING_BIT;
 		break;
+	case XFS_ICI_BLOCKGC_TAG:
+		dwork = &pag->pag_blockgc_work;
+		default_ms = xfs_blockgc_secs * 1000;
+		opflag_bit = XFS_OPFLAG_BLOCKGC_RUNNING_BIT;
+		break;
 	default:
 		return;
 	}
@@ -577,7 +587,7 @@ xfs_perag_set_inode_tag(
 		xfs_reclaim_work_queue(mp);
 		break;
 	case XFS_ICI_BLOCKGC_TAG:
-		xfs_blockgc_queue(pag);
+		xfs_blockgc_queue(pag, ip);
 		break;
 	case XFS_ICI_INODEGC_TAG:
 		xfs_inodegc_queue(pag, ip);
@@ -1815,7 +1825,7 @@ xfs_blockgc_start(
 
 	trace_xfs_blockgc_start(mp, __return_address);
 	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
-		xfs_blockgc_queue(pag);
+		xfs_blockgc_queue(pag, NULL);
 }
 
 /* Don't try to run block gc on an inode that's in any of these states. */
@@ -1906,7 +1916,7 @@ xfs_blockgc_worker(
 	if (error)
 		xfs_info(mp, "AG %u preallocation gc worker failed, err=%d",
 				pag->pag_agno, error);
-	xfs_blockgc_queue(pag);
+	xfs_blockgc_queue(pag, NULL);
 }
 
 /*

