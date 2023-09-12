Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D47FEE3F10
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 19:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbjILTj6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 15:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbjILTj5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 15:39:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C2A115
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 12:39:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A972C433C8;
        Tue, 12 Sep 2023 19:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694547593;
        bh=Qtrfu9fSGKIgmPAe5Pz4+CvDebXAuTGOX5EQrvmAw24=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=POLtv8IQp80EWw8A1VxclHvPfn3vxkZzumngaJBgJKXn0UnCjf9mpjMXj2TRRt75w
         wh8kzK+6phcsitqd9mBa5zLXqoyQkqHLIpfrmX5IqSH4VwV0ZBYyx09YnNjsSyvMGY
         3lahlj6NeBG6Qp7G0kY0ue6a3tAhVCpngXcY5B85twFmVc7dJm++lCXjNs3vdZa4XE
         6FgVlU8gJI7EpdQFlhyebp4Vmz+mX1zKaXvasN9bqblgjIh+nxPMUVm92IP6NeBZ6G
         wSywL2Vy+HRdHtrgQt7r0dnFl9jEmCAlmucWdJAxJTCZ6JZRWI5xjyuhRIR94TiMHb
         a7CLrIqcb4cuw==
Subject: [PATCH 3/6] libxfs: use XFS_IGET_CREATE when creating new files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 12 Sep 2023 12:39:52 -0700
Message-ID: <169454759296.3539425.5228393276062246709.stgit@frogsfrogsfrogs>
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

Use this flag to check that newly allocated inodes are, in fact,
unallocated.  This matches the kernel, and prevents userspace programs
from making latent corruptions worse by unintentionally crosslinking
files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index e7d3497ec96..8f79b0cd17b 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -260,7 +260,7 @@ libxfs_init_new_inode(
 	unsigned int		flags;
 	int			error;
 
-	error = libxfs_iget(tp->t_mountp, tp, ino, 0, &ip);
+	error = libxfs_iget(tp->t_mountp, tp, ino, XFS_IGET_CREATE, &ip);
 	if (error != 0)
 		return error;
 	ASSERT(ip != NULL);

