Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB987C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbjDFTax (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236270AbjDFTav (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:30:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F669004
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:30:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6DD764BA5
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EB1C433EF;
        Thu,  6 Apr 2023 19:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809448;
        bh=vRClyRSsT11H+C7M9adEzUyAb8ceiG7dlPs99jNTiLw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=SnU8yAlXg+LQ7JQRKECcAbZG6zMlFDag2yR9MsUui48ANnAvRbXDH1an0OlfSUJBs
         qRGma1MBLiBxPNGid22SompnxPGbvxGZVW/hlMlxDFBJ6LXSbqkbltCer10tBAaueJ
         e1WPkeVgwTpT7KPDLvx+cF5mk47iwvJZ1DYP46dioWpDej06iKN2AHpzj0zqqyMJ3m
         /ELvdCTpsMs43grDqDgY8Lt2uIxYCyn4aL7/DOn/I1/Pw6qb06SkJ8iAhV2Et/nSs/
         l0gQdtE3bDgGRJOV4ix/hLdoIldlqsqtH+/pYr3wy8r+fOiEmer0VrBo63/r/xmoRD
         Fnn9fFqvx+VaQ==
Date:   Thu, 06 Apr 2023 12:30:47 -0700
Subject: [PATCH 07/10] xfs: log NVLOOKUP xattr setting operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827207.616519.9220542881940587774.stgit@frogsfrogsfrogs>
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

If high level code wants to do a deferred xattr set operation with the
NVLOOKUP flag set, we need to push this through the log.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c       |    6 +++++-
 libxfs/xfs_log_format.h |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 9621f8715..a8c778bbd 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -901,9 +901,13 @@ xfs_attr_defer_add(
 	struct xfs_da_args	*args)
 {
 	struct xfs_attr_intent	*new;
+	int			op_flag = XFS_ATTRI_OP_FLAGS_SET;
 	int			error = 0;
 
-	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_SET, &new);
+	if (args->op_flags & XFS_DA_OP_NVLOOKUP)
+		op_flag = XFS_ATTRI_OP_FLAGS_NVSET;
+
+	error = xfs_attr_intent_init(args, op_flag, &new);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index ecf0ac32d..7a4226e20 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -958,6 +958,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
 #define XFS_ATTRI_OP_FLAGS_NVREMOVE	4	/* Remove attr w/ vlookup */
+#define XFS_ATTRI_OP_FLAGS_NVSET	5	/* Set attr with w/ vlookup */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*

