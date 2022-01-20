Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AAC0C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345196AbiATAXM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345140AbiATAXL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:23:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4505CC061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:23:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B54AB81A85
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF360C004E1;
        Thu, 20 Jan 2022 00:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638188;
        bh=T3y0fWsrqWrP+rUdAYBcpr4mulrPFbUYQ3rm1Xglj6g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UeaMem1mhNGyzs9JfYLPtCcA2JdgXIwGlD5Y/DPQtLk52P1oFj9Aqwj6DZRcuOqTW
         Fc69eSuSsHoF/4hD+onYCgV4EI42L6Y5z4CU0dCrSPf7FLducgao8KF4ftuE0+p8cQ
         J2Jrwfpik6ocK5zoJEVOGH4EZu8f4ivheKbZTg9DZQbWNg9Ul74Q7meSo0Hkmw1cCR
         jynJGAgDjKuiFbVDAzkcwnis3YxdeQuiUqbxCzI/WIo3pWsV1KsqENthVm8G439HZ+
         8tmVf0opi1BazeZVPlUgdaTsk314Nj0hdYQMnBX9oYSEBAAAaS8oQl2YEw7NyAh9iW
         zy4bNtvENzj2w==
Subject: [PATCH 17/17] mkfs: enable inobtcount and bigtime by default
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Wed, 19 Jan 2022 16:23:08 -0800
Message-ID: <164263818830.863810.13464903229869457127.stgit@magnolia>
In-Reply-To: <164263809453.863810.8908193461297738491.stgit@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Enable the inode btree counters and large timestamp features by default.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index af536a8a..96682f9a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3870,11 +3870,11 @@ main(
 			.spinodes = true,
 			.rmapbt = false,
 			.reflink = true,
-			.inobtcnt = false,
+			.inobtcnt = true,
 			.parent_pointers = false,
 			.nodalign = false,
 			.nortalign = false,
-			.bigtime = false,
+			.bigtime = true,
 			/*
 			 * When we decide to enable a new feature by default,
 			 * please remember to update the mkfs conf files.

