Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02EE3C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjEZBp3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjEZBp2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:45:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56021189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:45:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E61F564C3A
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5028CC433EF;
        Fri, 26 May 2023 01:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065526;
        bh=fYnePKyaAbKyqDlPzatUVuDomu10MyTs43Y5+Xp29Uk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=HtblTxxzUlr/YimdPUcIhP3j5PdM2yytJlF8jvpvnDrlo5+sPpvZDtnqpBlpmUyMF
         DihlmUiIzDs1MXyesV0Pi57J3pKVw7/R4DIEzMVAu361s0EwjdevYfMU51Ekp0Cdz2
         WNNJHn0BOAi+hy73f5OQXsXw7uV+3wdW+3M79tAZnb9kakoeoLlL+KsnVUCDIndDw9
         jsy997NeWw/gGVTedNRQk9IIFfoIxBaC5Sog6kyjuA7wj86/rBJ24LwBwAFCC7nCXL
         /6R6jMmFwcYs05n7i47Q5OXA8CRgSANFWuX5neprQ9AsR9htOaH0MYw86FKqisD6Ts
         AAx+7EvuJD69Q==
Date:   Thu, 25 May 2023 18:45:25 -0700
Subject: [PATCH 6/9] xfs_scrub: clean up repair_item_difficulty a little
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506072101.3743400.5028071114532405072.stgit@frogsfrogsfrogs>
In-Reply-To: <168506072015.3743400.5119599474014297677.stgit@frogsfrogsfrogs>
References: <168506072015.3743400.5119599474014297677.stgit@frogsfrogsfrogs>
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
index 804596195cb..9de34eada04 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -340,6 +340,15 @@ repair_item_mustfix(
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
@@ -349,9 +358,10 @@ repair_item_difficulty(
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

