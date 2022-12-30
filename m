Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF392C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbiLaA1F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235651AbiLaA1E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:27:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2FA1E3FE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:27:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01945B81E9F
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949EDC433D2;
        Sat, 31 Dec 2022 00:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446420;
        bh=+1Vh1zymLEUeW/iLUevYD21YpkJzvx+C74oDOhztVEU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=D4wHSsx6tbQqTc6w+kU0uWUy3q09VtP7EDiNApPcXpzZ68fwaT4qYc/ZyUoEBbYwh
         0ERHc7tYv4OtNhELvOzUAdQUuTa55Gae4biwUmimmtBxuaqYBwSFeEKx2IiENlERUc
         bTszvOuRzAC+u0LS97L0shWoCYSoyrS3rBvFBK/8OBCnB/ZDfdpRj5nJy3o6jPZkp8
         bcs5Sw9JlCECbFuroxgfuo2LPxpNfaDLFfs8UNUij1tLHQBlyiFkkkH/gVg2YNqEAR
         tGZRAH+car8oYU9Wk+vvfDXcu/4RsJVjpiP6qkY3iE4pYIL/XEh6/JqT+Fbj+iIb1B
         PTPnAVPnwKFaA==
Subject: [PATCH 5/6] xfs_scrub: any inconsistency in metadata should trigger
 difficulty warnings
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:14 -0800
Message-ID: <167243869434.715119.17953400209830846198.stgit@magnolia>
In-Reply-To: <167243869365.715119.17881025524336922669.stgit@magnolia>
References: <167243869365.715119.17881025524336922669.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Any inconsistency in the space metadata can be a sign that repairs will
be difficult, so set off the warning if there were cross referencing
problems too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index cb0ca50a18e..6be5d7684b3 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -311,7 +311,9 @@ action_list_difficulty(
 	unsigned int			ret = 0;
 
 	list_for_each_entry_safe(aitem, n, &alist->list, list) {
-		if (!(aitem->flags & XFS_SCRUB_OFLAG_CORRUPT))
+		if (!(aitem->flags & (XFS_SCRUB_OFLAG_CORRUPT |
+				      XFS_SCRUB_OFLAG_XCORRUPT |
+				      XFS_SCRUB_OFLAG_XFAIL)))
 			continue;
 
 		switch (aitem->type) {

