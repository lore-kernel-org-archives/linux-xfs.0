Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A01A7C433E9
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 665042313E
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbhAWSxT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:53:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:35256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbhAWSxM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:53:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8009122DBF;
        Sat, 23 Jan 2021 18:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611427973;
        bh=4I9YvxI6NwO7tm4WxT8v3pPRkckY9yYDphLA/GpSjLs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MIihBoSFPwuKDDxqunELfqnIlWR84Km5lkVL/p266s8iUgn6HrDNylnNZCyutgmtd
         wiKPlVNnczqysWe3vDgSC9/qbfQOagqShyt1xf86pgwDit9/gc0VPUZ3lSYqZ0enBc
         V69wpyiCJAa/KUbubDTjOwHt5gGwfZPZHYtwEKoMqiFWZ7bsnxIwom1uCe5EAamrb4
         tHNNowP7dQQh4rflaS22OAGRcYPxdigeA7n2hCKP2BqyC9p8rlzedshNEVm5telUe8
         6vTE1Lf2MK+dg2gHEG8vZgbCWXNy7eVC9Hu/OmQj8QKOu1PixUkRwle1hyxJsV9zEK
         k/lZo0JdDG7dQ==
Subject: [PATCH 10/11] xfs: refactor xfs_icache_free_{eof,cow}blocks call
 sites
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:52:55 -0800
Message-ID: <161142797509.2171939.4924852652653930954.stgit@magnolia>
In-Reply-To: <161142791950.2171939.3320927557987463636.stgit@magnolia>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
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
 fs/xfs/xfs_file.c   |    3 +--
 fs/xfs/xfs_icache.c |   39 +++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_icache.h |    1 +
 fs/xfs/xfs_trace.h  |    1 +
 4 files changed, 36 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 57086838a676..a766ad4477c5 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -758,8 +758,7 @@ xfs_file_buffered_write(
 
 		xfs_iunlock(ip, iolock);
 		eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
-		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
-		xfs_icache_free_cowblocks(ip->i_mount, &eofb);
+		xfs_blockgc_free_space(ip->i_mount, &eofb);
 		goto write_retry;
 	}
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 7f999f9dd80a..0d228a5e879f 100644
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
 	struct xfs_eofblocks	eofb = {0};
 	struct xfs_mount	*mp = NULL;
 	bool			do_work = false;
-	int			error;
 
 	if (!udqp && !gdqp && !pdqp)
 		return 0;
@@ -1699,11 +1730,7 @@ xfs_blockgc_free_dquots(
 	if (!do_work)
 		return 0;
 
-	error = xfs_icache_free_eofblocks(mp, &eofb);
-	if (error)
-		return error;
-
-	return xfs_icache_free_cowblocks(mp, &eofb);
+	return xfs_blockgc_free_space(mp, &eofb);
 }
 
 /*
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
index 4cbf446bae9a..c3fd344aaf5b 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3926,6 +3926,7 @@ DEFINE_EVENT(xfs_eofblocks_class, name,	\
 		 unsigned long caller_ip), \
 	TP_ARGS(mp, eofb, caller_ip))
 DEFINE_EOFBLOCKS_EVENT(xfs_ioc_free_eofblocks);
+DEFINE_EOFBLOCKS_EVENT(xfs_blockgc_free_space);
 
 #endif /* _TRACE_XFS_H */
 

