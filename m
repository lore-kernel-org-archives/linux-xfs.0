Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 754B0C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B19364EB1
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhBIERv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:17:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:48454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230192AbhBIEPj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:15:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5D9464ECD;
        Tue,  9 Feb 2021 04:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843888;
        bh=t893qcb9jWSkUlEZugOvpZt1CG6f3kLN3tpCFmmeBNc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GH4d+Nu/5O83Deu7bph02oh1GwaDDjisT3R7bCqQaDPl+llVpDKgTJqDSxPblMSNl
         LNXyyyWIQ+8BS+WCpG4tA7L0lOy0WSFwM9+TIyMQxV8NEoGvwaYb8wl+5P54XT8ocu
         P41yzFFT+8erd2/ItWds/KB0snKBt2Yd0ZZBowgYjkjQr4z3BEP3q+PCSQcfnyGK+f
         z93fQigErhWmYthFafQYizd25Bw/M7cQ10WCPzpCrmIDe7pMfwRZGQIga2Kxy0AClR
         Ox7WDEfu48Y6woadp6RLc+Y9JNpGjxD4+bG7aW+4FkMXJGKLOCCJMk+56RGUcTABrB
         51Si/kfjMCXKA==
Subject: [PATCH 2/6] xfs_scrub: detect infinite loops when scanning inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, chandanrlinux@gmail.com,
        Chaitanya.Kulkarni@wdc.com
Date:   Mon, 08 Feb 2021 20:11:27 -0800
Message-ID: <161284388746.3058224.2675575511596158478.stgit@magnolia>
In-Reply-To: <161284387610.3058224.6236053293202575597.stgit@magnolia>
References: <161284387610.3058224.6236053293202575597.stgit@magnolia>
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
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
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

