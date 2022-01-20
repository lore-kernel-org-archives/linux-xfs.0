Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40BE2C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240436AbiATAU1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:20:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58192 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357760AbiATAU0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:20:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B58F361506
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B602C004E1;
        Thu, 20 Jan 2022 00:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638025;
        bh=4W6xgL2YvKtJeczeKtUF93znDisOmSuIM/zB+K2nZb0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KauNNUIewIHlG4ZRzJEZR20ZsTZWxGC2atp7efwjOU5ngH4Xl9e360Tn453MniN3p
         het3IOaUHHuPlkHv2N9k4BwxjvonFWqZerY8S8MpseOfKuUqaf6qhgaEg8X3lj1ZyK
         JBqZt5ncjOAnGRRAWQn6mkGg35GXe5CS3mQcVPhl76dhAurn3GBgP2yKI4oCxnXOtf
         WijbxChIe9sDq67zUkl+3SJMkRS0am9LFoLu3JgkAhJ9R2fIyFV5DXO2oDb5OG6RrU
         ZIj7bXwTs9qPGsI5JH7pn4YnLwiTA425awl8KqDQgxE2yK/nf+miX6vWRmFIdudRcQ
         zg92k5Q9Tk05A==
Subject: [PATCH 33/45] libxfs: replace xfs_sb_version checks with feature flag
 checks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:20:24 -0800
Message-ID: <164263802468.860211.15737349840605006073.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert the xfs_sb_version_hasfoo() to checks against mp->m_features.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index adee90d5..8fe2f963 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -432,17 +432,17 @@ rtmount_init(
 	xfs_daddr_t	d;	/* address of last block of subvolume */
 	int		error;
 
-	if (mp->m_sb.sb_rblocks == 0)
+	if (!xfs_has_realtime(mp))
 		return 0;
 
-	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+	if (xfs_has_reflink(mp)) {
 		fprintf(stderr,
 	_("%s: Reflink not compatible with realtime device. Please try a newer xfsprogs.\n"),
 				progname);
 		return -1;
 	}
 
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+	if (xfs_has_rmapbt(mp)) {
 		fprintf(stderr,
 	_("%s: Reverse mapping btree not compatible with realtime device. Please try a newer xfsprogs.\n"),
 				progname);

