Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C5E2C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjEZCOJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjEZCOJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:14:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A04194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:14:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B3F064768
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD264C433D2;
        Fri, 26 May 2023 02:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067243;
        bh=v9qrvLMam5wEjartZP7r9F50kO9ofwN20Lc8Yp7Mg64=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=fDgVhv21NmzvAMbIyy5/1fsqha/ZeKHBwKxuKSJ1LaNKdv+qLl0n3Dcc7Y5Wqrl9G
         tmGBE1EIzPUTd6uR30GpgLmLcO8l3yJcCLdXspNNybl4ao/1zJ3HF5zVtBtGCvT+94
         Lx3tKvffQVYF73TV7uviYWCJC5530jkiydIIcvmfz4ZuHXPdTXtKjNsJL5l1eXnjRW
         EB5Y0ldECkA8cBlsZew1HOKY+BGM8s4a4mJl5i2oy4rR1IbYEgvX/txku1ugSedsjt
         pamo3F0ZamZMEHBKy/3XeECU6Qc25tnius3cNNu7lcgGS7f1ftreW0z2YT5EFygnSK
         8fSz0X9k4WHGg==
Date:   Thu, 25 May 2023 19:14:03 -0700
Subject: [PATCH 16/18] xfs: drop compatibility minimum log size computations
 for reflink
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506072929.3744191.15491540792855187890.stgit@frogsfrogsfrogs>
In-Reply-To: <168506072673.3744191.16402822066993932505.stgit@frogsfrogsfrogs>
References: <168506072673.3744191.16402822066993932505.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

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

