Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CE1EC7619A
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 00:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbjDFAKK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 20:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbjDFAKJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 20:10:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817502101
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 17:10:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14BA862B09
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 00:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EACC433D2;
        Thu,  6 Apr 2023 00:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680739807;
        bh=z+OQI62VVQuTwyDk39WJDstdkgKOu7Tc5xUH/O71ZFA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WWOwi9hpqqlr4iHxQsHBdw++bEn41+vVxUABQKG2NCekUOlqHh5LPyHtBIVtB2in8
         mtyRBYcV6s21R4FiidiNlfmGSJiKiyep1SELbUEK5R0ctLGzIDDsvmBovs4OqAinw/
         xp7RW/QlOTvC/0gkJghqzu9ulWbGchX3Vhd641V3+xtfBJ5UxEbUDgtI4Au4lBRmKh
         rZ8586lkapLIVG89VVsBdt3DFcrev7EgIp+EEWFiEDYPdkdfwBnFptFxjn18uKra96
         45fbiAqEnFKxv4Lg67Sl1k59ZehkgpLw6zxGJFs9kJc3q51XHRStJKkbnrNkY6vH49
         LDHr2UDbpKw4g==
Subject: [PATCH 6/6] mkfs: deprecate the ascii-ci feature
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 05 Apr 2023 17:10:07 -0700
Message-ID: <168073980709.1656666.3199846607416694974.stgit@frogsfrogsfrogs>
In-Reply-To: <168073977341.1656666.5994535770114245232.stgit@frogsfrogsfrogs>
References: <168073977341.1656666.5994535770114245232.stgit@frogsfrogsfrogs>
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
---
 man/man8/mkfs.xfs.8.in |    1 +
 mkfs/xfs_mkfs.c        |   11 +++++++++++
 2 files changed, 12 insertions(+)


diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 6fc7708b..01f9dc6e 100644
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
index 6dc0f335..64f17a8f 100644
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

