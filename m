Return-Path: <SRS0=GEoz=YA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F31ECE58C
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Oct 2019 13:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDF6F2084D
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Oct 2019 13:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfJGNTk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Oct 2019 09:19:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43614 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727442AbfJGNTk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Oct 2019 09:19:40 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 05E3E30ADBA5
        for <linux-xfs@vger.kernel.org>; Mon,  7 Oct 2019 13:19:40 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B59BF1001DC0
        for <linux-xfs@vger.kernel.org>; Mon,  7 Oct 2019 13:19:39 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 2/3] xfs: remove broken error handling on failed attr sf to leaf change
Date:   Mon,  7 Oct 2019 09:19:37 -0400
Message-Id: <20191007131938.23839-3-bfoster@redhat.com>
In-Reply-To: <20191007131938.23839-1-bfoster@redhat.com>
References: <20191007131938.23839-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 07 Oct 2019 13:19:40 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_attr_shortform_to_leaf() attempts to put the shortform fork back
together after a failed attempt to convert from shortform to leaf
format. While this code reallocates and copies back the shortform
attr fork data, it never resets the inode format field back to local
format. Further, now that the inode is properly logged after the
initial switch from local format, any error that triggers the
recovery code will eventually abort the transaction and shutdown the
fs. Therefore, remove the broken and unnecessary error handling
code.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 36c0a32cefcf..1b956c313b6b 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -831,28 +831,13 @@ xfs_attr_shortform_to_leaf(
 
 	bp = NULL;
 	error = xfs_da_grow_inode(args, &blkno);
-	if (error) {
-		/*
-		 * If we hit an IO error middle of the transaction inside
-		 * grow_inode(), we may have inconsistent data. Bail out.
-		 */
-		if (error == -EIO)
-			goto out;
-		xfs_idata_realloc(dp, size, XFS_ATTR_FORK);	/* try to put */
-		memcpy(ifp->if_u1.if_data, tmpbuffer, size);	/* it back */
+	if (error)
 		goto out;
-	}
 
 	ASSERT(blkno == 0);
 	error = xfs_attr3_leaf_create(args, blkno, &bp);
-	if (error) {
-		/* xfs_attr3_leaf_create may not have instantiated a block */
-		if (bp && (xfs_da_shrink_inode(args, 0, bp) != 0))
-			goto out;
-		xfs_idata_realloc(dp, size, XFS_ATTR_FORK);	/* try to put */
-		memcpy(ifp->if_u1.if_data, tmpbuffer, size);	/* it back */
+	if (error)
 		goto out;
-	}
 
 	memset((char *)&nargs, 0, sizeof(nargs));
 	nargs.dp = dp;
-- 
2.20.1

