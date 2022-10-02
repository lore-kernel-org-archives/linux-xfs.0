Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A75C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiJBSiZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiJBSiY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:38:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DF23BC72
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:38:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04860B80D7E
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A998CC433C1;
        Sun,  2 Oct 2022 18:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735900;
        bh=z0Tr2E+mEkEl8b7pdWOLDcwYicA/TYGxfiFV2ECEWLQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fIslf29pJkUdg5w1DWzUXu2Ls6CMXr8btgK57JlyGeK4LcSY+ERfCFjAetY25XkID
         2XNPfZS3Y3j1QToiz2HQPmzitK0kxovhPTEW2rg0dK3oPM7seMQyB1/aNSU0fh09WN
         l4s9un35HXrZGGE2cG35mLlvH5eDygy4nrEfpVLSqsGog3NPXWOt9I31cWKOB8bL56
         zbZG30VHB4TycW6HibvHm/FVWSGosJ1POf5Kk4w/aABlE89Dx5r+3WJ5H/F3okEQv6
         hL6sGrCvd2NLREDHrBrdTXq7M22JIxW/9R+lNO/DQiQJ+CX+RtoxAOROrH7R5PB1UE
         YgTeYVNchUfqg==
Subject: [PATCH 2/3] xfs: drop the _safe behavior from the xbitmap foreach
 macro
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:44 -0700
Message-ID: <166473484443.1085359.14422803132351714364.stgit@magnolia>
In-Reply-To: <166473484410.1085359.13141946672747602766.stgit@magnolia>
References: <166473484410.1085359.13141946672747602766.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

It's not safe to edit bitmap intervals while we're iterating them with
for_each_xbitmap_extent.  None of the existing callers actually need
that ability anyway, so drop the safe variable.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bitmap.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index d32ded56da90..f8ebc4d61462 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -13,8 +13,9 @@
 #include "scrub/scrub.h"
 #include "scrub/bitmap.h"
 
-#define for_each_xbitmap_extent(bex, n, bitmap) \
-	list_for_each_entry_safe((bex), (n), &(bitmap)->list, list)
+/* Iterate each interval of a bitmap.  Do not change the bitmap. */
+#define for_each_xbitmap_extent(bex, bitmap) \
+	list_for_each_entry((bex), &(bitmap)->list, list)
 
 /*
  * Set a range of this bitmap.  Caller must ensure the range is not set.
@@ -46,10 +47,9 @@ void
 xbitmap_destroy(
 	struct xbitmap		*bitmap)
 {
-	struct xbitmap_range	*bmr;
-	struct xbitmap_range	*n;
+	struct xbitmap_range	*bmr, *n;
 
-	for_each_xbitmap_extent(bmr, n, bitmap) {
+	list_for_each_entry_safe(bmr, n, &bitmap->list, list) {
 		list_del(&bmr->list);
 		kfree(bmr);
 	}
@@ -308,10 +308,9 @@ xbitmap_hweight(
 	struct xbitmap		*bitmap)
 {
 	struct xbitmap_range	*bmr;
-	struct xbitmap_range	*n;
 	uint64_t		ret = 0;
 
-	for_each_xbitmap_extent(bmr, n, bitmap)
+	for_each_xbitmap_extent(bmr, bitmap)
 		ret += bmr->len;
 
 	return ret;
@@ -324,10 +323,10 @@ xbitmap_walk(
 	xbitmap_walk_fn	fn,
 	void			*priv)
 {
-	struct xbitmap_range	*bex, *n;
+	struct xbitmap_range	*bex;
 	int			error = 0;
 
-	for_each_xbitmap_extent(bex, n, bitmap) {
+	for_each_xbitmap_extent(bex, bitmap) {
 		error = fn(bex->start, bex->len, priv);
 		if (error)
 			break;

