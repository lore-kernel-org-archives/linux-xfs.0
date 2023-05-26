Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD6E4C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjEZCZS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234501AbjEZCZQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:25:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F7913D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:25:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A176A64C3C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14407C433D2;
        Fri, 26 May 2023 02:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067914;
        bh=Kd928IKNpr/KPVwjCp9YvkUq95ykWdj/vAIRzlzbgLU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=V6/pWSzxUctF0XGcctGCNvsrMK3hTJ3RPXvAnDBvyQ66upi3qjNV08lE6y5Zm8E8Z
         7BDDNeSuPRbYxZtkFuEwbBpEpIqhq+dIBdK8iHKGhLhY+EJlSU7RLmdG96tgYazSYJ
         yBuLIZsQZ1rxDM42hxpXll42UCnl/7b4BtV2iAMJFvZJ0Dl+DXNTDy+YY768bodpNd
         p9/I3S9itAcj2f5hU7Jhpf7PdpCllnUoDTtwRlL3Ln3mtiT0hJYRfFFfhCIGBxEw6t
         JPMSLMV+O8x4zqaeGmR+WhpeXzGZ+zs7CbxZ5BFM+yPOow3b9cPTctSRlyO5rYV74+
         h2vO4QifypoKQ==
Date:   Thu, 25 May 2023 19:25:13 -0700
Subject: [PATCH 13/30] xfs: drop compatibility minimum log size computations
 for reflink
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078064.3749421.2036217039904070986.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
References: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_log_rlimit.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/libxfs/xfs_log_rlimit.c b/libxfs/xfs_log_rlimit.c
index 6ecb9ad5111..59605f0dc97 100644
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

