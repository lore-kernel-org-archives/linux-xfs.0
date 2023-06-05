Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03EC4C77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 15:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbjFEPhA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 11:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234636AbjFEPg6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 11:36:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BC6F1
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 08:36:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64AC36130E
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 15:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0929C433EF;
        Mon,  5 Jun 2023 15:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685979415;
        bh=VDi+DULT9ahOuj6VpBK9uKjU5Xkx6GTcbmuma85AXJ4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=n0pmRZklRTrGqADqP+VGAPXdBBoc5xv4v1XXco+qPsl6B/79U7o3cqn4I1d09ufkO
         gXZt36PFES8gA02phhR9KG9MVh7QQpS7NdKXdc1isuwoYmFLuLa3GGI2vRodHMUa84
         82puK4q4fxEhDupxUHLCPK8FpwVqaKhiis9p3PRfB8bSSrOK48nqZRxFmwdUPEGpKn
         jm8I6gB1QvS5Idoq0gRzmP6w5rkmdrtSqdo2co7NifCGpSOolDred74nAnW9B0LBCT
         10T4EuPEkHaSMPLZSc/8yITAw2dWxmwEB3muq+1BEwIfkIa2/jMBaE+B3nECoLgp7o
         hCm3v4veg2a6g==
Subject: [PATCH 5/5] mkfs: deprecate the ascii-ci feature
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org
Date:   Mon, 05 Jun 2023 08:36:55 -0700
Message-ID: <168597941538.1226098.5474468450992478417.stgit@frogsfrogsfrogs>
In-Reply-To: <168597938725.1226098.18077307069307502725.stgit@frogsfrogsfrogs>
References: <168597938725.1226098.18077307069307502725.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Deprecate this feature, since the feature is broken.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man8/mkfs.xfs.8.in |    1 +
 mkfs/xfs_mkfs.c        |   11 +++++++++++
 2 files changed, 12 insertions(+)


diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 6fc7708bc94..01f9dc6e6e9 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -828,6 +828,7 @@ This transformation roughly corresponds to case insensitivity in ISO
 The transformations are not compatible with other encodings (e.g. UTF8).
 Do not enable this feature unless your entire environment has been coerced
 to ISO 8859-1.
+This feature is deprecated and will be removed in September 2030.
 .IP
 Note: Version 1 directories are not supported.
 .TP
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2f2995e13e3..d3a15cf44e0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2150,6 +2150,17 @@ validate_sb_features(
 	struct mkfs_params	*cfg,
 	struct cli_params	*cli)
 {
+	if (cli->sb_feat.nci) {
+		/*
+		 * The ascii-ci feature is deprecated in the upstream Linux
+		 * kernel.  In September 2025 it will be turned off by default
+		 * in the kernel and in September 2030 support will be removed
+		 * entirely.
+		 */
+		fprintf(stdout,
+_("ascii-ci filesystems are deprecated and will not be supported by future versions.\n"));
+	}
+
 	/*
 	 * Now we have blocks and sector sizes set up, check parameters that are
 	 * no longer optional for CRC enabled filesystems.  Catch them up front

