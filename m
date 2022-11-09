Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4CD0C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiKICF6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKICF5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:05:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC65560E88
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:05:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CBC9B81CC4
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:05:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3EFC433C1;
        Wed,  9 Nov 2022 02:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959554;
        bh=Uq7zC3UduKSRYqGXbxTf7gG5CUJuPcBgxOlZ9VTpWK4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jhPBaZloAVOllxidVvu/t6jXvXxrbetOTkN3Iyl9Bm0X1FN4CtErJdBdDbDg57PJQ
         3Viu9+V7jcs2e9IS02p6BDVXxBWeO/mSzCeCGJ1dpzVC7n6sIiDvubeZUW2z+XY7ET
         jPr7ZmUNKZfyXCgzEshus0Ty+1559edCC3gL0RHe5P087NYgmnCgxLcVwG6p/1vLxV
         mD0/U7wcyv9v50SlGcsbsbELaW17CUG3HX6HafuSooSIhUXeTvmxUFuVnBkPVx+nY7
         bVygKFOwnjiXOF5n2i65cXhFidHRw86VBGXSXgnexVFErLYAfyGE//3BHLHrJkzC7A
         nc4y1h36CZOOw==
Subject: [PATCH 02/24] xfs: Remove the unneeded result variable
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Zeal Robot <zealci@zte.com.cn>,
        ye xingchen <ye.xingchen@zte.com.cn>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:05:53 -0800
Message-ID: <166795955382.3761583.1638017452653008682.stgit@magnolia>
In-Reply-To: <166795954256.3761583.3551179546135782562.stgit@magnolia>
References: <166795954256.3761583.3551179546135782562.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: ye xingchen <ye.xingchen@zte.com.cn>

Source kernel commit: abda5271f8ec6e9a84ae8129ddc59226c89def7a

Return the value xfs_dir_cilookup_result() directly instead of storing it
in another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_dir2_sf.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)


diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index e97799b96f..08b36c95ce 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -865,7 +865,6 @@ xfs_dir2_sf_lookup(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	int			i;		/* entry index */
-	int			error;
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
 	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
 	enum xfs_dacmp		cmp;		/* comparison result */
@@ -929,8 +928,7 @@ xfs_dir2_sf_lookup(
 	if (!ci_sfep)
 		return -ENOENT;
 	/* otherwise process the CI match as required by the caller */
-	error = xfs_dir_cilookup_result(args, ci_sfep->name, ci_sfep->namelen);
-	return error;
+	return xfs_dir_cilookup_result(args, ci_sfep->name, ci_sfep->namelen);
 }
 
 /*

