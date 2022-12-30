Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8AFBC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236300AbiLaC7l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbiLaC7i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:59:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E669192B4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:59:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E15E61D11
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01099C433EF;
        Sat, 31 Dec 2022 02:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455577;
        bh=b2VoYFImPIswkR8dHQUMIC4aWyD0T/yjv70S3lu1B80=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tGYbOlXmkjbbTjWNKbT2WycK4GG7igvicEEN4J1nJrTXcO+qDOiNcLM6waCwdayAN
         GZmgW/Ot3YrTzq6tFtUpWBuFLkYWGAxp1G560Q9xzti+I9YejoNIqqzZ2Ys+j98I33
         tvZBBPDeTWET0KG6yrYFlygYlMsuaXx3HSwF9SvDUmkZ4n3ZwOkhTgQtbhTBqy6SMI
         3fQCyoTROvT1Z50F1PPdUEjRTALaSDVKVGxRlitHHOSrofR0RNE3zcPE592WV0CyTL
         i+gIoQf6agsVnGoVZV4Mxc2xgeeGv9G8TPpGPtmWd2oejA/vZDdigcVzk71CcVPWtm
         /GSzs1XVDiitA==
Subject: [PATCH 21/41] xfs: scrub the realtime refcount btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:10 -0800
Message-ID: <167243881047.734096.938489046333779694.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add code to scrub realtime refcount btrees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 5819576a51a..453b0861225 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -746,9 +746,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_RGSUPER	28	/* realtime superblock */
 #define XFS_SCRUB_TYPE_RGBITMAP	29	/* realtime group bitmap */
 #define XFS_SCRUB_TYPE_RTRMAPBT	30	/* rtgroup reverse mapping btree */
+#define XFS_SCRUB_TYPE_RTREFCBT	31	/* realtime reference count btree */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	31
+#define XFS_SCRUB_TYPE_NR	32
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)

