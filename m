Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D81C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjDFTaE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjDFTaD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:30:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923BD6E94
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:30:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AD9064807
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C08AC433EF;
        Thu,  6 Apr 2023 19:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809401;
        bh=h2cRsgHU4fiUE6MOtB08jMtcJhA1MR+cdxMfuODmhrw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ljGjHxnQ99wP8k1hZzCufKuueTqtirig+xwPG/DKTbi76WLQunSlRI6/TwSTre0PE
         tAwsZ8xxUos4nrbpdQHFvTiuxL3ykTBXgZL8kE8GnBDfAyAUlOzGWPgGPuYss0XKF0
         sNTmC1dd5RcxHafCC8gNkVv8gtIWhKWFUZpcgL0AH6RtUUQS5sLDDzZrAZLr+WQohY
         CwReAdJtmqgFz2zObYqafz+Y2wAZJunvrPBl1HZuLLhHyZVDjBG0LxBTP3kQgYIYni
         wJHc/x4/7y2TkpM4r6OXQXU0HSgaEgtmURZlo35jhCzQGmKIikVoyY4bv5sqLlkiuc
         jsKq1ZJUHb7gA==
Date:   Thu, 06 Apr 2023 12:30:01 -0700
Subject: [PATCH 04/10] xfs: restructure xfs_attr_complete_op a bit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827168.616519.1051996710045283889.stgit@frogsfrogsfrogs>
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

Reduce the indentation in this function by flattening the nested if
statements.  We're going to add more code later to this function later,
hence the early cleanup.  No functional changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 7782f00c1..137ba5e50 100644
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

