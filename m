Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E382C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:56:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjBPU4l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjBPU4k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:56:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF804D606
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:56:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 584F160C20
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20B5C433D2;
        Thu, 16 Feb 2023 20:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580998;
        bh=qfyM6y5bq45+QteprUZIwQskwprkqtd8M0Tj7SFLDds=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=QyH7+P5RBDwNiHQqNjmL8EXPT+eW7s0ybmemi8n88VYV0JzgquCh6bUy1ocXyMDom
         Wh+tn9gjvAlPLre4hf5SUSyKCWuQmpU9PYdDvgC7XCpjT+f4zkaAAUlL25IkCjlb9l
         zztec5kyFu63OPE2oVyxDxre1mpdJWjWaeLLoRJ01rwa89bXnh7VthFInNNUy5olRw
         12ealfD4yXbUmexaVfx2cyoUR6ouJLH7VgJ+u4+DXEzKat0ZlPPlgHPfEKQ7Qa0s5D
         w7fpeDgAzc/xHT9QPDEGN4ObytkoOUhoyoZHc9EBMMEg/OKutvbJZz/0dkBvhuSsHl
         6aRbksIcTDgiA==
Date:   Thu, 16 Feb 2023 12:56:38 -0800
Subject: [PATCH 12/25] xfsprogs: add parent attributes to link
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879065.3476112.7980816751548942388.stgit@magnolia>
In-Reply-To: <167657878885.3476112.11949206434283274332.stgit@magnolia>
References: <167657878885.3476112.11949206434283274332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_link to add a parent pointer to the inode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_trans_space.h |    2 --
 1 file changed, 2 deletions(-)


diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index 87b31c69..f7220792 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
@@ -84,8 +84,6 @@
 	(2 * (mp)->m_alloc_maxlevels)
 #define	XFS_GROWFSRT_SPACE_RES(mp,b)	\
 	((b) + XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK))
-#define	XFS_LINK_SPACE_RES(mp,nl)	\
-	XFS_DIRENTER_SPACE_RES(mp,nl)
 #define	XFS_MKDIR_SPACE_RES(mp,nl)	\
 	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
 #define	XFS_QM_DQALLOC_SPACE_RES(mp)	\

