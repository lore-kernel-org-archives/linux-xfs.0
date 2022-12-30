Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A8DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbiLaA35 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235603AbiLaA3k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:29:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4C21EACF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:29:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9A61BCE1AC3
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5BAC433EF;
        Sat, 31 Dec 2022 00:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446575;
        bh=kL9Y7YuRzbEEYIQTD79/1YXgJsIq9YtNvFd6fSMYQdA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gZjVRUp/3XmxFPrQevE4i9dDgRjVqZd2ADvgMbvJakImMPDXPfdqzgGqIGdt9yyZ2
         +35lSrKBSVWJWQB6mO/WfsrVT+syyxFs5vU41rupS8SgFESEFTJe3/FB/Eg4AcOrS9
         7j4ksSxaqOxbNHDNez418wc7/bBdgu0N9+cyVS8G33ugeWl2CX7A9o+4d8KysxuPW6
         c9nf9WSq2TPK8VilQezWuTpd8XoynoeFmSw222GVrqv5bdaXNfHrLZG0rMjHGFqU+Y
         vPtAst6DCeJzTKybTikuIMwO9SXjyZQw0iHFp4AI67SoI96JzTVOtmmjQU1HbjuBwD
         HxiamP/hmWNBQ==
Subject: [PATCH 9/9] xfs_scrub: remove unused action_list fields
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:18 -0800
Message-ID: <167243869833.715746.893789790108959642.stgit@magnolia>
In-Reply-To: <167243869711.715746.14725730988345960302.stgit@magnolia>
References: <167243869711.715746.14725730988345960302.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Remove some fields since we don't need them anymore.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c |    5 -----
 scrub/repair.h |    2 --
 2 files changed, 7 deletions(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index c1ab03d6f02..a552b445e90 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -423,7 +423,6 @@ action_list_discard(
 	struct action_item		*n;
 
 	list_for_each_entry_safe(aitem, n, &alist->list, list) {
-		alist->nr--;
 		list_del(&aitem->list);
 		free(aitem);
 	}
@@ -444,8 +443,6 @@ action_list_init(
 	struct action_list		*alist)
 {
 	INIT_LIST_HEAD(&alist->list);
-	alist->nr = 0;
-	alist->sorted = false;
 }
 
 /* Number of pending repairs in this list. */
@@ -469,8 +466,6 @@ action_list_add(
 	struct action_item		*aitem)
 {
 	list_add_tail(&aitem->list, &alist->list);
-	alist->nr++;
-	alist->sorted = false;
 }
 
 /* Repair everything on this list. */
diff --git a/scrub/repair.h b/scrub/repair.h
index b0b448cef7a..d76bb963cdd 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -8,8 +8,6 @@
 
 struct action_list {
 	struct list_head	list;
-	unsigned long long	nr;
-	bool			sorted;
 };
 
 struct action_item;

