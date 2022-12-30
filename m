Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 546DEC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235648AbiL3Wpm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235652AbiL3Wpl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:45:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF6B13CE7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:45:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8609FB81C22
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5B6C433EF;
        Fri, 30 Dec 2022 22:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440338;
        bh=x9z6zo/EXsYlr+IeQvB+VgiHTZHQHfVYShkX2j6qVeY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rkGu6lygb2mhQ7NpVxra4yJo7N6t0KHKLDuG+1JhoPYk9alXGmNmPBpgyU1uNARi/
         nnbxphTPDsMIZYBOkwbAb2NDwvIsgFqvUmA1RzvaX6yPNVMmo1FVota8BbYK5PANaA
         0RGTaahkIUVuTcePhru3Nu/iPHHnd8VdusTWdIqDsv9S90nUWMpYDtLxS3GlXIl3YZ
         9twu8VZCRYC+djLd6CF9i2zpHfc5j5kn7DffPZ5YaMxv3P5tf4OnjML0xVfG+BAm/i
         mqgSEHg8A43rPEP6BI8P/IsXDT7hLLU/UTSkD3MIcBgYtPxHYXKq3Om4sx3X56QFgU
         /pEgzyx50kOLA==
Subject: [PATCH 3/4] xfs: rename xchk_get_inode -> xchk_iget_for_scrubbing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:36 -0800
Message-ID: <167243829597.684831.7183936100069813265.stgit@magnolia>
In-Reply-To: <167243829551.684831.7487988225134202107.stgit@magnolia>
References: <167243829551.684831.7487988225134202107.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Dave Chinner suggested renaming this function to make more obvious what
it does.  The function returns an incore inode to callers that want to
scrub a metadata structure that hangs off an inode.  If the iget fails
with EINVAL, it will single-step the loading process to distinguish
between actually free inodes or impossible inumbers (ENOENT);
discrepancies between the inobt freemask and the free status in the
inode record (EFSCORRUPTED).  Any other negative errno is returned
unchanged.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c   |    2 +-
 fs/xfs/scrub/common.c |   12 +++++++-----
 fs/xfs/scrub/common.h |    2 +-
 fs/xfs/scrub/inode.c  |    2 +-
 4 files changed, 10 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index b195bc0e09a4..fe13da54e133 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -34,7 +34,7 @@ xchk_setup_inode_bmap(
 	if (xchk_need_fshook_drain(sc))
 		xchk_fshooks_enable(sc, XCHK_FSHOOKS_DRAIN);
 
-	error = xchk_get_inode(sc);
+	error = xchk_iget_for_scrubbing(sc);
 	if (error)
 		goto out;
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 70ee293bc58f..90f53f415d99 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -807,12 +807,14 @@ xchk_install_handle_inode(
 }
 
 /*
- * Given an inode and the scrub control structure, grab either the
- * inode referenced in the control structure or the inode passed in.
- * The inode is not locked.
+ * In preparation to scrub metadata structures that hang off of an inode,
+ * grab either the inode referenced in the scrub control structure or the
+ * inode passed in.  If the inumber does not reference an allocated inode
+ * record, the function returns ENOENT to end the scrub early.  The inode
+ * is not locked.
  */
 int
-xchk_get_inode(
+xchk_iget_for_scrubbing(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_imap		imap;
@@ -961,7 +963,7 @@ xchk_setup_inode_contents(
 {
 	int			error;
 
-	error = xchk_get_inode(sc);
+	error = xchk_iget_for_scrubbing(sc);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 6a7fe2596841..5ef27e6bdac6 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -135,7 +135,7 @@ int xchk_count_rmap_ownedby_ag(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
 		const struct xfs_owner_info *oinfo, xfs_filblks_t *blocks);
 
 int xchk_setup_ag_btree(struct xfs_scrub *sc, bool force_log);
-int xchk_get_inode(struct xfs_scrub *sc);
+int xchk_iget_for_scrubbing(struct xfs_scrub *sc);
 int xchk_setup_inode_contents(struct xfs_scrub *sc, unsigned int resblks);
 void xchk_buffer_recheck(struct xfs_scrub *sc, struct xfs_buf *bp);
 
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 3b272c86d0ad..39ac7cc09fbd 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -39,7 +39,7 @@ xchk_setup_inode(
 	 * Try to get the inode.  If the verifiers fail, we try again
 	 * in raw mode.
 	 */
-	error = xchk_get_inode(sc);
+	error = xchk_iget_for_scrubbing(sc);
 	switch (error) {
 	case 0:
 		break;

