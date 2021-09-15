Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F9ADC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4BC3600D4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbhIOXJi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:09:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229538AbhIOXJi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:09:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B143A610A4;
        Wed, 15 Sep 2021 23:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747298;
        bh=8wwD+xjXF7jCpyTQakDZIECzjneA1xfrjTQ2vOTpd8c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GjMgeTZnYLKkQgJv4o9/r9luKtWh4NvON03/RXrfMSYpCaCCt9q0VKBDc9Z05w9a/
         2ebSdKKEp46OK0WO+MOISLhlGc4g07xTtRlHNMAUR5hl++gQi0ySLV1LmvZ1nJa3k4
         ntw/KUQZ/DZQM5GNHWE5/8xQcxefES/1Ki57TmWP/zrRCxHuyDgkG/TQCwpfWr/cgN
         YiZAIRUqJRfDII9cK1YEDev5FIwNYVlYH8ex381HfiTIqp4GHMuxveoELuoZF+OS73
         yoLeFlM8ZG1TORTbcNhkaYZ8/dsHK+uKZw+NJKFGIh4ZATA2eHcClvVOonxOovg0mg
         UI6p5KllGIqJg==
Subject: [PATCH 19/61] xfs: Remove xfs_attr_rmtval_set
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:08:18 -0700
Message-ID: <163174729847.350433.17873127404817401270.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: 0e6acf29db6f463027d1ff7cea86a641da89f0d4

This function is no longer used, so it is safe to remove

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr_remote.c |   66 ----------------------------------------------
 libxfs/xfs_attr_remote.h |    1 -
 2 files changed, 67 deletions(-)


diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 5a0699ee..d474ad7d 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -560,72 +560,6 @@ xfs_attr_rmtval_stale(
 	return 0;
 }
 
-/*
- * Write the value associated with an attribute into the out-of-line buffer
- * that we have defined for it.
- */
-int
-xfs_attr_rmtval_set(
-	struct xfs_da_args	*args)
-{
-	struct xfs_inode	*dp = args->dp;
-	struct xfs_bmbt_irec	map;
-	xfs_dablk_t		lblkno;
-	int			blkcnt;
-	int			nmap;
-	int			error;
-
-	trace_xfs_attr_rmtval_set(args);
-
-	error = xfs_attr_rmt_find_hole(args);
-	if (error)
-		return error;
-
-	blkcnt = args->rmtblkcnt;
-	lblkno = (xfs_dablk_t)args->rmtblkno;
-	/*
-	 * Roll through the "value", allocating blocks on disk as required.
-	 */
-	while (blkcnt > 0) {
-		/*
-		 * Allocate a single extent, up to the size of the value.
-		 *
-		 * Note that we have to consider this a data allocation as we
-		 * write the remote attribute without logging the contents.
-		 * Hence we must ensure that we aren't using blocks that are on
-		 * the busy list so that we don't overwrite blocks which have
-		 * recently been freed but their transactions are not yet
-		 * committed to disk. If we overwrite the contents of a busy
-		 * extent and then crash then the block may not contain the
-		 * correct metadata after log recovery occurs.
-		 */
-		nmap = 1;
-		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
-				  blkcnt, XFS_BMAPI_ATTRFORK, args->total, &map,
-				  &nmap);
-		if (error)
-			return error;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
-
-		ASSERT(nmap == 1);
-		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
-		       (map.br_startblock != HOLESTARTBLOCK));
-		lblkno += map.br_blockcount;
-		blkcnt -= map.br_blockcount;
-
-		/*
-		 * Start the next trans in the chain.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
-	}
-
-	return xfs_attr_rmtval_set_value(args);
-}
-
 /*
  * Find a hole for the attr and store it in the delayed attr context.  This
  * initializes the context to roll through allocating an attr extent for a
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index 8ad68d5d..61b85b91 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -9,7 +9,6 @@
 int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
 
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
-int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);

