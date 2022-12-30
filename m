Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A2CAC3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235592AbiLaA3Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235664AbiLaA2w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:28:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D874D1E3FE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:28:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CA2CB81EAC
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50123C433D2;
        Sat, 31 Dec 2022 00:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446529;
        bh=M1FskjE7kjB8CrAVJEo+WtbH4hOUSyy4dRFaOF3F9a4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Zj/FEU9jEdzNxEvAkqK7yxuakPHaQzvqeVjqCgpEoWvtFdlOXrPYEOutxFh1ZJziC
         J5xjxDhQmMHcFR+RY/0BRW4ufeoGmYueT+zlpVan1wIpB7A5UxjGarzDdZFor2n1pX
         V5+JytN5qRwYJ5hwaUgl3RGX2JvplJ8/+0W0jhzJeULkVWgjUHeNuuRGfw71q/YAus
         dGzCxm+os3qOs5aWBJ6WnLRV4UUsp0KzjEchESXrgWq2bqhybDh5GFWi4ZCb7xkeXo
         IWs7LmzzI26kdfkmiDCTrlQGmWCv3QpL2wwNYGnfcdPwrmIMbpzUmKIbQtw2EhIirT
         4HsH80lgYmGqA==
Subject: [PATCH 6/9] xfs_scrub: clean up repair_item_difficulty a little
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:17 -0800
Message-ID: <167243869793.715746.14142316853722833072.stgit@magnolia>
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

Document the flags handling in repair_item_difficulty.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index 16acb0a0f10..7ad4f6cfe8a 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -331,6 +331,15 @@ repair_item_mustfix(
 	}
 }
 
+/*
+ * These scrub item states correspond to metadata that is inconsistent in some
+ * way and must be repaired.  If too many metadata objects share these states,
+ * this can make repairs difficult.
+ */
+#define HARDREPAIR_STATES	(SCRUB_ITEM_CORRUPT | \
+				 SCRUB_ITEM_XCORRUPT | \
+				 SCRUB_ITEM_XFAIL)
+
 /* Determine if primary or secondary metadata are inconsistent. */
 unsigned int
 repair_item_difficulty(
@@ -340,9 +349,10 @@ repair_item_difficulty(
 	unsigned int		ret = 0;
 
 	foreach_scrub_type(scrub_type) {
-		if (!(sri->sri_state[scrub_type] & (XFS_SCRUB_OFLAG_CORRUPT |
-						    XFS_SCRUB_OFLAG_XCORRUPT |
-						    XFS_SCRUB_OFLAG_XFAIL)))
+		unsigned int	state;
+
+		state = sri->sri_state[scrub_type] & HARDREPAIR_STATES;
+		if (!state)
 			continue;
 
 		switch (scrub_type) {

