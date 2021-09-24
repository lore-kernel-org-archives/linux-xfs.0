Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F3DC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AAE2604E9
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243772AbhIXB3R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 21:29:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243769AbhIXB3Q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Sep 2021 21:29:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B10D0610CB;
        Fri, 24 Sep 2021 01:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632446863;
        bh=/BCv7Obigp0Z9IPSuQwTI0GSnBv8Ceqy8y/weVWjWdk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uGxEZJrxlMv9S6b00rczs8owCKksMDkE6SC6sy1EwnqRwRC54L3g4xg157pmgUnYF
         KQH8ynmJCQg5k4uEsSp9LUrjqMRG5avVXGN/JOOkjMrXXscj03mIAqYYsgl+Mc+F34
         7mINtPtoJ55O8IcP+xyacZg+HGJQPhmv8wdGcAWk0B60pSTSQ0NJU+X+pDoWoTXEiC
         I1WEq4lUeGgVJLvU7ZmsmocE+WnJY2MabGPu5DRMxIMhNCEGQnmwAWHGSz3U5mIHNy
         ekUniq6PJ0MM5zOe2Rf1nIuiLU5oemUkGv3iptAxWYcZ1Z7g0J5bhBz2At3KbQO3rI
         NULoDSZP1/IXg==
Subject: [PATCH 1/4] xfs: remove xfs_btree_cur.bc_blocklog
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com,
        chandanrlinux@gmail.com, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 23 Sep 2021 18:27:43 -0700
Message-ID: <163244686340.2701674.14324295598821372906.stgit@magnolia>
In-Reply-To: <163244685787.2701674.13029851795897591378.stgit@magnolia>
References: <163244685787.2701674.13029851795897591378.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This field isn't used by anyone, so get rid of it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |    1 -
 fs/xfs/libxfs/xfs_btree.h |    1 -
 2 files changed, 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 64b47e81f6f3..619319ff41e5 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -5023,7 +5023,6 @@ xfs_btree_alloc_cursor(
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
-	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 	cur->bc_maxlevels = maxlevels;
 
 	return cur;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 89239b2be096..527b90aa085b 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -241,7 +241,6 @@ struct xfs_btree_cur
 	uint			bc_flags; /* btree features - below */
 	uint8_t		bc_maxlevels;	/* maximum levels for this btree type */
 	uint8_t		bc_nlevels;	/* number of levels in the tree */
-	uint8_t		bc_blocklog;	/* log2(blocksize) of btree blocks */
 	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
 	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
 	int		bc_statoff;	/* offset of btre stats array */

