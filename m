Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25BD6C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234667AbjEZCbA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjEZCa7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:30:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34740199
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:30:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 861C864C57
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F90C433EF;
        Fri, 26 May 2023 02:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685068257;
        bh=Hu2qtOUkJXBwwIEhVs1D/S3kxVKo1LDE0spBg9hqRBw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=DhUiZwSycc9tmX0sff2Kix4gkWoZztm77SsPinjJ4E+pijhgamofW0uDzzw3GYPTL
         QcYsarefPorHYYTTbA431kZhHIJdFj+sPFJRvnowHloP0ueXlux3fRQYY0rOuMH4Oy
         Tzbi2AScDFwXDA9+6QmabJN0COongB2xRXrj/7RLXDRb/E8pfgTTZuajnD8mYA0VhC
         /rqfmyzLrr8Q/nrUDooOttl6QcSpRLudXS51Q7gloTmQmK7agZMGiAoRyX/wJ2GGhn
         X7szTTtl51qo3rrHswT8Md7/6gbmIq8Xa+qFRXuIrygZ0H90mT3j0475TCOxu2L/5C
         J5CbAuOaO8X5g==
Date:   Thu, 25 May 2023 19:30:56 -0700
Subject: [PATCH 05/14] xfs: remove pointless unlocked assertion
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078664.3750196.13932868054799499466.stgit@frogsfrogsfrogs>
In-Reply-To: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
References: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Remove this assertion about the inode not having an attr fork from
xfs_bmap_add_attrfork because the function handles that case just fine.
Weirder still, the function actually /requires/ the caller not to hold
the ILOCK, which means that its accesses are not stabilized.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c |    2 --
 1 file changed, 2 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index cc2159bb8c5..ea764ab2678 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1010,8 +1010,6 @@ xfs_bmap_add_attrfork(
 	int			logflags;	/* logging flags */
 	int			error;		/* error return value */
 
-	ASSERT(xfs_inode_has_attr_fork(ip) == 0);
-
 	mp = ip->i_mount;
 	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 

