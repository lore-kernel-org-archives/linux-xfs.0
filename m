Return-Path: <SRS0=GEoz=YA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC19ECE58D
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Oct 2019 13:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CA7D2084D
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Oct 2019 13:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfJGNTj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Oct 2019 09:19:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38346 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727442AbfJGNTj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Oct 2019 09:19:39 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 93FC118CB8F9
        for <linux-xfs@vger.kernel.org>; Mon,  7 Oct 2019 13:19:39 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 517561001B30
        for <linux-xfs@vger.kernel.org>; Mon,  7 Oct 2019 13:19:39 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 1/3] xfs: log the inode on directory sf to block format change
Date:   Mon,  7 Oct 2019 09:19:36 -0400
Message-Id: <20191007131938.23839-2-bfoster@redhat.com>
In-Reply-To: <20191007131938.23839-1-bfoster@redhat.com>
References: <20191007131938.23839-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Mon, 07 Oct 2019 13:19:39 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When a directory changes from shortform (sf) to block format, the sf
format is copied to a temporary buffer, the inode format is modified
and the updated format filled with the dentries from the temporary
buffer. If the inode format is modified and attempt to grow the
inode fails (due to I/O error, for example), it is possible to
return an error while leaving the directory in an inconsistent state
and with an otherwise clean transaction. This results in corruption
of the associated directory and leads to xfs_dabuf_map() errors as
subsequent lookups cannot accurately determine the format of the
directory. This problem is reproduced occasionally by generic/475.

The fundamental problem is that xfs_dir2_sf_to_block() changes the
on-disk inode format without logging the inode. The inode is
eventually logged by the bmapi layer in the common case, but error
checking introduces the possibility of failing the high level
request before this happens.

Update both of the dir2 and attr callers of
xfs_bmap_local_to_extents_empty() to log the inode core as
consistent with the bmap local to extent format change codepath.
This ensures that any subsequent errors after the format has changed
cause the transaction to abort.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c  | 1 +
 fs/xfs/libxfs/xfs_dir2_block.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index b9f019603d0b..36c0a32cefcf 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -827,6 +827,7 @@ xfs_attr_shortform_to_leaf(
 
 	xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
 	xfs_bmap_local_to_extents_empty(dp, XFS_ATTR_FORK);
+	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
 
 	bp = NULL;
 	error = xfs_da_grow_inode(args, &blkno);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 9595ced393dc..3d1e5f6d64fd 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -1098,6 +1098,7 @@ xfs_dir2_sf_to_block(
 	xfs_idata_realloc(dp, -ifp->if_bytes, XFS_DATA_FORK);
 	xfs_bmap_local_to_extents_empty(dp, XFS_DATA_FORK);
 	dp->i_d.di_size = 0;
+	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 
 	/*
 	 * Add block 0 to the inode.
-- 
2.20.1

