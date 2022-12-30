Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9392BC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbiLaBfx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235853AbiLaBfv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:35:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5292721B2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:35:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04DB4B81E11
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B168FC433D2;
        Sat, 31 Dec 2022 01:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450546;
        bh=+y92eAdaacXVpso0oDsQ3b1gj32CA4Emzi4+ogFJ+o8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VFIr/2MA11ZXABzdkiJXOp8mwi+1+vi0/3l640XPhmJ5qkq3XniAi6rlg8m1tBvJf
         GF2KffhGpiR9fBnFVAGgmCJKMEfXTrzkcaasB9tMX+Ko1uzh0kQWQiwh5X0/PA3abL
         lCkFnejlkAbfO4xVjQm8lr6cvNSk303b/VPc9rRWCSWDkOVoab9d76ff3xpg/xpsxQ
         3l3GHGHuOtSH+KyLM5UDhbCGqwsS916BzY1T3c6b2wD3+4pBemZwMN+/wtzl95m9n4
         Hsz2OspfSp5ZaiuV8PxkyMoKl1vghN7falj7GjIrIBd2c5NU8CkN6zogK8jqRboQht
         /MUonG0X6yZAQ==
Subject: [PATCH 1/5] xfs: attach rtgroup objects to btree cursors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:11 -0800
Message-ID: <167243869175.714954.2927866081417377028.stgit@magnolia>
In-Reply-To: <167243869156.714954.12346064053546135919.stgit@magnolia>
References: <167243869156.714954.12346064053546135919.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make it so that we can attach realtime group objects to btree cursors.
This will be crucial for enabling rmap btrees in realtime groups.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |    4 ++++
 fs/xfs/libxfs/xfs_btree.h |    2 ++
 2 files changed, 6 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 00bc1dd73675..c02748e16075 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -31,6 +31,7 @@
 #include "scrub/xfile.h"
 #include "scrub/xfbtree.h"
 #include "xfs_btree_mem.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Btree magic numbers.
@@ -476,6 +477,9 @@ xfs_btree_del_cursor(
 	       xfs_is_shutdown(cur->bc_mp) || error != 0);
 	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
 		kmem_free(cur->bc_ops);
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    !(cur->bc_flags & XFS_BTREE_IN_MEMORY) && cur->bc_ino.rtg)
+		xfs_rtgroup_put(cur->bc_ino.rtg);
 	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) &&
 	    !(cur->bc_flags & XFS_BTREE_IN_MEMORY) && cur->bc_ag.pag)
 		xfs_perag_put(cur->bc_ag.pag);
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index b15bc77369cf..125f45731a54 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -12,6 +12,7 @@ struct xfs_mount;
 struct xfs_trans;
 struct xfs_ifork;
 struct xfs_perag;
+struct xfs_rtgroup;
 
 /*
  * Generic key, ptr and record wrapper structures.
@@ -244,6 +245,7 @@ struct xfs_btree_cur_ag {
 /* Btree-in-inode cursor information */
 struct xfs_btree_cur_ino {
 	struct xfs_inode		*ip;
+	struct xfs_rtgroup		*rtg;	/* if realtime metadata */
 	struct xbtree_ifakeroot		*ifake;	/* for staging cursor */
 	int				allocated;
 	short				forksize;

