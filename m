Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31834C7EE2E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbjEZCSA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjEZCR7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:17:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC775B2
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:17:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50D3B64768
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05C3C4339B;
        Fri, 26 May 2023 02:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067477;
        bh=qwnVCCZ8PfKIcqnjTZRp6nmkh+HSSLPe76IwbPtDywQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=dy2SDyyZOQzB5ejx2F7SG7EZ/dNx8/DFwb9wFDVqBUko1E0PnyLiySpsSM3T1Ba6a
         czyUT1h+pXtVrfarparHg8oC3GzMj7Yk5ucAhckA1kdLXBQGvIElQLm/bB0enuaYgg
         LwL6nzT5a8+WpZdPNJqyFfzVIUBDhV+ySUeFRnK7eQfEARqi1UJSlNX9PQeYBGWMop
         GNfyEyPNvy4D9erRpTfwK/290ATEEI3iD58h8TiiZrziIFagZ3cGt4efm9YyHVZEm8
         0eTf3ehjV8I/bcaStZheaS7LMjIMQA6KJzXUYJ0WfWVAKMwrqrwlIwgYLf8b6zOyVb
         Coz90xSF7YBig==
Date:   Thu, 25 May 2023 19:17:57 -0700
Subject: [PATCH 13/17] xfs: replace namebuf with parent pointer in parent
 pointer repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506073481.3745075.16880906423617126770.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
References: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Replace the dirent name buffer at the end of struct xrep_parent with a
xfs_parent_name_irec object.  The namebuf and p_name usage do not
overlap, so we can save 256 bytes of memory by allowing them to overlap.
Doing so makes the code a bit more complex, so this is called out
separately.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/parent_repair.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index b57ba7559361..ff73b6c5b77f 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -24,6 +24,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_health.h"
 #include "xfs_swapext.h"
+#include "xfs_parent.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -63,8 +64,12 @@ struct xrep_parent {
 	/* Orphanage reparenting request. */
 	struct xrep_adoption	adoption;
 
-	/* Directory entry name, plus the trailing null. */
-	unsigned char		namebuf[MAXNAMELEN];
+	/*
+	 * Scratch buffer for scanning dirents to create pptr xattrs.  At the
+	 * very end of the repair, it can also be used to compute the
+	 * lost+found filename if we need to reparent the file.
+	 */
+	struct xfs_parent_name_irec pptr;
 };
 
 /* Tear down all the incore stuff we created. */
@@ -234,7 +239,7 @@ xrep_parent_move_to_orphanage(
 	if (error)
 		goto err_adoption;
 
-	error = xrep_adoption_compute_name(&rp->adoption, rp->namebuf);
+	error = xrep_adoption_compute_name(&rp->adoption, rp->pptr.p_name);
 	if (error)
 		goto err_adoption;
 

