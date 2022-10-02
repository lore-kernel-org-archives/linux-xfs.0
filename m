Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB64C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiJBSai (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiJBSah (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:30:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BF527B2C
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:30:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C89E660F07
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33950C433C1;
        Sun,  2 Oct 2022 18:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735436;
        bh=Klz+nZ8PpAysmb/xF2Y37QyJrzucFAfnpaBuCpCWTNk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LABq+mI6VgTlqkp6l1mk4nrQf50tasDKLnvgaqsJm8o/unoGwGoQHG5+b8DrkYEKB
         H+jzblr+WeJEfE65OQNR71+ZBA00IzPh6/HtPQpWE9Gtq5+GnFrqoi97FcSCA7zUic
         quR08CKHvFQbPi7ufwM8FH+cIZP0bkYURj6PMJxf923ddm405lQe1cV1N2ETcZ9FO9
         01HBFZgCQDM+OxOUckIMBn2PAefvuNkUNr4pwtMLORWIhKKt5u4m7WUnqbLYoE4nAP
         4rRNE/A5kGyJTyTevgbtjmvW0nGyJoJGKYN7D3dsMqJaZSWtZYs2te0YZKD/ybrUE/
         FmK0wkOIw6ECw==
Subject: [PATCH 1/2] xfs: skip fscounters comparisons when the scan is
 incomplete
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:05 -0700
Message-ID: <166473480561.1083794.11478098043597895258.stgit@magnolia>
In-Reply-To: <166473480544.1083794.8963547317476704789.stgit@magnolia>
References: <166473480544.1083794.8963547317476704789.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If any part of the per-AG summary counter scan loop aborts without
collecting all of the data we need, the scrubber's observation data will
be invalid.  Set the incomplete flag so that we abort the scrub without
reporting false corruptions.  Document the data dependency here too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/fscounters.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 3c66523ec212..c869b537fe34 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -145,6 +145,18 @@ xchk_setup_fscounters(
 	return xchk_trans_alloc(sc, 0);
 }
 
+/*
+ * Part 1: Collecting filesystem summary counts.  For each AG, we add its
+ * summary counts (total inodes, free inodes, free data blocks) to an incore
+ * copy of the overall filesystem summary counts.
+ *
+ * To avoid false corruption reports in part 2, any failure in this part must
+ * set the INCOMPLETE flag even when a negative errno is returned.  This care
+ * must be taken with certain errno values (i.e. EFSBADCRC, EFSCORRUPTED,
+ * ECANCELED) that are absorbed into a scrub state flag update by
+ * xchk_*_process_error.
+ */
+
 /* Count free space btree blocks manually for pre-lazysbcount filesystems. */
 static int
 xchk_fscount_btreeblks(
@@ -232,8 +244,10 @@ xchk_fscount_aggregate_agcounts(
 	}
 	if (pag)
 		xfs_perag_put(pag);
-	if (error)
+	if (error) {
+		xchk_set_incomplete(sc);
 		return error;
+	}
 
 	/*
 	 * The global incore space reservation is taken from the incore
@@ -274,6 +288,11 @@ xchk_fscount_aggregate_agcounts(
 	return 0;
 }
 
+/*
+ * Part 2: Comparing filesystem summary counters.  All we have to do here is
+ * sum the percpu counters and compare them to what we've observed.
+ */
+
 /*
  * Is the @counter reasonably close to the @expected value?
  *

