Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC40C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjBPUnY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:43:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjBPUnY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:43:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EE94B53D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:43:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03C97B826BA
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9996C433EF;
        Thu, 16 Feb 2023 20:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580200;
        bh=z0Tr2E+mEkEl8b7pdWOLDcwYicA/TYGxfiFV2ECEWLQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=rZHfqPHtHxeRiMDKiBMTeUDNA+A1GdYQqFFbhkY6Aeat6aTwrr9J3qMrnFOiRmtWW
         GE8F3+7OQyXHqmSGamH7rKFAZWivOCcGQmwQ757B8UR2og6UR6tcTSW35HZmeMtOKg
         ETDy98mV/OypFBtBmo0c1vtgeNxGjRFjMvy866zwGKHCY3q+LUSwsu8mj34wbn68zF
         r+/svG9Kng5cNEfQoW99jPJcf9XzX2l9Q4xivQyLzY40o+4OpYvSySWmAHmNFx7g+P
         vOXBx7liVWIbpniBLRutAJUfZkMRjG5r1CvVIPPAfe1qFoX7SPzOv0w3rGIQGeX8bi
         YgpXD825NH42g==
Date:   Thu, 16 Feb 2023 12:43:20 -0800
Subject: [PATCH 06/23] xfs: drop the _safe behavior from the xbitmap foreach
 macro
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657873922.3474338.15009606137507144188.stgit@magnolia>
In-Reply-To: <167657873813.3474338.3118516275923112371.stgit@magnolia>
References: <167657873813.3474338.3118516275923112371.stgit@magnolia>
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

