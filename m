Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87BD3C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235595AbiLaANe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235580AbiLaANd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:13:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D247B48F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:13:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5936B81DD9
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6CCC433D2;
        Sat, 31 Dec 2022 00:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445610;
        bh=BNAtpZACAl2l4KtbQxYnLgyzxcb+vb1e+k0MuWij8sc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RMCE+7Mnpca+xykyw0nZCtB1k9UN4lBtDDqej89M3uhsrZseSCMEy9adCAZZcLbJn
         QHbQ3gWRSC2yr0kpjXY6KBdDgBPEyQtMvia3WZScHxPCquhaJJ5ogmj+gAynrK5duC
         RsgiNfgWGIIshCMqvl1ZewVhOglhZ6sd5EmqJDwjABNhutQ4Vuq9wzh9QlzwWVAeoO
         AFUwzx/NyBAyZv2CX2lpv+7KvirPEnXQmcduNcpigU2lrc5TZaGgMuGAZi0mpvRx7O
         6XcG1m0InQQr8eKvh/Xo/0qHMXkzH3gUQNWdW5NB9syvlj1e6cfiXGqa7ck4FE6kUk
         gxS7z8evH90iw==
Subject: [PATCH 9/9] xfbtree: let the buffer cache flush dirty buffers to the
 xfile
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:42 -0800
Message-ID: <167243866277.711834.8918707899481865492.stgit@magnolia>
In-Reply-To: <167243866153.711834.17585439086893346840.stgit@magnolia>
References: <167243866153.711834.17585439086893346840.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

As a performance optimization, when we're committing xfbtree updates,
let the buffer cache flush the dirty buffers to disk when it's ready
instead of writing everything at every transaction commit.  This is a
bit sketchy but it's an ephemeral tree so we can play fast and loose.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfbtree.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)


diff --git a/libxfs/xfbtree.c b/libxfs/xfbtree.c
index 41851c3b9ae..65d6baea856 100644
--- a/libxfs/xfbtree.c
+++ b/libxfs/xfbtree.c
@@ -699,7 +699,6 @@ xfbtree_trans_commit(
 	struct xfbtree		*xfbt,
 	struct xfs_trans	*tp)
 {
-	LIST_HEAD(buffer_list);
 	struct xfs_log_item	*lip, *n;
 	bool			corrupt = false;
 	bool			tp_dirty = false;
@@ -733,12 +732,16 @@ xfbtree_trans_commit(
 			 * If the buffer fails verification, log the failure
 			 * but continue walking the transaction items so that
 			 * we remove all ephemeral btree buffers.
+			 *
+			 * Since the userspace buffer cache supports marking
+			 * buffers dirty and flushing them later, use this to
+			 * reduce the number of writes to the xfile.
 			 */
 			if (fa) {
 				corrupt = true;
 				xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 			} else {
-				xfs_buf_delwri_queue_here(bp, &buffer_list);
+				libxfs_buf_mark_dirty(bp);
 			}
 		}
 
@@ -752,15 +755,9 @@ xfbtree_trans_commit(
 	tp->t_flags = (tp->t_flags & ~XFS_TRANS_DIRTY) |
 			(tp_dirty ? XFS_TRANS_DIRTY : 0);
 
-	if (corrupt) {
-		xfs_buf_delwri_cancel(&buffer_list);
+	if (corrupt)
 		return -EFSCORRUPTED;
-	}
-
-	if (list_empty(&buffer_list))
-		return 0;
-
-	return xfs_buf_delwri_submit(&buffer_list);
+	return 0;
 }
 
 /*

