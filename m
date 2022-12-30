Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8232C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbiLaATR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235908AbiLaATQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:19:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3629417597
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:19:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E089FB81E6F
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B05C433EF;
        Sat, 31 Dec 2022 00:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445953;
        bh=7QEkY49yIZAW+aXxErTpQNVjZJgoeRKw1/lxFrHi/dk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=E5HQ3YJkD8zUc6dlLgEpo1aYebHGh6iUjP2V0iiY7gXpNakrnMGHv0O4khcdE1bHH
         Rb8EJ+cFS7RfV9PSdfpTTWVn725e/KmUoX6hJ1Xa0nd0tqdG9GoCBeGpI/xTYg+Ilp
         eAqGuDp22KwfXbRXBD9WHpgwHrN3xvlnI4nN+NYfhjLGzHlaIxt8UkTvjXNYSk7ftP
         rrxNy162y5UYEma87bYyV8d7xu6FfqbSkBb/TSCg1M09sFMHu8e58OPvaV/+2IaA32
         Cu73/TT5SAW4EIX9fxr5eP0I2NGdFOWtF6KWu0oVDyQQg40oMlL8RJRmjqEbLTUOGP
         TRUQYyYE1fNGA==
Subject: [PATCH 02/19] xfs: parameterize all the incompat log feature helpers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:59 -0800
Message-ID: <167243867965.713817.13467276025796120784.stgit@magnolia>
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

We're about to define a new XFS_SB_FEAT_INCOMPAT_LOG_ bit, which means
that callers will soon require the ability to toggle on and off
different log incompat feature bits.  Parameterize the
xlog_{use,drop}_incompat_feat and xfs_sb_remove_incompat_log_features
functions so that callers can specify which feature they're trying to
use and so that we can clear individual log incompat bits as needed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_format.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 5ba2dae7aa2..817adb36cb1 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -404,9 +404,10 @@ xfs_sb_has_incompat_log_feature(
 
 static inline void
 xfs_sb_remove_incompat_log_features(
-	struct xfs_sb	*sbp)
+	struct xfs_sb	*sbp,
+	uint32_t	feature)
 {
-	sbp->sb_features_log_incompat &= ~XFS_SB_FEAT_INCOMPAT_LOG_ALL;
+	sbp->sb_features_log_incompat &= ~feature;
 }
 
 static inline void

