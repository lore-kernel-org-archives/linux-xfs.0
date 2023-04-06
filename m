Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B66C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240103AbjDFTZz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjDFTZz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:25:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D2B65B6
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:25:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E144963D38
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F628C433EF;
        Thu,  6 Apr 2023 19:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809152;
        bh=8VPQKMFoc+cxsGYakxUHlLz/psc13YLtgg059UQ2xvQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=bwJgHPl2Z8RKaYRHNJXsviXJ3QQfyf9wB7eomvCSGJ2GWewkA6ljOeC+Xb8ypIHE3
         IxozW679gu6kf0NS1hfPzgiCVbFShW2Vvnye3cAplOJgvr8xwcdpvXgWg4UOkwmX1G
         dFEzSuwKlIe65sp2EtvRTTBNC8VIVklNDqXdegTD5wgtMiworInXgnLlcKXoRYlnKT
         rV7GsmRcwLXQW1P7RPWLlOPXwDKBvFPBTEGdtsI8M+Cs9UB9aVdACuYZ9IcD0v/I7h
         bUBP4jsNc8CNeHMzyhij4mq9dTL8z4QM8Th2iOgMgpPUwmIeYjYCEVIR2b6qO4yXUn
         fx8yIcJ+v3Huw==
Date:   Thu, 06 Apr 2023 12:25:51 -0700
Subject: [PATCH 21/23] xfs: drop compatibility minimum log size computations
 for reflink
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080824956.615225.5157032097692302846.stgit@frogsfrogsfrogs>
In-Reply-To: <168080824634.615225.17234363585853846885.stgit@frogsfrogsfrogs>
References: <168080824634.615225.17234363585853846885.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_log_rlimit.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index e5c606fb7a6a..74821c7fd0cc 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
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

