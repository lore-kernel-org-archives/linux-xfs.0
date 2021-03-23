Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA3B5C433EC
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEED2619B8
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhCWEVG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:21:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229666AbhCWEU4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 00:20:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 013BE6198E;
        Tue, 23 Mar 2021 04:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616473256;
        bh=yUB8d38HfpbDCRPHNKnnorSrkrAJTVvygBH4h4lHOZY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cngs+7G5TBY6AZ/UnqUDjzKGCj376lsUVBYJuiqZzMVhsUBMIJtxHoE5UjAQeNSeX
         eAxoA4X/LQbPCoN3+D1AUKA03ujoCFDcSBltLMgsYAswYnq0g12VrXEWeZ+zeBgnDC
         wfpRslDW4hR3xGmkxAjiyThkK5b7niCIgYqxOD4NzKOdVUlxdUB4UOPeTg5OHvhK0u
         WnJlYNjk4BtG8lFBR5UtWcxxzrb0BdKaKSQdys3DNUiDLtELFYNErg8Gd73ItiRZfI
         PVxdqrAdTE2/yw+lSs5h/ocoVE+LRIbhpg2LvQaOtCl2NU6TDCx9Su72XxDf+ZbCFX
         Hdafjkv/TA6YA==
Subject: [PATCH 2/3] xfs/122: embiggen struct xfs_agi size for inobtcount
 feature
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 22 Mar 2021 21:20:55 -0700
Message-ID: <161647325568.3431131.12651460689158775079.stgit@magnolia>
In-Reply-To: <161647324459.3431131.16341235245632737552.stgit@magnolia>
References: <161647324459.3431131.16341235245632737552.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make the expected AGI size larger for the inobtcount feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 tests/xfs/122.out |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index cfe09c6d..b0773756 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -113,7 +113,7 @@ sizeof(struct xfs_scrub_metadata) = 64
 sizeof(struct xfs_unmount_log_format) = 8
 sizeof(xfs_agf_t) = 224
 sizeof(xfs_agfl_t) = 36
-sizeof(xfs_agi_t) = 336
+sizeof(xfs_agi_t) = 344
 sizeof(xfs_alloc_key_t) = 8
 sizeof(xfs_alloc_rec_incore_t) = 8
 sizeof(xfs_alloc_rec_t) = 8

