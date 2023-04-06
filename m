Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8239C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjDFTfi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237261AbjDFTfe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:35:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18BF901C
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:35:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C01F64B89
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A991AC433D2;
        Thu,  6 Apr 2023 19:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809728;
        bh=s47meeJ4xP2+OZk0nbyc/W2qYGh1jl4HGDevpUSHD2I=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=bNlszqHledIM9AefndIz9xYX6P12B0XLuccAga3SAogaU4pWJtDuL6oOj+SECHEoC
         HJMEoJaScxnqCO2dui+7mA/yfw2ruLL5K6vbsVTpkvXLMa4sJ2nDTLL6hfkasGIiJ+
         50zYQyQQcgmzwnJ39CQlIWarsAStT0058a7YEktyCkriKm2A/phhc2Nc9WpF7aAFyE
         Ws/hFFKv/sjNj5JFpY7YVDQjaKJvDpO+YXaSyd90JxcZ6wVpMOpGHm49RUoqBiFKEZ
         FlWZivxfhN10hAZt+gmywZnKSwxw7ducsV6SvIxo7ZJsK8wmixoH9L5mXWOP0neecQ
         +vVKv9WowfLHQ==
Date:   Thu, 06 Apr 2023 12:35:28 -0700
Subject: [PATCH 15/32] xfs: drop compatibility minimum log size computations
 for reflink
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827754.616793.10713015735486315248.stgit@frogsfrogsfrogs>
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

Having established that we can reduce the minimum log size computation
for filesystems with parent pointers or any newer feature, we should
also drop the compat minlogsize code that we added when we reduced the
transaction reservation size for rmap and reflink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_log_rlimit.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/libxfs/xfs_log_rlimit.c b/libxfs/xfs_log_rlimit.c
index 6ecb9ad51..59605f0dc 100644
--- a/libxfs/xfs_log_rlimit.c
+++ b/libxfs/xfs_log_rlimit.c
@@ -91,6 +91,16 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 {
 	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
 
+	/*
+	 * Starting with the parent pointer feature, every new fs feature
+	 * drops the oversized minimum log size computation introduced by the
+	 * original reflink code.
+	 */
+	if (xfs_has_parent_or_newer_feature(mp)) {
+		xfs_trans_resv_calc(mp, resv);
+		return;
+	}
+
 	/*
 	 * In the early days of rmap+reflink, we always set the rmap maxlevels
 	 * to 9 even if the AG was small enough that it would never grow to

