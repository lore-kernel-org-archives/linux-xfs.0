Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9650C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235894AbiLaAVg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235931AbiLaAVf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:21:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE27D104
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:21:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79EC061D18
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD713C433D2;
        Sat, 31 Dec 2022 00:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446093;
        bh=SX8jfga9eXGcnOygYkQKsZhvAoIvCaHh0x/OVvLPuA4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Mndid7w9zkmdEVsjWObtextNKIYMfH9dgpkUYN0vJXtKCTa6ZDiloodFbaDsuoHnX
         PCfOT9Wd0i2nWV4u7OHDGR12MhQx20oOZpRrAwZwZXuu9Qz9SMqLRWf9VRjH3Cm8iH
         zVnfnwmHVLdA6ai7U9C6PqYTwUMuJ12U7ULoIJoIUgVSCjOhmoL8OAZEmfL1Rli9at
         R/WeTbHzww8wCfZXMiSqfEbbZqF4u4xgX4Ns8J/PteETBuW6RgmDPYh33LQRxa7F27
         LqEC379FX3aRaRi+MlHzc42O36iRpQ1gK2x/EEi5XWxHgEkUaLPprHRhaaosJ5Qmdt
         O8E8kJOQAJg/A==
Subject: [PATCH 11/19] xfs: enable atomic swapext feature
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:00 -0800
Message-ID: <167243868083.713817.2641535793607986902.stgit@magnolia>
In-Reply-To: <167243867932.713817.982387501030567647.stgit@magnolia>
References: <167243867932.713817.982387501030567647.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add the atomic swapext feature to the set of features that we will
permit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_format.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index bb8bff48801..0c457905cce 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -393,7 +393,8 @@ xfs_sb_has_incompat_feature(
 #define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed Attributes */
 #define XFS_SB_FEAT_INCOMPAT_LOG_SWAPEXT  (1U << 31)	/* file extent swap */
 #define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
-	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
+		(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS | \
+		 XFS_SB_FEAT_INCOMPAT_LOG_SWAPEXT)
 #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
 static inline bool
 xfs_sb_has_incompat_log_feature(

