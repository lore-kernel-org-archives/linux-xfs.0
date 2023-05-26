Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93376C7EE32
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjEZCII (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjEZCIH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:08:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A300E7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:08:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E978D64C4F
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53894C433EF;
        Fri, 26 May 2023 02:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066885;
        bh=eAvlvzVk3lpUk4bkKTDe0hp6yzmyjtXIufg5qQebGdw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=K8hwQTM58knmBx8LpklU2N45HcdKOUclPAWpgQkXDMDotsJbUmHGIeyyLfGBQrAGf
         LZJJ/4MUBhZ4BV5KmCQIFQ1+URkNwDTmzR4vgodqz1SDtDXwdxUS2A6dPOBXkinhdM
         2o5bcvbrogHzzmtmTr9LDTgU6Yd5nOXBOQExyWniIT4YyxLUwXZNj0PASl05st9uZ1
         aiFXOxHRsbF08/xQwqE39eB6a2nd4i8tulc7Hu90PK/kkOYXmwNjZc2jJXD04TOFSo
         oTuKe7YxiOYwFwKQpbvM3fOY1EBETWg79PnghSQiV4FvJp+BOknMX5qVAl28rFRIEO
         PSfpL6g9hvrIQ==
Date:   Thu, 25 May 2023 19:08:04 -0700
Subject: [PATCH 05/12] xfs: restructure xfs_attr_complete_op a bit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506072253.3743652.8697122643701102076.stgit@frogsfrogsfrogs>
In-Reply-To: <168506072168.3743652.12378764451724622618.stgit@frogsfrogsfrogs>
References: <168506072168.3743652.12378764451724622618.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Reduce the indentation in this function by flattening the nested if
statements.  We're going to add more code later to this function later,
hence the early cleanup.  No functional changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 3c999b145a6a..b7484251a21a 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -421,11 +421,11 @@ xfs_attr_complete_op(
 	bool			do_replace = args->op_flags & XFS_DA_OP_REPLACE;
 
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
-	if (do_replace) {
-		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
-		return replace_state;
-	}
-	return XFS_DAS_DONE;
+	if (!do_replace)
+		return XFS_DAS_DONE;
+
+	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	return replace_state;
 }
 
 static int

