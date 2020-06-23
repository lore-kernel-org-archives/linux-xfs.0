Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD80C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 05:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE5A020738
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 05:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgFWFVF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 01:21:05 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:60974 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727087AbgFWFVF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jun 2020 01:21:05 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 05BA48216C3
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jun 2020 15:21:00 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jnbMi-000388-33
        for linux-xfs@vger.kernel.org; Tue, 23 Jun 2020 15:21:00 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jnbMh-007wiZ-QH
        for linux-xfs@vger.kernel.org; Tue, 23 Jun 2020 15:20:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: use MMAPLOCK around filemap_map_pages()
Date:   Tue, 23 Jun 2020 15:20:59 +1000
Message-Id: <20200623052059.1893966-1-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=hZikwOn_FLllmE7cUhYA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The page faultround path ->map_pages is implemented in XFS via
filemap_map_pages(). This function checks that pages found in page
cache lookups have not raced with truncate based invalidation by
checking page->mapping is correct and page->index is within EOF.

However, we've known for a long time that this is not sufficient to
protect against races with invalidations done by operations that do
not change EOF. e.g. hole punching and other fallocate() based
direct extent manipulations. The way we protect against these
races is we wrap the page fault operations in a XFS_MMAPLOCK_SHARED
lock so they serialise against fallocate and truncate before calling
into the filemap function that processes the fault.

Do the same for XFS's ->map_pages implementation to close this
potential data corruption issue.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7b05f8fd7b3d..4b185a907432 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1266,10 +1266,23 @@ xfs_filemap_pfn_mkwrite(
 	return __xfs_filemap_fault(vmf, PE_SIZE_PTE, true);
 }
 
+static void
+xfs_filemap_map_pages(
+	struct vm_fault		*vmf,
+	pgoff_t			start_pgoff,
+	pgoff_t			end_pgoff)
+{
+	struct inode		*inode = file_inode(vmf->vma->vm_file);
+
+	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+	filemap_map_pages(vmf, start_pgoff, end_pgoff);
+	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+}
+
 static const struct vm_operations_struct xfs_file_vm_ops = {
 	.fault		= xfs_filemap_fault,
 	.huge_fault	= xfs_filemap_huge_fault,
-	.map_pages	= filemap_map_pages,
+	.map_pages	= xfs_filemap_map_pages,
 	.page_mkwrite	= xfs_filemap_page_mkwrite,
 	.pfn_mkwrite	= xfs_filemap_pfn_mkwrite,
 };
-- 
2.26.2.761.g0e0b3e54be

