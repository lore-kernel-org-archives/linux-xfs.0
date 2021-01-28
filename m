Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4066C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B601964DD8
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbhA1GDq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:03:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:37784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229785AbhA1GDm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:03:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 109A664DD1;
        Thu, 28 Jan 2021 06:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813807;
        bh=iuSKfG8UcwV1wQRUXgpbO2dT/zGO+QkuMO5NxHvGvp4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lnVvmr3TvWsxkzrgvg7fp4OEPMdBRCEEoCdZlvWZi7NYdQp2H4vQ8m4ci7fuYEJTo
         A86XIH6YO+VAuRvT1UuNcf8h2/Ml0jYegEB3L6OfQIo2Se1dUjZSGEK0jzgb+wioV4
         hYmEJ0laCZHb39V1CGIaMweTWNhVnRqfmEEXlM3nHL+rdMj8EX7hCmdXBKLGo7E1/b
         WCpRoNiVVHpaj4I8f5471C73RgLe9mlAqr9VZooq/mu4c4YJUxJiWO5fIM87W4Nf/w
         U+rjTNo5Q+P1TYZdluq0tMSK+4giSND+mnrZ+d7kYXy4CX44PPdMns06jPR54uIask
         lmT6CSXpu7TZQ==
Subject: [PATCH 11/11] xfs: flush speculative space allocations when we run
 out of space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:03:23 -0800
Message-ID: <161181380328.1525026.14172897140148764735.stgit@magnolia>
In-Reply-To: <161181374062.1525026.14717838769921652940.stgit@magnolia>
References: <161181374062.1525026.14717838769921652940.stgit@magnolia>
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
 fs/xfs/xfs_trans.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)


diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7d4823cbd7c0..eb39baddff35 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -23,6 +23,7 @@
 #include "xfs_inode.h"
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
+#include "xfs_icache.h"
 
 kmem_zone_t	*xfs_trans_zone;
 
@@ -288,6 +289,18 @@ xfs_trans_alloc(
 	tp->t_firstblock = NULLFSBLOCK;
 
 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
+	if (error == -ENOSPC) {
+		/*
+		 * We weren't able to reserve enough space for the transaction.
+		 * Flush the other speculative space allocations to free space.
+		 * Do not perform a synchronous scan because callers can hold
+		 * other locks.
+		 */
+		error = xfs_blockgc_free_space(mp, NULL);
+		if (error)
+			return error;
+		error = xfs_trans_reserve(tp, resp, blocks, rtextents);
+	}
 	if (error) {
 		xfs_trans_cancel(tp);
 		return error;

