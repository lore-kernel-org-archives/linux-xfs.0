Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F36DBC43331
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C394061477
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245653AbhCCDPy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:15:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2360769AbhCBW3i (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Mar 2021 17:29:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A57B64F3B;
        Tue,  2 Mar 2021 22:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614724122;
        bh=FzQo15NTC+T7NcqJ1hM13yI72Xy5AgEtFgTcS7zVafw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K+PRlGzTJ52+h0FEDIaqdg2KKuXdlno+e05ZO65hpySnrdJM7642zysli69Khnv8W
         nsU+TAqCoXL7nw1WJQub86Kd5kB6KA6BrayiZsru6gFPZ25IAxMDvjKVW6uWeP0FXj
         K3PtXgCnuN819XTlZHc6pOEbBIvzcLutzN29QYKlnd9iZAq4o2GauXUG6KHkxMOYTy
         L9lgNwOnVqACWDCVw6ZvuHOEwTF5J+YfytLWiRC8l/YChmF6b7LXLmPc4PdLbeZ8Ds
         US2XI7MUcWpFUBaXnxO7Rgra96U11tRKELacNOtn0a9dKe//F0TYcf+kMwVJgUmP+i
         UMHx77YSEQ/8w==
Subject: [PATCH 1/7] xfs: fix uninitialized variables in xrep_calc_ag_resblks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 02 Mar 2021 14:28:42 -0800
Message-ID: <161472412192.3421582.514508996639938538.stgit@magnolia>
In-Reply-To: <161472411627.3421582.2040330025988154363.stgit@magnolia>
References: <161472411627.3421582.2040330025988154363.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we can't read the AGF header, we never actually set a value for
freelen and usedlen.  These two variables are used to make the worst
case estimate of btree size, so it's safe to set them to the AG size as
a fallback.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/repair.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 25e86c71e7b9..61bc43418a2a 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -207,7 +207,11 @@ xrep_calc_ag_resblks(
 
 	/* Now grab the block counters from the AGF. */
 	error = xfs_alloc_read_agf(mp, NULL, sm->sm_agno, 0, &bp);
-	if (!error) {
+	if (error) {
+		aglen = xfs_ag_block_count(mp, sm->sm_agno);
+		freelen = aglen;
+		usedlen = aglen;
+	} else {
 		struct xfs_agf	*agf = bp->b_addr;
 
 		aglen = be32_to_cpu(agf->agf_length);

