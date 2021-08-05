Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A76C4338F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 02:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DFB36109F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 02:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238153AbhHECHn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Aug 2021 22:07:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238146AbhHECHm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Aug 2021 22:07:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E92861073;
        Thu,  5 Aug 2021 02:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628129249;
        bh=Pc2rO/q/foeS0l77/SplbSGwGhSrTGfLGpIumWTTNbU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qYnT3WcfroAS14SyXbEFUNTk7B7Bv3sZCA10CDttndk8CioEqwMFznopy4gURc1F2
         yTStrMTlVQqE8FjHQAIPMm2XdLIs9x13ERCpJ05PkucgKECkhQZrhTjyeRT5drxz8J
         j9yWyZ3wwEA5wMKmmFtOGYPRmMcJFr7Hvpd9xottZFpwmNNNEhxitMeGOPjotVJvSj
         mmW14AphOQzxxJuMVPkFtlN9ZlUT8gCbv9Su7TEYbYggMx52HW4LbTLsnhVT2FUARG
         zuQ37vBSAGVCaNheVXZvUFrA/C9z9NqtJ32+hgDk8H2Cl2pCbMZGY+FO581wuKMeBP
         a5nVT5/kIrP1Q==
Subject: [PATCH 12/14] xfs: use background worker pool when transactions can't
 get free space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Wed, 04 Aug 2021 19:07:28 -0700
Message-ID: <162812924890.2589546.999461658082207492.stgit@magnolia>
In-Reply-To: <162812918259.2589546.16599271324044986858.stgit@magnolia>
References: <162812918259.2589546.16599271324044986858.stgit@magnolia>
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
 fs/xfs/xfs_icache.c |   28 ++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.h |    1 +
 fs/xfs/xfs_trace.h  |    1 +
 fs/xfs/xfs_trans.c  |    5 +----
 4 files changed, 31 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 5ee1a084d36d..f5a4f4d64c50 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1507,6 +1507,34 @@ xfs_blockgc_free_space(
 	return 0;
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
+	/*
+	 * For each blockgc worker, move its queue time up to now.  If it
+	 * wasn't queued, it will not be requeued.  Then flush whatever's
+	 * left.
+	 */
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
+		mod_delayed_work(pag->pag_mount->m_blockgc_wq,
+				&pag->pag_blockgc_work, 0);
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
index 8175148afd50..18c2d224aa78 100644
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
index 1b1c288610af..0a179cfc35c0 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -202,6 +202,7 @@ DEFINE_FS_EVENT(xfs_fs_sync_fs);
 DEFINE_FS_EVENT(xfs_blockgc_start);
 DEFINE_FS_EVENT(xfs_blockgc_stop);
 DEFINE_FS_EVENT(xfs_blockgc_worker);
+DEFINE_FS_EVENT(xfs_blockgc_flush_all);
 
 DECLARE_EVENT_CLASS(xfs_ag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),
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

