Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48CCBC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:35:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235857AbiLaBfd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235856AbiLaBfc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:35:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E395DEB7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:35:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B90FD61CC6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C150C433EF;
        Sat, 31 Dec 2022 01:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450531;
        bh=4J2ubBY+hNfeB++cRx4hlG/dnyMgHM8xK592lFlBzZI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=c0BB5hCTfSPLhbfrQB9wqKBV3yR+hlNlm/8MrSWhJv/QceauSx8aeajj4uwU4+Wqf
         PVS25/0t9U0cyH0m3V4HQwNcDAqs7mKUZbsAo43MttVp90N1p7W8OH95a86qdCMRo9
         a6PoLsvvTwr4Xo07hxczaB6jI6p+qiRphfArWuYkF2sdmez6caLS892ysdql3rq5XA
         nHeT04lbeE3w7GBrCrxWhZ6VZ5pBpea11w3iYm6lvxmC9xJkDCirRiv4EveUq70haE
         8pJv6wh8YISLvqbmwCNxfp85yfY2m1ntyY+iio5kpX13RJuYoF+W6rbMKIxcIL238t
         CAQhuuvIZVlUg==
Subject: [PATCH 2/2] xfs: support error injection when freeing rt extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:08 -0800
Message-ID: <167243868866.714671.584997460355004822.stgit@magnolia>
In-Reply-To: <167243868836.714671.1578924317888085757.stgit@magnolia>
References: <167243868836.714671.1578924317888085757.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

A handful of fstests expect to be able to test what happens when extent
free intents fail to actually free the extent.  Now that we're
supporting EFIs for realtime extents, add to xfs_rtfree_extent the same
injection point that exists in the regular extent freeing code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index ccefbfc70f8b..a4cd7925492d 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -20,6 +20,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_log.h"
 #include "xfs_buf_item.h"
+#include "xfs_errortag.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
@@ -1139,6 +1140,9 @@ xfs_rtfree_extent(
 	ASSERT(mp->m_rbmip->i_itemp != NULL);
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_FREE_EXTENT))
+		return -EIO;
+
 	error = xfs_rtcheck_alloc_range(mp, tp, start, len);
 	if (error)
 		return error;

