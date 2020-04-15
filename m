Return-Path: <SRS0=6B5E=57=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC5CC2BA19
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 13:15:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 383CA20575
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 13:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586956517;
	bh=JTDIwijcZwHGMxB9O0aoixYI7r3ZtbL2U0goW3aJfk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=E5fWFAyZSL0W3231zWxx8FlhiutAylTz/LYfJ0IjE7XqeqgWc9uDBtdLyHkMD0g0J
	 Pxx+g4UFndYiGQ7r5rh8w76y5YA/+gWhrwPQkc0/1Ptd5LMyTINhfY7Ry0KH4jnBQZ
	 r3WjPbLTNM+Dg9vOwGhUKtMpQHfokb31sfu0+IDA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370675AbgDONOr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 09:14:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897040AbgDOLfS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Apr 2020 07:35:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E85EE214D8;
        Wed, 15 Apr 2020 11:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950517;
        bh=JTDIwijcZwHGMxB9O0aoixYI7r3ZtbL2U0goW3aJfk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=00+0c5g4WLQcaOpqbHIozN1Iv1y8TV7OMtftSrL4vRoth1xeTLUOcGyK82p2Ex1CN
         dzifD3ti/AAaAYdKJwGacRuJqZ3GlkmFXI9ofvEj1kCbUxOzaVv1tYK0EXRFa4rjUD
         6KOfhNeTuRUTOnuuaZApqyG+p5sVIM9KXGdQD/ss=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tommi Rantala <tommi.t.rantala@nokia.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 027/129] xfs: fix regression in "cleanup xfs_dir2_block_getdents"
Date:   Wed, 15 Apr 2020 07:33:02 -0400
Message-Id: <20200415113445.11881-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Tommi Rantala <tommi.t.rantala@nokia.com>

[ Upstream commit 3d28e7e278913a267b1de360efcd5e5274065ce2 ]

Commit 263dde869bd09 ("xfs: cleanup xfs_dir2_block_getdents") introduced
a getdents regression, when it converted the pointer arithmetics to
offset calculations: offset is updated in the loop already for the next
iteration, but the updated offset value is used incorrectly in two
places, where we should have used the not-yet-updated value.

This caused for example "git clean -ffdx" failures to cleanup certain
directory structures when running in a container.

Fix the regression by making sure we use proper offset in the loop body.
Thanks to Christoph Hellwig for suggestion how to best fix the code.

Cc: Christoph Hellwig <hch@lst.de>
Fixes: 263dde869bd09 ("xfs: cleanup xfs_dir2_block_getdents")
Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_dir2_readdir.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 0d3b640cf1cce..871ec22c9aee9 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -147,7 +147,7 @@ xfs_dir2_block_getdents(
 	xfs_off_t		cook;
 	struct xfs_da_geometry	*geo = args->geo;
 	int			lock_mode;
-	unsigned int		offset;
+	unsigned int		offset, next_offset;
 	unsigned int		end;
 
 	/*
@@ -173,9 +173,10 @@ xfs_dir2_block_getdents(
 	 * Loop over the data portion of the block.
 	 * Each object is a real entry (dep) or an unused one (dup).
 	 */
-	offset = geo->data_entry_offset;
 	end = xfs_dir3_data_end_offset(geo, bp->b_addr);
-	while (offset < end) {
+	for (offset = geo->data_entry_offset;
+	     offset < end;
+	     offset = next_offset) {
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
 		uint8_t filetype;
@@ -184,14 +185,15 @@ xfs_dir2_block_getdents(
 		 * Unused, skip it.
 		 */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
-			offset += be16_to_cpu(dup->length);
+			next_offset = offset + be16_to_cpu(dup->length);
 			continue;
 		}
 
 		/*
 		 * Bump pointer for the next iteration.
 		 */
-		offset += xfs_dir2_data_entsize(dp->i_mount, dep->namelen);
+		next_offset = offset +
+			xfs_dir2_data_entsize(dp->i_mount, dep->namelen);
 
 		/*
 		 * The entry is before the desired starting point, skip it.
-- 
2.20.1

