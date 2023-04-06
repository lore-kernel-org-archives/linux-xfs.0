Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2A7FC76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236627AbjDFTdc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236500AbjDFTd0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:33:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A03E72
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:33:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C337264902
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28673C433D2;
        Thu,  6 Apr 2023 19:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809604;
        bh=QsC+7QAXjp9I1zOzX/qu4XxD0xBCS5dUnYR+Zjby2jI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=VWXRK9RccxWhrhh0JMoNgzk1fDiI2OQupmeb4WNYhOxQubjCAQ2nUld03F6q0CANF
         xV/iDxO/uNBJgEaapiQxuEd3lgh54X35JapX9a4INoDqmZBlroeNEDS8/1NCkHLynD
         J/67PEluTtSoTopYibSmgKojq61/I82CojXzPU7xq5AmAofjgJSpzXuPsqtoIMe1rX
         zwbHOErfvdi8yPHyT6PMZ1UN19smHyYJSdm5E7KSKF2IjsMhZHFXXjO8Z39KVGe04k
         JpIA22IhwkmcTxjEIa76J7XvuTouf1iahzRDLnl+6wvGFE4CNqRKWd6vQ+xIrpZeqn
         +RNWKNmR7Qb0Q==
Date:   Thu, 06 Apr 2023 12:33:23 -0700
Subject: [PATCH 07/32] xfs: add parent attributes to link
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827650.616793.2845706168484202535.stgit@frogsfrogsfrogs>
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

This patch modifies xfs_link to add a parent pointer to the inode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: minor rebase fixes]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_trans_space.h |    2 --
 1 file changed, 2 deletions(-)


diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index 87b31c69a..f72207923 100644
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

