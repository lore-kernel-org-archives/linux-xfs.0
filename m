Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE01C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E08A60F5C
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbhG2Spm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:45:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231599AbhG2Spm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jul 2021 14:45:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 886AC60F4B;
        Thu, 29 Jul 2021 18:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627584338;
        bh=9t5Pk57wFoxNjKQ3weTkQlVVs8nQn1wiM+WPzm6R3pA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SJd4LGp8/I7kgdj4ZxeiBjlitS+e4dmGBa8wH4Y3JVs96SjK5gBnmKqbblwnJqRTt
         JGM9KS7FdBWWme/tl+S0laZIL/F4dcOT5iorc6Ev6WPtNv1b8DoDXaLl71bOSq49I+
         NfF5owPZ/Xzsq1uIqmFBTJPiillIbRs3nOxnRR1sMII3ZNNhwk+Kf063XUAjexdopK
         Dl/bnOTvVEMb9ZmQDu5dZPiVMt3p9+TW/mSDfsRHarxKVtC0nD8r7vOotg5SvTp2AU
         iQbTINxZiFRFUZ5aPyEw2HxFjpVZDdk1TzvlmMzm+QNnDKOUIDf0cN5X1/pajUpx0K
         YABDpUdQ3xP8Q==
Subject: [PATCH 19/20] xfs: use background worker pool when transactions can't
 get free space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 29 Jul 2021 11:45:38 -0700
Message-ID: <162758433827.332903.12188673251424790428.stgit@magnolia>
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
index 59a9526a25ff..b21d1d37bcb0 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1939,6 +1939,25 @@ xfs_blockgc_free_space(
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
+	trace_xfs_blockgc_flush_all(mp, __return_address);
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
index 7622efe6fd58..e256af3ed9b2 100644
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
index 80dc15a14173..b6dd25f19d24 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -193,6 +193,7 @@ DEFINE_FS_EVENT(xfs_fs_sync_fs);
 DEFINE_FS_EVENT(xfs_inodegc_delay_mempressure);
 DEFINE_FS_EVENT(xfs_blockgc_start);
 DEFINE_FS_EVENT(xfs_blockgc_stop);
+DEFINE_FS_EVENT(xfs_blockgc_flush_all);
 
 TRACE_EVENT(xfs_inodegc_requeue_mempressure,
 	TP_PROTO(struct xfs_perag *pag, unsigned long nr, void *caller_ip),
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 87bffd12c20c..83abaa219616 100644
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

