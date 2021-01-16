Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5D84C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 01:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEC90207B6
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 01:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbhAPB0G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Jan 2021 20:26:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:33398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729034AbhAPB0F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jan 2021 20:26:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 206A523A34;
        Sat, 16 Jan 2021 01:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610760325;
        bh=ojNwOriUnwm63bH7ZjrFzFrG0iqxg6ivv4QGaCSiyyk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dpakNLV5IbLvp4ReMkNdG8bY05oI9IHmLzcOFklFkr3FqnLlGkKe8HRLdfToQiyWO
         yOVqXL8QAQhjc0vVIGc3k2n9MAWIfNY+5QuX6YLf8pLvLb53wwluYbjYd5/Yxm5+qp
         Hoi8RmkIn+za36VDM8yLvxRqqDtlSo5HOWCI/LdiYB0WpWnILDcZNbxu67z5ircwfP
         CDgqcN5Y1ZigdO6lh88NEFvt12ChtsUWqmXtF4+yz4IcDx6S8KC6Cqjs0xDkrg84lR
         DNL/nn1gsZ6eyGcfZcUiIH9YuU43dqGvkcQhb+b4eV94jRzkmUzGjRjDaP4ROQqET4
         3gwJlq/ReMwuQ==
Subject: [PATCH 2/4] xfs_scrub: detect infinite loops when scanning inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 15 Jan 2021 17:25:24 -0800
Message-ID: <161076032453.3386689.17554565086009869010.stgit@magnolia>
In-Reply-To: <161076031261.3386689.3320804567045193864.stgit@magnolia>
References: <161076031261.3386689.3320804567045193864.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

During an inode scan (aka phase 3) when we're scanning the inode btree
to find files to check, make sure that each invocation of inumbers
actually gives us an inobt record with a startino that's at least as
large as what we asked for so that we always make forward progress.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/inodes.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index 63865113..cc73da7f 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -119,6 +119,7 @@ scan_ag_inodes(
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	struct xfs_bulkstat	*bs;
 	struct xfs_inumbers	*inumbers;
+	uint64_t		nextino = cvt_agino_to_ino(&ctx->mnt, agno, 0);
 	int			i;
 	int			error;
 	int			stale_count = 0;
@@ -153,6 +154,21 @@ scan_ag_inodes(
 	/* Find the inode chunk & alloc mask */
 	error = -xfrog_inumbers(&ctx->mnt, ireq);
 	while (!error && !si->aborted && ireq->hdr.ocount > 0) {
+		/*
+		 * Make sure that we always make forward progress while we
+		 * scan the inode btree.
+		 */
+		if (nextino > inumbers->xi_startino) {
+			str_corrupt(ctx, descr,
+	_("AG %u inode btree is corrupt near agino %lu, got %lu"), agno,
+				cvt_ino_to_agino(&ctx->mnt, nextino),
+				cvt_ino_to_agino(&ctx->mnt,
+						ireq->inumbers[0].xi_startino));
+			si->aborted = true;
+			break;
+		}
+		nextino = ireq->hdr.ino;
+
 		/*
 		 * We can have totally empty inode chunks on filesystems where
 		 * there are more than 64 inodes per block.  Skip these.

