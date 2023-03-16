Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DEC1C6FD19
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjCPTXB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjCPTXA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:23:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E41BCFE2
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:22:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F126620C9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCABC433EF;
        Thu, 16 Mar 2023 19:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994567;
        bh=P/2Dr4jU4U0gFwv0Q8y1QSNrbmQONrKwU/LjtDqK56A=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=MeHOGwP6zJedoLnf1aPje1Lsnr/3tEpBAnJvOEmpVPkj4JkJrvS0EGuLYXuCC9rCX
         iDES1QD5aDbXbtdF+xl4Zd3eG38OblbJziXZ8PvKb5chJMHsCJhgyUhoDb8kboJvdL
         TLEvcorLrhJuUh3JVq3WBlHzyVJbgSiXD6GYh56vKTNAyxD15XwONYWgZDpKmHx+KO
         fCLI0Lwi9nKBUR1g1R9eX9oU2pvORa4dZX7dE8dvnhbog0krnQyTAEvqtNdP4IjXfD
         /ugatgKsBUU+faf+Wel+k6FRBlL6qwca8c5gFtde/v2Iu6lrNRd3q4iObbTllCOfb9
         CyP+fMxFzJPAQ==
Date:   Thu, 16 Mar 2023 12:22:47 -0700
Subject: [PATCH 05/17] xfs: restructure xfs_attr_complete_op a bit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899414427.15363.5872297549117711319.stgit@frogsfrogsfrogs>
In-Reply-To: <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
References: <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_attr.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 86672061c99e..996ef24482e1 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -422,17 +422,17 @@ xfs_attr_complete_op(
 	bool			do_replace = args->op_flags & XFS_DA_OP_REPLACE;
 
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
-	if (do_replace) {
-		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
-		if (args->new_namelen > 0) {
-			args->name = args->new_name;
-			args->namelen = args->new_namelen;
-			args->hashval = xfs_da_hashname(args->name,
-							args->namelen);
-		}
+	if (!do_replace)
+		return XFS_DAS_DONE;
+
+	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	if (args->new_namelen == 0)
 		return replace_state;
-	}
-	return XFS_DAS_DONE;
+
+	args->name = args->new_name;
+	args->namelen = args->new_namelen;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return replace_state;
 }
 
 static int

