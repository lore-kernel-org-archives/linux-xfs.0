Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 192E1C61D97
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Nov 2023 23:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbjKVXHF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Nov 2023 18:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjKVXHE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2023 18:07:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9867910E
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 15:07:00 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31034C433C8;
        Wed, 22 Nov 2023 23:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700694420;
        bh=DYzmwUo3DJJMVUy0AY0F0qZ2TlTaf00KTyU2pPyU/FM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=I4hHaSEKO4Ak9dOQZjFUKrrUgh3UUx0b84EcXZW+rv72OQf0oIw2nghtpjo5MDKpR
         fP4DVBFps+YZAF0yLkE9WdNQTTueA6gEXRyrNght5BcLjttmxZ5H2TbvAqJW+Ayani
         J6Y1aSQQ267Yb+UCHQcWbx/Ue1tC/vUY2aQZuJO1WmzIECbobwoUFzQeEw6CV3sEz4
         z6bzKl1ha2g+hNgEayKmf9sVc20Qn6ufvLVrnbabGjNizXvLI8l7nAW37GQUzJyOuA
         /qWEvC/GOTD0gZEaJsYkw7bgo0AHyly7m29R7f/xWP/AJx1R+fCLmS4jO5Vt78mSnu
         yYw57AEDtqiwA==
Subject: [PATCH 2/9] libxfs: don't UAF a requeued EFI
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 22 Nov 2023 15:06:59 -0800
Message-ID: <170069441966.1865809.4282467818590298794.stgit@frogsfrogsfrogs>
In-Reply-To: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In the kernel, commit 8ebbf262d4684 ("xfs: don't block in busy flushing
when freeing extents") changed the allocator behavior such that AGFL
fixing can return -EAGAIN in response to detection of a deadlock with
the transaction busy extent list.  If this happens, we're supposed to
requeue the EFI so that we can roll the transaction and try the item
again.

If a requeue happens, we should not free the xefi pointer in
xfs_extent_free_finish_item or else the retry will walk off a dangling
pointer.  There is no extent busy list in userspace so this should
never happen, but let's fix the logic bomb anyway.

We should have ported kernel commit 0853b5de42b47 ("xfs: allow extent
free intents to be retried") to userspace, but neither Carlos nor I
noticed this fine detail. :(

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 3f519252046..8731d1834be 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -115,6 +115,13 @@ xfs_extent_free_finish_item(
 	error = xfs_free_extent(tp, xefi->xefi_pag, agbno,
 			xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE);
 
+	/*
+	 * Don't free the XEFI if we need a new transaction to complete
+	 * processing of it.
+	 */
+	if (error == -EAGAIN)
+		return error;
+
 	xfs_extent_free_put_group(xefi);
 	kmem_cache_free(xfs_extfree_item_cache, xefi);
 	return error;

