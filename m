Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE011C433E9
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 10:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5701820757
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 10:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313959AbhAZXC6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 18:02:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbhAZFAd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jan 2021 00:00:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECCAA22573;
        Tue, 26 Jan 2021 04:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611637193;
        bh=gY1HrTBzr4j3Le3oF0SZAkabF7RMF6LqkNUvF/2JMGk=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=mFNg3RqBxzl+saE/hfomnweHnsTPPVfir04XUS5EZ74rijg5R5bDlTHXb/aTpgH2E
         XCMxg18GxP8oVEL7M8xP/h7cBWQHgBjRIznYQgYlV+/0GqjRQdL5tVMiaslYtwPPPR
         sYeHjAOXCMUG5UlgXS5k0oB3MtH/VqJW4UMr3GZq72r/nB/2U3GmDnpqetlSdJPEFa
         EZYUXZooj39LHotOf1/wKVUpi+HTVlicX2e5DUOk5glp6iM5ZqpBVBqSLXtHJkclIL
         F0P9u04apvzixhu0XQJ14gWiREBqEZ5OcElR9R02Mb3Cg5I97sAMopYplQj/P/Elfb
         kZvjxG8iXW7Lw==
Date:   Mon, 25 Jan 2021 20:59:52 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: [PATCH v4.1 11/11] xfs: flush speculative space allocations when we
 run out of space
Message-ID: <20210126045952.GR7698@magnolia>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142798066.2171939.9311024588681972086.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142798066.2171939.9311024588681972086.stgit@magnolia>
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
v4.1: don't free the transaction, since it's not pinning log resources
---
 fs/xfs/xfs_trans.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index e72730f85af1..79ef904c5698 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -20,6 +20,8 @@
 #include "xfs_trace.h"
 #include "xfs_error.h"
 #include "xfs_defer.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
 
 kmem_zone_t	*xfs_trans_zone;
 
@@ -285,6 +287,18 @@ xfs_trans_alloc(
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
