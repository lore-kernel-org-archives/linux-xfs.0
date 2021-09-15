Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0037FC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB05F606A5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbhIOXIi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:08:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232733AbhIOXIi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:08:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEADB600D4;
        Wed, 15 Sep 2021 23:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747238;
        bh=pNljwCQ8+Kzn+iThNc1aHHDJc3m2300u/21/jDaHd3Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=P/m6RT7LNTnmavWT5Qh0sxSpqgOSoaIA7WitkW0lS1gY9/A4+Kv3SHUm1emlWDgY0
         n1jYQ/frcnfR/h0MXzbo1oyEq5OhlwHsBYj2laW3CkKr3eDALycjrMkmZRLob1rUXk
         Wvm9Nc6+tfUhZKFk36zJhubpmBGOODn7Pwgc3HgWw0ZNHuFBQIN/J95EVy2gdcOobN
         CvbTwBrr1TJzfo4WTeyXrXyhFqTc20qwej5vqxCAOb6goQ7S/+tnHXokFq4ItCYLpE
         V28s595BjKZeorOVdkxJN4eXQose1oB9JwEkW/pOO5npBJV9gi60FeFgffzGc+ZB+R
         mJwmJ6fKVjzxA==
Subject: [PATCH 08/61] xfs: use xfs_buf_alloc_pages for uncached buffers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:07:18 -0700
Message-ID: <163174723845.350433.10227292919710229460.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 07b5c5add42a0afccf79401b12d78043ed6b8240

Use the newly factored out page allocation code. This adds
automatic buffer zeroing for non-read uncached buffers.

This also allows us to greatly simply the error handling in
xfs_buf_get_uncached(). Because xfs_buf_alloc_pages() cleans up
partial allocation failure, we can just call xfs_buf_free() in all
error cases now to clean up after failures.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ag.c |    1 -
 1 file changed, 1 deletion(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index cf4d65a3..b94ad5c3 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -42,7 +42,6 @@ xfs_get_aghdr_buf(
 	if (error)
 		return error;
 
-	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
 	bp->b_bn = blkno;
 	bp->b_maps[0].bm_bn = blkno;
 	bp->b_ops = ops;

