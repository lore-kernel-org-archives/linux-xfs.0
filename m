Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E79A6C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiKICHV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiKICHV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:07:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BB0686A5
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:07:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D32FB81CE7
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE64C433D6;
        Wed,  9 Nov 2022 02:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959637;
        bh=YQKjqx+guOrHfKZhgvh8DiZbr2hTYzHhEaHsMVC/42M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fWE+3og3b6duzk+drX99LvTzmMl29e7K7s4MiNB11LO8LG3rDHQ7IANnmZddHe2tZ
         h9bIkrJxHrjobQjTdUXQNF5G1J15B9p/rN7Jf9zGIWjJKW3O8pS88ycUpi83XXJBWY
         m8/KHMt/BoUXQDl4UVEUSBUy43e8JnZAKPYU9ZRyQkXw6bhNDIIZER9c8sWlJ3M/PZ
         7ZH0ypCZN0T4CLuYPpaOuMDEF1/vklLS5Yj0sQaMsAxKqtHlsjLVTdT6wobSeZS+3n
         bUIWj75NJsL5Pb+uJFpw5bQEDbFf+YPG2vGxt9XVNN/7Bc/N3YS6HUp8zKc5+fcjM0
         UvPnu0JX/BTKA==
Subject: [PATCH 17/24] xfs: refactor domain and refcount checking
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:07:17 -0800
Message-ID: <166795963742.3761583.10209840169462299066.stgit@magnolia>
In-Reply-To: <166795954256.3761583.3551179546135782562.stgit@magnolia>
References: <166795954256.3761583.3551179546135782562.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: ea3d9e89f37160240af1c9f1706d17fea9e20ce9

Create a helper function to ensure that CoW staging extent records have
a single refcount and that shared extent records have more than 1
refcount.  We'll put this to more use in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_refcount.c |    5 +----
 libxfs/xfs_refcount.h |   12 ++++++++++++
 2 files changed, 13 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 7094a27dce..f0fc96da6a 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -141,10 +141,7 @@ xfs_refcount_get_rec(
 	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
 		goto out_bad_rec;
 
-	/* handle special COW-staging domain */
-	if (irec->rc_domain == XFS_REFC_DOMAIN_COW && irec->rc_refcount != 1)
-		goto out_bad_rec;
-	if (irec->rc_domain == XFS_REFC_DOMAIN_SHARED && irec->rc_refcount < 2)
+	if (!xfs_refcount_check_domain(irec))
 		goto out_bad_rec;
 
 	/* check for valid extent range, including overflow */
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 3beb5a30a9..ee32e8eb5a 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -55,6 +55,18 @@ struct xfs_refcount_intent {
 	xfs_fsblock_t				ri_startblock;
 };
 
+/* Check that the refcount is appropriate for the record domain. */
+static inline bool
+xfs_refcount_check_domain(
+	const struct xfs_refcount_irec	*irec)
+{
+	if (irec->rc_domain == XFS_REFC_DOMAIN_COW && irec->rc_refcount != 1)
+		return false;
+	if (irec->rc_domain == XFS_REFC_DOMAIN_SHARED && irec->rc_refcount < 2)
+		return false;
+	return true;
+}
+
 void xfs_refcount_increase_extent(struct xfs_trans *tp,
 		struct xfs_bmbt_irec *irec);
 void xfs_refcount_decrease_extent(struct xfs_trans *tp,

