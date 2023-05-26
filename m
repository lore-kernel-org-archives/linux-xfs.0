Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC37FC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240667AbjEZBq0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240830AbjEZBqZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:46:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F241A4
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:46:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA46A64C40
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3085AC433EF;
        Fri, 26 May 2023 01:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065573;
        bh=MP+XJf+igjeqSsrLXH+6jHA8JVT0b57bcZDJYKVD3Bk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ov4GRxsBmBPbmsckfgpwFwZKJTBmB3qhylS0u2W2pZZ92i6E6V8fZgHZz+bd4EaNl
         RpYSrahy3nlirtKNlUYsaGzPa77e/ZMOWbn7KjG7h7zZNPaE0ZBjeVhAeuhLPBMjGr
         p9qFZPc2uRQOGM2B3/eHe4s4ZvaWF4Z5WGKNEKw3tTDlvdmPo8qtgyG/hhaQW9mzZX
         TghgQfrdv5nNxPVcU4SU7dqcx3fHPLx+kIxh0cfB/5GQ13EBhCRLRlByNGhjCS8lYp
         TTm8B8IUvhD1sHdblvJ1sWP9/LAR/6+9UrhBstwrFpupL0Fopt6+DkVOF7BOpNA7qi
         9uXeEY0xWWvfA==
Date:   Thu, 25 May 2023 18:46:12 -0700
Subject: [PATCH 9/9] xfs_scrub: remove unused action_list fields
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506072143.3743400.15912922496995887293.stgit@frogsfrogsfrogs>
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

Remove some fields since we don't need them anymore.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c |    5 -----
 scrub/repair.h |    2 --
 2 files changed, 7 deletions(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index 824fb7fc283..7a6f725e7d1 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -432,7 +432,6 @@ action_list_discard(
 	struct action_item		*n;
 
 	list_for_each_entry_safe(aitem, n, &alist->list, list) {
-		alist->nr--;
 		list_del(&aitem->list);
 		free(aitem);
 	}
@@ -453,8 +452,6 @@ action_list_init(
 	struct action_list		*alist)
 {
 	INIT_LIST_HEAD(&alist->list);
-	alist->nr = 0;
-	alist->sorted = false;
 }
 
 /* Number of pending repairs in this list. */
@@ -478,8 +475,6 @@ action_list_add(
 	struct action_item		*aitem)
 {
 	list_add_tail(&aitem->list, &alist->list);
-	alist->nr++;
-	alist->sorted = false;
 }
 
 /* Repair everything on this list. */
diff --git a/scrub/repair.h b/scrub/repair.h
index f66c61f1e72..185e539d53c 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -8,8 +8,6 @@
 
 struct action_list {
 	struct list_head	list;
-	unsigned long long	nr;
-	bool			sorted;
 };
 
 struct action_item;

