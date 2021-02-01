Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B376AC433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FFE164E27
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhBACIT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jan 2021 21:08:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231325AbhBACHK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 31 Jan 2021 21:07:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9D7864E2D;
        Mon,  1 Feb 2021 02:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612145189;
        bh=FjwonZxBCmRJmhhj2m/PoGXdZ2W3BzgGf4OXsXBdp+A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=saw2qCduB8jMj3VEzNrFe+8j+DRu2q1h8wX2YBqWD/uHIjWrG8Dd+Pi+7HI4PlYjw
         t9qaZrpfm8zYrURIXz/7Xn1QggJXnDO8PC+sRde8EhVEx0nsjlIeGEODBh/7VDToap
         GeIBxjYSzpRxyoF1Wf7YBH0pyrP4rnlkbvBsb1cVNU5fuMjHNOJy6Zzh2+PYPeFFxl
         Y7Mzb6wT+mYOdb2yCLkeNpPU5nK4swR6QZUGuZQoLWgfgvXaBOVjvxSrji1L9Qcfn1
         ME1/rZDKEevzmzrK4DIKT8z6s6WgS81qVRKeSfaO/1Zy40hg6RAGeMo1ergZcYBzj5
         tsHhn+exoV+pw==
Subject: [PATCH 11/12] xfs: refactor xfs_icache_free_{eof,cow}blocks call
 sites
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Sun, 31 Jan 2021 18:06:28 -0800
Message-ID: <161214518845.140945.4939930350133477265.stgit@magnolia>
In-Reply-To: <161214512641.140945.11651856181122264773.stgit@magnolia>
References: <161214512641.140945.11651856181122264773.stgit@magnolia>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_file.c   |    3 +--
 fs/xfs/xfs_icache.c |   39 +++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_icache.h |    1 +
 fs/xfs/xfs_trace.h  |    1 +
 4 files changed, 36 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 3be0b1d81325..dc91973c0b4f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -759,8 +759,7 @@ xfs_file_buffered_write(
 
 		xfs_iunlock(ip, iolock);
 		eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
-		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
-		xfs_icache_free_cowblocks(ip->i_mount, &eofb);
+		xfs_blockgc_free_space(ip->i_mount, &eofb);
 		goto write_retry;
 	}
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index cd369dd48818..97c15fcdd6f7 100644
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
@@ -1665,7 +1697,6 @@ xfs_blockgc_free_dquots(
 	struct xfs_eofblocks	eofb = {0};
 	struct xfs_mount	*mp = NULL;
 	bool			do_work = false;
-	int			error;
 
 	if (!udqp && !gdqp && !pdqp)
 		return 0;
@@ -1703,11 +1734,7 @@ xfs_blockgc_free_dquots(
 	if (!do_work)
 		return 0;
 
-	error = xfs_icache_free_eofblocks(mp, &eofb);
-	if (error)
-		return error;
-
-	return xfs_icache_free_cowblocks(mp, &eofb);
+	return xfs_blockgc_free_space(mp, &eofb);
 }
 
 /* Run cow/eofblocks scans on the quotas attached to the inode. */
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 5f520de637f6..583c132ae0fb 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -57,6 +57,7 @@ void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 int xfs_blockgc_free_dquots(struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
 		struct xfs_dquot *pdqp, unsigned int eof_flags);
 int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int eof_flags);
+int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_eofblocks *eofb);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 38649e3341cb..27929c6ca43a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3928,6 +3928,7 @@ DEFINE_EVENT(xfs_eofblocks_class, name,	\
 		 unsigned long caller_ip), \
 	TP_ARGS(mp, eofb, caller_ip))
 DEFINE_EOFBLOCKS_EVENT(xfs_ioc_free_eofblocks);
+DEFINE_EOFBLOCKS_EVENT(xfs_blockgc_free_space);
 
 #endif /* _TRACE_XFS_H */
 

