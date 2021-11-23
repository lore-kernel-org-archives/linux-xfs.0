Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81173C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Nov 2021 19:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238758AbhKWUBQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Nov 2021 15:01:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:38834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240058AbhKWUBO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Nov 2021 15:01:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4974960240;
        Tue, 23 Nov 2021 19:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637697486;
        bh=8jwLTJzGQvpvDppx4RCQo4I9oPbA0igwTe8to8ozeG0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ihoRtSugZHrI9aQxusPm1EUBa6G0ifd5Q0qeQR6YoQW+QVhRES1M7o1uoFFBPdCl0
         wIagBuhOSJAWGkqPwjr3YumE4E/rbqIxjyXUA11rPBCTVhOIFdLLYICPsGIdozqQ7Q
         hbOcJUsuf5wKZYVGfWI4lqjzJ7VmYgwdn7d3wgff7bFzGbmf1P3LpE8W9whg4uw1mI
         95wtK9u24pVCuSQlpu2A6/micwBFxcC9irJvGX/1dcFINcixDJCRqZ5+fP4UefFZnE
         xkQVHWmurbeBaGA8JFUmfeN9vYscFrr5SzYvuDwgS+SE0QI4D6wMxwB9vFkQZWSM+J
         2qvRytfzhy65A==
Subject: [PATCH 1/1] xfs/122: update for 5.16 typedef removal
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 23 Nov 2021 11:58:06 -0800
Message-ID: <163769748600.881878.10036762775945430259.stgit@magnolia>
In-Reply-To: <163769748044.881878.3850309120360970780.stgit@magnolia>
References: <163769748044.881878.3850309120360970780.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In 5.16 we removed the xfs_dsb, xfs_dqblk, and xfs_dinode typedefs,
which means that we need to list the non-typedef struct definitions
explictly in the golden output for this test.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 7607f0a5..608faa4b 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -77,6 +77,7 @@ sizeof(struct xfs_cui_log_format) = 16
 sizeof(struct xfs_da3_blkinfo) = 56
 sizeof(struct xfs_da3_intnode) = 64
 sizeof(struct xfs_da3_node_hdr) = 64
+sizeof(struct xfs_dinode) = 176
 sizeof(struct xfs_dir3_blk_hdr) = 48
 sizeof(struct xfs_dir3_data_hdr) = 64
 sizeof(struct xfs_dir3_free) = 64
@@ -84,6 +85,8 @@ sizeof(struct xfs_dir3_free_hdr) = 64
 sizeof(struct xfs_dir3_leaf) = 64
 sizeof(struct xfs_dir3_leaf_hdr) = 64
 sizeof(struct xfs_disk_dquot) = 104
+sizeof(struct xfs_dqblk) = 136
+sizeof(struct xfs_dsb) = 264
 sizeof(struct xfs_dsymlink_hdr) = 56
 sizeof(struct xfs_extent_data) = 24
 sizeof(struct xfs_extent_data_info) = 32

