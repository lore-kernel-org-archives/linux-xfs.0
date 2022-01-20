Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEBF3C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345153AbiATAVt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345141AbiATAVt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:21:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B33C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:21:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71943B81AD5
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1392BC004E1;
        Thu, 20 Jan 2022 00:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638106;
        bh=PWE1zOAhrJW0bkLGswpE/TlDOqjvKrb5RoUt+ItxG/k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=I97ogSJSnUpLrXrMis8VdRl/GewMFF3hznHSOerORMsDU3ynkXXjc2prHCyuG5Hqg
         3Yk5AogMBkGPxH5urtG3n9avaPB9vWQ+PCesfROpVEzPFvyhj8Y3F7ObV7Cgk53lbI
         K/g/gGbj3Yl24AFYE93MSAZm2qT1VEUkxGpzGwTH+nnBexpg5vHuKQm389u2fq4AtT
         w96GX3V7JrERx92nwNT/k749Sa5VJPWPmoVivERdYyXf4JPVNXPFTeIxc2YqsSePzu
         i2yLMBeexGjpc7YMsuOp7HsVAtyq3NeN9DiwyES7ZlKZQwdkkSbfPsPtTzrG1guCbp
         eJe+kt2Q/g0Dg==
Subject: [PATCH 02/17] libxfs: shut down filesystem if we xfs_trans_cancel
 with deferred work items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Wed, 19 Jan 2022 16:21:45 -0800
Message-ID: <164263810572.863810.13209521254816975203.stgit@magnolia>
In-Reply-To: <164263809453.863810.8908193461297738491.stgit@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While debugging some very strange rmap corruption reports in connection
with the online directory repair code.  I root-caused the error to the
following incorrect sequence:

<start repair transaction>
<expand directory, causing a deferred rmap to be queued>
<roll transaction>
<cancel transaction>

Obviously, we should have committed the transaction instead of
cancelling it.  Thinking more broadly, however, xfs_trans_cancel should
have warned us that we were throwing away work item that we already
committed to performing.  This is not correct, and we need to shut down
the filesystem.

Change xfs_trans_cancel to complain in the loudest manner if we're
cancelling any transaction with deferred work items attached.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/trans.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)


diff --git a/libxfs/trans.c b/libxfs/trans.c
index fd2e6f9d..8c16cb8d 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -318,13 +318,30 @@ void
 libxfs_trans_cancel(
 	struct xfs_trans	*tp)
 {
+	bool			dirty;
+
 	trace_xfs_trans_cancel(tp, _RET_IP_);
 
 	if (tp == NULL)
 		return;
+	dirty = (tp->t_flags & XFS_TRANS_DIRTY);
 
-	if (tp->t_flags & XFS_TRANS_PERM_LOG_RES)
+	/*
+	 * It's never valid to cancel a transaction with deferred ops attached,
+	 * because the transaction is effectively dirty.  Complain about this
+	 * loudly before freeing the in-memory defer items.
+	 */
+	if (!list_empty(&tp->t_dfops)) {
+		ASSERT(list_empty(&tp->t_dfops));
+		ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+		dirty = true;
 		xfs_defer_cancel(tp);
+	}
+
+	if (dirty) {
+		fprintf(stderr, _("Cancelling dirty transaction!\n"));
+		abort();
+	}
 
 	xfs_trans_free_items(tp);
 	xfs_trans_free(tp);

