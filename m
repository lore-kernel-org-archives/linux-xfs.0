Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02AAAC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjEZCQ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjEZCQ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:16:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620EAF7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:16:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3FE36122B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7ADC4339B;
        Fri, 26 May 2023 02:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067415;
        bh=txMVw3rTM5bZCQh6XyjkLVjZdxHjYUR+RI/9z1XIQ3E=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=SR4OM+pzsVoNdYTU1UGJAWm8jOr6zLI6D+0mZzUM3gORA8vpCLPRVT5mx3Ldm2Y6x
         FdWds27AgUEZLemWUGODVzs25DO1KtSYoMHiq2LLj3lTu2TEd+xqVnPoffjvpPvGQ8
         nlCEs1Yn6taLGTJmiZY5WjYcnIW7gdk3kQsqMWMJLV1nqks5dLakvRuCNNgPZ4oEz7
         cFiaYio/hRXlrQvLfPI89i1Jegzuyw+JCNRukPwmiDEvnHEyPWxzP1RMnfRa14VFnU
         GhcJe0D4IV6CHByZeHLkdiSiqOCEzvmtH0SCumHLUejdtCkpy2LcvRLvi3jWsZjNeN
         h63U0HQUrCuxg==
Date:   Thu, 25 May 2023 19:16:54 -0700
Subject: [PATCH 09/17] xfs: replace namebuf with parent pointer in directory
 repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506073425.3745075.8429021580807757967.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
References: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Replace the dirent name buffer at the end of struct xrep_dir with a
xfs_parent_name_irec object.  The namebuf and p_name usage do not
overlap, so we can save 256 bytes of memory by allowing them to overlap.
Doing so makes the code a bit more complex, so this is called out
separately.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir_repair.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index c44da2f46b76..450c9b38e085 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -28,6 +28,7 @@
 #include "xfs_swapext.h"
 #include "xfs_xchgrange.h"
 #include "xfs_ag.h"
+#include "xfs_parent.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -131,8 +132,14 @@ struct xrep_dir {
 	/* Should we move this directory to the orphanage? */
 	bool			move_orphanage;
 
-	/* Directory entry name, plus the trailing null. */
-	unsigned char		namebuf[MAXNAMELEN];
+	/*
+	 * Scratch buffer for reading parent pointers from child files.  The
+	 * p_name field is used to flush stashed dirents into the temporary
+	 * directory in between parent pointers.  At the very end of the
+	 * repair, it can also be used to compute the lost+found filename
+	 * if we need to reparent the directory.
+	 */
+	struct xfs_parent_name_irec pptr;
 };
 
 /* Tear down all the incore stuff we created. */
@@ -694,7 +701,7 @@ xrep_dir_replay_update(
 	struct xfs_name			name = {
 		.len			= dirent->namelen,
 		.type			= dirent->ftype,
-		.name			= rd->namebuf,
+		.name			= rd->pptr.p_name,
 	};
 	struct xfs_mount		*mp = rd->sc->mp;
 	xfs_ino_t			ino;
@@ -769,10 +776,10 @@ xrep_dir_replay_updates(
 
 		/* The dirent name is stored in the in-core buffer. */
 		error = xfblob_load(rd->dir_names, dirent.name_cookie,
-				rd->namebuf, dirent.namelen);
+				rd->pptr.p_name, dirent.namelen);
 		if (error)
 			return error;
-		rd->namebuf[MAXNAMELEN - 1] = 0;
+		rd->pptr.p_name[MAXNAMELEN - 1] = 0;
 
 		error = xrep_dir_replay_update(rd, &dirent);
 		if (error)
@@ -1406,7 +1413,7 @@ xrep_dir_move_to_orphanage(
 	if (error)
 		goto err_adoption;
 
-	error = xrep_adoption_compute_name(&rd->adoption, rd->namebuf);
+	error = xrep_adoption_compute_name(&rd->adoption, rd->pptr.p_name);
 	if (error)
 		goto err_adoption;
 

