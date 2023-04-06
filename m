Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9DC5C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjDFTdn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236525AbjDFTdl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:33:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EC25243
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:33:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AEB764876
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6ACC433EF;
        Thu,  6 Apr 2023 19:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809619;
        bh=zoQF0MRGrDL2xaetCDGYObIdzb+J7m0HWIp+HxALtnM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=FWKix8Xcpk3vD8jlWZkc7GG2DapxTimyKOfOP/Zkq1zJg+AZFhUFbLFt0tbKeU5m3
         CjUh1lLWdp9Edwc3GDBgkj8NCgZpjct7omZrGCkTO9ZzLGyQvNNhaxk63NRIgDeLxL
         EleXhrBN/guIQtuHsR7YZw5B0EUsWxvp+4yKmqa8ZvtB19QEM9Hbq6wqdcGKaHkrvp
         JSPCNbCss3XwO1HWZkvv9T6t7M5i03bbvqYIkJC6IKcQOMm5QuvF4VDRCCHVuOp7L8
         lmIbvZaQn8SkAzxuIxESw3dY/7jNl16Nmd93HygeBDWladdyLrFOc42gH6n7H72CF9
         /LLwl1PSlPX4g==
Date:   Thu, 06 Apr 2023 12:33:39 -0700
Subject: [PATCH 08/32] xfs: add parent attributes to symlink
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827663.616793.2072925585458839551.stgit@frogsfrogsfrogs>
In-Reply-To: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
References: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_symlink to add a parent pointer to the inode.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: minor rebase fixups]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_trans_space.h |    2 --
 1 file changed, 2 deletions(-)


diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index f72207923..25a55650b 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
@@ -95,8 +95,6 @@
 	XFS_DIRREMOVE_SPACE_RES(mp)
 #define	XFS_RENAME_SPACE_RES(mp,nl)	\
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
-#define	XFS_SYMLINK_SPACE_RES(mp,nl,b)	\
-	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
 #define XFS_IFREE_SPACE_RES(mp)		\
 	(xfs_has_finobt(mp) ? M_IGEO(mp)->inobt_maxlevels : 0)
 

