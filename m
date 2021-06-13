Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0755DC48BCF
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E54B261284
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Jun 2021 17:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbhFMRXV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 13 Jun 2021 13:23:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232014AbhFMRXV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 13 Jun 2021 13:23:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7D1761078;
        Sun, 13 Jun 2021 17:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623604879;
        bh=6yr9JbqpIh9c87TQcZ9DPfuqvYWxRyMQ/BuyvDwXB9I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=vM48YorukCMroHlQz5eNo5uj6OaY6loO4K5wW7tPHhj0LB1TSymzFmEZvYZnUa9up
         WyIov/sRusZZbLDzRhekkLRNU/Hf3harxra9a1ywXGIoJedR4Ncq6jHaMAPiz+TUal
         a4w1wihZk4HDV0IWFMb6b8ZrVixOSKrmXKl0XyDlaORYCwTaaVWyYju+wsLOakBV4O
         fQp/cu1tmjWIrMcwfiG+wJsECoozVGRmL3VU3j3st9LOTPJ5YH9rCJTMNtNlaOozPw
         +PmeyR/wR7xkEUdP02hj2Zt2zqf/PuDycBOrQY40+vDxH833jmrCBQkrJqNILsh5Kr
         oJrT5jb5dAHUg==
Subject: [PATCH 15/16] xfs: use background worker pool when transactions can't
 get free space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        bfoster@redhat.com
Date:   Sun, 13 Jun 2021 10:21:19 -0700
Message-ID: <162360487939.1530792.9794697674663330727.stgit@locust>
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

In xfs_trans_alloc, if the block reservation call returns ENOSPC, we
call xfs_blockgc_free_space with a NULL icwalk structure to try to free
space.  Each frontend thread that encounters this situation starts its
own walk of the inode cache to see if it can find anything, which is
wasteful since we don't have any additional selection criteria.  For
this one common case, create a function that reschedules all pending
background work immediately and flushes the workqueue so that the scan
can run in parallel.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   19 +++++++++++++++++++
 fs/xfs/xfs_icache.h |    1 +
 fs/xfs/xfs_trace.h  |    1 +
 fs/xfs/xfs_trans.c  |    5 +----
 4 files changed, 22 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f530dc2803ed..656ae8d81ec5 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1949,6 +1949,25 @@ xfs_blockgc_free_space(
 	return xfs_icwalk(mp, XFS_ICWALK_INODEGC, icw);
 }
 
+/*
+ * Reclaim all the free space that we can by scheduling the background blockgc
+ * and inodegc workers immediately and waiting for them all to clear.
+ */
+void
+xfs_blockgc_flush_all(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+
+	trace_xfs_blockgc_flush_all(mp, 0, _RET_IP_);
+
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
+		flush_delayed_work(&pag->pag_blockgc_work);
+
+	xfs_inodegc_flush(mp);
+}
+
 /*
  * Run cow/eofblocks scans on the supplied dquots.  We don't know exactly which
  * quota caused an allocation failure, so we make a best effort by including
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 840eac06a71b..a9e9bb3ce4bb 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -59,6 +59,7 @@ int xfs_blockgc_free_dquots(struct xfs_mount *mp, struct xfs_dquot *udqp,
 		unsigned int iwalk_flags);
 int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int iwalk_flags);
 int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_icwalk *icm);
+void xfs_blockgc_flush_all(struct xfs_mount *mp);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 0795427e8f38..ecbfa8399776 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -198,6 +198,7 @@ DEFINE_FS_EVENT(xfs_inodegc_stop);
 DEFINE_FS_EVENT(xfs_fs_sync_fs);
 DEFINE_FS_EVENT(xfs_blockgc_start);
 DEFINE_FS_EVENT(xfs_blockgc_stop);
+DEFINE_FS_EVENT(xfs_blockgc_flush_all);
 
 DECLARE_EVENT_CLASS(xfs_ag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 586f2992b789..9fa340cc018d 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -295,10 +295,7 @@ xfs_trans_alloc(
 		 * Do not perform a synchronous scan because callers can hold
 		 * other locks.
 		 */
-		error = xfs_blockgc_free_space(mp, NULL);
-		if (error)
-			return error;
-
+		xfs_blockgc_flush_all(mp);
 		want_retry = false;
 		goto retry;
 	}

