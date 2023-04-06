Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BEC5C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjDFTaT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDFTaS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1934EC3
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A915664B8B
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DF9C433D2;
        Thu,  6 Apr 2023 19:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809417;
        bh=1LBgxXge6Gg1JFkaaBCBDs2oA2cohQtg0RHFKKXAncA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=J4SW71RiqWoXW8dhGHUs9WYP8PfhQR3887cWQ2vCTuwhmzlO5TF6IRwtgPMM2uZso
         0sEKb9QjmQDd22pyF0tvYBMN6KgFZMWnStivmfKzquw19SETIzkI30smp3bVLjZiOw
         ydwW9L0j/gIZjzXb1ZwoTfuYtu7FoycCwt/CcBecKFkDIiBM8BsttfRVTRStoTDx75
         xY38uka9zXSz6gih5K0gDPC2FGWKKv8pGhmFPSEgUZct0KKQCqmijGbvWe3GCxRHb7
         ahdwVkXCYZGzGsa9R2WGTHZjSawYxnS5CLwejNlx0f2Skdax9Cws27RTgWZ8Bu+bxi
         fIw5J24r0LMRg==
Date:   Thu, 06 Apr 2023 12:30:16 -0700
Subject: [PATCH 05/10] xfs: use helpers to extract xattr op from opflags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827181.616519.1699264842688527792.stgit@frogsfrogsfrogs>
In-Reply-To: <168080827114.616519.13224581752144055912.stgit@frogsfrogsfrogs>
References: <168080827114.616519.13224581752144055912.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create helper functions to extract the xattr op from the ondisk xattri
log item and the incore attr intent item.  These will get more use in
the patches that follow.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.h |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 81be9b3e4..f0aa372ec 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -529,6 +529,11 @@ struct xfs_attr_intent {
 	struct xfs_bmbt_irec		xattri_map;
 };
 
+static inline unsigned int
+xfs_attr_intent_op(const struct xfs_attr_intent *attr)
+{
+	return attr->xattri_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+}
 
 /*========================================================================
  * Function prototypes for the kernel.

