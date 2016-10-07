Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43933 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756512AbcJGXH4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Oct 2016 19:07:56 -0400
Subject: [PATCH 5/7] xfs: fix label inaccuracies
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 07 Oct 2016 16:07:50 -0700
Message-ID: <147588167051.12127.12421314963194053634.stgit@birch.djwong.org>
In-Reply-To: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
References: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

Since we don't unlock anything on the way out, change the label.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_file.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 54c27ed..710ee11 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1098,19 +1098,19 @@ xfs_file_share_range(
 	/* Wait for the completion of any pending IOs on srcfile */
 	ret = xfs_file_wait_for_io(inode_in, pos_in, len);
 	if (ret)
-		goto out_unlock;
+		goto out;
 	ret = xfs_file_wait_for_io(inode_out, pos_out, len);
 	if (ret)
-		goto out_unlock;
+		goto out;
 
 	if (is_dedupe)
 		flags |= XFS_REFLINK_DEDUPE;
 	ret = xfs_reflink_remap_range(XFS_I(inode_in), pos_in, XFS_I(inode_out),
 			pos_out, len, flags);
 	if (ret < 0)
-		goto out_unlock;
+		goto out;
 
-out_unlock:
+out:
 	return ret;
 }
 

