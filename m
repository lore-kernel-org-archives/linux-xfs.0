Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 049D7C43331
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D794422E01
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387841AbhARWNU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 17:13:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:34074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387862AbhARWNN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 17:13:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BADB5230FA;
        Mon, 18 Jan 2021 22:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611007973;
        bh=UoY73ZJqQ1IITBljWSZJGLYOOgjLpBaK2KgLBEeJkf0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OSGzvVdcegZGU9CrdPJVQg4JMmSImOUUpeZ0revpGOhXDNaj0gEQU3bHh/x590gOa
         sFL6k9hOLEaa4N7btYCF8Ryep3xrXWnlESokG4dFDxh1dWinRTsx7gb2JkcmNWjZS+
         4rjNigR6asZG8MWwM/bYychdNJYmJFyn46Y5bAVOpoRm44l9MW15tXac7xKXM6NLg1
         Y34y592hJ4buTcYjl674EBQl9lqtYCEPvI+RvrY1M3z8J1U+sWMk5dU7/ho9Q/Lh4n
         F4VVLrGS2Q82ZE6MmZAQRYB1wk1uvy/rQZAt39cUBaXNrFdgQDz/39/s+JGub90GKY
         agTLfEDOaN3cw==
Subject: [PATCH 10/11] xfs: refactor xfs_icache_free_{eof,cow}blocks call
 sites
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 18 Jan 2021 14:12:53 -0800
Message-ID: <161100797342.88816.14893475136673260706.stgit@magnolia>
In-Reply-To: <161100791789.88816.10902093186807310995.stgit@magnolia>
References: <161100791789.88816.10902093186807310995.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In anticipation of more restructuring of the eof/cowblocks gc code,
refactor calling of those two functions into a single internal helper
function, then present a new standard interface to purge speculative
block preallocations and start shifting higher level code to use that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c   |    6 ++++--
 fs/xfs/xfs_icache.c |   45 +++++++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_icache.h |    1 +
 fs/xfs/xfs_trace.h  |    1 +
 4 files changed, 41 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a318a4749b59..40b12db17a20 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -697,14 +697,16 @@ xfs_file_buffered_aio_write(
 		iolock = 0;
 	} else if (ret == -ENOSPC && !cleared_space) {
 		struct xfs_eofblocks eofb = {0};
+		int	ret2;
 
 		cleared_space = true;
 		xfs_flush_inodes(ip->i_mount);
 
 		xfs_iunlock(ip, iolock);
 		eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
-		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
-		xfs_icache_free_cowblocks(ip->i_mount, &eofb);
+		ret2 = xfs_blockgc_free_space(ip->i_mount, &eofb);
+		if (ret2)
+			return ret2;
 		goto write_retry;
 	}
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 9ba1ad69abb7..acf67384e52f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1645,6 +1645,38 @@ xfs_start_block_reaping(
 	xfs_queue_cowblocks(mp);
 }
 
+/* Scan all incore inodes for block preallocations that we can remove. */
+static inline int
+xfs_blockgc_scan(
+	struct xfs_mount	*mp,
+	struct xfs_eofblocks	*eofb)
+{
+	int			error;
+
+	error = xfs_icache_free_eofblocks(mp, eofb);
+	if (error)
+		return error;
+
+	error = xfs_icache_free_cowblocks(mp, eofb);
+	if (error)
+		return error;
+
+	return 0;
+}
+
+/*
+ * Try to free space in the filesystem by purging eofblocks and cowblocks.
+ */
+int
+xfs_blockgc_free_space(
+	struct xfs_mount	*mp,
+	struct xfs_eofblocks	*eofb)
+{
+	trace_xfs_blockgc_free_space(mp, eofb, _RET_IP_);
+
+	return xfs_blockgc_scan(mp, eofb);
+}
+
 /*
  * Run cow/eofblocks scans on the supplied dquots.  We don't know exactly which
  * quota caused an allocation failure, so we make a best effort by including
@@ -1661,7 +1693,6 @@ xfs_blockgc_free_dquots(
 {
 	struct xfs_eofblocks	eofb = {0};
 	struct xfs_mount	*mp = NULL;
-	int			error;
 
 	*found_work = false;
 
@@ -1698,18 +1729,12 @@ xfs_blockgc_free_dquots(
 		*found_work = true;
 	}
 
-	if (*found_work) {
-		error = xfs_icache_free_eofblocks(mp, &eofb);
-		if (error)
-			return error;
-
-		error = xfs_icache_free_cowblocks(mp, &eofb);
-		if (error)
-			return error;
-	}
+	if (*found_work)
+		return xfs_blockgc_free_space(mp, &eofb);
 
 	return 0;
 }
+
 /*
  * Run cow/eofblocks scans on the quotas applicable to the inode. For inodes
  * with multiple quotas, we don't know exactly which quota caused an allocation
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 8d8e7cabc27f..56ae668dcdcf 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -59,6 +59,7 @@ int xfs_blockgc_free_dquots(struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
 		bool *found_work);
 int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int eof_flags,
 		bool *found_work);
+int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_eofblocks *eofb);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3f761f33099b..7ec9d4d703a6 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3926,6 +3926,7 @@ DEFINE_EVENT(xfs_eofblocks_class, name,	\
 		 unsigned long caller_ip), \
 	TP_ARGS(mp, eofb, caller_ip))
 DEFINE_EOFBLOCKS_EVENT(xfs_ioc_free_eofblocks);
+DEFINE_EOFBLOCKS_EVENT(xfs_blockgc_free_space);
 
 #endif /* _TRACE_XFS_H */
 

