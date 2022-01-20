Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C978C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240566AbiATAVx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:21:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240471AbiATAVw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:21:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A217DC061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:21:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41EFC61512
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A647C004E1;
        Thu, 20 Jan 2022 00:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638111;
        bh=QoFwLpDnrj0/T6i8fCtwd/wMls1QMbMhf4fL2YL8K4A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JwxADUfuT+UHmiHRKGAB2warTze3h0zXGZMnUMcTiEuQq0i9bGGzRXnauyAkhlOHE
         Ej2IftUx9f9+jwHbiFVLEzzxm+beHGrV1A+NfizWXd9wrhIDhGb3Kgn93x9Em678LV
         1241Js/9AtfTB2hnAYEapYgtAmFaT4+sCh+oTZL6okEm8nsJcqGMl9Veducg9grdT+
         WReM1CWQNHsyzWoOWm1e8JtqCudtpokoWFAHpiYISQCoZ2DVfKjWOsgBM6fv0cGKY1
         arStkMBrt0fergl3dLPJgs7Mv1/OCFBsHUpiL+oc3dPPrWXYlDDjPMyQQ37QqnAJ99
         EoItTAhngChMA==
Subject: [PATCH 03/17] libxfs: don't leave dangling perag references from
 xfs_buf
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Wed, 19 Jan 2022 16:21:51 -0800
Message-ID: <164263811129.863810.509345961407054307.stgit@magnolia>
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

When we're preparing to move a list of xfs_buf(fers) to the freelist, be
sure to detach the perag reference so that we don't leak the reference
or leave dangling pointers.  Currently this has no negative effects
since we only call libxfs_bulkrelse while exiting programs, but let's
not be sloppy.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/rdwr.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 2a9e8c98..b43527e4 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -887,11 +887,19 @@ libxfs_buf_mark_dirty(
 	bp->b_flags |= LIBXFS_B_DIRTY;
 }
 
-/* Complain about (and remember) dropping dirty buffers. */
-static void
-libxfs_whine_dirty_buf(
+/* Prepare a buffer to be sent to the MRU list. */
+static inline void
+libxfs_buf_prepare_mru(
 	struct xfs_buf		*bp)
 {
+	if (bp->b_pag)
+		xfs_perag_put(bp->b_pag);
+	bp->b_pag = NULL;
+
+	if (!(bp->b_flags & LIBXFS_B_DIRTY))
+		return;
+
+	/* Complain about (and remember) dropping dirty buffers. */
 	fprintf(stderr, _("%s: Releasing dirty buffer to free list!\n"),
 			progname);
 
@@ -909,11 +917,7 @@ libxfs_brelse(
 
 	if (!bp)
 		return;
-	if (bp->b_flags & LIBXFS_B_DIRTY)
-		libxfs_whine_dirty_buf(bp);
-	if (bp->b_pag)
-		xfs_perag_put(bp->b_pag);
-	bp->b_pag = NULL;
+	libxfs_buf_prepare_mru(bp);
 
 	pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
 	list_add(&bp->b_node.cn_mru, &xfs_buf_freelist.cm_list);
@@ -932,8 +936,7 @@ libxfs_bulkrelse(
 		return 0 ;
 
 	list_for_each_entry(bp, list, b_node.cn_mru) {
-		if (bp->b_flags & LIBXFS_B_DIRTY)
-			libxfs_whine_dirty_buf(bp);
+		libxfs_buf_prepare_mru(bp);
 		count++;
 	}
 

