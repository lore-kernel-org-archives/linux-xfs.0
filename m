Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220D9C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 20:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiFWUkL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 16:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiFWUkK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 16:40:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04D156C32
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 13:40:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83165B82551
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 20:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D781C341C0;
        Thu, 23 Jun 2022 20:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656016807;
        bh=GcJ2b19HiR7t1yYZjaDKdbQHVU+h2KSr8KA2+mvTRnA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZeH2JVOU3ieac3gedsnFs5N84SLGgqsmGUS18NUyiBkfs9I6gmvYNmbDNKjMxrDIe
         FPjqqltRXtwBXSygMRkddYtyHkKo+jFT3L7m0ur5D97+n1GfxGcVh8MCKDdwNshNET
         unLdfQ/tcutKq0LU+HXmLGR8fi6jX5xfdroYRDhgCHu+YCU9LzZBXBtWr5iguleRZ2
         ngIdvSgVWyKZJ6Ql+4ZJr8Oi1zGdTT7t8E+ioZgf+Y4TWmRtS9IhKiTrWN1pQ/W97J
         VIJZpJau1OnPZidZRQnVPdckOmMWGLkVI7mq0vkVNtjDRk+iyj42NJ+9faUbd2Ozew
         7WX0d5wyqP4Nw==
Subject: [PATCH 2/2] xfs: clean up the end of xfs_attri_item_recover
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Thu, 23 Jun 2022 13:40:06 -0700
Message-ID: <165601680672.2928801.4056935562404690211.stgit@magnolia>
In-Reply-To: <165601679540.2928801.11814839944987662641.stgit@magnolia>
References: <165601679540.2928801.11814839944987662641.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The end of this function could use some cleanup -- the EAGAIN
conditionals make it harder to figure out what's going on with the
disposal of xattri_leaf_bp, and the dual error/ret variables aren't
needed.  Turn the EAGAIN case into a separate block documenting all the
subtleties of recovering in the middle of an xattr update chain, which
makes the rest of the prologue much simpler.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |   45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 76a23283ec65..0561c142b711 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -582,7 +582,7 @@ xfs_attri_item_recover(
 	struct xfs_trans_res		tres;
 	struct xfs_attri_log_format	*attrp;
 	struct xfs_attri_log_nameval	*nv = attrip->attri_nameval;
-	int				error, ret = 0;
+	int				error;
 	int				total;
 	int				local;
 	struct xfs_attrd_log_item	*done_item = NULL;
@@ -658,13 +658,31 @@ xfs_attri_item_recover(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	ret = xfs_xattri_finish_update(attr, done_item);
-	if (ret == -EAGAIN) {
-		/* There's more work to do, so add it to this transaction */
+	error = xfs_xattri_finish_update(attr, done_item);
+	if (error == -EAGAIN) {
+		/*
+		 * There's more work to do, so add the intent item to this
+		 * transaction so that we can continue it later.
+		 */
 		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
-	} else
-		error = ret;
+		error = xfs_defer_ops_capture_and_commit(tp, capture_list);
+		if (error)
+			goto out_unlock;
 
+		/*
+		 * The defer capture structure took its own reference to the
+		 * attr leaf buffer and will give that to the continuation
+		 * transaction.  The attr intent struct drives the continuation
+		 * work, so release our refcount on the attr leaf buffer but
+		 * retain the pointer in the intent structure.
+		 */
+		if (attr->xattri_leaf_bp)
+			xfs_buf_relse(attr->xattri_leaf_bp);
+
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		xfs_irele(ip);
+		return 0;
+	}
 	if (error) {
 		xfs_trans_cancel(tp);
 		goto out_unlock;
@@ -675,24 +693,13 @@ xfs_attri_item_recover(
 out_unlock:
 	if (attr->xattri_leaf_bp) {
 		xfs_buf_relse(attr->xattri_leaf_bp);
-
-		/*
-		 * If there's more work to do to complete the attr intent, the
-		 * defer capture structure will have taken its own reference to
-		 * the attr leaf buffer and will give that to the continuation
-		 * transaction.  The attr intent struct drives the continuation
-		 * work, so release our refcount on the attr leaf buffer but
-		 * retain the pointer in the intent structure.
-		 */
-		if (ret != -EAGAIN)
-			attr->xattri_leaf_bp = NULL;
+		attr->xattri_leaf_bp = NULL;
 	}
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
 out:
-	if (ret != -EAGAIN)
-		xfs_attr_free_item(attr);
+	xfs_attr_free_item(attr);
 	return error;
 }
 

