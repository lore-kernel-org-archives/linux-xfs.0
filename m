Return-Path: <SRS0=FqvN=X5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A68C4CED1
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 12:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDF222070B
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 12:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387690AbfJDMzV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Oct 2019 08:55:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42394 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387719AbfJDMzV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Oct 2019 08:55:21 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 130E6898114
        for <linux-xfs@vger.kernel.org>; Fri,  4 Oct 2019 12:55:21 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C66295C21A
        for <linux-xfs@vger.kernel.org>; Fri,  4 Oct 2019 12:55:20 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: log the inode on directory sf to block format change
Date:   Fri,  4 Oct 2019 08:55:20 -0400
Message-Id: <20191004125520.7857-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Fri, 04 Oct 2019 12:55:21 +0000 (UTC)
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

Update xfs_dir2_sf_to_block() to log the inode when the on-disk
format is changed. This ensures that any subsequent errors after the
format has changed cause the transaction to abort.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_dir2_block.c | 1 +
 1 file changed, 1 insertion(+)

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

