Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 250E3C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E28E222E01
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387956AbhARWN2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 17:13:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:34072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387807AbhARWNR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 17:13:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 498E022E01;
        Mon, 18 Jan 2021 22:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611007979;
        bh=EsVW9I/Z1RASz1E0NSCfC62YI+ixBZ0eYhG9lFyw2T8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mfpSc16ugjtmC++VCKF/KIzAwdiZ8wLI3Ncmz1unuSx9uvtZ0PYFafp3r3vEfcTOD
         E1w7b3abbRNHcDSvH0qDg/ub412TBcyuY7W1VQbsRnVQp/qxVEz/HfbplwoXMBmoRU
         AeW7PKH1xX0AiAQszGDn0J4+YWsmYo0fmsuwrjWKZGsCOMiz9wcYeleCPg/tSya1ih
         7DdPif4p+gkISvV3QSgsVHtdsk8Fyo5YVUqHPS7+DEd/ZNvx/4T+J0v/vHOmR9f4+7
         yB0goOKLQ908PhPXDhXlZT9Ey1cMn2XqI0MYcYMJw1AkpGRa5eBd8A4lrAxc5udeEn
         DZ1i9FvOyNVIg==
Subject: [PATCH 11/11] xfs: flush speculative space allocations when we run
 out of space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 18 Jan 2021 14:12:59 -0800
Message-ID: <161100797896.88816.8665571739298768051.stgit@magnolia>
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

If a fs modification (creation, file write, reflink, etc.) is unable to
reserve enough space to handle the modification, try clearing whatever
space the filesystem might have been hanging onto in the hopes of
speeding up the filesystem.  The flushing behavior will become
particularly important when we add deferred inode inactivation because
that will increase the amount of space that isn't actively tied to user
data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trans.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index e72730f85af1..2b92a4084bb8 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -20,6 +20,8 @@
 #include "xfs_trace.h"
 #include "xfs_error.h"
 #include "xfs_defer.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
 
 kmem_zone_t	*xfs_trans_zone;
 
@@ -256,8 +258,10 @@ xfs_trans_alloc(
 	struct xfs_trans	**tpp)
 {
 	struct xfs_trans	*tp;
+	unsigned int		tries = 1;
 	int			error;
 
+retry:
 	/*
 	 * Allocate the handle before we do our freeze accounting and setting up
 	 * GFP_NOFS allocation context so that we avoid lockdep false positives
@@ -285,6 +289,22 @@ xfs_trans_alloc(
 	tp->t_firstblock = NULLFSBLOCK;
 
 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
+	if (error == -ENOSPC && tries > 0) {
+		xfs_trans_cancel(tp);
+
+		/*
+		 * We weren't able to reserve enough space for the transaction.
+		 * Flush the other speculative space allocations to free space.
+		 * Do not perform a synchronous scan because callers can hold
+		 * other locks.
+		 */
+		error = xfs_blockgc_free_space(mp, NULL);
+		if (error)
+			return error;
+
+		tries--;
+		goto retry;
+	}
 	if (error) {
 		xfs_trans_cancel(tp);
 		return error;

