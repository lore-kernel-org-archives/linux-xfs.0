Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3CFEC7EE37
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jun 2023 05:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbjFLFfM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 01:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbjFLFew (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 01:34:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11DA129
        for <linux-xfs@vger.kernel.org>; Sun, 11 Jun 2023 22:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=sly3dfLyf49sJ7FPZL2AfEw01N76v2paWtUjCRTSk6s=; b=XASb8Fuv67QBD1JVDBDifpJeDb
        u5aM4SP1uf1bHtss2aY8xQmolYXk++UsqEa55P+bqfa9Jp3vhn7bGIn4EYS6rKPDxUQjT+nBHidsy
        I/H9GtieCeRwzre4I5Oad3UUA00y6gLHkePfi8DU0CFtCl3p9VxtH5WnQtGSWLQR8Lq7OWXIg9TZ2
        9XqYRmEAfjueY2olGOi9NNq6/FUfQYeWAlmq83YStN6qhFow2AfzAoDHtfiBlXq5diZQYf4fxyLDq
        R549gj5SZ9V8nhBve8SQHcv77QDi50LPppNtMDY0de2u9H+EY3DVqPE+y9HjQ/h6yD/D//OoALUCe
        UhqfT8SA==;
Received: from 2a02-8389-2341-5b80-8c8c-28f8-1274-e038.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8c8c:28f8:1274:e038] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q8aCY-002ezI-0U;
        Mon, 12 Jun 2023 05:34:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: set FMODE_CAN_ODIRECT instead of a dummy direct_IO method
Date:   Mon, 12 Jun 2023 07:34:46 +0200
Message-Id: <20230612053446.585328-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since commit a2ad63daa88b ("VFS: add FMODE_CAN_ODIRECT file flag") file
systems can just set the FMODE_CAN_ODIRECT flag at open time instead of
wiring up a dummy direct_IO method to indicate support for direct I/O.
Do that for xfs so that noop_direct_IO can eventually be removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 2 --
 fs/xfs/xfs_file.c | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 2ef78aa1d3f608..451942fb38ec21 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -582,7 +582,6 @@ const struct address_space_operations xfs_address_space_operations = {
 	.release_folio		= iomap_release_folio,
 	.invalidate_folio	= iomap_invalidate_folio,
 	.bmap			= xfs_vm_bmap,
-	.direct_IO		= noop_direct_IO,
 	.migrate_folio		= filemap_migrate_folio,
 	.is_partially_uptodate  = iomap_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
@@ -591,7 +590,6 @@ const struct address_space_operations xfs_address_space_operations = {
 
 const struct address_space_operations xfs_dax_aops = {
 	.writepages		= xfs_dax_writepages,
-	.direct_IO		= noop_direct_IO,
 	.dirty_folio		= noop_dirty_folio,
 	.swap_activate		= xfs_iomap_swapfile_activate,
 };
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index aede746541f8ae..605587fefbd3c5 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1172,7 +1172,7 @@ xfs_file_open(
 	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
 		return -EIO;
 	file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC |
-			FMODE_DIO_PARALLEL_WRITE;
+			FMODE_DIO_PARALLEL_WRITE | FMODE_CAN_ODIRECT;
 	return generic_file_open(inode, file);
 }
 
-- 
2.39.2

