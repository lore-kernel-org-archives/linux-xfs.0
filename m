Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4EA7C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Dec 2022 00:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbiLUAxj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 19:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234260AbiLUAxi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 19:53:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B399FC6
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 16:53:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 069AAB81A84
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 00:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980CEC433F0;
        Wed, 21 Dec 2022 00:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671584014;
        bh=qud2C/AlKkX0jJrwUgoW0pzjCEo7BmA5aDXSjJzmhuk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YzTA4YMCW7Gc9+dyC/0qsRJiQUIvu7+dMUkFWMA6TWSgSzJng9Top5EPaimfleNOM
         4lzqL/UeZLSKuDr8hkqpw0ZSqOyQ83PMxFhHxlY8cPV9dbdGpELbfg62PdzucEqw9x
         ZDQ32QY5ALtn88Q/yE0lRl/Jn909yEUbezgpOmtbk3WCrNWePgG1OfTtKe2mGre4ex
         +OmH4yOaG+toi5fRzKm9TLrlSZNxmrVC4GYwD/n0Rm6KJjYyTozPBvK08aMNK+1Lfe
         lwP782QnBRglfn5gk5FaXS3uu8q4Je90zREUHsg36BzV3h/ybuE68//xpwSgHG79gt
         mFoYLVfk0/ilQ==
Subject: [PATCH 1/1] xfs_db: fix dir3 block magic check
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 20 Dec 2022 16:53:34 -0800
Message-ID: <167158401424.315997.9124675033467112155.stgit@magnolia>
In-Reply-To: <167158400859.315997.2365290256986240896.stgit@magnolia>
References: <167158400859.315997.2365290256986240896.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix this broken check, which (amazingly) went unnoticed until I cranked
up the warning level /and/ built the system for s390x.

Fixes: e96864ff4d4 ("xfs_db: enable blockget for v5 filesystems")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/db/check.c b/db/check.c
index bb27ce58053..964756d0ae5 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2578,7 +2578,7 @@ process_data_dir_v2(
 		error++;
 	}
 	if ((be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC ||
-	     be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC) &&
+	     be32_to_cpu(data->magic) == XFS_DIR3_BLOCK_MAGIC) &&
 					stale != be32_to_cpu(btp->stale)) {
 		if (!sflag || v)
 			dbprintf(_("dir %lld block %d bad stale tail count %d\n"),

