Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA189C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236286AbiLaCzQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiLaCzP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:55:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB0B19023
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:55:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 838E9B81E49
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9BCC433EF;
        Sat, 31 Dec 2022 02:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455312;
        bh=itdnL6hy1oasR33tP9+6eXyA6g7dNN5KoJr4A8JXk7I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UcZLKB/PhqiQpJ9IM4Jj36+aXVIyI+C8d3JLM3r0tzVkBrhJGb5TvhkLX6eTNbi/4
         IB3qZQuetgjJ3BdxxweE1rtBYsyTVsxjLIPvVEQqgkFhSkgD/p9yytUHnBJIKFdoWr
         3q8ThC6oymP8oI4YFUThoNe5/nmctH86t8QmUEZjtoHlDrNH47G3dBgySrJfurPY+A
         51Vtv8xF5jk1rGU4D3bvMwRxgWavh05KIAyLkoUCam745Cgg5QX28VKwjsH8mraJSs
         8dMkIwUFIuJrFd+ejO/09OKFk0Z/YiRHU8QuJjSJS/sHhkqlfaKj7MMXq9L1paUKhG
         YailLXrwlXU0g==
Subject: [PATCH 04/41] xfs: realtime refcount btree transaction reservations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:08 -0800
Message-ID: <167243880820.734096.8665173732629390213.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that there's enough log reservation to handle mapping
and unmapping realtime extents.  We have to reserve enough space
to handle a split in the rtrefcountbt to add the record and a second
split in the regular refcountbt to record the rtrefcountbt split.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_trans_resv.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 42322a42058..7279b06fcb5 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -89,6 +89,14 @@ xfs_refcountbt_block_count(
 	return num_ops * (2 * mp->m_refc_maxlevels - 1);
 }
 
+static unsigned int
+xfs_rtrefcountbt_block_count(
+	struct xfs_mount	*mp,
+	unsigned int		num_ops)
+{
+	return num_ops * (2 * mp->m_rtrefc_maxlevels - 1);
+}
+
 /*
  * Logging inodes is really tricksy. They are logged in memory format,
  * which means that what we write into the log doesn't directly translate into
@@ -256,10 +264,13 @@ xfs_rtalloc_block_count(
  * Compute the log reservation required to handle the refcount update
  * transaction.  Refcount updates are always done via deferred log items.
  *
- * This is calculated as:
+ * This is calculated as the max of:
  * Data device refcount updates (t1):
  *    the agfs of the ags containing the blocks: nr_ops * sector size
  *    the refcount btrees: nr_ops * 1 trees * (2 * max depth - 1) * block size
+ * Realtime refcount updates (t2);
+ *    the rt refcount inode
+ *    the rtrefcount btrees: nr_ops * 1 trees * (2 * max depth - 1) * block size
  */
 static unsigned int
 xfs_calc_refcountbt_reservation(
@@ -267,12 +278,20 @@ xfs_calc_refcountbt_reservation(
 	unsigned int		nr_ops)
 {
 	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
+	unsigned int		t1, t2 = 0;
 
 	if (!xfs_has_reflink(mp))
 		return 0;
 
-	return xfs_calc_buf_res(nr_ops, mp->m_sb.sb_sectsize) +
-	       xfs_calc_buf_res(xfs_refcountbt_block_count(mp, nr_ops), blksz);
+	t1 = xfs_calc_buf_res(nr_ops, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_refcountbt_block_count(mp, nr_ops), blksz);
+
+	if (xfs_has_realtime(mp))
+		t2 = xfs_calc_inode_res(mp, 1) +
+		     xfs_calc_buf_res(xfs_rtrefcountbt_block_count(mp, nr_ops),
+				     blksz);
+
+	return max(t1, t2);
 }
 
 /*

