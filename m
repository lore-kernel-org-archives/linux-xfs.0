Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 648CAC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbjEZC3K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjEZC3J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:29:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC06A9B
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:29:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C40A64C27
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD646C4339B;
        Fri, 26 May 2023 02:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685068147;
        bh=lwkarbGOdDEX/E16amenOkw3MgR6dA2IlSNgfWpfGFg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=fp4zevTesmy+sxZZ0EfAftg6QuY40hwBMJjLeSeTVxHX9Fby0hI+ewCaNTRR+zkYx
         sH/sstoNajYUoddQ3nf9CMaxp1uwJa2wztQpjO4mI1bgTP/9CKXVSWH+SAEXu2UIQv
         IuS0kUQzGvTVGXUQDWOC5W+NnlKZWyguEJ9IbV2O5j3TgdAfx6oSoaDusva8uunriw
         n9H2hfDL9qI25DJBX3fw9fIIubSxnXfp4QL1LEHM0iBUoLeP7eZKDp2g6dtgfYq6TH
         FJ+STl2TefhvwQSX5Svg47CdsNQuLXbfngCSwijMoJHwvaBThkenzLnpsdNuE7VlDD
         Cj+KACh8fLVQg==
Date:   Thu, 25 May 2023 19:29:07 -0700
Subject: [PATCH 28/30] xfsprogs: Fix default superblock attr bits
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078268.3749421.1971130920300572465.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
References: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Recent parent pointer testing discovered that the default attr
configuration has XFS_SB_VERSION2_ATTR2BIT enabled but
XFS_SB_VERSION_ATTRBIT disabled.  This is incorrect since
XFS_SB_VERSION2_ATTR2BIT describes the format of the attr where
as XFS_SB_VERSION_ATTRBIT enables or disables attrs.  Fix this
by enableing XFS_SB_VERSION_ATTRBIT for either attr version 1 or 2

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 19868eff9db..89b1f2c27a6 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3468,7 +3468,7 @@ sb_set_features(
 		sbp->sb_versionnum |= XFS_SB_VERSION_DALIGNBIT;
 	if (fp->log_version == 2)
 		sbp->sb_versionnum |= XFS_SB_VERSION_LOGV2BIT;
-	if (fp->attr_version == 1)
+	if (fp->attr_version >= 1)
 		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
 	if (fp->nci)
 		sbp->sb_versionnum |= XFS_SB_VERSION_BORGBIT;

