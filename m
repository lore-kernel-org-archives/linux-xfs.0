Return-Path: <SRS0=GEoz=YA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E200AECE58D
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Oct 2019 13:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C26102084D
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Oct 2019 13:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbfJGNTl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Oct 2019 09:19:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34508 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727490AbfJGNTl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Oct 2019 09:19:41 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6F4B2315C03D
        for <linux-xfs@vger.kernel.org>; Mon,  7 Oct 2019 13:19:40 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26B251001B30
        for <linux-xfs@vger.kernel.org>; Mon,  7 Oct 2019 13:19:40 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 3/3] xfs: move local to extent inode logging into bmap helper
Date:   Mon,  7 Oct 2019 09:19:38 -0400
Message-Id: <20191007131938.23839-4-bfoster@redhat.com>
In-Reply-To: <20191007131938.23839-1-bfoster@redhat.com>
References: <20191007131938.23839-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Mon, 07 Oct 2019 13:19:40 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The callers of xfs_bmap_local_to_extents_empty() log the inode
external to the function, yet this function is where the on-disk
format value is updated. Push the inode logging down into the
function itself to help prevent future mistakes.

Note that internal bmap callers track the inode logging flags
independently and thus may log the inode core twice due to this
change. This is harmless, so leave this code around for consistency
with the other attr fork conversion functions.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c  | 3 +--
 fs/xfs/libxfs/xfs_bmap.c       | 6 ++++--
 fs/xfs/libxfs/xfs_bmap.h       | 3 ++-
 fs/xfs/libxfs/xfs_dir2_block.c | 3 +--
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 1b956c313b6b..f0089e862216 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -826,8 +826,7 @@ xfs_attr_shortform_to_leaf(
 	sf = (xfs_attr_shortform_t *)tmpbuffer;
 
 	xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
-	xfs_bmap_local_to_extents_empty(dp, XFS_ATTR_FORK);
-	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
+	xfs_bmap_local_to_extents_empty(args->trans, dp, XFS_ATTR_FORK);
 
 	bp = NULL;
 	error = xfs_da_grow_inode(args, &blkno);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4edc25a2ba80..02469d59c787 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -792,6 +792,7 @@ xfs_bmap_extents_to_btree(
  */
 void
 xfs_bmap_local_to_extents_empty(
+	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	int			whichfork)
 {
@@ -808,6 +809,7 @@ xfs_bmap_local_to_extents_empty(
 	ifp->if_u1.if_root = NULL;
 	ifp->if_height = 0;
 	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 
 
@@ -840,7 +842,7 @@ xfs_bmap_local_to_extents(
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL);
 
 	if (!ifp->if_bytes) {
-		xfs_bmap_local_to_extents_empty(ip, whichfork);
+		xfs_bmap_local_to_extents_empty(tp, ip, whichfork);
 		flags = XFS_ILOG_CORE;
 		goto done;
 	}
@@ -887,7 +889,7 @@ xfs_bmap_local_to_extents(
 
 	/* account for the change in fork size */
 	xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
-	xfs_bmap_local_to_extents_empty(ip, whichfork);
+	xfs_bmap_local_to_extents_empty(tp, ip, whichfork);
 	flags |= XFS_ILOG_CORE;
 
 	ifp->if_u1.if_root = NULL;
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 5bb446d80542..e2798c6f3a5f 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -182,7 +182,8 @@ void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 		xfs_filblks_t len);
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 int	xfs_bmap_set_attrforkoff(struct xfs_inode *ip, int size, int *version);
-void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
+void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
+		struct xfs_inode *ip, int whichfork);
 void	__xfs_bmap_add_free(struct xfs_trans *tp, xfs_fsblock_t bno,
 		xfs_filblks_t len, const struct xfs_owner_info *oinfo,
 		bool skip_discard);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 3d1e5f6d64fd..49e4bc39e7bb 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -1096,9 +1096,8 @@ xfs_dir2_sf_to_block(
 	memcpy(sfp, oldsfp, ifp->if_bytes);
 
 	xfs_idata_realloc(dp, -ifp->if_bytes, XFS_DATA_FORK);
-	xfs_bmap_local_to_extents_empty(dp, XFS_DATA_FORK);
+	xfs_bmap_local_to_extents_empty(tp, dp, XFS_DATA_FORK);
 	dp->i_d.di_size = 0;
-	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 
 	/*
 	 * Add block 0 to the inode.
-- 
2.20.1

