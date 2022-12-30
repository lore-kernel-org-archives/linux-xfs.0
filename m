Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F93C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236040AbiLaBQX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236035AbiLaBQV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:16:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC87B865
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:16:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D10BB81DF6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7033C433D2;
        Sat, 31 Dec 2022 01:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449378;
        bh=xW11WUq2tVw1T8oZwM7bBpAY25fM2gd5n3kFf3has50=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uuOrTpfDbjfk9smsoWexuKNiDifSJ0XEgem2z4Zc/sV7NWk7DEdOhNpZ9BTqzeBB5
         cbjTDsQwZiAHo6JNRP8Axq073FeWttHJS/F/ScSvku2HSX7jHeKRzU2emW6cItLgAV
         LOX3vywqqXCOMWaoSJIXLCMdYnPLG0O2e5I755peTMexRQKzyBOs9bHM6K25beDtTC
         b42cKe31piY927FbnHQsH/EM6P6yOhLAxTaJVIQjq54VssZfkFCGZ5E0Mx63IskvSX
         zTnHgEuvlha4eBVnZnoM1sZS9SSyjbvGOiMmvIBacc9kjTHYP8bJVGb5IYU/Cvj/LD
         WtNQCnQ12Hekg==
Subject: [PATCH 23/23] xfs: enable metadata directory feature
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:27 -0800
Message-ID: <167243864783.708110.11860044626605131224.stgit@magnolia>
In-Reply-To: <167243864431.708110.1688096566212843499.stgit@magnolia>
References: <167243864431.708110.1688096566212843499.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Enable the metadata directory feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 0bd915bd4eed..33b047f9cf03 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -396,7 +396,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
-		 XFS_SB_FEAT_INCOMPAT_NREXT64)
+		 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
+		 XFS_SB_FEAT_INCOMPAT_METADIR)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool

