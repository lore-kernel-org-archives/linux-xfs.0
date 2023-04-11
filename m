Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4897CC77B6F
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 17:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjDKRrL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 13:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjDKRrF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 13:47:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E28272A9
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 10:46:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFDA362A37
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 17:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFF8C433D2;
        Tue, 11 Apr 2023 17:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681235205;
        bh=0mEsnp3Jec3KkjTGT2yA26jj/Vslcb2+Fxjt9YYWoCg=;
        h=Date:From:To:Cc:Subject:From;
        b=Q72Xvg4iS07WOxz7SQSZwTdc4sMZWiRJa9OQJ6Of/dAtHJC44ZElOitp/zznHLqsZ
         IC+Utz4wTpyfI02wH7MuQ481cV4odhPf2sWJDTLk/zUzXWWG+VxuCZuxsV/RDpI7cN
         oFLzuv5paW6UzZ9gvpbTj3ZeFecxnJyC7t5oVBiBr1/sAHE6VneYFUdQx+cfBfIL6T
         Y7apGQ28V41HSXd9b9iM7ppc3SHO8vJK4U8Uj2dZ1U+lOG0pkToieuyQUxBFo++rk4
         oFlpxxH6mnSgdXgVodcEzpEzzSQ9jYpvBGsayTMYpNpBdUl5EII+5dUJRxht3RK5R6
         pHeYtuTRG1icA==
Date:   Tue, 11 Apr 2023 10:46:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs_db: fix inverted logic in error path
Message-ID: <20230411174644.GI360889@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

smatch complains proceeding into the if body if leaf is a null pointer.
This is backwards, so correct that.

check.c:3455 process_leaf_node_dir_v2_int() warn: variable dereferenced before check 'leaf'

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db/check.c b/db/check.c
index 964756d0..d5f3d225 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3452,7 +3452,7 @@ process_leaf_node_dir_v2_int(
 				 id->ino, dabno, stale,
 				 be16_to_cpu(leaf3->hdr.stale));
 		error++;
-	} else if (!leaf && stale != be16_to_cpu(leaf->hdr.stale)) {
+	} else if (leaf && stale != be16_to_cpu(leaf->hdr.stale)) {
 		if (!sflag || v)
 			dbprintf(_("dir %lld block %d stale mismatch "
 				 "%d/%d\n"),
