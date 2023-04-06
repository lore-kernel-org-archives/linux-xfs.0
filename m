Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8568DC7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjDFTjZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjDFTjY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:39:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1669F
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:39:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7776E60FA6
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF47EC433D2;
        Thu,  6 Apr 2023 19:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809962;
        bh=MpAWHMDIwTiOZX99OMpmDuNaAR5q4sl6CzNjTnJhJtU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=g67uAuJzRRFb5hfFQUG1C2Ac/mAWl1CsfhTZ7hV4V9KYjLsEYTnBZSjZOWCj9MII2
         5BM2cClrQ5dy7qFHHtra243/1kk8B8YDqR3nNKGY+r+er6mcjdZheMOEfuzfYaWlC1
         LGm8Dq2ezf5LBu52prvzm9ocwVUGRypa3TFbMOTTmQTg7BzJub4IQVFXiG18qMPbmM
         t0a6ym9kvY+mBQudTtaFifvWvmKTtdz1JH2vkEg9y9aRMiqRnjIxDQqTlSjIUinHxp
         ulmQHGrASeF/efh+psPAvFV5ozZQcBisOc4uMzbcLaS3PTgFWh0T+SfJUq0kwprgkH
         EBrUxEmZMGeoA==
Date:   Thu, 06 Apr 2023 12:39:22 -0700
Subject: [PATCH 30/32] xfsprogs: Fix default superblock attr bits
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827952.616793.11727080637758218778.stgit@frogsfrogsfrogs>
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

Recent parent pointer testing discovered that the default attr
configuration has XFS_SB_VERSION2_ATTR2BIT enabled but
XFS_SB_VERSION_ATTRBIT disabled.  This is incorrect since
XFS_SB_VERSION2_ATTR2BIT describes the format of the attr where
as XFS_SB_VERSION_ATTRBIT enables or disables attrs.  Fix this
by enableing XFS_SB_VERSION_ATTRBIT for either attr version 1 or 2

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 4399bf379..f2e683117 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3266,7 +3266,7 @@ sb_set_features(
 		sbp->sb_versionnum |= XFS_SB_VERSION_DALIGNBIT;
 	if (fp->log_version == 2)
 		sbp->sb_versionnum |= XFS_SB_VERSION_LOGV2BIT;
-	if (fp->attr_version == 1)
+	if (fp->attr_version >= 1)
 		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
 	if (fp->nci)
 		sbp->sb_versionnum |= XFS_SB_VERSION_BORGBIT;

