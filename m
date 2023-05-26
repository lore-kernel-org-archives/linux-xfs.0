Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA06EC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjEZCUV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjEZCUU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4180BB2
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E76264A68
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBAFC433EF;
        Fri, 26 May 2023 02:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067617;
        bh=QmAnVbYJvYX3jHeum40MbtLhQYAdbwJkSiOwr89dq0I=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=IX1eYOxrZgOzpFjUfWPqQl7YdY77gJ3DX9K08txs1yFHYOJjBdp12+1JgBg+OBTBv
         NuU09P8EIYUNCpfca7gjWCWxeEyzJRC3/SZQQqpmQuNfNXO/qx7T0Q3nU/rVbv1+rt
         jhVGJ0NKr80dG3SffO3pi9iy7WpP6ZFWqdRds94Wha1S9aofjZtpNLVTznFnLaudq9
         Gq22TwrySPdZuwrStWc2oyYS9zi2DRuKVLxACX8gNMCFvL8jZ1NSkbkbTz51M/1CeQ
         XzCUK6yfhOZQHbIJ7nEqvC+O+SsAjSss0pk1O2tODxnbjN2QrH20PQonrr3OwhnTwA
         1A5zJOsKWeh/g==
Date:   Thu, 25 May 2023 19:20:17 -0700
Subject: [PATCH 04/10] xfs: restructure xfs_attr_complete_op a bit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506077489.3749126.7311222685035659749.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077431.3749126.3177791326683307311.stgit@frogsfrogsfrogs>
References: <168506077431.3749126.3177791326683307311.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_attr.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index a4227f6379d..4a2c48d050d 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -419,11 +419,11 @@ xfs_attr_complete_op(
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

