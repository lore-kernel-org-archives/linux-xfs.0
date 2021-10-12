Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 483D8C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:33:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AF9860FDA
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbhJLXfs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234169AbhJLXfr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 19:35:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D18360F92;
        Tue, 12 Oct 2021 23:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634081625;
        bh=zVWTkpaV3cx0bT2tZoyo+LrrUlZh8TVjFI7PHF0GeW8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KWN3L48taUaYSoq/TrUhiwr2y68xOS/KEO9BNrXJNTkaf2qRITMaJt8MEV2VYx9cI
         VUlIunvZQKT6wH5MBzKJRHpW3VoogARbndb3mJSrGPVyBIV2JS22pXmllptY1dlKxf
         IX7ykbwr7ZBC1UhVmI7iiFbSu7oD5Gi8wPRpVE6ZeNnjF+Y6oJyok/7QersaXcuWUm
         zz3CAxNaDlcis3NXAgXX1Ehh5aFXwrVx78vxBPgC1JQ91szLAaw6HXV1AWfXRPaw2t
         Mrkp/XdesQvJWKW3Lw/lCndBi+A3HktnJusBbcLYA9oaZSXH6K6TDYtcn7sF55kvti
         gPlnHvip7gKvg==
Subject: [PATCH 13/15] xfs: widen btree maxlevels computation to handle 64-bit
 record counts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Date:   Tue, 12 Oct 2021 16:33:45 -0700
Message-ID: <163408162537.4151249.5138465633448556647.stgit@magnolia>
In-Reply-To: <163408155346.4151249.8364703447365270670.stgit@magnolia>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Rework xfs_btree_compute_maxlevels to handle larger record counts, since
we're about to add support for very large data forks.  Eventually the
realtime reverse mapping btree will need this too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   16 ++++++++--------
 fs/xfs/libxfs/xfs_btree.h |    3 ++-
 2 files changed, 10 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 201b81d54622..b95c817ad90d 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4515,19 +4515,19 @@ xfs_btree_sblock_verify(
 
 /*
  * Calculate the number of btree levels needed to store a given number of
- * records in a short-format btree.
+ * records in btree blocks.  This does not include the inode root level.
  */
-uint
+unsigned int
 xfs_btree_compute_maxlevels(
-	uint			*limits,
-	unsigned long		len)
+	unsigned int		*limits,
+	unsigned long long	len)
 {
-	uint			level;
-	unsigned long		maxblocks;
+	unsigned int		level;
+	unsigned long long	maxblocks;
 
-	maxblocks = (len + limits[0] - 1) / limits[0];
+	maxblocks = howmany_64(len, limits[0]);
 	for (level = 1; maxblocks > 1; level++)
-		maxblocks = (maxblocks + limits[1] - 1) / limits[1];
+		maxblocks = howmany_64(maxblocks, limits[1]);
 	return level;
 }
 
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index d5f03550cec9..20a2828c11ef 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -480,7 +480,8 @@ xfs_failaddr_t xfs_btree_lblock_v5hdr_verify(struct xfs_buf *bp,
 xfs_failaddr_t xfs_btree_lblock_verify(struct xfs_buf *bp,
 		unsigned int max_recs);
 
-uint xfs_btree_compute_maxlevels(uint *limits, unsigned long len);
+unsigned int xfs_btree_compute_maxlevels(unsigned int *limits,
+		unsigned long long len);
 unsigned int xfs_btree_compute_maxlevels_size(unsigned long long max_btblocks,
 		unsigned int leaf_mnr);
 unsigned long long xfs_btree_calc_size(uint *limits, unsigned long long len);

