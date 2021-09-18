Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FBDCC433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB56760FBF
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbhIRBbv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 21:31:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235079AbhIRBbt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Sep 2021 21:31:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5AE160FBF;
        Sat, 18 Sep 2021 01:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631928626;
        bh=oGnMn2zETXGz0ot92YxDBa9OabwlA3aTzg0IRZ3D9+s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QGKR3GX5NSHoVUIpgu3+W+uUd4YZX3ujU2jz7EwGxOz8yrdzMvBGnmRi8qU6Kbej9
         UmdOLmBCcpJbkMphERJtjOzfgOIpq2uYb0zAq8vOgAU9aocKM76q8DVskQ1+6A1yZB
         MfVaS+REFAZrFy+y2fDJ7ySXu7DGQ9Y2Wu1RriILpAcdv2uCBt/jiAmWGSCunNi9rL
         QX2tyVpkg25qWcJLDwGcnDu9QwT67rhtRov7VcKLLJidM5wwAc7dAR7PXHVS5x7KGl
         RBGkh8adazhutRnn2FkefSZWnQDfmRQycWfsLtBj+i7R6msao33qildgpKbcbr1oom
         w/0GptSW31ZqA==
Subject: [PATCH 14/14] xfs: kill XFS_BTREE_MAXLEVELS
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 17 Sep 2021 18:30:26 -0700
Message-ID: <163192862659.416199.7915871246193862758.stgit@magnolia>
In-Reply-To: <163192854958.416199.3396890438240296942.stgit@magnolia>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Nobody uses this symbol anymore, so kill it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |    2 --
 fs/xfs/libxfs/xfs_btree.h |    2 --
 2 files changed, 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 005bc42cf0bd..a7c866332911 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -5003,8 +5003,6 @@ xfs_btree_alloc_cursor(
 	struct xfs_btree_cur	*cur;
 	unsigned int		maxlevels = xfs_btree_maxlevels(mp, btnum);
 
-	ASSERT(maxlevels <= XFS_BTREE_MAXLEVELS);
-
 	cur = kmem_zalloc(xfs_btree_cur_sizeof(maxlevels), KM_NOFS);
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index d256d869f0af..91154dd63472 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -90,8 +90,6 @@ uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum);
 #define XFS_BTREE_STATS_ADD(cur, stat, val)	\
 	XFS_STATS_ADD_OFF((cur)->bc_mp, (cur)->bc_statoff + __XBTS_ ## stat, val)
 
-#define	XFS_BTREE_MAXLEVELS	9	/* max of all btrees */
-
 struct xfs_btree_ops {
 	/* size of the key and record structures */
 	size_t	key_len;

