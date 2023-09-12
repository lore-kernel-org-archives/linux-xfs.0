Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57890EE3F0C
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 19:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237625AbjILTkJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 15:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236057AbjILTkJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 15:40:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BAC1B2
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 12:40:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29C2C433C7;
        Tue, 12 Sep 2023 19:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694547605;
        bh=LRLqK2zFlof5NQGwsXKWobxAZLOFtR/zIYGAKFl8x8k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=by24WXwgu3+t+xSd5lZoBPac98qfHgYJF4JysiWcl1N/pkXsAwwKDj0/bHcS6QIkp
         U0b2jQGsOYOjqKts+5OTpqxW/B25N09YzGB0/iYfIHgryJNSUmVyXTfkDshd0gxr3M
         gpQ39yOGLGUKrRlR3wAQ5porl+dQED9JMEncgRGI6jqY8pPAfTwL8YZWHE0o12Kikt
         kM47Pb1oZYi1uzH8kKu8GOnGTRskMczeQ2pSjrGV9/w0+BiLBKfs5N9KZP03gqVtjh
         FMCZJ4o1Z2A2o9RIgahjohFZNYYmTf7ZFI84vUqGusLIDC3VAyPbsQ30IJ2kq/Yu7D
         SHU+rU57zbmaQ==
Subject: [PATCH 5/6] xfs_repair: set aformat and anextents correctly when
 clearing the attr fork
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 12 Sep 2023 12:40:04 -0700
Message-ID: <169454760445.3539425.1849980383287926875.stgit@frogsfrogsfrogs>
In-Reply-To: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
References: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Ever since commit b42db0860e130 ("xfs: enhance dinode verifier"), we've
required that inodes with zero di_forkoff must also have di_aformat ==
EXTENTS and di_naextents == 0.  clear_dinode_attr actually does this,
but then both callers inexplicably set di_format = LOCAL.  That in turn
causes a verifier failure the next time the xattrs of that file are
read by the kernel.  Get rid of the bogus field write.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |    2 --
 1 file changed, 2 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index e534a01b500..c10dd1fa322 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2078,7 +2078,6 @@ process_inode_attr_fork(
 		if (!no_modify)  {
 			do_warn(_(", clearing attr fork\n"));
 			*dirty += clear_dinode_attr(mp, dino, lino);
-			dino->di_aformat = XFS_DINODE_FMT_LOCAL;
 			ASSERT(*dirty > 0);
 		} else  {
 			do_warn(_(", would clear attr fork\n"));
@@ -2135,7 +2134,6 @@ process_inode_attr_fork(
 			/* clear attributes if not done already */
 			if (!no_modify)  {
 				*dirty += clear_dinode_attr(mp, dino, lino);
-				dino->di_aformat = XFS_DINODE_FMT_LOCAL;
 			} else  {
 				do_warn(_("would clear attr fork\n"));
 			}

