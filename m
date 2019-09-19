Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D109C3A5A6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 21:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E245B217D6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 21:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732857AbfISVBk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 17:01:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52916 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730064AbfISVBk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Sep 2019 17:01:40 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E87A4308213F
        for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2019 21:01:39 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-123-212.rdu2.redhat.com [10.10.123.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 972095D9CD
        for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2019 21:01:39 +0000 (UTC)
From:   Bill O'Donnell <billodo@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4] xfs: assure zeroed memory buffers for certain kmem allocations
Date:   Thu, 19 Sep 2019 16:01:38 -0500
Message-Id: <20190919210138.13535-1-billodo@redhat.com>
In-Reply-To: <20190916153504.30809-1-billodo@redhat.com>
References: <20190916153504.30809-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 19 Sep 2019 21:01:39 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Guarantee zeroed memory buffers for cases where potential memory
leak to disk can occur. In these cases, kmem_alloc is used and
doesn't zero the buffer, opening the possibility of information
leakage to disk.

Use existing infrastucture (xfs_buf_allocate_memory) to obtain
the already zeroed buffer from kernel memory.

This solution avoids the performance issue that would occur if a
wholesale change to replace kmem_alloc with kmem_zalloc was done.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
v4: use __GFP_ZERO as part of gfp_mask (instead of KM_ZERO)
v3: remove XBF_ZERO flag, and instead use XBF_READ flag only.
v2: zeroed buffer not required for XBF_READ case. Correct placement
    and rename the XBF_ZERO flag.

 fs/xfs/xfs_buf.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 120ef99d09e8..5d0a68de5fa6 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -345,6 +345,15 @@ xfs_buf_allocate_memory(
 	unsigned short		page_count, i;
 	xfs_off_t		start, end;
 	int			error;
+	uint			kmflag_mask = 0;
+
+	/*
+	 * assure zeroed buffer for non-read cases.
+	 */
+	if (!(flags & XBF_READ)) {
+		kmflag_mask |= KM_ZERO;
+		gfp_mask |= __GFP_ZERO;
+	}
 
 	/*
 	 * for buffers that are contained within a single page, just allocate
@@ -354,7 +363,8 @@ xfs_buf_allocate_memory(
 	size = BBTOB(bp->b_length);
 	if (size < PAGE_SIZE) {
 		int align_mask = xfs_buftarg_dma_alignment(bp->b_target);
-		bp->b_addr = kmem_alloc_io(size, align_mask, KM_NOFS);
+		bp->b_addr = kmem_alloc_io(size, align_mask,
+					   KM_NOFS | kmflag_mask);
 		if (!bp->b_addr) {
 			/* low memory - use alloc_page loop instead */
 			goto use_alloc_page;
-- 
2.21.0

