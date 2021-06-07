Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F90C47082
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 22:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7EB36121D
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 22:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhFGW1I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 18:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230303AbhFGW1I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Jun 2021 18:27:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 322BA610E7;
        Mon,  7 Jun 2021 22:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623104716;
        bh=EmgWvPy7YlP4/Inp0ThEeGZ4CaEs6FRByr6FeXGTYBM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TtvjNkn4zAmafUqgeqXbQrFxrbzA9zCmRr6+wC94QTwl3B/htGfMpXg3RkEOptr8c
         jG2tzjj2+2cAd4Cpo6oA06o3LP4YShtt7B4QBFF/YeBk/a6rm+rTyG6k0ZRmNKljnr
         onZjd3wjlyGhXD/vXNcM9iyYxl+oBJz0KMUPPjH3xZwFftG1dm2u7A3VcckZQ6wDrT
         W/T8o6ZOVdPjrGLxB4HPnP51eaqNTYOcc6B7HEH8tC3qq0kPSh8UsHRv1XZfKVPBZ/
         4pDq9jSbzy/j8xxWvGPi4YbsYa4KAabv4zT4nBtjaEAqm9t9eLzgqDCQLvnyw9NpqT
         07PVxtroDv2UQ==
Subject: [PATCH 4/9] xfs: force inode inactivation and retry fs writes when
 there isn't space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Mon, 07 Jun 2021 15:25:15 -0700
Message-ID: <162310471588.3465262.13574945609610308742.stgit@locust>
In-Reply-To: <162310469340.3465262.504398465311182657.stgit@locust>
References: <162310469340.3465262.504398465311182657.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Any time we try to modify a file's contents and it fails due to ENOSPC
or EDQUOT, force inode inactivation work to try to free space.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 432b30d0b878..a7ca6b988e29 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1657,16 +1657,23 @@ xfs_blockgc_worker(
 }
 
 /*
- * Try to free space in the filesystem by purging eofblocks and cowblocks.
+ * Try to free space in the filesystem by purging inactive inodes, eofblocks
+ * and cowblocks.
  */
 int
 xfs_blockgc_free_space(
 	struct xfs_mount	*mp,
 	struct xfs_icwalk	*icw)
 {
+	int			error;
+
 	trace_xfs_blockgc_free_space(mp, icw, _RET_IP_);
 
-	return xfs_icwalk(mp, XFS_ICWALK_BLOCKGC, icw);
+	error = xfs_icwalk(mp, XFS_ICWALK_BLOCKGC, icw);
+	if (error)
+		return error;
+
+	return xfs_inodegc_free_space(mp, icw);
 }
 
 /*

