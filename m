Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8922C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A22CC610F9
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbhINCnG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:43:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234374AbhINCnG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:43:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80443610CC;
        Tue, 14 Sep 2021 02:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587309;
        bh=TcFCeBPnxLvqlpWygdscfZwtNWXM7c3b54HUHS2AP+g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CZSWoQd+6gmkZt/Ndd5HdCA4q/d4ioyHz5tYREDztsdsBCj4UUvujxLNxMS1Z2KfB
         jUtbPvWekkFA1AXPHymH28F48C/R0YYyY0FLx7T7pAVkgjyb3D4ftjgHPr+W2NuxbW
         y4q3n5C+wOiAJ55UPUpBNx+AZyFui5chUVcAQJ/kJYBDHlHZs6gldAqOFYXVtKAi1m
         oE/I13uk4fGoAZITJ+hXgPCCreY4CvWGeTotN95+KiJ+1N0jJqcncg/jNu4IDabL3L
         QTTpGkodgmvinBr+UnvT4N5uAHEhBYexS6rSPNNzZNoCLGi0Rv9vQYNq9PFG8KRSXT
         GUVfFXUqwx2MQ==
Subject: [PATCH 20/43] xfs: sb verifier doesn't handle uncached sb buffer
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:41:49 -0700
Message-ID: <163158730925.1604118.17231730849319617732.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 8cf07f3dd56195316be97758cb8b4e1d7183ea84

The verifier checks explicitly for bp->b_bn == XFS_SB_DADDR to match
the primary superblock buffer, but the primary superblock is an
uncached buffer and so bp->b_bn is always -1ULL. Hence this never
matches and the CRC error reporting is wholly dependent on the
mount superblock already being populated so CRC feature checks pass
and allow CRC errors to be reported.

Fix this so that the primary superblock CRC error reporting is not
dependent on already having read the superblock into memory.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_sb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index b2e214ee..f29a59ae 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -634,7 +634,7 @@ xfs_sb_read_verify(
 
 		if (!xfs_buf_verify_cksum(bp, XFS_SB_CRC_OFF)) {
 			/* Only fail bad secondaries on a known V5 filesystem */
-			if (bp->b_bn == XFS_SB_DADDR ||
+			if (bp->b_maps[0].bm_bn == XFS_SB_DADDR ||
 			    xfs_sb_version_hascrc(&mp->m_sb)) {
 				error = -EFSBADCRC;
 				goto out_error;

