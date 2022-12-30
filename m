Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49660C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:51:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiL3Wvk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiL3Wvj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:51:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CA11AA0F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:51:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56259B81C22
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FD4C433D2;
        Fri, 30 Dec 2022 22:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440696;
        bh=z0Tr2E+mEkEl8b7pdWOLDcwYicA/TYGxfiFV2ECEWLQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qyZ3bCYBjH8miC7qNCLJe7dYi1yYQFucSPc2kNVkHLMZCFVlq3GxleIYFl+/rJZ3J
         8azDggR2W7lZgzlrM7yJZVSH4/28k9Rvz4mJE7vyZWch8iAvGGo87hB2tHgQZKP3kB
         JhGwKiDLNNTyQdJtcRtFgT8k9pQhLHDN8uBfYJjkOB/3EeUudFBf/0zmkZhdGGQWLG
         hr/EMVeuW1Rugrf17a7Ef/vGduw4dwbJ2ZbunNbj4n5V+aq4SJ5a/irBadIoF2Y5We
         lBKkVfIB7/2iSpgcajMiJUE5w7s8yqYPAtwXfD3o2kJc9a45sfsmCbD8ntNEc7Pjfw
         fEEbANxbXrtgw==
Subject: [PATCH 2/3] xfs: drop the _safe behavior from the xbitmap foreach
 macro
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:50 -0800
Message-ID: <167243831075.687325.7380037738597284071.stgit@magnolia>
In-Reply-To: <167243831043.687325.2964308291999582962.stgit@magnolia>
References: <167243831043.687325.2964308291999582962.stgit@magnolia>
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

