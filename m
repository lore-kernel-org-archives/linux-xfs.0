Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0147CE7A97
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjIYV6s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjIYV6r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:58:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87106112
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 14:58:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D56C433C7;
        Mon, 25 Sep 2023 21:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695679121;
        bh=cfUBVmJYOooVAuCLVrDZZ+eLta9STVP4EGlPohAPMns=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YWJ/UnC/xk1v+paiI0Kg4yrTgZbL/guIqo0ZcP7Nzi8zhNVuPja5jFm24vUbIPVmj
         RRmdeiLgEsvfDSuPzG2ejsa6o6A48TB2WsQCBbQfgEjYOxpALIt1j0jQiA8g2/5KDx
         JEqDLhcLWmNWsMboylKlz26gc/HIX1JZfr6Qa1jjOSSiycoeYOetiiBWQrHMEAjZQA
         c6kolpMubmnZckyOenzt4eNJI9+R6V4PIR1LR5haTLDczNUQ4ZapIS2kj6bREqo+4t
         lqADBlw144xoKUmXJ5kBtAloPnJ4GSmDi+pD2LE4wB8ahyPfgLQ2TflB/JL0E+bb3h
         fzLMf9yL03AvA==
Subject: [PATCH 5/5] Revert "xfs: switch to multigrain timestamps"
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        linux-xfs@vger.kernel.org
Date:   Mon, 25 Sep 2023 14:58:40 -0700
Message-ID: <169567912075.2318286.15932536197253759402.stgit@frogsfrogsfrogs>
In-Reply-To: <169567909240.2318286.10628058261852886648.stgit@frogsfrogsfrogs>
References: <169567909240.2318286.10628058261852886648.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

Source kernel commit: f798accd5987dc2280e0ba9055edf1124af46a5f

This reverts commit e44df2664746aed8b6dd5245eb711a0ce33c5cf5.

Users reported regressions due to enabling multi-grained timestamps
unconditionally. As no clear consensus on a solution has come up and the
discussion has gone back to the drawing board revert the infrastructure
changes for. If it isn't code that's here to stay, make it go away.

Message-ID: <20230920-keine-eile-c9755b5825db@brauner>
Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 libxfs/xfs_trans_inode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index 7a6ecb5db0d..ca8e823762c 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -59,12 +59,12 @@ xfs_trans_ichgtime(
 	ASSERT(tp);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
-	/* If the mtime changes, then ctime must also change */
-	ASSERT(flags & XFS_ICHGTIME_CHG);
+	tv = current_time(inode);
 
-	tv = inode_set_ctime_current(inode);
 	if (flags & XFS_ICHGTIME_MOD)
 		inode->i_mtime = tv;
+	if (flags & XFS_ICHGTIME_CHG)
+		inode_set_ctime_to_ts(inode, tv);
 	if (flags & XFS_ICHGTIME_CREATE)
 		ip->i_crtime = tv;
 }

