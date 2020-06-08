Return-Path: <SRS0=Wnnb=7W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 188CDC433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 00:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E57B820774
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 00:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591663618;
	bh=ccKiDK3evDF3ELMAGfBKIcswpEkX5T9uPmZmUMJvvZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=lHvKGgQMceMTLST8vtX057u53+icToAjP6yllGb/dgonUrN0+iQUmuSADVjD2RmqU
	 AWmP58+DcfEfRrpR/vVUQPkw/HnhvpR958MFZySF50Q1thCVmZJLNZ8rqbLRStSqEg
	 b8lPBGdSlNQAyCtgWUTL2E72qtDBD0All1lgcA0o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgFIAqt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 20:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727865AbgFHXL3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Jun 2020 19:11:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D12D120E65;
        Mon,  8 Jun 2020 23:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657888;
        bh=ccKiDK3evDF3ELMAGfBKIcswpEkX5T9uPmZmUMJvvZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lDxyYuoobH/7VMXroh5HSlWA6BzBLsKRsdrnzBzgft+m6is/QX8VtaF8WvyYVgW09
         vlfrp02zTtgf3SUfj8QQQjLwg2Z18mqT0QkTW7YViI1wKeJQmY9nC0/WO89N6dhC6x
         rtuTOlgyIA2YxQk9IGCFtvs6+pDy0K4XDqHMS+bM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 244/274] xfs: force writes to delalloc regions to unwritten
Date:   Mon,  8 Jun 2020 19:05:37 -0400
Message-Id: <20200608230607.3361041-244-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit a5949d3faedf492fa7863b914da408047ab46eb0 ]

When writing to a delalloc region in the data fork, commit the new
allocations (of the da reservation) as unwritten so that the mappings
are only marked written once writeback completes successfully.  This
fixes the problem of stale data exposure if the system goes down during
targeted writeback of a specific region of a file, as tested by
generic/042.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index fda13cd7add0..f8fe83c9348d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4193,17 +4193,7 @@ xfs_bmapi_allocate(
 	bma->got.br_blockcount = bma->length;
 	bma->got.br_state = XFS_EXT_NORM;
 
-	/*
-	 * In the data fork, a wasdelay extent has been initialized, so
-	 * shouldn't be flagged as unwritten.
-	 *
-	 * For the cow fork, however, we convert delalloc reservations
-	 * (extents allocated for speculative preallocation) to
-	 * allocated unwritten extents, and only convert the unwritten
-	 * extents to real extents when we're about to write the data.
-	 */
-	if ((!bma->wasdel || (bma->flags & XFS_BMAPI_COWFORK)) &&
-	    (bma->flags & XFS_BMAPI_PREALLOC))
+	if (bma->flags & XFS_BMAPI_PREALLOC)
 		bma->got.br_state = XFS_EXT_UNWRITTEN;
 
 	if (bma->wasdel)
@@ -4611,8 +4601,23 @@ xfs_bmapi_convert_delalloc(
 	bma.offset = bma.got.br_startoff;
 	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLEN);
 	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
+
+	/*
+	 * When we're converting the delalloc reservations backing dirty pages
+	 * in the page cache, we must be careful about how we create the new
+	 * extents:
+	 *
+	 * New CoW fork extents are created unwritten, turned into real extents
+	 * when we're about to write the data to disk, and mapped into the data
+	 * fork after the write finishes.  End of story.
+	 *
+	 * New data fork extents must be mapped in as unwritten and converted
+	 * to real extents after the write succeeds to avoid exposing stale
+	 * disk contents if we crash.
+	 */
+	bma.flags = XFS_BMAPI_PREALLOC;
 	if (whichfork == XFS_COW_FORK)
-		bma.flags = XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
+		bma.flags |= XFS_BMAPI_COWFORK;
 
 	if (!xfs_iext_peek_prev_extent(ifp, &bma.icur, &bma.prev))
 		bma.prev.br_startoff = NULLFILEOFF;
-- 
2.25.1

